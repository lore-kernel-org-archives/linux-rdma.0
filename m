From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/9] IB/ipoib: Fix deadlock between rmmod and set_mode
Date: Tue, 27 Dec 2016 15:39:06 +0200
Message-ID: <20161227133911.14340-5-leon@kernel.org>
References: <20161227133911.14340-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161227133911.14340-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When calling set_mode from sys/fs, the call flow locks the sys/fs lock
first and then tries to lock rtnl_lock (when calling ipoib_set_mod).
On the other hand, the rmmod call flow takes the rtnl_lock first
(when calling unregister_netdev) and then tries to take the sys/fs
lock. Deadlock a->b, b->a.

The problem starts when ipoib_set_mod frees it's rtnl_lck and tries
to get it after that.

    set_mod:
    [<ffffffff8104f2bd>] ? check_preempt_curr+0x6d/0x90
    [<ffffffff814fee8e>] __mutex_lock_slowpath+0x13e/0x180
    [<ffffffff81448655>] ? __rtnl_unlock+0x15/0x20
    [<ffffffff814fed2b>] mutex_lock+0x2b/0x50
    [<ffffffff81448675>] rtnl_lock+0x15/0x20
    [<ffffffffa02ad807>] ipoib_set_mode+0x97/0x160 [ib_ipoib]
    [<ffffffffa02b5f5b>] set_mode+0x3b/0x80 [ib_ipoib]
    [<ffffffff8134b840>] dev_attr_store+0x20/0x30
    [<ffffffff811f0fe5>] sysfs_write_file+0xe5/0x170
    [<ffffffff8117b068>] vfs_write+0xb8/0x1a0
    [<ffffffff8117ba81>] sys_write+0x51/0x90
    [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

    rmmod:
    [<ffffffff81279ffc>] ? put_dec+0x10c/0x110
    [<ffffffff8127a2ee>] ? number+0x2ee/0x320
    [<ffffffff814fe6a5>] schedule_timeout+0x215/0x2e0
    [<ffffffff8127cc04>] ? vsnprintf+0x484/0x5f0
    [<ffffffff8127b550>] ? string+0x40/0x100
    [<ffffffff814fe323>] wait_for_common+0x123/0x180
    [<ffffffff81060250>] ? default_wake_function+0x0/0x20
    [<ffffffff8119661e>] ? ifind_fast+0x5e/0xb0
    [<ffffffff814fe43d>] wait_for_completion+0x1d/0x20
    [<ffffffff811f2e68>] sysfs_addrm_finish+0x228/0x270
    [<ffffffff811f2fb3>] sysfs_remove_dir+0xa3/0xf0
    [<ffffffff81273f66>] kobject_del+0x16/0x40
    [<ffffffff8134cd14>] device_del+0x184/0x1e0
    [<ffffffff8144e59b>] netdev_unregister_kobject+0xab/0xc0
    [<ffffffff8143c05e>] rollback_registered+0xae/0x130
    [<ffffffff8143c102>] unregister_netdevice+0x22/0x70
    [<ffffffff8143c16e>] unregister_netdev+0x1e/0x30
    [<ffffffffa02a91b0>] ipoib_remove_one+0xe0/0x120 [ib_ipoib]
    [<ffffffffa01ed95f>] ib_unregister_device+0x4f/0x100 [ib_core]
    [<ffffffffa021f5e1>] mlx4_ib_remove+0x41/0x180 [mlx4_ib]
    [<ffffffffa01ab771>] mlx4_remove_device+0x71/0x90 [mlx4_core]

Fixes: 862096a8bbf8 ("IB/ipoib: Add more rtnl_link_ops callbacks")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.6+
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 12 +++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  6 ++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 096c4f6..1c7a9a1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1507,12 +1507,14 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,

 	ret = ipoib_set_mode(dev, buf);

-	rtnl_unlock();
-
-	if (!ret)
-		return count;
+	/* The assumption is that the function ipoib_set_mode returned
+	 * with the rtnl held by it, if not the value -EBUSY returned,
+	 * then no need to rtnl_unlock
+	 */
+	if (ret != -EBUSY)
+		rtnl_unlock();

-	return ret;
+	return (!ret || ret == -EBUSY) ? count : ret;
 }

 static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, show_mode, set_mode);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1787f6b..1090fe2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -493,8 +493,7 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 		priv->tx_wr.wr.send_flags &= ~IB_SEND_IP_CSUM;

 		ipoib_flush_paths(dev);
-		rtnl_lock();
-		return 0;
+		return (!rtnl_trylock()) ? -EBUSY : 0;
 	}

 	if (!strcmp(buf, "datagram\n")) {
@@ -503,8 +502,7 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 		dev_set_mtu(dev, min(priv->mcast_mtu, dev->mtu));
 		rtnl_unlock();
 		ipoib_flush_paths(dev);
-		rtnl_lock();
-		return 0;
+		return (!rtnl_trylock()) ? -EBUSY : 0;
 	}

 	return -EINVAL;
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
