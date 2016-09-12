From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: free the userspace memory region with kfree
 instead of vfree
Date: Mon, 12 Sep 2016 07:52:07 +0300
Message-ID: <20160912045207.GC8812@leon.nu>
References: <20160909071537.18821-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160909071537.18821-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 08:15:37AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> The userspace memory region 'mr' is allocated with kzalloc in
> __rvt_alloc_mr  however it is incorrectly being freed with vfree in
> __rvt_free_mr. Fix this by using kfree to free it.
>
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/sw/rdmavt/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
> index 80c4b6b..46b6497 100644
> --- a/drivers/infiniband/sw/rdmavt/mr.c
> +++ b/drivers/infiniband/sw/rdmavt/mr.c
> @@ -294,7 +294,7 @@ static void __rvt_free_mr(struct rvt_mr *mr)
>  {
>  	rvt_deinit_mregion(&mr->mr);
>  	rvt_free_lkey(&mr->mr);
> -	vfree(mr);
> +	kfree(mr);
>  }
>
>  /**
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1jR3AAoJEORje4g2clinC4YQAK3RvZYvAuN8MgcCRnEWKMal
uGdUca+4e/M4qRRnRzGD6VSsu6gqUYTEJP3sDQEpvti3NfHMyxd/6UjSTtdeJ5kH
lEIsxKiiiio3QM/VXOjlUaspIRYcapfnnlcVqlXahyeIUVC6+grG22HPIAgwGQZ+
jKSXVW8PIf/F3zzbqZX8FsGehxOkmBySwhVsKUth9fRVJSFbV/Xqn/3xpJu3OzAR
EPnaBAk71QSbKOpMA2DQ2dXF0mYyvb+OOFl34cD1sKyv2w2xdPNEnDfNkLO3a18e
Dr+hPtFk0XdQgF6LwTay8A6cIy3mYSxXEU4mlY9gi5hUBPyapTC6o0dnXIc6uduG
bz1rEA1ADSZTodlMhLrcwWx75Vku1k7eGRdiY8suHbiiNbXWNl1EK4mboKvrlgy0
KZtgCnVHorEvzVVr6oDI9nXQx0TSWqjqBYVgPPBFZ6H5ao16KRozmcYF20VMwfbo
YTFlA6DaMHBTDfYw42QWAX2mq0CB9o+v0hPf1JkermAP2f/O3VitnZUyWrxJMi6J
PW/lvaZjh3bhV8TQQsEPP/T5FHeyjYMB/x31RpVeB4MoNEQXhhexZ9jU8EA6wsst
sVM5M8XBw5+GtrdJKI0ItmEQ5PplS1oLAJ1ip+Jy/2/I9IKeqPnPv9pUbVWDTz2M
ArEDXZtJbfQu0CPXtAOb
=ih+e
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
