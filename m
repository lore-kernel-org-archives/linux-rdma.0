From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/5] IB/srp: Add RDMA/CM support
Date: Wed, 17 Jan 2018 18:11:24 -0500
Message-ID: <1516230684.3403.290.camel@redhat.com>
References: <20180116183945.30629-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-L+UUZs5fdkXVNqPRoVZ/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180116183945.30629-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-L+UUZs5fdkXVNqPRoVZ/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-16 at 10:39 -0800, Bart Van Assche wrote:
> Hello Jason and Doug,
>=20
> The five patches in this series add RDMA/CM support to the SRP
> initiator. Please consider these patches for kernel v4.16.
>=20
> Thanks,
>=20
> Bart.
>=20
> Changes compared to v3:
> - Moved a kobj_ns_drop() call inside an if-statement to keep the grab and=
 put
>   ns calls balanced.
>=20
> Changes compared to v2:
> - Added a patch that exports kobj_ns_grab_current() and kobj_ns_drop().
> - Made the rdma_create_id() call also use the namespace of the process th=
at
>   triggered SRP login. Added kobj_ns_grab_current() and kobj_ns_drop() ca=
lls
>   to the SRP initiator to ensure that that network namespace exists at le=
ast
>   as long as the SRP channel that is using it.
>=20
> Changes compared to v1:
> - Use the network namespace of the process that writes into the SRP sysfs=
 login
>   attribute in rdma_create_id() and inet_pton_with_scope() calls.
> - Removed an irrelevant part from the RDMA/CM patch description.
>=20
> Bart Van Assche (5):
>   kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
>   IB/srp: Use kstrtoull() instead of simple_strtoull()
>   IB/srp: Make the path record query error message more informative
>   IB/srp: Refactor srp_send_req()
>   IB/srp: Add RDMA/CM support
>=20
>  drivers/infiniband/ulp/srp/ib_srp.c | 762 ++++++++++++++++++++++++++++--=
------
>  drivers/infiniband/ulp/srp/ib_srp.h |  42 +-
>  include/scsi/srp.h                  |  17 +
>  lib/kobject.c                       |   2 +
>  4 files changed, 654 insertions(+), 169 deletions(-)
>=20

The patchset looks pretty good now, but obviously we need an ack from
Greg before patch 1 can be applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-L+UUZs5fdkXVNqPRoVZ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpf2B0ACgkQuCajMw5X
L903AQ//YMUGjoUhuBOWmIFwV7Iz6/jJX0oFROn8sJUuS+UXecMOI5Esw1vWCUEB
7HpDo1yIRpeBccFcG9cjsrDRhc3xvOV3jQdWjRlpiehV+oPnEPcUr44m2B+D9TQV
YFBvSPV/KxSs7u1FeWl/L2spX0xEMoyJQekzy355zN392eYmw8bb3hpY/2PLiKOc
AF9rQU6nUCJbkDIZHcqeGW5kf5ogc793oLXsCabo33/LzqRWdCW27okqx4sx9Cl8
He1N0uQaKj1/UeOtx1lw05zi9b9wp+W4hCYOGoJlDUuHF8zGPw7AkuSR7UJSWN1K
OhWZk3z6tmXL9jos9df2Lhy1MKypXvaDQo5ivOqRYLjl3hD0SOyj94OjDyCbG9tT
mnNLiThAlqIOGXuYeTbLqpuO/dowV/oq/IxtZRxbKAGEIAkGpAuslxZ1fzrS5/Kn
tkPUYvTQJcI7Yu+HEdv+wDM1NKpR50fLNbQiCezzvE1X23nLI1xAmNdX0Aiz8R9g
pMrEnWj2tn8t90Tzk+hK2lxcNKS78AOa9JVz1pOT5oKl7WOxVDQDLfj1I3ArR5bN
2HiopYyquPdWXVMo+PfE52/Wh6ARoWqSVpp0YtPsVHnAEOSKjRAYOtLAjlB1cXeY
jarGQ9oT810l3GAJA2elUxkGg3j8OZV9Z1dERxlJP9UR0QA9av8=
=OJAR
-----END PGP SIGNATURE-----

--=-L+UUZs5fdkXVNqPRoVZ/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
