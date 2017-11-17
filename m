From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default
 GID when IPv6 is disabled
Date: Fri, 17 Nov 2017 02:40:25 +0000
Message-ID: <VI1PR0502MB30088002C62858EEA0487533D12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-2-leon@kernel.org> <20171115001817.GH25894@ziepe.ca>
 <VI1PR0502MB300800ABA04E768A68684608D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171115044049.GK25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115044049.GK25894-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Tuesday, November 14, 2017 10:41 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 defau=
lt
> GID when IPv6 is disabled
>=20
> On Wed, Nov 15, 2017 at 03:59:26AM +0000, Parav Pandit wrote:
>=20
> > Currently in rest of the IB stack in cma.c, addr.c we check for
> > IS_ENABLED(CONFIG_IPV6).  May be when all of them are changed, this
> > can also shift to honoring sysctl.
>=20
> I think most of the rest of the stack is guarding things that would cause=
 linking
> problems when ipv6 is compiled out, those cannot be changed to sysctl.
>=20
> Since this clearly should be sysctl based it should start out that way.
Ok. But I will not be able to provide such fix anytime soon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
