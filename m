From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx4: Take source GID by index from HW GID
 table
Date: Tue, 14 Feb 2017 13:41:20 -0500
Message-ID: <1487097680.86943.84.camel@redhat.com>
References: <20170214052453.16488-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yweVWMm7dVzOH6d2Mc9e"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214052453.16488-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-yweVWMm7dVzOH6d2Mc9e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 07:24 +0200, Leon Romanovsky wrote:
> From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Previously, we used the HW GID index in order to search the source
> GID
> in the software GID cached table. In some cases, for example when
> the MAC Address of the network interface is changed, the GID cached
> table
> saves the old-IPv6-link-local GID at the end of the table.
>=20
> When returning the old MAC address, the software GID cached table
> tries
> to add the new IPv6-link-local GID, and when it identifies that the
> GID
> already exists, the software GID cached does not add it. Thus a
> mismatch
> occurs between the HW and the SW GID tables.
>=20
> It resulted with sending traffic with the wrong source GID.
>=20
> This commit fixes the issue by taking both from the HW table.
>=20
> The problem can be reproduced with the following scenario:
> Client:
> =C2=A0=C2=A0=C2=A0 # ifconfig ens6 2.2.2.5
> =C2=A0=C2=A0=C2=A0 # ifconfig ens6 inet6 add 2001:0db8:0:f101::5/64
> =C2=A0=C2=A0=C2=A0 # ifconfig ens6 hw ether f4:52:14:61:a0:71
> =C2=A0=C2=A0=C2=A0 # ifconfig ens6 inet6 del 2001:0db8:0:f101::5/64
> =C2=A0=C2=A0=C2=A0 # ifconfig ens6 inet6 add 2001:0db8:0:f101::5/64
> =C2=A0=C2=A0=C2=A0 # ucmatose -f ipv6 -b 2001:0db8:0:f101::5 -s 2001:0db8=
:0:f101::6
> -p 20156
> Server:
> =C2=A0=C2=A0=C2=A0 # ucmatose -f ipv6 -b 2001:0db8:0:f101::6 -p 20156
>=20
> Fixes: 4c3eb3ca1396 ('IB/mlx4: Add VLAN support for IBoE')
> Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-yweVWMm7dVzOH6d2Mc9e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYo09QAAoJELgmozMOVy/dYpMP/iUnp9yvNCBveiABDU87Dy7o
f7WSo9cajvh6OuhLRRbFiuG5tF3Y+rmKjb5q6XEtJLzY8lqlXpFteIkogfPjYuMM
pFVWm3iFYIDXm6FEuhq2D1z8ER+a6WKq9/IW4GmnzEqVpNy9ys3Ny38hERKwqD4+
uefLmMaNiT9jidgXilaa0373YqoaTVqTMRvZoXlZ8p+v9G2VkOaqlHk7OCkuOv2E
ey2yPKQfg0PZDPPX4Gj+65nC651dcTG+z7KDuqHgIHSODYe/KTQFfEdeCpP/mk3E
SCX/ziBWGbmrdu75oxmLLqkr5TTbfYr5QrMJ8NYwfoVM94cQQgopKfk++wmCmPtU
8HWrLKUVSx/9Yf0RvLcWLr5fZ9AQNB53+guBUoFer8R3ixh3J7UP9m8N3pMTOuQC
oYo9OsjPflFhdxedxpZphVmSLyIt//NuC/EF9kg3+O9rEp2mdTGcB7FgeWX1qTWo
eEJn5O/6sNSdVI40THrJYNsDf/LRHNrEcCEagyzKPHBGDC3q2Ag+llwxUdYQzEW7
uS75SfpLzRjiAOx7OhSWhQBshmlrEmaVbp6mbjPQL7RVa1to1gFiAg3YSNPBXaYA
HNNARkqKf2so48H2cD70v5WMkisFmc8gD5bDF/ypSoII449Og+1dkHFMKABbtqW3
nGJzi3wX5JLaO6J/AyFG
=5oHq
-----END PGP SIGNATURE-----

--=-yweVWMm7dVzOH6d2Mc9e--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
