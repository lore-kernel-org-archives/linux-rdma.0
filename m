From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 02/17] IB/mlx5: Enhance UMR support to allow partial page table update
Date: Thu, 11 Dec 2014 17:04:11 +0200
Message-ID: <1418310266-9584-3-git-send-email-haggaie@mellanox.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current UMR interface doesn't allow partial updates to a memory region's
page tables. This patch changes the interface to allow that.

It also changes the way the UMR operation validates the memory region's state.
When set, IB_SEND_UMR_FAIL_IF_FREE will cause the UMR operation to fail if the
MKEY is in the free state. When it is unchecked the operation will check that
it isn't in the free state.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  15 ++++++
 drivers/infiniband/hw/mlx5/mr.c      |  29 +++++-----
 drivers/infiniband/hw/mlx5/qp.c      | 100 ++++++++++++++++++++++-------------
 include/linux/mlx5/device.h          |  13 +++++
 4 files changed, 109 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 29da55222070..53d19e6e69a4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -111,6 +111,8 @@ struct mlx5_ib_pd {
  */
 
 #define MLX5_IB_SEND_UMR_UNREG	IB_SEND_RESERVED_START
+#define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_RESERVED_START << 1)
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
index 610500810f75..d69db8d7d227 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -37,6 +37,7 @@
 #include <linux/export.h>
 #include <linux/delay.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_verbs.h>
 #include "mlx5_ib.h"
 
 enum {
@@ -146,7 +147,7 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		mr->order = ent->order;
 		mr->umred = 1;
 		mr->dev = dev;
-		in->seg.status = 1 << 6;
+		in->seg.status = MLX5_MKEY_STATUS_FREE;
 		in->seg.xlt_oct_size = cpu_to_be32((npages + 1) / 2);
 		in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 		in->seg.flags = MLX5_ACCESS_MODE_MTT | MLX5_PERM_UMR_EN;
@@ -675,6 +676,7 @@ static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct ib_mr *mr = dev->umrc.mr;
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
 
 	sg->addr = dma;
 	sg->length = ALIGN(sizeof(u64) * n, 64);
@@ -689,21 +691,24 @@ static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
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
+
+	wr->send_flags = MLX5_IB_SEND_UMR_UNREG | MLX5_IB_SEND_UMR_FAIL_IF_FREE;
 	wr->opcode = MLX5_IB_WR_UMR;
-	wr->wr.fast_reg.rkey = key;
+	umrwr->mkey = key;
 }
 
 void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context)
@@ -1028,7 +1033,7 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 		goto err_free;
 	}
 
-	in->seg.status = 1 << 6; /* free */
+	in->seg.status = MLX5_MKEY_STATUS_FREE;
 	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
 	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
@@ -1143,7 +1148,7 @@ struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 		goto err_free;
 	}
 
-	in->seg.status = 1 << 6; /* free */
+	in->seg.status = MLX5_MKEY_STATUS_FREE;
 	in->seg.xlt_oct_size = cpu_to_be32((max_page_list_len + 1) / 2);
 	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 	in->seg.flags = MLX5_PERM_UMR_EN | MLX5_ACCESS_MODE_MTT;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e261a53f9a02..9bdcaf65f5e6 100644
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
@@ -1838,37 +1829,70 @@ static void set_frwr_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 	umr->mkey_mask = frwr_mkey_mask();
 }
 
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
 
+	if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
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
@@ -1885,7 +1909,7 @@ static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 {
 	memset(seg, 0, sizeof(*seg));
 	if (li) {
-		seg->status = 1 << 6;
+		seg->status = MLX5_MKEY_STATUS_FREE;
 		return;
 	}
 
@@ -1902,19 +1926,23 @@ static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 
 static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr)
 {
+	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
+
 	memset(seg, 0, sizeof(*seg));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UNREG) {
-		seg->status = 1 << 6;
+		seg->status = MLX5_MKEY_STATUS_FREE;
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
index 1d67fd32e71c..3562b9732699 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -180,6 +180,15 @@ enum {
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
 
@@ -784,6 +793,10 @@ struct mlx5_query_eq_mbox_out {
 	struct mlx5_eq_context	ctx;
 };
 
+enum {
+	MLX5_MKEY_STATUS_FREE = 1 << 6,
+};
+
 struct mlx5_mkey_seg {
 	/* This is a two bit field occupying bits 31-30.
 	 * bit 31 is always 0,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
