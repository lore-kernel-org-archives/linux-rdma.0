From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] qedr: cumulative fixes for user verbs
Date: Thu, 22 Dec 2016 11:40:59 -0500
Message-ID: <f04910aa-00f1-f64d-8107-a3d669601e2b@redhat.com>
References: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hEr2I2qViq0UVXAfHPiOTmCm2KrLwRU63"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hEr2I2qViq0UVXAfHPiOTmCm2KrLwRU63
Content-Type: multipart/mixed; boundary="eMadjDlJc5J0FiGcMn93LHfbtnvqmA5c6";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <f04910aa-00f1-f64d-8107-a3d669601e2b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] qedr: cumulative fixes for user verbs
References: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--eMadjDlJc5J0FiGcMn93LHfbtnvqmA5c6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 7:40 AM, Ram Amrani wrote:
> This patch series introduces eight fixes for the various verbs.
>=20
> Ram Amrani (8):
>   qedr: configure the number of CQEs on CQ creation
>   qedr: return error if destroy CQ failed
>   qedr: return correct value on modify qp
>   qedr: modify QP state to error when destroying it
>   qedr: ignore inline flag in read verbs
>   qedr: post_send/recv according to QP state
>   qedr: clear the vendor error field in the work completion
>   qedr: Always notify the verb consumer of flushed CQEs
>=20
>  drivers/infiniband/hw/qedr/verbs.c | 35 +++++++++++++++++++++++++-----=
-----
>  1 file changed, 25 insertions(+), 10 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--eMadjDlJc5J0FiGcMn93LHfbtnvqmA5c6--

--hEr2I2qViq0UVXAfHPiOTmCm2KrLwRU63
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXAIbAAoJELgmozMOVy/daZkP/1XOiec12AQzJvrvAVwMucbX
FWhKUPjvwEP6GPHE3Z+yeyMZaS0Ltus16jCAmJLI6cfirIKJolfZXcL1QZFOzrSj
BK+9vD90BLKbJ1qYzCB6T1a7oGUXNIgP9Hm5ghI70WUlMWptnSL5eJAzyihNzEwq
P33b+almOi7AXefoB6dLnZD5BT1CRSnJ3vJzbMcOVTIzZBAv1a0iOWVazSldCPBO
Q+kfDL3EXBBW62AhuhEydrZWWvjB4Ir4tZG01Wmpx/lS1ikBCB0XkOkZcZXc+snN
U5fyaOx7c3iGLETv/AtKXQcPDYh1OQpYdqCc4GyPI4R8Kg36N1B13LmDpO4Vn4rN
A32D1vfUoLFX0yEsUyPGXVFaCA7vfz7OkUuZLUnSCrg1H1aERJdzJYjmnT96QM+/
HvPdW1j+tASkRovwF55GmNFIt50eu1bynWernjsUlyXzlm7b/2T2gLbvjqVPzHCK
ieecKmXWeqcNLWRrLWSc+dN0OIUbj99ku6nGMh0HFpqCippUfW6gwgj9yoph7amn
O/Bz9fz6hrq36htiBLZ+h6ktufibxI+5ummH9xF04opRGlJB/4JWPh/KA9KwoyoI
iuhGfOtT61LOgqHCNw8rxQD0Ab+7WW0GrDyJ+3fF43vO9/PLaRkvHzwg6uxzTTzN
wQUFnxEwB81uDpDjQBje
=srJI
-----END PGP SIGNATURE-----

--hEr2I2qViq0UVXAfHPiOTmCm2KrLwRU63--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
