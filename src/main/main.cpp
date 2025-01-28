#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QProcess>
#include <QLineEdit>
#include <QTextEdit>
#include <QDebug>

class scmd : public QWidget {
public:
    scmd() {
        // Set the window title
        setWindowTitle("Slackware Commander");

        // Create main layout
        QVBoxLayout* mainLayout = new QVBoxLayout(this);

        // Title Section
        QLabel* titleLabel = new QLabel("<span style='font-family: purisa; font-weight: bold; font-size: large;'>SYSTEM UPDATE</span>");
        mainLayout->addWidget(titleLabel);

        // Slackpkg Package Management Buttons
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Update", "/usr/bin/konsole --hold -e /usr/sbin/slackpkg update"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Upgrade-all", "/usr/bin/konsole --hold -e /usr/sbin/slackpkg upgrade-all"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Install-new", "/usr/bin/konsole --hold -e /usr/sbin/slackpkg install-new"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg new-config", "/usr/bin/konsole --hold -e /usr/sbin/slackpkg new-config"));

        // Slackpkg Setup Section
        QVBoxLayout* setupLayout = new QVBoxLayout();
        setupLayout->addWidget(createSlackpkgButton("Blacklist", "/usr/bin/konsole -e nano /etc/slackpkg/blacklist"));
        setupLayout->addWidget(createSlackpkgButton("Mirrors", "/usr/bin/konsole -e nano /etc/slackpkg/mirrors"));
        setupLayout->addWidget(createSlackpkgButton("Slackpkg.conf", "/usr/bin/konsole -e nano /etc/slackpkg/slackpkg.conf"));
        setupLayout->addWidget(createSlackpkgButton("ChangeLog", "cat /var/lib/slackpkg/ChangeLog.txt | yad --text-info --width=600 --height=600 --title 'ChangeLog'"));
        mainLayout->addLayout(setupLayout);

        // Slackpkg+ Configuration
        mainLayout->addWidget(createSlackpkgButton("slackpkg+.conf", "/usr/bin/konsole -e nano /etc/slackpkg/slackpkgplus.conf"));

        // Package Command Section (slackpkg build, install, reinstall, etc.)
        QVBoxLayout* packageLayout = new QVBoxLayout();
        QLineEdit* packageEntry = new QLineEdit();
        packageLayout->addWidget(new QLabel("Package:"));
        packageLayout->addWidget(packageEntry);

        // Package management buttons
        packageLayout->addWidget(createPackageCommandButton("slackpkg_build", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg install", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg reinstall", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg search", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg remove", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Help", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Slackpkg info", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Whereis", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Which", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Version", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("Manual", packageEntry));

        mainLayout->addLayout(packageLayout);

        // More Tools Button
        QPushButton* moreToolsButton = new QPushButton("MORE TOOLS");
        connect(moreToolsButton, &QPushButton::clicked, this, &scmd::openMoreTools);
        mainLayout->addWidget(moreToolsButton);

        setLayout(mainLayout);
    }

private:
    QPushButton* createSlackpkgButton(const QString& label, const QString& action) {
        QPushButton* button = new QPushButton(label);
        connect(button, &QPushButton::clicked, [action]() {
            qDebug() << "Executing: " << action;
            QProcess::startDetached("/bin/sh", QStringList() << "-c" << action);
        });
        return button;
    }

    QPushButton* createPackageCommandButton(const QString& label, QLineEdit* packageEntry) {
        QPushButton* button = new QPushButton(label);
        connect(button, &QPushButton::clicked, [packageEntry, label]() {
            QString command = label + " " + packageEntry->text();
            qDebug() << "Executing: " << command;
            QProcess::startDetached("/bin/sh", QStringList() << "-c" << command);
        });
        return button;
    }

    void openMoreTools() {
        QProcess::startDetached("/bin/sh", QStringList() << "-c" << "bash SLCMD2.sh");
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    scmd window;
    window.show();

    return app.exec();
}
