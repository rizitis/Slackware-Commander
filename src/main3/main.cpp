#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QProcess>
#include <QLineEdit>

class scmd : public QWidget {
public:
    scmd() {
        QVBoxLayout *mainLayout = new QVBoxLayout(this);

        // Title Layout
        QLabel *titleLabel = new QLabel("<font color='blue' size='5'><b>SOME MORE TOOLS</b></font>", this);

        mainLayout->addWidget(titleLabel);

        // Package Dependencies Button
        QHBoxLayout *findDepsLayout = new QHBoxLayout();
        QLineEdit *pkgInput = new QLineEdit(this);
        QPushButton *findDepsButton = createButton("Find package`s deps", "konsole --hold -e curl -sSL https://raw.githubusercontent.com/gapan/slackware-deps/15.0/$(pkgInput->text()).dep &");
        findDepsLayout->addWidget(pkgInput);
        findDepsLayout->addWidget(findDepsButton);
        mainLayout->addLayout(findDepsLayout);

        // Weather Forecast Button
        QPushButton *weatherButton = createButton("Weather-Forcast", "konsole --hold -e /usr/local/bin/weather_forcast &");
        mainLayout->addWidget(weatherButton);

        // Isnum Button
        QHBoxLayout *isnumLayout = new QHBoxLayout();
        QLineEdit *numInput = new QLineEdit(this);
        QPushButton *isnumButton = createButton("Isnum?", "konsole --hold -e /usr/local/bin/isnum $(numInput->text()) &");
        isnumLayout->addWidget(numInput);
        isnumLayout->addWidget(isnumButton);
        mainLayout->addLayout(isnumLayout);

        // Slackware Version Button
        QPushButton *versionButton = createButton("Print Slackware Release Version", "konsole --hold -e /usr/local/bin/print_version &");
        mainLayout->addWidget(versionButton);

        // Slack-Revert Button
        QPushButton *slackRevertButton = createButton("slack-revert", "konsole --hold -e slack-revert &");
        mainLayout->addWidget(slackRevertButton);

        // SBKS Button
        QPushButton *sbksButton = createButton("SBKS (Slack Build Kernel Script)", "konsole --hold -e SBKS &");
        mainLayout->addWidget(sbksButton);

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

    scmd window;
    window.setWindowTitle("Slackware Commander");
    window.show();

    return app.exec();
}
