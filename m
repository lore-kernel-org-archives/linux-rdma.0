From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 7/8] RDMA/nes: Remove zeroed parameter from port query callback
Date: Tue, 15 Aug 2017 12:14:30 +0300
Message-ID: <20170815091431.12822-8-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to explicitly zero parameters, because
the structure requested to be filled already initialized to zeros.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c2943e39d2f9..f0dc5f4aa177 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -481,21 +481,16 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu);
 
 	props->lid = 1;
-	props->lmc = 0;
-	props->sm_lid = 0;
-	props->sm_sl = 0;
 	if (netif_queue_stopped(netdev))
 		props->state = IB_PORT_DOWN;
 	else if (nesvnic->linkup)
 		props->state = IB_PORT_ACTIVE;
 	else
 		props->state = IB_PORT_DOWN;
-	props->phys_state = 0;
 	props->port_cap_flags = IB_PORT_CM_SUP | IB_PORT_REINIT_SUP |
 			IB_PORT_VENDOR_CLASS_SUP | IB_PORT_BOOT_MGMT_SUP;
 	props->gid_tbl_len = 1;
 	props->pkey_tbl_len = 1;
-	props->qkey_viol_cntr = 0;
 	props->active_width = IB_WIDTH_4X;
 	props->active_speed = IB_SPEED_SDR;
 	props->max_msg_sz = 0x80000000;
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
