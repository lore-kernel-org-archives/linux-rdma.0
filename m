From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] RDMA/nes: Fix for passing a valid QP pointer to the user
 space library
Date: Tue, 11 Mar 2014 14:20:17 -0500
Message-ID: <20140311192017.GA18980@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for passing a valid QP pointer to the user space library

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c    |    2 +-
 drivers/infiniband/hw/nes/nes_user.h  |    5 +++--
 drivers/infiniband/hw/nes/nes_verbs.c |    2 ++
 drivers/infiniband/hw/nes/nes_verbs.h |    1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index e852a3a..dfa9df4 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -657,7 +657,7 @@ static void build_rdma0_msg(struct nes_cm_node *cm_node, struct nes_qp **nesqp_a
 	struct nes_qp *nesqp = *nesqp_addr;
 	struct nes_hw_qp_wqe *wqe = &nesqp->hwqp.sq_vbase[0];
 
-	u64temp = (unsigned long)nesqp;
+	u64temp = (unsigned long)nesqp->nesuqp_addr;
 	u64temp |= NES_SW_CONTEXT_ALIGN >> 1;
 	set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX, u64temp);
 
diff --git a/drivers/infiniband/hw/nes/nes_user.h b/drivers/infiniband/hw/nes/nes_user.h
index 4926de7..529c421 100644
--- a/drivers/infiniband/hw/nes/nes_user.h
+++ b/drivers/infiniband/hw/nes/nes_user.h
@@ -39,8 +39,8 @@
 
 #include <linux/types.h>
 
-#define NES_ABI_USERSPACE_VER 1
-#define NES_ABI_KERNEL_VER    1
+#define NES_ABI_USERSPACE_VER 2
+#define NES_ABI_KERNEL_VER    2
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -78,6 +78,7 @@ struct nes_create_cq_req {
 
 struct nes_create_qp_req {
 	__u64 user_wqe_buffers;
+	__u64 user_qp_buffer;
 };
 
 enum iwnes_memreg_type {
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8308e36..797d887 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1191,6 +1191,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 				if (req.user_wqe_buffers) {
 					virt_wqs = 1;
 				}
+				if (req.user_qp_buffer)
+					nesqp->nesuqp_addr = req.user_qp_buffer;
 				if ((ibpd->uobject) && (ibpd->uobject->context)) {
 					nesqp->user_mode = 1;
 					nes_ucontext = to_nesucontext(ibpd->uobject->context);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 0eff7c4..309b31c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -184,5 +184,6 @@ struct nes_qp {
 	u8                    pau_busy;
 	u8                    pau_pending;
 	u8                    pau_state;
+	__u64                 nesuqp_addr;
 };
 #endif			/* NES_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
