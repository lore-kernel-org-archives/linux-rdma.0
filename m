From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 6/7] IB/mlx4: Avoid executing gid task when device is being removed
Date: Thu, 21 Aug 2014 14:28:42 +0300
Message-ID: <1408620523-10616-7-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When device is being removed (e.g during VPI port link type change from ETH
to IB), tasks for gid table changes should not be executed.

Flush the current queue of tasks and block further tasks from entering the queue.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 5179504..ea30f9e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1387,6 +1387,9 @@ static void update_gids_task(struct work_struct *work)
 	int err;
 	struct mlx4_dev	*dev = gw->dev->dev;
 
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
@@ -1417,6 +1420,9 @@ static void reset_gids_task(struct work_struct *work)
 	int err;
 	struct mlx4_dev	*dev = gw->dev->dev;
 
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("reset gid table failed\n");
@@ -2366,6 +2372,9 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	struct mlx4_ib_dev *ibdev = ibdev_ptr;
 	int p;
 
+	ibdev->ib_active = false;
+	flush_workqueue(wq);
+
 	mlx4_ib_close_sriov(ibdev);
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
