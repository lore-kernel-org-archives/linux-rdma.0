From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer section for hfi1
Date: Thu, 3 Sep 2015 13:40:56 -0400
Message-ID: <55E88628.6060909@redhat.com>
References: <20150818140609.3571.87830.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lCgfjtwKfGHtEAHPUMRh2xKRqWsXCeqIT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818140609.3571.87830.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lCgfjtwKfGHtEAHPUMRh2xKRqWsXCeqIT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/18/2015 10:06 AM, Mike Marciniszyn wrote:
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This was squashed into the rest of the hfi1 driver patchset.

> ---
>  0 files changed
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b3c1a56..45953e9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9892,6 +9892,13 @@ M:	Arnaud Patard <arnaud.patard-dQbF7i+pzddAfugRpC6u6w@public.gmane.org>
>  S:	Odd Fixes
>  F:	drivers/staging/xgifb/
> =20
> +HFI1 DRIVER
> +M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +L:	devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
> +S:	Supported
> +F:	drivers/staging/hfi1
> +
>  STARFIRE/DURALAN NETWORK DRIVER
>  M:	Ion Badulescu <ionut-Rv4seVrz/scdnm+yROfE0A@public.gmane.org>
>  S:	Odd Fixes
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lCgfjtwKfGHtEAHPUMRh2xKRqWsXCeqIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6IYoAAoJELgmozMOVy/dmo8P/3Ga3/JLxgmF/HftVtKGxqBp
ybtpHyaEFCbiVOs8WFT5zImtzqqz0DIhD2aeXpcSRU4/FgNVJI/jgSgA/EH3f/N5
pV88UqfSElPp7A/8B7a5lszK1/WvuJnUviqZSnZvg2/uAuGamKYGu33jF3/QX4V/
590+oVhdeH8JgfSZtqA4kFdg559re1fr6Z+O1g15+8uY3lMDHz3KvZa9Tij/FZUE
2tjs19TCq/RN6XkkW9nX4brcijnzGYhH1Suf2OqcczHStNxxfelEOXwaArNgbn6i
VDLl2E4v12AgO1UrhHYERlRIgQvOJFuXLpNbIgZ6twJQAjyAZYEOMQvlU3eWq0Ff
IcROO3OnxqaxdDbA4ynkwZ4Cu2QZKbuvgXa7C00g5kTIBO4dUJjpad6uq643mQUs
8V0ejeSbSa5l6iGi6oeqA6mCU6IQTUD/vwEwJ/J0j1SMqh5CwNdYuz/LJ0+hd4jt
QO0UX1aPtvLva6jNOpYROU6ZwfTLEgRjiukyTdQPSWZDnFKCWfKqNMXMVZseQTt8
PkDyc6V+S7zXE6S/MYUPvQR+veN99eDllVhLJBfprVD7Jixtp3MxN17X+JQvCmV0
Zu4z/cBxcU9HRPIM7a0j4Q3U4Ls+uFgZz5Vrcz/jZA3RPtqaBmhdupywc7pLfFSN
tfxq/gyRDT+ft4DLC697
=PQJE
-----END PGP SIGNATURE-----

--lCgfjtwKfGHtEAHPUMRh2xKRqWsXCeqIT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
