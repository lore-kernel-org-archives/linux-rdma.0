From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 5/7] IB/mlx5: Implement reg_user_dma_buf_mr
Date: Mon,  1 Aug 2016 09:57:31 +0300
Message-ID: <1470034653-9097-6-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Register DMA-BUF buffers as memory regions using the ib_mr_attach_dmabuf
helper function. The code posts the fast registration request on the UMR
QP and syncs before returning.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    |  4 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +++
 drivers/infiniband/hw/mlx5/mr.c      | 51 ++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f41254f3689a..852be161b68e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2368,7 +2368,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.uverbs_ex_cmd_mask =
 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP)	|
+		(1ull << IB_USER_VERBS_EX_CMD_REG_DMA_BUF_MR);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
@@ -2409,6 +2410,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.get_dma_mr		= mlx5_ib_get_dma_mr;
 	dev->ib_dev.reg_user_mr		= mlx5_ib_reg_user_mr;
 	dev->ib_dev.rereg_user_mr	= mlx5_ib_rereg_user_mr;
+	dev->ib_dev.reg_user_dma_buf_mr = mlx5_ib_reg_user_dma_buf_mr;
 	dev->ib_dev.dereg_mr		= mlx5_ib_dereg_mr;
 	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c4a9825828bc..a722dcb367fc 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -711,6 +711,10 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
 int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			  u64 length, u64 virt_addr, int access_flags,
 			  struct ib_pd *pd, struct ib_udata *udata);
+struct ib_mr *mlx5_ib_reg_user_dma_buf_mr(struct ib_pd *pd,
+					  struct dma_buf *dmabuf,
+					  int mr_access_flags,
+					  struct ib_udata *udata);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fb2bb25c6cf0..f773787013bd 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -39,6 +39,7 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_umem_odp.h>
 #include <rdma/ib_verbs.h>
+#include <linux/dma-buf.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -1447,6 +1448,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 	int npages = mr->npages;
 	struct ib_umem *umem = mr->umem;
+	struct dma_buf_attachment *attach = ibmr->attach;
+	struct sg_table *sg = ibmr->sg;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (umem && umem->odp_data) {
@@ -1477,6 +1480,9 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		atomic_sub(npages, &dev->mdev->priv.reg_pages);
 	}
 
+	if (attach)
+		ib_mr_detach_dmabuf(attach, sg);
+
 	return 0;
 }
 
@@ -1785,3 +1791,48 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 
 	return n;
 }
+
+struct ib_mr *mlx5_ib_reg_user_dma_buf_mr(struct ib_pd *pd,
+					  struct dma_buf *dmabuf,
+					  int mr_access_flags,
+					  struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct ib_mr *mr;
+	struct mlx5_ib_umr_context umr_context;
+	struct ib_reg_wr regwr = {};
+	int ret;
+
+	if (mr_access_flags & IB_ACCESS_ON_DEMAND) {
+		mlx5_ib_err(dev, "reg DMA-BUF MR with on-demand paging not supported");
+		return ERR_PTR(-EINVAL);
+	}
+
+	mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+			 DIV_ROUND_UP(dmabuf->size, PAGE_SIZE));
+	if (IS_ERR(mr))
+		return mr;
+
+	ret = ib_mr_attach_dmabuf(mr, dmabuf, mr_access_flags);
+	if (ret)
+		goto dereg;
+
+	mlx5_ib_init_umr_context(&umr_context);
+	regwr.wr.wr_cqe = &umr_context.cqe;
+	regwr.wr.opcode = IB_WR_REG_MR;
+	regwr.mr = mr;
+	regwr.key = mr->lkey;
+	regwr.access = mr_access_flags;
+
+	ret = mlx5_ib_post_umr_sync(dev, &regwr.wr);
+	if (ret)
+		goto detach;
+
+	return mr;
+
+detach:
+	ib_mr_detach_dmabuf(mr->attach, mr->sg);
+dereg:
+	WARN_ON_ONCE(ib_dereg_mr(mr));
+	return ERR_PTR(ret);
+}
-- 
1.7.11.2
