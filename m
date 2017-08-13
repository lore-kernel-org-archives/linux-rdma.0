From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: fix duplicated code for different branches
Date: Sun, 13 Aug 2017 09:31:56 +0300
Message-ID: <20170813063156.GP24282@mtr-leonro.local>
References: <20170813005235.GA30629@embeddedgus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S6vg04ofUPzW4qJg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813005235.GA30629@embeddedgus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--S6vg04ofUPzW4qJg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 12, 2017 at 07:52:35PM -0500, Gustavo A. R. Silva wrote:
> Refactor code to avoid identical code for different branches.
>
> This issue was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c | 4 ----
>  1 file changed, 4 deletions(-)

I see that you used the same commit message and title for many patches,
it will be better to have description on what exactly you are removing
and why there is no bug in that code.


>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 2b4d613..b46262f 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -590,8 +590,6 @@ static struct cm_id_private * cm_insert_listen(struct cm_id_private *cm_id_priv)
>  			link = &(*link)->rb_right;
>  		else if (be64_lt(service_id, cur_cm_id_priv->id.service_id))
>  			link = &(*link)->rb_left;
> -		else if (be64_gt(service_id, cur_cm_id_priv->id.service_id))
> -			link = &(*link)->rb_right;
>  		else
>  			link = &(*link)->rb_right;
>  	}
> @@ -619,8 +617,6 @@ static struct cm_id_private * cm_find_listen(struct ib_device *device,
>  			node = node->rb_right;
>  		else if (be64_lt(service_id, cm_id_priv->id.service_id))
>  			node = node->rb_left;
> -		else if (be64_gt(service_id, cm_id_priv->id.service_id))
> -			node = node->rb_right;

You should remove be64_gt() too.

>  		else
>  			node = node->rb_right;
>  	}
> --
> 2.5.0
>

--S6vg04ofUPzW4qJg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmP8lwACgkQ5GN7iDZy
WKcXjg/+K6AZTPqdtaYGwpV1zFW4Q09YOZNntpa857PJUTP8ohl+xskQB+GO3h88
81n5A9lFUphHV7CDg4geeBlIQ36DtTp79ZUxOl23FD6+Mtdhi8HVM3oKRpL+rS6f
aEyau0d12fmGsu74EMq1EGI73cm3abht4l1T86jAvvJjG4nEly8NE6VDzf/xlhfx
kqROMXEQryNTrE/Ze7jZGxpvmUJH7ZZ2Oa4T2CoKGqwvpEZ2f6AigkTodi86y0zP
v7JvlPh45kk6GHkDrnzhen0wp1Hz9O0WVHLsOuSLCcvGNqyXTG682t6+ceTl+HVS
Vyr4cjIKH1Ntg7QHqeIL40p6qTomsYodlH6iae/3CsUB8GlW4g8wd2DgJb7szaV5
wS60MkLPAjW/Ddac1MwI6YsnHrIvtFTJzXyDfU5G7ucZJT21PfFp+3GEv66C7hMY
MN0LkR5rxWWmkmrBMbuMaF+l9BYGWjNsZTomkPz2wdNfbk3kV2t9cLBfRSM27jXq
ODjqMEnuy30mp/sWgbli/SxQ2y0ua8+80Yo37SwB2Jih1Fxm234NRDuu20kyI1lv
NUwdGLVIuWz0kGwF0qHWOApnJpUxP7k56Mtbgn3DSygENDc6alZcycdmD0iCv5ZD
DGoRALS7XrxLdvPmVrFwzN5sgGfclbFJVbaT5kznHu0g7Jvu6Y4=
=JjiP
-----END PGP SIGNATURE-----

--S6vg04ofUPzW4qJg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
