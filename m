From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/32] iwpmd: mark symbols static where possible
Date: Thu, 13 Oct 2016 19:51:14 +0200
Message-ID: <1476381095-20041-12-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm_common.c |  6 +++---
 iwpmd/iwarp_pm_server.c | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index b20a368..ee9d119 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -39,9 +39,9 @@
 #endif
 
 /* iwpm config params */
-char * iwpm_param_names[IWPM_PARAM_NUM] = 
+static char * iwpm_param_names[IWPM_PARAM_NUM] =
 	{ "nl_sock_rbuf_size" };
-int iwpm_param_vals[IWPM_PARAM_NUM] = 
+static int iwpm_param_vals[IWPM_PARAM_NUM] =
 	{ 0 };
 
 /**
@@ -276,7 +276,7 @@ void destroy_iwpm_socket(int pm_sock)
 /**
  * check_iwpm_nlattr - Check for NULL netlink attribute
  */ 
-int check_iwpm_nlattr(struct nlattr *nltb[], int nla_count)
+static int check_iwpm_nlattr(struct nlattr *nltb[], int nla_count)
 { 
         int i, ret = 0;          
         for (i = 1; i < nla_count; i++) {
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index 89d3ee5..b8ae3e3 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -34,34 +34,34 @@
 #include "config.h"
 #include "iwarp_pm.h"
 
-const char iwpm_ulib_name [] = "iWarpPortMapperUser";
-int iwpm_version = 3;
+static const char iwpm_ulib_name [] = "iWarpPortMapperUser";
+static int iwpm_version = 3;
 
 LIST_HEAD(mapping_reqs);		      /* list of map tracking objects */
 LIST_HEAD(pending_messages);		      /* list of pending wire messages */
 iwpm_client client_list[IWARP_PM_MAX_CLIENTS];/* list of iwarp port mapper clients */
-int mapinfo_num_list[IWARP_PM_MAX_CLIENTS];   /* list of iwarp port mapper clients */
+static int mapinfo_num_list[IWARP_PM_MAX_CLIENTS];   /* list of iwarp port mapper clients */
 
 /* socket handles */
 static int pmv4_sock, pmv6_sock, netlink_sock, pmv4_client_sock, pmv6_client_sock;
 
-pthread_t map_req_thread; /* handling mapping requests timeout */
-pthread_cond_t cond_req_complete;
+static pthread_t map_req_thread; /* handling mapping requests timeout */
+pthread_cond_t cond_req_complete; 
 pthread_mutex_t map_req_mutex = PTHREAD_MUTEX_INITIALIZER;
 int wake = 0; /* set if map_req_thread is wake */
 
-pthread_t pending_msg_thread; /* sending iwpm wire messages */
+static pthread_t pending_msg_thread; /* sending iwpm wire messages */
 pthread_cond_t cond_pending_msg;
 pthread_mutex_t pending_msg_mutex = PTHREAD_MUTEX_INITIALIZER;
 
 static void iwpm_cleanup(void);
-int print_mappings = 0;
+static int print_mappings = 0;
 
 /**
  * iwpm_signal_handler - Handle signals which iwarp port mapper receives
  * @signum: the number of the caught signal
  */
-void iwpm_signal_handler(int signum)
+static void iwpm_signal_handler(int signum)
 {
 	switch(signum) {
 		case SIGHUP:
@@ -87,7 +87,7 @@ void iwpm_signal_handler(int signum)
 /**
  * iwpm_mapping_reqs_handler - Handle mapping requests timeouts and retries
  */
-void *iwpm_mapping_reqs_handler(void)
+static void *iwpm_mapping_reqs_handler(void)
 {
 	iwpm_mapping_request *iwpm_map_req, *next_map_req;
 	int ret = 0;
@@ -139,7 +139,7 @@ mapping_reqs_handler_exit:
 /**
  * iwpm_pending_msgs_handler - Handle sending iwarp port mapper wire messages
  */
-void *iwpm_pending_msgs_handler(void)
+static void *iwpm_pending_msgs_handler(void)
 {
 	iwpm_pending_msg *pending_msg;
 	iwpm_send_msg *send_msg;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
