From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/6] RDMA/hfi1: Avoid redeclaration error
Date: Wed, 17 Aug 2016 09:45:59 +0300
Message-ID: <20160817064559.GF5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-4-git-send-email-leon@kernel.org>
 <20160817060139.GA27477@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817060139.GA27477-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 02:01:40AM -0400, ira.weiny wrote:
> On Tue, Aug 16, 2016 at 04:45:20PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > Plugging HFI1 IOCTL defines will cause to the following
> > build error for QIB:
> >   CC [M] drivers/infiniband/hw/qib/qib_sysfs.o
> > In file included from ./include/uapi/rdma/rdma_user_ioctl.h:39:0,
> > 		 from include/uapi/rdma/ib_user_mad.h:38,
> > 		 from include/rdma/ib_mad.h:43,
> > 		 from include/rdma/ib_pma.h:38,
> > 		 from drivers/infiniband/hw/qib/qib_mad.h:37,
> > 		 from drivers/infiniband/hw/qib/qib_init.c:49:
> > ./include/uapi/rdma/hfi/hfi1_user.h:370:2: error: redeclaration of
> > enumerator =E2=80=98ur_rcvhdrtail=E2=80=99
> >   ur_rcvhdrtail =3D 0,
>=20
> I was pretty confused about what you were doing here mainly because you
> reference a symbol you don't actually touch in the patch.
>=20
> I see what you are doing now.  But a better explanation would be:
>=20
> <quote>
>=20
> Move hfi1 ioctl definitions to a new header which can be included by both=
 the
> hfi1 and qib drivers to avoid a duplicate enum definition as shown in this
> build error:
>=20
> build error for QIB:
>   CC [M] drivers/infiniband/hw/qib/qib_sysfs.o
> In file included from ./include/uapi/rdma/rdma_user_ioctl.h:39:0,
> 		 from include/uapi/rdma/ib_user_mad.h:38,
> 		 from include/rdma/ib_mad.h:43,
> 		 from include/rdma/ib_pma.h:38,
> 		 from drivers/infiniband/hw/qib/qib_mad.h:37,
> 		 from drivers/infiniband/hw/qib/qib_init.c:49:
> ./include/uapi/rdma/hfi/hfi1_user.h:370:2: error: redeclaration of
> enumerator =E2=80=98ur_rcvhdrtail=E2=80=99
>   ur_rcvhdrtail =3D 0,
>=20
>=20
> The actual move of the ioctl definitions comes in a follow on patch.
> </quote>
>=20

It is definitely better.
I'll update it in next version.

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtAgnAAoJEORje4g2clin7zQP/A2id2TqvE+lmqn3pNrNL3H0
z8KrKDOK4z6dS52u6eWriuSsfRkD5jrddlnPDnGEzEjEnx+7BErTs4HXWJ1IZg+Y
BGB2buiQGp80JMKjx3Col5nEqh3d0cjgEp57XZ1oNzU/N+U2eR2Jtyzze8sbl0aD
2NkfjLbck9/bsMUO2mQmH1OMqFWPEzYQjkrDrJhfjqR1xLosKZgAx/gnTvWc3/xy
mOYQk9IaZfslk+JPfhIq2STINLaB+Fhd9YMF4kEvPYIUQc0DKHJhNr+jGu7kH7mB
vtn+vmvokvByH5dvoKf1PVb/1CY82J5IhUKMvXrB6iDr4wuxwl1uJjqQbMmqTbHc
DvQSEYiCxye3eFzelRn6LK6qtlbJpuzBnvLCjDhH1CTWyV4rTDiZxdRVdB9i/qwO
QbaGcrrFoctunMC4O0AHlppHcOA0a+ZZw9GiJ1ohzrYw8S29ubPcdlCsKFRp7PQR
wmjL1FdVRP+/+b0P6EP5OMpwik/FaZ/Axc6LIsXwGmu0fk1DIvlchUL4aEP+NxbM
BvIZyy25rRBacANqW/DEmH5umkFYIr99j6y43P8iCigu2es4cWhO+HyiOdQhrR6F
OFfrp1mfqzJQvx40sF68pRV1XENH0x8+NN5Vkla1R29fNeNsaSz2HJrOdOSd3m8s
1uY4x+Fw7Li0PlCOyQCR
=yT4K
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
