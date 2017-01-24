From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Tue, 24 Jan 2017 16:34:34 -0500
Message-ID: <1485293674.43764.86.camel@redhat.com>
References: <1483954699-17826-1-git-send-email-shamir.rabinovitch@oracle.com>
         <20170111085358.GX7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OXmXcZSswO39S8rnPe7H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111085358.GX7218-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-OXmXcZSswO39S8rnPe7H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-11 at 10:53 +0200, Leon Romanovsky wrote:
> On Mon, Jan 09, 2017 at 04:38:19AM -0500, Shamir Rabinovitch wrote:
> >=C2=A0
> > [1383664.318513] mlx4_core 0006:01:00.1: HCA minimum page size:1
> > [1383664.318515] mlx4_core 0006:01:00.1: UAR size:4096 !=3D kernel
> > PAGE_SIZE of
> > 8192
> > [1383664.318517] mlx4_core 0006:01:00.1: Failed to obtain slave
> > caps
> >=20
> > Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >=20
> > ---
>=20
> Doug,
> To be clear, NAK.
> It is custom kernel with out-of-tree patches and very specific FW.

As you wish.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-OXmXcZSswO39S8rnPe7H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8hqAAoJELgmozMOVy/d1BAP/RFzLqLc1yIu0uK6MWZ0BfFk
vFqLIZQMol7FhXHTODQuTkPkqL/bS7Z/GfnsfMrs9UbfL/Xyq7hkWp5f9KxJF22r
hB8pubjmHggV+yJxMY/QwK3PxdcXDO4nq4BPilEOQhZ5NA25TXLY1auOUqyQCHBE
CeQFbrl4Uw56gxoTjawiJRGUB58vNoT1WgAhAa5ztuTR2b37hj8MjDdFIc8coNEf
iKWTFTVme1pJ2sgdgOUobpXWVgvQEX9w7EDsvoHBD1zpnjpo5N4yMLT51rE/ZtU3
M2J8ahZsf1PkqbfGUkblrmn5szPGSy/N7h6QvDtmPFOuWrBrKFKdf0nuWKdj871M
Gv6EFTHhElonb+0DQ6gVEbtYGigkKkBBPPoVtI306OhYYZTErSKf98lioi+hFSs3
5FIM76+SPUdDIGKIuHxfHwd64YTA698CMLhqwoNiO5ZSyqWlZsUCiOK0nesS2dzP
EQuvqM7aMhnaSM4VQK9ZCSAU8cq7/cM9kdrQKyPoWzLHlxoyLH+KyC4bRA12922K
VV1OF/Gftju1NdbISdrc8LmzQ3lntkLLpiyXZ0O4zs340L+Ouumua9TzdbrVeEye
xPR0X0qo+0RR7arS3S6izwEq/OkgEIkga0IYyUpObeNzWpkvHTJWWicxqTX0sNv9
YuJtS1L29xlOCjsXcLdM
=+YYR
-----END PGP SIGNATURE-----

--=-OXmXcZSswO39S8rnPe7H--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
