From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: [IPoIB] Missing join mcast events causing full machine lockup
Date: Thu, 21 Jul 2016 10:31:03 +0300
Message-ID: <57907A37.3000902@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, 

With running the risk of sounding like a broken record, I came across 
another case where ipoib can cause the machine to go haywire due to 
missed join requests. This is on 4.4.14 kernel. Here is what I believe 
happens:

1. Ipoib connectivity breaks, which causes a workqueue task to stall: : 
[1297655.474707] kworker/u96:1   D ffff88026b057c48     0  6581      2 0x00000000
[1297655.474714] Workqueue: ipoib_wq ipoib_mcast_restart_task [ib_ipoib]
[1297655.474715]  ffff88026b057c48 ffff883ff29c6040 ffff880b2b5f2940 ffff88026b058000
[1297655.474717]  7fffffffffffffff ffff8820e2f809d8 ffff880b2b5f2940 ffff880b2b5f2940
[1297655.474718]  ffff88026b057c60 ffffffff816103dc ffff8820e2f809d0 ffff88026b057ce0
[1297655.474720] Call Trace:
[1297655.474722]  [<ffffffff816103dc>] schedule+0x3c/0x90
[1297655.474724]  [<ffffffff81613642>] schedule_timeout+0x202/0x260
[1297655.474728]  [<ffffffff81308645>] ? find_next_bit+0x15/0x20
[1297655.474734]  [<ffffffff812f409f>] ? cpumask_next_and+0x2f/0x40
[1297655.474737]  [<ffffffff8108db8c>] ? load_balance+0x1cc/0x9a0
[1297655.474739]  [<ffffffff816118df>] wait_for_completion+0xcf/0x130
[1297655.474742]  [<ffffffff8107cd30>] ? wake_up_q+0x70/0x70
[1297655.474745]  [<ffffffffa02de354>] ipoib_mcast_restart_task+0x3a4/0x4d0 [ib_ipoib]
[1297655.474748]  [<ffffffff81079a86>] ? finish_task_switch+0x76/0x220
[1297655.474750]  [<ffffffff8106bdf9>] process_one_work+0x159/0x450
[1297655.474752]  [<ffffffff8106c4a9>] worker_thread+0x69/0x490
[1297655.474753]  [<ffffffff8106c440>] ? rescuer_thread+0x350/0x350
[1297655.474755]  [<ffffffff8106c440>] ? rescuer_thread+0x350/0x350
[1297655.474757]  [<ffffffff8107161f>] kthread+0xef/0x110
[1297655.474759]  [<ffffffff81071530>] ? kthread_park+0x60/0x60
[1297655.474761]  [<ffffffff816149ff>] ret_from_fork+0x3f/0x70
[1297655.474763]  [<ffffffff81071530>] ? kthread_park+0x60/0x60

ipoib_mcast_restart_task+0x3a4 corresponds to: 


/*
 * make sure the in-flight joins have finished before we attempt
 * to leave
 */
 list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
 	if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
        	wait_for_completion(&mcast->done);

