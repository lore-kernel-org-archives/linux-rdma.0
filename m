From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/32] iwpmd: use proper ANSI-C prototypes for functions without arguments
Date: Thu, 13 Oct 2016 19:51:11 +0200
Message-ID: <1476381095-20041-9-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm_common.c |  2 +-
 iwpmd/iwarp_pm_server.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index 3a885d8..aa6b4a0 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -212,7 +212,7 @@ create_socket_v6_exit:
 /**
  * create_netlink_socket - Create netlink socket for the iwarp port mapper
  */
-int create_netlink_socket()
+int create_netlink_socket(void)
 {
 	sockaddr_union bind_addr;
 	struct sockaddr_nl *bind_nl;
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index deed3e7..89d3ee5 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -87,7 +87,7 @@ void iwpm_signal_handler(int signum)
 /**
  * iwpm_mapping_reqs_handler - Handle mapping requests timeouts and retries
  */
-void *iwpm_mapping_reqs_handler()
+void *iwpm_mapping_reqs_handler(void)
 {
 	iwpm_mapping_request *iwpm_map_req, *next_map_req;
 	int ret = 0;
@@ -139,7 +139,7 @@ mapping_reqs_handler_exit:
 /**
  * iwpm_pending_msgs_handler - Handle sending iwarp port mapper wire messages
  */
-void *iwpm_pending_msgs_handler()
+void *iwpm_pending_msgs_handler(void)
 {
 	iwpm_pending_msg *pending_msg;
 	iwpm_send_msg *send_msg;
@@ -1279,7 +1279,7 @@ static void iwpm_cleanup(void)
 /**
  * iwarp_port_mapper - Distribute work orders for processing different types of iwpm messages
  */
-static int iwarp_port_mapper()
+static int iwarp_port_mapper(void)
 {
 	fd_set select_fdset; /* read fdset */
 	struct timeval select_timeout;
@@ -1355,8 +1355,8 @@ iwarp_port_mapper_exit:
 
 /**
  * daemonize_iwpm_server - Make iwarp port mapper a daemon process
- */
-static void daemonize_iwpm_server()
+ */ 
+static void daemonize_iwpm_server(void)
 {
 	pid_t pid, sid;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
