From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 v2] qedr: batch of fixes for 4.10
Date: Tue, 24 Jan 2017 15:50:05 -0500
Message-ID: <1485291005.43764.67.camel@redhat.com>
References: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jLPF+ZNsm5szqxirPjyi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485258703-11949-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-jLPF+ZNsm5szqxirPjyi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 13:51 +0200, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
>=20
> This series contains a batch of fixes for 4.10.
>=20
> Based on origin/k.o/for-4.10, over
> "[PATCH 0/5 v2] qedr: QP and CQ fixes for 4.10",
> on top of 5cc8fab.
>=20
> Changes from v1:
> =C2=A0- exactly the same, except that it is built on top of
> =C2=A0=C2=A0=C2=A0"[PATCH 0/5 v2] qedr: QP and CQ fixes for 4.10"
>=20
> Ram Amrani (5):
> =C2=A0 qedr: mark three functions as static
> =C2=A0 qedr: fix formatting
> =C2=A0 qedr: fix RDMA CM loopback
> =C2=A0 qedr: fix memory leak in PD allocation and simplify it
> =C2=A0 qedr: dispatch port active event from qedr_add
>=20
> =C2=A0drivers/infiniband/hw/qedr/main.c=C2=A0=C2=A0=C2=A0=C2=A0| 23 +++++=
++++++++-------
> =C2=A0drivers/infiniband/hw/qedr/qedr.h=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A05 +++++
> =C2=A0drivers/infiniband/hw/qedr/qedr_cm.c |=C2=A0=C2=A04 ++--
> =C2=A0drivers/infiniband/hw/qedr/verbs.c=C2=A0=C2=A0=C2=A0| 41 ++++++++++=
+++++++++++++---
> ----------
> =C2=A04 files changed, 48 insertions(+), 25 deletions(-)

I took these, but I would like to point out a couple things. =C2=A0First,
the commit messages could use some work. =C2=A0I fixed a number of them up.
=C2=A0Also, a fix to formatting isn't really an -rc fix. =C2=A0I took it, b=
ut
next time let's be more selective on our submission please.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-jLPF+ZNsm5szqxirPjyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh739AAoJELgmozMOVy/dAiIP/RbS8jTF/hzgvFh9Z2s2Fe7s
4VszsTqFNCmYNbbadj1jk1KzbOCP2DORh5OEv40suwmh2XmFlOYCZjZ2p2GTsYM7
HnkuSMeAEDrEeOQAuWkb7Z5H8z8sIq1CWACm6OnmNoV9rTQzPkf5lzJqMWeAR37h
Y1woLTiDP3NwNt/MSPvW/iMWj+Xl3Wqgqr8q5sjxBb6pFW2Cm6aN6O+W83Z9Pe28
5MYOd142uesEbv+bMOMth0tz2zrRwNEMA2cH7N8eT7OQ6gnc+UNomfbH0oy2+rUh
DM8HAqjedmyVc5gd6kgmvb1Ucs2i96jI7R0iUqYuK3AoE0nQkklNZA2o/fxsVNtZ
x0CJRLHt1dyVu4fkgiAPt3l41dxu/5gKBXAvtXwhCVeXVVzLRf47stD2jdAHDka6
qRwwWvPcWAFfLfcEnpnxkOxCfP9ed+DYyVSJfj02teQ6uLMn0wzE1OGG3duAoR8f
2X/sSbhLUz6cZ4Ire8VHt8eYXInlpKCO/A21JnPvBfuAv0uRYuXnYA6j9XOMrND8
iTA1yrQPukR1zXgt5STaXXSl69GvQGgigvdjw69CnbEhScFi89STeCcTNlaqRiN5
G5cYUb+gVkcHe/ev42CAjEtCNx3ZCVXgJuxdWvX7HbjkVTCugUBN7sURgaFeDUm1
dYh/r+xeypksImK3WJCP
=BeIO
-----END PGP SIGNATURE-----

--=-jLPF+ZNsm5szqxirPjyi--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
