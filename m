From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 v2] qedr: QP and CQ fixes for 4.10
Date: Tue, 24 Jan 2017 15:48:43 -0500
Message-ID: <1485290923.43764.65.camel@redhat.com>
References: <1485258638-11884-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-h/pS4Or9qcf9hAyRqO2f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485258638-11884-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-h/pS4Or9qcf9hAyRqO2f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 13:50 +0200, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
>=20
> This series contains QP and CQ related fixes for 4.10.
>=20
> Changes from v1:
> =C2=A0- remove obsolete field comp_handler_lock from qedr_cq struct
>=20
> Built against origin/k.o/for-4.10, 5cc8fab.
>=20
> Ram Amrani (5):
> =C2=A0 qedr: return success when changing from QP state X to X
> =C2=A0 qedr: return maximum inline data capability on QP query
> =C2=A0 qedr: remove CQ spinlock from RDMA CM completion=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0handlers
> =C2=A0 qedr: avoid printing error messages for flushed CQEs if QP in erro=
r
> =C2=A0=C2=A0=C2=A0=C2=A0state
> =C2=A0 qedr: fail QP state transition from error to reset if SQ/RQ are no=
t
> =C2=A0=C2=A0=C2=A0=C2=A0empty
>=20
> =C2=A0drivers/infiniband/hw/qedr/qedr.h=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A03 ---
> =C2=A0drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++--------
> =C2=A0drivers/infiniband/hw/qedr/verbs.c=C2=A0=C2=A0=C2=A0| 19 ++++++++++=
++++-----
> =C2=A03 files changed, 16 insertions(+), 16 deletions(-)

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-h/pS4Or9qcf9hAyRqO2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh72rAAoJELgmozMOVy/dNRAP/A/f4fbmgn1+gDfunJPCeXjS
u+2lhRFatwF13mdCD4LpEk4RBTNIUhKlPhy+fO/ijxtmb7Zp7B6C0hZ8SDdwd3ZC
P/+ycmV2vxr2yEIbfQ7us3RIz8sYSiQldq+sB9d6Cpm0VNFj6tC/tEDwH60KbAFn
WEcJk9L8KHZXgTMZiMYkWqs3ntXpBmdmhOU9M5OyarYEOG+tzdQzi3FG/f/UWMWA
CPe+s96h/5TarBz0WXgr5X3ewpD2MnDnIk0lwhgHTmiw5XKnfddZNKMlFnuPf1fI
yNIQ8MC3YrxduoVsqDCBYNVUS4GeAi78iMz+OMZOF+h1u0nrWzrmFaMuJSpv58t0
QAOPCaO/WZ+9kOn9rijm3UyD3jbn6OlH1Bn1jtMrvNFBNDs7qrAivXSbtEZvcPry
uervWofhzZPVTGUJXjTOzP+sGHnq1EnPWo0cBAJRmno0pfSmRodUdRstMAmw1rj0
v2g65uuEi3AcVdtQaKZEmZbdbs+2VbvTzWFo487B0YA852EV6wWvbWeUw87iWEDR
aLsP0i2HFW2h2Bw+JC+iuXma66UL6RkBSvMCE2DzP+ccCwVok7XcGgSpxZ+DiI2j
AfhXWhxfSkNGNC5PpREJmEPhb29CfX0NRxoV0wRafpwT7rR5XkrDTyknjIaAHck2
f219GXQv9p5rpbzC6P7l
=oQXh
-----END PGP SIGNATURE-----

--=-h/pS4Or9qcf9hAyRqO2f--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
