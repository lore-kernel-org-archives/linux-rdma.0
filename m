From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Warning about possible recursive locking detected in IPoIB
Date: Thu, 23 May 2013 17:23:30 +0200
Message-ID: <519E3472.3050708@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020205080208050400050906"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020205080208050400050906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Or,

I saw below warning when enable CONFIG_DEBUG_MUTEXES


> 1893 May 21 08:56:32 ib2 kernel: [   44.738725] =============================================
>  1894 May 21 08:56:32 ib2 kernel: [   44.738782] [ INFO: possible recursive locking detected ]
>  1895 May 21 08:56:32 ib2 kernel: [   44.738841] 3.9.0-rc7-pserver #4 Tainted: G           O
>  1896 May 21 08:56:32 ib2 kernel: [   44.738896] ---------------------------------------------
>  1897 May 21 08:56:32 ib2 kernel: [   44.738953] kworker/u:5/238 is trying to acquire lock:
>  1898 May 21 08:56:32 ib2 kernel: [   44.739008]  (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa073f36c>] __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1899 May 21 08:56:32 ib2 kernel: [   44.739218]
>  1900 May 21 08:56:32 ib2 kernel: [   44.739218] but task is already holding lock:
>  1901 May 21 08:56:32 ib2 kernel: [   44.739328]  (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa073f36c>] __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1902 May 21 08:56:32 ib2 kernel: [   44.739537]
>  1903 May 21 08:56:32 ib2 kernel: [   44.739537] other info that might help us debug this:
>  1904 May 21 08:56:32 ib2 kernel: [   44.739613]  Possible unsafe locking scenario:
>  1905 May 21 08:56:32 ib2 kernel: [   44.739613]
>  1906 May 21 08:56:32 ib2 kernel: [   44.739688]        CPU0
>  1907 May 21 08:56:32 ib2 kernel: [   44.739741]        ----
>  1908 May 21 08:56:32 ib2 kernel: [   44.739791]   lock(&priv->vlan_mutex);
>  1909 May 21 08:56:32 ib2 kernel: [   44.739902]   lock(&priv->vlan_mutex);
>  1910 May 21 08:56:32 ib2 kernel: [   44.740014]
>  1911 May 21 08:56:32 ib2 kernel: [   44.740014]  *** DEADLOCK ***
>  1912 May 21 08:56:32 ib2 kernel: [   44.740014]
>  1913 May 21 08:56:32 ib2 kernel: [   44.740103]  May be due to missing lock nesting notation
>  1914 May 21 08:56:32 ib2 kernel: [   44.740103]
>  1915 May 21 08:56:32 ib2 kernel: [   44.740213] 3 locks held by kworker/u:5/238:
>  1916 May 21 08:56:32 ib2 kernel: [   44.740266]  #0:  (ipoib){.+.+.+}, at: [<ffffffff81067755>] process_one_work+0x165/0x560
>  1917 May 21 08:56:32 ib2 kernel: [   44.740495]  #1:  ((&priv->flush_heavy)){+.+...}, at: [<ffffffff81067755>] process_one_work+0x165/0x560
>  1918 May 21 08:56:32 ib2 kernel: [   44.740725]  #2:  (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa073f36c>] __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1919 May 21 08:56:32 ib2 kernel: [   44.740961]
>  1920 May 21 08:56:32 ib2 kernel: [   44.740961] stack backtrace:
>  1921 May 21 08:56:32 ib2 kernel: [   44.741035] Pid: 238, comm: kworker/u:5 Tainted: G           O 3.9.0-rc7-pserver #4
>  1922 May 21 08:56:32 ib2 kernel: [   44.741111] Call Trace:
>  1923 May 21 08:56:32 ib2 kernel: [   44.741170]  [<ffffffff81046430>] ? vprintk_emit+0x280/0x520
>  1924 May 21 08:56:32 ib2 kernel: [   44.741233]  [<ffffffff810ac473>] __lock_acquire+0x6c3/0x17c0
>  1925 May 21 08:56:32 ib2 kernel: [   44.741295]  [<ffffffff810aca3c>] ? __lock_acquire+0xc8c/0x17c0
>  1926 May 21 08:56:32 ib2 kernel: [   44.741357]  [<ffffffff810047a7>] ? dump_trace+0x177/0x2f0
>  1927 May 21 08:56:32 ib2 kernel: [   44.741418]  [<ffffffff810ad612>] lock_acquire+0xa2/0x180
>  1928 May 21 08:56:32 ib2 kernel: [   44.741483]  [<ffffffffa073f36c>] ? __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1929 May 21 08:56:32 ib2 kernel: [   44.741563]  [<ffffffff8101090f>] ? save_stack_trace+0x2f/0x50
>  1930 May 21 08:56:32 ib2 kernel: [   44.741626]  [<ffffffff817bb0cb>] __mutex_lock_common+0x5b/0x3e0
>  1931 May 21 08:56:32 ib2 kernel: [   44.741693]  [<ffffffffa073f36c>] ? __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1932 May 21 08:56:32 ib2 kernel: [   44.741777]  [<ffffffffa073f36c>] ? __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1933 May 21 08:56:32 ib2 kernel: [   44.741855]  [<ffffffff817bb585>] mutex_lock_nested+0x45/0x50
>  1934 May 21 08:56:32 ib2 kernel: [   44.741922]  [<ffffffffa073f36c>] __ipoib_ib_dev_flush+0x3c/0x230 [ib_ipoib]
>  1935 May 21 08:56:32 ib2 kernel: [   44.741991]  [<ffffffffa073f38a>] __ipoib_ib_dev_flush+0x5a/0x230 [ib_ipoib]
>  1936 May 21 08:56:32 ib2 kernel: [   44.742060]  [<ffffffffa073f57a>] ipoib_ib_dev_flush_heavy+0x1a/0x20 [ib_ipoib]
> 1937 May 21 08:56:32 ib2 kernel: [   44.742138]  [<ffffffff810677c6>] process_one_work+0x1d6/0x560
>  1938 May 21 08:56:32 ib2 kernel: [   44.742199]  [<ffffffff81067755>] ? process_one_work+0x165/0x560
>  1939 May 21 08:56:32 ib2 kernel: [   44.742262]  [<ffffffff81068e29>] worker_thread+0x119/0x370
>  1940 May 21 08:56:32 ib2 kernel: [   44.742324]  [<ffffffff81068d10>] ? manage_workers+0x340/0x340
>  1941 May 21 08:56:32 ib2 kernel: [   44.742388]  [<ffffffff8106e846>] kthread+0xe6/0xf0
>  1942 May 21 08:56:32 ib2 kernel: [   44.742450]  [<ffffffff8106e760>] ? __init_kthread_worker+0x70/0x70
>  1943 May 21 08:56:32 ib2 kernel: [   44.742513]  [<ffffffff817c842c>] ret_from_fork+0x7c/0xb0
>  1944 May 21 08:56:32 ib2 kernel: [   44.742575]  [<ffffffff8106e760>] ? __init_kthread_worker+0x70/0x70
>  1945 May 21 08:56:32 ib2 kernel: [   44.744467] IPv6: ADDRCONF(NETDEV_CHANGE): ib1: link becomes ready
>  1946 May 21 08:56:45 ib2 kernel: [   57.700823] IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready

