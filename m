From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-4.2 2/2] IB/mlx4: Optimize do_slave_init
Date: Thu,  9 Jul 2015 10:26:50 -0400
Message-ID: <ba67097e948b1fde775309c7b7955d3c10fcf8e4.1436452010.git.dledford@redhat.com>
References: <062f47dbcfcc4533e473b0866166ed7de1bc190c.1436452010.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <062f47dbcfcc4533e473b0866166ed7de1bc190c.1436452010.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <062f47dbcfcc4533e473b0866166ed7de1bc190c.1436452010.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <062f47dbcfcc4533e473b0866166ed7de1bc190c.1436452010.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is little chance our memory allocation will fail, so we can
combine initializing the work structs with allocating them instead of
looping through all of them once to allocate and again to initialize.
Then when we need to actually find out if our device is up or in the
process of going down, have all of our work structs batched up, take the
spin_lock once and only once, and do all of the batch under the one
spin_lock invocation instead of incurring all of the locked memory cycles
we would otherwise incur to take/release the spin_lock over and over
again.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1c59e4749736..8be6db816460 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2681,20 +2681,22 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 				kfree(dm[i]);
 			goto out;
 		}
-	}
-	/* initialize or tear down tunnel QPs for the slave */
-	for (i = 0; i < ports; i++) {
 		INIT_WORK(&dm[i]->work, mlx4_ib_tunnels_update_work);
 		dm[i]->port = first_port + i + 1;
 		dm[i]->slave = slave;
 		dm[i]->do_init = do_init;
 		dm[i]->dev = ibdev;
-		spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
-		if (!ibdev->sriov.is_going_down)
+	}
+	/* initialize or tear down tunnel QPs for the slave */
+	spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
+	if (!ibdev->sriov.is_going_down) {
+		for (i = 0; i < ports; i++)
 			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
-		else
-			kfree(dm[i]);
 		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
+		for (i = 0; i < ports; i++)
+			kfree(dm[i]);
 	}
 out:
 	kfree(dm);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
