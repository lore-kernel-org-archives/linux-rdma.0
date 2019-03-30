From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 15/67] i40iw: Avoid panic when handling the inetdev event
Date: Fri, 29 Mar 2019 20:49:55 -0400
Message-ID: <20190330005047.25998-15-sashal@kernel.org>
References: <20190330005047.25998-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190330005047.25998-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit ec4fe4bcc584b55e24e8d1768f5510a62c0fd619 ]

There is a panic reported that on a system with x722 ethernet, when doing
the operations like:

	# ip link add br0 type bridge
	# ip link set eno1 master br0
	# systemctl restart systemd-networkd

The system will panic "BUG: unable to handle kernel null pointer
dereference at 0000000000000034", with call chain:

	i40iw_inetaddr_event
	notifier_call_chain
	blocking_notifier_call_chain
	notifier_call_chain
	__inet_del_ifa
	inet_rtm_deladdr
	rtnetlink_rcv_msg
	netlink_rcv_skb
	rtnetlink_rcv
	netlink_unicast
	netlink_sendmsg
	sock_sendmsg
	__sys_sendto

It is caused by "local_ipaddr = ntohl(in->ifa_list->ifa_address)", while
the in->ifa_list is NULL.

So add a check for the "in->ifa_list == NULL" case, and skip the ARP
operation accordingly.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 59e978141ad4..e99177533930 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -173,7 +173,12 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 
 		rcu_read_lock();
 		in = __in_dev_get_rcu(upper_dev);
-		local_ipaddr = ntohl(in->ifa_list->ifa_address);
+
+		if (!in->ifa_list)
+			local_ipaddr = 0;
+		else
+			local_ipaddr = ntohl(in->ifa_list->ifa_address);
+
 		rcu_read_unlock();
 	} else {
 		local_ipaddr = ntohl(ifa->ifa_address);
@@ -185,6 +190,11 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 	case NETDEV_UP:
 		/* Fall through */
 	case NETDEV_CHANGEADDR:
+
+		/* Just skip if no need to handle ARP cache */
+		if (!local_ipaddr)
+			break;
+
 		i40iw_manage_arp_cache(iwdev,
 				       netdev->dev_addr,
 				       &local_ipaddr,
-- 
2.19.1
