From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH 2/2] ipoib: show VF broadcast address
Date: Wed, 12 Jun 2019 13:33:46 +0200
Message-ID: <20190612113348.59858-2-dkirjanov@suse.com>
References: <20190612113348.59858-1-dkirjanov@suse.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612113348.59858-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, dledford@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
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
...

Signed-off-by: Denis Kirjanov <dkirjanov@suse.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2e1b9ffbe602..f70902b57a40 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1248,6 +1248,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+	    nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast) ||
 	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
 		    &vf_rate) ||
-- 
2.12.3
