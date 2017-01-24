From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] qedr: add qedr-abi.h to Kbuild
Date: Tue, 24 Jan 2017 15:47:48 -0500
Message-ID: <1485290868.43764.62.camel@redhat.com>
References: <1485252091-9370-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zdeWWbQeFbjl2ZjHE80D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485252091-9370-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-zdeWWbQeFbjl2ZjHE80D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 12:01 +0200, Ram Amrani wrote:
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0include/uapi/rdma/Kbuild | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> index 82bdf56..bb68cb1 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -16,3 +16,4 @@ header-y +=3D nes-abi.h
> =C2=A0header-y +=3D ocrdma-abi.h
> =C2=A0header-y +=3D hns-abi.h
> =C2=A0header-y +=3D vmw_pvrdma-abi.h
> +header-y +=3D qedr-abi.h

So, there is work progressing that should render this obsolete.
=C2=A0However, I suspect that won't land until 4.11, so this is still neede=
d
for 4.10-rc. =C2=A0Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-zdeWWbQeFbjl2ZjHE80D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh710AAoJELgmozMOVy/daGYQAJwQw8QP606RpMeVMbmaIyg3
dI84ffmftN66xJgNNaxc+zghNHU8vA6FbBG/aB93s8HwruWwI3vo1B4IzRGqzefx
gZX4VjdWQOjKxSB9TvLcWS86W5NcZ1iQSWFxFhlbg03REpKw1jALSvV93/arm9fr
1OJs3exnoHBgSLqa59HSuwZy6WrNXTlbFuXwSALtAIXzqPeP3J+OVpk9WJ57hw80
mStidX2rsyjLVx+2HS5k66X3JDDAlx+oxHRgbpmY1idxMx2e9IH/wUc7WsMuzsfN
2xJki9oMOC44QfA7pHrYoq5JIL3bT5LNv1ocJGLGETp1mefCfEBTRMTyURaX4GgI
4VOlZFKtNPc7gFqBnjNith2XWbmWpJPS52ipy/i/wwfcNaPyfFCIIeZxPN+qUfun
c/YqI7RK+BVGLMAfjUhBFhA02maDoAEMaamuvam2go5dCuYrYGFDMAXIqFVoWubl
vTIbyI3p/Mvdc0v89CZDza3MZuCU1PcrWBeNXtMAGPA+HuAuErNWNUiCDQ0idgPe
AzQCzMHxAVquXWP8ixsyQp07SbRxx6kBTXLb7zKRE1Cbyk0FmpVY65U4lGGHJREb
gyFJ0IRCsuEAhL72Uh+iqKODTUiIfo6W2+3vdlFFbG9bljPo5rrbCbl8CMWqzRFo
ftTIZZo9wQFvY7r1sdz8
=yXJL
-----END PGP SIGNATURE-----

--=-zdeWWbQeFbjl2ZjHE80D--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
