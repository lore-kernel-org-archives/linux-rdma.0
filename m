From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/10] IB/mlx5: Add ODP support to MW
Date: Mon,  3 Apr 2017 13:06:40 +0300
Message-ID: <20170403100640.3332-11-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Internally MW implemented as KLM MKey and filled by userspace UMR
postsends.  Handle pagefault trigered by operations on this MKeys.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/mr.c      |   1 +
 drivers/infiniband/hw/mlx5/odp.c     | 161 +++++++++++++++++++++++++----------
 3 files changed, 120 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 3cd064b5f0bf..9f519404ad7a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -513,6 +513,7 @@ struct mlx5_ib_mr {
 struct mlx5_ib_mw {
 	struct ib_mw		ibmw;
 	struct mlx5_core_mkey	mmkey;
+	int			ndescs;
 };
 
 struct mlx5_ib_umr_context {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9a74260e9899..93c0e82aa491 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1688,6 +1688,7 @@ struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 
 	mw->mmkey.type = MLX5_MKEY_MW;
 	mw->ibmw.rkey = mw->mmkey.key;
+	mw->ndescs = ndescs;
 
 	resp.response_length = min(offsetof(typeof(resp), response_length) +
 				   sizeof(resp.response_length), udata->outlen);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 842e1dbb50b8..ae0746754008 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -288,24 +288,6 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	return;
 }
 
-static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(struct mlx5_ib_dev *dev,
-						   u32 key)
-{
-	u32 base_key = mlx5_base_mkey(key);
-	struct mlx5_core_mkey *mmkey = __mlx5_mr_lookup(dev->mdev, base_key);
-	struct mlx5_ib_mr *mr;
-
-	if (!mmkey || mmkey->key != key || mmkey->type != MLX5_MKEY_MR)
-		return NULL;
-
-	mr = container_of(mmkey, struct mlx5_ib_mr, mmkey);
-
-	if (!mr->live)
-		return NULL;
-
-	return container_of(mmkey, struct mlx5_ib_mr, mmkey);
-}
-
 static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 				      struct mlx5_pagefault *pfault,
 				      int error)
@@ -625,6 +607,14 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	return ret;
 }
 
