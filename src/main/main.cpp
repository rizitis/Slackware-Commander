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
        titleLabel->setTextFormat(Qt::RichText);
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

        // Collapsible Section Toggle
        QPushButton* toggleButton = new QPushButton("▶ SHOW HIDDEN TOOLS");
        mainLayout->addWidget(toggleButton);

        // Collapsible Widget for Package Section
        QWidget* packageWidget = new QWidget();
        QVBoxLayout* packageLayout = new QVBoxLayout(packageWidget);

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
        packageLayout->addWidget(createPackageCommandButton("--version", packageEntry));
        packageLayout->addWidget(createPackageCommandButton("man", packageEntry));

        packageWidget->setVisible(false);  // Initially hidden
        mainLayout->addWidget(packageWidget);

        // Toggle logic with auto-resize
        connect(toggleButton, &QPushButton::clicked, [this, toggleButton, packageWidget]() {
            bool isVisible = packageWidget->isVisible();
            packageWidget->setVisible(!isVisible);
            toggleButton->setText(isVisible ? "▶ Show Hidden Tools" : "▼ Hide Again Tools");
            this->adjustSize(); // Auto-resize the window
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
            QString command;

            if (label.startsWith("--")) {
                command = packageEntry->text() + " " + label;
            } else {
                command = label + " " + packageEntry->text();
            }

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
    window.adjustSize(); // Ensure initial sizing is tight

    return app.exec();
}
