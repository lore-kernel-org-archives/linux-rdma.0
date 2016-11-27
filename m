From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/10] IB/mlx4: Support raw packet protocol
Date: Sun, 27 Nov 2016 16:51:29 +0200
Message-ID: <1480258296-27032-4-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
index b597e82..3902832 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2532,16 +2532,19 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
