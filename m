From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] i40iw: Set maj_err and min_err in i40iw_sc_cqp_create
Date: Tue, 24 Jan 2017 16:23:54 -0500
Message-ID: <1485293034.43764.75.camel@redhat.com>
References: <1484761709-6072-1-git-send-email-shiraz.saleem@intel.com>
         <20170118195433.GA17688@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KzEf+S68Z1Smj0dgO6qS"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170118195433.GA17688@yuval-lap>
Sender: kernel-janitors-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>, Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-rdma@vger.kernel.org


--=-KzEf+S68Z1Smj0dgO6qS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 21:54 +0200, Yuval Shaia wrote:
> On Wed, Jan 18, 2017 at 11:48:29AM -0600, Shiraz Saleem wrote:
> >=20
> > Set maj_err and min_err in i40iw_sc_cqp_create so that it
> > returns correct values for all return cases. This also
> > addresses an uninitialized variable warning for maj_err and
> > min_err in i40iw_create_cqp.
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Reported-by: Yuval Shaia <yuval.shaia@oracle.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> > =C2=A0drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 3 +++
> > =C2=A01 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > index 2c4b4d0..47a2529 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > @@ -315,6 +315,9 @@ static enum i40iw_status_code
> > i40iw_sc_cqp_create(struct i40iw_sc_cqp *cqp,
> > =C2=A0	u32 cnt =3D 0, p1, p2, val =3D 0, err_code;
> > =C2=A0	enum i40iw_status_code ret_code;
> > =C2=A0
> > +	*maj_err =3D 0;
> > +	*min_err =3D 0;
> > +
>=20
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

Thanks, applied to -next.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-KzEf+S68Z1Smj0dgO6qS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8XqAAoJELgmozMOVy/dUCoP+gL/yw8qLoy1zjTKcldszHk5
ddmYEZYgYSO+fuGp6/NbuRNhH2epsCCIsqeqopffK+H0x2HuEXaicM8BjS1VDFdJ
ixm/mAvvzsoRlWT8bz8ZlilpVZVeytEY2fBVJKJTnfoU34FmBNFyAgdyz0wsM1C7
7Ce4iy2/ZKakX/lt96slarkof2Cl1brjQj2fSIHblWl/WCMDSu2Jfj9Yz90emMCY
ZC0i6J0ifBideS6ctgaM9k2hqlfK9tkg554mavAGQcrvCwaFS87g4c4D0P7+i+Lr
/MH4wX3iXJKU/iOauYWM0PHeznq56MVZr2HRHA0j1L0vc/M8Kyf5hf3KSMn44oxd
64mK7z5UN+LhCfNITC4PcKt1HwtEmfoVtO9gWkB7UaVi6wyWDz6xNd3BH2REm5PU
bV925wO0YJqBpp8oGCwBi1GoI3kNrL8nNRIsmov0ykmztD3TuurdRCoUWEziChhG
jZBQXSqPXxU8qHtpU6ArsouLu2nsy6a4AOcAfjZpPZje+GN4tyrUHW8sFAXENJER
avGJOfKTp2KBB72WIDfkaZdMaE3gu+zWIZdf1ovr3g2WO4WLtEfUiawh/1UOwebj
z29TGdW86MnN1x6BySTSVDPChKbxBEz1eaGPZp8e5PWA9qkX8t2JRDPrkwGdjDLW
65FrTEOKx8mopy99i5fb
=SaX2
-----END PGP SIGNATURE-----

--=-KzEf+S68Z1Smj0dgO6qS--

