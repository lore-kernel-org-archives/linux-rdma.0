From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 10/20] IB/mlx5: Enhance UMR support to allow partial page table update
Date: Sun,  2 Mar 2014 12:49:28 +0200
Message-ID: <1393757378-16412-11-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current UMR interface doesn't allow partial updates to a memory region's
page tables. This patch changes the interface to allow that.

It also changes the way the UMR operation validates the memory region's state.
When set, IB_SEND_UMR_CHECK_FREE will cause the UMR operation to fail if the
MKEY is in the free state. When it is unchecked the operation will check that
it isn't in the free state.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 15 ++++++
 drivers/infiniband/hw/mlx5/mr.c      | 22 ++++----
 drivers/infiniband/hw/mlx5/qp.c      | 97 +++++++++++++++++++++++-------------
 include/linux/mlx5/device.h          |  9 ++++
 4 files changed, 100 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5054158..afe39e7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -111,6 +111,8 @@ struct mlx5_ib_pd {
  */
 
 #define MLX5_IB_SEND_UMR_UNREG	IB_SEND_RESERVED_START
+#define MLX5_IB_SEND_UMR_CHECK_FREE (IB_SEND_RESERVED_START << 1)
+#define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
 #define MLX5_IB_WR_UMR		IB_WR_RESERVED1
 
@@ -206,6 +208,19 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_SIGNATURE_HANDLING           = 1 << 1,
 };
 
+struct mlx5_umr_wr {
+	union {
+		u64			virt_addr;
+		u64			offset;
+	} target;
+	struct ib_pd		       *pd;
+	unsigned int			page_shift;
+	unsigned int			npages;
+	u32				length;
+	int				access_flags;
+	u32				mkey;
+};
+
 struct mlx5_shared_mr_info {
 	int mr_id;
 	struct ib_umem		*umem;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 66b7290..dd6a4bb 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -37,6 +37,7 @@
 #include <linux/export.h>
 #include <linux/delay.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_verbs.h>
 #include "mlx5_ib.h"
 
 enum {
@@ -675,6 +676,7 @@ static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct ib_mr *mr = dev->umrc.mr;
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
 
 	sg->addr = dma;
 	sg->length = ALIGN(sizeof(u64) * n, 64);
@@ -689,21 +691,23 @@ static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
 		wr->num_sge = 0;
 
 	wr->opcode = MLX5_IB_WR_UMR;
-	wr->wr.fast_reg.page_list_len = n;
-	wr->wr.fast_reg.page_shift = page_shift;
-	wr->wr.fast_reg.rkey = key;
-	wr->wr.fast_reg.iova_start = virt_addr;
-	wr->wr.fast_reg.length = len;
-	wr->wr.fast_reg.access_flags = access_flags;
-	wr->wr.fast_reg.page_list = (struct ib_fast_reg_page_list *)pd;
+
+	umrwr->npages = n;
+	umrwr->page_shift = page_shift;
+	umrwr->mkey = key;
+	umrwr->target.virt_addr = virt_addr;
+	umrwr->length = len;
+	umrwr->access_flags = access_flags;
+	umrwr->pd = pd;
 }
 
 static void prep_umr_unreg_wqe(struct mlx5_ib_dev *dev,
 			       struct ib_send_wr *wr, u32 key)
 {
-	wr->send_flags = MLX5_IB_SEND_UMR_UNREG;
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
+	wr->send_flags = MLX5_IB_SEND_UMR_UNREG | MLX5_IB_SEND_UMR_CHECK_FREE;
 	wr->opcode = MLX5_IB_WR_UMR;
-	wr->wr.fast_reg.rkey = key;
+	umrwr->mkey = key;
 }
 
 void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 335bcbe..e48b699 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -70,15 +70,6 @@ static const u32 mlx5_ib_opcode[] = {
 	[MLX5_IB_WR_UMR]			= MLX5_OPCODE_UMR,
 };
 
-struct umr_wr {
-	u64				virt_addr;
-	struct ib_pd		       *pd;
-	unsigned int			page_shift;
-	unsigned int			npages;
-	u32				length;
-	int				access_flags;
-	u32				mkey;
-};
 
 static int is_qp0(enum ib_qp_type qp_type)
 {
@@ -1818,37 +1809,71 @@ static void set_frwr_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 	umr->mkey_mask = frwr_mkey_mask();
 }
 
+
+static __be64 get_umr_reg_mr_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_LEN		|
+		 MLX5_MKEY_MASK_PAGE_SIZE	|
+		 MLX5_MKEY_MASK_START_ADDR	|
+		 MLX5_MKEY_MASK_PD		|
+		 MLX5_MKEY_MASK_LR		|
+		 MLX5_MKEY_MASK_LW		|
+		 MLX5_MKEY_MASK_KEY		|
+		 MLX5_MKEY_MASK_RR		|
+		 MLX5_MKEY_MASK_RW		|
+		 MLX5_MKEY_MASK_A		|
+		 MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
+static __be64 get_umr_unreg_mr_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
+static __be64 get_umr_update_mtt_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
 static void set_reg_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 				struct ib_send_wr *wr)
 {
-	struct umr_wr *umrwr = (struct umr_wr *)&wr->wr.fast_reg;
-	u64 mask;
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
 
 	memset(umr, 0, sizeof(*umr));
 
+	if (wr->send_flags & MLX5_IB_SEND_UMR_CHECK_FREE)
+		umr->flags = MLX5_UMR_CHECK_FREE; /* fail if free */
+	else
+		umr->flags = MLX5_UMR_CHECK_NOT_FREE; /* fail if not free */
+
 	if (!(wr->send_flags & MLX5_IB_SEND_UMR_UNREG)) {
-		umr->flags = 1 << 5; /* fail if not free */
 		umr->klm_octowords = get_klm_octo(umrwr->npages);
-		mask =  MLX5_MKEY_MASK_LEN		|
-			MLX5_MKEY_MASK_PAGE_SIZE	|
-			MLX5_MKEY_MASK_START_ADDR	|
-			MLX5_MKEY_MASK_PD		|
-			MLX5_MKEY_MASK_LR		|
-			MLX5_MKEY_MASK_LW		|
-			MLX5_MKEY_MASK_KEY		|
-			MLX5_MKEY_MASK_RR		|
-			MLX5_MKEY_MASK_RW		|
-			MLX5_MKEY_MASK_A		|
-			MLX5_MKEY_MASK_FREE;
-		umr->mkey_mask = cpu_to_be64(mask);
+		if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_MTT) {
+			umr->mkey_mask = get_umr_update_mtt_mask();
+			umr->bsf_octowords = get_klm_octo(umrwr->target.offset);
+			umr->flags |= MLX5_UMR_TRANSLATION_OFFSET_EN;
+		} else {
+			umr->mkey_mask = get_umr_reg_mr_mask();
+		}
 	} else {
-		umr->flags = 2 << 5; /* fail if free */
-		mask = MLX5_MKEY_MASK_FREE;
-		umr->mkey_mask = cpu_to_be64(mask);
+		umr->mkey_mask = get_umr_unreg_mr_mask();
 	}
 
 	if (!wr->num_sge)
