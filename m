From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] mlx4: Fix IBoE link state
Date: Thu, 11 Nov 2010 23:05:58 +0200
Message-ID: <20101111210558.GA30436@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make use of netif_running() and netif_carrier_ok() to report link state, in the
same manner it is done to report Ethernet link state in sysfs.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
I find this version even more correct than the previous one. This
exactly the same logic used to show the carrier in sysfs.

 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 018007c..f200b96 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -242,7 +242,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	tmp = iboe_get_mtu(ndev->mtu);
 	props->active_mtu = tmp ? min(props->max_mtu, tmp) : IB_MTU_256;
 
-	props->state		= netif_running(ndev) &&  netif_oper_up(ndev) ?
+	props->state		= (netif_running(ndev) && netif_carrier_ok(ndev)) ?
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
