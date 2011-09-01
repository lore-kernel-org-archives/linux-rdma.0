From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
Date: Thu, 1 Sep 2011 11:29:34 -0600
Message-ID: <20110901172934.GI30654@obsidianresearch.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.204265835@systemfabricworks.com>
 <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com>
 <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com>
 <CAO+b5-qV9uxs=V_uHbVZ_3sm1LqkQUB0em=K=nrRxUvFQYWo5A@mail.gmail.com>
 <CAO+b5-pKPuhsrQV6igqo78y_1+gZ=09GxHoABOVnLxX3myFYZA@mail.gmail.com>
 <037f01cc6855$5780cef0$06826cd0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <037f01cc6855$5780cef0$06826cd0$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 31, 2011 at 10:15:02PM -0500, Bob Pearson wrote:

> > 1. Using ipv6_eth_mc_map() for mapping multicast GIDs seems an
> > unfortunate choice to me. That choice will cause multicast GIDs to be
> > mapped to the 33-33-xx-xx-xx-xx Ethernet address range that has been
> > reserved by RFC 2464 for IPv6 multicast addresses. If a collision with
> > an IPv6 multicast address occurs and IPv6 MLD snooping has enabled on
> > the switches in the involved network then RoCE multicast won't work
> > properly. IMHO we need a separate Ethernet address range for RoCE
> > multicast purposes, next to the existing ranges for IPv4 and IPv6.
> 
> I thought this was intentional! I.e. in order to get multicast over RoCE to
> work we were trying to piggyback on the behavior of intelligent switches.
> Otherwise the only way to get packets forwarded without adding a new group
> of multicast addresses would be to broadcast. The implementation of IGMP and
> MLD at the end node is oblivious to the packet's ethertype. And switches (at
> least the ones we tried) also happily multicast RoCE packets.

Nothing about RoCE multicast is standardized or even proposed to be
standardized.

Hijacking the IPv6 MAC space - and also abusing the net stack to
generate MLD stuff is what Mellanox did in their implementation. I
don't know if that was included in the main line submission or not?

Frankly I'd be inclined to map to the broadcast MAC address to pressure
the relevant standards bodies to finish the work on RoCE.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
