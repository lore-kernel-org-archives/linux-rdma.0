From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/mlx4: Support raw packet protocol
Date: Thu, 19 Jan 2017 07:41:00 +0200
Message-ID: <20170119054102.20135-4-leon@kernel.org>
References: <20170119054102.20135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119054102.20135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Mark support for the new raw packet protocol on Eth ports.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c8413fc..7019b94 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2536,16 +2536,19 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND) {
 		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+		immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 	} else {
 		if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
 			immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
 			immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
 				RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+		immutable->core_cap_flags |= RDMA_CORE_PORT_RAW_PACKET;
+		if (immutable->core_cap_flags & (RDMA_CORE_PORT_IBA_ROCE |
+		    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP))
+			immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 	}
 
-	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
-
 	return 0;
 }
 
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
