From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Fix kernel panic from skb
 destructor
Date: Sat, 22 Jul 2017 13:14:26 -0400
Message-ID: <a99bd03b-ea1d-983f-f76a-4798baa55fd4@redhat.com>
References: <20170622141000.9899-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="esLuSpbT3GgWLfXPVCaKOMkDUpXCkS6sP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622141000.9899-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--esLuSpbT3GgWLfXPVCaKOMkDUpXCkS6sP
Content-Type: multipart/mixed; boundary="T2OisbGl1Mu8ItCXdrfHCCejAWNorcjpn";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <a99bd03b-ea1d-983f-f76a-4798baa55fd4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Fix kernel panic from skb
 destructor
References: <20170622141000.9899-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170622141000.9899-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--T2OisbGl1Mu8ItCXdrfHCCejAWNorcjpn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/22/2017 10:09 AM, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> In the time between rxe_send has finished and skb destructor
> called, the QP's ref count might be 0, leading to a possible
> QP destruction. This will lead to a kernel panic when the destructor
> dereferences the QP.
>=20
> The operation of incrementing QP ref count at rxe_send and decrementing=

> from skb destructor will prevent this crash.

This series has been applied to 4.13-rc, thanks.

FWIW Leon, if you have a series, even if it's a short 2 patch series, I
prefer a cover letter.  It doesn't need to be long, and can just be
something like "I have two bug fixes for rxe in this series", but I
dislike responding to a patch and saying I applied a series.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--T2OisbGl1Mu8ItCXdrfHCCejAWNorcjpn--

--esLuSpbT3GgWLfXPVCaKOMkDUpXCkS6sP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4fzAAoJELgmozMOVy/dOSoQAIemWzcauDyucnFlEgyATwIM
WKaQshkJSNYUNL52QjyNVompRPZT8OLptSEBDoAnbyd6+fxlHi1qa0yueasjJ0tr
/dHIJq9Mg1HKPzcLpStSf4dnyaFb6TBAiylf9vXqpRidg9o/mKaPG3SRX3LQZ0Sv
rupPwU41bTtyVafG1TarN+jGv9MzlfOH3aM7PdcC6x9xTQqx5cPU9hyLkZoHN4qC
hmEfZY2ve9xbkuhUTYsULpQ4Bt91JJIMZpqY6dasBMm40Juw4XUWrOZzIEO98Dpu
kMJvSfOB0JaniVjCEEvqMO/0haX2tjUuSPJqkw36lW6glYaprIesZkFzu+Cf8xOg
XzNIqvSMMse/qbZlPT62OYunzM8uxAAGeTg0akgLZgnGK0So22Cz2JN7LnkHslR5
fZlDZLibn4ntpwtpH1W6Be2BNdkd8z1RXZCAk7TuVE3tOr886hwU+usHq8LepYNK
WYsVZyVRPcrhaEGymSQ4iT76/WRI7IKHWlssFE8it0ZwOQt8484rTJ6yzNjOHJ1b
auNzlGr25M/uFkQCFi0k8e4BIsvOLJer53HGQT+nd8lOiP4uIh6iKORoSChJJuu/
jhsMHxWI6ms+9Kjowj6dWDJUBC9UDBLNp23BSI+phAVQw85eOlASgQeK7MjB91Nk
LIho6KUaDiSw4PVuSnwZ
=BcEn
-----END PGP SIGNATURE-----

--esLuSpbT3GgWLfXPVCaKOMkDUpXCkS6sP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
