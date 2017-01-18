From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 11/11] IB/mlx5: Support creation of a WQ with scatter FCS offload
Date: Wed, 18 Jan 2017 15:40:04 +0200
Message-ID: <20170118134004.5380-12-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for creation of a WQ with scatter FCS capability, if
this capability is supported by the hardware.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e333bda..844e3fb 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4590,6 +4590,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		      struct ib_wq_init_attr *init_attr)
 {
 	struct mlx5_ib_dev *dev;
+	int has_net_offloads;
 	__be64 *rq_pas0;
 	void *in;
 	void *rqc;
@@ -4621,9 +4622,9 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET(wq, wq, log_wq_pg_sz, rwq->log_page_size);
 	MLX5_SET(wq, wq, wq_signature, rwq->wq_sig);
 	MLX5_SET64(wq, wq, dbr_addr, rwq->db.dma);
+	has_net_offloads = MLX5_CAP_GEN(dev->mdev, eth_net_offloads);
 	if (init_attr->create_flags & IB_WQ_FLAGS_CVLAN_STRIPPING) {
-		if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-		      MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
+		if (!(has_net_offloads && MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
 			mlx5_ib_dbg(dev, "VLAN offloads are not supported\n");
 			err = -EOPNOTSUPP;
 			goto out;
@@ -4631,6 +4632,14 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	} else {
 		MLX5_SET(rqc, rqc, vsd, 1);
 	}
+	if (init_attr->create_flags & IB_WQ_FLAGS_SCATTER_FCS) {
+		if (!(has_net_offloads && MLX5_CAP_ETH(dev->mdev, scatter_fcs))) {
+			mlx5_ib_dbg(dev, "Scatter FCS is not supported\n");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+		MLX5_SET(rqc, rqc, scatter_fcs, 1);
+	}
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
 	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rwq->core_qp);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
