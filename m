From: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 2/8] net: vrf: cycle_netdev(): Add an
	extack argument
Date: Wed, 5 Dec 2018 10:51:37 +0000
Message-ID: <eb87a73c9e3f48abd7ca7b6ad76924af70cecef1.1544006963.git.petrm@mellanox.com>
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

A follow-up patch will extend dev_change_flags() with an extack
argument. Extend cycle_netdev() to have that argument available for the
conversion.

Signed-off-by: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Ido Schimmel <idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/vrf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 21ad4b1d7f03..1e9f2dc0de07 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -747,7 +747,8 @@ static int vrf_rtable_create(struct net_device *dev)
 /**************************** device handling ********************/
 
 /* cycle interface to flush neighbor cache and move routes across tables */
-static void cycle_netdev(struct net_device *dev)
+static void cycle_netdev(struct net_device *dev,
+			 struct netlink_ext_ack *extack)
 {
 	unsigned int flags = dev->flags;
 	int ret;
@@ -785,7 +786,7 @@ static int do_vrf_add_slave(struct net_device *dev, struct net_device *port_dev,
 	if (ret < 0)
 		goto err;
 
-	cycle_netdev(port_dev);
+	cycle_netdev(port_dev, extack);
 
 	return 0;
 
@@ -815,7 +816,7 @@ static int do_vrf_del_slave(struct net_device *dev, struct net_device *port_dev)
 	netdev_upper_dev_unlink(port_dev, dev);
 	port_dev->priv_flags &= ~IFF_L3MDEV_SLAVE;
 
-	cycle_netdev(port_dev);
+	cycle_netdev(port_dev, NULL);
 
 	return 0;
 }
-- 
2.4.11
