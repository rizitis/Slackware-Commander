#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QIcon>
#include <QPixmap>
#include <QProcess>
#include <QMessageBox>
#include <QLineEdit>
#include <QTextEdit>

class SlackwareCommander : public QWidget {
public:
    SlackwareCommander() {
        // Set the window title
        setWindowTitle("Slackware Commander");

        // Create main layout
        QVBoxLayout* mainLayout = new QVBoxLayout(this);

        // Logo section
        QLabel* logoLabel = new QLabel();
        logoLabel->setPixmap(QPixmap("/usr/share/icons/Slackware-Commander/slackware_logo_med.png"));
        QLabel* titleLabel = new QLabel("<span style='color: white; font-family: purisa; font-weight: bold; font-size: large;'>SYSTEM UPDATE</span>");
        QVBoxLayout* logoLayout = new QVBoxLayout();
        logoLayout->addWidget(logoLabel);
        logoLayout->addWidget(titleLabel);

        mainLayout->addLayout(logoLayout);

        // Slackpkg Package Management Buttons
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Update", "/usr/share/icons/Slackware-Commander/this-way-up-symbol-icon.png", "konsole --hold -e /usr/sbin/slackpkg update"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Upgrade-all", "/usr/share/icons/Slackware-Commander/deep-water-icon.png", "konsole --hold -e /usr/sbin/slackpkg upgrade-all"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Install-new", "/usr/share/icons/Slackware-Commander/wow-icon.png", "konsole --hold -e slackpkg install-new"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg new-config", "/usr/share/icons/Slackware-Commander/project-work-icon.png", "konsole --hold -e /usr/sbin/slackpkg new-config"));

        // Slackpkg Setup Section
        QVBoxLayout* setupLayout = new QVBoxLayout();
        setupLayout->addWidget(createSlackpkgButton("Blacklist", "/usr/share/icons/Slackware-Commander/silence-icon.png", "konsole -e nano /etc/slackpkg/blacklist"));
        setupLayout->addWidget(createSlackpkgButton("Mirrors", "/usr/share/icons/Slackware-Commander/business-management-icon.png", "konsole -e nano /etc/slackpkg/mirrors"));
        setupLayout->addWidget(createSlackpkgButton("Slackpkg.conf", "/usr/share/icons/Slackware-Commander/carpenter-tools-icon.png", "konsole -e nano /etc/slackpkg/slackpkg.conf"));
        setupLayout->addWidget(createSlackpkgButton("ChangeLog", "/usr/share/icons/Slackware-Commander/downtime-arrow-icon.png", "cat /var/lib/slackpkg/ChangeLog.txt | yad --text-info --width=600 --height=600 --title 'ChangeLog'"));
        mainLayout->addLayout(setupLayout);

        // Slackpkg+ Configuration
        mainLayout->addWidget(createSlackpkgButton("slackpkg+.conf", "/usr/share/icons/Slackware-Commander/diy-do-it-yourself-icon.png", "konsole -e nano /etc/slackpkg/slackpkgplus.conf"));

        // Package Command Section (slackpkg build, install, reinstall, etc.)
        QVBoxLayout* packageLayout = new QVBoxLayout();
        QLineEdit* packageEntry = new QLineEdit();
        packageLayout->addWidget(new QLabel("Package:"));
        packageLayout->addWidget(packageEntry);

        // Package management buttons
        packageLayout->addWidget(createPackageCommandButton("slackpkg_build", "/usr/share/icons/Slackware-Commander/hammer-icon.png", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg install", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg reinstall", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg search", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg remove", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Help", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Slackpkg info", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Whereis", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Which", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Version", "", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Manual", "", packageEntry));

        mainLayout->addLayout(packageLayout);

        // More Tools Button
        QPushButton* moreToolsButton = new QPushButton("MORE TOOLS");
        moreToolsButton->setIcon(QIcon("/usr/share/icons/Slackware-Commander/toolbox-icon.png"));
        connect(moreToolsButton, &QPushButton::clicked, this, &SlackwareCommander::openMoreTools);
        mainLayout->addWidget(moreToolsButton);

        setLayout(mainLayout);
    }

private:
    QPushButton* createSlackpkgButton(const QString& label, const QString& iconPath, const QString& action) {
        QPushButton* button = new QPushButton(label);
        button->setIcon(QIcon(iconPath));
        connect(button, &QPushButton::clicked, [action]() {
            QProcess::startDetached(action);
        });
        return button;
    }

    QPushButton* createPackageCommandButton(const QString& label, const QString& iconPath, QLineEdit* packageEntry) {
        QPushButton* button = new QPushButton(label);
        if (!iconPath.isEmpty()) {
            button->setIcon(QIcon(iconPath));
        }
        connect(button, &QPushButton::clicked, [packageEntry, label]() {
            QString command = label + " " + packageEntry->text();
            if (label == "Help") {
                QProcess::startDetached(command + " --help | yad --text-info --width=600 --height=600 --title 'Help'");
            } else if (label == "Slackpkg info") {
                QProcess::startDetached("konsole --hold -e slackpkg info " + packageEntry->text());
            } else if (label == "Whereis") {
                QProcess::startDetached("whereis " + packageEntry->text() + " | yad --text-info --width=400 --height=20 --title 'Whereis'");
            } else if (label == "Which") {
                QProcess::startDetached("which " + packageEntry->text() + " | yad --text-info --width=200 --height=200 --title 'Version'");
            } else if (label == "Version") {
                QProcess::startDetached(packageEntry->text() + " --version | yad --text-info --width=200 --height=200 --title 'Version'");
            } else if (label == "Manual") {
                QProcess::startDetached("man " + packageEntry->text() + " | yad --text-info --width=400 --height=500 --title 'Manual'");
            } else {
                QProcess::startDetached(command);
            }
        });
        return button;
    }

    void openMoreTools() {
        QProcess::startDetached("bash SLCMD2.sh");
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    SlackwareCommander window;
    window.show();

    return app.exec();
}
