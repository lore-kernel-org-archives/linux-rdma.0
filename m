From: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 4/8] net: core: dev: Add extack argument
 to dev_change_flags()
Date: Wed, 5 Dec 2018 10:51:46 +0000
Message-ID: <a85ca38ac0470f61758d979bcd1b9e3b9e086d1c.1544006963.git.petrm@mellanox.com>
References: <cover.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <cover.1544006963.git.petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org" <linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, "linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org" <dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "_govind-KK0ffGbhmjU@public.gmane.org" <_govind-KK0ffGbhmjU@public.gmane.org>, "dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org" <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>, "ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org" <ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>, kys <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org" <andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org>, "johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ioana.ciornei-3arQi8VN3Tc@public.gmane.org" <ioana.ciornei-3arQi8VN3Tc@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org" <ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org>, "jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, marcel@holtma
List-Id: linux-rdma@vger.kernel.org

In order to pass extack together with NETDEV_PRE_UP notifications, it's
necessary to route the extack to __dev_open() from diverse (possibly
indirect) callers. One prominent API through which the notification is
invoked is dev_change_flags().

Therefore extend dev_change_flags() with and extra extack argument and
update all users. Most of the calls end up just encoding NULL, but
several sites (VLAN, ipvlan, VRF, rtnetlink) do have extack available.

Since the function declaration line is changed anyway, name the other
function arguments to placate checkpatch.

Signed-off-by: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Ido Schimmel <idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  6 +++---
 drivers/net/hyperv/netvsc_drv.c           |  2 +-
 drivers/net/ipvlan/ipvlan_main.c          | 12 ++++++++----
 drivers/net/vrf.c                         |  4 ++--
 include/linux/netdevice.h                 |  3 ++-
 net/8021q/vlan.c                          |  4 +++-
 net/core/dev.c                            |  4 +++-
 net/core/dev_ioctl.c                      |  2 +-
 net/core/net-sysfs.c                      |  2 +-
 net/core/rtnetlink.c                      |  3 ++-
 net/ipv4/devinet.c                        |  2 +-
 net/ipv4/ipconfig.c                       |  6 +++---
 net/openvswitch/vport-geneve.c            |  2 +-
 net/openvswitch/vport-gre.c               |  2 +-
 net/openvswitch/vport-vxlan.c             |  2 +-
 15 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8710214594d8..6214d8c0d546 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -167,7 +167,7 @@ int ipoib_open(struct net_device *dev)
 			if (flags & IFF_UP)
 				continue;
 
-			dev_change_flags(cpriv->dev, flags | IFF_UP);
+			dev_change_flags(cpriv->dev, flags | IFF_UP, NULL);
 		}
 		up_read(&priv->vlan_rwsem);
 	}
@@ -207,7 +207,7 @@ static int ipoib_stop(struct net_device *dev)
 			if (!(flags & IFF_UP))
 				continue;
 
-			dev_change_flags(cpriv->dev, flags & ~IFF_UP);
+			dev_change_flags(cpriv->dev, flags & ~IFF_UP, NULL);
 		}
 		up_read(&priv->vlan_rwsem);
 	}
@@ -1823,7 +1823,7 @@ static void ipoib_parent_unregister_pre(struct net_device *ndev)
 	 * running ensures the it will not add more work.
 	 */
 	rtnl_lock();
-	dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
+	dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP, NULL);
 	rtnl_unlock();
 
 	/* ipoib_event() cannot be running once this returns */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index c65620adab52..18b5584d6377 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1993,7 +1993,7 @@ static void __netvsc_vf_setup(struct net_device *ndev,
 			    "unable to change mtu to %u\n", ndev->mtu);
 
 	/* set multicast etc flags on VF */
