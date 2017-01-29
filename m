From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/11] Broadcom User Space RoCE Driver
Date: Sat, 28 Jan 2017 21:24:19 -0500
Message-ID: <1485656659.2432.33.camel@redhat.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-c2vnEq86Q0q2LifxtmCp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485641622-30015-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-c2vnEq86Q0q2LifxtmCp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2017-01-28 at 17:13 -0500, Devesh Sharma wrote:
> This series introduces the user space RoCE driver for the Broadcom
> NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
> is dependent on the bnxt_re driver posted earlier to linux-rdma
> community and is under reveiw.
>=20
> This patch series is based on the latest master of rdma-core
> repository hosted at https://github.com/linux-rdma/rdma-core.git
>=20
> The GIT for this library is hosted at following URL on github
> https://github.com/dsharma283/bnxtre-rdma-core.git
> branch: bnxtre-v0
>=20
> Please review and give your feedback.

Not a complete review, just noting that you did the same thing about
not being consistent with your name. =C2=A0It should be libbnxt_re to match
the kernel module name.

> Devesh Sharma (11):
> =C2=A0 libbnxtre: introduce bnxtre user space RDMA provider
> =C2=A0 libbnxtre: Add support for user memory regions
> =C2=A0 libbnxtre: Add support for CQ and QP management
> =C2=A0 libbnxtre: Add support for posting and polling
> =C2=A0 libbnxtre: Allow apps to poll for flushed completions
> =C2=A0 libbnxtre: convert cpu to le all over the place
> =C2=A0 libbnxtre: Enable UD control path and wqe posting
> =C2=A0 libbnxtre: Enable polling for UD completions
> =C2=A0 libbnxtre: Add support for atomic operations
> =C2=A0 libbnxtre: Add support for SRQ in user lib
> =C2=A0 libbnxtre: Add versioning support
>=20
> =C2=A0CMakeLists.txt=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A0=C2=A01 +
> =C2=A0MAINTAINERS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A0=C2=A0=C2=A05 +
> =C2=A0providers/bnxtre/CMakeLists.txt |=C2=A0=C2=A0=C2=A0=C2=A06 +
> =C2=A0providers/bnxtre/abi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A0418 ++++++++++
> =C2=A0providers/bnxtre/bnxtre.driver=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A0=
1 +
> =C2=A0providers/bnxtre/db.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0110 +++
> =C2=A0providers/bnxtre/list.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0135 ++++
> =C2=A0providers/bnxtre/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0220 ++++++
> =C2=A0providers/bnxtre/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0358 +++++++++
> =C2=A0providers/bnxtre/memory.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A077 ++
> =C2=A0providers/bnxtre/memory.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0160 ++++
> =C2=A0providers/bnxtre/verbs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0| 1597
> +++++++++++++++++++++++++++++++++++++++
> =C2=A0providers/bnxtre/verbs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0106 +++
> =C2=A0providers/bnxtre/version.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A0=C2=A053 ++
> =C2=A014 files changed, 3247 insertions(+)
> =C2=A0create mode 100644 providers/bnxtre/CMakeLists.txt
> =C2=A0create mode 100644 providers/bnxtre/abi.h
> =C2=A0create mode 100644 providers/bnxtre/bnxtre.driver
> =C2=A0create mode 100644 providers/bnxtre/db.c
> =C2=A0create mode 100644 providers/bnxtre/list.h
> =C2=A0create mode 100644 providers/bnxtre/main.c
> =C2=A0create mode 100644 providers/bnxtre/main.h
> =C2=A0create mode 100644 providers/bnxtre/memory.c
> =C2=A0create mode 100644 providers/bnxtre/memory.h
> =C2=A0create mode 100644 providers/bnxtre/verbs.c
> =C2=A0create mode 100644 providers/bnxtre/verbs.h
> =C2=A0create mode 100644 providers/bnxtre/version.h
>=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-c2vnEq86Q0q2LifxtmCp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYjVJTAAoJELgmozMOVy/dyL4P/i6Eh5yFXJkw1iwSd9iTFcki
JRVeCnnQ9btdHjzJqcQ2Uwg1dd89J+D6Iv2QYM3GNJPVP9SbmyNPxn99FJdH0man
XwwI0MU2dUu2YaWfXLyS/gWGLS3uTvN72EYojLDmJ6iDzlFK9JmNxe7LCZNyKQZI
+JCOn0xG3IXBB2A+2MmSxf6icwbI5zBwjFHp/Q2M+1B5LXI9+J4e4d6Rme7Aq3tc
gkeNY/pMjWqPMvvFRMsXtBxK2bsrHPdWpStevPLisL4Fu6UqQrI3NJ1VYVm8v50h
6hKvqbUbWlYiQCVz0omXVz64mlmWw2sKi7QKAk5m/B6ytb3gyd2RgUQN3S1zIMr/
QrxnSNu0AbzB7892h3A3JEtfv4BC2JbD3L9fJsif4TtrWOjWBfFklAjIJJ8R/ijV
nv3+GWDmwDHCZDGVwmbLmKETjhAhEtIqDbQbzjSqjq8XxS49WtNM5GBz2Q6oYObF
Ii/XwJ7zVeqfEjZIQIzzYZgMEDepiMd2nqfe4LT76pYdZHaHFH6Rw8kyi4tcYSgx
JNIrNIJsowSX2hpRIBbyX/zUoCVGt7QjdlGeT+KodrR1d54nNa/kK9zYnz6Tk+tE
825sSY1dMojA57pXx84ECVhE0tDuAc3abqcFuUkMO+akzPD8x6VEPdlFIWF4qfrD
RTU2Z7/BT1ikoecTGnzL
=5W2U
-----END PGP SIGNATURE-----

--=-c2vnEq86Q0q2LifxtmCp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
