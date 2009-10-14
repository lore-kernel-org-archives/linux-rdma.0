From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Wed, 14 Oct 2009 09:23:57 -0700
Message-ID: <1255537437.14513.28.camel@wilder.ibm.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20091013231234.GK5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean-
This patch should fix the behavior of rdma_resolve_addr  when using
link-local addressing.
  
On Tue, 2009-10-13 at 17:12 -0600, Jason Gunthorpe wrote:
> On Tue, Oct 13, 2009 at 03:09:40PM -0700, David J. Wilder wrote:
> > Here is a patch to addr6_resolve_remote() to correctly handle link-local address.
> > It should cover all the conditions Jason described. 
> 
> Looks pretty good to me, definitely on the right track.
> 
> Hmm..
> 
> Actually, upon comparing to tcp_ipv6.c, I'd say one more behavior is
> necessary. The code in tcp_ipv6 allows the destination to not specify
> a scope id if an interface has already been set. Looks like the two
> ways to set an interface ID are to use bind() or SO_BINDTODEVICE..
> 
> Specifying a source address to RDMA CM is similar to bind(), so if the
> source address is link local it must specify a sin6_scope_id and the
> dest address can specify 0, or the same value.

Jason - 
This new patch should closely emulate tcp_ipv6.c. when both source and
destination scope_ids are given with link-local address. 

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
+++ drivers/infiniband/core/addr.c	2009-10-14 10:47:56.000000000 -0500
@@ -278,6 +278,21 @@ static int addr6_resolve_remote(struct s
 	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
 	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
 
+	if (ipv6_addr_type(&dst_in->sin6_addr) & IPV6_ADDR_LINKLOCAL){
+		// Link-local address require an interface to be specified.
+		if (!(dst_in->sin6_scope_id||src_in->sin6_scope_id))
+			return -EINVAL;
+
+		// If src and dst interfaces are supplied they must match.
+		if ( (dst_in->sin6_scope_id && src_in->sin6_scope_id) &&
+			(src_in->sin6_scope_id != dst_in->sin6_scope_id) )
+				return -EINVAL;
+		if ( dst_in->sin6_scope_id )
+			fl.oif = dst_in->sin6_scope_id;
+		else
+			fl.oif = src_in->sin6_scope_id;
+	}
+
 	dst = ip6_route_output(&init_net, NULL, &fl);
 	if (!dst)
 		return ret;
