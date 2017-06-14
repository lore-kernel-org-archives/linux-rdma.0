From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 5/5] IB/ipoib: Fix memory leak in create child syscall
Date: Wed, 14 Jun 2017 09:59:09 +0300
Message-ID: <20170614065909.23650-6-leon@kernel.org>
References: <20170614065909.23650-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The flow of creating a new child goes through ipoib_vlan_add
which allocates a new interface and checks the rtnl_lock.

If the lock is taken, restart_syscall will be called to restart
the system call again. In this case we are not releasing the
already allocated interface, causing a leak.

Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 1ee46194bbf5..081b33deff1b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -133,13 +133,13 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
 	if (!priv)
 		return -ENOMEM;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
 	down_write(&ppriv->vlan_rwsem);
 
 	/*
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
