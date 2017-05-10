From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: fix array termination by appending NULL to attr
 array
Date: Wed, 10 May 2017 19:18:52 +0300
Message-ID: <20170510161852.GF1839@mtr-leonro.local>
References: <1494431652-67941-1-git-send-email-robers97@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494431652-67941-1-git-send-email-robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5Mfx4RzfBqgnTE/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 10:54:12AM -0500, Steven L. Roberts wrote:
> From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> This fixes a kernel panic when loading the hfi driver as a dynamic module.
>
> Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Thanks a lot,
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkTPWsACgkQ5GN7iDZy
WKeldQ//RkJkD4CWAuRjIG8I2caFS+OMOK7bMfDrto9BstP/9lD0O4JPBTVfb2qZ
dEGXq4dXP7jY8II5KySNDvzA4VIodCGbcCUple8b3BirMoaq/BHz9XWvWGa66c/N
q1hcxIfS3qIcdluR6Ye/d+ZgNK9cY0ry93jRHqSCg4PAAlPIaAfQJB2d922KwTTj
9+r3E5eCpUDYRW9gE3XQl645E/Q+Ta8EwlVhOyJLf4v1Vub5CegCSGfnB1AaqByw
uM6rB7G/Wj5SP8oq6DX9hWrIMdXRO+n4UPkF6oLZooLF7dQEK5RtBeK5we8NfK1j
eYNB+lXzKgYN6BxABMGjHXX0bzELyRZC2h3DzYm55rnmdhIiKmJV6kYiHRrcOXOp
9DsI+NElws0aDHJAx9OriGynqjRoSM9qyu5tu3F0IhYFGnXGMyqcKEWldbXYnBsO
PkIgkmviIyM/MPusvv8Sgf901vON7s0pbFMoHEppNTxwhrgkA2hbAtjIyt4E/6qX
qrY32tDGZIzsPOEEnYl25wFyudQWDT0BL5R5ToYJTn8Rw9X8vpo+A1kreFtW47On
PfC2imwVvpYySqIo1rjSF/9++IIPo3ebDPPX+VemNnEenhegablBSx3/uUFvWjLV
Q6ajizuWydk958ihA+p0/dhAifJSXPwx1fDOn3jjucLG485IxNE=
=vfy1
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
