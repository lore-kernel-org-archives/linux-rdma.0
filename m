From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Tue, 7 Nov 2017 19:10:26 +0200
Message-ID: <20171107171026.GN18825@mtr-leonro.local>
References: <20171107163326.23881-1-leon@kernel.org>
 <20171107164632.GA7063@ziepe.ca>
 <065e66ff-e901-bd5c-674d-173eab720989@mellanox.com>
 <20171107165539.GB7063@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107165539.GB7063-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2017 at 09:55:39AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 07, 2017 at 10:52:11AM -0600, Daniel Jurgens wrote:
> > On 11/7/2017 10:46 AM, Jason Gunthorpe wrote:
> > > On Tue, Nov 07, 2017 at 06:33:26PM +0200, Leon Romanovsky wrote:
> > >
> > >> -	bool special_qp =3D (qp->qp_type =3D=3D IB_QPT_SMI ||
> > >> -			   qp->qp_type =3D=3D IB_QPT_GSI ||
> > >> -			   qp->qp_type >=3D IB_QPT_RESERVED1);
> > >> +	struct ib_qp *real_qp =3D qp->real_qp;
> > >> +	bool special_qp =3D (real_qp->qp_type =3D=3D IB_QPT_SMI ||
> > >> +			   real_qp->qp_type =3D=3D IB_QPT_GSI ||
> > >> +			   real_qp->qp_type >=3D IB_QPT_RESERVED1);
> > > This QPT_RESERVED stuff was not supposed to be visible to the core
> > > layer, so why are we adding checks in security????
> >
> > The checks exclude those QPs from security enforcement.=A0 They've
> > been there the whole time, you reviewed this previously right?
>
> Nope
>
> .. and they shouldn't be there, those reserved QPTs are totally banned
> from user space so it shouldn't matter for security

We will send followup patch to clean it, but for this patch I prefer do
not change the logic here because it is supposed to go to stable@.

Thanks

>
> Jason
>

--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloB6QIACgkQ5GN7iDZy
WKfZvQ/+KoGthI9bclUGN0Q0kgWezJWFm0sNBoxVa993JnG/DQVYX5LVh0nkIBTr
eldYVdWnV6oD+Y+VfPwsw51ZPnmRtUDg9Jm2+4+FcEmCk22ZVhQyx6TTkXDMKGb4
BspzCkfWdUyDoblIbh6xOD2YGbsbg34S6zfkIERrJgvpV46Qae5qHGD2SnFWa0R6
jVhR/IN0YHwbUxuzPRbydIiOZW9Zr8PVPEmu0hyfG0VYXDxj+np3u+EJM1tqGRt6
THXad2TjdLwwkS/vQUjvFweCWXyhsUrAq0AsAlpXgDHRmmowKZ1Ye3hGBh1E9efY
sdfvqp2prm6dbiD4nDa9TWxdcEqXuqpwdkkU1hApep8ETyCGJrDjf72uxIlP6e/b
b+oJF5onRJQb9cgoQE4wIFtr3OXl30vGXodkv3j4u+CyFYUbyuVjGMODTG++wM/E
23YSymEFKnNJtSp3JrYCSgPiCxiZSrbExbZhA21Gl1JtqmJs6dtyC4iTmqfH3djP
kFgBtL3pK5H9OotesfKL7M5Mi5w8QNnWhMbm8lszSFMIBNrEA8FFK6mXGyNloDH/
dBQAMyKv1idgdMmNF2ZxYg/ILzcMxhd0r2tvsqA9DUy5OAT5DVT0Oa1H+Awt8cFu
i6PSisI2A8poBqfX2CoXDxR/86BYmkytGkexZI+rujvlN0cE9YI=
=e5HZ
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