However, wait_for_completion never returns. Admin logs on the
node and issues a command to down the ib0 interface with the
hopes of resolving the situation, this in turn leads to the 
following backtrace: 
[1297655.475229] ip              D ffff8820cc1e35a8     0 24895      1 0x00000004
[1297655.475231]  ffff8820cc1e35a8 ffff883fbf2a2940 ffff88239d7ae040 ffff8820cc1e4000
[1297655.475233]  7fffffffffffffff ffff8820cc1e3700 ffff88239d7ae040 ffff88239d7ae040
[1297655.475234]  ffff8820cc1e35c0 ffffffff816103dc ffff8820cc1e36f8 ffff8820cc1e3640
[1297655.475236] Call Trace:
[1297655.475238]  [<ffffffff816103dc>] schedule+0x3c/0x90
[1297655.475239]  [<ffffffff81613642>] schedule_timeout+0x202/0x260
[1297655.475241]  [<ffffffff8107c8b9>] ? try_to_wake_up+0x49/0x430
[1297655.475244]  [<ffffffff810b0f94>] ? lock_timer_base.isra.37+0x54/0x70
[1297655.475246]  [<ffffffff816118df>] wait_for_completion+0xcf/0x130
[1297655.475247]  [<ffffffff8107cd30>] ? wake_up_q+0x70/0x70
[1297655.475249]  [<ffffffff8106986a>] flush_workqueue+0x11a/0x5d0
[1297655.475253]  [<ffffffffa02dda76>] ipoib_mcast_stop_thread+0x46/0x50 [ib_ipoib]
[1297655.475255]  [<ffffffffa02dbca2>] ipoib_ib_dev_down+0x22/0x40 [ib_ipoib]
[1297655.475257]  [<ffffffffa02d7f8d>] ipoib_stop+0x2d/0xb0 [ib_ipoib]
[1297655.475261]  [<ffffffff81546f28>] __dev_close_many+0x98/0xf0
[1297655.475263]  [<ffffffff815470d6>] __dev_close+0x36/0x50
[1297655.475266]  [<ffffffff8154ff6d>] __dev_change_flags+0x9d/0x160
[1297655.475268]  [<ffffffff81550059>] dev_change_flags+0x29/0x70
[1297655.475269]  [<ffffffff81308645>] ? find_next_bit+0x15/0x20
[1297655.475271]  [<ffffffff8155de2b>] do_setlink+0x5db/0xad0
[1297655.475272]  [<ffffffff8108d115>] ? update_sd_lb_stats+0x115/0x510
[1297655.475275]  [<ffffffff8114898c>] ? zone_statistics+0x7c/0xa0
[1297655.475277]  [<ffffffff8114898c>] ? zone_statistics+0x7c/0xa0
[1297655.475278]  [<ffffffff8114898c>] ? zone_statistics+0x7c/0xa0
[1297655.475283]  [<ffffffff8131e972>] ? nla_parse+0x32/0x100
[1297655.475284]  [<ffffffff8155f498>] rtnl_newlink+0x528/0x8c0
[1297655.475289]  [<ffffffff81131ed6>] ? __alloc_pages_nodemask+0x1a6/0xb90
[1297655.475291]  [<ffffffff8131e972>] ? nla_parse+0x32/0x100
[1297655.475293]  [<ffffffff8155c9e2>] rtnetlink_rcv_msg+0x92/0x230
[1297655.475295]  [<ffffffff815392aa>] ? __alloc_skb+0x7a/0x1d0
[1297655.475296]  [<ffffffff8155c950>] ? rtnetlink_rcv+0x30/0x30
[1297655.475298]  [<ffffffff8157ef84>] netlink_rcv_skb+0xa4/0xc0
[1297655.475299]  [<ffffffff8155c948>] rtnetlink_rcv+0x28/0x30
[1297655.475301]  [<ffffffff8157e763>] netlink_unicast+0x103/0x180
[1297655.475303]  [<ffffffff8157ec9c>] netlink_sendmsg+0x4bc/0x5d0
[1297655.475305]  [<ffffffff81531748>] sock_sendmsg+0x38/0x50
[1297655.475306]  [<ffffffff81531c55>] ___sys_sendmsg+0x285/0x290
[1297655.475308]  [<ffffffff8153097f>] ? sock_destroy_inode+0x2f/0x40
[1297655.475310]  [<ffffffff811b39fe>] ? evict+0x12e/0x190
[1297655.475312]  [<ffffffff811ae9ee>] ? dentry_free+0x4e/0x90
[1297655.475313]  [<ffffffff811af6f2>] ? __dentry_kill+0x162/0x1e0
[1297655.475315]  [<ffffffff811af965>] ? dput+0x1f5/0x230
[1297655.475317]  [<ffffffff811b8c24>] ? mntput+0x24/0x40
[1297655.475319]  [<ffffffff8119a968>] ? __fput+0x188/0x1f0
[1297655.475320]  [<ffffffff81532322>] __sys_sendmsg+0x42/0x80
[1297655.475322]  [<ffffffff81532372>] SyS_sendmsg+0x12/0x20
[1297655.475324]  [<ffffffff8161465b>] entry_SYSCALL_64_fastpath+0x16/0x6e

The bad thing that happens here is that this task hangs on waiting 
the flushing of the workqueue (with rtnl_lock held), which never 
completes due to ipoib_mcast_restart_task being hung on the join. 

This makes me wonder if using timeouts is actually better than
blindly relying on completing the join. So Doug, what would
you say about the following as a proposed fix (not tested):

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 87799de90a1d..f6f15d36b02d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -947,7 +947,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
         */
        list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
                if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-                       wait_for_completion(&mcast->done);
+                       wait_for_completion_timeout(&mcast->done, 30 * HZ);
 
        list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
                ipoib_mcast_leave(mcast->dev, mcast);

Given the loop afterwards which uses ipoib_mcast_(leave_free) that should work?
Looking at the code in ipoib_mcast_leave it seems we are going to trigger a warning, 
which is preferable to putting the machine to a grinding halt? 

Does the proposed patch break things horribly ?

Regards, 
Nikolay 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
