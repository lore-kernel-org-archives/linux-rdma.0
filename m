From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 16:20:29 +0000
Message-ID: <HE1PR0502MB3004F7046CDD35882E22E494D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com> <20180209161030.GA7584@mellanox.com>
 <HE1PR0502MB3004BB45FC9ADB9B49CAF283D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
 <20180209161325.GD7570@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209161325.GD7570-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Friday, February 09, 2018 10:13 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
>=20
> On Fri, Feb 09, 2018 at 04:12:24PM +0000, Parav Pandit wrote:
>=20
> > > I did a patch that will make our public headers mostly strictly
> > > conforming to C11 with -Wpedantic set, which I've been wondering if i=
t is
> worth sending..
>=20
> > Any reason to use open code instead of using BIT() macro from
> > include/linux/bitops.h which does the same thing?
>=20
> BIT only works in the kernel. This is a publich header from rdma-core use=
rspace.
>=20
o.k. Got it. Same duplicated definition exist in kernel too which is not ye=
t fixed because its unused, I guess.
Likely user space headers don't have any BIT() or support macros.
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
