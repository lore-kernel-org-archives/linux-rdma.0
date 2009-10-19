From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] link-local address fix for rdma_resolve_addr
Date: Mon, 19 Oct 2009 15:47:09 -0700
Message-ID: <1255992430.12075.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean, Roland

Here is the updated patch that Jason and I discussed last week.

rdma_resolve_addr() returns an error when attempting to resolve ipv6
link-local address.  This patch fixes the handling of link-local address.

The patch was tested using rping run as such:

Link-local with scope:
# /usr/bin/rping -c -a <remote-system-link-local>%ib0

Link-local w/out scope: (expect failure)
# /usr/bin/rping -c -a <remote-system-link-local>
rdma_resolve_addr error -1

Own interface link local:
# /usr/bin/rping -c -a <remote-system-link-local>%ib0

Other ipv6 address:
# /usr/bin/rping -c -a 2001:db8:1234::2

(server side started with rping -s -P -v -a ::0)

Tested against ofed build OFED-1.5-20091019-0811 and kernel 2.6.30.

Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

------------------------------------------------------
 drivers/infiniband/core/addr.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index bd07803..3442256 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -278,6 +278,21 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
 	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
 
+	if (ipv6_addr_type(&src_in->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
+		if (!src_in->sin6_scope_id)
+			return -EINVAL;
+		fl.oif = src_in->sin6_scope_id;
+	}
+	if (ipv6_addr_type(&dst_in->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
+		if (dst_in->sin6_scope_id) {
+			if (fl.oif && fl.oif != dst_in->sin6_scope_id)
+				return -EINVAL;
+			fl.oif = dst_in->sin6_scope_id;
+		}
+		if (!fl.oif)
+			return -EINVAL;
+	}
+
 	dst = ip6_route_output(&init_net, NULL, &fl);
 	if (!dst)
 		return ret;
@@ -390,14 +405,16 @@ static int addr_resolve_local(struct sockaddr *src_in,
 	case AF_INET6:
 	{
 		struct in6_addr *a;
+		int found = 0;
 
 		for_each_netdev(&init_net, dev)
 			if (ipv6_chk_addr(&init_net,
 					  &((struct sockaddr_in6 *) dst_in)->sin6_addr,
-					  dev, 1))
+					  dev, 1)) {
+				found = 1;
 				break;
-
-		if (!dev)
+			}
+		if (!found)
 			return -EADDRNOTAVAIL;
 
 		a = &((struct sockaddr_in6 *) src_in)->sin6_addr;
@@ -406,6 +423,8 @@ static int addr_resolve_local(struct sockaddr *src_in,
 			src_in->sa_family = dst_in->sa_family;
 			((struct sockaddr_in6 *) src_in)->sin6_addr =
 				((struct sockaddr_in6 *) dst_in)->sin6_addr;
+			((struct sockaddr_in6 *) src_in)->sin6_scope_id =
+				((struct sockaddr_in6 *) dst_in)->sin6_scope_id;
 			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
 		} else if (ipv6_addr_loopback(a)) {
 			ret = rdma_translate_ip(dst_in, addr);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
