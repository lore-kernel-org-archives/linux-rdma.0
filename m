From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Thu, 23 Jun 2016 12:18:24 -0400
Message-ID: <c233fabc-7779-db30-b983-13cf61094716@redhat.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D52bSh8CdR502c8oUIef5V70SW0tN7t7o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466084751-29901-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D52bSh8CdR502c8oUIef5V70SW0tN7t7o
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/16/2016 09:45 AM, Moni Shoua wrote:
> Hi Doug
>=20
> Soft RoCE (RXE) - The software RoCE driver

I've pulled v2 into my tree for 4.8.  Please make any remaining fixes
between now and then incremental patches.  Although I've pulled this in,
I want to remove the FMR interface prior to submission to Linus, so
please prioritize getting the driver updated in that regard.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--D52bSh8CdR502c8oUIef5V70SW0tN7t7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAvQAAoJELgmozMOVy/dor0P/1+EXa8B8C8/zd0HBsA/c5Y3
q+2vsxlZAto1QSkAS/mj24GQYAJJZgyuk3H2UvZPPDHi0zPaDmYAkjcnCEdtvsXl
sM6MgyaQcuBJxXeubJmJK/TZOPtJGWUpZ3LXkpD16OFKwKAh/ZbU1q/aHCNrTzqn
+djeH8UGRSr5wJNW2c22T2PtbL35H1U3KCd5fC1qrA5esFiZWXlyKuxYDnuOE0UG
sTop+8t3gx8gUcd1uY+Cl0dazDCk757sX3lxmV9LWgzMmSCQRJnmYw4T4SHn9t4g
QHupxO10sAEyTrXsSRAImagku+BZusKE+0RGatpYM2G6bL9Mi9/mXcGw83PW8IWJ
fGoP/+luEOoCiw/Zlk7s40I7ddolKUP7k3lHelsRD/t+RgCWHWPHL392wPOjBEXH
OjnQUEcZqoON2Egtly2G5NygKXps9lfVz4GXyX9+vf/CvvIM4nVLboD8v2zmc2EQ
MByOITxie8pomF0ZOHCKVvbxGvVRo0aYLTbFXekz5Axa7gfbX7XWYBVcmwZ61tkp
2Vzi6sWAiklFEy5PGKRSLDNn2QRa5/Y51nuZmXHS80ZN2VwQ9SlMLmJ0MUWlNvFj
lQLZ9cUK3nI6I7bu35HHCyvWWIYoPIcTxU6akgFoVjn7QuUuLQoE4zXpc+FXKkFg
oUNNmoeUoSwUIuMOC3Rq
=BoPZ
-----END PGP SIGNATURE-----

--D52bSh8CdR502c8oUIef5V70SW0tN7t7o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
