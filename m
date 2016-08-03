From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Allow for non-double word multiple message
 sizes for user SDMA
Date: Tue, 02 Aug 2016 22:49:39 -0400
Message-ID: <1470192579.18081.53.camel@redhat.com>
References: <20160728010842.GC3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YkEOW71ieHweZHQZL5QE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160728010842.GC3158-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-YkEOW71ieHweZHQZL5QE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-07-27 at 21:08 -0400, ira.weiny wrote:
> The driver pads non-double word multiple message sizes but it doesn't
> account for this padding when the packet length is calculated. Also,
> the
> data length is miscalculated for message sizes less than 4 bytes due
> to
> the bit representation in LRH. And there's a check for non-double
> word
> multiple message sizes that prevents these messages from being sent.
> This patch fixes length miscalculations and enables the functionality
> to
> send non-double word multiple message sizes.
>=20
> Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=C2=A0

I agree with you, I like sizeof(u32) as compared to a bare 4. =C2=A0Applied=
.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-YkEOW71ieHweZHQZL5QE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVvDAAoJELgmozMOVy/d12UP/j78z7I5JOJkv0xHWHaXYLjE
r6eClJca56GqTElyRiTJHDg25yGT2XE0xbNnNImiJV1L1+93n/esx/PatqKzCS3f
SQ23frwPRwODyZdImw3/JlA63psiUzPyUI+O6PUGphUrnOGkCAI6ouMljqw+Q9j+
t4Raykmj7OmV2XK1gXGrmu5Z+Y7vVI9YWDoCzYQyMVhPj6ZFSqTVj8biWgJGbBU5
hAtcIhQn41X2Kakwvj9Ay4hORrg/4/tbMZsutC51OuPIiOughle3EKlBjhgoPej+
bAgGm6dohUpMmPwE9Su5zkO30dSmNbX5hjCHEzFjCi3Kd5nsuocp7b3EA8NZuM0x
PTDu0SyncP898KzjSWZ3I8N6JM9nR+F5hu532EVPl5nuBKN7yFbNsfDP2OcDrXGr
Q5gOwgKmbtlJat/BnW2cvVXM/ynEw3aH+zDefw3oZWdXWji7ceYbAeqg12gATbw1
X/W3FynJ0Nwu+hIElbVZX54i5cuieyI2I4NsTWL6xJW/h+09UNYs4zn0Xa0ijtxz
+dbPRoBlx6j3YPykjrx5T0YQGtYHLwHghTgagYi69VbsGKYGRhci5gs81M+b6ool
LegLJKc3MMgAM5X9ivdimiF4dLDnuctlx71s63U9+hiIZoAdV3CPoXuPFOWkb8Hc
vamPPsB8svPxf+j5nYVW
=HGNW
-----END PGP SIGNATURE-----

--=-YkEOW71ieHweZHQZL5QE--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
