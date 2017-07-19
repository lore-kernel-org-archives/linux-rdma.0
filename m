From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Convert pr_info to pr_warn
Date: Wed, 19 Jul 2017 09:09:08 +0300
Message-ID: <20170719060908.GN3259@mtr-leonro.local>
References: <20170718203539.6777-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170718203539.6777-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 18, 2017 at 11:35:39PM +0300, Yuval Shaia wrote:
> These messages are warning so let's print them accordingly.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
> index 5bddf469361b..272db3792c50 100644
> --- a/drivers/infiniband/sw/rxe/rxe_av.c
> +++ b/drivers/infiniband/sw/rxe/rxe_av.c
> @@ -39,7 +39,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
>  	struct rxe_port *port;
>
>  	if (rdma_ah_get_port_num(attr) != 1) {
> -		pr_info("invalid port_num = %d\n", rdma_ah_get_port_num(attr));
> +		pr_warn("invalid port_num = %d\n", rdma_ah_get_port_num(attr));
>  		return -EINVAL;
>  	}

How this code can be executed? IB/core ensures that port_num is in range.
You can remove this check.

>
> @@ -49,7 +49,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
>  		u8 sgid_index = rdma_ah_read_grh(attr)->sgid_index;
>
>  		if (sgid_index > port->attr.gid_tbl_len) {
> -			pr_info("invalid sgid index = %d\n", sgid_index);
> +			pr_warn("invalid sgid index = %d\n", sgid_index);
>  			return -EINVAL;
>  		}
>  	}
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllu94QACgkQ5GN7iDZy
WKfyCg/8CyOGW6Ph3SElAxhUBCte+5vsFZf8EcqcQxGj6wyA0OXGmNJfA/egXUX/
GVP9DR0n88dK+cDjH2mmuIQPX8UXgKQPFO9aesY+hv3rdPOl+jaZfjSIFqDeFh3b
eEnjuqOk+dQQYc42hRSCbSjxBqV3uVlw4zhVFQGok0459aC/GnNyPBUR757fGEQT
hdGPkFmqN1YSul32+C9MiGZtYshL5ZyhajLjgR4392pDKBxGNV/WoEjQhmerV+Lg
OuaoazPzWYfo0MlxqH+hpNM0GNYWtQJ8cqrop7u+MdB9P3ghnQ9r+EeHISnA2YtR
s/b3W19Q/GNE7jdK3Q3A+46LL+7/zMDt1OpujP4Q6IbDC6GkpKEfmzJaYI17lvkL
UdN0/9CWmIwci+et7pTAISaHN/AxTtuwrar30VhuiFDH7cFYYbx9bjGXvHjE4CX6
/LvF07NOgUWeGqfD9HI/jw87uhPMfpU+4QKhPJeoFtPEzWHnWiKZmMv1PxHA+vsT
dfc4J2PLc2V2/w0Dc5Aj2YXZMRAY348QJFm0ovHeDY/+mPSZVGxF87u9QKcrGHtY
XGswwgDvD/4MAt4onAYyd7nq/ksdjj8ejRpOcGpKv7RNeMURIvp27zWvgXgJmoK8
nM80Lko2kSXIFjzYX+p63pSlU4hvhtQ54DQP4XPQx3cNbaE3aQQ=
=Dh9r
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
