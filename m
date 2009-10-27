From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: re: [PATCH] librdmacm/cmatose: add support for ipv6
Date: Tue, 27 Oct 2009 14:50:57 -0700
Message-ID: <1256680257.12957.14.camel@wilder.ibm.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
	<20091019234329.GC9643@obsidianresearch.com>
	<676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
	<20091020003344.GA14520@obsidianresearch.com>
	<1256164230.12075.31.camel@wilder.ibm.com>
	<20091021230845.GR14520@obsidianresearch.com>
	<1256245942.12075.46.camel@wilder.ibm.com>
	<660D538F30E647F3AE1E5E6C1ACBE882@amr.corp.intel.com>
	<1256667738.16192.1.camel@wilder.ibm.com>
	<EE6710D62B854E4FBA82524DEB84E8DC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <EE6710D62B854E4FBA82524DEB84E8DC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Tue, 2009-10-27 at 11:58 -0700, Sean Hefty wrote:
> >This patch adds ipv6 support to ucmatose.
> >
> >Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> Thanks.
> 
> I pulled this patch into my local git tree with just a couple of minor cleanups.
> What other patches, if any, did you use to test with it?
> 
> - Sean
> 
I have been testing ucmatose against today's ofed 1.5 build, with the
patch I posted earlier with fixes to resolve_local() and
ipv6_resolve_remote().

This patch is still missing the binding changes Jason suggested it just
fixes the existing code.  I did not see the panic you saw on 2.6.32, but
I have run on that kernel yet.

Dave..

Patch (posted earlier)

rdma_resolve_addr() returns an error when attempting to resolve ipv6
link-local address.  This patch fixes the handling of link-local address.

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
