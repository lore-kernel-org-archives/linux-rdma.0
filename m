From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/7] ibverbs: Add an option to poll cvlan value from a CQ
Date: Tue, 14 Mar 2017 13:15:40 +0200
Message-ID: <1489490143-29018-5-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a WQ or a QP is created with cvlan stripping option, it is
stripped from the incoming packet and included in the work
completion.
Extend the poll_cq_ex mechanism with a function that reads the
stripped cvlan value from the work completion.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index c9084ea..15e93b3 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -435,6 +435,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_SL		= 1 << 5,
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 6,
 	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 7,
+	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
 };
 
 enum {
@@ -449,7 +450,8 @@ enum {
 
 enum {
 	IBV_CREATE_CQ_SUP_WC_FLAGS = IBV_WC_STANDARD_FLAGS |
-				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
+				IBV_WC_EX_WITH_CVLAN
 };
 
 enum ibv_wc_flags {
@@ -1092,6 +1094,7 @@ struct ibv_cq_ex {
 	uint8_t (*read_sl)(struct ibv_cq_ex *current);
 	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
 	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
+	uint16_t (*read_cvlan)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1170,6 +1173,11 @@ static inline uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex *cq)
 	return cq->read_completion_ts(cq);
 }
 
+static inline uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex *cq)
+{
+	return cq->read_cvlan(cq);
+}
+
 static inline int ibv_post_wq_recv(struct ibv_wq *wq,
 				   struct ibv_recv_wr *recv_wr,
 				   struct ibv_recv_wr **bad_recv_wr)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
