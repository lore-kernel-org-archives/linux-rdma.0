From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/core: Add support for RoCEv2 multicast
Date: Mon, 12 Jun 2017 11:14:04 +0300
Message-ID: <20170612081404.17553-4-leon@kernel.org>
References: <20170612081404.17553-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612081404.17553-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When creating address handle from multicast GID, set MAC according to
the appropriate formula instead of searching for it in the GID table:
- For IPv4 multicast GID use ip_eth_mc_map().
- For IPv6 multicast GID use ipv6_eth_mc_map().

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 0e8e6d1b5b5b..c24be769aab9 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1220,6 +1220,18 @@ int ib_resolve_eth_dmac(struct ib_device *device,
 	if (rdma_link_local_addr((struct in6_addr *)grh->dgid.raw)) {
 		rdma_get_ll_mac((struct in6_addr *)grh->dgid.raw,
 				ah_attr->roce.dmac);
+		return 0;
+	}
+	if (rdma_is_multicast_addr((struct in6_addr *)ah_attr->grh.dgid.raw)) {
+		if (ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw)) {
+			__be32 addr = 0;
+
+			memcpy(&addr, ah_attr->grh.dgid.raw + 12, 4);
+			ip_eth_mc_map(addr, (char *)ah_attr->roce.dmac);
+		} else {
+			ipv6_eth_mc_map((struct in6_addr *)ah_attr->grh.dgid.raw,
+					(char *)ah_attr->roce.dmac);
+		}
 	} else {
 		union ib_gid		sgid;
 		struct ib_gid_attr	sgid_attr;
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
