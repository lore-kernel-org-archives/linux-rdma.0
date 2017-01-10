From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] iw_cxgb4: refactor sq/rq drain logic
Date: Tue, 10 Jan 2017 14:03:00 -0500
Message-ID: <1484074980.2149.25.camel@redhat.com>
References: <68eb584a0cf57442ca6b2be97f915ab03c9b4293.1482442436.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sBy/RC2KNdYx1c7yp1+K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <68eb584a0cf57442ca6b2be97f915ab03c9b4293.1482442436.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-sBy/RC2KNdYx1c7yp1+K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-12-22 at 07:04 -0800, Steve Wise wrote:
> With the addition of the IB/Core drain API, iw_cxgb4 supported drain
> by watching the CQs when the QP was out of RTS and signalling "drain
> complete" when the last CQE is polled.=C2=A0=C2=A0This, however, doesn't =
fully
> support the drain semantics. Namely, the drain logic is supposed to
> signal
> "drain complete" only when the application has _processed_ the last
> CQE,
> not just removed them from the CQ.=C2=A0=C2=A0Thus a small timing hole ex=
ists
> that
> can cause touch after free type bugs in applications using the drain
> API
> (nvmf, iSER, for example).=C2=A0=C2=A0So iw_cxgb4 needs a better solution=
.
>=20
> The iWARP Verbs spec mandates that "_at some point_ after the QP is
> moved to ERROR", the iWARP driver MUST synchronously fail post_send
> and
> post_recv calls.=C2=A0=C2=A0iw_cxgb4 was currently not allowing any posts=
 once
> the
> QP is in ERROR.=C2=A0=C2=A0This was in part due to the fact that the HW q=
ueues
> for
> the QP in ERROR state are disabled at this point, so there wasn't
> much
> else to do but fail the post operation synchronously.=C2=A0=C2=A0This
> restriction
> is what drove the first drain implementation in iw_cxgb4 that has the
> above mentioned flaw.
>=20
> This patch changes iw_cxgb4 to allow post_send and post_recv WRs
> after
> the QP is moved to ERROR state for kernel mode users, thus still
> adhering
> to the Verbs spec for user mode users, but allowing flush WRs for
> kernel
> users.=C2=A0=C2=A0Since the HW queues are disabled, we just synthesize a =
CQE
> for
> this post, queue it to the SW CQ, and then call the CQ event handler.
> This enables proper drain operations for the various storage
> applications.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Hi Steve,

I've pulled these three patches for 4.10-rc. =C2=A0Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-sBy/RC2KNdYx1c7yp1+K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdS/kAAoJELgmozMOVy/d7mwQALfOzpNoI0TNjtarFE3jBlqu
7pffHUhZbKVqAHb5SfZvDKkZbCTLpIkOgY5BHmgDMna3FeGp3AHB+wy5yGhR11Rr
QpL5FhfOKJoz/znz6Vd168l5oavhd6mvYaKiSDpLJlYxMQ6fwqOFpjcOyKzhLNmP
B3bYki4UxaxEIrvTceYG+4pr/ZFx4e/+wSOdKmaL0bxNYetp6Z87lb8vPTyNwnUC
bObpDJdJ1J1mzOBFeXfXmHQ6wYO/qNmiH1sm8KOwwnxw2bYsx625k5JHshDGLyYB
dsJfsGoVe1EzKVjOaDw1Lqv4lgAXjjP2j9T0ldWoWj7Qxmho8MKVaFt9DuWVVeWs
lU7G1ExIC7OCrcmTDHLCVipFe2qSXWDz0I7hHEEl057Ef/30+8nD+59X7Hze2TC/
tQdWWQBChW20GMm9RMSFpoe2ami7JNmw7ErirAG2E+Z8GNqbPHhigUhgmsAGYaQK
TyGkVb056mymP+NRYSrChl+8vPdqX0h2kwox1vG6td4GgWbf/UxX/v+PEbTtXiRQ
ruMkhFmjjkTqYvLO1APLiZZ834PUI83rMBhvM8Ilk8Vr226zb94j3LTyj4pSYYbM
Hjwv/tiS8G90p/26/zqdzG9h5ZXrnp1u8NfOqGOJdGMKS56E876q0fuxORUUNIZx
cI5xvyd+FXqrbuwvgkmz
=bJr8
-----END PGP SIGNATURE-----

--=-sBy/RC2KNdYx1c7yp1+K--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
