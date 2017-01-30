From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Jan 2017 21:52:17 +0000
Message-ID: <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170130211420.GB27111-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, January 30, 2017 3:14 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Mon, Jan 30, 2017 at 08:15:51PM +0000, Parav Pandit wrote:
>=20
> > > Both roceev1 and v2 need to use the netdev that was used to create
> > > the UD QP to anchor these lookups, that netdev should be a child of
> > > some kind from the get_netdev (eg a vlan, or macvlan, etc)
> > >
> > As you know UD QP is not created with netdev (AH binds to netdev).
> > So AH and RC QPs are going to be anchored now around GID.
>=20
> Well, that is fundamentally incompatible with how the netdev stack works.
What I meant is, UD QP is not attached to netdev but yes with my patches an=
y QP is attached to namespace, just like regular socket.
So I have qp_net inside ib_qp structure.
Let me finish internal peer reviews before I post the patches.

>=20
> We certainly can't have namespaces with such an insecure design. UD QPs
> must not receive packets inapproprate for the netdev they are associated
> with, or the collection of netdevs in their namespace (for * binds)
>=20
Haggai and I had exact same discussion few days back when I referred the IB=
 spec. 1.3.1 section C9-46.
So I agree for netdev (mac, vlan). But IP could be of other namespace in in=
coming packet and that should be ok because we don't have UDP socket style =
bind() on UD QPs.

> In my prior message I was assuming that rocee disallowed '*' binds since =
that
> isn't really how RDMA CM works.. (what does that even mean if you have
> two rocee devices??)
>=20

> But this clearly hasn't been thought through on the rocee side, so we hav=
e a
> nonsense mess :\
>=20
> > > This is necessary to make namespaces and other subtle things work
> properly.
> >
> > Yes. I am currently testing my patches for this support in our setup.
> > I will post the patches soon.
> > However fix that Roland pointed out is needed regardless.
> > I actually hit ifindex case even with IPv4 last week but was unable to
> reproduce it.
>=20
> Well, using idev isn't going to work with child netdevs, etc
>=20
I have further added checks for vlan_dev in presence of wc vlan id present =
and walking upto upper device.

> The best approach for now is to first consult the GID table to learn the
> ingress netdev for the packet that caused the 'wc'.
>=20
> Then do an ingress route lookup to make sure the packet should have been
> accepted (bit late, but OK)
>=20
> Then do the egreess route lookup to figure out the parameters for the new
> AH.
>=20
> But this is only 'safe' if the caller of ib_init_ah_from_wc is assuming t=
he UD
> QP was bound to * - and only if there are no namespaces.
>=20
> The best thing to do is introduce required netdev binding for UD QPs in
> kernel and then the kernel's ib_init_ah_from_wc can work safely..
>=20
I am binding to net_ns of the calling process which can have one or more ne=
tdev.
This is the right thing to do similar to regular sockets.
Exception if QP1 which will receive packets for all namespaces and will ing=
ress and egress lookups based on the git_addr->net.

> > > I think this brokenness fell out of the above confusion, it should
> > > be removed, rdma_addr_find_dmac_by_grh should not be callable
> > > without a proper netdev.
> > >
> > IP route apis are working mostly based on the iface_id as input.
> > So I am thinking to continue with ifindex input argument instead of
> changing to netdev pointer.
>=20
> ifindex do not quickly re-use so this is fine.
>=20
Its not quickly reused but when netdevice moves to different namespace, if =
that ifindex is already exist there, it assigns new one.
But I agree it's pretty corner case and its likely an administrative limita=
tion until we establish good use case.

> > Currently rdma_addr_find_l2_eth_by_grh() has ifindex as optional
> > argument, which is removed in my sandbox now.
>=20
> Right, should not be optional, but I'm wondering if this routine should e=
ven
> exist in this form. The two call sites seem reasonably different.
>=20
> > > The !=3D case can happen if the gid table resolve differently than th=
e
> > > route table, but it is conceptually wrong to lookup in the gid table
> > > before doing a route lookup, and I think these apis are poorly
> > > designed to enforce that requirement.
> > >
> > Gid lookup is still done after the route lookup using
> get_sgid_index_from_eth().
> > ib_get_gids_from_rdma_hdr() just gets the GID formatted properly.
> > I think this part is ok?
>=20
> Sort of, but you can't do the route lookup until you get the netdev, and =
you
> can't get a netdev without a gid table lookup. :\
>=20
wc->vlan establishes netdev and its ifindex.
If upper device exist, netdev is established through that in addition to vl=
an.
netdev establishes namespace.
Namespace establishes gid table search scope and therefore right sgid index=
.
Same namespace will be used for destination route table lookup as you descr=
ibed in steps above.

I am glad that we are having this discussion right now.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
