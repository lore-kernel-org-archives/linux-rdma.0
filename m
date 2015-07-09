From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-4.2 1/2] IB/mlx4: Fix memory leak in do_slave_init
Date: Thu,  9 Jul 2015 10:26:49 -0400
Message-ID: <062f47dbcfcc4533e473b0866166ed7de1bc190c.1436452010.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We create a number of work structs to be queued up to a workqueue, and
on completion of the workqueue handler, the workqueue handler frees the
allocated memory.  If, however, we don't queue the work struct because
the device is going down, then we need to free the memory ourselves.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 064454aee863..1c59e4749736 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2692,6 +2692,8 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
 		if (!ibdev->sriov.is_going_down)
 			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
+		else
+			kfree(dm[i]);
 		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
 	}
 out:
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