And I found attached patch you submitted long time ago, I tried that
patch, it fixed the warning, I wonder why the patch was not accepted,
anything wrong?

Regards,
Jack

--------------020205080208050400050906
Content-Type: text/x-patch;
 name="patch_fix_vlan_lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch_fix_vlan_lock.patch"

do nested flushing only if the device isn't a child

Signed-off-by: Or Gerlitz <ogerl...-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

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
 (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] 
__ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

but task is already holding lock:
 (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] 
__ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

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
 #1:  ((&priv->flush_heavy)){+.+...}, at: [<ffffffff81041e39>] 
process_one_work+0x210/0x4a6
 #2:  (&priv->vlan_mutex){+.+.+.}, at: [<ffffffffa021ae9f>] 
__ipoib_ib_dev_flush+0x2c/0x1cf [ib_ipoib]

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

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c 
b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5c1bc99..cac2b71 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -934,16 +934,18 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv 
*priv,
        struct net_device *dev = priv->dev;
        u16 new_index;

-       mutex_lock(&priv->vlan_mutex);
+       if (!priv->parent) {
+               mutex_lock(&priv->vlan_mutex);

-       /*
-        * Flush any child interfaces too -- they might be up even if
-        * the parent is down.
-        */
-       list_for_each_entry(cpriv, &priv->child_intfs, list)
-               __ipoib_ib_dev_flush(cpriv, level);
+               /*
+                * Flush any child interfaces too -- they might be up even if
+                * the parent is down.
+                */
+               list_for_each_entry(cpriv, &priv->child_intfs, list)
+                       __ipoib_ib_dev_flush(cpriv, level);

-       mutex_unlock(&priv->vlan_mutex);
+               mutex_unlock(&priv->vlan_mutex);
+       }

        if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
                ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not 
set.\n");

--------------020205080208050400050906--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
