From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libqedr: remove fast-path debug prints
Date: Wed, 18 Jan 2017 14:40:17 +0200
Message-ID: <20170118124017.GC32481@mtr-leonro.local>
References: <1484742398-6927-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0ywUhQCikZ2Y3PNw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484742398-6927-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--0ywUhQCikZ2Y3PNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 02:26:38PM +0200, Ram Amrani wrote:
> Remove the invocations of the macro FP_DP_VERBOSE().
> They are not useful as enabling them causes a flood of prints.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 38 --------------------------------------
>  1 file changed, 38 deletions(-)

Thanks, applied.

--0ywUhQCikZ2Y3PNw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/YjEACgkQ5GN7iDZy
WKdnfA/8D7VIhdA/1AubdHqbeCMlJrzSgAakhEQ3Z9NqX9blvNQXAqKFPTbfeeEy
sWGweYf2o5Y43haUQRxaPIky9ebFFK6S7EPQe7lfsbLXPaVZI0XiqvChVahQcgr0
aJ20y0ieO41tIUYd8tUt9hAl4CQV035uu6VnmwCKoSfdE0Y22HxQ8n7QvVStXDEd
Ed5bU68+U4ZjevlBc70sA2IX77fC5lvY/Of7X14TMyuqR+LT3rmb2tpNZ0L0BDdp
51mqf++DoE9SrIXG19/1SDjdBq5baZSELbo6PhCg0nHtqWvtnunEeTSa74rcE8Fw
XldErgW9MjAOuUjo/1M1n5SxGxH/Hlofq5XHrstJ3FRVdIsiJh4bVsxc3mBZFw01
+Lz+44PZ4B4CVZ9h8OOtDPz4njGi4/ciLTVccPQ0pOm24S63dK50v5BkFwutVtgz
oCrkgDMz/SCXTxB/C5CAtHp4nvEWk5rkVyxH1i3O6JdmdVzc68A82M8F5qfcnw5x
qfS0IygqIZquJgCCsFBXP1MHlS6PyBa4FwhA3ZoqT6hqqn5OmoFT+W+5/uREXKfy
Pw+bBlQM3g+b4/rwl25lnUGmivwk1lI5KDi4P0w927fmDw5cWGPgm0eD9qF+lzV/
Q+SJz/IaEi38FrU+IxPzGistrzn3vkAwZ7oYY39I+czqR4B5fRs=
=knz3
-----END PGP SIGNATURE-----

--0ywUhQCikZ2Y3PNw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
