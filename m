From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 2/5] verbs: Introduce tag matching SRQ
Date: Mon, 12 Jun 2017 09:42:44 +0300
Message-ID: <1497249767-15353-3-git-send-email-artemyko@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497249767-15353-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introducing tag matching SRQ (TM-SRQ), which retains basic semantic of
regular SRQ, reports completions to own CQ, and has additional tag
based message receiving mechanism.

Change-Id: Ic527680984f343608507ba2162147435be2f7aee
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 43fa386..120471a 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -666,7 +666,8 @@ struct ibv_srq_init_attr {
 
 enum ibv_srq_type {
 	IBV_SRQT_BASIC,
-	IBV_SRQT_XRC
+	IBV_SRQT_XRC,
+	IBV_SRQT_TAG_MATCHING
 };
 
 enum ibv_srq_init_attr_mask {
@@ -674,7 +675,13 @@ enum ibv_srq_init_attr_mask {
 	IBV_SRQ_INIT_ATTR_PD		= 1 << 1,
 	IBV_SRQ_INIT_ATTR_XRCD		= 1 << 2,
 	IBV_SRQ_INIT_ATTR_CQ		= 1 << 3,
-	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 4
+	IBV_SRQ_INIT_ATTR_TAG_MATCHING  = 1 << 4,
+	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 5
+};
+
+struct ibv_tm_cap {
+	uint32_t		max_num_tags;
+	uint32_t		max_ops;
 };
 
 struct ibv_srq_init_attr_ex {
@@ -686,6 +693,7 @@ struct ibv_srq_init_attr_ex {
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
 	struct ibv_cq	       *cq;
+	struct ibv_tm_cap	tm_cap;
 };
 
 enum ibv_wq_type {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
