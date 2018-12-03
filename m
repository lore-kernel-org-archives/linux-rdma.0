From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc 0/2] Patches for 4.20 rc cycle
Date: Mon, 03 Dec 2018 16:07:29 -0500
Message-ID: <7f6ca96b81ec66cb4cdfb03715389ca3a159c910.camel@redhat.com>
References: <20181128143119.10591.16943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-88jvrdhINb6G8+2/Glhs"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181128143119.10591.16943.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniczyn <mike.marciniszyn@intel.com>, Piotr Stankiewicz <piotr.stankiewicz@intel.com>, Stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-88jvrdhINb6G8+2/Glhs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-11-28 at 06:44 -0800, Dennis Dalessandro wrote:
> Hi Doug and Jason,
>=20
> Here are two patches that would be good to land in the RC. One fixes a bu=
g
> found by KASAN that was marked stable. The other fixes something that was
> introduced in the last release cycle.
>=20
> Both patches are pretty small.

The first patch was more of a performance issue than a true bugfix.  I
took it, but mainly because it was small and the commit message implied
the regression was significant.

> ---
>=20
> Michael J. Ruhl (1):
>       IB/hfi1: Fix a latency issue for small messages
>=20
> Piotr Stankiewicz (1):
>       IB/hfi1: Fix an out-of-bounds access in get_hw_stats
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c  |    3 ++-
>  drivers/infiniband/hw/hfi1/hfi.h   |    2 ++
>  drivers/infiniband/hw/hfi1/qp.c    |    7 +++++++
>  drivers/infiniband/hw/hfi1/verbs.c |    2 +-
>  4 files changed, 12 insertions(+), 2 deletions(-)
>=20
> --
> -Denny

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-88jvrdhINb6G8+2/Glhs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlwFmxEACgkQuCajMw5X
L93llRAAwlp/CHRgLA170rwQKCF52CtZsS7Iat0X9oCHwWGUGN4jfAcMg7z/h2L5
T5S5oZvjL1rS+8xmzmfpmhdGEwPLPsh2zPxzUeydDsRJQ1ILYlNmpRhZiLmYX2i9
irIMuMM/FCGFnt135uNoHGvqNp6e4BfibmQ8o3XRZasbwCYWb1vE3tPaN3dQteki
0rESzNNZnWQcUdi/0Op2VznH9TAcV9PjLs5n1qGJu8CwOkI9ZdQ9LYamBqGw8rl+
UvmRjkAmFwQCcSjhKTDAS5f80ku0zAXPUAQkkgJYidB20rIOX6ZiGHQ41+gtJXhE
WOkqsQ0O3hWOZjW108cg79dZSvHA+804ppnQJ+JAQZY3lt1zuM0qmSz2kn9XtBoR
RVm7U0n+ophLkGnMhRMw25zELRomgfyCRwjgJ8k/RU77pVOZKbb25temC2xdgi+8
TdLD9Ny4d+QMnSTpmrGFlGGqb+7oFNuCPAJAbNiLbvHVLpSl/QmO+THzlXat89s4
1iLoDgkH8hx0NKPHlr632p6+8fLP7qrNYO00KO5er13y3c7OR4N5QG9KoorhfHb2
vjuGE9+Yq3gZFKp2OnDy2/MNkK42ExJuV+fpcxHm1kvaLrkwDywJlOhG/NcrWbIF
Ga3919y0IbIcKnoSIHgs5gvlTfDnwRKAdNoDv4NS3trG06iUtfE=
=brwF
-----END PGP SIGNATURE-----

--=-88jvrdhINb6G8+2/Glhs--
