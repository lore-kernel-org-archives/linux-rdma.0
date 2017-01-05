From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: Remove unnecessary returned value check
Date: Thu, 5 Jan 2017 14:50:22 +0200
Message-ID: <20170105125022.GA15685@mtr-leonro.local>
References: <20170105061236.GV12077@mtr-leonro.local>
 <1483606568-17232-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483606568-17232-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2017 at 03:56:08AM -0500, Zhu Yanjun wrote:
> In the function ipoib_set_dev_features, the returned value is always 0.
> As such, it is not necessary to check the returned value.
> This is not a bug. It is a trivial problem.
>
> Reviewed-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhuQQ4ACgkQ5GN7iDZy
WKf/4RAAvSmY9+UCiLdXg07aUNzkNIT2+b3dwE7vJLxuuz15nBtfHn4GbLqwbJTA
hZTyiSmPj8fEcMXGagvnnn/IlExjqqXasBKxNmHsvfFjNvdi8J/ft5TIcrj1i9qH
SYJYqdfy/dcLTLbzs8WwghWZIgLdOeSq+KSkGdQi+IMYflEmywng4N+lsFXIYFds
8Xib9JyodPGgUfEwRKM0RHqWM4fotfqeLTMafF+gFrUNBIUKQVolP/D6ZeTKlZHS
b278MYUV4oUjM6rz2kNNa3ZRLRi1DV3C5m1STVEbrSghFuWMPZQlZtpWx2RhhWRg
9CoX20o04DjFb2HLUUyXKxrF23lSG0UjIzDA1iCJZuyiSWnmFNuJV4ICEcYlB2jy
xzgD4Zln8m8dzopHLOH55/6qyqTU7QC08WxyuzryWusMj6ruFf+2GbEq07/w0IoB
WhCh7E9ZcDdj3vi1fRJXprqmoyosFKphLk2+BWxIhsf0nwb8+lo82U2YXKii0wq/
gveSMajwLrZ+4AeG1AmlqzbvEhu/Ru/5CjSlBBAJuvXpR/BX1AV9tBjIvOGcGg4J
4WoXYzMevobuCNc+BVQxD4ERxUyTjXN9KgVcJWHdmVVrhT0gFFMropG6KXOvTw+C
SOdehL8ohcdO+5oEaMdMaLCkdGLF7jcSs2oZmdmSC1o5xuAuyk8=
=qpmQ
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
