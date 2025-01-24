#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QProcess>

class SlackwareCommander : public QWidget {
public:
    SlackwareCommander() {
        QVBoxLayout *mainLayout = new QVBoxLayout(this);

        // Title Layout
        QLabel *titleLabel = new QLabel("<font color='blue' size='5'><b>SYSTEM INFORMATIONS and TOOLS</b></font>", this);
        mainLayout->addWidget(titleLabel);

        // Button Layout
        QVBoxLayout *buttonLayout = new QVBoxLayout();

        // Panic Button
        QPushButton *panicButton = createButton("Panic Button", "konsole --hold -e bash -c \"$(ls /usr/local/bin/panic/*.sh | shuf -n 1)\"");
        buttonLayout->addWidget(panicButton);

        // CPU Info Button
        QPushButton *cpuInfoButton = createButton("CPU Infos", "cat /proc/cpuinfo | yad --text-info --width=700 --height=500 --title='CPU infos'");
        buttonLayout->addWidget(cpuInfoButton);

        // Ethernet Interfaces Button
        QPushButton *ethernetButton = createButton("Ethernet Interfaces", "ifconfig | yad --text-info --width=700 --height=500 --title='View an ethernet network interface'");
        buttonLayout->addWidget(ethernetButton);

        // Wireless Interfaces Button
        QPushButton *wirelessButton = createButton("Wireless Interfaces", "iwconfig | yad --text-info --width=700 --height=500 --title='Current wireless network interface'");
        buttonLayout->addWidget(wirelessButton);

        // USB Devices Button
        QPushButton *usbButton = createButton("USB Devices", "lsusb | yad --text-info --width=700 --height=500 --title='USB devices'");
        buttonLayout->addWidget(usbButton);

        // Add more buttons as needed...

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
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    SlackwareCommander window;
    window.setWindowTitle("Slackware Commander");
    window.show();

    return app.exec();
}
