From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/5] Licensing and cleanup issues
Date: Thu, 29 Sep 2016 11:19:30 -0400
Message-ID: <57ED3102.7020809@redhat.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="nSXCrOD7vVGsohgWt2fRUfTKi7Ax971AP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nSXCrOD7vVGsohgWt2fRUfTKi7Ax971AP
Content-Type: multipart/mixed; boundary="G5EV9xqSJflFin0mTsvw53TNqrwLGgELS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <57ED3102.7020809-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/5] Licensing and cleanup issues
References: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--G5EV9xqSJflFin0mTsvw53TNqrwLGgELS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/29/16 7:10 AM, Yishai Hadas wrote:
> Sending V1 to introduce few notes got from Jason, details below.
>=20
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
> Pull request was sent [1]
>=20
> [1] https://github.com/linux-rdma/rdma-core/pull/5
>=20
> Changes from V0:
> Patch #2: Move to use min_t/max_t and fix typing issues among the proje=
ct.
>           Add involved license files to ccan.
> 	  Sort list of files in ccan/CMakeLists.txt.
> 	  Use buildlib/config.h.in for ccan HAVE_XXX.

It looks to me as you successfully addressed Jason's comments, so I've
merged this patch set.  Future changes will need to be incremental
patches.  Thanks!


> Patch #3: Add ccan/str.c and update relevant cmake files.
>           Sort list of files in ccan/CMakeLists.txt.=20
>=20
> Yishai Hadas (5):
>   Remove container_of and offset local declarations
>   ccan: Add CCAN min and max functionality
>   ccan: Add list functionality
>   libmlx5: Move to use CCAN list functionality
>   libocrdma: Move to use CCAN list functionality
>=20
>  CMakeLists.txt                       |   1 +
>  buildlib/config.h.in                 |  10 +
>  buildlib/publish_headers.cmake       |  18 +-
>  buildlib/rdma_functions.cmake        |   8 +
>  ccan/BSD-MIT                         |  17 +
>  ccan/CC0                             |  97 ++++
>  ccan/CMakeLists.txt                  |  16 +
>  ccan/build_assert.h                  |  40 ++
>  ccan/check_type.h                    |  64 +++
>  ccan/container_of.h                  | 146 ++++++
>  ccan/list.h                          | 842 +++++++++++++++++++++++++++=
++++++++
>  ccan/minmax.h                        |  65 +++
>  ccan/str.c                           |  13 +
>  ccan/str.h                           | 228 ++++++++++
>  ccan/str_debug.h                     |  30 ++
>  ibacm/CMakeLists.txt                 |   6 +-
>  ibacm/linux/osd.h                    |   8 +-
>  ibacm/prov/acmp/src/acmp.c           |   2 +-
>  iwpmd/src/CMakeLists.txt             |   2 +-
>  libibcm/examples/CMakeLists.txt      |   2 +-
>  libibcm/src/cm.c                     |   5 -
>  libibumad/tests/CMakeLists.txt       |   4 +-
>  libibverbs/examples/CMakeLists.txt   |  16 +-
>  libibverbs/examples/rc_pingpong.c    |  12 +-
>  libmlx5/src/buf.c                    |  11 +-
>  libmlx5/src/list.h                   | 331 --------------
>  libmlx5/src/mlx5.c                   |   2 +-
>  libmlx5/src/mlx5.h                   |  19 +-
>  libmlx5/src/qp.c                     |   4 +-
>  libmlx5/src/srq.c                    |   2 +-
>  libmlx5/src/verbs.c                  |  21 +-
>  libocrdma/src/ocrdma_list.h          | 104 -----
>  libocrdma/src/ocrdma_main.c          |  24 +-
>  libocrdma/src/ocrdma_main.h          |  12 +-
>  libocrdma/src/ocrdma_verbs.c         |  33 +-
>  librdmacm/examples/CMakeLists.txt    |  26 +-
>  librdmacm/src/cma.h                  |  11 +-
>  librdmacm/src/rsocket.c              |  13 +-
>  srp_daemon/srp_daemon/CMakeLists.txt |   2 +-
>  39 files changed, 1692 insertions(+), 575 deletions(-)
>  create mode 100644 ccan/BSD-MIT
>  create mode 100644 ccan/CC0
>  create mode 100644 ccan/CMakeLists.txt
>  create mode 100644 ccan/build_assert.h
>  create mode 100644 ccan/check_type.h
>  create mode 100644 ccan/container_of.h
>  create mode 100644 ccan/list.h
>  create mode 100644 ccan/minmax.h
>  create mode 100644 ccan/str.c
>  create mode 100644 ccan/str.h
>  create mode 100644 ccan/str_debug.h
>  delete mode 100644 libmlx5/src/list.h
>  delete mode 100644 libocrdma/src/ocrdma_list.h
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--G5EV9xqSJflFin0mTsvw53TNqrwLGgELS--

--nSXCrOD7vVGsohgWt2fRUfTKi7Ax971AP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7TEDAAoJELgmozMOVy/dLw0QALOXghcD5B0mk8flo6jlEI+T
klL4jAMqBhcIu8Vdkms92wVUYkquuE3klcH5L7e0qoIwcxIwfcrpZhGWDUoVGq7G
6k1pAfWouWYbH9cE2opTfolldHcJljypS/GIqa4mjTYrR2jUEHN+Z0h61s0tLlw/
wPelqo5pD5ArTFZDvoSwXGBsVUjsYKEjzmeIkVVXsWVORYtjd+yFU7FDPvZIx6hY
SLxkGavVCLcUbSg4VRK7VvB+VrTH7SNMQN0sdu/e+fmioH1NnWAbYYfbL6rCJisF
YkPC7qxuWUAKt0vasM4erkeTrg7xYZQDLOTq1m6i+usK7qIlydR6P73cGao5Aqid
ZtlzM/zzLbjr+pdDG33TGPt16k/uqvOWzuHTA4QnuqFtJENN8vfUcYKi93vye5zK
z9qZwQt3CzsC6joLsZyyTFaYKcz/2lcBykUuJZ6q1aor09qEQikTeAK3seWQoaIJ
uYyCN8Hm7OP8UTJxjed2zqW3KaoL5ULZ/fnAouPlE4+4TsOxaBfu7ENMuzFthBWl
0pslSEXsX6TFejZUabxgF+WIscVl3300fG6ktjYaz5ZxHov4zw4kcxlc5U+yAcEz
rGWnx+buqmh0c87UfVSveiE0hvr+2eU82AwGLtPCJnMgiL/6wCMOmHHtR2HnwhH/
RLQNPWGB6y/pP43nTlTs
=Zyll
-----END PGP SIGNATURE-----

--nSXCrOD7vVGsohgWt2fRUfTKi7Ax971AP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
