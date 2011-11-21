From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
	multicast response
Date: Mon, 21 Nov 2011 08:43:54 -0500
Message-ID: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This following can occur with ipoib when processing a multicast reponse:

BUG: soft lockup - CPU#0 stuck for 67s! [ib_mad1:982]
Modules linked in: ...
CPU 0:
Modules linked in: ...
Pid: 982, comm: ib_mad1 Not tainted 2.6.32-131.0.15.el6.x86_64 #1 ProLiant DL160 G5
RIP: 0010:[<ffffffff814ddb27>]  [<ffffffff814ddb27>] _spin_unlock_irqrestore+0x17/0x20
RSP: 0018:ffff8802119ed860  EFLAGS: 00000246
0000000000000004 RBX: ffff8802119ed860 RCX: 000000000000a299
RDX: ffff88021086c700 RSI: 0000000000000246 RDI: 0000000000000246
RBP: ffffffff8100bc8e R08: ffff880210ac229c R09: 0000000000000000
R10: ffff88021278aab8 R11: 0000000000000000 R12: ffff8802119ed860
R13: ffffffff8100be6e R14: 0000000000000001 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000006d4840 CR3: 0000000209aa5000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
[<ffffffffa032c247>] ? ipoib_mcast_send+0x157/0x480 [ib_ipoib]
[<ffffffff8100bc8e>] ? apic_timer_interrupt+0xe/0x20
[<ffffffff8100bc8e>] ? apic_timer_interrupt+0xe/0x20
[<ffffffffa03283d4>] ? ipoib_path_lookup+0x124/0x2d0 [ib_ipoib]
[<ffffffffa03286fc>] ? ipoib_start_xmit+0x17c/0x430 [ib_ipoib]
[<ffffffff8141e758>] ? dev_hard_start_xmit+0x2c8/0x3f0
[<ffffffff81439d0a>] ? sch_direct_xmit+0x15a/0x1c0
[<ffffffff81423098>] ? dev_queue_xmit+0x388/0x4d0
[<ffffffffa032d6b7>] ? ipoib_mcast_join_finish+0x2c7/0x510 [ib_ipoib]
[<ffffffffa032dab8>] ? ipoib_mcast_sendonly_join_complete+0x1b8/0x1f0 [ib_ipoib]
[<ffffffffa02a0946>] ? mcast_work_handler+0x1a6/0x710 [ib_sa]
[<ffffffffa015f01e>] ? ib_send_mad+0xfe/0x3c0 [ib_mad]
[<ffffffffa00f6c93>] ? ib_get_cached_lmc+0xa3/0xb0 [ib_core]
[<ffffffffa02a0f9b>] ? join_handler+0xeb/0x200 [ib_sa]
[<ffffffffa029e4fc>] ? ib_sa_mcmember_rec_callback+0x5c/0xa0 [ib_sa]
[<ffffffffa029e79c>] ? recv_handler+0x3c/0x70 [ib_sa]
[<ffffffffa01603a4>] ? ib_mad_completion_handler+0x844/0x9d0 [ib_mad]
[<ffffffffa015fb60>] ? ib_mad_completion_handler+0x0/0x9d0 [ib_mad]
[<ffffffff81088830>] ? worker_thread+0x170/0x2a0
[<ffffffff8108e160>] ? autoremove_wake_function+0x0/0x40
[<ffffffff810886c0>] ? worker_thread+0x0/0x2a0
[<ffffffff8108ddf6>] ? kthread+0x96/0xa0
[<ffffffff8100c1ca>] ? child_rip+0xa/0x20

Coinciding with stack trace is the following message:

ib0: ib_address_create failed

The code below in ipoib_mcast_join_finish() will note the above failure in the
address handle but otherwise continue:

                ah = ipoib_create_ah(dev, priv->pd, &av);
                if (!ah) {
                        ipoib_warn(priv, "ib_address_create failed\n");
                } else {

The while loop at the bottom of ipoib_mcast_join_finish() will attempt to send queued
multicast packets in mcast->pkt_queue and eventually end up in ipoib_mcast_send():

        if (!mcast->ah) {
                if (skb_queue_len(&mcast->pkt_queue) < IPOIB_MAX_MCAST_QUEUE)
                        skb_queue_tail(&mcast->pkt_queue, skb);
                else {
                        ++dev->stats.tx_dropped;
                        dev_kfree_skb_any(skb);
                }

My read is that the code will requeue the packet and return to the
ipoib_mcast_join_finish() while loop and the stage is set for the "hung" task
diagnostic as the while loop never sees a non-NULL ah, and will do nothing to
resolve.

There are GFP_ATOMIC allocates in the provider routines, so this is possible and
should be dealt with.

The test that induced the failure is associated with a host SM on the same
server during a shutdown.

This patch causes ipoib_mcast_join_finish() to exit with an error which will
flush the queued mcast packets.   Nothing is done to unwind the qp attached
state so that subsequent sends from above will retry the join.

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   13 ++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    7 +++++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 0ef9af9..4115be5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -57,21 +57,24 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 				 struct ib_pd *pd, struct ib_ah_attr *attr)
 {
 	struct ipoib_ah *ah;
+	struct ib_ah *vah;
 
 	ah = kmalloc(sizeof *ah, GFP_KERNEL);
 	if (!ah)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ah->dev       = dev;
 	ah->last_send = 0;
 	kref_init(&ah->ref);
 
-	ah->ah = ib_create_ah(pd, attr);
-	if (IS_ERR(ah->ah)) {
+	vah = ib_create_ah(pd, attr);
+	if (IS_ERR(vah)) {
 		kfree(ah);
-		ah = NULL;
-	} else
+		ah = (struct ipoib_ah *)vah;
+	} else {
+		ah->ah = vah;
 		ipoib_dbg(netdev_priv(dev), "Created ah %p\n", ah->ah);
+	}
 
 	return ah;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7567b60..37c46c6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -432,7 +432,7 @@ static void path_rec_completion(int status,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (ah) {
+	if (!IS_ERR_OR_NULL(ah)) {
 		path->pathrec = *pathrec;
 
 		old_ah   = path->ah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 1b7a976..30ca8f0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -240,8 +240,11 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 		av.grh.dgid = mcast->mcmember.mgid;
 
 		ah = ipoib_create_ah(dev, priv->pd, &av);
-		if (!ah) {
-			ipoib_warn(priv, "ib_address_create failed\n");
+		if (IS_ERR(ah)) {
+			ipoib_warn(priv, "ib_address_create failed %ld\n",
+				-PTR_ERR(ah));
+			/* use original error */
+			return PTR_ERR(ah);
 		} else {
 			spin_lock_irq(&priv->lock);
 			mcast->ah = ah;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
