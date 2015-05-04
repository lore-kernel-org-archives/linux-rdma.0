From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 0/6] IB/uverbs: check request parameters
Date: Mon, 04 May 2015 13:45:19 -0400
Message-ID: <1430761519.2407.87.camel@redhat.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wKTX2EZPyy+dbkzvlqxQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-wKTX2EZPyy+dbkzvlqxQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 15:00 +0200, Yann Droneaud wrote:
> Hi,
>=20
> Please find a patchset against uverbs to improve the checks done
> on uverbs request parameters. This patchset in an extract of a
> previous patchset sent some times ago[1].

I reviewed those patches last time they came around.  In general, I'm on
board with the idea of cleaning up option checking, but in your original
patch submission you point out that the patches have a non-0 chance of
breaking user applications that pass in parameters that wouldn't pass
these checks but work anyway.  Have you done any looking into that
possibility?

> I've provided some explanation of the issues partialy addressed
> by this patchset in a previous message[2].
>=20
> As we're now addressing overflows, I think it's time to apply
> this patchset.
>=20
> Changes since v0 [3]
> - updated against v4.1-rc2
> - incorporated patches to add check on response buffer using
>   access_ok()
>=20
> [1] "[PATCH 00/22] infiniband: improve userspace input check"
>=20
> http://marc.info/?i=3Dcover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>=20
> [2] "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for v3.1=
3"
>=20
> http://marc.info/?i=3D1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
> http://mid.gmane.org/1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
>=20
> [3] "[PATCH 0/4] IB/uverbs: check request parameters"
>=20
> http://marc.info/?i=3Dcover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> http://mid.gmane.org/cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>=20
> Yann Droneaud (6):
>   IB/uverbs: check userspace input buffer size
>   IB/uverbs: check userspace output buffer size
>   IB/uverbs: check userspace output buffer size in ib_uverbs_poll_cq()
>   IB/uverbs: subtract command header from input size
>   IB/uverbs: move cast from u64 to void __user pointer to its own
>     variable
>   IB/uverbs: check access to userspace response buffer
>=20
>  drivers/infiniband/core/uverbs_cmd.c         | 449 +++++++++++++++++++++=
------
>  drivers/infiniband/core/uverbs_main.c        |  29 +-
>  drivers/infiniband/hw/mlx5/cq.c              |   6 +-
>  drivers/infiniband/hw/mlx5/main.c            |   2 +-
>  drivers/infiniband/hw/mlx5/srq.c             |   6 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c |   2 +-
>  6 files changed, 382 insertions(+), 112 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-wKTX2EZPyy+dbkzvlqxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR7AvAAoJELgmozMOVy/dwSQP/AhwccL09R383tz7KcQFG1lD
xLjst02xQHsa2VCbwN8YDvXTmOgNHQVftxIU0sP5F3nYYDbFsZiZDq8A1doRPJrp
G2ngr46BRjcT1DyUZtC7EmE8pGckEz4yXRqKxyodx4lPSaaoe+BAuAH7P9DLw/G/
m+aRm/gKEDs4Y0/P2sey+cki6SKSWEP1WQ/kqrOEiZ3BT0BDX4vrhE0H3dy0ePr7
21UoCXc6hA794BKK8UVLujpoSwGf/NbcsCeCvYOVz5Esq81Waf3FimAP3PgpCtVp
cTTuRuyDMBa3t/rBkWjTXLaV+7RhvSoavUdGJi9DbJ9Ge6q3uYeTxI8g9E9UPspC
HZ6Llp49VZ0qqoB8B6p4t6jci4HHK67dGBtQ62gMBzZEWZWXNfbqm0xPaDtwCo9P
cwGG5TgNzCMvUYNlcOeadBO+NE5jVBMkYdvWYtvYNwbb5OMEIdpnnQ6MEpRNKj5W
pVLr1tmg5EmYxY091kfNyLittQpb49jgARWcWayEcKuQn93WF9NmzWapwQs8NMoj
g5NzP+pP7Puq3C4oQPFS4wj+SDLoGb+mLkhM36r3RuWF9W9OxeYFD5m9qk/cYWOA
5odwoiv0PfdMxl6OelDEIuxrZJtqxhQ5sAnzMmUtplAo9XUbJs2KtYm9evOUeij3
js8AGMSHUYQlFRmBiL5H
=apPu
-----END PGP SIGNATURE-----

--=-wKTX2EZPyy+dbkzvlqxQ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
