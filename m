From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Tue, 24 Nov 2015 10:45:14 +0100
Message-ID: <1448358314.19858.13.camel@opteya.com>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
	 <1438264693.9344.19.camel@opteya.com> <20151118104607.GB4597@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151118104607.GB4597@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 18 novembre 2015 =C3=A0 12:46 +0200, Yuval Shaia a =C3=A9cr=
it=C2=A0:
> On Thu, Jul 30, 2015 at 03:58:13PM +0200, Yann Droneaud wrote:
> > Le jeudi 30 juillet 2015 =C3=A0 04:46 -0700, Yuval Shaia a =C3=A9cr=
it :

> > > This enhancement suggest the usage of IB CRC instead of CSUM in
> > > IPoIB CM. IPoIB CM uses RC (Reliable Connection) which guarantees
> > > the corruption free delivery of the packet.
> > >=20
> > > InfiniBand uses 32b CRC which provides stronger data integrity=20
> > > protection compare to 16b IP Checksum.
> >=20
> > InfiniBand 32b CRC <=3D> Ethernet 32b CRC, it's link layer, layer 2=
=2E
> >=20
> > IPv4 checksum is at another level, it's internet layer, layer 3.
> >=20
> > > So, there is no added value that IP/TCP Checksum provides in the
> > > IB world.
> > >=20
> >=20
> > Sure, IPv4 checksum is a thing of the past: checksum was dropped
> > from IP header in IPv6: it assumes the lower layer, such as
> > Ethernet, provides the required integrety check.

> Right, will change description to something like this:
> InfiniBand 32b CRC offers strong data integrity protection compare
> CSUM.

This patch must clearly state that, without IPv4 header checksum, it's
no more IP protocol as described by RFC 791

> >=20
> > I think not checking the IPv4 checksum should be a choice,
> > carefully thought, for inside a fabric, as I understand your
> > proposal, packet with invalid checksum will be allowed to go in/out
> > of the fabric.

> If peer supports this feature do you see any reason why not?

You're free to run you own protocol inside your private network, but
this protocol is not compatible with IPv4.

> >=20
> > It sound like it's a departure from the behavior one can expect
> > from an IPv4 network stack.
> >=20
> > > The proposal is to tell network stack that IPoIB-CM supports IP=20
> > > Checksum offload. This enables the kernel to save the time of=20
> > > checksum calculation of IPoIB CM packets. Network sends the IP
> > > packet without adding the IP Checksum to the header. On the
> > > receive side, IPoIB driver again tells the network stack that IP
> > > Checksum is good for the incoming packets and network stack
> > > avoids the IP Checksum calculations.
> > >=20
> > > During connection establishment the driver determine if peer
> > > supports IB CRC as checksum. This is done so driver will be able
> > > to calculate checksum before transmiting the packet in case the
> > > peer does not support this feature.
> > >=20
> >=20
> > Two questions:
> >=20
> > - What will see tool such as wireshark/tcpdump when sniffing
> > checksum-less IPv4 packets sent/received on IPoIB interface ?

> Never checked it but i assume 0 or what ever the kernel put there
> when driver reports NETIF_F_IP_CSUM. I can check and zero if needed
> but any reason to believe it is needed?

I don't think it's needed if you agree that this modification creates a
new protocol which is no more IPv4.

> >=20
> > - What might happen if such checksum-less IPv4 packet is later
> > routed to a different IPv4 network ?

> Same as my question above, if peer supports this feature do you see
> anything wrong?

If peer is going to forward this packet to a different network, which
is not IPoIB based, the checksum will be checked and the packet will be
rejected.

Regards.

--=C2=A0
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
