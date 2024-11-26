#!/bin/bash
MYSQL_MAJOR_VERSION=8;
MYSQL_MINOR_VERSION=0;
MYSQL_PATCH_VERSION=36;

INSTALLER_HOME=$(dirname "$(realpath "$0")");
MYSQL_BASE="${INSTALLER_HOME}/mysql";

export MYSQL_HOME="${MYSQL_BASE}/server";
export DATADIR="$MYSQL_HOME/data";
MY_CNF="$MYSQL_HOME/my.cnf";
BINDIR="$MYSQL_HOME/bin";

MYSQLD_PID="$DATADIR/mysqld.pid";

#Java
JAVA_VERSION="11.0.22";
JAVA_UPDATE=7;

INSTALLER_HOME=$(dirname "$(realpath "$0")");
JAVA_BASE="${INSTALLER_HOME}/java";
JDK_BASE="${JAVA_BASE}/jdk";
JAVA_HOME=$("${JAVA_BASE}"/java_install.sh "${JAVA_BASE}" "${JAVA_VERSION}" "${JAVA_UPDATE}" "${JDK_BASE}" | tail -n 1);

if [ ! -d "${BINDIR}" ]; then
    "${MYSQL_BASE}"/mysql_install.sh ${MYSQL_MAJOR_VERSION} ${MYSQL_MINOR_VERSION} ${MYSQL_PATCH_VERSION} ${JAVA_HOME};
fi

if [ ! -d "${BINDIR}" ]; then
    echo "Not installed MySQL version ${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION} then running stop";
    exit 1;
fi

# Create systemd service file
echo "Creating systemd service file for MySQL..."
cat > "/etc/systemd/system/mysql.service" <<EOL
[Unit]
Description=MySQL Server
After=network.target

[Service]
ExecStart=${BINDIR}/mysqld --defaults-file=${MY_CNF} --datadir=${DATADIR}
ExecStop=${BINDIR}/mysqld --defaults-file=${MY_CNF} shutdown
PIDFile=${DATADIR}/mysqld.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable the service
echo "Reloading systemd and enabling MySQL service..."
systemctl daemon-reload
systemctl enable mysql.service

# Start the MySQL service
echo "Starting MySQL service..."
systemctl start mysql.service

# Check service status
systemctl status mysql.service --no-pager

echo "MySQL setup and service configuration complete!"
