From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] IB/ipoib: Prevent lockdep warning in __ipoib_ib_dev_flush
Date: Tue,  7 Jul 2015 17:45:13 +0300
Message-ID: <1436280313-21451-3-git-send-email-haggaie@mellanox.com>
References: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436280313-21451-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

__ipoib_ib_dev_flush calls itself recursively on child devices, and lockdep
complains about locking vlan_rwsem twice (see below). Use down_read_nested
instead of down_read to prevent the warning.

 =============================================
 [ INFO: possible recursive locking detected ]
 4.1.0-rc4+ #36 Tainted: G           O
 ---------------------------------------------
 kworker/u20:2/261 is trying to acquire lock:
  (&priv->vlan_rwsem){.+.+..}, at: [<ffffffffa0791e2a>] __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]

 but task is already holding lock:
  (&priv->vlan_rwsem){.+.+..}, at: [<ffffffffa0791e2a>] __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&priv->vlan_rwsem);
   lock(&priv->vlan_rwsem);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 3 locks held by kworker/u20:2/261:
  #0:  ("%s""ipoib_flush"){.+.+..}, at: [<ffffffff810827cc>] process_one_work+0x15c/0x760
  #1:  ((&priv->flush_heavy)){+.+...}, at: [<ffffffff810827cc>] process_one_work+0x15c/0x760
  #2:  (&priv->vlan_rwsem){.+.+..}, at: [<ffffffffa0791e2a>] __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]

 stack backtrace:
 CPU: 3 PID: 261 Comm: kworker/u20:2 Tainted: G           O    4.1.0-rc4+ #36
 Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
 Workqueue: ipoib_flush ipoib_ib_dev_flush_heavy [ib_ipoib]
  ffff8801c6c54790 ffff8801c9927af8 ffffffff81665238 0000000000000001
  ffffffff825b5b30 ffff8801c9927bd8 ffffffff810bba51 ffff880100000000
  ffffffff00000001 ffff880100000001 ffff8801c6c55428 ffff8801c6c54790
 Call Trace:
  [<ffffffff81665238>] dump_stack+0x4f/0x6f
  [<ffffffff810bba51>] __lock_acquire+0x741/0x1820
  [<ffffffff810bcbf8>] lock_acquire+0xc8/0x240
  [<ffffffffa0791e2a>] ? __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]
  [<ffffffff81669d2c>] down_read+0x4c/0x70
  [<ffffffffa0791e2a>] ? __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]
  [<ffffffffa0791e2a>] __ipoib_ib_dev_flush+0x3a/0x2b0 [ib_ipoib]
  [<ffffffffa0791e4a>] __ipoib_ib_dev_flush+0x5a/0x2b0 [ib_ipoib]
  [<ffffffffa07920ba>] ipoib_ib_dev_flush_heavy+0x1a/0x20 [ib_ipoib]
  [<ffffffff81082871>] process_one_work+0x201/0x760
  [<ffffffff810827cc>] ? process_one_work+0x15c/0x760
  [<ffffffff81082ef0>] worker_thread+0x120/0x4d0
  [<ffffffff81082dd0>] ? process_one_work+0x760/0x760
  [<ffffffff81082dd0>] ? process_one_work+0x760/0x760
  [<ffffffff81088b7e>] kthread+0xfe/0x120
  [<ffffffff81088a80>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8166c6e2>] ret_from_fork+0x42/0x70
  [<ffffffff81088a80>] ? __init_kthread_worker+0x70/0x70

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 63b92cbb29ad..058150ff5aa1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -985,20 +985,21 @@ static inline int update_child_pkey(struct ipoib_dev_priv *priv)
 }
 
 static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
-				enum ipoib_flush_level level)
+				enum ipoib_flush_level level,
+				int nesting)
 {
 	struct ipoib_dev_priv *cpriv;
 	struct net_device *dev = priv->dev;
 	int result;
 
-	down_read(&priv->vlan_rwsem);
+	down_read_nested(&priv->vlan_rwsem, nesting);
 
 	/*
 	 * Flush any child interfaces too -- they might be up even if
 	 * the parent is down.
 	 */
 	list_for_each_entry(cpriv, &priv->child_intfs, list)
-		__ipoib_ib_dev_flush(cpriv, level);
+		__ipoib_ib_dev_flush(cpriv, level, nesting + 1);
 
 	up_read(&priv->vlan_rwsem);
 
@@ -1076,7 +1077,7 @@ void ipoib_ib_dev_flush_light(struct work_struct *work)
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, flush_light);
 
-	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_LIGHT);
+	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_LIGHT, 0);
 }
 
 void ipoib_ib_dev_flush_normal(struct work_struct *work)
@@ -1084,7 +1085,7 @@ void ipoib_ib_dev_flush_normal(struct work_struct *work)
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, flush_normal);
 
-	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_NORMAL);
+	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_NORMAL, 0);
 }
 
 void ipoib_ib_dev_flush_heavy(struct work_struct *work)
@@ -1092,7 +1093,7 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work)
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, flush_heavy);
 
-	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_HEAVY);
+	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_HEAVY, 0);
 }
 
 void ipoib_ib_dev_cleanup(struct net_device *dev)
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
