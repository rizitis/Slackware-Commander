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
        setWindowTitle("slackpkg+");

        // Create main layout
        QVBoxLayout* mainLayout = new QVBoxLayout(this);

        // Title Section
        QLabel* titleLabel = new QLabel("<span style='font-family: purisa; font-weight: bold; font-size: large;'>SLACKPKG+ SETUP</span>");
        mainLayout->addWidget(titleLabel);

        // Slackpkg+ Setup Section
        QVBoxLayout* setupLayout = new QVBoxLayout();
        setupLayout->addWidget(createSlackpkgButton("slackpkgplus.conf", "nano /etc/slackpkg/slackpkgplus.conf"));
        setupLayout->addWidget(createSlackpkgButton("greylist", "nano /etc/slackpkg/greylist"));
        setupLayout->addWidget(createSlackpkgButton("notifymsg.conf", "nano /etc/slackpkg/notifymsg.conf"));
        setupLayout->addWidget(createSlackpkgButton("post-functions.conf-sample", "nano /etc/slackpkg/post-functions.conf-sample"));
        mainLayout->addLayout(setupLayout);

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
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    scmd window;
    window.show();

    return app.exec();
}
