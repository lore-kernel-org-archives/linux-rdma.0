From: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 0/8] Pass extack to NETDEV_PRE_UP
Date: Wed, 5 Dec 2018 10:51:27 +0000
Message-ID: <cover.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
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

Drivers may need to validate configuration of a device that's about to
be upped. An example is mlxsw, which needs to check the configuration of
a VXLAN device attached to an offloaded bridge. Should the validation
fail, there's currently no way to communicate details of the failure to
the user, beyond an error number.

Therefore this patch set extends the NETDEV_PRE_UP event to include
extack, if available.

There are three vectors through which NETDEV_PRE_UP invocation can be
reached. The two major ones are dev_open() and dev_change_flags(), the
last is then __dev_change_flags().

In patch #1, the first access vector, dev_open() is addressed. An extack
parameter is added and all users converted to use it.

Before addressing the second vector, two preparatory patches propagate
extack argument to the proximity of the dev_change_flags() call in VRF
and IPVLAN drivers. That happens in patches #2 and #3. Then in patch #4,
dev_change_flags() is treated similarly to dev_open().

Likewise in patch #5, __dev_change_flags() is extended.

Then in patches #6 and #7, the extack is finally propagated all the way
to the point where the notification is emitted.

This change allows particularly mlxsw (which already has code to
leverage extack if available) to communicate to the user error messages
regarding VXLAN configuration. In patch #8, add a test case that
exercises this code and checks that an error message is propagated.

For example:

# ip link add name br1 up type bridge vlan_filtering 0 mcast_snooping 0
# ip link add name vx1 up type vxlan id 1000 \
	local 192.0.2.17 remote 192.0.2.18 \
	dstport 4789 nolearning noudpcsum tos inherit ttl 100
# ip link set dev vx1 master br1
# ip link set dev sw1p1 master br1
# ip link add name br2 up type bridge vlan_filtering 0 mcast_snooping 0
# ip link add name vx2 up type vxlan id 2000 \
	local 192.0.2.17 remote 192.0.2.18 \
	dstport 4789 nolearning noudpcsum tos inherit ttl 100
# ip link set dev vx2 master br2
# ip link set dev sw1p2 master br2
# ip link set dev vx2 down
# ip link set dev vx2 type vxlan ttl 200
# ip link set dev vx2 up
Error: mlxsw_spectrum: Conflicting NVE tunnels configuration.

Petr Machata (8):
  net: core: dev: Add extack argument to dev_open()
  net: vrf: cycle_netdev(): Add an extack argument
  net: ipvlan: ipvlan_set_port_mode(): Add an extack argument
  net: core: dev: Add extack argument to dev_change_flags()
  net: core: dev: Add extack argument to __dev_change_flags()
  net: core: dev: Add call_netdevice_notifiers_extack()
  net: core: dev: Attach extack to NETDEV_PRE_UP
  selftests: mlxsw: Add a new test extack.sh

 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  6 +-
 drivers/net/bonding/bond_main.c                    |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 drivers/net/ethernet/sfc/ethtool.c                 |  2 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  6 +-
 drivers/net/ipvlan/ipvlan_main.c                   | 19 +++--
 drivers/net/net_failover.c                         |  8 +--
 drivers/net/team/team.c                            |  2 +-
 drivers/net/vrf.c                                  | 11 +--
 drivers/net/wireless/intersil/hostap/hostap_main.c |  2 +-
 drivers/s390/net/qeth_l2_main.c                    |  2 +-
 drivers/s390/net/qeth_l3_main.c                    |  2 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c            |  2 +-
 drivers/staging/unisys/visornic/visornic_main.c    |  2 +-
 include/linux/netdevice.h                          |  8 ++-
 net/8021q/vlan.c                                   |  4 +-
 net/bluetooth/6lowpan.c                            |  2 +-
 net/core/dev.c                                     | 43 +++++++----
 net/core/dev_ioctl.c                               |  2 +-
 net/core/net-sysfs.c                               |  2 +-
 net/core/netpoll.c                                 |  2 +-
 net/core/rtnetlink.c                               |  6 +-
 net/ipv4/devinet.c                                 |  2 +-
 net/ipv4/ipconfig.c                                |  6 +-
 net/ipv4/ipmr.c                                    |  4 +-
 net/ipv6/addrconf.c                                |  2 +-
 net/ipv6/ip6mr.c                                   |  2 +-
 net/openvswitch/vport-geneve.c                     |  2 +-
 net/openvswitch/vport-gre.c                        |  2 +-
 net/openvswitch/vport-vxlan.c                      |  2 +-
 .../testing/selftests/drivers/net/mlxsw/extack.sh  | 84 ++++++++++++++++++++++
 36 files changed, 182 insertions(+), 71 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/extack.sh

-- 
2.4.11
