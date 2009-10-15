From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Thu, 15 Oct 2009 12:27:21 -0700
Message-ID: <1255634841.5111.40.camel@wilder.ibm.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
	<1255537437.14513.28.camel@wilder.ibm.com>
	<20091014170155.GL5191@obsidianresearch.com>
	<1255541405.5111.14.camel@wilder.ibm.com>
	<20091014174017.GM5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20091014174017.GM5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2009-10-14 at 13:09 Jason Gunthorpe wrote:

> So, it tries to match the source addr to the addrs bound to the
> device, which is wrong - that isn't how the ip stack works.

> You can patch this up a little bit by fixing up addr_resolve_local to
> set sin6_scope_ip.

I found the bug in addr_resolve_local().  (more comments below)

--- addr.c.1759	2009-10-13 15:57:48.000000000 -0500
+++ addr.c.ip_local	2009-10-15 14:03:50.000000000 -0500
@@ -390,14 +390,17 @@ static int addr_resolve_local(struct soc
 	case AF_INET6:
 	{
 		struct in6_addr *a;
+		int found = 0;
 
 		for_each_netdev(&init_net, dev)
 			if (ipv6_chk_addr(&init_net,
 					  &((struct sockaddr_in6 *) dst_in)->sin6_addr,
-					  dev, 1))
+					  dev, 1)){
+				found = 1;
 				break;
+			}
 
-		if (!dev)
+		if (!found)
 			return -EADDRNOTAVAIL;
 
 		a = &((struct sockaddr_in6 *) src_in)->sin6_addr;
@@ -406,6 +409,8 @@ static int addr_resolve_local(struct soc
 			src_in->sa_family = dst_in->sa_family;
 			((struct sockaddr_in6 *) src_in)->sin6_addr =
 				((struct sockaddr_in6 *) dst_in)->sin6_addr;
+			((struct sockaddr_in6 *) src_in)->sin6_scope_id =
+                                ((struct sockaddr_in6 *) dst_in)->sin6_scope_id;
 			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
 		} else if (ipv6_addr_loopback(a)) {
 			ret = rdma_translate_ip(dst_in, addr);


> But really the correct thing to do is to remove addr_resolve_local and
> place the source address into the struct flowi and use the result of
> the route lookup to bind to the source device, and set the source
> address if it is unset.

Sorry I don't get it..
Are you saying that ip6_route_output() will resolve the address even if
it is a link-local address bound to my own interface? Therefor
addr_resolve_local() is not needed.
