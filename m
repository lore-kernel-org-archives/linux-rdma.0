From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 40iw: include linux/irq.h
Date: Wed, 14 Mar 2018 16:10:42 -0400
Message-ID: <1521058242.18703.103.camel@redhat.com>
References: <20180313120644.2619889-1-arnd@arndb.de>
         <20180313132000.GA18400@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/ymUGrBBWfd4Dv/wwzyH"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313132000.GA18400@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Faisal Latif <faisal.latif@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Artemy Kovalyov <artemyko@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-/ymUGrBBWfd4Dv/wwzyH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-03-13 at 08:20 -0500, Shiraz Saleem wrote:
> On Tue, Mar 13, 2018 at 01:06:20PM +0100, Arnd Bergmann wrote:
> > We get a build failure on ARM unless the header is included explicitly:
> >=20
> > drivers/infiniband/hw/i40iw/i40iw_verbs.c: In function 'i40iw_get_vecto=
r_affinity':
> > drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: implicit decla=
ration of function 'irq_get_affinity_mask'; did you mean 'irq_create_affini=
ty_masks'? [-Werror=3Dimplicit-function-declaration]
> >   return irq_get_affinity_mask(msix_vec->irq);
> >          ^~~~~~~~~~~~~~~~~~~~~
> >          irq_create_affinity_masks
> > drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: returning 'int=
' from a function with return type 'const struct cpumask *' makes pointer f=
rom integer without a cast [-Werror=3Dint-conversion]
> >   return irq_get_affinity_mask(msix_vec->irq);
> >=20
> > Fixes: 7e952b19eb63 ("i40iw: Implement get_vector_affinity API")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
>=20
> Looks like you beat me to it. 0-day caught this on rdma-nxt and I was goi=
ng to send the fix today.=20
>=20
> Typo in the subject. 40iw --> i40iw. Othwerwise, looks good.
>=20
> Thanks for the patch, Arnd!
>=20
> Shiraz
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-/ymUGrBBWfd4Dv/wwzyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpgcIACgkQuCajMw5X
L91F4w/+OSKz9gxNSVsdcK3wkvZGyb9imq3bUVOweaA9a5sWHrO9Nv0qXUwTf6PP
Pr7uyv1FHug0NYZNYF10E+d3hrs8c7DiJpKpXvrDGJA3Jz9Lj9VRSKoYB+X81FA5
jWw5r7haoh67kj6j18VspIcQ0znJoJUTNfhHJng0I7WYj/X2EgVq/mz+N3VNgwG4
u2V7qtnhdlst3bMfOtyAigh8UzojVDmSV1rQClUG0uLz/6EVJkAOv6UiP30hWcSh
G9tXTIeJSJ+jOM0X1jfuMhSb0yTTfLKWCAdCUHRs29VifTfz6OgfuRDtAhr2FjaT
7dAFMMFhjwmA84O84TUm8KYjP55au9GKvdGoq+oTNqNC2nySJdoNtFXIG51FFv6P
YfBE9RQxyb81jASUQrWQgMAJvaeTGtZFO/TonMVBLUxTcJYgKdibrr1Pd6U49Kik
bs3QiLKYjp34RGedrLixP6BXpEgO3KtdnM5IEiqR7ftldBEHBDArv1ZoiYp6WRl0
U+NB3lBxd8EKImGXCqRI5qmYHIfxsvp9S3ZlUk6HghhTZhrAiVvH4tLXkktqYRWB
ncr5OmkvyWsMVelyjdJgaGdDSkZi3dlG50gi6D6KLrYqxIA0iCao2HwrV+NeQrW9
PGPXR1FG1VDyHOQVMh36Zv4Y1eEbLAM/Gfi/62U+FPdU8J9ChRY=
=hbze
-----END PGP SIGNATURE-----

--=-/ymUGrBBWfd4Dv/wwzyH--
