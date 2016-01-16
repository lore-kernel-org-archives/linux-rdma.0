From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs V1 1/5] Add CQ ignore overrun flag
Date: Sat, 16 Jan 2016 17:53:40 +0200
Message-ID: <1452959624-29454-2-git-send-email-leon@leon.nu>
References: <1452959624-29454-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452959624-29454-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A CQ overrun is checked while posting a completion, and if
encountered, the QP is transferred to the appropriate error
state.

CQ update (and error discovery) are not synchronized with
WQE execution. In cross-channel mode, the send/receive
queues will forward their completions to managing QP.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |  1 +
 man/ibv_create_cq_ex.3     | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index c3e863850d4e..466d779592bf 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1207,6 +1207,7 @@ enum ibv_create_cq_attr {
 
 enum ibv_create_cq_attr_flags {
 	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_IGNORE_OVERRUN       = 1 << 1
 };
 
 struct ibv_create_cq_attr_ex {
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
index 9f9e049b0d43..f01a5513926b 100644
--- a/man/ibv_create_cq_ex.3
+++ b/man/ibv_create_cq_ex.3
@@ -1,6 +1,6 @@
 .\" -*- nroff -*-
 .\"
-.TH IBV_CREATE_CQ_EX 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.TH IBV_CREATE_CQ_EX 3 2015-12-27 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
 ibv_create_cq_ex \- create a completion queue (CQ)
 .SH "SYNOPSIS"
@@ -42,13 +42,19 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SLID                  = 1 << 7,  /* Require slid in WC */
         IBV_WC_EX_WITH_SL                    = 1 << 8,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 9,  /* Require dlid path bits in WC */
-        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 10, /* Require completion timestamp in WC /*
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 10, /* Require completion timestamp in WC */
 };
 
+enum ibv_create_cq_attr_flags {
+	IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP	= 1 << 0,
+	IBV_CREATE_CQ_ATTR_IGNORE_OVERRUN	= 1 << 1 /* Ignore completion queue overrun errors */
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
@@ -68,4 +74,8 @@ CQ should be destroyed with ibv_destroy_cq.
 .BR ibv_create_qp (3)
 .SH "AUTHORS"
 .TP
-Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+Matan Barak
+.RI < matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
+.TP
+Leon Romanovsky
+.RI < leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
