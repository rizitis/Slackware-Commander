#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QLabel>
#include <QProcess>
#include <QFile>
#include <QDebug>

class scmd : public QWidget {
public:
    scmd() {
        QVBoxLayout *mainLayout = new QVBoxLayout(this);

        // Title Layout
        QLabel *titleLabel = new QLabel("<font color='blue' size='5'><b>SYSTEM INFORMATIONS and TOOLS</b></font>", this);
        mainLayout->addWidget(titleLabel);

        // Button Layout
        QVBoxLayout *buttonLayout = new QVBoxLayout();

        // CPU Info
        buttonLayout->addWidget(createButton("CPU Info", "cat /proc/cpuinfo | kdialog --textbox - --geometry 700x500 --title 'CPU Info'"));

        // Memory Info
        buttonLayout->addWidget(createButton("Memory Info", "free -h | kdialog --textbox - --geometry 700x500 --title 'Memory Info'"));

        // GPU Info (Supports both X11 & Wayland)
        buttonLayout->addWidget(createButton("GPU Info", "lspci | grep -i vga | kdialog --textbox - --geometry 700x500 --title 'GPU Info'"));

        // Ethernet Interfaces
        buttonLayout->addWidget(createButton("Ethernet Interfaces", "ifconfig 2>/dev/null || ip a | kdialog --textbox - --geometry 700x500 --title 'Ethernet Interfaces'"));

        // Wireless Interfaces
        buttonLayout->addWidget(createButton("Wireless Interfaces", "iwconfig 2>/dev/null || nmcli device show | kdialog --textbox - --geometry 700x500 --title 'Wireless Interfaces'"));

        // USB Devices
        buttonLayout->addWidget(createButton("USB Devices", "lsusb | kdialog --textbox - --geometry 700x500 --title 'USB Devices'"));

        // Sound Cards
        buttonLayout->addWidget(createButton("Sound Cards", "aplay -l | kdialog --textbox - --geometry 700x500 --title 'Sound Cards'"));

        // Microphones
        buttonLayout->addWidget(createButton("Microphones", "arecord -l | kdialog --textbox - --geometry 700x500 --title 'Microphones'"));

        // Monitor Detection (Wayland + X11)
        buttonLayout->addWidget(createButton("Connected Monitors", detectMonitorCommand()));

        // Webcams
        buttonLayout->addWidget(createButton("Webcams", "ls /dev/video* 2>/dev/null | kdialog --textbox - --geometry 700x500 --title 'Detected Webcams'"));

        mainLayout->addLayout(buttonLayout);
        setLayout(mainLayout);
    }

private:
    QPushButton* createButton(const QString& label, const QString& action) {
        QPushButton *button = new QPushButton(label, this);
        connect(button, &QPushButton::clicked, this, [=]() {
            QProcess::startDetached("bash", QStringList() << "-c" << action);
        });
        return button;
    }

    QString detectMonitorCommand() {
        if (QFile::exists("/usr/bin/xrandr")) {
            return "xrandr --query | kdialog --textbox - --geometry 700x500 --title 'Connected Monitors'";
        } else if (QFile::exists("/usr/bin/wlr-randr")) {
            return "wlr-randr | kdialog --textbox - --geometry 700x500 --title 'Wayland Monitors'";
        } else if (QFile::exists("/usr/bin/swaymsg")) {
            return "swaymsg -t get_outputs | kdialog --textbox - --geometry 700x500 --title 'Sway Monitors'";
        } else {
            return "echo 'No monitor detection available for this system' | kdialog --error 'Monitor Detection Failed'";
        }
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    scmd window;
    window.setWindowTitle("Slackware Commander");
    window.show();

    return app.exec();
}
