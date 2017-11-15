From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default
 GID when IPv6 is disabled
Date: Wed, 15 Nov 2017 03:59:26 +0000
Message-ID: <VI1PR0502MB300800ABA04E768A68684608D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-2-leon@kernel.org> <20171115001817.GH25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115001817.GH25894-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Tuesday, November 14, 2017 6:18 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav
> Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 defau=
lt
> GID when IPv6 is disabled
>=20
> On Tue, Nov 14, 2017 at 02:51:48PM +0200, Leon Romanovsky wrote:
>=20
> > +	/* Default GID is created using unique GUID and local subnet prefix,
> > +	 * as described in section 4.1.1 and 3.5.10 in IB spec 1.3.
> > +	 * Therefore don't create RoCEv2 default GID based on it that
> > +	 * resembles as IPv6 GID based on link local address when IPv6 is
> > +	 * disabled in kernel.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_IPV6))
> > +		gid_type_mask &=3D ~BIT(IB_GID_TYPE_ROCE_UDP_ENCAP);
>=20
> There is also a sysctl to globally disable ipv6, I would think it would b=
e better to
> check than then a CONFIG symbol?
>=20
Currently in rest of the IB stack in cma.c, addr.c we check for IS_ENABLED(=
CONFIG_IPV6).
May be when all of them are changed, this can also shift to honoring sysctl=
.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
