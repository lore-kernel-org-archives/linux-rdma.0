From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Wed, 18 Oct 2017 19:00:06 +0000
Message-ID: <VI1PR0502MB30086B735FD4B5948B521673D14D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170130195412.GE24466-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh, Selvin, Somnath,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Monday, January 30, 2017 1:54 PM
> To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Sun, Jan 29, 2017 at 05:21:43PM -0800, Roland Dreier wrote:
> > I recently debugged an issue where an RDMA-CM / RoCE connection to a
> > link-local IPv6 address takes 1 second to establish.  The delay comes
> > when the passive side cm_req_handler() calls
> > cm_init_av_for_response(), which calls ib_init_ah_from_wc().
> >
> > That calls into rdma_addr_find_l2_eth_by_grh() with the link-local
> > address, but with 0 passed in through the if_index parameter.  So
> >
> > The fix seems as simple as adding
> >
> >     if_index =3D idev->ifindex;
> >
> > to ib_init_ah_from_wc() before the call to
> > rdma_addr_find_l2_eth_by_grh() - this can't fail, since we return an
> > error if finding idev fails.
>=20
> Hum, it is certainly a big conceptual mistake to not anchor a route looku=
p in a
> netdev at this point.
>=20
> Both roceev1 and v2 need to use the netdev that was used to create the UD=
 QP
> to anchor these lookups, that netdev should be a child of some kind from =
the
> get_netdev (eg a vlan, or macvlan, etc)
>=20
> This is necessary to make namespaces and other subtle things work properl=
y.
>=20
> So, right idea, wrong netdev.
>=20
> > However, I'm not sure if it's quite that simple - how does this
> > interact with RoCEv2, or other addressing like IPv4 or non-link-local
> > IPv6? I'm not sure I understand what the cases where resolved_dev will
> > be !=3D idev, or if passing in idev->ifindex will break this.
>=20
> I think this brokenness fell out of the above confusion, it should be rem=
oved,
> rdma_addr_find_dmac_by_grh should not be callable without a proper netdev=
.
>=20
> The !=3D case can happen if the gid table resolve differently than the ro=
ute table,
> but it is conceptually wrong to lookup in the gid table before doing a ro=
ute
> lookup, and I think these apis are poorly designed to enforce that requir=
ement.
>=20
> Jason

I have fixed this issue where rdma_addr_find_l2_eth_by_grh() accepts netdev=
 of the GID.
Derivation of GID is based on vlan, and DGID of the incoming GRH, network_t=
ype fields.
Finding out the right GID depends above fields from the cached gid table.

Before I post the patch,
We found that bnx_re driver doesn't set IB_WC_WITH_VLAN in the QP1 wc.
Fail to set vlan id and IB_WC_WITH_VLAN flag when incoming QP1 packet in vl=
an, will fail to search the right GID.

Please also see recent important fix in qedr driver [1] who now correctly s=
ets IB_WC_WITH_VLAN, in case if you need reference.
Most drivers are setting it correctly now.

Will you please fix this issue in bnx_re driver as well - to set IB_WC_WITH=
_VLAN, vlan_id, SL when vlan is present in QP1 UD receive packets?

Please let me know in case if you need more information.

[1] https://www.spinics.net/lists/linux-rdma/msg55115.html

Parav
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
