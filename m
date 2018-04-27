From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/nes: fix nes_netdev_start_xmit()'s return type
Date: Fri, 27 Apr 2018 14:08:11 -0400
Message-ID: <1524852491.11756.68.camel@redhat.com>
References: <20180424131545.2810-1-luc.vanoostenryck@gmail.com>
         <20180424173612.GI24820@mtr-leonro.local>
         <20180425153522.GL24820@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-C+E98sWZbhnglmtvGCLE"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425153522.GL24820@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Faisal Latif <faisal.latif@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-C+E98sWZbhnglmtvGCLE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-04-25 at 18:35 +0300, Leon Romanovsky wrote:
> On Tue, Apr 24, 2018 at 08:36:12PM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 24, 2018 at 03:15:45PM +0200, Luc Van Oostenryck wrote:
> > > The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> > > which is a typedef for an enum type, but the implementation in this
> > > driver returns an 'int'.
> > >=20
> > > Fix this by returning 'netdev_tx_t' in this driver too.
> > >=20
> > > Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> > > ---
> > >  drivers/infiniband/hw/nes/nes_nic.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > ipoib_start_xmit() needs the same fix.
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-C+E98sWZbhnglmtvGCLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjZwwACgkQuCajMw5X
L91PaA//QRzgyMQZmRUR250fRRn87mDrMJePLp+dDb/mFyiUGqhWgUnMcbo7YTQK
bl0bmjT5tAO/pduZo9U+hV9bc2MvHFvjGnFFOSt462wVZGSIxzWyuwJSd0Of+X3z
KJt58LiyAJZ3FZz3QeOFv+5wNeVWzIZE6tZ11SqORcmP9HXxYUABmmtJQj286HWu
RuacG7rXuZnuDgTsz37iTP+E2WRYc9IMBpTIhBws7s/Gq172+KJYSHldpWvmKvW/
UgQb7Jv7ukXf7YZODqUnTbn5MXxb23CdpiH7zAXeDRKcDNMV5BJkMkw2NuKHPt+i
4sy82ucl+PbXBmW/+4HM6gKT8huqes7JP59k/OofY0BxfHZ9+C5lAc3L08KvSTg9
beW13A/Fa1etnX5JfGeWhQXdG9CBEa+HCgujvrnyxIWtKXjjOCwmAnFxA2OyhBfx
al7r3OYp8IA5AY7VlN8idDSJo5//TspGLw3W1V0FybXXD/GvU4bIuVoVHr3I4qfm
IUUxpTOvdr5Cg4doWbLZ+253gV8mOtw192//OLjnJ2n7oW0meB0ZPHzxSdSLOjdb
INtCxihupTaB33Smf3s7tiMUWHKLg91MamUMnp8hZKqLjny6a1b9IHQFVI9dVH7p
IJ9nqm4To4riOHW6yib2kqeMDP8iTnwFOL4uqEPDRuse9u+ap4U=
=tvA6
-----END PGP SIGNATURE-----

--=-C+E98sWZbhnglmtvGCLE--
