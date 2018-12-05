From: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 1/8] net: core: dev: Add extack argument
 to dev_open()
Date: Wed, 5 Dec 2018 10:51:32 +0000
Message-ID: <58aee6a3c1ecba75a780cc303e5fd6e4d92059be.1544006963.git.petrm@mellanox.com>
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
invoked is dev_open().

Therefore extend dev_open() with and extra extack argument and update
all users. Most of the calls end up just encoding NULL, but bond and
team drivers have the extack readily available.

Signed-off-by: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Ido Schimmel <idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/bonding/bond_main.c                     | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c      | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c    | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c  | 2 +-
 drivers/net/ethernet/sfc/ethtool.c                  | 2 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c           | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 2 +-
 drivers/net/hyperv/netvsc_drv.c                     | 4 ++--
 drivers/net/net_failover.c                          | 8 ++++----
 drivers/net/team/team.c                             | 2 +-
 drivers/net/wireless/intersil/hostap/hostap_main.c  | 2 +-
 drivers/s390/net/qeth_l2_main.c                     | 2 +-
 drivers/s390/net/qeth_l3_main.c                     | 2 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c             | 2 +-
 drivers/staging/unisys/visornic/visornic_main.c     | 2 +-
 include/linux/netdevice.h                           | 2 +-
 net/bluetooth/6lowpan.c                             | 2 +-
 net/core/dev.c                                      | 5 +++--
 net/core/netpoll.c                                  | 2 +-
 net/ipv4/ipmr.c                                     | 4 ++--
 net/ipv6/addrconf.c                                 | 2 +-
 net/ipv6/ip6mr.c                                    | 2 +-
 23 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 333387f1f1fe..6b34dbefa7dd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1538,7 +1538,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	slave_dev->flags |= IFF_SLAVE;
 
 	/* open the slave since the application closed it */
-	res = dev_open(slave_dev);
+	res = dev_open(slave_dev, extack);
 	if (res) {
 		netdev_dbg(bond_dev, "Opening slave %s failed\n", slave_dev->name);
 		goto err_restore_mac;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a5fd71692c8b..43b42615ad84 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -525,7 +525,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		}
 	}
 	if (ndev_running)
-		err = dev_open(ndev);
+		err = dev_open(ndev, NULL);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index f42f7a6e1559..ebd5c2cf1efe 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -241,7 +241,7 @@ static int enic_set_ringparam(struct net_device *netdev,
 	}
 	enic_init_vnic_resources(enic);
 	if (running) {
-		err = dev_open(netdev);
+		err = dev_open(netdev, NULL);
 		if (err)
 			goto err_out;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 774beda040a1..8e9b95871d30 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -624,7 +624,7 @@ static void hns_nic_self_test(struct net_device *ndev,
 		clear_bit(NIC_STATE_TESTING, &priv->state);
 
 		if (if_running)
-			(void)dev_open(ndev);
+			(void)dev_open(ndev, NULL);
 	}
 	/* Online tests aren't run; pass by default */
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 4563638367ac..e678b6939da3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -821,7 +821,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	}
 
 	if (if_running)
