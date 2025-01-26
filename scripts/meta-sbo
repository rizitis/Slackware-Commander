import tkinter as tk
from tkinter import ttk
import json
import os
import subprocess
from ttkbootstrap import Style
import re


# Initialize JSON_FILE to None, it will be set when the user selects one of the checkboxes.
JSON_FILE = None

def load_json():
    """
    Load the JSON data from the selected file path and populate the treeview.
    """
    global JSON_FILE  # Use the global JSON_FILE variable

    if not JSON_FILE:
        error_label.config(text="Error: Please select a repository (SBo or Ponce).")
        return

    try:
        if not os.path.exists(JSON_FILE):
            error_label.config(text=f"Error: JSON file does not exist at {JSON_FILE}.")
            return

        if os.stat(JSON_FILE).st_size == 0:
            error_label.config(text=f"Error: JSON file is empty at {JSON_FILE}.")
            return

        with open(JSON_FILE, 'r', encoding='utf-8') as file:
            content = file.read().strip()

            if not content:
                error_label.config(text=f"Error: JSON file contains only whitespace or is empty at {JSON_FILE}.")
                return

            try:
                data = json.loads(content)
            except json.JSONDecodeError as e:
                error_label.config(text=f"Error loading JSON: Invalid format - {e}")
                return

            populate_tree(data)
            error_label.config(text="")  # Clear any error message after successful load
    except Exception as e:
        error_label.config(text=f"Unexpected error: {e}")

def populate_tree(data):
    """
    Populate the treeview widget with the loaded JSON data.
    """
    tree.delete(*tree.get_children())  # Clear any existing items
    locations = {}

    # Loop through the data and populate the treeview
    for package, details in data.items():
        location = details.get("location", "Unknown")

        # Only add the location once at the root level
        if location not in locations:
            locations[location] = tree.insert("", "end", text=f"📁 {location}", open=False)

        package_node = tree.insert(locations[location], "end", text=f"📦 {package}", open=False)

        # Add the package details, but avoid adding the location again
        for key, value in details.items():
            if key != "location":  # Skip location field from being inserted as a subfolder
                if isinstance(value, list):
                    sub_node = tree.insert(package_node, "end", text=f"📂 {key}", open=False)
                    for item in value:
                        tree.insert(sub_node, "end", text=f"📄 {item}", open=False)
                else:
                    tree.insert(package_node, "end", text=f"🔹 {key}: {value}", open=False)

def search_tree(event=None):
    """
    Perform the search and highlight matching items in the treeview.
    """
    search_term = search_entry.get().lower()  # Get the search term in lowercase
    if search_term:
        # Clear previous highlights
        for item in tree.get_children():
            tree.item(item, tags=())  # Remove any existing tags

        # Search for the term in the JSON data and highlight matching items
        for item in tree.get_children():
            search_in_item(item, search_term, None)

        # Force refresh of the treeview
        tree.update_idletasks()  # Refresh the treeview to reflect changes

def search_in_item(item, search_term, parent=None):
    """
    Recursive function to search through the treeview items and highlight the matching ones.
    """
    item_text = tree.item(item, 'text').lower()

    # If the search term is found in the location or package, highlight it in red
    if search_term in item_text:
        tree.item(item, tags="highlight_red")  # Red highlight for parent folder/package
        if parent:
            tree.item(parent, tags="highlight_red")  # Red highlight for parent folder

    # Check if the item has children (subfolders/details)
    for child in tree.get_children(item):
        child_text = tree.item(child, 'text').lower()

        # If the search term is found in the subfolder (e.g., description), highlight it in green
        if search_term in child_text:
            tree.item(child, tags="highlight_green")  # Green highlight for subfolder

        # Recursively search through child nodes
        search_in_item(child, search_term, item)

def copy_selected_item(event=None):
    """
    Copy the selected item text to the clipboard.
    """
    selected_item = tree.selection()  # Get the selected item
    if selected_item:
        selected_text = tree.item(selected_item[0], "text")  # Get the text of the selected item
        root.clipboard_clear()
        root.clipboard_append(selected_text)  # Copy to clipboard
        print(f"Copied: {selected_text}")

