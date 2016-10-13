From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/32] iwpmd: fix the prototype for the pthread_create start functions
Date: Thu, 13 Oct 2016 19:51:15 +0200
Message-ID: <1476381095-20041-13-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

And also remove the unessecary taking of the address for function
arguments while we're at it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm_server.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index b8ae3e3..ab90c6c 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -87,7 +87,7 @@ static void iwpm_signal_handler(int signum)
 /**
  * iwpm_mapping_reqs_handler - Handle mapping requests timeouts and retries
  */
-static void *iwpm_mapping_reqs_handler(void)
+static void *iwpm_mapping_reqs_handler(void *unused)
 {
 	iwpm_mapping_request *iwpm_map_req, *next_map_req;
 	int ret = 0;
@@ -139,7 +139,7 @@ mapping_reqs_handler_exit:
 /**
  * iwpm_pending_msgs_handler - Handle sending iwarp port mapper wire messages
  */
-static void *iwpm_pending_msgs_handler(void)
+static void *iwpm_pending_msgs_handler(void *unused)
 {
 	iwpm_pending_msg *pending_msg;
 	iwpm_send_msg *send_msg;
@@ -1438,11 +1438,11 @@ int main(int argc, char *argv[])
 	pthread_cond_init(&cond_req_complete, NULL);
 	pthread_cond_init(&cond_pending_msg, NULL);
 
-	ret = pthread_create(&map_req_thread, NULL, &iwpm_mapping_reqs_handler, NULL);
+	ret = pthread_create(&map_req_thread, NULL, iwpm_mapping_reqs_handler, NULL);
 	if (ret)
 		goto error_exit;
 
-	ret = pthread_create(&pending_msg_thread, NULL, &iwpm_pending_msgs_handler, NULL);
+	ret = pthread_create(&pending_msg_thread, NULL, iwpm_pending_msgs_handler, NULL);
 	if (ret)
 		goto error_exit;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
