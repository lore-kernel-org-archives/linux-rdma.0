From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/ipoib: eliminate nested locking of the vlan mutex
Date: Sun, 15 Jan 2012 17:31:48 +0200
Message-ID: <alpine.LRH.2.00.1201151731410.25738@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201111905150.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111905150.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

do nested flushing only if the device isn't a child

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

----

setting CONFIG_DEBUG_MUTEXES I see the below warning, however,
for some reason, I didn't manage to trigger it without my other
patch that adds the clones, I don't see how that patch could
be the reason for the warning, as the code always goes nested,
I've instrumented the flush code to dump its caller/stack and
indeed, you can see that the flushing code is called recursively
and should have that warning, but it doesn't...

ib0.8001: downing ib_dev
ib0: downing ib_dev
ib0: ipoib_ib_dev_flush_light called
ib0: __ipoib_ib_dev_flush pid 29251
Pid: 29251, comm: kworker/u:1 Not tainted 3.2.0-06106-g75f0703-dirty #16
Call Trace:
 [<ffffffffa02b5e1e>] __ipoib_ib_dev_flush+0x57/0x204 [ib_ipoib]
 [<ffffffffa02b6057>] ? ipoib_ib_dev_flush_normal+0x46/0x46 [ib_ipoib]
 [<ffffffffa02b6096>] ipoib_ib_dev_flush_light+0x3f/0x43 [ib_ipoib]
 [<ffffffff81041ee6>] process_one_work+0x2bd/0x4a6
 [<ffffffff81041e39>] ? process_one_work+0x210/0x4a6
 [<ffffffff810424e6>] worker_thread+0x1d6/0x350
 [<ffffffff81042310>] ? rescuer_thread+0x241/0x241
 [<ffffffff81045d5a>] kthread+0x84/0x8c
 [<ffffffff81366ee4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810514d1>] ? finish_task_switch+0x154/0x156
 [<ffffffff8135f243>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff8135f59d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81045cd6>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff81366ee0>] ? gs_change+0xb/0xb
ib0.8001: __ipoib_ib_dev_flush pid 29251
Pid: 29251, comm: kworker/u:1 Not tainted 3.2.0-06106-g75f0703-dirty #16
Call Trace:
 [<ffffffffa02b5e1e>] __ipoib_ib_dev_flush+0x57/0x204 [ib_ipoib]
 [<ffffffffa02b5e4e>] __ipoib_ib_dev_flush+0x87/0x204 [ib_ipoib]
 [<ffffffffa02b6057>] ? ipoib_ib_dev_flush_normal+0x46/0x46 [ib_ipoib]
 [<ffffffffa02b6096>] ipoib_ib_dev_flush_light+0x3f/0x43 [ib_ipoib]
 [<ffffffff81041ee6>] process_one_work+0x2bd/0x4a6
 [<ffffffff81041e39>] ? process_one_work+0x210/0x4a6
 [<ffffffff810424e6>] worker_thread+0x1d6/0x350
 [<ffffffff81042310>] ? rescuer_thread+0x241/0x241
 [<ffffffff81045d5a>] kthread+0x84/0x8c
 [<ffffffff81366ee4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810514d1>] ? finish_task_switch+0x154/0x156
 [<ffffffff8135f243>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff8135f59d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81045cd6>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff81366ee0>] ? gs_change+0xb/0xb

---

=============================================
[ INFO: possible recursive locking detected ]
3.2.0-06106-g75f0703-dirty #16 Not tainted
---------------------------------------------
kworker/u:2/1578 is trying to acquire lock:
 (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

but task is already holding lock:
 (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&priv->vlan_mutex);
  lock(&priv->vlan_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u:2/1578:
 #0:  (ipoib){.+.+.+}, at: [<ffffffff81041e39>] process_one_work+0x210/0x4a6
 #1:  ((&priv->flush_heavy)){+.+...}, at: [<ffffffff81041e39>] process_one_work+0x210/0x4a6
 #2:  (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

stack backtrace:
Pid: 1578, comm: kworker/u:2 Not tainted 3.2.0-06106-g75f0703-dirty #16
Call Trace:
 [<ffffffff81029a02>] ? console_unlock+0x10c/0x207
 [<ffffffff810668a6>] __lock_acquire+0x16b5/0x174e
 [<ffffffff8100ca22>] ? save_stack_trace+0x2a/0x47
 [<ffffffff81066a2f>] lock_acquire+0xf0/0x116
 [<ffffffffa021ae9f>] ? __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]
 [<ffffffff8135cbb9>] mutex_lock_nested+0x64/0x2e6
 [<ffffffffa021ae9f>] ? __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]
 [<ffffffff81063bad>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffffa021ae9f>] __ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]
 [<ffffffffa021aec5>] __ipoib_ib_dev_flush+0x52/0x1cf [ib_ipoib]
 [<ffffffff81063bad>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffffa021b042>] ? __ipoib_ib_dev_flush+0x1cf/0x1cf [ib_ipoib]
 [<ffffffffa021b057>] ipoib_ib_dev_flush_heavy+0x15/0x17 [ib_ipoib]
 [<ffffffff81041ee6>] process_one_work+0x2bd/0x4a6
 [<ffffffff81041e39>] ? process_one_work+0x210/0x4a6
 [<ffffffff8135f243>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff810424e6>] worker_thread+0x1d6/0x350
 [<ffffffff81042310>] ? rescuer_thread+0x241/0x241
 [<ffffffff81045d5a>] kthread+0x84/0x8c
 [<ffffffff81366ee4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8135f59d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81045cd6>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff81366ee0>] ? gs_change+0xb/0xb
ADDRCONF(NETDEV_CHANGE): ib0.8001: link becomes ready
ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready

 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5c1bc99..cac2b71 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -934,16 +934,18 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	struct net_device *dev = priv->dev;
 	u16 new_index;

-	mutex_lock(&priv->vlan_mutex);
+	if (!priv->parent) {
+		mutex_lock(&priv->vlan_mutex);

-	/*
-	 * Flush any child interfaces too -- they might be up even if
-	 * the parent is down.
-	 */
-	list_for_each_entry(cpriv, &priv->child_intfs, list)
-		__ipoib_ib_dev_flush(cpriv, level);
+		/*
+		 * Flush any child interfaces too -- they might be up even if
+		 * the parent is down.
+		 */
+		list_for_each_entry(cpriv, &priv->child_intfs, list)
+			__ipoib_ib_dev_flush(cpriv, level);

-	mutex_unlock(&priv->vlan_mutex);
+		mutex_unlock(&priv->vlan_mutex);
+	}

 	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
