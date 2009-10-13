From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Tue, 13 Oct 2009 15:09:40 -0700
Message-ID: <1255471781.14513.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here is a patch to addr6_resolve_remote() to correctly handle link-local address.
It should cover all the conditions Jason described. 

With this patch rping works as expected.

Link-local with scope:
# /usr/bin/rping -c -a fe80::202:c903:1:1925%ib0
 
Link-local w/out scope:
# /usr/bin/rping -c  -a fe80::202:c903:1:1925
rdma_resolve_addr error -1

Other ipv6 address:
# /usr/bin/rping -c -a 2001:db8:1234::2
 
(server side started with rping -s -P -v -a ::0)

Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
-----------------------------------------------------------------

--- drivers/infiniband/core/addr.c.1759	2009-10-13 15:57:48.000000000 -0500
+++ drivers/infiniband/core/addr.c	2009-10-13 16:11:02.000000000 -0500
@@ -278,6 +278,15 @@ static int addr6_resolve_remote(struct s
 	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
 	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
 
+	if (ipv6_addr_type(&dst_in->sin6_addr) & IPV6_ADDR_LINKLOCAL){
+		if (!dst_in->sin6_scope_id)
+			return -EINVAL;
+		if ( src_in->sin6_scope_id &&
+			(src_in->sin6_scope_id != dst_in->sin6_scope_id))
+			return -EINVAL;
+		fl.oif = dst_in->sin6_scope_id;
+	}
+
 	dst = ip6_route_output(&init_net, NULL, &fl);
 	if (!dst)
 		return ret;
