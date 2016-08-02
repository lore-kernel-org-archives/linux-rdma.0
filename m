From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] IB/mlx5: Fix port counter ID association to QP
 offset
Date: Tue, 02 Aug 2016 14:43:13 -0400
Message-ID: <1470163393.18081.29.camel@redhat.com>
References: <1468416311-25643-1-git-send-email-leon@kernel.org>
	 <VI1PR05MB1391222EBF9C51484716FC6AD2310@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-U4pdcv2PArigln73+Rsq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB1391222EBF9C51484716FC6AD2310-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-U4pdcv2PArigln73+Rsq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-07-13 at 14:09 +0000, Mark Bloch wrote:
> >=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > Sent: Wednesday, July 13, 2016 4:25 PM
> > To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: [PATCH for-next] IB/mlx5: Fix port counter ID association
> > to QP
> > offset
> >=20
> > From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > The q-counter-id is given in modify-QP command associates
> > the QP with the counter. The offset to which the counter
> > ID was set is incorrect, causing IB port counters not to
> > count on QP.
> >=20
> > Fixes: 0837e86a7a34 ('IB/mlx5: Add per port counters')
> > Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >=C2=A0
> Alex thank for noticing and fixing this.
>=20
> Tested-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-U4pdcv2PArigln73+Rsq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoOnBAAoJELgmozMOVy/dR/kQAKTQ4uayYbEaN/NAlddI427X
rYtb0SOAzOoAyljMrKCeumKscGZLYmby1x5LZiMA6wylV6Q+4CPDy0njnG++9ZQD
OIlDg8wVjBeYYb3yGOrhfZfyd9DU4TkoPfF1WXKq5ZOb7DRMaFaMutsOY4JdHQ+0
lCOeTwKIKY6lBtSstBHodc4OQ1cEkBdeASsgaPgEqIzHUQmwM4XqeN5715qffY86
1dh/eEM/59s9fDQoZeXYvNEtDFT0Gy2U18liWGASP8DcTRBbQQ9/JCgiU1TD1FZQ
3mHuxUKk04u9VlTjSNOSlxq0CTReCj/KAJ1ZHtK7qBXoBp3UvdM87mtCUhwtfVLS
N8aQMSnq4v1mcHEcITgRnls0nzvV+7mXlGpNVrIcStTyUySPV37IYJEVWS1Xrfzc
hpL7tHxDszy5qj933Bs+fv4YS/1jRQHZbQkv3OrGlc6akPNS6izwhUR/moXEYpV5
2vMMA69JPkuzoQ0kKGYoxnT37+gF0zze/fP0hHKBX0C2tz6WfrfiyApUC+3r2C1F
hdolC8QsLr2t1nd9CScUL0lmA6pGA8qL1mlWYyAH3QbflnUE11hYKNRsFsCA0Fle
hj5rsV3SPrhC9QyY/1k+ScJHopcycJj8FVeXxcrdkKFAbd8YofZgC+16PaIQle00
Xh+JzQWciKrFBPzEbosY
=I01l
-----END PGP SIGNATURE-----

--=-U4pdcv2PArigln73+Rsq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
