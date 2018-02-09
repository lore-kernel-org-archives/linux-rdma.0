From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 16:12:24 +0000
Message-ID: <HE1PR0502MB3004BB45FC9ADB9B49CAF283D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com> <20180209161030.GA7584@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209161030.GA7584-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Friday, February 09, 2018 10:11 AM
> To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
>=20
> On Fri, Feb 09, 2018 at 04:01:51PM +0000, Bart Van Assche wrote:
> > On Thu, 2018-02-08 at 16:38 -0700, Jason Gunthorpe wrote:
> > >  enum {
> > > -	MLX4_WQE_BIND_TYPE_2		=3D (1<<31),
> > > +	MLX4_WQE_BIND_TYPE_2		=3D (1UL<<31),
> > >  	MLX4_WQE_BIND_ZERO_BASED	=3D (1<<30),
> > >  };
> >
> > Hello Jason,
> >
> > A quote from the C11 standard:
> >
> > "The expression that defines the value of an enumeration constant
> > shall be an integer constant expression that has a value representable
> > as an int. [ ... ] Each enumerated type shall be compatible with char,
> > a signed integer type, or an unsigned integer type. The choice of type
> > is implementation-defined but shall be capable of representing the
> > values of all the members of the enumeration."
> >
> > Does that mean that this change relies on extensions to the C standard?
>=20
> Yes, this relies on a common compiler extension to promote the type of en=
um
> constants beyond int. AFAIK all compilers have done this forever, kinda b=
onkers
> it isn't in C11, IMHO.
>=20
> As I understand it, the current code is also non-conforming as (1<<31) is
> apparently undefined behavior, and at least gcc throws a warning for it i=
n -
> Wpedantic mode.
>=20
> I did a patch that will make our public headers mostly strictly conformin=
g to C11
> with -Wpedantic set, which I've been wondering if it is worth sending..
>=20
Any reason to use open code instead of using BIT() macro from include/linux=
/bitops.h which does the same thing?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