-		umr->flags |= (1 << 7); /* inline */
+		umr->flags |= MLX5_UMR_INLINE;
 }
 
 static u8 get_umr_flags(int acc)
@@ -1882,19 +1907,23 @@ static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 
 static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr)
 {
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
+
 	memset(seg, 0, sizeof(*seg));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UNREG) {
 		seg->status = 1 << 6;
 		return;
 	}
 
-	seg->flags = convert_access(wr->wr.fast_reg.access_flags);
-	seg->flags_pd = cpu_to_be32(to_mpd((struct ib_pd *)wr->wr.fast_reg.page_list)->pdn);
-	seg->start_addr = cpu_to_be64(wr->wr.fast_reg.iova_start);
-	seg->len = cpu_to_be64(wr->wr.fast_reg.length);
-	seg->log2_page_size = wr->wr.fast_reg.page_shift;
+	seg->flags = convert_access(umrwr->access_flags);
+	if (!(wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_MTT)) {
+		seg->flags_pd = cpu_to_be32(to_mpd(umrwr->pd)->pdn);
+		seg->start_addr = cpu_to_be64(umrwr->target.virt_addr);
+	}
+	seg->len = cpu_to_be64(umrwr->length);
+	seg->log2_page_size = umrwr->page_shift;
 	seg->qpn_mkey7_0 = cpu_to_be32(0xffffff00 |
-				       mlx5_mkey_variant(wr->wr.fast_reg.rkey));
+				       mlx5_mkey_variant(umrwr->mkey));
 }
 
 static void set_frwr_pages(struct mlx5_wqe_data_seg *dseg,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 407bdb6..9d7d239 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -131,6 +131,15 @@ enum {
 	MLX5_MKEY_MASK_FREE		= 1ull << 29,
 };
 
+enum {
+	MLX5_UMR_TRANSLATION_OFFSET_EN	= (1 << 4),
+
+	MLX5_UMR_CHECK_NOT_FREE		= (1 << 5),
+	MLX5_UMR_CHECK_FREE		= (2 << 5),
+
+	MLX5_UMR_INLINE			= (1 << 7),
+};
+
 enum mlx5_event {
 	MLX5_EVENT_TYPE_COMP		   = 0x0,
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
