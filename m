From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 5/5] srp_daemon.service: Add support for hot-plugging
Date: Mon, 15 May 2017 15:47:33 -0700
Message-ID: <20170515224733.29586-12-bart.vanassche@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515224733.29586-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

srp_daemon.service is modified such that instead of starting
/usr/sbin/srp_daemon.sh that it does not start any process. A new
template service is added, namely srp_daemon_port@.service. This
service replaces srp_daemon.sh and controls /usr/sbin/srp_daemon
for a single port. A udev rule is added that instantiates the
srp_daemon_port@.service every time an RDMA port is hot-added.
Since the per-port service depends on the srp_daemon service,
starting or stopping the srp_daemon service affects all per-port
services.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 debian/srptools.install               |  5 ++++
 redhat/rdma-core.spec                 |  5 +++-
 srp_daemon/90-srp-daemon.rules        |  1 +
 srp_daemon/CMakeLists.txt             |  5 ++++
 srp_daemon/srp_daemon.service         | 12 ++++-----
 srp_daemon/srp_daemon.service.5       | 30 +++++++++++++++++++++++
 srp_daemon/srp_daemon_port@.service   | 18 ++++++++++++++
 srp_daemon/srp_daemon_port@.service.5 | 46 +++++++++++++++++++++++++++++++++++
 8 files changed, 114 insertions(+), 8 deletions(-)
 create mode 100644 srp_daemon/90-srp-daemon.rules
 create mode 100644 srp_daemon/srp_daemon.service.5
 create mode 100644 srp_daemon/srp_daemon_port@.service
 create mode 100644 srp_daemon/srp_daemon_port@.service.5

diff --git a/debian/srptools.install b/debian/srptools.install
index ecec5d9a..81dbd4cd 100644
--- a/debian/srptools.install
+++ b/debian/srptools.install
@@ -1,6 +1,11 @@
 etc/srp_daemon.conf
+lib/systemd/system/srp_daemon.service
+lib/systemd/system/srp_daemon_port@.service
+lib/udev/rules.d/90-srp-daemon.rules
 usr/sbin/ibsrpdm
 usr/sbin/srp_daemon
 usr/share/doc/rdma-core/ibsrpdm.md usr/share/doc/srptools/
 usr/share/man/man1/ibsrpdm.1
 usr/share/man/man1/srp_daemon.1
+usr/share/man/man5/srp_daemon.service.5
+usr/share/man/man5/srp_daemon_port@.service.5
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 993a6c80..fc9edaa1 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -439,10 +439,13 @@ rm -rf %{buildroot}/%{_initrddir}/
 %files -n srp_daemon
 %config(noreplace) %{_sysconfdir}/srp_daemon.conf
 %{_unitdir}/srp_daemon.service
+%{_unitdir}/srp_daemon_port@.service
 %{_sbindir}/ibsrpdm
 %{_sbindir}/srp_daemon
-%{_sbindir}/srp_daemon.sh
 %{_sbindir}/run_srp_daemon
+%{_udevrulesdir}/90-srp-daemon.rules
 %{_mandir}/man1/ibsrpdm.1*
 %{_mandir}/man1/srp_daemon.1*
+%{_mandir}/man5/srp_daemon.service.5*
+%{_mandir}/man5/srp_daemon_port@.service.5*
 %doc %{_docdir}/%{name}-%{version}/ibsrpdm.md
