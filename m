From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA/uverbs: Fix race between uverbs_close and remove_one
Date: Mon,  7 Mar 2016 00:31:32 -0500
Message-ID: <1457328692-884-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixes: 35d4a0b63dc0c6d1177d4f532a9deae958f0662c
("IB/uverbs: Fix race between ib_uverbs_open and remove_one")

While testing ocrdma for disassociate_ucontext support following
kernel panic was seen:

BUG: unable to handle kernel paging request at ffffffffa07ccd7a
[67139.981020] IP: [<ffffffffa07ccd7a>] 0xffffffffa07ccd7a
[67139.987185] PGD 19c5067 PUD 19c6063 PMD 469d08067 PTE 0
[67139.993370] Oops: 0010 [#1] SMP
[67140.257286] Call Trace:
[67140.260665]  [<ffffffff810c16a0>] ? prepare_to_wait_event+0xf0/0xf0
[67140.268337]  [<ffffffffa04cabc3>] ? ib_dereg_mr+0x23/0x30 [ib_core]
[67140.276009]  [<ffffffffa03ee5f0>] ? ib_uverbs_cleanup_ucontext+0x320/0x440 [ib_uverbs]
[67140.285550]  [<ffffffffa03ee9e9>] ? ib_uverbs_close+0x59/0xb0 [ib_uverbs]
[67140.293807]  [<ffffffff811ff744>] ? __fput+0xe4/0x210
[67140.300132]  [<ffffffff811ff8ae>] ? ____fput+0xe/0x10
[67140.306457]  [<ffffffff8109b697>] ? task_work_run+0x77/0x90
[67140.313388]  [<ffffffff81081af2>] ? do_exit+0x2d2/0xab0
[67140.319910]  [<ffffffff8108234f>] ? do_group_exit+0x3f/0xa0
[67140.326821]  [<ffffffff8108d54c>] ? get_signal+0x1cc/0x5e0
[67140.333635]  [<ffffffff81017387>] ? do_signal+0x37/0x660
[67140.340257]  [<ffffffffa021669a>] ? ucma_write+0x7a/0xc0 [rdma_ucm]
[67140.347949]  [<ffffffff81079c37>] ? exit_to_usermode_loop+0x59/0xa2
[67140.355651]  [<ffffffff81003bad>] ? syscall_return_slowpath+0x8d/0xa0
[67140.363554]  [<ffffffff81680dcc>] ? int_ret_from_sys_call+0x25/0x8f
[67140.371259] Code:  Bad RIP value.
[67140.375678] RIP  [<ffffffffa07ccd7a>] 0xffffffffa07ccd7a
[67140.382314]  RSP <ffff880867727ad8>
[67140.386894] CR2: ffffffffa07ccd7a
[67140.393737] ---[ end trace 807b4472c30412d0 ]---
[67141.682413] Kernel panic - not syncing: Fatal exception
[67141.682431] Kernel Offset: disabled
[67141.733934] ---[ end Kernel panic - not syncing: Fatal exception

Root Cause:

During rmmod <vendor-driver> "ib_uverbs_close()" context is
still running, while "ib_uverbs_remove_one()" context completes and
ends up freeing ib_dev pointer, thus causing a Kernel Panic.

This patch fixes the race. ib_uverbs_close validates dev->ib_dev against NULL
inside an srcu lock. If it is NULL, it waits for a completion and drops the srcu
else continues with the normal flow.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..94a7339 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -121,6 +121,7 @@ struct ib_uverbs_file {
 	struct ib_event_handler			event_handler;
 	struct ib_uverbs_event_file	       *async_file;
 	struct list_head			list;
+	struct completion			fcomp;
 	int					is_closed;
 };
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 39680ae..f1948bc 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -928,6 +928,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	file->async_file = NULL;
 	kref_init(&file->ref);
 	mutex_init(&file->mutex);
+	init_completion(&file->fcomp);
 
 	filp->private_data = file;
 	kobject_get(&dev->kobj);
@@ -954,21 +955,33 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_device *dev = file->device;
 	struct ib_ucontext *ucontext = NULL;
+	struct ib_device *ib_dev;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
+	ib_dev = srcu_dereference(dev->ib_dev,
+				  &dev->disassociate_srcu);
+	if (!ib_dev)
+		goto out;
 
-	mutex_lock(&file->device->lists_mutex);
+	mutex_lock(&dev->lists_mutex);
 	ucontext = file->ucontext;
 	file->ucontext = NULL;
 	if (!file->is_closed) {
 		list_del(&file->list);
 		file->is_closed = 1;
 	}
-	mutex_unlock(&file->device->lists_mutex);
+	mutex_unlock(&dev->lists_mutex);
 	if (ucontext)
 		ib_uverbs_cleanup_ucontext(file, ucontext);
 
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
 
+	complete(&file->fcomp);
+out:
+	wait_for_completion(&file->fcomp);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 	kref_put(&file->ref, ib_uverbs_release_file);
 	kobject_put(&dev->kobj);
 
@@ -1199,6 +1212,8 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 		}
 
 		mutex_lock(&uverbs_dev->lists_mutex);
+
+		complete(&file->fcomp);
 		kref_put(&file->ref, ib_uverbs_release_file);
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
