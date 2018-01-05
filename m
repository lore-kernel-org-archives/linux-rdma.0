From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 0/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 12:22:00 -0500
Message-ID: <1515172920.3403.12.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BfrXW/dBb2ZvB4pVAeJs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104222842.26756-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-BfrXW/dBb2ZvB4pVAeJs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-04 at 14:28 -0800, Bart Van Assche wrote:
> Hello Jason,
>=20
> The four patches in this series add RDMA/CM support to the SRP
> initiator. Please consider these patches for kernel v4.16.
>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (4):
>   IB/srp: Use kstrtoull() instead of simple_strtoull()
>   IB/srp: Make the path record query error message more informative
>   IB/srp: Refactor srp_send_req()
>   IB/srp: Add RDMA/CM support
>=20
>  drivers/infiniband/ulp/srp/ib_srp.c | 744 ++++++++++++++++++++++++++++--=
------
>  drivers/infiniband/ulp/srp/ib_srp.h |  41 +-
>  include/scsi/srp.h                  |  17 +
>  3 files changed, 636 insertions(+), 166 deletions(-)
>=20

The first three patches are fine, the fourth presents problems.  Would
you prefer I take the first three while you think about the fourth, or
do you want to keep the series intact?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-BfrXW/dBb2ZvB4pVAeJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPtDgACgkQuCajMw5X
L91gHg//amwBD2HFMRWa3o6qitZcqO9yxaeBn3wPV3Te2getSg1ErfLM27K/2cKv
zwAH5aVOrl03n+AAUgQJh4QFOcRhSE9ZIRseiEaQodZA+trbo/qeGMU6JNjiIFrJ
5cWIaakwJ4chvtM9oKjYZ3D6/S9IHgKG0W7K9o9Ji7Z9jys5SHN/SeEoKBZss7jY
l5m0T0jvCkaYwRAjX9soCNLK/ZJAPfsKTyxAbwHPrHJOGL9MatUlnut57ZQkqu8D
zXZYkq1+wOhDx63eIKguxNC+8tYvouek4OraJ6EhUu/3jLZQ0Cy4bowjYxChupBf
ylIGjp/Q6KkwuzZRp2UX5cqEifN1IAWz5ttc/mG4VVulzvnBcTw9oMo9zpIJnpM9
oDYFLBoBiONYMD730wYQiU0oUIQkno9hM1m9RUCj6uscgTfNSqSzs7eB1f3wHr+R
56DHw77+NTm/1pkJHCAEiqvp2m4sDShOhzLmhg/vCtiZR+bHJgruy1hAru2XyBPO
edQ36wVzFFsPvUcf6uQjAMn00cHg0rgd4d2V+K23qAOAWbaq85FJzx/6+ybjjBYg
BrrbCCkdK0pRiw0iURmscMCeAcpwl0wlwBFOj6vuD5+6nvUTJvMkYylHXyRE+0OV
d+OqJzfuu56yMCuFArThg4q3lWuOMn3GzjZKIulKqHVTHpL10ZE=
=EfJu
-----END PGP SIGNATURE-----

--=-BfrXW/dBb2ZvB4pVAeJs--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