diff --git a/srp_daemon/90-srp-daemon.rules b/srp_daemon/90-srp-daemon.rules
new file mode 100644
index 00000000..6d6788f0
--- /dev/null
+++ b/srp_daemon/90-srp-daemon.rules
@@ -0,0 +1 @@
+ACTION=="add", SUBSYSTEM=="infiniband_mad", PROGRAM:="/usr/bin/systemctl show srp_daemon -p UnitFileState", RESULT=="UnitFileState=enabled", TAG+="systemd", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index 24e4c30d..39f4bc99 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -3,6 +3,8 @@ set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
 rdma_man_pages(
   ibsrpdm.1
   srp_daemon.1.in
+  srp_daemon.service.5
+  srp_daemon_port@.service.5
   )
 
 rdma_sbin_executable(srp_daemon
@@ -28,6 +30,9 @@ rdma_subst_install(FILES "srp_daemon.sh.in"
 install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
 install(FILES srp_daemon.service DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+install(FILES srp_daemon_port@.service DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+
+install(FILES 90-srp-daemon.rules DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
 # FIXME: The ib init.d file should really be included in rdma-core as well.
 set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
diff --git a/srp_daemon/srp_daemon.service b/srp_daemon/srp_daemon.service
index 9510f5fb..5bcb1d53 100644
--- a/srp_daemon/srp_daemon.service
+++ b/srp_daemon/srp_daemon.service
@@ -1,17 +1,15 @@
 [Unit]
-Description=Start or stop the daemon that attaches to SRP devices
+Description=Daemon that discovers and logs in to SRP target systems
 Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
-Requires=rdma.service
-Wants=opensm.service
-After=rdma.service opensm.service
-After=network.target
 Before=remote-fs-pre.target
 
 [Service]
-Type=simple
-ExecStart=/usr/sbin/srp_daemon.sh
+Type=oneshot
+RemainAfterExit=yes
+ExecStart=/bin/true
+ExecStop=/bin/true
 
 [Install]
 WantedBy=remote-fs-pre.target
diff --git a/srp_daemon/srp_daemon.service.5 b/srp_daemon/srp_daemon.service.5
new file mode 100644
index 00000000..a6b25d6a
--- /dev/null
+++ b/srp_daemon/srp_daemon.service.5
@@ -0,0 +1,30 @@
+'\" t
+.TH "SRP_DAEMON\&.SERVICE" "5" "" "srp_daemon" "srp_daemon.service"
+.\" -----------------------------------------------------------------
+.\" * set default formatting
+.\" -----------------------------------------------------------------
+.\" disable hyphenation
+.nh
+.\" disable justification (adjust text to left margin only)
+.ad l
+.\" -----------------------------------------------------------------
+.\" * MAIN CONTENT STARTS HERE *
+.\" -----------------------------------------------------------------
+.SH "NAME"
+srp_daemon.service \- srp_daemon systemd service that controls all ports
+.SH "SYNOPSIS"
+.PP
+srp_daemon\&.service
+.SH "DESCRIPTION"
+.PP
+The srp_daemon\&.service controls whether or not any srp_daemon processes are
+running. Although no srp_daemon processes are controlled directly by the
+srp_daemon\&.service, this service controls whether or not any
+srp_daemon_port@\&.service are allowed to be active. Each
+srp_daemon_port@\&.service controls one srp_daemon process.
+
+.SH "SEE ALSO"
+.PP
+\fBsrp_daemon\fR(1),
+\fBsrp_daemon_port@.service\fR(5),
+\fBsystemctl\fR(1)
diff --git a/srp_daemon/srp_daemon_port@.service b/srp_daemon/srp_daemon_port@.service
new file mode 100644
index 00000000..666400ab
--- /dev/null
+++ b/srp_daemon/srp_daemon_port@.service
@@ -0,0 +1,18 @@
+[Unit]
+Description=SRP daemon that monitors port %i
+Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
+DefaultDependencies=false
+Conflicts=emergency.target emergency.service
+Requires=rdma.service
+Wants=opensm.service
+After=rdma.service opensm.service srp_daemon.service
+After=network.target
+Before=remote-fs-pre.target
+BindsTo=srp_daemon.service
+
+[Service]
+Type=simple
+ExecStart=/usr/sbin/srp_daemon -e -c -n -j %I -R 60
+
+[Install]
+WantedBy=remote-fs-pre.target
diff --git a/srp_daemon/srp_daemon_port@.service.5 b/srp_daemon/srp_daemon_port@.service.5
new file mode 100644
index 00000000..a755b2eb
--- /dev/null
+++ b/srp_daemon/srp_daemon_port@.service.5
@@ -0,0 +1,46 @@
+'\" t
+.TH "SRP_DAEMON_PORT@\&.SERVICE" "5" "" "srp_daemon" "srp_daemon_port@.service"
+.\" -----------------------------------------------------------------
+.\" * set default formatting
+.\" -----------------------------------------------------------------
+.\" disable hyphenation
+.nh
+.\" disable justification (adjust text to left margin only)
+.ad l
+.\" -----------------------------------------------------------------
+.\" * MAIN CONTENT STARTS HERE *
+.\" -----------------------------------------------------------------
+.SH "NAME"
+srp_daemon_port@.service \- srp_daemon_port@ systemd service that controls a
+single port
+.SH "SYNOPSIS"
+.PP
+srp_daemon_port@\&.service
+.SH "DESCRIPTION"
+.PP
+The srp_daemon_port@\&.service controls whether or not an srp_daemon process
+is monitoring the RDMA port specified as template argument. The format for the
+RDMA port name is \fIdev:port\fR where \fIdev\fR is the name of an RDMA device
+and \fIport\fR is an port number starting from one. Starting an instance of
+this template will start an srp_daemon process. Stopping an instance of this
+template will stop the srp_daemon process for the specified port.  Here is an
+example of how to obtain a list of all RDMA device and port number pairs:
+.PP
+.nf
+.RS
+$ for p in /sys/class/infiniband/*/ports/*; do
+    echo $p | sed 's,/sys/class/infiniband/,,;s,/ports/,:,'
+  done
+mlx4_0:1
+mlx4_0:2
+mlx4_1:1
+mlx4_1:2
+.RE
+.fi
+.PP
+
+.SH "SEE ALSO"
+.PP
+\fBsrp_daemon\fR(1),
+\fBsrp_daemon.service\fR(5),
+\fBsystemctl\fR(1)
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
