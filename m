From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Fri, 21 Sep 2018 20:15:55 -0400
Message-ID: <d95923621d4f181e9443bcf415bd443c735bc89b.camel@redhat.com>
References: <20180917103049.18235-1-leon@kernel.org>
         <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
         <20180921193335.GV3519@mtr-leonro.mtl.com>
         <bbc9bf5b9c4aa99cabc52444a6551afa0e0a6631.camel@redhat.com>
         <20180921214017.GX3519@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-J949sS2CWtgpSXd2H/Vv"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180921214017.GX3519@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-J949sS2CWtgpSXd2H/Vv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2018-09-22 at 00:40 +0300, Leon Romanovsky wrote:
> On Fri, Sep 21, 2018 at 04:05:53PM -0400, Doug Ledford wrote:
> > On Fri, 2018-09-21 at 22:33 +0300, Leon Romanovsky wrote:
> > > Hope it makes it clear now.
> >=20
> > Clear enough.  Between yours and Jason's explanation I think it's well
> > covered.
> >=20
> > > Are you ok with me/Saeed taking first patch to our branch so you will=
 be
> > > able to take the rest?
> >=20
> > Yep.  Let me know a tag when it's ready to merge.
>=20
> Done, it doesn't have tag.
> Commit d773ff41a7c ("net/mlx5: Rename incorrect naming in IFC file")


You confused me for a minute!  There is a copy-paste issue in the above.
The actual commit hash is 5d773ff41a7c.  Thanks, got it.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-J949sS2CWtgpSXd2H/Vv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlulibsACgkQuCajMw5X
L92hcQ/+M9ewA24bSsjGDUw9AMxVmcmWLesgCXEPlMir675JCd9A7N6j9hrsngWX
yUlHoUdHjSUZZ9hSdp1EwfMBNq5fOlEWz1gFHL9dgWkA1F84qwdnDB8mOYjBdieJ
2D98g9P+cB5QiNM1pTrbTYVeAUX+gGcg6FRWdww2jGc5CDifWa4bOHBPPrfUItUn
KrT92OV7/eXpFlJktdcRJouJFtl+QAvqVr9mmO2ZQ7GdUfYibeHf8fbXDoT+SOYA
Ndb/w91skhElzJQDq1ORHxq6r41u2sT1MQ+g+CuPmpq1+eGNmo3la8pHIim1u0vy
OPWpy6pcyK5SnCuxy/g4GborxAT7lkyE2Sqc3fAoT88xeybk609Mi3V0JbNorqbx
C9CU1KwKVoJWpPnAwtLcAmCgzU9NhMTH0B+kH20arr/T5AGBSh4ia5Kw+t/7E3Xy
yxPn5/w4Yrq4u+0NwXhWOxvSHywF9t2oN75r1QgjLKJSr1e26PH2OawxQmwXhM3R
xTB7rKT3PqbUrsb5Htb49kQwsJhJoPoqtAIHeV9en3iXKMlzd6SltG1cbOz/znkS
l/tBg7FPbcitnzlm9796tKOz9vWIZAcreYTsSD5vJg022HD9wnQW1auGoji3jeQ6
W5/VwDunSEFpDIDUIgjzqYimr/Torc2BYrgjMoOD3ETpbfMPMfs=
=R9EK
-----END PGP SIGNATURE-----

--=-J949sS2CWtgpSXd2H/Vv--
