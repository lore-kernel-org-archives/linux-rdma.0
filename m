From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-4.2] IB/mlx4: Fix and optimize SRIOV slave init
Date: Wed,  8 Jul 2015 18:30:58 -0400
Message-ID: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In mlx4_main.c:do_slave_init(), the function is supposed to queue up
each work struct.  However, it checks to make sure the sriov support
isn't going down first.  When it is going down, it doesn't queue up the
work struct, which results in us leaking the work struct at the end of
the function.  As a fix, make sure that if we don't queue up the work
struct, then we kfree it instead.

The routine was also sub-optimal in its loop operations.  Instead of
taking and releasing a spin lock over and over again, let's just take it
once, and quickly loop through what needs to be done under the spin lock
and then release it.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 064454aee863..3f21a5565af2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2681,19 +2681,21 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
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
-			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
-		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
 	}
+	/* initialize or tear down tunnel QPs for the slave */
+	spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
+	if (!ibdev->sriov.is_going_down)
+		for (i = 0; i < ports; i++)
+			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
+	else
+		for (i = 0; i < ports; i++)
+			kfree(dm[i]);
+	spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
 out:
 	kfree(dm);
 	return;
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
