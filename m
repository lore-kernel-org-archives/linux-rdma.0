From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH V3 15/16] RDMA/i40iw: Fix SD calculation for initial HMC
 creation
Date: Wed, 20 Apr 2016 11:25:39 +0300
Message-ID: <20160420082539.GW6349@leon.nu>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
 <1460993589-9428-16-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AFjAQ8ujNJnIGHaX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460993589-9428-16-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AFjAQ8ujNJnIGHaX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 18, 2016 at 10:33:08AM -0500, Mustafa Ismail wrote:
> Correct SD calculation by using base address returned from commit FPM.
> This alleviates any assumptions on resource ordering and alignment
> requirement. Also consolidate SD estimation code into i40iw_est_sd().
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 93 +++++++++++++++++++++-----=
------
>  drivers/infiniband/hw/i40iw/i40iw_type.h |  2 +-
>  2 files changed, 62 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniban=
d/hw/i40iw/i40iw_ctrl.c
> index 023a7ae..2c4b4d0 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> @@ -114,16 +114,21 @@ static enum i40iw_status_code i40iw_cqp_poll_regist=
ers(
>   * i40iw_sc_parse_fpm_commit_buf - parse fpm commit buffer
>   * @buf: ptr to fpm commit buffer
>   * @info: ptr to i40iw_hmc_obj_info struct
> + * @sd: number of SDs for HMC objects
>   *
>   * parses fpm commit info and copy base value
>   * of hmc objects in hmc_info
>   */
>  static enum i40iw_status_code i40iw_sc_parse_fpm_commit_buf(
>  				u64 *buf,
> -				struct i40iw_hmc_obj_info *info)
> +				struct i40iw_hmc_obj_info *info,
> +				u32 *sd)
>  {
>  	u64 temp;

=2E..

> +	size =3D info[k].cnt * info[k].size + info[k].base;
> +	if (size & 0x1FFFFF)
> +		*sd =3D (u32)((size >> 21) + 1); /* add 1 for remainder */
> +	else
> +		*sd =3D (u32)(size >> 21);
> +

The code above can be simplified a little bit.
  *sd =3D (u32)((size >> 21);
  if (size & 0x1FFFFF)
        *sd +=3D 1;

>  	return 0;
>  }

=2E..

> +
> +	if (size & 0x1FFFFF)
> +		sd =3D (size >> 21) + 1; /* add 1 for remainder */
> +	else
> +		sd =3D size >> 21;

The same as above.

> +
> +	if (!dev->is_pf) {
> +		/* 2MB alignment for VF PBLE HMC */
> +		size =3D hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].cnt * hmc_info->hmc_obj[=
I40IW_HMC_IW_PBLE].size;
> +		if (size & 0x1FFFFF)
> +			sd +=3D (size >> 21) + 1; /* add 1 for remainder */
> +		else
> +			sd +=3D size >> 21;
> +	}

The same as above.

> +
> +	return sd;
> +}
> +

--AFjAQ8ujNJnIGHaX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFz0DAAoJEORje4g2clincW4P/3WtSZgLW8KIg6I+AwswXtKS
Qtr2FjZ9HdZDfpm3Y8O7BUWyJXYkaq/5oS3w7ALHB/zbWD7+YDrQyu5JkqmQKvLi
il00L0hWGfnd1euy2/lyFz3ocWC09HK7HJ/xMZ8dH3Qbr+5aLMB4E9mLPqeXIX92
x4Po7SkAX3/Q2RGWlDoFu8GEpKBemYx/yackZAmWdTUJwA5+tLpz8BgWmWU4ttYb
IFfcl5+FRFjCoXzqrL7q5OCBK+cNxMqlZA+WcZ3LvsyTA2TQ18zH0UyDHYvZ2Bjl
KxEfBaIvW6desTCsT+dje5ORr8xyw1OJHipogP3MkYszRqntraxntYcLJojP2/TG
4EYrQ1tJycotRAbbzMXOExq9SR3yQ8Hf/6h1bg4LGSjbVEpIdJuMFUGa0NPzrUXl
WeDZIezvs611uJClOUA2C/952Den602RmqHRQzkRa0dchvOO0xEkFPl53KGnOFv3
PdTF+9BkIM4ZRJXCZM0QVM2ZBN7CBq+fzIdwBO404eaAJ3/dWo87mAIRTdmsOOHL
unzvKBxVK+kMLOMX5U4He2tJpgi/8dVa38hFUNF+4qNBwsINLEv8Q+bt7QqLu88l
O6A+2xB1VHAenLHDHMAoLU5XP4NzNYTuGvP8cBnHP4/ve6byPpYL1wXVIDELraer
8TTO390jTCVG+0GTxXvr
=LJ1c
-----END PGP SIGNATURE-----

--AFjAQ8ujNJnIGHaX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
