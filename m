From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/uverbs: Fix NULL pointer dereference during device removal
Date: Wed, 16 Aug 2017 18:57:04 +0300
Message-ID: <20170816155704.23997-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

As part of ib_uverbs_remove_one which might be triggered upon
reset flow, we trigger IB_EVENT_DEVICE_FATAL event to userspace
application.
If device was removed after uverbs fd was opened but before
ib_uverbs_get_context was called, the event file will be accessed
before it was allocated, result in NULL pointer dereference:

[ 72.325873] BUG: unable to handle kernel NULL pointer dereference at (null)
...
[ 72.325984] IP: _raw_spin_lock_irqsave+0x22/0x40
[ 72.327123] Call Trace:
[ 72.327168] ib_uverbs_async_handler.isra.8+0x2e/0x160 [ib_uverbs]
[ 72.327216] ? synchronize_srcu_expedited+0x27/0x30
[ 72.327269] ib_uverbs_remove_one+0x120/0x2c0 [ib_uverbs]
[ 72.327330] ib_unregister_device+0xd0/0x180 [ib_core]
[ 72.327373] mlx5_ib_remove+0x74/0x140 [mlx5_ib]
[ 72.327422] mlx5_remove_device+0xfb/0x110 [mlx5_core]
[ 72.327466] mlx5_unregister_interface+0x3c/0xa0 [mlx5_core]
[ 72.327509] mlx5_ib_cleanup+0x10/0x962 [mlx5_ib]
[ 72.327546] SyS_delete_module+0x155/0x230
[ 72.328472] ? exit_to_usermode_loop+0x70/0xa6
[ 72.329370] do_syscall_64+0x54/0xc0
[ 72.330262] entry_SYSCALL64_slow_path+0x25/0x25

Fix it by checking that user context was allocated before
trigger the event.

Fixes: 036b10635739 ('IB/uverbs: Enable device removal when there are active user space applications')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index c023e2c81b8f..5e530d2bee44 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1153,7 +1153,6 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 		kref_get(&file->ref);
 		mutex_unlock(&uverbs_dev->lists_mutex);

-		ib_uverbs_event_handler(&file->event_handler, &event);

 		mutex_lock(&file->cleanup_mutex);
 		ucontext = file->ucontext;
@@ -1170,6 +1169,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 			 * for example due to freeing the resources
 			 * (e.g mmput).
 			 */
+			ib_uverbs_event_handler(&file->event_handler, &event);
 			ib_dev->disassociate_ucontext(ucontext);
 			mutex_lock(&file->cleanup_mutex);
 			ib_uverbs_cleanup_ucontext(file, ucontext, true);
--
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
