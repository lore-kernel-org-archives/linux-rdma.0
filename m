From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/uverbs: Allow CQ moderation with modify
 CQ
Date: Mon, 23 Oct 2017 12:42:14 +0300
Message-ID: <20171023094214.GG2106@mtr-leonro.local>
References: <20171019053524.11135-1-leon@kernel.org>
 <20171019053524.11135-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bDKzcj6YHRdh76QF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171019053524.11135-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bDKzcj6YHRdh76QF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 19, 2017 at 08:35:19AM +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Uverbs support in modify_cq for CQ moderation only.
> Gives ability to change cq_max_count and cq_period.
> CQ moderation enhance performance by moderating the number
> of cookies needed to create an event instead of application
> having to suffer from event per cookie.
> To achieve CQ moderation the application needs to set cq_max_count
> and cq_period.
> cq_max_count - defines the number of cookies
>                needed to create an event.
> cq_period - defines the timeout (micro seconds) between last
>             event and a new one that will occur even if
> 	    cq_max_count was not satisfied
>
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h      |  1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 36 +++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/uverbs_main.c |  1 +
>  include/rdma/ib_verbs.h               |  4 ++++
>  include/uapi/rdma/ib_user_verbs.h     | 11 ++++++++++-
>  5 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index ee2739ae4305..deccefb71a6b 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -306,5 +306,6 @@ IB_UVERBS_DECLARE_EX_CMD(destroy_wq);
>  IB_UVERBS_DECLARE_EX_CMD(create_rwq_ind_table);
>  IB_UVERBS_DECLARE_EX_CMD(destroy_rwq_ind_table);
>  IB_UVERBS_DECLARE_EX_CMD(modify_qp);
> +IB_UVERBS_DECLARE_EX_CMD(modify_cq);
>
>  #endif /* UVERBS_H */
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index ab29a0327831..c7819e5540f1 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3856,3 +3856,39 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
>  	return err;
>  }
> +
> +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> +			   struct ib_device *ib_dev,
> +			   struct ib_udata *ucore,
> +			   struct ib_udata *uhw)
> +{
> +	struct ib_uverbs_ex_modify_cq cmd = {};
> +	struct ib_cq *cq;
> +	int ret;
> +
> +	/* sanity checks */
> +	if (ucore->inlen > sizeof(cmd) &&
> +	    !ib_is_udata_cleared(ucore, sizeof(cmd),
> +				 ucore->inlen - sizeof(cmd)))
> +		return -EOPNOTSUPP;
> +
> +	ret = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
> +	if (ret)
> +		return ret;
> +
> +	if (cmd.attr_mask != IB_CQ_MODERATE)
> +		return -EINVAL;
> +
> +	if (!cmd.comp_mask)
> +		return -EINVAL;

No way that it worked, comp_mask is never set, so it is supposed to be
zero and it is always returning EINVAL.

Additionally, the "attr_mask" is already carrying the same information as
"comp_mask" will handle, hence the "comp_mask" should be dropped.

Thanks

--bDKzcj6YHRdh76QF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlntuXYACgkQ5GN7iDZy
WKdMSQ/9E7k9g021LAMZ87AFHdj9KMMEpiaQ3IwsN8dyjsLAkA8vOP/nQPrza4UG
5DBfm8uvXOFarFy4oewHD4AwJ+/BRqBQ42HnCCzOkDbK5DQTSKQi8OMsrEKZxsD7
getCpI/yK4TCec9eRlodU61unBpK4rDwD7vj5J4W1Jd8+ny/xVfT4jYZTw6tBV1S
zxinnkdVvESdSMhO1qxavBCvnpU61F+OVu8AxPCMEBrz8+Q9eJ2ngAIJ1FhDr9ZB
p6Wa8T0LBy0VyVmiIMtyitOFnzGS4QBrtJzYOVKB8Ktxl+jbiLYuGKD/RZY/H8o5
1thkcHA2MhSeXAxUpQwdTXhKOYWAx76C+3+tRVHDsiSazD5yIXFL1Bh2ZcGHYOmE
LxYg4ZXDThr2W3BIrJjsLXYOLUC7h+QzujnYUS2rrZVA1Gj1iHTFMMWcCfmuoNqh
8Smhjc87eAdTnmeZWZ6R5zbA+OZm5uLZAvaV4fYN31eG9I1qjXoZcFYaWlR9lKmz
9zdGg5fGvnPZmuXQV1J1wG8Skt9S1K5ideU3+kxNo6qFAjHsHgsaDMGHdayZv32+
hxglOObSc1j1jDZqTM3pkBtLSlA/OY8KWHXPH2XHfSF9bFL6RW9GZaZ75Ld0x7wY
pN3z/mbMrMc8g0tWqpwblR2MGowNYkjDwgBuRyOLgQOUgyFL5u8=
=29QP
-----END PGP SIGNATURE-----

--bDKzcj6YHRdh76QF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
