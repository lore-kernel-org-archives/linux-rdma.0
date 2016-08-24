From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/mlx5: Remove superfluous include of
 io-mapping.h
Date: Wed, 24 Aug 2016 11:32:02 -0400
Message-ID: <c57a7c2a-af8f-c1bc-af38-24ca5c956e8b@redhat.com>
References: <20160823201626.13926-1-chris@chris-wilson.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O9NT0whpvRfSrJWi57jiik8kuQdeUhJed"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823201626.13926-1-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O9NT0whpvRfSrJWi57jiik8kuQdeUhJed
Content-Type: multipart/mixed; boundary="dptAJ039SDgGA4n0gABIMdLjTk2XwDQRe"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein
 <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <c57a7c2a-af8f-c1bc-af38-24ca5c956e8b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/mlx5: Remove superfluous include of
 io-mapping.h
References: <20160823201626.13926-1-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
In-Reply-To: <20160823201626.13926-1-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>

--dptAJ039SDgGA4n0gABIMdLjTk2XwDQRe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 4:16 PM, Chris Wilson wrote:
> This file does not use any structs or functions defined by io-mapping.h=

> (nor does it directly use iomap, ioremap, iounamp or friends). Remove i=
t
> to simplify verification of changes to io-mapping.h
>=20
> The include existed since its inception in
>=20
> commit e126ba97dba9edeb6fafa3665b5f8497fc9cdf8c
> Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Sun Jul 7 17:25:49 2013 +0300
>=20
>     mlx5: Add driver for Mellanox Connect-IB adapters
>=20
> which looks like a copy across from the Mellanox ethernet driver.
>=20

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--dptAJ039SDgGA4n0gABIMdLjTk2XwDQRe--

--O9NT0whpvRfSrJWi57jiik8kuQdeUhJed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvb3yAAoJELgmozMOVy/d7ZoP/AoOwetGHvUUVSMijpj6vAN1
54nJ0H/vH06/liGVZwhTaiZxTjtdlS4fLX0yV/ZQe+S0CQLtLnxecwDjWER+29OH
FdQsX0FNnX9vbC47NI+1pJaImIKNOuOAL+yjPaZInnf0crIVozOpzFCUrl/O1XkN
p2BVfzwgy8D2wd9c0wDcixI/zGc4cWrtb9WEvj1LukxuqR9A6dvLz5lgP6or3Hid
OT2Xwpy82SzrbcwbvNj+cHt1RFMluId8Jab7ihLYLszSY+s4oAgzVGAgcWB70rum
AazvL6xuFHVj0JQgc35+GbLxd24fU8Bq1UkwCUZ02+uIT5tG5ACuQ9RETWYuxpUc
wkPiQFlrc4kskXQ5XT9deIKY9GtjkVmXooma6MgKhsyrgYZ++ovYCx02n20iQn+X
X+8M9Q2bswcIAW+WMKeANgo4nOactjka5NW5rLeXFJOSWthx4Pc8BMyQ8151CQII
pGPAhLxlgohZRPFDgAxizmnfz2lZRWZ/dDioAe1YPZM17mREVn+9D+uN7NYNkiAv
FZnU4/uWHsmOqWGfrmDAWtwMc819Qyixhz/6zoJu85owG2DEMJyGWWoDp0sGlKPs
TOj4Djihi13l3hJCZX2U7q/CE+EoEQfvfAVkGoz52xfKnur+7xnwOVtd9gxCfeoA
L+B2gxw8XxvC+GLtk7hG
=pBS+
-----END PGP SIGNATURE-----

--O9NT0whpvRfSrJWi57jiik8kuQdeUhJed--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
