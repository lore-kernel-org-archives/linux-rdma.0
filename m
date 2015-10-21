From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] RDMA/ocrdma: bug fixes
Date: Wed, 21 Oct 2015 17:29:18 -0400
Message-ID: <562803AE.3010806@redhat.com>
References: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u0tQAxER1GsFL6OJ7NCMhXND4NSXxst40"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445330880-3912-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u0tQAxER1GsFL6OJ7NCMhXND4NSXxst40
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 04:47 AM, Selvin Xavier wrote:
> This patch series includs fix in CQ door bell logic, check to prevent
> driver crash and code cleanup.
> Please apply.
>=20
> Devesh Sharma (1):
>   RDMA/ocrdma: Prevent CQ-Doorbell floods
>=20
> Naga Irrinki (1):
>   RDMA/ocrdma: Check resource ids received in Async CQE
>=20
> Selvin Xavier (3):
>   RDMA/ocrdma: Cleanup unused device list and rcu variables
>   RDMA/ocrdma: Avoid a possible crash in ocrdma_rem_port_stats
>   RDMA/ocrdma: Bump up ocrdma version number to 11.0.0.0
>=20
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |  3 +--
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 30 +++++++++++++++++++++=
++++----
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 16 ++-------------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 11 +++--------
>  5 files changed, 33 insertions(+), 29 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--u0tQAxER1GsFL6OJ7NCMhXND4NSXxst40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKAOuAAoJELgmozMOVy/dDGMP/i/LcvIW0pXtomjU8vMX5FXd
BfbTV4+4SucvzaabFXFoeSSOedpFiounv+JTlTttjxrUnVFFzt44Sbfh3w36WvHY
AVp9i9L9hpDa5WDltTgxNxZme3r6QJksr8F6q07CvviXPp4/64dpsw7fxG024mia
cE9nqexESY5Uww32IBEi9FBVY33TVnkTJsLACqZ59eaH6rkXeZRbf9f1BVZbjvAE
0yCkev7VkBY6TJktcoclwr53EmxapvNPw2OET4/uzOkB5f6MjmEHLunsCfuUdxgB
GD9i2qCn9QTQ/aDK2trFYILQe1tro4s9ojYWBLcvGfn0HedpIRXaJ7Zqo3CEAAM1
Eyf3yeM64ZjpjlQfy7kI/lK+UR5bs8aUKOvGpm04S8FSji3LRd5RHvjd/dfX+i5q
OzQnLO5rg24iVixeU8kz5KEl1MIdmxiwi19NX+N523EgXQW5mScvOhRCn4qjk4GT
w3EdY+K6j6i27k2vLqMYo2LMZnwNxqHxkWiGp+ZAbVnKCSz1QD6RVRp8j2yYKUaD
ThwjYabs4mvU30CYcDupyjc+uC4aZzvY/Y2WKfOBfR+1A4nij3ALEP1IA5GaqqA3
uTGGmtRD/gxVPHM2cSAA2x88Eq0Z3axuZ2GiQqEqqihWO/X9gJCFHzBRruvyNj+Q
cWn3gDSDGk8ykWFmQSdi
=h8Nz
-----END PGP SIGNATURE-----

--u0tQAxER1GsFL6OJ7NCMhXND4NSXxst40--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
