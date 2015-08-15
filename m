From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix possible incorrect cq completions flushing
 in internal error state
Date: Fri, 14 Aug 2015 21:41:56 -0400
Message-ID: <55CE98E4.2020408@redhat.com>
References: <1439108187-12785-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TbqeM7Apj7Dq1TgvtOlnuIO5KIVSIkK0w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439108187-12785-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TbqeM7Apj7Dq1TgvtOlnuIO5KIVSIkK0w
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/09/2015 04:16 AM, Sagi Grimberg wrote:
> From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When handling a device internal error, the driver is responsible to
> drain the completion queue with flush errors.
>=20
> In case a completion queue was assigned to multiple send queues, the
> driver iterates over the send queues and generates flush errors of
> inflight wqes. The driver must correctly pass the wc array with an
> offset as a result of the previous send queue iteration. Not doing so
> will overwrite previously set completions and return a wrong number
> of polled completions which includes ones which were not correctly set.=

>=20
> Fixes: 35f05dabf95a (IB/mlx4: Reset flow support for IB kernel ULPs)
> Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TbqeM7Apj7Dq1TgvtOlnuIO5KIVSIkK0w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzpjkAAoJELgmozMOVy/drWIP/2HMXr94Sv1Jz8PhtHtiU4Xp
WW26rEy+t5V61jJJHVRm7bqudHF3b00Tde0uolaBUYxLiLGzo/zmZ2aPe3nR+Ab4
Ug9rMW9JvTiBBl1vq1dZLJ0upvliOT3QRSWngdOJHF9hR2nK4s1m+4CcVtIGy/RK
DfYxK7IFvCUArO8D7pXp83sHkfavMSORcpaTV8G9aUxXI6UyBWLg6neIzcTgUToa
oycywknIFrCIR2gZvYZuvv3AkYfs2yvsoJUKI8wp8JGxL9Www3rQ/525agTl81/b
PhtcSIeMUpQlANQtwi8DeRlckx9PMRsqEp0Xq0hajuNUIeoZ5dmATKEfisdXSauh
EmYx4wJGzlzYQTmZgxLyEDkATPtdpre3wP/cTd9hRWBaM7D4SvmEX8W4AMt8Y+Vq
jQXivuHnAsByKN5Amh0dN8xL+k8JQxnVw7c0zLlQkrBk+84F4IrJ5GAgBnJKF/cT
SBeWZ+8RoaFiTW3XvlJJofKsT5yK/ewVsuJFmfeuYdg79ydWAibzdNgIAGNREB3f
2AJRJ7ZCE+q8OxhF54GeQuIwJnlTMaW1JVC16KMOdOXhAJTO3xkgiG95HsEQ5TSt
mjq1yMbFUDyKwNjn9enFZk7C4N7yhLF3Nas53Y6+wMc7ncckTJOAxoDuQYnyfmz0
J0cjLg2JOn16IT1j3aLH
=wNAY
-----END PGP SIGNATURE-----

--TbqeM7Apj7Dq1TgvtOlnuIO5KIVSIkK0w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