-	dev_change_flags(vf_netdev, ndev->flags | IFF_SLAVE);
+	dev_change_flags(vf_netdev, ndev->flags | IFF_SLAVE, NULL);
 
 	/* sync address list from ndev to VF */
 	netif_addr_lock_bh(ndev);
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 14f1cbd3b96f..c3d3e458f541 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -85,10 +85,12 @@ static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 			flags = ipvlan->dev->flags;
 			if (nval == IPVLAN_MODE_L3 || nval == IPVLAN_MODE_L3S) {
 				err = dev_change_flags(ipvlan->dev,
-						       flags | IFF_NOARP);
+						       flags | IFF_NOARP,
+						       extack);
 			} else {
 				err = dev_change_flags(ipvlan->dev,
-						       flags & ~IFF_NOARP);
+						       flags & ~IFF_NOARP,
+						       extack);
 			}
 			if (unlikely(err))
 				goto fail;
@@ -117,9 +119,11 @@ static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
 		flags = ipvlan->dev->flags;
 		if (port->mode == IPVLAN_MODE_L3 ||
 		    port->mode == IPVLAN_MODE_L3S)
-			dev_change_flags(ipvlan->dev, flags | IFF_NOARP);
+			dev_change_flags(ipvlan->dev, flags | IFF_NOARP,
+					 NULL);
 		else
-			dev_change_flags(ipvlan->dev, flags & ~IFF_NOARP);
+			dev_change_flags(ipvlan->dev, flags & ~IFF_NOARP,
+					 NULL);
 	}
 
 	return err;
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 1e9f2dc0de07..95909e262ba4 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -756,9 +756,9 @@ static void cycle_netdev(struct net_device *dev,
 	if (!netif_running(dev))
 		return;
 
-	ret = dev_change_flags(dev, flags & ~IFF_UP);
+	ret = dev_change_flags(dev, flags & ~IFF_UP, extack);
 	if (ret >= 0)
-		ret = dev_change_flags(dev, flags);
+		ret = dev_change_flags(dev, flags, extack);
 
 	if (ret < 0) {
 		netdev_err(dev,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79be3055f5f..18cf464450ee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3612,7 +3612,8 @@ int dev_ifconf(struct net *net, struct ifconf *, int);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *, unsigned int flags);
-int dev_change_flags(struct net_device *, unsigned int);
+int dev_change_flags(struct net_device *dev, unsigned int flags,
+		     struct netlink_ext_ack *extack);
 void __dev_notify_flags(struct net_device *, unsigned int old_flags,
 			unsigned int gchanges);
 int dev_change_name(struct net_device *, const char *);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index aef1a977279c..dc4411165e43 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -358,6 +358,7 @@ static int __vlan_device_event(struct net_device *dev, unsigned long event)
 static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 			     void *ptr)
 {
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct vlan_group *grp;
 	struct vlan_info *vlan_info;
@@ -460,7 +461,8 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 
 			vlan = vlan_dev_priv(vlandev);
 			if (!(vlan->flags & VLAN_FLAG_LOOSE_BINDING))
-				dev_change_flags(vlandev, flgs | IFF_UP);
+				dev_change_flags(vlandev, flgs | IFF_UP,
+						 extack);
 			netif_stacked_transfer_operstate(dev, vlandev);
 		}
 		break;
diff --git a/net/core/dev.c b/net/core/dev.c
index b801c1aafd70..8bba6f98b545 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7595,11 +7595,13 @@ void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
  *	dev_change_flags - change device settings
  *	@dev: device
  *	@flags: device state flags
+ *	@extack: netlink extended ack
  *
  *	Change settings on device based state flags. The flags are
  *	in the userspace exported format.
  */
-int dev_change_flags(struct net_device *dev, unsigned int flags)
+int dev_change_flags(struct net_device *dev, unsigned int flags,
+		     struct netlink_ext_ack *extack)
 {
 	int ret;
 	unsigned int changes, old_flags = dev->flags, old_gflags = dev->gflags;
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 90e8aa36881e..da273ec3cc57 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -234,7 +234,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 
 	switch (cmd) {
 	case SIOCSIFFLAGS:	/* Set interface flags */
-		return dev_change_flags(dev, ifr->ifr_flags);
+		return dev_change_flags(dev, ifr->ifr_flags, NULL);
 
 	case SIOCSIFMETRIC:	/* Set the metric on the interface
 				   (currently unused) */
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index bd67c4d0fcfd..ff9fd2bb4ce4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -337,7 +337,7 @@ NETDEVICE_SHOW_RW(mtu, fmt_dec);
 
 static int change_flags(struct net_device *dev, unsigned long new_flags)
 {
-	return dev_change_flags(dev, (unsigned int)new_flags);
+	return dev_change_flags(dev, (unsigned int)new_flags, NULL);
 }
 
 static ssize_t flags_store(struct device *dev, struct device_attribute *attr,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 98876cd1e36c..4c9e4e187600 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2489,7 +2489,8 @@ static int do_setlink(const struct sk_buff *skb,
 	}
 
 	if (ifm->ifi_flags || ifm->ifi_change) {
-		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm));
+		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
+				       extack);
 		if (err < 0)
 			goto errout;
 	}
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a34602ae27de..5b9b6d497f71 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1100,7 +1100,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 				inet_del_ifa(in_dev, ifap, 1);
 			break;
 		}
