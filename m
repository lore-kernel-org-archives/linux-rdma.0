From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 7/7] IB/mlx5: Allow XRC usage via verbs in DEVX context
Date: Mon, 26 Nov 2018 08:28:38 +0200
Message-ID: <20181126062838.5907-8-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Allows XRC usage from the verbs flow in a DEVX context.
As XRCD is some shared kernel resource between processes it should be
created with UID=0 to point on that.

As a result once XRC QP/SRQ are created they must be used as well with
UID=0 so that firmware will allow the XRCD usage.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
 drivers/infiniband/hw/mlx5/qp.c      | 12 +++++-------
 drivers/infiniband/hw/mlx5/srq.c     |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4d33965369cc..24cb2f793210 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -543,7 +543,6 @@ struct mlx5_ib_srq {
 struct mlx5_ib_xrcd {
 	struct ib_xrcd		ibxrcd;
 	u32			xrcdn;
-	u16			uid;
 };
 
 enum mlx5_ib_mtt_access_flags {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 52ffc6af3c20..369db954edbe 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -775,6 +775,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	__be64 *pas;
 	void *qpc;
 	int err;
+	u16 uid;
 
 	err = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
 	if (err) {
@@ -836,7 +837,8 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		goto err_umem;
 	}
 
-	MLX5_SET(create_qp_in, *in, uid, to_mpd(pd)->uid);
+	uid = (attr->qp_type != IB_QPT_XRC_TGT) ? to_mpd(pd)->uid : 0;
+	MLX5_SET(create_qp_in, *in, uid, uid);
 	pas = (__be64 *)MLX5_ADDR_OF(create_qp_in, *in, pas);
 	if (ubuffer->umem)
 		mlx5_ib_populate_pas(dev, ubuffer->umem, page_shift, pas, 0);
@@ -5513,7 +5515,6 @@ struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_xrcd *xrcd;
 	int err;
-	u16 uid;
 
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
 		return ERR_PTR(-ENOSYS);
@@ -5522,14 +5523,12 @@ struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 	if (!xrcd)
 		return ERR_PTR(-ENOMEM);
 
-	uid = context ? to_mucontext(context)->devx_uid : 0;
-	err = mlx5_cmd_xrcd_alloc(dev->mdev, &xrcd->xrcdn, uid);
+	err = mlx5_cmd_xrcd_alloc(dev->mdev, &xrcd->xrcdn, 0);
 	if (err) {
 		kfree(xrcd);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	xrcd->uid = uid;
 	return &xrcd->ibxrcd;
 }
 
@@ -5537,10 +5536,9 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 {
 	struct mlx5_ib_dev *dev = to_mdev(xrcd->device);
 	u32 xrcdn = to_mxrcd(xrcd)->xrcdn;
-	u16 uid =  to_mxrcd(xrcd)->uid;
 	int err;
 
-	err = mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, uid);
+	err = mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, 0);
 	if (err)
 		mlx5_ib_warn(dev, "failed to dealloc xrcdn 0x%x\n", xrcdn);
 
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index b3aef0eb39cb..0413b10dea71 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -113,7 +113,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 
 	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	in->page_offset = offset;
-	in->uid = to_mpd(pd)->uid;
+	in->uid = (in->type != IB_SRQT_XRC) ?  to_mpd(pd)->uid : 0;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
-- 
2.19.1
