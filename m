From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] iw_cxgb4: Fixes locking issue in process_mpa_request
Date: Fri,  7 Nov 2014 10:20:31 +0530
Message-ID: <1415335832-11413-2-git-send-email-hariprasad@chelsio.com>
References: <1415335832-11413-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415335832-11413-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=============================================
[ INFO: possible recursive locking detected ]
3.17.0+ #3 Tainted: G            E
---------------------------------------------
kworker/u64:3/299 is trying to acquire lock:
 (&epc->mutex){+.+.+.}, at: [<ffffffffa074e07a>]
process_mpa_request+0x1aa/0x3e0 [iw_cxgb4]

but task is already holding lock:
 (&epc->mutex){+.+.+.}, at: [<ffffffffa074e34e>] rx_data+0x9e/0x1f0 [iw_cxgb4]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&epc->mutex);
  lock(&epc->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u64:3/299:
 #0:  ("%s""iw_cxgb4"){.+.+.+}, at: [<ffffffff8106f14d>]
process_one_work+0x13d/0x4d0
 #1:  (skb_work){+.+.+.}, at: [<ffffffff8106f14d>] process_one_work+0x13d/0x4d0
 #2:  (&epc->mutex){+.+.+.}, at: [<ffffffffa074e34e>] rx_data+0x9e/0x1f0
[iw_cxgb4]

stack backtrace:
CPU: 2 PID: 299 Comm: kworker/u64:3 Tainted: G            E  3.17.0+ #3
Hardware name: Dell Inc. PowerEdge T110/0X744K, BIOS 1.2.1 01/28/2010
Workqueue: iw_cxgb4 process_work [iw_cxgb4]
 ffff8800b91593d0 ffff8800b8a2f9f8 ffffffff815df107 0000000000000001
 ffff8800b9158750 ffff8800b8a2fa28 ffffffff8109f0e2 ffff8800bb768a00
 ffff8800b91593d0 ffff8800b9158750 0000000000000000 ffff8800b8a2fa88
Call Trace:
 [<ffffffff815df107>] dump_stack+0x49/0x62
 [<ffffffff8109f0e2>] print_deadlock_bug+0xf2/0x100
 [<ffffffff810a0f04>] validate_chain+0x454/0x700
 [<ffffffff810a1574>] __lock_acquire+0x3c4/0x580
 [<ffffffffa074e07a>] ? process_mpa_request+0x1aa/0x3e0 [iw_cxgb4]
 [<ffffffff810a17cc>] lock_acquire+0x9c/0x110
 [<ffffffffa074e07a>] ? process_mpa_request+0x1aa/0x3e0 [iw_cxgb4]
 [<ffffffff815e111b>] mutex_lock_nested+0x4b/0x360
 [<ffffffffa074e07a>] ? process_mpa_request+0x1aa/0x3e0 [iw_cxgb4]
 [<ffffffff810c181a>] ? del_timer_sync+0xaa/0xd0
 [<ffffffff810c1770>] ? try_to_del_timer_sync+0x70/0x70
 [<ffffffffa074e07a>] process_mpa_request+0x1aa/0x3e0 [iw_cxgb4]
 [<ffffffffa074a3ec>] ? update_rx_credits+0xec/0x140 [iw_cxgb4]
 [<ffffffffa074e381>] rx_data+0xd1/0x1f0 [iw_cxgb4]
 [<ffffffff8109ff23>] ? mark_held_locks+0x73/0xa0
 [<ffffffff815e4b90>] ? _raw_spin_unlock_irqrestore+0x40/0x70
 [<ffffffff810a020d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 [<ffffffff810a02dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa074c931>] process_work+0x51/0x80 [iw_cxgb4]
 [<ffffffff8106f1c8>] process_one_work+0x1b8/0x4d0
 [<ffffffff8106f14d>] ? process_one_work+0x13d/0x4d0
 [<ffffffff8106f600>] worker_thread+0x120/0x3c0
 [<ffffffff8106f4e0>] ? process_one_work+0x4d0/0x4d0
 [<ffffffff81074a0e>] kthread+0xde/0x100
 [<ffffffff815e4b40>] ? _raw_spin_unlock_irq+0x30/0x40
 [<ffffffff81074930>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815e512c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81074930>] ? __init_kthread_worker+0x70/0x70
===============================================

Based on original work by Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index fb61f66..ce87fd3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1640,7 +1640,8 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 		__state_set(&ep->com, MPA_REQ_RCVD);
 
 		/* drive upcall */
-		mutex_lock(&ep->parent_ep->com.mutex);
+		mutex_lock_nested(&ep->parent_ep->com.mutex,
+				  SINGLE_DEPTH_NESTING);
 		if (ep->parent_ep->com.state != DEAD) {
 			if (connect_request_upcall(ep))
 				abort_connection(ep, skb, GFP_KERNEL);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
