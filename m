From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 09/11] IB/mlx5: Enable WQ creation and modification with cvlan offload
Date: Wed, 18 Jan 2017 15:40:02 +0200
Message-ID: <20170118134004.5380-10-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow creating a WQ with cvlan stripping considering device's
capabilities. The default value was fixed to disable vlan stripping
till was asked explicitly.

In addition, allow modification of a WQ to turn on/off this property.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6a83fb3..74c242f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4610,9 +4610,20 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET(wq, wq, log_wq_pg_sz, rwq->log_page_size);
 	MLX5_SET(wq, wq, wq_signature, rwq->wq_sig);
 	MLX5_SET64(wq, wq, dbr_addr, rwq->db.dma);
+	if (init_attr->create_flags & IB_WQ_FLAGS_CVLAN_STRIPPING) {
+		if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
+		      MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
+			mlx5_ib_dbg(dev, "VLAN offloads are not supported\n");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+	} else {
+		MLX5_SET(rqc, rqc, vsd, 1);
+	}
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
 	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rwq->core_qp);
+out:
 	kvfree(in);
 	return err;
 }
@@ -4895,11 +4906,26 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		wq_state = MLX5_RQC_STATE_ERR;
 	MLX5_SET(modify_rq_in, in, rq_state, curr_wq_state);
 	MLX5_SET(rqc, rqc, state, wq_state);
+	if (wq_attr_mask & IB_WQ_FLAGS) {
+		if (wq_attr->flags_mask & IB_WQ_FLAGS_CVLAN_STRIPPING) {
+			if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
+			      MLX5_CAP_ETH(dev->mdev, vlan_cap))) {
+				mlx5_ib_dbg(dev, "VLAN offloads are not supported\n");
+				err = -EOPNOTSUPP;
+				goto out;
+			}
+			MLX5_SET64(modify_rq_in, in, modify_bitmask,
+				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_VSD);
+			MLX5_SET(rqc, rqc, vsd,
+				 (wq_attr->flags & IB_WQ_FLAGS_CVLAN_STRIPPING) ? 0 : 1);
+		}
+	}
 
 	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in, inlen);
-	kvfree(in);
 	if (!err)
 		rwq->ibwq.state = (wq_state == MLX5_RQC_STATE_ERR) ? IB_WQS_ERR : wq_state;
 
+out:
+	kvfree(in);
 	return err;
 }
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
