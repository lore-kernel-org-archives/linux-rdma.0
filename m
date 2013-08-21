From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/nes: lower NAPI weight
Date: Wed, 21 Aug 2013 18:50:21 +0200
Message-ID: <1377103822-1752-2-git-send-email-mschmidt@redhat.com>
References: <1377103822-1752-1-git-send-email-mschmidt@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377103822-1752-1-git-send-email-mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since commit 82dc3c63 netif_napi_add() produces an error message if
a NAPI poll weight greater than 64 is requested.

Use the standard NAPI weight.

Signed-off-by: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 49eb511..0eb34a9 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1679,7 +1679,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	netdev->type = ARPHRD_ETHER;
 	netdev->netdev_ops = &nes_netdev_ops;
 	netdev->ethtool_ops = &nes_ethtool_ops;
-	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, 128);
+	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, NAPI_POLL_WEIGHT);
 	nes_debug(NES_DBG_INIT, "Enabling VLAN Insert/Delete.\n");
 
 	/* Fill in the port structure */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
