From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 15:58:13 +0200
Message-ID: <1438264693.9344.19.camel@opteya.com>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438256764-9077-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 30 juillet 2015 =C3=A0 04:46 -0700, Yuval Shaia a =C3=A9crit :
> This enhancement suggest the usage of IB CRC instead of CSUM in IPoIB=
=20
> CM. IPoIB CM uses RC (Reliable Connection) which guarantees the=20
> corruption free delivery of the packet.
>=20
> InfiniBand uses 32b CRC which provides stronger data integrity=20
> protection compare to 16b IP Checksum.

InfiniBand 32b CRC <=3D> Ethernet 32b CRC, it's link layer, layer 2.

IPv4 checksum is at another level, it's internet layer, layer 3.

>  So, there is no added value that IP/TCP Checksum provides in the IB=20
> world.
>=20

Sure, IPv4 checksum is a thing of the past: checksum was dropped from
IP header in IPv6: it assumes the lower layer, such as Ethernet,
provides the required integrety check.

I think not checking the IPv4 checksum should be a choice, carefully
thought, for inside a fabric, as I understand your proposal, packet
with invalid checksum will be allowed to go in/out of the fabric.

It sound like it's a departure from the behavior one can expect from an
IPv4 network stack.

> The proposal is to tell network stack that IPoIB-CM supports IP=20
> Checksum offload. This enables the kernel to save the time of=20
> checksum calculation of IPoIB CM packets. Network sends the IP packet=
=20
> without adding the IP Checksum to the header. On the receive side,=20
> IPoIB driver again tells the network stack that IP Checksum is good=20
> for the incoming packets and network stack avoids the IP Checksum=20
> calculations.
>=20
> During connection establishment the driver determine if peer supports
> IB CRC as checksum. This is done so driver will be able to calculate
> checksum before transmiting the packet in case the peer does not=20
> support this feature.
>=20

Two questions:

- What will see tool such as wireshark/tcpdump when sniffing checksum
-less IPv4 packets sent/received on IPoIB interface ?

- What might happen if such checksum-less IPv4 packet is later routed t=
o a different IPv4 network ?

> With this enhancement throughput is increased by 60%.
>=20

> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
