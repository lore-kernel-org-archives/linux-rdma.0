From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Two additional RDMA/rxe fixes
Date: Wed, 17 Jan 2018 10:13:29 -0500
Message-ID: <1516202009.3403.253.camel@redhat.com>
References: <20180112231159.26569-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Rjhmk0YXEQRMMcSkL3O8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112231159.26569-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Rjhmk0YXEQRMMcSkL3O8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-12 at 15:11 -0800, Bart Van Assche wrote:
> Hello Jason,
>=20
> This patch series provides two additional fixes for issues I ran into whi=
le
> testing the RDMA/CM support in the SRP initiator driver. Please consider =
these
> for inclusion in the upstream kernel.
>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (2):
>   RDMA/rxe: Fix a race condition in rxe_requester()
>   RDMA/rxe: Fix rxe_qp_cleanup()
>=20
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  1 -
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 12 ++++++++++--
>  drivers/infiniband/sw/rxe/rxe_req.c   |  9 +--------
>  drivers/infiniband/sw/rxe/rxe_resp.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.h |  3 +++
>  5 files changed, 15 insertions(+), 12 deletions(-)

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Rjhmk0YXEQRMMcSkL3O8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfaBoACgkQuCajMw5X
L90nKA//aHlcEFGyFKRKHmhH6isVq5r9ngmqA2PIjrPxA3er6k10Q8kKxZZgXX+P
hkh9R/bgn5/T+OoVb/vW6m8X6qPE/5omMQHxp12hFT6wd5KOaI051xjMhflKAs2+
a7dCz/mHoMgyLTC9EhHNge+c6jTBa7p0SNXM8BDmFv+/dCY2miSYsSHDaDZwFW+1
sYSJ85oX5NlEmOfmM9lPwVxNGBhE6W6IZUQq+14Rtt41SZPZkcZrUEl1/SDtaeaa
E+JkXflnYcBFeoWaLA0T3r+EuV503tlBW/dq5NceVuxpK24g5ppX2C2S2FTPhAsD
k5ZS06nIBsonfL7D5iYcR7R6OHyyVoJoqDS0yD2phwezmYZqE5296jqeDrm1NUcz
BMB/Coi2Wnlzp5u+kwXf7Mm/o7ovOEixqfjEYZcN78ovA+U/HUfcZpxKQQ5MfQY8
FhzZbUIUU49A0iN+g6cywUxQtcZLKyjpX+OshffAiwlxTxWLSAooDX6BQDI4O0gJ
8Jrn93L0upQxXzY9VvNSLuDP3Yh1E0tw4WXL/WwzDydcmgDVo/CvtuY3yT2nx6dS
iZ7DvoucuQJ9Eo+HCmmocN5kTrUGI/t+kRqIupW8LWwbHWgIlHh2jT2dYaOBA8FM
EyLL5EQuS3SQWU4iQXPxGhrrYqCOhEt9wzg6iJ6msjtwjJxRek0=
=C4rm
-----END PGP SIGNATURE-----

--=-Rjhmk0YXEQRMMcSkL3O8--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
