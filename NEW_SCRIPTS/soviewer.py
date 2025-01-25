# This script is a GUI for viewing and searching Slackware64 Current Shared Object files
# It fetches package names from my GitHub repository, so its Un-Official tool...
# License MIT Anagnostakis Ioannis 2025 GR


import os
import tempfile
import tkinter as tk
from tkinter import scrolledtext, font
import requests
import shutil

# Function to download the AALL_FILES.md to a temporary directory
def download_aall_files():
    temp_dir = tempfile.mkdtemp()  # Create a temporary directory
    aall_file_path = os.path.join(temp_dir, "AALL_FILES.md")  # Path to the downloaded file
    url = "https://raw.githubusercontent.com/rizitis/Slackware64-Current-sofiles/refs/heads/main/AALL_FILES.md"

    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        with open(aall_file_path, "w") as file:
            file.write(response.text)  # Save the content to the file
    except requests.exceptions.RequestException as e:
        print(f"Error downloading AALL_FILES.md: {e}")
        return None

    return aall_file_path  # Return the path to the downloaded file

# Function to read package names and URLs from the downloaded AALL_FILES.md
def load_packages(file_path):
    packages = {}
    try:
        with open(file_path, "r") as file:
            for line in file:
                if line.startswith("[") and "](" in line:
                    name = line.split("[")[1].split("]")[0]
                    url = line.split("(")[1].split(")")[0]
                    packages[name] = url
    except FileNotFoundError:
        print("AALL_FILES.md not found.")
    return packages

# Function to fetch and display the first line of README.md content on startup
def fetch_readme():
    url = "https://raw.githubusercontent.com/rizitis/Slackware64-Current-sofiles/refs/heads/main/README.md"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        first_line = response.text.splitlines()[0]  # Get the first line of the file
        text_area.delete(1.0, tk.END)  # Clear previous content
        text_area.insert(tk.END, first_line)  # Display the first line
    except requests.exceptions.Timeout:
        text_area.insert(tk.END, "Error: Request timed out.")
    except requests.exceptions.HTTPError as err:
        text_area.insert(tk.END, f"HTTP Error: {err}")
    except requests.RequestException as e:
        text_area.insert(tk.END, f"Error fetching file: {e}")

# Function to search and update the listbox
def update_listbox(*args):
    search_term = search_var.get().lower()
    listbox.delete(0, tk.END)
    for pkg in packages.keys():
        if search_term in pkg.lower():
            listbox.insert(tk.END, pkg)

# Function to fetch and display file content
def fetch_file():
    selected = listbox.get(tk.ACTIVE)
    if selected and selected in packages:
        url = packages[selected].replace("blob/main", "raw/main")  # Convert to raw URL
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            text_area.delete(1.0, tk.END)
            text_area.insert(tk.END, response.text)
        except requests.RequestException as e:
            text_area.delete(1.0, tk.END)
            text_area.insert(tk.END, f"Error fetching file: {e}")

# Function to clear the app and reset everything (like app just started)
def clear_app():
    listbox.delete(0, tk.END)  # Clear listbox
    search_var.set("")  # Clear search entry
    fetch_readme()  # Fetch and display the first line of README.md

# GUI Setup
root = tk.Tk()
root.title("Slackware64 Current Shared Object File Viewer")
root.geometry("700x600")
root.configure(bg="#2C2C2C")  # Dark mode background

def_font = font.Font(family="San Francisco", size=14)
heading_font = font.Font(family="San Francisco", size=16, weight="bold")

search_var = tk.StringVar()
search_var.trace("w", update_listbox)

search_label = tk.Label(root, text="Search:", font=heading_font, bg="#2C2C2C", fg="white")
search_label.pack(pady=10)

search_entry = tk.Entry(root, textvariable=search_var, width=50, font=def_font, bd=2, relief="flat", bg="#3C3C3C", fg="white", insertbackground="white")
search_entry.pack(pady=5)

listbox_frame = tk.Frame(root, bg="#3C3C3C", bd=2, relief="sunken")
listbox = tk.Listbox(listbox_frame, width=50, height=10, font=def_font, bd=0, highlightthickness=0, activestyle="none", bg="#3C3C3C", fg="white")
listbox.pack(pady=5, padx=5)
listbox_frame.pack(pady=5)

fetch_button = tk.Button(root, text="Fetch File", command=fetch_file, font=heading_font, bg="#007AFF", fg="white", padx=12, pady=8, bd=0, relief="flat")
fetch_button.pack(pady=15)

clear_button = tk.Button(root, text="Clear", command=clear_app, font=heading_font, bg="red", fg="white", padx=12, pady=8, bd=0, relief="flat")
clear_button.pack(pady=15)

text_area_frame = tk.Frame(root, bg="#3C3C3C", bd=2, relief="sunken")
text_area = scrolledtext.ScrolledText(text_area_frame, width=80, height=20, font=def_font, bd=0, highlightthickness=0, wrap="word", bg="#3C3C3C", fg="white", insertbackground="white")
text_area.pack(pady=5, padx=5)
text_area_frame.pack(pady=5)

# Download AALL_FILES.md, load packages, and fetch README file (first line) on app start
aall_file_path = download_aall_files()  # Download AALL_FILES.md to temp directory
if aall_file_path:
    packages = load_packages(aall_file_path)  # Load packages from the downloaded file
    fetch_readme()  # Fetch the first line of the README.md

root.mainloop()
