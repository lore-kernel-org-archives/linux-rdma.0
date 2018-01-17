From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/5] verbs: Add support to read completion's timestamp in wall clock nanoseconds
Date: Wed, 17 Jan 2018 15:51:32 +0200
Message-ID: <1516197093-20699-5-git-send-email-yishaih@mellanox.com>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to read completion timestamp and convert it from
HCA clock units to wallclock nanoseconds.

This commit revises the documentation for ibv_wc_read_completion_ts
to clarify the return value time units.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3 |  9 +++++++--
 libibverbs/verbs.h                | 10 +++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index 23f867c..51a6eb5 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -40,9 +40,10 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SLID                  = 1 << 4,  /* Require slid in WC */
         IBV_WC_EX_WITH_SL                    = 1 << 5,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 6,  /* Require dlid path bits in WC */
-        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require completion timestamp in WC /*
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require completion device timestamp in WC /*
         IBV_WC_EX_WITH_CVLAN                 = 1 << 8,  /* Require VLAN info in WC */
         IBV_WC_EX_WITH_FLOW_TAG		     = 1 << 9,  /* Require flow tag in WC */
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK  = 1 << 11, /* Require completion wallclock timestamp in WC */
 };
 
 enum ibv_cq_init_attr_mask {
@@ -132,7 +133,11 @@ Below members and functions are used in order to poll the current completion. Th
  Get the dlid_path_bits field from the current completion.
 
 .BI "uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex " "*cq"); \c
- Get the completion timestamp from the current completion.
+ Get the completion timestamp from the current completion in HCA clock units.
+
+.BI "uint64_t ibv_wc_read_completion_wallclock_ns(struct ibv_cq_ex " *cq ");
+Get the completion timestamp from the current completion and convert it
+from HCA clock units to wall clock nanoseconds.
 
 .BI "uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex " "*cq"); \c
  Get the CVLAN field from the current completion.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 997597a..ddda03b 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -466,6 +466,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
 	IBV_WC_EX_WITH_FLOW_TAG		= 1 << 9,
 	IBV_WC_EX_WITH_TM_INFO		= 1 << 10,
+	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK	= 1 << 11,
 };
 
 enum {
@@ -483,7 +484,8 @@ enum {
 				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
 				IBV_WC_EX_WITH_CVLAN |
 				IBV_WC_EX_WITH_FLOW_TAG |
-				IBV_WC_EX_WITH_TM_INFO
+				IBV_WC_EX_WITH_TM_INFO |
+				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK
 };
 
 enum ibv_wc_flags {
@@ -1205,6 +1207,7 @@ struct ibv_cq_ex {
 	uint32_t (*read_flow_tag)(struct ibv_cq_ex *current);
 	void (*read_tm_info)(struct ibv_cq_ex *current,
 			     struct ibv_wc_tm_info *tm_info);
+	uint64_t (*read_completion_wallclock_ns)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1307,6 +1310,11 @@ static inline uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex *cq)
 	return cq->read_completion_ts(cq);
 }
 
+static inline uint64_t ibv_wc_read_completion_wallclock_ns(struct ibv_cq_ex *cq)
+{
+	return cq->read_completion_wallclock_ns(cq);
+}
+
 static inline uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex *cq)
 {
 	return cq->read_cvlan(cq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
