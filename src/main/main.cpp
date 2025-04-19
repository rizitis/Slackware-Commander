#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QProcess>
#include <QLineEdit>
#include <QTextEdit>
#include <QGroupBox>
#include <QDebug>

class scmd : public QWidget {
public:
    scmd() {
        setWindowTitle("Slackware Commander");

        // Set the window to always stay on top
        setWindowFlags(windowFlags() | Qt::WindowStaysOnTopHint);


        QVBoxLayout* mainLayout = new QVBoxLayout(this);

        QLabel* titleLabel = new QLabel("<span style='font-family: purisa; font-weight: bold; font-size: large;'>SYSTEM UPDATE</span>");
        titleLabel->setTextFormat(Qt::RichText);
        mainLayout->addWidget(titleLabel);

        // ── Group: System Updates ────────────────────────
        QGroupBox* updateGroup = new QGroupBox("");
        QVBoxLayout* updateLayout = new QVBoxLayout();

        QPushButton* fullUpdateBtn = createSlackpkgButton("Slackpkg Full Update", "bash -c '/usr/sbin/slackpkg update; /usr/sbin/slackpkg install-new; /usr/sbin/slackpkg upgrade-all'");
        fullUpdateBtn->setStyleSheet("background-color: #B22222; color: white; font-weight: bold;");
        updateLayout->addWidget(fullUpdateBtn);

        updateLayout->addWidget(createSlackpkgButton("Slackpkg Update", "/usr/sbin/slackpkg update"));
        updateLayout->addWidget(createSlackpkgButton("Slackpkg Upgrade-all", "/usr/sbin/slackpkg upgrade-all"));
        updateLayout->addWidget(createSlackpkgButton("Slackpkg Install-new", "/usr/sbin/slackpkg install-new"));
        updateLayout->addWidget(createSlackpkgButton("Slackpkg new-config", "/usr/sbin/slackpkg new-config"));

        updateGroup->setLayout(updateLayout);
        mainLayout->addWidget(updateGroup);

        // ── Toggle Hidden Tools ──────────────────────────
        QPushButton* toggleButton = new QPushButton("▶ SHOW HIDDEN");
        toggleButton->setStyleSheet("background-color: #0057b7; color: white; font-weight: bold; border-radius: 5px; padding: 4px;");
        mainLayout->addWidget(toggleButton);

        // ── Group: Hidden Package Tools ──────────────────
        QWidget* packageWidget = new QWidget();
        QVBoxLayout* packageLayout = new QVBoxLayout(packageWidget);

        QGroupBox* configGroup = new QGroupBox("Config Files");
        QVBoxLayout* configLayout = new QVBoxLayout();
        configLayout->addWidget(createSlackpkgButton("Blacklist", "nano /etc/slackpkg/blacklist"));
        configLayout->addWidget(createSlackpkgButton("Mirrors", "nano /etc/slackpkg/mirrors"));
        configLayout->addWidget(createSlackpkgButton("Slackpkg.conf", "nano /etc/slackpkg/slackpkg.conf"));
        configLayout->addWidget(createSlackpkgButton("ChangeLog", "kdialog --textbox /var/lib/slackpkg/ChangeLog.txt 600 400"));
        configLayout->addWidget(createSlackpkgButton("whitelist", "nano /etc/slackpkg/whitelist"));
        configGroup->setLayout(configLayout);
        packageLayout->addWidget(configGroup);

        QGroupBox* pkgActionsGroup = new QGroupBox("Package Commands:");
        QVBoxLayout* pkgActionLayout = new QVBoxLayout();

        QLineEdit* packageEntry = new QLineEdit();
        // pkgActionLayout->addWidget(new QLabel("Package:"));
        pkgActionLayout->addWidget(packageEntry);

        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg_build", packageEntry));
        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg install", packageEntry));
        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg reinstall", packageEntry));
        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg search", packageEntry));
        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg remove", packageEntry));
        // pkgActionLayout->addWidget(createPackageCommandButton("--help", packageEntry));
        pkgActionLayout->addWidget(createPackageCommandButton("slackpkg info", packageEntry));
        // pkgActionLayout->addWidget(createPackageCommandButton("whereis", packageEntry));
        // pkgActionLayout->addWidget(createPackageCommandButton("which", packageEntry));

        pkgActionsGroup->setLayout(pkgActionLayout);
        packageLayout->addWidget(pkgActionsGroup);

        packageWidget->setVisible(false);
        mainLayout->addWidget(packageWidget);

        connect(toggleButton, &QPushButton::clicked, [this, toggleButton, packageWidget]() {
            bool isVisible = packageWidget->isVisible();
            packageWidget->setVisible(!isVisible);
            toggleButton->setText(isVisible ? "▶ Show Hidden" : "▼ Hide Again");
            this->adjustSize();
        });

        // ── Group: Utilities ─────────────────────────────
        QGroupBox* utilGroup = new QGroupBox("Extra Utilities");
        QVBoxLayout* utilLayout = new QVBoxLayout();

        QPushButton* moreToolsButton = new QPushButton("MORE TOOLS");
        moreToolsButton->setStyleSheet("background-color: #228B22; color: white; font-weight: bold; border-radius: 5px; padding: 4px;");
        connect(moreToolsButton, &QPushButton::clicked, this, &scmd::openMoreTools);
        utilLayout->addWidget(moreToolsButton);

        QPushButton* slackpkgplussButton = new QPushButton("slackpkg+ SetUp");
        slackpkgplussButton->setStyleSheet("background-color: #FF8C00; color: white; font-weight: bold; border-radius: 5px; padding: 4px;");
        connect(slackpkgplussButton, &QPushButton::clicked, this, &scmd::openslackpkgpluss);
        utilLayout->addWidget(slackpkgplussButton);

        utilGroup->setLayout(utilLayout);
        mainLayout->addWidget(utilGroup);

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
