From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/vmw_pvrdma: Remove unused qp_type
Date: Tue, 17 Jan 2017 13:31:43 +0200
Message-ID: <20170117113143.GM32481@mtr-leonro.local>
References: <1484642040-10668-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3W6riq+uV6J42Ub"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484642040-10668-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--u3W6riq+uV6J42Ub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 10:34:00AM +0200, Yuval Shaia wrote:
> Remove the unused qp_type parameter from function's args
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--u3W6riq+uV6J42Ub
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh+AJ8ACgkQ5GN7iDZy
WKdGLRAArLQ8Jx7rN56e5FPcnjWlVorUgr3fT9CzP4NmjxZBt96mlyt6Yddq9Bkj
IdAbRnHMnVkosyPMzDFX735bUnx1COvNZSQVxDt7ZkCYY2i0ow8JCgjs7mWqBc/q
MBJzMpTv0dAcf7JE+GYugF7PuJjz09V0BcApfSqO8VL8znb0t9rSgUDTTZDP8of6
buJ8Wgl0McSXKhUjlyD9ppb+sbFavPjuZdyLraJim+xOfEmrOYzWtNmsTI38hwgA
mdIb9NX7LO3V/0xK1SRg2EcyEyFudrcP1xgmT/LO80kxOjcvdP7Lf8uzKc+Z79wt
s+ddLu3sZSoetzxZ5BgvR22NFQuubJiHXcmWauQicwTZ5XC8fp3z6s1hmQaSOlCi
bPHJG0O+Gy7gyc9qD3fddhOF9zDshDXDUFp0NG2yMSN0KNDIz6+QeFBryherGqco
fxtHTmg732arW4p9XrjK4sv3oTnKKFrAeGnqyUN7iHHB+n3RDIxHTTqriVaeyjs7
35XV05wfpd3VVjbZ/Gx5quiLlvs73X1aYGS8cmTBqdGOVF3Ms4UYH4A9UPCF5zR8
AKlHdnm/qPDNqfA26lvXm/GlfpcVflQgH7E/tBPPvCaQUWF8D0dT5LJ/csoUfOtD
AKShafZTNIur6e/NM9DxQblQ8hK4Lcw/71UrOdTPFshTV1+hZr8=
=E/Rl
-----END PGP SIGNATURE-----

--u3W6riq+uV6J42Ub--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
