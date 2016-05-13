From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 0/3] Misc fixes
Date: Fri, 13 May 2016 16:00:40 -0400
Message-ID: <fd3f59ca-3f81-3520-af2d-ffdd1213f4d0@redhat.com>
References: <1459352360-32663-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5KrtueShP8bSH8cpqQ3d5XqOPbEFO8og4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459352360-32663-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5KrtueShP8bSH8cpqQ3d5XqOPbEFO8og4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/30/2016 11:39 AM, Yishai Hadas wrote:
> Hi Doug,
>=20
> This series handles few issues:
> - Add an example to ibv_create_flow man page.
> - Handle few issues in ibv_xsrq_pingpong example.
>=20
> Thanks,
> Yishai
>=20
>=20
> Noa Osherovich (2):
>   Fix exchange message size in ibv_xsrq_pinpong example
>   Add GID support to ibv_xsrq_pingpong example
>=20
> Yishai Hadas (1):
>   Add an example to ibv_create_flow man page
>=20
>  examples/pingpong.c      | 10 -------
>  examples/pingpong.h      |  1 -
>  examples/xsrq_pingpong.c | 72 ++++++++++++++++++++++++++++++++++++++++=
--------
>  man/ibv_create_flow.3    | 62 ++++++++++++++++++++++++++++++++++++++++=
+
>  4 files changed, 122 insertions(+), 23 deletions(-)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5KrtueShP8bSH8cpqQ3d5XqOPbEFO8og4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjJpAAoJELgmozMOVy/d/KgP/j3TWsXgBEAABfQIG9VQ5Qt+
U1LwJCiLgl8bnIqrD7AYW3pVgNKGlesn6JIOyPgMGQHdZUMg7ocsUZSMUCm42de4
9+l2ujI2VOGsBjfoRbRHzV+yUiO1k6K56QdFAx3LCbSMv6yQe/iQaAvbPawJza/Z
CTpacP6BdrF6bCjHhMsVldgv3MlOQNoLdRrQIj+CXEJ5EObqbPRXQJA9wMiUqE1y
6iT461GjPNMGyUgAvxC6y73YW74EKG0UfbLzb5KNOuRoNsPxmC5pFIROvW3h3NL6
t55cf6xQQb9aS4nQfpLkqnohFcXYyLEvmfoz52rsxve9kesLeD0PVfn8JYtebZfw
exP89o5lsBDgtKiZ4yhH5yxe64aPCiCerfXZ1Olj8n14ZulMi1urXUs7RPBHgMyZ
Xayappdd3XmPCVv+pRzZM5vzCVnUS1wQar9LqFaYlR9oi2DrYoyvz1Q7huCfhhAZ
St7PJtjj0S8/5cTQxVDMapNL4XxCXy1RH3yB+78Xu4wC2lEeJaE2SE0D7sKqG3LS
QmIvJvP97zpkrWrU0rMkcJ8Y8cbFMdJmAPve8j7zD/qOkAzi78YLN/bAikaah26K
6SQXEYle7plPah1E3I1T+mi9JooD5u1dRFDbFkZdranF6hb1XP6DB2o4bB0BWMbQ
a71Pgbm/pfCF4gcaZ+Jb
=Cb7r
-----END PGP SIGNATURE-----

--5KrtueShP8bSH8cpqQ3d5XqOPbEFO8og4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
