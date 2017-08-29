From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/4] ibacm: Allow systemd to also setup the RDMA_LS socket for ibacm
Date: Tue, 29 Aug 2017 09:58:45 -0600
Message-ID: <1504022325-31039-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504022325-31039-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504022325-31039-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This makes sure that very early queries from the kernel can be
delivered to ibacm even before it starts.

Requires trivial systemd patch:
 5570d7f95612 ("Support 'rdma' as a ListenNetlink= argument (#6626)")
Which is present starting in systemd v235

Old systemd's just ignore the netlink listen.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/ibacm.socket |  4 +++
 ibacm/src/acm.c    | 79 ++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/ibacm/ibacm.socket b/ibacm/ibacm.socket
index aa94c91d60daf1..bdf1f9f4e85fe1 100644
--- a/ibacm/ibacm.socket
+++ b/ibacm/ibacm.socket
@@ -10,6 +10,10 @@ Before=rdma-hw.target
 ListenStream=6125
 BindToDevice=lo
 
+# Bind to PF_NETLINK, NETLINK_RDMA, RDMA_NL_GROUP_LS
+# Supported in systemd > 234
+ListenNetlink=rdma 4
+
 [Install]
 # Standard for all sockets
 WantedBy=sockets.target
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 08937345a0c112..367a43fe9ad1ea 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -604,29 +604,56 @@ static int acm_listen(void)
 /* Retrieve the listening socket from systemd. */
 static int acm_listen_systemd(void)
 {
+	int fd;
+
 	int rc = sd_listen_fds(1);
-	if (rc == 0) {
-		/* We are in systemd mode but no FDs were passed? Fall back to
-		 * normal mode
-		 */
-		return acm_listen();
-	}
 	if (rc == -1) {
 		fprintf(stderr, "sd_listen_fds failed %d\n", rc);
 		return rc;
 	}
 
-	if (rc != 1) {
-		fprintf(stderr, "sd_listen_fds returned %d fds, expected 1\n", rc);
+	if (rc > 2) {
+		fprintf(stderr,
+			"sd_listen_fds returned %d fds, expected <= 2\n", rc);
 		return -1;
 	}
 
-	if (!sd_is_socket(SD_LISTEN_FDS_START, AF_UNSPEC, SOCK_STREAM, 1)) {
-		fprintf(stderr, "sd_listen_fds socket is not a SOCK_STREAM listening socket\n");
-		return -1;
+	for (fd = SD_LISTEN_FDS_START; fd != SD_LISTEN_FDS_START + rc; fd++) {
+		if (sd_is_socket(fd, AF_NETLINK, SOCK_RAW, 0)) {
+			/* ListenNetlink for RDMA_NL_GROUP_LS multicast
+			 * messages from the kernel
+			 */
+			if (client_array[NL_CLIENT_INDEX].sock != -1) {
+				fprintf(stderr,
+					"sd_listen_fds returned more than one netlink socket\n");
+				return -1;
+			}
+			client_array[NL_CLIENT_INDEX].sock = fd;
+
+			/* systemd sets NONBLOCK on the netlink socket, while
+			 * we want blocking send to the kernel.
+			 */
+			if (set_fd_nonblock(fd, false)) {
+				fprintf(stderr,
+					"Unable to drop O_NOBLOCK on netlink socket");
+				return -1;
+			}
+		} else if (sd_is_socket(SD_LISTEN_FDS_START, AF_UNSPEC,
+					SOCK_STREAM, 1)) {
+			/* Socket for user space client communication */
+			if (listen_socket != -1) {
+				fprintf(stderr,
+					"sd_listen_fds returned more than one listening socket\n");
+				return -1;
+			}
+			listen_socket = fd;
+		} else {
+			fprintf(stderr,
+				"sd_listen_fds socket is not a SOCK_STREAM/SOCK_NETLINK listening socket\n");
+			return -1;
+		}
 	}
 
-	listen_socket = SD_LISTEN_FDS_START;
 	return 0;
 }
 
@@ -1708,18 +1735,30 @@ static void acm_server(bool systemd)
 
 	acm_log(0, "started\n");
 	acm_init_server();
-	if (systemd)
+
+	client_array[NL_CLIENT_INDEX].sock = -1;
+	listen_socket = -1;
+	if (systemd) {
 		ret = acm_listen_systemd();
-	else
+		if (ret) {
+			acm_log(0, "ERROR - systemd server listen failed\n");
+			return;
+		}
+	}
+
+	if (listen_socket == -1) {
 		ret = acm_listen();
-	if (ret) {
-		acm_log(0, "ERROR - server listen failed\n");
-		return;
+		if (ret) {
+			acm_log(0, "ERROR - server listen failed\n");
+			return;
+		}
 	}
 
-	ret = acm_init_nl();
-	if (ret)
-		acm_log(1, "Warn - Netlink init failed\n");
+	if (client_array[NL_CLIENT_INDEX].sock == -1) {
+		ret = acm_init_nl();
+		if (ret)
+			acm_log(1, "Warn - Netlink init failed\n");
+	}
 
 	if (systemd)
 		sd_notify(0, "READY=1");
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
