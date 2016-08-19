From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Fri, 19 Aug 2016 18:37:49 +0300
Message-ID: <20160819153748.GB18515@leon.nu>
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2016 at 09:06:20AM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 19 Aug 2016 08:50:23 +0200
>=20
> Reuse existing functionality from memdup_user() instead of keeping
> duplicate source code.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyfMAAoJEORje4g2clin2nsQAL6lUM0JPSY+Of7ZAT24soqI
PgtAqtgeiHQNNRnXqbpjKrcSMnUJ0GgH7l9ovmSlpvdAHqVOp/Wbw7D1fPGlyoFt
/1e+SZ1KXj8L3RU8GeZisBUvk6Na5wWRMCmt5unHP4QPjSDx4/fxnGknTLxt8WH3
zyvpIlbiHYSpZ/MTg1uv9PfsbpQVq+4qLDfccg0tRr97OlVrWJxiQM/z07oubk2Y
xPgg669toTUED+llSBUNrcadNxqgqESG9+xHGhP/iiYP+hmbMT2s/4EaN6XGE+DI
Y11NBwhJJvOolqdlT0rpysXyK46726yaZwXKRz4vi+wODXn7jrID/yWDvFskqPvn
5lAYe8FQU45k5LMec5IoFA9ufRujpM69HdizFAaBlbGc+vkEFko7HkTNuS81iWtx
BshhY9MJsQ1iFI4PeUde9pY5tbPPYMOBjnZmDV4jZnJzcjLyyq+RDKZTZDwQx20v
GY+vIIrllbi8Zt7hiP4ViDdePDMw29rpIOQsw3Ez6jbqxlQIyvrPjtALqHNH5uiS
NelKohAfovXQzFhL3iMacRFIZUoDpz7wAg+nBcv3GxoliA0l9BHTmz+nA7pWI/cT
qSEdQdolwFfpai2/alJDZ3OMq6ljZWd4Ukawra3dDQO2b2/AkLU9POMkTPxMqBv7
1Vvdu3/pzszeqYCIBsIX
=3p/F
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
