From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Licensing and cleanup issues
Date: Wed, 28 Sep 2016 12:03:54 -0400
Message-ID: <57EBE9EA.3090403@redhat.com>
References: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3dJvSrk4D6wIQUDIwSGBh4XrmXEk5tHc3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475076789-14359-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3dJvSrk4D6wIQUDIwSGBh4XrmXEk5tHc3
Content-Type: multipart/mixed; boundary="ijh9Nqf9VpO0bpSXkMw6OjNuMtaKPCvI1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <57EBE9EA.3090403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Licensing and cleanup issues
References: <1475076789-14359-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1475076789-14359-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ijh9Nqf9VpO0bpSXkMw6OjNuMtaKPCvI1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/16 11:33 AM, Yishai Hadas wrote:
> This series comes to solve some potential licensing issue around list.h=

> and ocrdma_list.h by using the CCAN functionality which has BSD license=
=2E
>=20
> The CCAN required functionality was taken as is with minor touches as o=
f
> flattening the directory structure, its original header
> with the licensing note was preserved.
>=20
> In addition, the series drops some local definitions and use shared cod=
e instead.
> Pull request was sent as well[1]
>=20
> Jason,
> Look at ccan/config.h I just hard coded few required HAVE_XXX which
> expects to be available in Linux/distros environment.
> In case you think that it should be changed to be set dynamically with =
cmake please
> make the relevant changes as you are more familiar by that time with cm=
ake.
>=20
> [1] https://github.com/linux-rdma/rdma-core/pull/5
>=20
> Yishai
>=20
> Yishai Hadas (5):
>   Remove container_of and offset local declarations
>   ccan: Add CCAN min and max functionality
>   ccan: Add list functionality
>   libmlx5: Move to use CCAN list functionality
>   libocrdma: Move to use CCAN list functionality
>=20
>  CMakeLists.txt                    |   1 +
>  buildlib/publish_headers.cmake    |  18 +-
>  ccan/CMakeLists.txt               |  10 +
>  ccan/build_assert.h               |  40 ++
>  ccan/check_type.h                 |  64 +++
>  ccan/config.h                     |   2 +
>  ccan/container_of.h               | 146 +++++++
>  ccan/list.h                       | 842 ++++++++++++++++++++++++++++++=
++++++++
>  ccan/minmax.h                     |  65 +++
>  ccan/str.h                        | 228 +++++++++++
>  ccan/str_debug.h                  |  30 ++
>  ibacm/linux/osd.h                 |   8 +-
>  libibcm/src/cm.c                  |   5 -
>  libibverbs/examples/rc_pingpong.c |   8 +-
>  libmlx5/src/buf.c                 |  11 +-
>  libmlx5/src/list.h                | 331 ---------------
>  libmlx5/src/mlx5.c                |   2 +-
>  libmlx5/src/mlx5.h                |  19 +-
>  libocrdma/src/ocrdma_list.h       | 104 -----
>  libocrdma/src/ocrdma_main.c       |  24 +-
>  libocrdma/src/ocrdma_main.h       |  12 +-
>  libocrdma/src/ocrdma_verbs.c      |  33 +-
>  librdmacm/src/cma.h               |  11 +-
>  23 files changed, 1489 insertions(+), 525 deletions(-)
>  create mode 100644 ccan/CMakeLists.txt
>  create mode 100644 ccan/build_assert.h
>  create mode 100644 ccan/check_type.h
>  create mode 100644 ccan/config.h
>  create mode 100644 ccan/container_of.h
>  create mode 100644 ccan/list.h
>  create mode 100644 ccan/minmax.h
>  create mode 100644 ccan/str.h
>  create mode 100644 ccan/str_debug.h
>  delete mode 100644 libmlx5/src/list.h
>  delete mode 100644 libocrdma/src/ocrdma_list.h
>=20

Series looks good to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--ijh9Nqf9VpO0bpSXkMw6OjNuMtaKPCvI1--

--3dJvSrk4D6wIQUDIwSGBh4XrmXEk5tHc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCgAGBQJX6+nrAAoJELgmozMOVy/djkoP936ruVAzlYEzAH1iYvWEPL3B
wyvdgFSPyMeEntVY3/RXDDd3WaldG3vR/5ZMMJ1NcCC03XfTOkWIMi0K/NX7TBVE
dG5yevUjqtZTJPBJR/neSRjj8MbtQnQs0cle9UUWP5P7OoifM2+rfQPDC3pf4K1c
Q5DE3A6iesTQh/A6+dxBYXA75Ph2KoFxTdYXlOqSOrn49w6neI6zUliYW4HbQqz1
hG9EGzjAIOA3Gq6hrh8iaTKEwP2ztQzRQ8thMbG5um96epoZtG+HoxGpC5KnEASc
KYXp1vp6yIRBA9zY1M6aeCb0S8CaOpZTqXIqrHSTrklcLldszEasYzWn0nyb+IwO
yBWXWiuLwToKdKKyAMKyVmjkbBAKNI3NwfmKB8oKj2QV+hVCKtak3c6O/Gp+GXo9
W9mOP5rSP1Te7vNcSAG5Q/w9BN+uKPc1aLkN3TngFFmWV9Go8XchJIdoWReVtDTj
AhiuF8o6TXQgCwzgj66gtVillkPSTAeH9F+nzqxbe2JlY9KSsJs+STDR6374RAaM
aoG0HRJXv4S4JdsiozLMGr3qAkn3XFvNxAmcKgXu4slovQVWQcbt7oYr0QTT6hb9
FSEjI9GmpvKWkMRYfrR12C/AWbLfjkOPpyg1MOpRi6f5ycr7ZFopmtnzdN2Vj8vN
q/kbZHNv3YR40KUg8Ao=
=ZFUv
-----END PGP SIGNATURE-----

--3dJvSrk4D6wIQUDIwSGBh4XrmXEk5tHc3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
