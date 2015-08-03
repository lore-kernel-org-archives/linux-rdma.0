From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/mlx4: Fix memory leaks related to updating GIDs
Date: Mon, 3 Aug 2015 10:04:17 -0700
Message-ID: <55BF9F11.6050708@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the memory leaks in update_gids_task() and reset_gids_task().
kmemleak reported one of these leaks as follows:

unreferenced object 0xffff88044576d668 (size 4096):
  comm "softirq", pid 0, jiffies 4294942043 (age 976.560s)
  hex dump (first 32 bytes):
    00 02 00 00 00 00 00 00 70 d6 76 45 04 88 ff ff  ........p.vE....
    70 d6 76 45 04 88 ff ff 60 d6 2d a0 ff ff ff ff  p.vE....`.-.....
  backtrace:
    [<ffffffff814f2f1e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811b0678>] kmem_cache_alloc_trace+0xc8/0x2d0
    [<ffffffffa02e061e>] reset_gid_table+0x2e/0xe0 [mlx4_ib]
    [<ffffffffa02e1c59>] mlx4_ib_netdev_event+0x449/0x450 [mlx4_ib]
    [<ffffffff814011ca>] register_netdevice_notifier+0x8a/0x1c0
    [<ffffffffa02e173b>] mlx4_ib_add+0x106b/0x1140 [mlx4_ib]
    [<ffffffffa00dc3d1>] mlx4_add_device+0x41/0xa0 [mlx4_core]
    [<ffffffffa00dc4bc>] mlx4_register_interface+0x8c/0xf0 [mlx4_core]
    [<ffffffffa02fc056>] ext4_has_free_clusters+0x6/0x170 [ext4]
    [<ffffffff8100211d>] do_one_initcall+0xad/0x1e0
    [<ffffffff814f7238>] do_init_module+0x61/0x1ec
    [<ffffffff810f95f2>] load_module+0x1d42/0x26b0
    [<ffffffff810fa150>] SyS_finit_module+0x80/0xb0
    [<ffffffff81502332>] entry_SYSCALL_64_fastpath+0x16/0x7a
    [<ffffffffffffffff>] 0xffffffffffffffff

Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v2.6.37
---
 drivers/infiniband/hw/mlx4/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8d88760..d79346e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1572,12 +1572,12 @@ static void update_gids_task(struct work_struct *work)
 	int is_bonded = mlx4_is_bonded(dev);
 
 	if (!gw->dev->ib_active)
-		return;
+		goto free;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
-		return;
+		goto free;
 	}
 
 	gids = mailbox->buf;
@@ -1595,6 +1595,8 @@ static void update_gids_task(struct work_struct *work)
 					       IB_EVENT_GID_CHANGE);
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
+
+free:
 	kfree(gw);
 }
 
@@ -1608,7 +1610,7 @@ static void reset_gids_task(struct work_struct *work)
 	struct mlx4_dev	*dev = gw->dev->dev;
 
 	if (!gw->dev->ib_active)
-		return;
+		goto free;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