-		ret = dev_open(ndev);
+		ret = dev_open(ndev, NULL);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 3143588ffd77..600d7b895cf2 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -539,7 +539,7 @@ static void efx_ethtool_self_test(struct net_device *net_dev,
 	/* We need rx buffers and interrupts. */
 	already_up = (efx->net_dev->flags & IFF_UP);
 	if (!already_up) {
-		rc = dev_open(efx->net_dev);
+		rc = dev_open(efx->net_dev, NULL);
 		if (rc) {
 			netif_err(efx, drv, efx->net_dev,
 				  "failed opening device.\n");
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index 1ccdb7a82e2a..72cedec945c1 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -517,7 +517,7 @@ static void ef4_ethtool_self_test(struct net_device *net_dev,
 	/* We need rx buffers and interrupts. */
 	already_up = (efx->net_dev->flags & IFF_UP);
 	if (!already_up) {
-		rc = dev_open(efx->net_dev);
+		rc = dev_open(efx->net_dev, NULL);
 		if (rc) {
 			netif_err(efx, drv, efx->net_dev,
 				  "failed opening device.\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c728ed1375b2..d20496f0ebd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4082,7 +4082,7 @@ static void stmmac_reset_subtask(struct stmmac_priv *priv)
 
 	set_bit(STMMAC_DOWN, &priv->state);
 	dev_close(priv->dev);
-	dev_open(priv->dev);
+	dev_open(priv->dev, NULL);
 	clear_bit(STMMAC_DOWN, &priv->state);
 	clear_bit(STMMAC_RESETING, &priv->state);
 	rtnl_unlock();
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 85936ed9e952..c65620adab52 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -137,7 +137,7 @@ static int netvsc_open(struct net_device *net)
 		 * slave as up. If open fails, then slave will be
 		 * still be offline (and not used).
 		 */
-		ret = dev_open(vf_netdev);
+		ret = dev_open(vf_netdev, NULL);
 		if (ret)
 			netdev_warn(net,
 				    "unable to open slave: %s: %d\n",
@@ -2002,7 +2002,7 @@ static void __netvsc_vf_setup(struct net_device *ndev,
 	netif_addr_unlock_bh(ndev);
 
 	if (netif_running(ndev)) {
-		ret = dev_open(vf_netdev);
+		ret = dev_open(vf_netdev, NULL);
 		if (ret)
 			netdev_warn(vf_netdev,
 				    "unable to open: %d\n", ret);
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index e964d312f4ca..ed1166adaa2f 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -40,14 +40,14 @@ static int net_failover_open(struct net_device *dev)
 
 	primary_dev = rtnl_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
-		err = dev_open(primary_dev);
+		err = dev_open(primary_dev, NULL);
 		if (err)
 			goto err_primary_open;
 	}
 
 	standby_dev = rtnl_dereference(nfo_info->standby_dev);
 	if (standby_dev) {
-		err = dev_open(standby_dev);
+		err = dev_open(standby_dev, NULL);
 		if (err)
 			goto err_standby_open;
 	}
@@ -517,7 +517,7 @@ static int net_failover_slave_register(struct net_device *slave_dev,
 	dev_hold(slave_dev);
 
 	if (netif_running(failover_dev)) {
-		err = dev_open(slave_dev);
+		err = dev_open(slave_dev, NULL);
 		if (err && (err != -EBUSY)) {
 			netdev_err(failover_dev, "Opening slave %s failed err:%d\n",
 				   slave_dev->name, err);
@@ -680,7 +680,7 @@ static int net_failover_slave_name_change(struct net_device *slave_dev,
 	/* We need to bring up the slave after the rename by udev in case
 	 * open failed with EBUSY when it was registered.
 	 */
-	dev_open(slave_dev);
+	dev_open(slave_dev, NULL);
 
 	return 0;
 }
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 364f514d56d8..93576e0240dd 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1212,7 +1212,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		goto err_port_enter;
 	}
 
-	err = dev_open(port_dev);
+	err = dev_open(port_dev, extack);
 	if (err) {
 		netdev_dbg(dev, "Device %s opening failed\n",
 			   portname);
diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/net/wireless/intersil/hostap/hostap_main.c
index 012930d35434..b0e7c0a0617e 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -690,7 +690,7 @@ static int prism2_open(struct net_device *dev)
 		/* Master radio interface is needed for all operation, so open
 		 * it automatically when any virtual net_device is opened. */
 		local->master_dev_auto_open = 1;
-		dev_open(local->dev);
+		dev_open(local->dev, NULL);
 	}
 
 	netif_device_attach(dev);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2836231c1c5d..f108d4b44605 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1007,7 +1007,7 @@ static int __qeth_l2_set_online(struct ccwgroup_device *gdev, int recovery_mode)
 			qeth_l2_set_rx_mode(card->dev);
 		} else {
 			rtnl_lock();
-			dev_open(card->dev);
+			dev_open(card->dev, NULL);
 			rtnl_unlock();
 		}
 	}
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index eca68da39d05..42a7cdc59b76 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2417,7 +2417,7 @@ static int __qeth_l3_set_online(struct ccwgroup_device *gdev, int recovery_mode)
 			__qeth_l3_open(card->dev);
 			qeth_l3_set_rx_mode(card->dev);
 		} else {
-			dev_open(card->dev);
+			dev_open(card->dev, NULL);
 		}
 		rtnl_unlock();
 	}
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 4fa37d6e598b..daabaceeea52 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1172,7 +1172,7 @@ static int ethsw_open(struct ethsw_core *ethsw)
 
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		port_priv = ethsw->ports[i];
-		err = dev_open(port_priv->netdev);
+		err = dev_open(port_priv->netdev, NULL);
 		if (err) {
 			netdev_err(port_priv->netdev, "dev_open err %d\n", err);
 			return err;
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index 3647b8f1ed28..5eeb4b93b45b 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -2095,7 +2095,7 @@ static int visornic_resume(struct visor_device *dev,
 	mod_timer(&devdata->irq_poll_timer, msecs_to_jiffies(2));
 
 	rtnl_lock();
-	dev_open(netdev);
+	dev_open(netdev, NULL);
 	rtnl_unlock();
 
 	complete_func(dev, 0);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 94fb2e12f117..d79be3055f5f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2605,7 +2605,7 @@ struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
 int dev_alloc_name(struct net_device *dev, const char *name);
-int dev_open(struct net_device *dev);
+int dev_open(struct net_device *dev, struct netlink_ext_ack *extack);
 void dev_close(struct net_device *dev);
 void dev_close_many(struct list_head *head, bool unlink);
 void dev_disable_lro(struct net_device *dev);
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 828e87fe8027..9d79c7de234a 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -607,7 +607,7 @@ static void ifup(struct net_device *netdev)
 	int err;
 
 	rtnl_lock();
-	err = dev_open(netdev);
+	err = dev_open(netdev, NULL);
 	if (err < 0)
 		BT_INFO("iface %s cannot be opened (%d)", netdev->name, err);
 	rtnl_unlock();
diff --git a/net/core/dev.c b/net/core/dev.c
index 04a6b7100aac..b801c1aafd70 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1406,7 +1406,8 @@ static int __dev_open(struct net_device *dev)
 
 /**
  *	dev_open	- prepare an interface for use.
- *	@dev:	device to open
+ *	@dev: device to open
+ *	@extack: netlink extended ack
  *
  *	Takes a device from down to up state. The device's private open
  *	function is invoked and then the multicast lists are loaded. Finally
@@ -1416,7 +1417,7 @@ static int __dev_open(struct net_device *dev)
  *	Calling this function on an active interface is a nop. On a failure
  *	a negative errno code is returned.
  */
-int dev_open(struct net_device *dev)
+int dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	int ret;
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2b9fdbc43205..36a2b63ffd6d 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -663,7 +663,7 @@ int netpoll_setup(struct netpoll *np)
 
 		np_info(np, "device %s not up yet, forcing it\n", np->dev_name);
 
-		err = dev_open(ndev);
+		err = dev_open(ndev, NULL);
 
 		if (err) {
 			np_err(np, "failed to open %s\n", ndev->name);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 5cbc749a50aa..ea04e38f56e9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -506,7 +506,7 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 			dev->flags |= IFF_MULTICAST;
 			if (!ipmr_init_vif_indev(dev))
 				goto failure;
-			if (dev_open(dev))
+			if (dev_open(dev, NULL))
 				goto failure;
 			dev_hold(dev);
 		}
@@ -589,7 +589,7 @@ static struct net_device *ipmr_reg_vif(struct net *net, struct mr_table *mrt)
 
 	if (!ipmr_init_vif_indev(dev))
 		goto failure;
-	if (dev_open(dev))
+	if (dev_open(dev, NULL))
 		goto failure;
 
 	dev_hold(dev);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 045597b9a7c0..521e471f1cf9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2820,7 +2820,7 @@ int addrconf_set_dstaddr(struct net *net, void __user *arg)
 			dev = __dev_get_by_name(net, p.name);
 			if (!dev)
 				goto err_exit;
-			err = dev_open(dev);
+			err = dev_open(dev, NULL);
 		}
 	}
 #endif
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index e2ea691e42c6..8c63494400c4 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -655,7 +655,7 @@ static struct net_device *ip6mr_reg_vif(struct net *net, struct mr_table *mrt)
 		return NULL;
 	}
 
-	if (dev_open(dev))
+	if (dev_open(dev, NULL))
 		goto failure;
 
 	dev_hold(dev);
-- 
2.4.11
