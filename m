From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Guard against null cm_id in dump_ep/qp
Date: Tue, 24 Jan 2017 14:45:13 -0500
Message-ID: <1485287113.43764.50.camel@redhat.com>
References: <1484895721-10839-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FRCm6Bbdf74XrdAER0Pg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484895721-10839-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FRCm6Bbdf74XrdAER0Pg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-20 at 12:32 +0530, Ganesh Goudar wrote:
> Endpoints that are aborting can have already dereferenced the
> cm_id and set ep->com.cm_id to NULL.=C2=A0=C2=A0So guard against that in
> dump_ep() and dump_qp().
>=20
> Also create a common function for setting up ip address pointers
> since the same logic is needed in several places.
>=20
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
> v2: Print mapped tcp ports instead of actual tcp ports.

This patch is kinda large for a late -rc cycle, so since this only
effects your dump functions, I've opted to put it into the -next area
instead of -rc area. =C2=A0Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-FRCm6Bbdf74XrdAER0Pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh67JAAoJELgmozMOVy/dVoUP/28VGLt/Ld2A7j49enUMCVwx
qQweLMU9OIl1hjKzPBGz6VpkWwgjYiYbxdNmsh18JxgO2D7f7wM1msLpumDoRTyb
CVrdZVriknma0LNVbNnr53jOuZjCm090KpumzADFSkxzcpWEcp0PAwmIlCUWQKLl
LXi6JfLs60H/kZ+IrnOfU88Rjd3p8lrllkyWNVMLryIi8VjUjFzxC9tBX/fV5A3G
vkuID6xjx0+7qyGLuGMKJMnWz8fH2ZimCT0qBztzbtHjnyGnxKTK9o/ieGOsq9Pc
xw5gEXd4XzPRudtzeM66NcECEMCuW7CeiVhMlJ8dKFuH5Ntg9FXD9EmK/fyluDNT
3CgKygBNrfq2tDNWqn9vZELYhhhfISxgiwzLPO3MnwP6kBLNyDY9mkRWfzdShUIh
dwGVSs70l4Lym4vOi6RyziCjMpeCo22BmQCZO0XY87YBdovMJHXmJAdBcZ1u2FOw
62vEti8Hya4FSXUJQii0AwkP1CdhHRQ15dEYcR8MQ78Mu9BpK3BWetZu7fRsU5E9
LdxIBIWfhuzkAupZ7zgJ8oNGI7/m4lRR1crMqL8UVQkXRIj+82I0eDjRRqin6sQY
PamKoOSG4/w3BCShvxZJ2Fd1FYZ/8etzv68PkpXP2crXKfoBntth21WQbSrYJ/rx
cQsFnu/2MYpZojXs/9AV
=YllX
-----END PGP SIGNATURE-----

--=-FRCm6Bbdf74XrdAER0Pg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
