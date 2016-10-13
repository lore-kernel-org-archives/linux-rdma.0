From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/32] iwpmd: move external declarations to iwarp_pm.h
Date: Thu, 13 Oct 2016 19:51:13 +0200
Message-ID: <1476381095-20041-11-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm.h        | 8 ++++++++
 iwpmd/iwarp_pm_common.c | 2 --
 iwpmd/iwarp_pm_helper.c | 6 ------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 1a2b69a..766e34f 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -277,4 +277,12 @@ void free_iwpm_mapped_ports(void);
 extern struct list_head pending_messages;
 extern struct list_head mapping_reqs;
 
+extern iwpm_client client_list[IWARP_PM_MAX_CLIENTS];
+
+extern pthread_cond_t cond_req_complete;
+extern pthread_mutex_t map_req_mutex;
+extern int wake;
+extern pthread_cond_t cond_pending_msg;
+extern pthread_mutex_t pending_msg_mutex;
+
 #endif
diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index aa6b4a0..b20a368 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -44,8 +44,6 @@ char * iwpm_param_names[IWPM_PARAM_NUM] =
 int iwpm_param_vals[IWPM_PARAM_NUM] = 
 	{ 0 };
 
-extern iwpm_client client_list[IWARP_PM_MAX_CLIENTS];
-
 /**
  * get_iwpm_param()
  */
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index 0b115c8..63530f1 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -35,12 +35,6 @@
 
 static LIST_HEAD(mapped_ports);		/* list of mapped ports */
 
-extern pthread_cond_t cond_req_complete;
-extern pthread_mutex_t map_req_mutex;
-extern int wake; /* set if map_req_thread is wake */
-extern pthread_cond_t cond_pending_msg;
-extern pthread_mutex_t pending_msg_mutex;
-
 /**
  * create_iwpm_map_request - Create a new map request tracking object
  * @req_nlh: netlink header of the received client message
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
