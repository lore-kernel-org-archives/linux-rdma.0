From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] infiniband: nes: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:10 +0530
Message-ID: <1506076036-16496-3-git-send-email-allen.lkml@gmail.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506076036-16496-1-git-send-email-allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5921ea3..e4fb0ad 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1746,8 +1746,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 		nesvnic->rdma_enabled = 0;
 	}
 	nesvnic->nic_cq.cq_number = nesvnic->nic.qp_id;
-	init_timer(&nesvnic->event_timer);
-	nesvnic->event_timer.function = NULL;
+	setup_timer(&nesvnic->event_timer, NULL, 0UL);
 	spin_lock_init(&nesvnic->tx_lock);
 	spin_lock_init(&nesvnic->port_ibevent_lock);
 	nesdev->netdev[nesdev->netdev_count] = netdev;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
