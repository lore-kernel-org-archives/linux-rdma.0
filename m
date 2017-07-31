From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/6] ibacm: Support systemd socket activation
Date: Mon, 31 Jul 2017 14:25:45 -0600
Message-ID: <1501532745-28378-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This lets systemd create the socket (to the admin's specifications) and
starts ibacm when something connects to it.

We are using this to improve boot ordering by ensuring that any rdma_cm
clients that would use ibacm block until ibacm is started up properly.
A user could also use this to demand start ibacm, but that means it
would not plug into kernel RMDA local services for caching.

For security, the socket will be created on the lo interface by default.
The admin can change this back to the old daemon behavior with a systemd
drop in.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/ibacm.install   |  1 +
 ibacm/CMakeLists.txt   |  6 ++++++
 ibacm/ibacm.service.in |  4 +++-
 ibacm/ibacm.socket     | 10 ++++++++++
 ibacm/man/ibacm.1      |  4 ++++
 ibacm/src/acm.c        | 54 +++++++++++++++++++++++++++++++++++++++++++++-----
 redhat/rdma-core.spec  |  1 +
 7 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100644 ibacm/ibacm.socket

diff --git a/debian/ibacm.install b/debian/ibacm.install
index 41cf5badb3e6c8..d3ed2a2e8f2dc7 100644
--- a/debian/ibacm.install
+++ b/debian/ibacm.install
@@ -1,5 +1,6 @@
 etc/init.d/ibacm
 lib/systemd/system/ibacm.service
+lib/systemd/system/ibacm.socket
 usr/bin/ib_acme
 usr/include/infiniband/acm.h
 usr/include/infiniband/acm_prov.h
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 75869968534438..5d54411027cc8e 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -16,6 +16,7 @@ rdma_sbin_executable(ibacm
 target_link_libraries(ibacm LINK_PRIVATE
   ibverbs
   ibumad
+  ${SYSTEMD_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   ${CMAKE_DL_LIBS}
   )
@@ -68,3 +69,8 @@ rdma_subst_install(FILES "ibacm.service.in"
   DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
   RENAME ibacm.service
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES "ibacm.socket"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  RENAME ibacm.socket
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index eb74c673552cb4..7f31ba673da979 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -2,9 +2,11 @@
 Description=InfiniBand Address Cache Manager Daemon
 Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
 After=opensm.service
+Wants=ibacm.socket
 
 [Service]
-ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm -P
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm --systemd
 
 [Install]
+Also=ibacm.socket
 WantedBy=network.target
diff --git a/ibacm/ibacm.socket b/ibacm/ibacm.socket
new file mode 100644
index 00000000000000..080257e9c7c320
--- /dev/null
+++ b/ibacm/ibacm.socket
@@ -0,0 +1,10 @@
+[Unit]
+Description=Socket for InfiniBand Address Cache Manager Daemon
+Documentation=man:ibacm
+
+[Socket]
+ListenStream=6125
+BindToDevice=lo
+
+[Install]
+WantedBy=sockets.target
diff --git a/ibacm/man/ibacm.1 b/ibacm/man/ibacm.1
index 5042e1ed88ac34..733dc64dde1910 100644
--- a/ibacm/man/ibacm.1
+++ b/ibacm/man/ibacm.1
@@ -50,6 +50,10 @@ address configuration file
 .TP
 \-O option_file
 option configuration file
+.TP
+\--systemd
+Enable systemd integration. This includes optional socket activation of the daemon's
+listening socket.
 .SH "QUICK START GUIDE"
 1. Prerequisites: libibverbs and libibumad must be installed.
 The IB stack should be running with IPoIB configured.
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index e5cfdcb8726a8f..3f28f04d8777b9 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -59,6 +59,8 @@
 #include <rdma/ib_user_sa.h>
 #include <poll.h>
 #include <inttypes.h>
+#include <getopt.h>
+#include <systemd/sd-daemon.h>
 #include <ccan/list.h>
 #include <util/util.h>
 #include "acm_mad.h"
@@ -599,6 +601,35 @@ static int acm_listen(void)
 	return 0;
 }
 
+/* Retrieve the listening socket from systemd. */
+static int acm_listen_systemd(void)
+{
+	int rc = sd_listen_fds(1);
+	if (rc == 0) {
+		/* We are in systemd mode but no FDs were passed? Fall back to
+		 * normal mode
+		 */
+		return acm_listen();
+	}
+	if (rc == -1) {
+		fprintf(stderr, "sd_listen_fds failed %d\n", rc);
+		return rc;
+	}
+
+	if (rc != 1) {
+		fprintf(stderr, "sd_listen_fds returned %d fds, expected 1\n", rc);
+		return -1;
+	}
+
+	if (!sd_is_socket(SD_LISTEN_FDS_START, AF_UNSPEC, SOCK_STREAM, 1)) {
+		fprintf(stderr, "sd_listen_fds socket is not a SOCK_STREAM listening socket\n");
+		return -1;
+	}
+
+	listen_socket = SD_LISTEN_FDS_START;
+	return 0;
+}
+
 static void acm_disconnect_client(struct acmc_client *client)
 {
 	pthread_mutex_lock(&client->lock);
@@ -1669,7 +1700,7 @@ static int acm_init_nl(void)
 	return 0;
 }
 
-static void acm_server(void)
+static void acm_server(bool systemd)
 {
 	fd_set readfds;
 	int i, n, ret;
@@ -1677,7 +1708,10 @@ static void acm_server(void)
 
 	acm_log(0, "started\n");
 	acm_init_server();
-	ret = acm_listen();
+	if (systemd)
+		ret = acm_listen_systemd();
+	else
+		ret = acm_listen();
 	if (ret) {
 		acm_log(0, "ERROR - server listen failed\n");
 		return;
@@ -2949,8 +2983,15 @@ static void show_usage(char *program)
 int main(int argc, char **argv)
 {
 	int i, op, as_daemon = 1;
+	bool systemd = false;
+
+	static const struct option long_opts[] = {
+		{"systemd", 0, NULL, 's'},
+		{}
+	};
 
-	while ((op = getopt(argc, argv, "DPA:O:")) != -1) {
+	while ((op = getopt_long(argc, argv, "DPA:O:", long_opts, NULL)) !=
+	       -1) {
 		switch (op) {
 		case 'D':
 			/* option no longer required */
@@ -2964,13 +3005,16 @@ int main(int argc, char **argv)
 		case 'O':
 			opts_file = optarg;
 			break;
+		case 's':
+			systemd = true;
+			break;
 		default:
 			show_usage(argv[0]);
 			exit(1);
 		}
 	}
 
-	if (as_daemon) {
+	if (as_daemon && !systemd) {
 		if (daemon(0, 0))
 			return EXIT_FAILURE;
 	}
@@ -3013,7 +3057,7 @@ int main(int argc, char **argv)
 	}
 	acm_activate_devices();
 	acm_log(1, "starting server\n");
-	acm_server();
+	acm_server(systemd);
 
 	acm_log(0, "shutting down\n");
 	if (client_array[NL_CLIENT_INDEX].sock != -1)
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index e5a59e073b7afd..71eae0cf8c2f78 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -389,6 +389,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %{_mandir}/man7/ibacm.*
 %{_mandir}/man7/ibacm_prov.*
 %{_unitdir}/ibacm.service
+%{_unitdir}/ibacm.socket
 %dir %{_libdir}/ibacm
 %{_libdir}/ibacm/*
 %doc %{_docdir}/%{name}-%{version}/ibacm.md
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
