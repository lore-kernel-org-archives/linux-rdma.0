From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 23:37:36 +0300
Message-ID: <20150730203735.GB3487@yuval-lab>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <1438264693.9344.19.camel@opteya.com>
 <20150730152049.GA29102@yuval-lab>
 <55BA47F0.5080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BA47F0.5080504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 11:51:12AM -0400, Doug Ledford wrote:
> On 07/30/2015 11:20 AM, Yuval Shaia wrote:
> > On Thu, Jul 30, 2015 at 03:58:13PM +0200, Yann Droneaud wrote:
> >> Hi,
> >>
> >> Le jeudi 30 juillet 2015 =E0 04:46 -0700, Yuval Shaia a =E9crit :
> >>> This enhancement suggest the usage of IB CRC instead of CSUM in I=
PoIB=20
> >>> CM. IPoIB CM uses RC (Reliable Connection) which guarantees the=20
> >>> corruption free delivery of the packet.
> >>>
> >>> InfiniBand uses 32b CRC which provides stronger data integrity=20
> >>> protection compare to 16b IP Checksum.
> >>
> >> InfiniBand 32b CRC <=3D> Ethernet 32b CRC, it's link layer, layer =
2.
> >>
> >> IPv4 checksum is at another level, it's internet layer, layer 3.
> >>
> >>>  So, there is no added value that IP/TCP Checksum provides in the=
 IB=20
> >>> world.
> >>>
> >>
> >> Sure, IPv4 checksum is a thing of the past: checksum was dropped f=
rom
> >> IP header in IPv6: it assumes the lower layer, such as Ethernet,
> >> provides the required integrety check.
> >>
> >> I think not checking the IPv4 checksum should be a choice, careful=
ly
> >> thought, for inside a fabric, as I understand your proposal, packe=
t
> >> with invalid checksum will be allowed to go in/out of the fabric.
> > Yes, this is why it is controlled by module parameter.
> > Maybe a better choice would be to default it to 0.
>=20
> In it's current form, yes, it should default to 0.
>=20
> >>
> >> It sound like it's a departure from the behavior one can expect fr=
om an
> >> IPv4 network stack.
> > It should be considered as network-fine-tuning parameter so if admi=
n knows his fabric he can use it.
> >>
> >>> The proposal is to tell network stack that IPoIB-CM supports IP=20
> >>> Checksum offload. This enables the kernel to save the time of=20
> >>> checksum calculation of IPoIB CM packets. Network sends the IP pa=
cket=20
> >>> without adding the IP Checksum to the header. On the receive side=
,=20
> >>> IPoIB driver again tells the network stack that IP Checksum is go=
od=20
> >>> for the incoming packets and network stack avoids the IP Checksum=
=20
> >>> calculations.
> >>>
> >>> During connection establishment the driver determine if peer supp=
orts
> >>> IB CRC as checksum. This is done so driver will be able to calcul=
ate
> >>> checksum before transmiting the packet in case the peer does not=20
> >>> support this feature.
> >>>
> >>
> >> Two questions:
> > Three :)
>=20
> No, he really only had 2, the second one was a line split of the word
> checksum-less done by his mailer ;-)
>=20
> >>
> >> - What will see tool such as wireshark/tcpdump when sniffing check=
sum
> > Zero or what ever the networking layer puts in csum when H/W suppor=
ts CSUM-offloading.
> > Please note that with this patch driver still supports backward com=
putability (per connection).
> > This means that for connections with peer which does not support th=
is functionality you expect to see this value filled with checksum.
> >> -less IPv4 packets sent/received on IPoIB interface ?
> > No
> >>
> >> - What might happen if such checksum-less IPv4 packet is later rou=
ted to a different IPv4 network ?
> > As noted above, for network that is opened to outside world this fe=
ature should be blocked.
> > In general i would say that if a layer 2 terminator device (e.x rou=
ter) exist in the fabric - this feature can't be used and must be block=
ed.
> > With this limitation it still worth use it because of the reason of=
 increasing throughput
>=20
> In its current state, I have my doubts about this patch.  However, it
> seems to me that this should be relatively easy to fix in such a way
> that you get 90%+ of the performance benefit, and can turn it on by
> default, and we don't cause any problems.  Why not perform the checks=
um
> operation on a per connection basis?  This is all IPoIB traffic anywa=
y,
This part is already implemented.
Actually this is the main purpose of adding 'caps' field to ipoib_cm_tx=
=2E
The peer capabilities (currently only one option but design let us add
up to 12 capabilities in the future) is passed in IPoIB's private data =
and
saved in ipoib_cm_tx.caps per connection basis.
Then, on ipoib_cm_send, the decision is made based on that (and on some
other conditions) and if needed - the driver calculate the checksum jus=
t
before sending.
> so every send will have a src ip and dst ip.  If the dst ip is link
> local to our src ip device, and the connected mode partner is capable=
 of
> running without csum, then send that specific packet without doing a
> checksum.  If the IP address is not link local, then do the checksum =
as
> normal.  That way if our final destination is on the other side of a
> router, we aren't leaking un-checksummed packets.  It means we would
> miss out on being able to do checksum-less transfers from host A on
> fabric 0 through host B as a router to host C on fabric 1, but I doub=
t
> that's a very common situation to be in.  Or maybe a better way of
> putting this is if our next hop IP address !=3D our dest IP address, =
then
> perform the checksum, otherwise if capable of checksum-less operation=
,
> do so.  Can you rework the patch to operate in that manner?
I think that the concern with 'router' is that when packet goes into it
and then goes out from it - we cannot trust end-to-end IB-CRC as this i=
s
layer 2 CRC.
So, if i understand you correctly, you suggest to tread every host beyo=
nd
a router as one that does not support this "fake" and to calculate csum
for it?
This make sense to me but does it cover all such cases (where we can't
trust end-to-end IB-CRC)?
If yes then sure, it is easy to implement.
This way we can default it to 1 and get rid of this module param.
>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
