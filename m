From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Mon, 13 Nov 2017 16:24:55 -0500
Message-ID: <1510608295.3735.41.camel@redhat.com>
References: <20171107163326.23881-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IyJgYag1nNKmjVqSmvpO"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171107163326.23881-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-IyJgYag1nNKmjVqSmvpO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-11-07 at 18:33 +0200, Leon Romanovsky wrote:
> From: Daniel Jurgens <danielj@mellanox.com>
>=20
> When modify QP is called on a shared QP update the security context for
> the real QP. When security is subsequently enforced the shared QP
> handles will be checked as well.
>=20
> Without this change shared QP handles get added to the port/pkey lists,
> which is a bug, because not all shared QP handles will be checked for
> access. Also the shared QP security context wouldn't get removed from
> the port/pkey lists causing access to free memory and list corruption
> when they are destroyed.
>=20
> Cc: stable@vger.kernel.org
> Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-IyJgYag1nNKmjVqSmvpO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKDacACgkQuCajMw5X
L916FRAAn7x0IB3KBvscByVR0PvSkDlR0npkdU5OAOLUX+Lz1YVemwJcDLiBZ53B
tD2zcux2thSkj9wf7waV9YRp/rmONVSGr8OKBERRVmfumQmJFbX6lzWBpesUw2sR
63HG/HDEMoWJplSxeCZsiZRjNKa8vX5mN2ZWI43Bsr8ZwyBx3o/Dn9vMzUsksSAV
zPFg6BPGjf2HiliSB7zf+nzNh9bcKJiDma/EAryouJLSq2IX0TvAzbsmNbQCs9v7
hAROBZxXPqIUaOdMdXxraBhbXW40NUka/eJddgtyctDSxmSZ3dkDVJzhhbG4hqmI
kCAOoayoujfx6VN11e9/YIP2oD2wps4VBvglNptEE/63vDW/ipmT2c8/hH1yyNva
Mmt0v2HYhIufJgCLgsSlv0+l7CTnszrFdZtRveRqnbymPFSF/TMhy8tOB7mYwquq
tm+nlDIOVHrlB01sqOnQvQWFkVsj/ksqB15b+9Q0N/Ao9e2oMBFUmPYp5NYBZCs+
sStp5k0+E26zUL2aPSkdQEBHAhh2so7gAQhyWrtNdkixgrp9UT9QRKbk3/cRm2M3
gsmp/mL5BG7P3nCHOoNmY4JZ6R8ZRs1pdU+sGl+HMiY9Uo6Ja45zE0UqVFkAx/ub
RfFboexmOohRUwlgKF7An6KvxuBOeg7WLcgHup7oz3+RGokqKXY=
=H8Lz
-----END PGP SIGNATURE-----

--=-IyJgYag1nNKmjVqSmvpO--
