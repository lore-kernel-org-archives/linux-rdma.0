From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc v2 0/6] IB/hfi1,rdmavt: Fixes for the 4.17 RC
Date: Tue, 01 May 2018 13:18:27 -0400
Message-ID: <1525195107.11756.122.camel@redhat.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hFHTCLgGTLJ/QL4mkxPD"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-hFHTCLgGTLJ/QL4mkxPD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-01 at 05:35 -0700, Dennis Dalessandro wrote:
> Hi Jason and Doug,
>=20
> Here are 6 patches that might make the bar for RC. The first patch fixes
> something that came in pretty recently, I beleive 4.13. The second patch =
is
> trivial, but does modify user visible text.
>=20
> Patch 3 looks large but it's mostly comments. It just moves code. Patch 4=
 is
> also pretty simple. The last two patches fix memory leaks.
>=20
> If you don't think these pass muster for RC please carry over to for-next=
.
>=20
> Changes since V1:
> Correct version tag so it shows up as for-rc in patchworks.=20

Those were all reasonable -rc fixes, so applied to for-rc.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-hFHTCLgGTLJ/QL4mkxPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrooWMACgkQuCajMw5X
L90utRAAtYwjGlMQkbQ6vhfLkv9u1f9JSED61zC0KFLjZm+KvtCPs25cmokdMy8W
Sd8/F8RrB/kNStg4zcUuov54OYqyDVGOA/G2b2VAzWFjXQRObN+9blojVAI9sCXY
aJLc2IkoJycVv3gz4D6oS73vVP2O/b1aiIpj8ZrGmNaVHSOaLLGV6oaIjRGYWCXH
IIio0SITTE/AF6bsPoX033eBaBVr3BmnLnuPZkgJyHZRs/D0faLYsbVAKpMXS4V1
e5KdnR09rmDGJAFAw37yIXcOzE1kWAE3BCEH1Z6n724nJCOA9jK8eQ9Q08Nb0Rpp
9v0/U5j9tD7QxJC4Dwc/8uf7ca+EFRoUgys+/UffqNbEDSIQZyjMV2nKjMJRZjjx
N53sTPmDEvJ3v67MBmdIcQCTKWopecJThNQR66VTum6kFw4zGJgn1KFHFUrzd9A0
0RL+QkquxDSnt7iZRmhiUA/3Yyj9BamlApZxETzFcmvzBnzHpzC4T+BlKL/ew6We
mBRpkZhEUucZSvKWo+stzNt7gmve6FWMY/MrmCCw1oaR5xzpIyAxsn5Ugh081fUX
2/PjwKTGZJl35Bx1zNjHK4QJo0HixNfQIIEeVlB4F6XjyY79TaU5Zqi/f1gSjsPU
v/5wYw01A3RD34tSnBsvtkjuNwKRfaI16FQH74JQUZhiAFoflbs=
=B0qw
-----END PGP SIGNATURE-----

--=-hFHTCLgGTLJ/QL4mkxPD--
