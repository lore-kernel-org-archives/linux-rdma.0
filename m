From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
Date: Thu, 1 Sep 2011 19:51:09 +0200
Message-ID: <CAO+b5-r9agN-5ayYdZA76dY1hk4V8VZef4aEsDhcmFrS5YSkwA@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.204265835@systemfabricworks.com> <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com>
 <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com> <CAO+b5-qV9uxs=V_uHbVZ_3sm1LqkQUB0em=K=nrRxUvFQYWo5A@mail.gmail.com>
 <CAO+b5-pKPuhsrQV6igqo78y_1+gZ=09GxHoABOVnLxX3myFYZA@mail.gmail.com> <037f01cc6855$5780cef0$06826cd0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <037f01cc6855$5780cef0$06826cd0$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 1, 2011 at 5:15 AM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > On Sat, Aug 20, 2011 at 4:47 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> > More in detail, my comments with regard to multicast support in ib_rxe
> are:
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

Shouldn't both the RoCE specification and RFC 4541 be updated
according to the above ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
