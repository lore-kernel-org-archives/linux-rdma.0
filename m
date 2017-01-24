From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/isert: fix spelling mistake: "teminating" ->
 "terminating"
Date: Tue, 24 Jan 2017 16:41:09 -0500
Message-ID: <1485294069.43764.93.camel@redhat.com>
References: <20161230143805.13549-1-colin.king@canonical.com>
         <20170105131554.GE15685@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HA3m7TT6pEnrymfi8Sky"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170105131554.GE15685@mtr-leonro.local>
Sender: target-devel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Colin King <colin.king@canonical.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-HA3m7TT6pEnrymfi8Sky
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-05 at 15:15 +0200, Leon Romanovsky wrote:
> On Fri, Dec 30, 2016 at 02:38:05PM +0000, Colin King wrote:
> >=20
> > From: Colin Ian King <colin.king@canonical.com>
> >=20
> > Trivial fix to spelling mistake in isert_warn message
> >=20
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> > =C2=A0drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Applied to -next area, thanks.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-HA3m7TT6pEnrymfi8Sky
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8n1AAoJELgmozMOVy/d5EcP/2mHTHcEw2VGoG86Efll0I/Z
IaGq4b5tqgA8SJr4jPGfbvgUTxKyIRZmaC6PuN/xYqUaR33iHsOXJ1PoAkvkyS2k
pEtgHA9bHr0wq8zTm6kLxcT2XS4ecmzYKkuNW4l336Uvabuifv9fBFOEnLcAV+8E
ET8TX/Uem/CjWDtzI7xJBmwI2KhBwfxjZXX09vgZosqSnF6QHziI8PryttDfufts
MdHlDBREyktmHQ2oofJJFLrKTVWrGPKdIm1eEVoSHyO5LRS8/wiOMW0B+qmdF3g/
nSbg5/TvwyE8AvQOJ3nTCk/sT+02/dB+czK8m/GoktLFyCaQPvtSUhpJIFe6rozY
gmDhg/Nn6+3fKgiPJINV9tJqd82dIzfbgB/sv1c2em9JNwnASEq05jWy5P+FKBcd
c5hzc66hdOoYClY4alnjB9DARhCCzsAANtt1NqBOiM85gujBib827efAhnPOXHQp
Ux8LFCcTnykpqPTPQBlFwdUB4X0r5TJMZYylzmQZj16+uqVwpu3g2kMghFEQ/zA0
NgnbGgcIGuza2yObfS67Biqqo62SApz86qcrSl3CZFZBDOBSbCNj4N6aVPnNi752
WQ0senEyPKtfuyrlg15wc1ixvedVADLuZSx+yz5RWUDA1jUTPbr1Jol+hDs6HXNr
z/cR0jk49CJViRY6DBZx
=6CR7
-----END PGP SIGNATURE-----

--=-HA3m7TT6pEnrymfi8Sky--
