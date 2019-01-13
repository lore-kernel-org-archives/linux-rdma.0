From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Add support for ODP for DEVX indirection mkey
Date: Sun, 13 Jan 2019 16:01:18 +0200
Message-ID: <20190113140118.10204-4-leon@kernel.org>
References: <20190113140118.10204-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190113140118.10204-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add support for ODP for DEVX indirection mkey, it includes:
- Recognizing its type as part of the radix tree lookup.
- Use similar flow as done for the MW MKEY type.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 8d46b1dc5658..82ac6cdc7130 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -685,6 +685,21 @@ struct pf_frame {
 	int depth;
 };
 
+static int get_indirect_num_descs(struct mlx5_core_mkey *mmkey)
+{
+	struct mlx5_ib_mw *mw;
+	struct mlx5_ib_devx_mr *devx_mr;
+
+	if (mmkey->type == MLX5_MKEY_MW) {
+		mw = container_of(mmkey, struct mlx5_ib_mw, mmkey);
+		return mw->ndescs;
+	}
+
+	devx_mr = container_of(mmkey, struct mlx5_ib_devx_mr,
+			       mmkey);
+	return devx_mr->ndescs;
+}
+
 /*
  * Handle a single data segment in a page-fault WQE or RDMA region.
  *
@@ -705,11 +720,11 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 	bool prefetch = flags & MLX5_PF_FLAGS_PREFETCH;
 	struct pf_frame *head = NULL, *frame;
 	struct mlx5_core_mkey *mmkey;
-	struct mlx5_ib_mw *mw;
 	struct mlx5_ib_mr *mr;
 	struct mlx5_klm *pklm;
 	u32 *out = NULL;
 	size_t offset;
+	int ndescs;
 
 	srcu_key = srcu_read_lock(&dev->mr_srcu);
 
@@ -762,7 +777,8 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 		break;
 
 	case MLX5_MKEY_MW:
-		mw = container_of(mmkey, struct mlx5_ib_mw, mmkey);
+	case MLX5_MKEY_INDIRECT_DEVX:
+		ndescs = get_indirect_num_descs(mmkey);
 
 		if (depth >= MLX5_CAP_GEN(dev->mdev, max_indirection)) {
 			mlx5_ib_dbg(dev, "indirection level exceeded\n");
@@ -771,7 +787,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 		}
 
 		outlen = MLX5_ST_SZ_BYTES(query_mkey_out) +
-			sizeof(*pklm) * (mw->ndescs - 2);
+			sizeof(*pklm) * (ndescs - 2);
 
 		if (outlen > cur_outlen) {
 			kfree(out);
@@ -786,14 +802,14 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 		pklm = (struct mlx5_klm *)MLX5_ADDR_OF(query_mkey_out, out,
 						       bsf0_klm0_pas_mtt0_1);
 
-		ret = mlx5_core_query_mkey(dev->mdev, &mw->mmkey, out, outlen);
+		ret = mlx5_core_query_mkey(dev->mdev, mmkey, out, outlen);
 		if (ret)
 			goto srcu_unlock;
 
 		offset = io_virt - MLX5_GET64(query_mkey_out, out,
 					      memory_key_mkey_entry.start_addr);
 
-		for (i = 0; bcnt && i < mw->ndescs; i++, pklm++) {
+		for (i = 0; bcnt && i < ndescs; i++, pklm++) {
 			if (offset >= be32_to_cpu(pklm->bcount)) {
 				offset -= be32_to_cpu(pklm->bcount);
 				continue;
-- 
2.19.1
