From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] libqedr: sparse
Date: Tue, 4 Jul 2017 14:04:52 +0300
Message-ID: <20170704110452.GI1528@mtr-leonro.local>
References: <1499164554-28552-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499164554-28552-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 04, 2017 at 01:35:52PM +0300, Ram Amrani wrote:
> Ram Amrani (2):
>   libqedr: fix sparse warnings
>   libqedr: enable sparse
>
>  CMakeLists.txt              |   2 +-
>  providers/qedr/qelr.h       |   6 +-
>  providers/qedr/qelr_verbs.c | 174 +++++++++++++++++++++++++-------------------
>  3 files changed, 103 insertions(+), 79 deletions(-)
>

Thanks, applied.

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllbdlQACgkQ5GN7iDZy
WKeEXw//bSEqLENbEA7/INaB5UrgQdLgqIDhkpk+tl4T+srh986RIkyG8LpQuSKm
UTVg9gBKlVr2PDwg7/MJogh0Bj615VGL/DlXozf+Pqx/fayyv2yFpI4YQRnZXjOR
Q8MgmwsuBFdgSeWIgjfnDDj+4KveLKXvesmytOKmtJTbz/rZ39DHxenn6Qddbrdr
65/jUfsks/K1wJRdIWE4su4jTnO/nXLKU1UYkYiREJndMjJaV4IO83J1al7OLnS2
GFI9ICMj3Hts20FelBKQ2zALpvVI/xPbZ6hPevUc5ytBjtpxk3Rqt3iVuPaML5Y5
Zb3BFXSNgTvfSkDItSr9zXg/Bvpa5Ueyh67iJrRQ3r3eYGda5SenezhzNsQz7z0p
44g2C8HylXnuVgA5f3phidX34WFfDhFkMq1ti00pdaI8O0el9AnrKeYKno+xqJCV
GF0/kTvrKNbQOrFVXCYOZwC+tBgUY2DuAwe2ySwNqrnVoAsqfCyn8hzbLgFTT+2L
a1/UCIPtZAHA3Rp/A5bMUYIVUFlLy9x+oF87pj8CytBiaPgiEavgdNusl3kLU7AJ
+k7/V/FilxMqN6Fxuas3BBs31h2oZ/k4wJ5JnOK9eorevzahQumcP4BWW0/x/vBV
RpeBdK3bRaknkjJy2hPIsR6XuL5a7dyn/hikAs3suCYg8DwD68Q=
=bMBN
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
