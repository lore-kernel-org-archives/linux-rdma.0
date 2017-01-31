From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Tue, 31 Jan 2017 00:21:17 +0000
Message-ID: <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170130221437.GA28117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, January 30, 2017 4:15 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Mon, Jan 30, 2017 at 09:52:17PM +0000, Parav Pandit wrote:
>=20
> > What I meant is, UD QP is not attached to netdev but yes with my
> > patches any QP is attached to namespace, just like regular socket.
> > So I have qp_net inside ib_qp structure.  Let me finish internal peer
> > reviews before I post the patches.
>=20
> No, regular sockets can be attached to both - '*' bind makes no sense for
> RDMA because such a socket will not rx for all ROCEE addreses, just the o=
nes
> on the device it is bound to.
>=20
> For that reason the entire concept of '*' bind should not even exist.

I am talking of binding QP or socket to namespace.
My understanding is a given socket can be bound to one and only one network=
 namespace at a time.
If that's not true, socket should have array for net.
Refer to sock_net_set() and sock_net() APIs.
Which namespace it is bound to, its obvious reason not known to the user, r=
egardless of bind(* or specific address).

>=20
> > > We certainly can't have namespaces with such an insecure design. UD
> > > QPs must not receive packets inapproprate for the netdev they are
> > > associated with, or the collection of netdevs in their namespace
> > > (for * binds)
> >
> > Haggai and I had exact same discussion few days back when I referred
> > the IB spec. 1.3.1 section C9-46.  So I agree for netdev (mac, vlan).
>=20
> ipvlan is a thing too..
Yes. Will think about this further.=20
>=20
> > But IP could be of other namespace in incoming packet and that should
> > be ok because we don't have UDP socket style bind() on UD QPs.
>=20
> That isn't OK from a security standpoint.
>=20
> You can't secure UD QPs by using the QPN, the NIC has to restrict incomin=
g
> packets to only match certain GID table entries, and those entries must b=
e
> the netdev the UD QP is bound to or all netdevices in the UD QPs's
> namespace (for '*' bind)
>=20
> Otherwise the NIC does not support rocee namespaces.
>=20
o.k. Just to highlight you, QP1 is exception to this.

> > > Well, using idev isn't going to work with child netdevs, etc
>=20
> > I have further added checks for vlan_dev in presence of wc vlan id
> > present and walking upto upper device.
>=20
> That sounds broken, there should never be walking of device or anything s=
illy
> like that to determine the ingress netdev. The only place that is done is=
 when
> constructing the GID cache.
>=20
GID table can have two gid entries with same GID content in there, but gid_=
attr->net can be different.
This is typically for vlan based devices located in two different namespace=
.
This is the fundamental point to query GID cache based on netdev's net.
Without considering net_ns, GID cache query is equally broken.
Therefore incoming packet's netdev and net namespace derivation is needed f=
rom ingress packet.

> > > The best thing to do is introduce required netdev binding for UD QPs
> > > in kernel and then the kernel's ib_init_ah_from_wc can work safely..
> > >
> > I am binding to net_ns of the calling process which can have one or
> > more netdev.
>=20
> But that doesn't make sense for in-kernel users, and those are the only u=
sers
> that can call ib_init_ah_from_wc...

Its done by default even for sockets. That's how its established that it be=
longs to init_net.
Refer to sk_alloc().

>=20
> > This is the right thing to do similar to regular sockets.
>=20
> Only if the sockets are '*' bound,..
>=20
I think you mean sockets are '*' bound to address.
Assuming yes, to it, regardless of address property they will be bound to n=
et_ns.
This covers the case of applications who are not using RDMA CM as well.

> > Exception if QP1 which will receive packets for all namespaces and
> > will ingress and egress lookups based on the git_addr->net.
>=20
> But even here you need to get the ingress netdevice from the gid cache an=
d
> use that to deduce what namespace the packet is for.
>=20
As mentioned above, GID table can have duplicate entries so namespace is id=
entified by the ingress path.
I have reviewed net code before, but I will refer again how it's done on re=
gular Ethernet packets.

> > > ifindex do not quickly re-use so this is fine.
>=20
> > Its not quickly reused but when netdevice moves to different
> > namespace, if that ifindex is already exist there, it assigns new one.
> > But I agree it's pretty corner case and its likely an administrative
> > limitation until we establish good use case.
>=20
> Oh? But in that case an (ifindex,ns) is still a stable reference.
>=20
> > > Sort of, but you can't do the route lookup until you get the netdev,
> > > and you can't get a netdev without a gid table lookup. :\
> > >
> > wc->vlan establishes netdev and its ifindex.
>=20
> Nope, that isn't enough to support all the behaviors.
>=20
> > If upper device exist, netdev is established through that in addition
> > to vlan.  netdev establishes namespace.  Namespace establishes gid
> > table search scope and therefore right sgid index.
> > Same namespace will be used for destination route table lookup as you
> > described in steps above.
>=20
> No way, that is backwards.
>=20
> The ingress netdev comes from searching the GID table, period. The GID
> table matches the vlan and dgid.
>=20
> From there you have the netnamespace to do routing lookups, etc.
>=20
> > I am glad that we are having this discussion right now.
>=20
> Can you try and submit a patch to fix Roland's problem please?
>=20
> Searching the gid table is the way to go for now...
>=20

Let's first agree/disagree for duplicate GID table entries exist for two di=
fferent namespaces.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
