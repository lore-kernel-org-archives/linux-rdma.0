From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/cxgb3: fix misspelling in header guard
Date: Tue, 24 Jan 2017 12:20:51 -0500
Message-ID: <1485278451.43764.34.camel@redhat.com>
References: <20170122134122.10352-1-nicolas.iooss_linux@m4x.org>
         <20170122135534.GH28570@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LF5Amm+Fmi6EVfCWGj7i"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170122135534.GH28570-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-LF5Amm+Fmi6EVfCWGj7i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-01-22 at 15:55 +0200, Leon Romanovsky wrote:
> On Sun, Jan 22, 2017 at 02:41:22PM +0100, Nicolas Iooss wrote:
> >=20
> > Use CXGB3_... instead of CXBG3_...
> >=20
> > Signed-off-by: Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
> > ---
> > =C2=A0include/uapi/rdma/cxgb3-abi.h | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Thanks,
> Fixes: a85fb3383340 ("IB/cxgb3: Move user vendor structures")
>=20
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, tags updated, patch applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-LF5Amm+Fmi6EVfCWGj7i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh4zzAAoJELgmozMOVy/dt9MQAJjoCS6F9JCRpvmKjObg86jJ
JIhxMXbUeaqDEFUwofZas51783wL5SN2UA1oW0B46WK0YyuTC4+XR4P1x7dH2oE4
dNCMnoSrsUSwPmfs5cE1gJGuA2I7Km5rLoCJk25bf1e1edFAFMoHfSaD5/41dDRY
F2UsV90Yf1hDYYA8mpRlGrzM7oZ43EZZIF/hVqQj247Lx38EYGlAPHBfU0mMu/Fq
4xuAZ5Pp1bsUAkZe6dvetkF1INaphlC3DXVmnEovn6iINkW/Gd7UnKAvOUDCN224
phUm+A4P5xf1uXl7fe0zQJk+27PefxG/AC2W3E3hUkyWwQHVJwQMg/lpi/l/iDRJ
Ng38FGq3ikw1qYcLZRpDrc//GzeXQ6TxN4L0DlNFHQPO1dgWPLfnsbJV5MuMlBoB
bpOaW1PsMNvU7EoZt8aOITMTE69ixIG9EPlqAbNCpJ7QjqEAn8D9FeNAU7BXgO/c
6wIX2ZSqHC3qdxshSu//tt07XYbv6WQ2dlw1o91LUSxNKzfNonhaFKWJ+KcdF4He
FiatQctLuRoZHEOdS/g9Kf90OeFyIGcD46BL+dNG9w9+BCG7eSxtaDeT8fdXBqKP
w++tQ5yO/iMqe3Lkcdb5L45giltxY1KEccPPThYtausyDilHiPNzyEEaU3QvtgqC
tSAllfvzmhAhXRAkI3+k
=rz5I
-----END PGP SIGNATURE-----

--=-LF5Amm+Fmi6EVfCWGj7i--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