def show_right_click_menu(event):
    """
    Display the right-click context menu to copy the selected item.
    """
    item = tree.identify('item', event.x, event.y)
    if item:
        tree.selection_set(item)  # Select the item under the right-click
        right_click_menu.post(event.x_root, event.y_root)

def on_right_click(event):
    """
    This method is used to show the right-click menu on Treeview.
    """
    item = tree.identify('item', event.x, event.y)
    if item:
        tree.selection_set(item)
        right_click_menu.post(event.x_root, event.y_root)

def select_sbo():
    """
    Set the JSON file path to SBo repository.
    """
    global JSON_FILE
    JSON_FILE = "/var/lib/slpkg/repos/SBo/data.json"
    print(f"Selected SBo path: {JSON_FILE}")
    load_json()

def select_ponce():
    """
    Set the JSON file path to Ponce repository.
    """
    global JSON_FILE
    JSON_FILE = "/var/lib/slpkg/repos/ponce/data.json"
    print(f"Selected Ponce path: {JSON_FILE}")
    load_json()

def validate_selection():
    """
    Ensure that either SBo or Ponce is selected before loading JSON.
    """
    global JSON_FILE
    if JSON_FILE:
        load_json()
    else:
        error_label.config(text="Error: Please select a repository (SBo or Ponce).")

def clear_all():
    """
    Clears the treeview, checkboxes, and error label.
    """
    tree.delete(*tree.get_children())  # Clear treeview
    search_entry.delete(0, tk.END)  # Clear search entry
    pkg_name_entry.delete(0, tk.END)  # Clear package name field
    error_label.config(text="")  # Clear error label
    sbo_var.set(0)  # Uncheck SBo checkbox
    ponce_var.set(0)  # Uncheck Ponce checkbox

def remove_ansi_escape_codes(text):
    """
    Remove ANSI escape codes from the text to make it more human-readable.
    """
    ansi_escape = re.compile(r'(?:\x1b[^m]*m)')
    return ansi_escape.sub('', text)

def display_colored_output(output):
    """
    Display the output with color in the terminal (Text widget).
    This function processes ANSI escape codes to display colored text.
    """
    cleaned_output = remove_ansi_escape_codes(output)  # Remove color codes
    terminal_output.delete(1.0, tk.END)  # Clear previous output
    terminal_output.insert(tk.END, cleaned_output)  # Insert cleaned output into Text widget

def get_selected_repo_option():
    """
    Returns the selected repository option for slpkg commands (-o {repo-name}).
    This function checks whether 'SBo' or 'Ponce' is selected and returns the corresponding option.
    """
    if sbo_var.get() == 1:  # Check if SBo checkbox is checked
        return "-o sbo"
    elif ponce_var.get() == 1:  # Check if Ponce checkbox is checked
        return "-o ponce"
    else:
        return ""  # Return an empty string if no repository is selected




def execute_pkexec_command():
    """
    Execute the command using pkexec to gain root privileges.
    """
    pkg_name = pkg_name_entry.get().strip()  # Get the value from the pkg_name_entry (package name field)
    if pkg_name:
        try:
            # Using pkexec to execute the command with elevated privileges
            command = f"pkexec slpkg -fm {pkg_name}"
            result = subprocess.run(command, shell=True, text=True, capture_output=True)

            # Output the result (stdout) and error (stderr) to the terminal view (Text widget)
            terminal_output.delete(1.0, tk.END)  # Clear previous output
            display_colored_output(result.stdout)  # Display colored stdout
            if result.stderr:
                terminal_output.insert(tk.END, "\nError:\n" + result.stderr)  # Insert stderr if exists

            print(f"Executed command: {command}")
        except subprocess.CalledProcessError as e:
            error_label.config(text=f"Error executing command: {e}")
    else:
        error_label.config(text="Error: Package name is empty.")