-		ret = dev_change_flags(dev, ifr->ifr_flags);
+		ret = dev_change_flags(dev, ifr->ifr_flags, NULL);
 		break;
 
 	case SIOCSIFADDR:	/* Set interface address (and family) */
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 88212615bf4c..55757764c381 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -220,7 +220,7 @@ static int __init ic_open_devs(void)
 	for_each_netdev(&init_net, dev) {
 		if (!(dev->flags & IFF_LOOPBACK) && !netdev_uses_dsa(dev))
 			continue;
-		if (dev_change_flags(dev, dev->flags | IFF_UP) < 0)
+		if (dev_change_flags(dev, dev->flags | IFF_UP, NULL) < 0)
 			pr_err("IP-Config: Failed to open %s\n", dev->name);
 	}
 
@@ -238,7 +238,7 @@ static int __init ic_open_devs(void)
 			if (ic_proto_enabled && !able)
 				continue;
 			oflags = dev->flags;
-			if (dev_change_flags(dev, oflags | IFF_UP) < 0) {
+			if (dev_change_flags(dev, oflags | IFF_UP, NULL) < 0) {
 				pr_err("IP-Config: Failed to open %s\n",
 				       dev->name);
 				continue;
@@ -315,7 +315,7 @@ static void __init ic_close_devs(void)
 		dev = d->dev;
 		if (d != ic_dev && !netdev_uses_dsa(dev)) {
 			pr_debug("IP-Config: Downing %s\n", dev->name);
-			dev_change_flags(dev, d->flags);
+			dev_change_flags(dev, d->flags, NULL);
 		}
 		kfree(d);
 	}
diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 5aaf3babfc3f..acb6077b7478 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -93,7 +93,7 @@ static struct vport *geneve_tnl_create(const struct vport_parms *parms)
 		return ERR_CAST(dev);
 	}
 
-	err = dev_change_flags(dev, dev->flags | IFF_UP);
+	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
 		rtnl_delete_link(dev);
 		rtnl_unlock();
diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index 0e72d95b0e8f..c38a62464b85 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -68,7 +68,7 @@ static struct vport *gre_tnl_create(const struct vport_parms *parms)
 		return ERR_CAST(dev);
 	}
 
-	err = dev_change_flags(dev, dev->flags | IFF_UP);
+	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
 		rtnl_delete_link(dev);
 		rtnl_unlock();
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 7e6301b2ec4d..8f16f11f7ad3 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -131,7 +131,7 @@ static struct vport *vxlan_tnl_create(const struct vport_parms *parms)
 		return ERR_CAST(dev);
 	}
 
-	err = dev_change_flags(dev, dev->flags | IFF_UP);
+	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
 		rtnl_delete_link(dev);
 		rtnl_unlock();
-- 
2.4.11
