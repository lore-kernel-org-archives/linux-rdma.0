From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
Date: Mon, 17 Jun 2019 10:53:41 +0200
Message-ID: <20190617085341.51592-4-dkirjanov@suse.com>
References: <20190617085341.51592-1-dkirjanov@suse.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190617085341.51592-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, dledford@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
List-Id: linux-rdma@vger.kernel.org

in IPoIB case we can't see a VF broadcast address for but
can see for PF

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
trust off, query_rss off
...

After:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

v1->v2: add the IFLA_VF_BROADCAST constant
v2->v3: put IFLA_VF_BROADCAST at the end
to avoid KABI breakage and set NLA_REJECT
dev_setlink

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_link.h | 5 +++++
 net/core/rtnetlink.c         | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5b225ff63b48..6f75bda2c2d7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -694,6 +694,7 @@ enum {
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,	/* VF broadcast */
 	__IFLA_VF_MAX,
 };
 
@@ -704,6 +705,10 @@ struct ifla_vf_mac {
 	__u8 mac[32]; /* MAX_ADDR_LEN */
 };
 
+struct ifla_vf_broadcast {
+	__u8 broadcast[32];
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cec60583931f..8ac81630ab5c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -908,6 +908,7 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 		size += num_vfs *
 			(nla_total_size(0) +
 			 nla_total_size(sizeof(struct ifla_vf_mac)) +
+			 nla_total_size(sizeof(struct ifla_vf_broadcast)) +
 			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
 			 nla_total_size(0) + /* nest IFLA_VF_VLAN_LIST */
 			 nla_total_size(MAX_VLAN_LIST_LEN *
@@ -1197,6 +1198,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	struct ifla_vf_vlan vf_vlan;
 	struct ifla_vf_rate vf_rate;
 	struct ifla_vf_mac vf_mac;
+	struct ifla_vf_broadcast vf_broadcast;
 	struct ifla_vf_info ivi;
 
 	memset(&ivi, 0, sizeof(ivi));
@@ -1231,6 +1233,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_trust.vf = ivi.vf;
 
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
+	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;
 	vf_vlan_info.vlan = ivi.vlan;
@@ -1247,6 +1250,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast), &vf_broadcast) ||
 	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
 		    &vf_rate) ||
@@ -1753,6 +1757,7 @@ static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
 
 static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
 	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
+	[IFLA_VF_BROADCAST]	= { .type = NLA_REJECT },
 	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
 	[IFLA_VF_VLAN_LIST]     = { .type = NLA_NESTED },
 	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },
-- 
2.12.3
