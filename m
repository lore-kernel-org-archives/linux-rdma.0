From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libqedr: fix inline data copy
Date: Mon, 30 Oct 2017 15:26:23 +0200
Message-ID: <20171030132623.GZ16127@mtr-leonro.local>
References: <1509368395-16738-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F1UMmCLUB5xxGl5w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509368395-16738-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--F1UMmCLUB5xxGl5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 02:59:55PM +0200, Ram Amrani wrote:
> Advance target pointer during data copy.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks, applied.

--F1UMmCLUB5xxGl5w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln3KH4ACgkQ5GN7iDZy
WKfCFg/5AeJuA2m8jYTPjR754wanmyRIpsZYOUr7NKfJYrqc8ujg5DI7z4W1rfQK
XClaMSMKa1/idUR3fyIW018XpLQEasUJMyaRqaar2u8/w14woBR5L6bQ7RZpNZcS
T1EB7rjuMcvfTCwKbj1q0rV5p6e+dMx+g1pdYVnm9KbNOEB+dsw+0zQpQKcrs2FL
LAa1r4/AF+Pu3OuV7/gbvvZf+35la8k+7VZe7U2FrdzHJ1lYt4gZexJM2t0uLYSH
gNA4UY/W7rrKhiqe4IllLBV08NIdKytvGkL2/EgxVcyg6dYRFP7R6VJa0BhKRsJ3
Oc9GdF+6O5pWMVybL8RXaZ7aLiD6wxiiUttzeQIHkFudA9ZytJlOTYbKGlhv4MwH
c7cBzDEPY9ZTImeoka/oOzOLrXV+ZS9bWC1UYwqUb60vHC4wanDCnA5QJlDsIKUx
nyxJrgsr3U8s63rl3eH649MlaH456NjScEiT1pdqUmjM/oVb4GItnmkBX7sDex4R
oJyfTocwsq8AoW33zGgMcgpbKYoArIvJMcHuPyDQpH6bz5Ob8QN+C/0dOhpWH8y5
vi2oQdV33nFBoi1hYvXQn53juBtMGpM55WZluPE0xt+DBcCO73B6UXH90Pkla0pg
+39EjVAJf7Tho6c+KC5KNpDG1nNUnubzgMTB3Jc6QwDRXkHzzvk=
=r6PM
-----END PGP SIGNATURE-----

--F1UMmCLUB5xxGl5w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
