From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 18:20:50 +0300
Message-ID: <20150730152049.GA29102@yuval-lab>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <1438264693.9344.19.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438264693.9344.19.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 03:58:13PM +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le jeudi 30 juillet 2015 =E0 04:46 -0700, Yuval Shaia a =E9crit :
> > This enhancement suggest the usage of IB CRC instead of CSUM in IPo=
IB=20
> > CM. IPoIB CM uses RC (Reliable Connection) which guarantees the=20
> > corruption free delivery of the packet.
> >=20
> > InfiniBand uses 32b CRC which provides stronger data integrity=20
> > protection compare to 16b IP Checksum.
>=20
> InfiniBand 32b CRC <=3D> Ethernet 32b CRC, it's link layer, layer 2.
>=20
> IPv4 checksum is at another level, it's internet layer, layer 3.
>=20
> >  So, there is no added value that IP/TCP Checksum provides in the I=
B=20
> > world.
> >=20
>=20
> Sure, IPv4 checksum is a thing of the past: checksum was dropped from
> IP header in IPv6: it assumes the lower layer, such as Ethernet,
> provides the required integrety check.
>=20
> I think not checking the IPv4 checksum should be a choice, carefully
> thought, for inside a fabric, as I understand your proposal, packet
> with invalid checksum will be allowed to go in/out of the fabric.
Yes, this is why it is controlled by module parameter.
Maybe a better choice would be to default it to 0.
>=20
> It sound like it's a departure from the behavior one can expect from =
an
> IPv4 network stack.
It should be considered as network-fine-tuning parameter so if admin kn=
ows his fabric he can use it.
>=20
> > The proposal is to tell network stack that IPoIB-CM supports IP=20
> > Checksum offload. This enables the kernel to save the time of=20
> > checksum calculation of IPoIB CM packets. Network sends the IP pack=
et=20
> > without adding the IP Checksum to the header. On the receive side,=20
> > IPoIB driver again tells the network stack that IP Checksum is good=
=20
> > for the incoming packets and network stack avoids the IP Checksum=20
> > calculations.
> >=20
> > During connection establishment the driver determine if peer suppor=
ts
> > IB CRC as checksum. This is done so driver will be able to calculat=
e
> > checksum before transmiting the packet in case the peer does not=20
> > support this feature.
> >=20
>=20
> Two questions:
Three :)
>=20
> - What will see tool such as wireshark/tcpdump when sniffing checksum
Zero or what ever the networking layer puts in csum when H/W supports C=
SUM-offloading.
Please note that with this patch driver still supports backward computa=
bility (per connection).
This means that for connections with peer which does not support this f=
unctionality you expect to see this value filled with checksum.
> -less IPv4 packets sent/received on IPoIB interface ?
No
>=20
> - What might happen if such checksum-less IPv4 packet is later routed=
 to a different IPv4 network ?
As noted above, for network that is opened to outside world this featur=
e should be blocked.
In general i would say that if a layer 2 terminator device (e.x router)=
 exist in the fabric - this feature can't be used and must be blocked.
With this limitation it still worth use it because of the reason of inc=
reasing throughput
>=20
> > With this enhancement throughput is increased by 60%.
> >=20
>=20
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Regards.
>=20
> --=20
> Yann Droneaud
> OPTEYA
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
