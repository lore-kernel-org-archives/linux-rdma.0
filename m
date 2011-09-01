From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 02/37] add opcodes to ib_pack.h
Date: Wed, 31 Aug 2011 22:15:02 -0500
Message-ID: <037f01cc6855$5780cef0$06826cd0$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.204265835@systemfabricworks.com> <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com> <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com> <CAO+b5-qV9uxs=V_uHbVZ_3sm1LqkQUB0em=K=nrRxUvFQYWo5A@mail.gmail.com> <CAO+b5-pKPuhsrQV6igqo78y_1+gZ=09GxHoABOVnLxX3myFYZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pKPuhsrQV6igqo78y_1+gZ=09GxHoABOVnLxX3myFYZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Monday, August 22, 2011 1:08 PM
> To: Bob Pearson
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
> 
> On Sat, Aug 20, 2011 at 4:47 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> wrote:
> > On Mon, Aug 15, 2011 at 6:15 PM, Bob Pearson
> > <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > > I want to eventually complete the IB transport parts of the driver
> although
> > > they are not used by RoCE. They would be useful for a soft IB
> implementation
> > > with say an FPGA based MAC/PHY. The long term goal is to have a
> complete
> > > reference implementation of the IB Architecture.
> >
> > Having a complete reference implementation of the IB architecture
> > available would be great. IMHO at least the following should be added
> > to ib_rxe (not necessarily in the first version) before it can called
> > a reference implementation:
> > - Support for secondary GIDs. These make it easy to implement
> > fail-over in a H.A. cluster.
> > - Support for multicast.
> 
> More in detail, my comments with regard to multicast support in ib_rxe
are:
> 1. Using ipv6_eth_mc_map() for mapping multicast GIDs seems an
> unfortunate choice to me. That choice will cause multicast GIDs to be
> mapped to the 33-33-xx-xx-xx-xx Ethernet address range that has been
> reserved by RFC 2464 for IPv6 multicast addresses. If a collision with
> an IPv6 multicast address occurs and IPv6 MLD snooping has enabled on
> the switches in the involved network then RoCE multicast won't work
> properly. IMHO we need a separate Ethernet address range for RoCE
> multicast purposes, next to the existing ranges for IPv4 and IPv6.

I thought this was intentional! I.e. in order to get multicast over RoCE to
work we were trying to piggyback on the behavior of intelligent switches.
Otherwise the only way to get packets forwarded without adding a new group
of multicast addresses would be to broadcast. The implementation of IGMP and
MLD at the end node is oblivious to the packet's ethertype. And switches (at
least the ones we tried) also happily multicast RoCE packets.

> 2. We need a way to limit multicast traffic to those switch ports on
> which receivers are listening. The InfiniBand architecture has such a
> protocol but it relies on the subnet manager, a component that does
> not exist in RoCE networks. And since IGMP and MLD are IPv4/IPv6
> specific we need a new (IBTA-approved) protocol.
> 3. RFC 4541, in which IGMP and MLD snooping has been defined, will
> have to be extended with a paragraph about snooping the protocol
> defined in (2).
> 4. Switch vendors will have to implement the protocol item (3) refers to.
> 
> Shouldn't a RoCE multicast implementation be postponed until the IEEE
> has assigned an Ethernet address range for mapping RoCE multicast GIDs
> ?
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
