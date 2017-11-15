From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to resolve
 link local address
Date: Wed, 15 Nov 2017 04:04:37 +0000
Message-ID: <VI1PR0502MB30080133A617972DC6F362F1D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-4-leon@kernel.org> <20171115003238.GI25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115003238.GI25894-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Tuesday, November 14, 2017 6:33 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav
> Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to res=
olve
> link local address
>=20
> On Tue, Nov 14, 2017 at 02:51:50PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Currently ib_resolve_eth_dmac() bypasses IPv6 stack for resolving link
> > local destination mac address and translates the IPv6 link local GID
> > to MAC address, which is not always correct.
> > Static link local neighbour entry can be setup using ip -6 neigh add
> > <link_local_addr> lladdr <mac_addr> dev eth0 Current code bypasses
> > such administratively set entries and IPV6 stack.
>=20
> At the very least this description makes little sense.
>=20
> The code is inspecting a DGID, and when in rocev1 mode, the DGID is
And it is inspecting SGID type too as rocev1 or v2 using below check.
sgid_attr.gid_type =3D=3D IB_GID_TYPE_ROCE

> *NOT* an IPv6 address and the correct thing to do is what it is doing now=
.
>=20
Yes. It does what it does today. When SGID is RoCEv1, it doesn't do ND.

> In rocev2 mode the DGID becomes and IPv6 address and you should do ND.
>=20
> Has this distinction been captured in the patch?
Yes. When SGID type is RoCEv2, it performs ARP/ND.
This is described in commit log - it uses rdma_addr_find_l2_eth_by_grh() wh=
ich performs ND.

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
