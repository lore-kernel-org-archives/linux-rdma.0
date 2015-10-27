From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 4/5] Add completion timestmap support for ibv_poll_cq_ex
Date: Tue, 27 Oct 2015 18:51:39 +0200
Message-ID: <1445964700-13235-5-git-send-email-matanb@mellanox.com>
References: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964700-13235-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for raw completion timestamp through ibv_poll_cq_ex.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 7 ++++++-
 man/ibv_poll_cq_ex.3       | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index f80126a..3d66726 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -391,6 +391,7 @@ enum ibv_wc_flags_ex {
 	IBV_WC_EX_WITH_SLID		= 1 << 7,
 	IBV_WC_EX_WITH_SL		= 1 << 8,
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
+	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP = 1 << 10,
 };
 
 enum {
@@ -409,6 +410,10 @@ enum {
 };
 
 /* fields order in wc_ex
+ *	// Raw timestamp of completion. A raw timestamp is implementation
+ *	// defined and can not be relied upon to have any ordering value
+ *	// between more than one HCA or driver.
+ *	uint64_t		completion_timestamp;
  *	uint32_t		byte_len,
  *	uint32_t		imm_data;	// in network byte order
  *	uint32_t		qp_num;
@@ -420,7 +425,7 @@ enum {
  */
 
 enum {
-	IBV_WC_EX_WITH_64BIT_FIELDS = 0
+	IBV_WC_EX_WITH_64BIT_FIELDS = IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
 };
 
 enum {
diff --git a/man/ibv_poll_cq_ex.3 b/man/ibv_poll_cq_ex.3
index 8f336bc..3eb9bc0 100644
--- a/man/ibv_poll_cq_ex.3
+++ b/man/ibv_poll_cq_ex.3
@@ -54,12 +54,14 @@ IBV_WC_EX_WITH_PKEY_INDEX               = 1 << 6,  /* The returned wc_ex contain
 IBV_WC_EX_WITH_SLID                     = 1 << 7,  /* The returned wc_ex contains slid field */
 IBV_WC_EX_WITH_SL                       = 1 << 8,  /* The returned wc_ex contains sl field */
 IBV_WC_EX_WITH_DLID_PATH_BITS           = 1 << 9,  /* The returned wc_ex contains dlid_path_bits field */
+IBV_WC_EX_WITH_COMPLETION_TIMESTAMP     = 1 << 10, /* The returned wc_ex contains completion_timestmap field */
 .in -8
 };
 
 .fi
 wc_flags describes which of the fields in buffer[0] have a valid value. The order of these fields and sizes are always the following:
 .nf
+uint64_t        completion_timestamp; /* Raw timestamp of completion. Implementation defined. Can't be relied upon to have any ordering value between more than one driver/hca */
 uint32_t        byte_len,
 uint32_t        imm_data;             /* in network byte order */
 uint32_t        qp_num;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
