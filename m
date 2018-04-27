From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/ipoib: fix ipoib_start_xmit()'s return type
Date: Fri, 27 Apr 2018 14:08:27 -0400
Message-ID: <1524852507.11756.69.camel@redhat.com>
References: <20180424131549.2859-1-luc.vanoostenryck@gmail.com>
         <20180425153532.GM24820@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bG1LVjLBjd3Y/MM/shNy"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425153532.GM24820@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Alex Vesker <valex@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Erez Shitrit <erezsh@mellanox.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Feras Daoud <ferasda@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-bG1LVjLBjd3Y/MM/shNy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-04-25 at 18:35 +0300, Leon Romanovsky wrote:
> On Tue, Apr 24, 2018 at 03:15:47PM +0200, Luc Van Oostenryck wrote:
> > The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> > which is a typedef for an enum type, but the implementation in this
> > driver returns an 'int'.
> >=20
> > Fix this by returning 'netdev_tx_t' in this driver too.
> >=20
> > Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-bG1LVjLBjd3Y/MM/shNy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjZxsACgkQuCajMw5X
L90tww//S79P5V5HEX7illwIe/FJMZzD9ZFWWkm57b+59kkowgeGiVdbPcHXqvvA
Z/998m8pLZJdg+emudTYKcL9RY9PzNnrnjTV5rzfvngqGLkevdAVcAwQI4YfbHHI
Q4+nWz9SuuVbxRGUzHcWtwY0dcPfmzoyy24YjJyLJnPHceqbsBMYQUEG0zw34GOB
rwNNjTffQm1m+/ju8R+72j06w8bB7RhalVdYIs3Wy7ooPAa9DGhHXIhgtuJzjH7r
VhkEj4sSeH6rCl7SnSnRba/UTPSNCavoW8WL7CcRNHgXoD1LflWNRT3AGyeFo2w5
aT2gOlJEgQ/UJusQTGN+fefiMGMRhAPZaDNPHWvWCTWqjQUK3Obso/bAF80IKA4P
PIWkTUHmbNY+spQQNzTSFryqXA3MDmQMa9KH7Zjlp+MqL7VM0B0zz8Pe73ZqjC4i
KW0KmHiUHpnVPB6nwdz5wFE3ar1e8qyN+mr6TFl1j3x6ZfzWXDwe8B6XhLQCOJxE
GnvGeoobZkt1rQ1culFY8+ROsqGOKvHBai3CDQ+9pMklIsTsz7zDM/gbhpi5/9fG
jbOJzK76D/XJkwvfcRI3n1eQh2XgXFmySod5r/lGJPhyo8iCOXnl1p0gEtlP36xV
dGaoEesniOCYmIZB6gjI6sJxpQJCgdGLYHZPvJ9pvi3477ZdT84=
=rtig
-----END PGP SIGNATURE-----

--=-bG1LVjLBjd3Y/MM/shNy--
