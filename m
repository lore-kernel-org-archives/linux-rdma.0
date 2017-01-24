From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1 v2] IB/srp: fix mr allocation when the device
 supports sg gaps
Date: Tue, 24 Jan 2017 11:04:35 -0500
Message-ID: <1485273875.43764.19.camel@redhat.com>
References: <1482922108-3243-1-git-send-email-maxg@mellanox.com>
         <1482922108-3243-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vpVWdrvQ1GSOK/jpa07g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482922108-3243-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-vpVWdrvQ1GSOK/jpa07g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-12-28 at 12:48 +0200, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> If the device support arbitrary sg list mapping (device cap
> IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
> IB_MR_TYPE_SG_GAPS.
>=20
> Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0[4.7+]
> Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=C2=A0

The v2 version of this patch has been applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-vpVWdrvQ1GSOK/jpa07g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh3sTAAoJELgmozMOVy/dOV4P/jLoCNp+BVw6sLfR6FbmHDjx
RSRw7YCf40TjSPdSWirvLVWUj45cxEbAQ7Nhxe6cMVsfZEqWMCX37+ewoT79M4Cf
rkL3cbYEcUc90Wg2foIXe6K4ILYpdZGS44f3/6ISIsuRyb2C9ZfTLSkLNa6JnIh3
HOBUuPM+RrQBK36iEEYxJmltHrcO+16pwB8hkIJHYgxtz50wYFpHcs3VhZnUC/m5
U3bZHmkN2ysMdkklswDHE03xq87OY6o760z93pJOkcialCyLzyDDJ8hKrDP6zBum
wiL7qmT8iNSIepcTyKz7SkX9i5v49SdE9LsiuDeg4lx0hij+Y4aVl7HhHYteGjCS
Vj6AsYhMQ0jFjvBtBQ25rahW8hdyocA4MrrRDZtFED/2anexJxyClBVCHlS53fnt
IsNlFdGLfgayJXZKmWoXvpZXhh0zlL1fk/RQ0JJ6J6oshlAX21CbOD72OOeld9HM
wQpgb3Aa+gpFy7YTGIUMLBtHNPPnRq/aMp/SyzjyKfbBEAazS5mYqIu1J4STQlW/
/xJSsQrhs/MBnlf6DuDgy0EYBhXMHIs+eXULDkEivtay9Wpmsj6mCxWwLN6R/rW6
JQDdCe1hd9nS+einPI/sC6yE2mLLmI8tyD05rWjdofXd9Us2qxZtlCXGsToDI8B1
GNYRYnGh+BG45IBhhEyH
=6Jyl
-----END PGP SIGNATURE-----

--=-vpVWdrvQ1GSOK/jpa07g--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
