From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Thu, 15 Oct 2009 15:32:05 -0600
Message-ID: <20091015213205.GV5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
	<1255537437.14513.28.camel@wilder.ibm.com>
	<20091014170155.GL5191@obsidianresearch.com>
	<1255541405.5111.14.camel@wilder.ibm.com>
	<20091014174017.GM5191@obsidianresearch.com>
	<1255634841.5111.40.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255634841.5111.40.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2009 at 12:27:21PM -0700, David J. Wilder wrote:
> On Wed, 2009-10-14 at 13:09 Jason Gunthorpe wrote:
> 
> > So, it tries to match the source addr to the addrs bound to the
> > device, which is wrong - that isn't how the ip stack works.
> 
> > You can patch this up a little bit by fixing up addr_resolve_local to
> > set sin6_scope_ip.
> 
> I found the bug in addr_resolve_local().  (more comments below)

Yes, that is the hacky work around I was mentioning..

> > But really the correct thing to do is to remove addr_resolve_local and
> > place the source address into the struct flowi and use the result of
> > the route lookup to bind to the source device, and set the source
> > address if it is unset.
> 
> Sorry I don't get it..
> Are you saying that ip6_route_output() will resolve the address even if
> it is a link-local address bound to my own interface? Therefor
> addr_resolve_local() is not needed.

Yes, and more. In Linux the routing table takes as input the source
(optional), device (optional) and destination address and returns as
output the device to use.

To determine the device to bind to you ask the routing table what
device to use for all the route information you have.

For example:

$ ip route get fe80::c2d from fe80::213:72ff:fe29:e65d oif eth0
fe80::c2d via fe80::c2d dev eth0  src fe80::213:72ff:fe29:e65d  metric 0 
    cache  mtu 1500 advmss 1440 hoplimit 4294967295

$ ip route get fe80::c2d oif eth0
fe80::c2d via fe80::c2d dev eth0  src fe80::213:72ff:fe29:e65d  metric 0 
    cache  mtu 1500 advmss 1440 hoplimit 4294967295

You can see in both cases the routing table returns a 'src'
entry. 'src' is the address to bind to if no bind address was specified.

When doing link local addresess the sin6_scope_id should sets the
'oif' key in the routing lookup, which will result in the correct src
address and output device being selected by the routing algorithm. For
instance on my machine here, I have two interfaces:

$ ip route get fe80::c2d oif virbr0 
fe80::c2d via fe80::c2d dev virbr0  src fe80::2c5d:c4ff:feb8:1ce5  metric 0 
    cache  mtu 1500 advmss 1440 hoplimit 4294967295

As you can see it is returning the link local address for virbr0 as
the source.

So the algorithm in RDMA CM should look like this:
 - If src is specified then set the bind local address to src
   [if src is link local then it must specify sin6_scope_id, and
   sin6_scope_id becomes the oif input to the route lookup]
 - If dst is link local then its sin6_scope_id is the oif to the route
   lookup (and must match src, as we did last go round)
 - Src (or 'any'), dst and device (or 'any') are passed to the route
   lookup
 - The RDMA CM ID is bound to the device returned by the route lookup
 - If the src address was not specified then the connection source IP
   is set to the 'src' value from the route lookup.

This is why addr_resolve_local/rdma_translate_ip is not needed, that
entire entire function is done by the routing table code.

You can see why this becomes important when it is combined with policy
routing, for instance consider this example:

$ ip rule
32765:  from 10.0.0.4 lookup dnat
$ ip route show table dnat
default via 10.0.0.1 dev eth1
$ ip route get 10.0.0.100
10.0.0.100 dev eth0  src 10.0.0.2 
$ ip route get 10.0.0.100 from 10.0.0.4
10.0.0.100 from 10.0.0.4 via 10.0.0.1 dev eth1
    cache  mtu 1500 advmss 1460 hoplimit 64

The two results are radically different and dependant on the source
address. (10.0.0.4 could be attached to eth0, and eth1!)

The actual fixing to the code is not hard, remove rdma_translate_ip,
addr_resolve_local, split addr_resolve_remote into a part to resolve
the route and a part that does the arp/nd. Make the route resolve part
work almost exactly like addr4_resolve_remote (noting that the v6
version is wrong, since is doesn't respect unset source addres,
another bug). Call rdma_copy_addr based on the rt->idev->dev (or
should it be odev??). Do the ARP.

The pain is in retesting everything :|

Jason