+struct pf_frame {
+	struct pf_frame *next;
+	u32 key;
+	u64 io_virt;
+	size_t bcnt;
+	int depth;
+};
+
 /*
  * Handle a single data segment in a page-fault WQE or RDMA region.
  *
@@ -641,43 +631,128 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 					 u32 *bytes_committed,
 					 u32 *bytes_mapped)
 {
-	int npages = 0, srcu_key, ret;
+	int npages = 0, srcu_key, ret, i, outlen, cur_outlen = 0, depth = 0;
+	struct pf_frame *head = NULL, *frame;
+	struct mlx5_core_mkey *mmkey;
+	struct mlx5_ib_mw *mw;
 	struct mlx5_ib_mr *mr;
-	size_t size;
+	struct mlx5_klm *pklm;
+	u32 *out = NULL;
+	size_t offset;
 
 	srcu_key = srcu_read_lock(&dev->mr_srcu);
-	mr = mlx5_ib_odp_find_mr_lkey(dev, key);
-	/*
-	 * If we didn't find the MR, it means the MR was closed while we were
-	 * handling the ODP event. In this case we return -EFAULT so that the
-	 * QP will be closed.
-	 */
-	if (!mr || !mr->ibmr.pd) {
-		mlx5_ib_dbg(dev, "Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
-			    key);
+
+	io_virt += *bytes_committed;
+	bcnt -= *bytes_committed;
+
+next_mr:
+	mmkey = __mlx5_mr_lookup(dev->mdev, mlx5_base_mkey(key));
+	if (!mmkey || mmkey->key != key) {
+		mlx5_ib_dbg(dev, "failed to find mkey %x\n", key);
 		ret = -EFAULT;
 		goto srcu_unlock;
 	}
-	if (!mr->umem->odp_data) {
-		mlx5_ib_dbg(dev, "skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
-			    key);
-		if (bytes_mapped)
-			*bytes_mapped +=
-				(bcnt - *bytes_committed);
+
+	switch (mmkey->type) {
+	case MLX5_MKEY_MR:
+		mr = container_of(mmkey, struct mlx5_ib_mr, mmkey);
+		if (!mr->live || !mr->ibmr.pd) {
+			mlx5_ib_dbg(dev, "got dead MR\n");
+			ret = -EFAULT;
+			goto srcu_unlock;
+		}
+
+		ret = pagefault_mr(dev, mr, io_virt, bcnt, bytes_mapped);
+		if (ret < 0)
+			goto srcu_unlock;
+
+		npages += ret;
+		ret = 0;
+		break;
+
+	case MLX5_MKEY_MW:
+		mw = container_of(mmkey, struct mlx5_ib_mw, mmkey);
+
+		if (depth >= MLX5_CAP_GEN(dev->mdev, max_indirection)) {
+			mlx5_ib_dbg(dev, "indirection level exceeded\n");
+			ret = -EFAULT;
+			goto srcu_unlock;
+		}
+
+		outlen = MLX5_ST_SZ_BYTES(query_mkey_out) +
+			sizeof(*pklm) * (mw->ndescs - 2);
+
+		if (outlen > cur_outlen) {
+			kfree(out);
+			out = kzalloc(outlen, GFP_KERNEL);
+			if (!out) {
+				ret = -ENOMEM;
+				goto srcu_unlock;
+			}
+			cur_outlen = outlen;
+		}
+
+		pklm = (struct mlx5_klm *)MLX5_ADDR_OF(query_mkey_out, out,
+						       bsf0_klm0_pas_mtt0_1);
+
+		ret = mlx5_core_query_mkey(dev->mdev, &mw->mmkey, out, outlen);
+		if (ret)
+			goto srcu_unlock;
+
+		offset = io_virt - MLX5_GET64(query_mkey_out, out,
+					      memory_key_mkey_entry.start_addr);
+
+		for (i = 0; bcnt && i < mw->ndescs; i++, pklm++) {
+			if (offset >= be32_to_cpu(pklm->bcount)) {
+				offset -= be32_to_cpu(pklm->bcount);
+				continue;
+			}
+
+			frame = kzalloc(sizeof(*frame), GFP_KERNEL);
+			if (!frame) {
+				ret = -ENOMEM;
+				goto srcu_unlock;
+			}
+
+			frame->key = be32_to_cpu(pklm->key);
+			frame->io_virt = be64_to_cpu(pklm->va) + offset;
+			frame->bcnt = min_t(size_t, bcnt,
+					    be32_to_cpu(pklm->bcount) - offset);
+			frame->depth = depth + 1;
+			frame->next = head;
+			head = frame;
+
+			bcnt -= frame->bcnt;
+		}
+		break;
+
+	default:
+		mlx5_ib_dbg(dev, "wrong mkey type %d\n", mmkey->type);
+		ret = -EFAULT;
 		goto srcu_unlock;
 	}
 
-	/*
-	 * Avoid branches - this code will perform correctly
-	 * in all iterations (in iteration 2 and above,
-	 * bytes_committed == 0).
-	 */
-	io_virt += *bytes_committed;
-	bcnt -= *bytes_committed;
+	if (head) {
+		frame = head;
+		head = frame->next;
 
-	npages = pagefault_mr(dev, mr, io_virt, size, bytes_mapped);
+		key = frame->key;
+		io_virt = frame->io_virt;
+		bcnt = frame->bcnt;
+		depth = frame->depth;
+		kfree(frame);
+
+		goto next_mr;
+	}
 
 srcu_unlock:
+	while (head) {
+		frame = head;
+		head = frame->next;
+		kfree(frame);
+	}
+	kfree(out);
+
 	srcu_read_unlock(&dev->mr_srcu, srcu_key);
 	*bytes_committed = 0;
 	return ret ? ret : npages;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
