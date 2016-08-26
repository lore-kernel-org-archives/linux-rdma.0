From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix a parameter of find_first_bit
Date: Fri, 26 Aug 2016 22:33:04 +0300
Message-ID: <20160826193304.GH594@leon.nu>
References: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDnEQgWzhgf+8aPe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472188577-14550-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--dDnEQgWzhgf+8aPe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 26, 2016 at 07:16:17AM +0200, Christophe JAILLET wrote:
> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> In this case, we are passing 'sizeof(tmp)' which is likely to be 4 or 8
> because 'tmp' is an 'unsigned long'.
>
> It is likely that the number of bits of 'tmp' was expected here. So use
> BITS_PER_LONG instead.
>
> It has been spotted by the following coccinelle script:
> @@
> expression ret, x;
>
> @@
> *  ret = \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--dDnEQgWzhgf+8aPe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwJlwAAoJEORje4g2clin83sP/ighg72cmSuON/71UqRCpMf/
3LYtQ1mPsrq28gIuEg8fgmiaVIcokCwxebe6W5W+z478p3+lqsjKmXGHYDUtZWxr
ztMLlDj0RfPWLMfpXBshqIJFBflvfvTrwgRn60SE7+Fl7CKhAN1ng0xnKhYRC7h4
/rq0eB9qVkMCOHAnIk4Eb3ykJe8ZbdR0eCGtqEiiHFkEbe17jRtNJgeOWTw9qt62
72R3AV6RPGHLH1wv+8XuwuTVUexG/sq1bEyet4jYZqYPMu+Y/hWNWhYD/B97H/R1
Oj4MiOhWG49/zmWODqdZIx5s+k+wKMXGsbCYoVUvuHrb4qUOTVVARvI07uQG2AuK
xUPlI54/UY09JI8ALK0bkFt4wYsve2yikddlQtmTvzCz2mo8Eo8sT0fObQRHQboV
IM+kevxbBhHRFO+VJW2iIpYD2D+ypK3haHCC2vUstscA4zNT/ltcpqSYQBtPxzjT
yOvzVh6zphq/hjcBvdhPG6YhHd+x3o5s4Vdo5LLp4K72Ygcoe1Spt5PtBIozrj4Y
m4VXex2fgdSDjQx19HI0as07k8gSa4Il/uVjpGvu5ACyzjzlL3hpgi1+lNUto5b2
S8pRhb4tiYr6bsZ3sDVqw4MmRQ4/nXRllcQ7AO73GafvzmUaXN1/QBpSoLDehk8x
HVGT73+FNsZjMfXE8PqJ
=o4nI
-----END PGP SIGNATURE-----

--dDnEQgWzhgf+8aPe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