def execute_slpkg_eE_command():
    """
    Execute the command 'slpkg -eE' with the entered package name and selected repository.
    """
    pkg_name = pkg_name_entry.get().strip()  # Get the package name from the entry field
    repo_option = get_selected_repo_option()  # Get the selected repository option

    if pkg_name:
        if repo_option:  # Ensure the repository option is valid
            try:
                # Using pkexec to execute the 'slpkg -eE' command with elevated privileges
                command = f"pkexec slpkg -eE {pkg_name} {repo_option}"
                result = subprocess.run(command, shell=True, text=True, capture_output=True)

                # Output the result (stdout) and error (stderr) to the terminal view (Text widget)
                terminal_output.delete(1.0, tk.END)  # Clear previous output
                display_colored_output(result.stdout)  # Display colored stdout
                if result.stderr:
                    terminal_output.insert(tk.END, "\nError:\n" + result.stderr)  # Insert stderr if exists

                print(f"Executed command: {command}")
            except subprocess.CalledProcessError as e:
                error_label.config(text=f"Error executing command: {e}")
        else:
            error_label.config(text="Error: No repository selected.")
    else:
        error_label.config(text="Error: Package name is empty.")

def execute_slpkg_w_command():
    """
    Execute the command 'slpkg -w' with the entered package name and selected repository.
    """
    pkg_name = pkg_name_entry.get().strip()  # Get the package name from the entry field
    repo_option = get_selected_repo_option()  # Get the selected repository option

    if pkg_name:
        if repo_option:  # Ensure the repository option is valid
            try:
                # Using subprocess to execute the 'slpkg -w' command with elevated privileges
                command = f"pkexec slpkg -w {pkg_name} {repo_option}"
                result = subprocess.run(command, shell=True, text=True, capture_output=True)

                # Output the result (stdout) and error (stderr) to the terminal view (Text widget)
                terminal_output.delete(1.0, tk.END)  # Clear previous output
                display_colored_output(result.stdout)  # Display colored stdout
                if result.stderr:
                    terminal_output.insert(tk.END, "\nError:\n" + result.stderr)  # Insert stderr if exists

                print(f"Executed command: {command}")
            except subprocess.CalledProcessError as e:
                error_label.config(text=f"Error executing command: {e}")
        else:
            error_label.config(text="Error: No repository selected.")
    else:
        error_label.config(text="Error: Package name is empty.")

def execute_slpkg_d_command():
    """
    Execute the command 'slpkg -d' with the entered package name and selected repository.
    """
    pkg_name = pkg_name_entry.get().strip()  # Get the package name from the entry field
    repo_option = get_selected_repo_option()  # Get the selected repository option

    if pkg_name:
        if repo_option:  # Ensure the repository option is valid
            try:
                # Using subprocess to execute the 'slpkg -d' command with elevated privileges
                command = f"pkexec slpkg -dy {pkg_name} {repo_option}"
                result = subprocess.run(command, shell=True, text=True, capture_output=True)

                # Output the result (stdout) and error (stderr) to the terminal view (Text widget)
                terminal_output.delete(1.0, tk.END)  # Clear previous output
                display_colored_output(result.stdout)  # Display colored stdout
                if result.stderr:
                    terminal_output.insert(tk.END, "\nError:\n" + result.stderr)  # Insert stderr if exists

                print(f"Executed command: {command}")
            except subprocess.CalledProcessError as e:
                error_label.config(text=f"Error executing command: {e}")
        else:
            error_label.config(text="Error: No repository selected.")
    else:
        error_label.config(text="Error: Package name is empty.")

# Create the main window
root = tk.Tk()
root.title("Modern JSON Package Viewer")
root.geometry("1000x600")  # Larger window

# Apply modern style using ttkbootstrap
style = Style(theme="darkly")

# Create the left frame for Clear, SBo, Ponce, Search, and Treeview
left_frame = ttk.Frame(root)
left_frame.pack(side="left", fill="both", padx=10, pady=10, expand=True)

# Create and place widgets for the left section
btn_clear = ttk.Button(left_frame, text="Clear", bootstyle="danger", width=15, command=clear_all)
btn_clear.pack(pady=20)

