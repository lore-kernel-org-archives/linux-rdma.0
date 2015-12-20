From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs 1/3] libibverbs: Add CQ ignore overrun creation flag
Date: Sun, 20 Dec 2015 13:22:42 +0200
Message-ID: <1450610564-17279-2-git-send-email-leon@leon.nu>
References: <1450610564-17279-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610564-17279-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A CQ overrun is checked while posting a completion, and if
encountered, the QP is transferred to the appropriate error
state.

CQ update (and error discovery) are not synchronized with
WQE execution. Thus, a positive acknowledgement can be sent
to the remote request, and subsequently a CQ overrun may be
detected. Hardware may not write the CQE as a result of the
error, and the CQ will be transitioned to an error state as
well as the QP that caused the CQ error.

To avoid these errors, software usually ensures that the
number of WQEs posted to a QP does not exceed the number
of entries in the CQ associated with this QP. When multiple
QPs post completions into the same CQ, this check is cumulative.

CQ ignore overrun flag instructs the HW doesn't ring doorbells
on updates of CQ consumer counter (poll for completion) or
request completion notifications (Arm CQ).

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |  7 ++++---
 man/ibv_create_cq_ex.3     | 10 ++++++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index c3e863850d4e..d8069d52ae13 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1201,12 +1201,13 @@ struct ibv_context {
 };
 
 enum ibv_create_cq_attr {
-	IBV_CREATE_CQ_ATTR_FLAGS	= 1 << 0,
-	IBV_CREATE_CQ_ATTR_RESERVED	= 1 << 1
+	IBV_CREATE_CQ_ATTR_FLAGS        = 1 << 0,
+	IBV_CREATE_CQ_ATTR_RESERVED     = 1 << 1
 };
 
 enum ibv_create_cq_attr_flags {
-	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP = 1 << 0,
+	IBV_CREATE_CQ_ATTR_IGNORE_OVERRUN       = 1 << 1
 };
 
 struct ibv_create_cq_attr_ex {
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
index 9f9e049b0d43..8670bd0a828b 100644
--- a/man/ibv_create_cq_ex.3
+++ b/man/ibv_create_cq_ex.3
@@ -42,13 +42,19 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SLID                  = 1 << 7,  /* Require slid in WC */
         IBV_WC_EX_WITH_SL                    = 1 << 8,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 9,  /* Require dlid path bits in WC */
-        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 10, /* Require completion timestamp in WC /*
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 10, /* Require completion timestamp in WC */
 };
 
+enum ibv_create_cq_attr_flags {
+	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_IGNORE_OVERRUN	= 1 << 1
+};
 
 enum ibv_create_cq_attr {
-        IBV_CREATE_CQ_ATTR_FLAGS             = 1 << 0,
+	IBV_CREATE_CQ_ATTR_FLAGS	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_RESERVED	= 1 << 1
 };
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
