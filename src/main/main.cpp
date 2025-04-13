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
        setWindowTitle("Slackware Commander");

        QVBoxLayout* mainLayout = new QVBoxLayout(this);

        QLabel* titleLabel = new QLabel("<span style='font-family: purisa; font-weight: bold; font-size: large;'>SYSTEM UPDATE</span>");
        titleLabel->setTextFormat(Qt::RichText);
        mainLayout->addWidget(titleLabel);

        // Main visible buttons
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Update", "/usr/sbin/slackpkg update"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Upgrade-all", "/usr/sbin/slackpkg upgrade-all"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Install-new", "/usr/sbin/slackpkg install-new"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg new-config", "/usr/sbin/slackpkg new-config"));
        mainLayout->addWidget(createSlackpkgButton("Slackpkg Full Update", "bash -c '/usr/sbin/slackpkg update; /usr/sbin/slackpkg install-new; /usr/sbin/slackpkg upgrade-all'"));

        // Toggle Button
        QPushButton* toggleButton = new QPushButton("▶ SHOW HIDDEN TOOLS");
        mainLayout->addWidget(toggleButton);

        // Collapsible Widget
        QWidget* packageWidget = new QWidget();
        QVBoxLayout* packageLayout = new QVBoxLayout(packageWidget);

        // Hidden Config Buttons
        packageLayout->addWidget(createSlackpkgButton("Blacklist", "nano /etc/slackpkg/blacklist"));
        packageLayout->addWidget(createSlackpkgButton("Mirrors", "nano /etc/slackpkg/mirrors"));
        packageLayout->addWidget(createSlackpkgButton("Slackpkg.conf", "nano /etc/slackpkg/slackpkg.conf"));
        packageLayout->addWidget(createSlackpkgButton("ChangeLog", "kdialog --textbox /var/lib/slackpkg/ChangeLog.txt 600 400"));
        packageLayout->addWidget(createSlackpkgButton("whitelist", "nano /etc/slackpkg/whitelist"));

        // Hidden Package Entry Section
        QLineEdit* packageEntry = new QLineEdit();
        packageLayout->addWidget(new QLabel("Package:"));
        packageLayout->addWidget(packageEntry);

        packageLayout->addWidget(createPackageCommandButton("slackpkg_build", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg install", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg reinstall", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg search", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg remove", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("--help", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("slackpkg info", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("whereis", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("which", packageEntry));
        //packageLayout->addWidget(createPackageCommandButton("--version", packageEntry));
        //packageLayout->addWidget(createPackageCommandButton("man", packageEntry));

        packageWidget->setVisible(false);
        mainLayout->addWidget(packageWidget);

        // Toggle logic
        connect(toggleButton, &QPushButton::clicked, [this, toggleButton, packageWidget]() {
            bool isVisible = packageWidget->isVisible();
            packageWidget->setVisible(!isVisible);
            toggleButton->setText(isVisible ? "▶ Show Hidden Tools" : "▼ Hide Again Tools");
            this->adjustSize();
        });

        // More Tools Button
        QPushButton* moreToolsButton = new QPushButton("MORE TOOLS");
        connect(moreToolsButton, &QPushButton::clicked, this, &scmd::openMoreTools);
        mainLayout->addWidget(moreToolsButton);

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
            QProcess::startDetached("/usr/bin/konsole", QStringList() << "--hold" << "-e" << "su" << "-c" << action);
        });
        return button;
    }

    QPushButton* createPackageCommandButton(const QString& label, QLineEdit* packageEntry) {
        QPushButton* button = new QPushButton(label);
        connect(button, &QPushButton::clicked, [packageEntry, label]() {
            QString command = label.startsWith("--")
                ? packageEntry->text() + " " + label
                : label + " " + packageEntry->text();

            qDebug() << "Executing as root: " << command;
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
    window.adjustSize();

    return app.exec();
}
