From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/core: Fix sparse warnings
Date: Sat, 22 Jul 2017 13:42:36 -0400
Message-ID: <ebd643b9-2ded-9ec4-f23a-89630ac2b6ad@redhat.com>
References: <1496932247-119899-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IbtuRKN7vOkKruKNFVmcUcVRx2gKaJbg6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496932247-119899-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IbtuRKN7vOkKruKNFVmcUcVRx2gKaJbg6
Content-Type: multipart/mixed; boundary="cWGV9uL0qIEx3SV3MusCRs7PjUDOfJxpa";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <ebd643b9-2ded-9ec4-f23a-89630ac2b6ad-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/core: Fix sparse warnings
References: <1496932247-119899-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1496932247-119899-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--cWGV9uL0qIEx3SV3MusCRs7PjUDOfJxpa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/8/2017 10:30 AM, Matan Barak wrote:
> Delete unused variables to prevent sparse warnings.
>=20
> Fixes: db1b5ddd5336 ("IB/core: Rename uverbs event file structure")
> Fixes: fd3c7904db6e ("IB/core: Change idr objects to use the new schema=
")

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--cWGV9uL0qIEx3SV3MusCRs7PjUDOfJxpa--

--IbtuRKN7vOkKruKNFVmcUcVRx2gKaJbg6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc46MAAoJELgmozMOVy/d9EIP/jSsqcldzsYYso5dntubXYWp
EBwwBDzGigjyPYYTQRwws6KI0fwF2cneeKnr/Cc4Kfv6ox9bjYSlKA1WJk2LARaJ
v50iGxE/kaAq4octNrTlW3jxn+6m4kn6ubyR7y+TgXmL80cLGxxUUts/S6lpwOot
VbJawohbJg9VZmR28rhEMjNpo1eLIDo+D5tDI2c5eQrFYCO4MYsPj1LJ/E+kiJhH
6brOeErGdc7TZj1uFbWZhJxPb3XuLE/CYalqgb6Jp1SAF3PWVRweJ5cqGi5iomra
1+ZKcm36KKbvVDsTcpwlr8q7N880Nqn1kxZDi7y7l6hmzZ+/E5NT2QEh39Ct2phU
tNsRMZMwFh9Pah3FWTCB8vC49X2T+6YY7CguUPyqR8A2Td57Knr8OIDbBk+Snoig
lP28pydGFN2bk+BOMU76GiE/vlwL4EUTSKJaYv0MbJZ+p/STYJO+TlX3JMGK2yO4
K25hHpzgVwsLY0wzf2ShVquVvanWhFqgNhvQ5Gjm141TgrA/3GndvKyFoblWqXjl
8tl090erIWzFWehsWjYgOF9P3zCnRRj+vPuv5HJlyfSK9qmFEUpdf8an0hIBcXSo
hgeKEMwcdLE6qDLbGJp3xW/Xv2CYwDvgAJWjf0AMXJq/P7/bKQHulEc5DqjBF9L/
073I+nTTWU/ZIHpKMyF8
=iJq6
-----END PGP SIGNATURE-----

--IbtuRKN7vOkKruKNFVmcUcVRx2gKaJbg6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
