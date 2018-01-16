From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Fwd: [PULL REQUEST] Please pull rdma.git]
Date: Tue, 16 Jan 2018 17:04:17 -0500
Message-ID: <1516140257.3403.232.camel@redhat.com>
References: <1516140157.3403.230.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4tbHQjaPR/s8ulLJ6WOw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gunthorpe, Jason" <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-4tbHQjaPR/s8ulLJ6WOw
Content-Type: multipart/mixed; boundary="=-gnSdTDEEjrNGrl9VhPov"


--=-gnSdTDEEjrNGrl9VhPov
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Forgot to Cc: people on this pull request to Linus...as soon as I hit
send I saw my mistake, sorry about that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-gnSdTDEEjrNGrl9VhPov
Content-Disposition: inline
Content-Description: Forwarded message =?UTF-8?Q?=E2=80=94?= [PULL REQUEST]
 Please pull rdma.git
Content-Type: message/rfc822

Message-ID: <1516140157.3403.230.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Date: Tue, 16 Jan 2018 17:02:37 -0500
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zFCBCfUAlCPACW80RDqW"
X-Mailer: Evolution 3.26.3 (3.26.3-1.fc27)
Mime-Version: 1.0


--=-zFCBCfUAlCPACW80RDqW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

We had a few more items creep up over the last week.  Given we are in
-rc8, these are obviously limited to bugs that have a big downside and
for which we are certain of the fix.

The first is a straight up oops bug that all you have to do is read the
code to see it's a guaranteed 100% oops bug.

The second is a use-after-free issue.  We get away lucky if the queue we
are shutting down is empty, but if it isn't, we can end up oopsing.  We
really need to drain the queue before destroying it.

The final one is an issue with bad user input causing us to access our
port array out of bounds.  While fixing the array out of bounds issue,
it was noticed that the original code did the same thing twice (the call
to rdma_ah_set_port_num()), so its removal is not balanced by a readd
elsewhere, it was already where it needed to be in addition to where it
didn't need to be.

Anyway, here's the boilerplate:

The following changes since commit a1ffa4670cb97ae3a4b3e8535d88be5f643f7c3b=
:

  IB/srpt: Fix ACL lookup during login (2018-01-03 20:07:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linu=
s

for you to fetch changes up to ae59c3f0b6cfd472fed96e50548a799b8971d876:

  RDMA/mlx5: Fix out-of-bound access while querying AH (2018-01-15 14:19:55=
 -0700)

----------------------------------------------------------------
Fifth pull request for 4.15-rc

- Oops fix in hfi1 driver
- Use-after-free issue in iser-target
- Use of user supplied array index without proper checking

----------------------------------------------------------------
Dan Carpenter (1):
      IB/hfi1: Prevent a NULL dereference

Leon Romanovsky (1):
      RDMA/mlx5: Fix out-of-bound access while querying AH

Sagi Grimberg (1):
      iser-target: Fix possible use-after-free in connection establishment =
error

 drivers/infiniband/hw/hfi1/file_ops.c   | 4 ++--
 drivers/infiniband/hw/mlx5/qp.c         | 7 +++----
 drivers/infiniband/ulp/isert/ib_isert.c | 1 +
 3 files changed, 6 insertions(+), 6 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-zFCBCfUAlCPACW80RDqW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpedn0ACgkQuCajMw5X
L92GKQ/7BYvvLD/NfrU8sERlE0/I4Oz8bBY0Y9/SS6Sx2997XItTWh77sW2NXwb4
asB/C6feW9iAw1QIVV9tDO41AIzUipe7ZlBgOBWACC8PMLEOTb3NN59H38zv9hSa
LcexZJEtyiHjwHztCC8taxXdc17Cf8nUsOyHNrh/wMOuBdQ8FhFA9DbixLb8JS4j
Cl6S/dR+OzXYXIiJo5eacoDuSdFBcFVCVpZzoJ/5NSIBhDONRa8TV59/HrmmXwpJ
Di1oG4AHEon+kuZGAtmJHEyar6u4/cb51eEgtmbpRJYPx9HmCXFiOSYQkNzbcw2+
69G5Qsz6sE/q+dJZ5Pn7p44Riy+j87XPaQfn7QLAPyMSGhjVOEfnWsbEWx1kPZiZ
aVVz9yoBizu7v9/A3q8xAkLdExIim10GEtXBBS9Z8d2fv8lSV+hX8qX0mDQ054qj
mrU62bPYB8KPd3MxkALJAVamEWNPhp/LrFkI0LRmOEZw4mO2kH7l4hvcZK93WB2S
iKeRKt+a1ed9EzMGkrpuAU/5f3Cvd0EszdC6PVhC4hNjuI91VzWa4QyHzK3h/xzM
GeIH8G5+EeBaDq/kMjWVqMLKVq8RNYmvswOlZqDJooI86Or3Am332Z6t9oETxJtS
mu2cANmCG3ghcEPD5NnjJIUp2XJh5Cp4uDECCIWkY7mBBSd0UqA=
=Hq5h
-----END PGP SIGNATURE-----

--=-zFCBCfUAlCPACW80RDqW--

--=-gnSdTDEEjrNGrl9VhPov--

--=-4tbHQjaPR/s8ulLJ6WOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpeduEACgkQuCajMw5X
L9142hAAoLBilXTt0H92T7NftVmeewNCcrCDSIspgWnqSIBN0KDMvwdEkA5Z16Da
p7AKpkHvY2lOpEGf3G+5ABTIxp5zMN/cZ4SAh/K1xdBAbj5mBC8M7qhWbpq0/jbs
KNOnTKghfZUqZZRtGXCRfgcCO9H0DcbvziD6FB6UiUyLNuMeHXWsuG8TKqYd9q8F
uS+H2CA69PNhQPiUlVbYCIfBmz22Bt2mhS1dtSSAjG9IvyZo2WNAeyMC3XSo5mqQ
ZceWx0fY/vu0zJaRwPIyE/Qr/bVF5swbvF3ROOB0UUvwzSqRdtQWnKzDXa4KENTN
gww+lNMoK3pv+HX5+ANFGK6Liyoddi0r8MAtoljuvG3VNv9xmSZWyipnkfFWWPj7
1dP3+6pvxCp1EJh1RIL2BC+mi7qP7Um1SMsindEX3URARNFx3dnBut1wgE8o3Nfj
YZeds3cpN8GEG3yS++T1gDjU9E6lLlTFOAysVZ7HJIUitiyD3Fw/WclnVs7u8cc2
ZQuCSLItoTaZpWloEQLpE1UspFo6E05VTtkC1BTsGPv+RwpE2x/s4VX0gX9edJRQ
jAs3LJvpntOXSW+lYtUf64PkecsRu09IqNTK66GXvye8EmeUY6mmn70b1ZWNjuX7
x2Yvd5rxEh2fdbE+ilUZK9ewzCc7RbSjuGdof6kUcZ8Vc984QWM=
=ZckR
-----END PGP SIGNATURE-----

--=-4tbHQjaPR/s8ulLJ6WOw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
