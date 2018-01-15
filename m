From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/3] RDMA/core: Remove RoCE support from
 rdma_addr_get_sgid()
Date: Mon, 15 Jan 2018 22:52:37 +0000
Message-ID: <VI1PR0502MB3008A0E2B956F26EAACA4937D1EB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-2-leon@kernel.org> <20180115220741.GA18489@ziepe.ca>
 <VI1PR0502MB300827C3710085B7D3C3A924D1EB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180115224742.GD2206@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115224742.GD2206-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Monday, January 15, 2018 4:48 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;
> Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 1/3] RDMA/core: Remove RoCE support from
> rdma_addr_get_sgid()
>=20
> On Mon, Jan 15, 2018 at 10:34:13PM +0000, Parav Pandit wrote:
>=20
> > > Can you define what the SGID/DGID should be in the rdma CM uapi when
> > > working with rocee?
> > >
> > It is the GIDs derived from the IP address using ip2gid() conversion.
>=20
> So then why is it OK for this patch to start returning dev_addr->src_dev_=
addr ?
>=20
It is not ok for RoCE. Therefore as the subject line says, it is no longer =
supported for RoCE.
For other transports the code is unchanged. It continues to report src_dev_=
addr.
For example, for IB transport GIDs are not derived IP address.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