# Create checkboxes for SBo and Ponce
repo_frame = ttk.Frame(left_frame)
repo_frame.pack(pady=10)

sbo_var = tk.IntVar()
ponce_var = tk.IntVar()

# Add SBo checkbox
sbo_checkbox = ttk.Checkbutton(repo_frame, text="SBo", variable=sbo_var, bootstyle="success", command=lambda: [select_sbo() if sbo_var.get() else None, ponce_var.set(0)])
sbo_checkbox.pack(side="left", padx=20)

# Add Ponce checkbox
ponce_checkbox = ttk.Checkbutton(repo_frame, text="Ponce", variable=ponce_var, bootstyle="info", command=lambda: [select_ponce() if ponce_var.get() else None, sbo_var.set(0)])
ponce_checkbox.pack(side="left", padx=20)

# Create the search bar for searching treeview
search_frame = ttk.Frame(left_frame)
search_frame.pack(pady=15)

search_label = ttk.Label(search_frame, text="Search:", font=("Arial", 14))
search_label.pack(side="left", padx=10)

search_entry = ttk.Entry(search_frame, font=("Arial", 14), width=30)
search_entry.pack(side="left", padx=10)

search_button = ttk.Button(search_frame, text="Search", bootstyle="secondary", width=10, command=search_tree)
search_button.pack(side="left", padx=10)

# Create the Treeview widget (under search)
tree_frame = ttk.Frame(left_frame)
tree_frame.pack(expand=True, fill="both", padx=10, pady=10)

# Define a larger font for the Treeview contents and add padding to improve line spacing
style.configure("Treeview", font=("Arial", 12), rowheight=25)  # Larger font and increased row height for spacing

tree = ttk.Treeview(tree_frame, columns=("Details"))
tree.pack(expand=True, fill="both")

# Define highlight tag styles
tree.tag_configure("highlight_red", background="red")  # Red for parent folder/package
tree.tag_configure("highlight_green", background="lightgreen")  # Green for subfolder

# Create the right frame (buttons will be added here)
right_frame = ttk.Frame(root)
right_frame.pack(side="right", expand=True, fill="both", padx=10, pady=10)

# Add a new input field for the package name to execute the command
pkg_name_label = ttk.Label(right_frame, text="Package Name:", font=("Arial", 14))
pkg_name_label.pack(pady=10)

pkg_name_entry = ttk.Entry(right_frame, font=("Arial", 14), width=30)
pkg_name_entry.pack(pady=10)

# Add buttons to the right side (with command to execute pkexec command)
btn_right_1 = ttk.Button(right_frame, text="Is installed?", bootstyle="primary", width=20, command=execute_pkexec_command)
btn_right_1.pack(pady=10)

btn_right_2 = ttk.Button(right_frame, text="Who Depeens-on", bootstyle="secondary", width=20, command=execute_slpkg_eE_command)
btn_right_2.pack(pady=10)

btn_right_3 = ttk.Button(right_frame, text="Package Info", bootstyle="info", width=20, command=execute_slpkg_w_command)
btn_right_3.pack(pady=10)

btn_right_4 = ttk.Button(right_frame, text="Download Only", bootstyle="warning", width=20, command=execute_slpkg_d_command)
btn_right_4.pack(pady=10)

# Create a label to display errors
error_label = ttk.Label(right_frame, text="", font=("Arial", 12), foreground="red")
error_label.pack(pady=20)

# Create a Text widget to display terminal output (for command execution)
terminal_output = tk.Text(right_frame, height=50, width=100, wrap=tk.WORD, font=("Courier", 10), bg="black", fg="white")
terminal_output.pack(pady=20)

# Bind the Enter key to trigger the search function
root.bind("<Return>", search_tree)

# Bind Ctrl+C to copy selected item text to clipboard
root.bind("<Control-c>", copy_selected_item)

# Create a context menu for right-click
right_click_menu = tk.Menu(root, tearoff=0)
right_click_menu.add_command(label="Copy", command=copy_selected_item)

# Bind right-click to show the context menu
tree.bind("<Button-3>", on_right_click)

# Run the GUI event loop
root.mainloop()
