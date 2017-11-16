From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to resolve
 link local address
Date: Thu, 16 Nov 2017 02:21:45 +0000
Message-ID: <VI1PR0502MB3008EEEEF2531ADC830237E3D12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-4-leon@kernel.org> <20171115003238.GI25894@ziepe.ca>
 <VI1PR0502MB30080133A617972DC6F362F1D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171115044129.GL25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115044129.GL25894-uk2M96/98Pc@public.gmane.org>
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
> Subject: Re: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to res=
olve
> link local address
>=20
> On Wed, Nov 15, 2017 at 04:04:37AM +0000, Parav Pandit wrote:
>=20
> > > Has this distinction been captured in the patch?
> > Yes. When SGID type is RoCEv2, it performs ARP/ND.
>=20
> Good then..
>=20
> > This is described in commit log - it uses
> > rdma_addr_find_l2_eth_by_grh() which performs ND.
>=20
> I find your commit messages very hard to understand.
>=20
Thanks Jason for the input. I will improve upon in future commits.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
