From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/3] IB/mlx5: Fix RoCE Address Path fields
Date: Mon, 30 Oct 2017 14:23:14 +0200
Message-ID: <20171030122315.21924-3-leon@kernel.org>
References: <20171030122315.21924-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030122315.21924-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When working over a RoCE network, the UDP source port should be set only
for statically connected QPs (RC, UC and XRC).

Fixes: 2811ba51b049 ("IB/mlx5: Add RoCE fields to Address Vector")
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index acb79d3a4f1d..a63060b93a43 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2283,8 +2283,12 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			return err;
 		memcpy(path->rmac, ah->roce.dmac, sizeof(ah->roce.dmac));
-		path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
-							  grh->sgid_index);
+		if (qp->ibqp.qp_type == IB_QPT_RC ||
+		    qp->ibqp.qp_type == IB_QPT_UC ||
+		    qp->ibqp.qp_type == IB_QPT_XRC_INI ||
+		    qp->ibqp.qp_type == IB_QPT_XRC_TGT)
+			path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
+								  grh->sgid_index);
 		path->dci_cfi_prio_sl = (sl & 0x7) << 4;
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
 			path->ecn_dscp = (grh->traffic_class >> 2) & 0x3f;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
