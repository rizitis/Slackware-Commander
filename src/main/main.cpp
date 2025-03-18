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
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Update", "/usr/sbin/slackpkg update"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Upgrade-all", "/usr/sbin/slackpkg upgrade-all"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Install-new", "/usr/sbin/slackpkg install-new"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg new-config", "/usr/sbin/slackpkg new-config"));

        // Slackpkg Setup Section
        QVBoxLayout* setupLayout = new QVBoxLayout();
        setupLayout->addWidget(createSlackpkgButton("Blacklist", "nano /etc/slackpkg/blacklist"));
        setupLayout->addWidget(createSlackpkgButton("Mirrors", "nano /etc/slackpkg/mirrors"));
        setupLayout->addWidget(createSlackpkgButton("Slackpkg.conf", "nano /etc/slackpkg/slackpkg.conf"));
        setupLayout->addWidget(createSlackpkgButton("ChangeLog", "kdialog --textbox /var/lib/slackpkg/ChangeLog.txt 600 400"));
        mainLayout->addLayout(setupLayout);

        // Slackpkg+ Configuration
        mainLayout->addWidget(createSlackpkgButton("whitelist", "nano /etc/slackpkg/whitelist"));

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
        packageLayout->addWidget(createPackageCommandButton("--help", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg info", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("whereis", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("which", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("--version", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("man", packageEntry));

        mainLayout->addLayout(packageLayout);

        // More Tools Button
        QPushButton* moreToolsButton = new QPushButton("MORE TOOLS");
        connect(moreToolsButton, &QPushButton::clicked, this, &scmd::openMoreTools);
        mainLayout->addWidget(moreToolsButton);

        setLayout(mainLayout);

        // Slackpkg+ setup Button
        QPushButton* slackpkgplussButton = new QPushButton("slackpkg+ SetUp");
        connect(slackpkgplussButton, &QPushButton::clicked, this, &scmd::openslackpkgpluss);
        mainLayout->addWidget(slackpkgplussButton);

        setLayout(mainLayout);
    }

private:
    QPushButton* createSlackpkgButton(const QString& label, const QString& action) {
        QPushButton* button = new QPushButton(label);
        connect(button, &QPushButton::clicked, [action]() {
            qDebug() << "Executing as root: " << action;
            // Run the command as root using su -c
            QProcess::startDetached("/usr/bin/konsole", QStringList() << "--hold" << "-e" << "su" << "-c" << action);
        });
        return button;
    }

    QPushButton* createPackageCommandButton(const QString& label, QLineEdit* packageEntry) {
        QPushButton* button = new QPushButton(label);
        connect(button, &QPushButton::clicked, [packageEntry, label]() {
            QString command;

            // Special handling for --help or --version commands
            if (label.startsWith("--")) {  // This handles --help or --version
                command = packageEntry->text() + " " + label;
            } else {
                command = label + " " + packageEntry->text();
            }

            qDebug() << "Executing as root: " << command;
            // Run the command as root using su -c
            QProcess::startDetached("/usr/bin/konsole", QStringList() << "--hold" << "-e" << "su" << "-c" << command);
        });
        return button;
    }

    void openMoreTools() {
    QProcess::startDetached("/usr/local/sbin/scmd2");
}
    void openslackpkgpluss() {
    QProcess::startDetached("/usr/local/sbin/scmd3");
}
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    scmd window;
    window.show();

    return app.exec();
}
