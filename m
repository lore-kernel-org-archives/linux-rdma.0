From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next 1/2] ipoib: correcly show a VF hardware address
Date: Wed, 12 Jun 2019 13:33:47 +0200
Message-ID: <20190612113348.59858-3-dkirjanov@suse.com>
References: <20190612113348.59858-1-dkirjanov@suse.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612113348.59858-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, dledford@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>
List-Id: linux-rdma@vger.kernel.org

in the case of IPoIB with SRIOV enabled hardware
ip link show command incorrecly prints
0 instead of a VF hardware address. To correcly print the address
add a new field to specify an address length.

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
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
...

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 include/uapi/linux/if_link.h              | 1 +
 net/core/rtnetlink.c                      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9b5e11d3fb85..04ea7db08e87 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1998,6 +1998,7 @@ static int ipoib_get_vf_config(struct net_device *dev, int vf,
 		return err;
 
 	ivf->vf = vf;
+	memcpy(ivf->mac, dev->dev_addr, dev->addr_len);
 
 	return 0;
 }
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5b225ff63b48..904ee1a7330b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -702,6 +702,7 @@ enum {
 struct ifla_vf_mac {
 	__u32 vf;
 	__u8 mac[32]; /* MAX_ADDR_LEN */
+	__u8 addr_len;
 };
 
 struct ifla_vf_vlan {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cec60583931f..2e1b9ffbe602 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1230,6 +1230,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_rss_query_en.vf =
 		vf_trust.vf = ivi.vf;
 
+	vf_mac.addr_len = dev->addr_len;
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;
-- 
2.12.3
