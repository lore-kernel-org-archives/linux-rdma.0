From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 1/8] verbs: Annotate ibv_wc helpers with endian
Date: Thu, 20 Jul 2017 11:00:57 -0600
Message-ID: <1500570064-11712-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500570064-11712-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This follows the scheme of used in the wc by introducing a
ibv_wc_read_invalidated_rkey to access the host endian
invalidated_rkey value with proper annotations.

This is just an inline wrapper to allow sparse to work sensibly,
not really a good reason to add another driver entry point.

Fixes: 32186550 ("verbs: Add be annotations to public headers")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3 |  5 ++++-
 libibverbs/verbs.h                | 13 +++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index 7dfbef28d2413b..e943e0e266c582 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -104,9 +104,12 @@ Below members and functions are used in order to poll the current completion. Th
 .BI "uint32_t ibv_wc_read_byte_len(struct ibv_cq_ex " "*cq"); \c
  Get the vendor error from the current completion.
 
-.BI "uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex " "*cq"); \c
+.BI "__be32 ibv_wc_read_imm_data(struct ibv_cq_ex " "*cq"); \c
  Get the immediate data field from the current completion.
 
+.BI "uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex " "*cq"); \c
+ Get the rkey invalided by the SEND_INVAL from the current completion.
+
 .BI "uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex " "*cq"); \c
  Get the QP number field from the current completion.
 
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 4f0765e0476db8..997ef248b26b62 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1093,7 +1093,7 @@ struct ibv_cq_ex {
 	enum ibv_wc_opcode (*read_opcode)(struct ibv_cq_ex *current);
 	uint32_t (*read_vendor_err)(struct ibv_cq_ex *current);
 	uint32_t (*read_byte_len)(struct ibv_cq_ex *current);
-	uint32_t (*read_imm_data)(struct ibv_cq_ex *current);
+	__be32 (*read_imm_data)(struct ibv_cq_ex *current);
 	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
 	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
 	int (*read_wc_flags)(struct ibv_cq_ex *current);
@@ -1141,11 +1141,20 @@ static inline uint32_t ibv_wc_read_byte_len(struct ibv_cq_ex *cq)
 	return cq->read_byte_len(cq);
 }
 
-static inline uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
+static inline __be32 ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
 {
 	return cq->read_imm_data(cq);
 }
 
+static inline uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex *cq)
+{
+#ifdef __CHECKER__
+	return (__attribute__((force)) uint32_t)cq->read_imm_data(cq);
+#else
+	return cq->read_imm_data(cq);
+#endif
+}
+
 static inline uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex *cq)
 {
 	return cq->read_qp_num(cq);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
