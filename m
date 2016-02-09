From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 1/1] IB/ipoib: fix for rare multicast join race condition
Date: Tue, 09 Feb 2016 14:35:25 -0500
Message-ID: <20160209193525.20351.78895.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A narrow window for race condition still exist between
multicast join thread and *dev_flush workers.
A kernel crash caused by prolong erratic link state changes
was observed (most likely a faulty cabling):

[167275.656270] BUG: unable to handle kernel NULL pointer dereference at
0000000000000020
[167275.665973] IP: [<ffffffffa05f8f2e>] ipoib_mcast_join+0xae/0x1d0 [ib_ipoib]
[167275.674443] PGD 0
[167275.677373] Oops: 0000 [#1] SMP
...
[167275.977530] Call Trace:
[167275.982225]  [<ffffffffa05f92f0>] ? ipoib_mcast_free+0x200/0x200 [ib_ipoib]
[167275.992024]  [<ffffffffa05fa1b7>] ipoib_mcast_join_task+0x2a7/0x490
[ib_ipoib]
[167276.002149]  [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
[167276.010754]  [<ffffffff8109e3cb>] worker_thread+0x11b/0x400
[167276.019088]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[167276.027737]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
Here was a hit spot:
ipoib_mcast_join() {
..............
      rec.qkey      = priv->broadcast->mcmember.qkey;
                                       ^^^^^^^
.....
 }
Proposed patch should prevent multicast join task to continue
if link state change is detected.

Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Chages from v2:
- Move check for OPER_UP flag state to mcast_join() to
ensure no event worker is in progress.
- minor style fixes.

Changes from v1:
No need to lock again if error detected.
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 050dfa1..6320d39 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -456,7 +456,7 @@ out_locked:
 	return status;
 }
 
-static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
+static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_sa_multicast *multicast;
@@ -466,6 +466,10 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 	ib_sa_comp_mask comp_mask;
 	int ret = 0;
 
+	if (!priv->broadcast ||
+	    !test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
+		return -EINVAL;
+
 	ipoib_dbg_mcast(priv, "joining MGID %pI6\n", mcast->mcmember.mgid.raw);
 
 	rec.mgid     = mcast->mcmember.mgid;
@@ -539,6 +543,7 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 	}
+	return 0;
 }
 
 void ipoib_mcast_join_task(struct work_struct *work)
@@ -621,7 +626,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
 				init_completion(&mcast->done);
 				set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 				spin_unlock_irq(&priv->lock);
-				ipoib_mcast_join(dev, mcast);
+				if (!ipoib_mcast_join(dev, mcast))
+					return;
 				spin_lock_irq(&priv->lock);
 			} else if (!delay_until ||
 				 time_before(mcast->delay_until, delay_until))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
