From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 02/10] IB/mlx5: Avoid hangs due to a missing completion
Date: Thu,  8 Nov 2018 21:10:09 +0200
Message-ID: <20181108191017.21891-3-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Fix 2 flows that may cause a process to hang on wait_for_completion():

1. When callback for create MKEY command returns with bad status
2. When callback for create MKEY command is called before executer of
command calls wait_for_completion()

The following call trace might be triggered in the above flows:

INFO: task echo_server:1655 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
echo_server     D ffff880813fb6898     0  1655      1 0x00000004
 ffff880423f5b880 0000000000000086 ffff880402290fd0 ffff880423f5bfd8
 ffff880423f5bfd8 ffff880423f5bfd8 ffff880402290fd0 ffff880813fb68a0
 7fffffffffffffff ffff880813fb6898 ffff880402290fd0 ffff880813fb6898
Call Trace:
 [<ffffffff816a94c9>] schedule+0x29/0x70
 [<ffffffff816a6fd9>] schedule_timeout+0x239/0x2c0
 [<ffffffffc07309e2>] ? mlx5_cmd_exec_cb+0x22/0x30 [mlx5_core]
 [<ffffffffc073e697>] ? mlx5_core_create_mkey_cb+0xb7/0x220 [mlx5_core]
 [<ffffffff811b94b7>] ? mm_drop_all_locks+0xd7/0x110
 [<ffffffff816a987d>] wait_for_completion+0xfd/0x140
 [<ffffffff810c4810>] ? wake_up_state+0x20/0x20
 [<ffffffffc08fd308>] mlx5_mr_cache_alloc+0xa8/0x170 [mlx5_ib]
 [<ffffffffc0909626>] implicit_mr_alloc+0x36/0x190 [mlx5_ib]
 [<ffffffffc090a26e>] mlx5_ib_alloc_implicit_mr+0x4e/0xa0 [mlx5_ib]
 [<ffffffffc08ff2f3>] mlx5_ib_reg_user_mr+0x93/0x6a0 [mlx5_ib]
 [<ffffffffc0907410>] ? mlx5_ib_exp_query_device+0xab0/0xbc0 [mlx5_ib]
 [<ffffffffc04998be>] ib_uverbs_exp_reg_mr+0x2fe/0x550 [ib_uverbs]
 [<ffffffff811edaff>] ? do_huge_pmd_anonymous_page+0x2bf/0x530
 [<ffffffffc048f6cc>] ib_uverbs_write+0x3ec/0x490 [ib_uverbs]
 [<ffffffff81200d2d>] vfs_write+0xbd/0x1e0
 [<ffffffff81201b3f>] SyS_write+0x7f/0xe0
 [<ffffffff816b4fc9>] system_call_fastpath+0x16/0x1b

Fixes: 49780d42dfc9 ("IB/mlx5: Expose MR cache for mlx5_ib")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/mr.c      | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b651a7a6fde9..cd9335e368bd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -644,6 +644,7 @@ struct mlx5_cache_ent {
 	struct delayed_work	dwork;
 	int			pending;
 	struct completion	compl;
+	atomic_t		do_complete;
 };

 struct mlx5_mr_cache {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9b195d65a13e..259dd49c6874 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -143,7 +143,7 @@ static void reg_mr_callback(int status, void *context)
 		kfree(mr);
 		dev->fill_delay = 1;
 		mod_timer(&dev->delay_timer, jiffies + HZ);
-		return;
+		goto do_complete;
 	}

 	mr->mmkey.type = MLX5_MKEY_MR;
@@ -167,8 +167,13 @@ static void reg_mr_callback(int status, void *context)
 		pr_err("Error inserting to mkey tree. 0x%x\n", -err);
 	write_unlock_irqrestore(&table->lock, flags);

-	if (!completion_done(&ent->compl))
+do_complete:
+	spin_lock_irqsave(&ent->lock, flags);
+	if (atomic_read(&ent->do_complete)) {
 		complete(&ent->compl);
+		atomic_dec(&ent->do_complete);
+	}
+	spin_unlock_irqrestore(&ent->lock, flags);
 }

 static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
@@ -476,9 +481,12 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev, int entry)
 		if (list_empty(&ent->head)) {
 			spin_unlock_irq(&ent->lock);

+			atomic_inc(&ent->do_complete);
 			err = add_keys(dev, entry, 1);
-			if (err && err != -EAGAIN)
+			if (err && err != -EAGAIN) {
+				atomic_dec(&ent->do_complete);
 				return ERR_PTR(err);
+			}

 			wait_for_completion(&ent->compl);
 		} else {
@@ -687,6 +695,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		ent->order = i + 2;
 		ent->dev = dev;
 		ent->limit = 0;
+		atomic_set(&ent->do_complete, 0);

 		init_completion(&ent->compl);
 		INIT_WORK(&ent->work, cache_work_func);
