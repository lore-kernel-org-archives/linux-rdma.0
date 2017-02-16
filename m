From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 16 Feb 2017 09:51:58 -0500
Message-ID: <abceb7f1-ac72-3f48-1903-46d5c868a5b5@redhat.com>
References: <1487080104-28991-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3spAwaFXRPpuxCwGKHIIItcw9lkG7abwX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3spAwaFXRPpuxCwGKHIIItcw9lkG7abwX
Content-Type: multipart/mixed; boundary="U8nj4dKdrSXtC9qwWF8t0jD6GXULvVwCV";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <abceb7f1-ac72-3f48-1903-46d5c868a5b5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/7] Add mlx5 direct verbs
References: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--U8nj4dKdrSXtC9qwWF8t0jD6GXULvVwCV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/14/2017 8:48 AM, Yishai Hadas wrote:
> This patchset from Leon adds direct access to mlx5 devices.
> Sending V2 to handle few notes around packaging and man pages, details =
below.
>=20
> The libibverbs API is an abstract API. It is agnostic to any underlying=

> provider specific implementation. While this abstraction has the advant=
age of
> user applications portability it has a performance penalty. For some
> applications optimizing performance is more important than portability.=

>=20
> The mlx5 direct verbs API introduced in this patchset is intended for s=
uch
> applications. It exposes mlx5 specific low level data path
> (send/receive/completion) operations, allowing the application to bypas=
s the
> libibverbs data path API.
>=20
> The proposed interface consists from one hardware specific header with =
relevant
> inline functions and conversion logic from ibverbs structures to mlx5 r=
elated
> structures.
>=20
> New header is going to be installed in below path location:
> /usr/inlcude/infiniband/mlx5dv.h

This series is entirely self contained and the API is owned solely by
mlx5, so series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--U8nj4dKdrSXtC9qwWF8t0jD6GXULvVwCV--

--3spAwaFXRPpuxCwGKHIIItcw9lkG7abwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYpbyOAAoJELgmozMOVy/doe4P/RsLKAZegQ9Zp7hObN/eofHz
MhBlqDHoj5SzShoATLxcQP3+WK5VcC2rfTM7PwAz0EzoyBk5rGJx4RI2cl+9g85e
KzDDwIjuAwpbmBrCXrPSKLEUudAZrPxgoRC1F/MvrYIsM5HlSx+RYuczadw5NRwu
CDHdCBmosuvNtU8+TCiKXY/NzviuCmTWg9nIsgDQPEqAJlT1Gog184oxYadN5RrS
1FCe+zm/kbnvbKNxgicsca+uvZtvBlUQy7TjviHKftULNstU9cL2G+h0hyjnw82B
dfqG1kd7tmfyR+eGGSgZSRxdtFZu3CFR1a3Kc0HTMjjRYUwP7HC3xRFgnlagd+yf
W/vu4rx/dD6ZqDtUbGGweseKKHztg52lYV7jFqP9JnesU6kIpQG1q0hZYSmhYZj+
Jk6rePnVbU6IPgap8L8xSuiWJxHY/iPeYa6qzzYAhTc6hXdT7KjQ9cJDHW96Xl8A
deNgNrQtIXxqsxJbS3VBuaSfvf8MbFycbz+zPuydOzuxHin2iSzFzzPERbzxe37R
qEhzWxED7x0jW3jRVwCbeoms679i1Y23qUXtuWnPARwULgPD+hdwgB1rX71zPxHQ
HDbZfIUfLsqi1jsl8em3N/q4QqXKOvHoiIg6K/sM6eAugTcBIR3YEpCUbJ6pPzmL
xTDLV8GitV9dbj6RYYO7
=Chr/
-----END PGP SIGNATURE-----

--3spAwaFXRPpuxCwGKHIIItcw9lkG7abwX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
