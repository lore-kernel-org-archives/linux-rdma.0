From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Convert page_size to encoded value
Date: Fri, 11 Nov 2016 15:07:26 +0200
Message-ID: <20161111130726.GJ28957@leon.nu>
References: <20161110032559.21472-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j+MD90OnwjQyWNYt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161110032559.21472-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--j+MD90OnwjQyWNYt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 09, 2016 at 09:25:59PM -0600, Henry Orosco wrote:
> Passed in page_size was used as encoded value for writing
> the WQE and passed in value was usually 4096. This was
> working out since bit 0 was 0 and implies 4KB pages,
> but would not work for other page sizes.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 12 +++++++++---
>  drivers/infiniband/hw/i40iw/i40iw_type.h |  5 +++++
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> index cd71444..bdb4421 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> @@ -2613,7 +2613,9 @@ static enum i40iw_status_code i40iw_sc_alloc_stag(
>  	u64 *wqe;
>  	struct i40iw_sc_cqp *cqp;
>  	u64 header;
> +	enum i40iw_page_size page_size;
>
> +	page_size = (info->page_size == 0x200000) ? I40IW_PAGE_SIZE_2M : I40IW_PAGE_SIZE_4K;
>  	cqp = dev->cqp;
>  	wqe = i40iw_sc_cqp_get_next_send_wqe(cqp, scratch);
>  	if (!wqe)
> @@ -2633,7 +2635,7 @@ static enum i40iw_status_code i40iw_sc_alloc_stag(
>  		 LS_64(1, I40IW_CQPSQ_STAG_MR) |
>  		 LS_64(info->access_rights, I40IW_CQPSQ_STAG_ARIGHTS) |
>  		 LS_64(info->chunk_size, I40IW_CQPSQ_STAG_LPBLSIZE) |
> -		 LS_64(info->page_size, I40IW_CQPSQ_STAG_HPAGESIZE) |
> +		 LS_64(page_size, I40IW_CQPSQ_STAG_HPAGESIZE) |
>  		 LS_64(info->remote_access, I40IW_CQPSQ_STAG_REMACCENABLED) |
>  		 LS_64(info->use_hmc_fcn_index, I40IW_CQPSQ_STAG_USEHMCFNIDX) |
>  		 LS_64(info->use_pf_rid, I40IW_CQPSQ_STAG_USEPFRID) |
> @@ -2669,7 +2671,9 @@ static enum i40iw_status_code i40iw_sc_mr_reg_non_shared(
>  	u32 pble_obj_cnt;
>  	bool remote_access;
>  	u8 addr_type;
> +	enum i40iw_page_size page_size;
>
> +	page_size = (info->page_size == 0x200000) ? I40IW_PAGE_SIZE_2M : I40IW_PAGE_SIZE_4K;
>  	if (info->access_rights & (I40IW_ACCESS_FLAGS_REMOTEREAD_ONLY |
>  				   I40IW_ACCESS_FLAGS_REMOTEWRITE_ONLY))
>  		remote_access = true;
> @@ -2712,7 +2716,7 @@ static enum i40iw_status_code i40iw_sc_mr_reg_non_shared(
>  	header = LS_64(I40IW_CQP_OP_REG_MR, I40IW_CQPSQ_OPCODE) |
>  		 LS_64(1, I40IW_CQPSQ_STAG_MR) |
>  		 LS_64(info->chunk_size, I40IW_CQPSQ_STAG_LPBLSIZE) |
> -		 LS_64(info->page_size, I40IW_CQPSQ_STAG_HPAGESIZE) |
> +		 LS_64(page_size, I40IW_CQPSQ_STAG_HPAGESIZE) |
>  		 LS_64(info->access_rights, I40IW_CQPSQ_STAG_ARIGHTS) |
>  		 LS_64(remote_access, I40IW_CQPSQ_STAG_REMACCENABLED) |
>  		 LS_64(addr_type, I40IW_CQPSQ_STAG_VABASEDTO) |
> @@ -2927,7 +2931,9 @@ enum i40iw_status_code i40iw_sc_mr_fast_register(
>  	u64 temp, header;
>  	u64 *wqe;
>  	u32 wqe_idx;
> +	enum i40iw_page_size page_size;
>
> +	page_size = (info->page_size == 0x200000) ? I40IW_PAGE_SIZE_2M : I40IW_PAGE_SIZE_4K;
>  	wqe = i40iw_qp_get_next_send_wqe(&qp->qp_uk, &wqe_idx, I40IW_QP_WQE_MIN_SIZE,
>  					 0, info->wr_id);
>  	if (!wqe)
> @@ -2954,7 +2960,7 @@ enum i40iw_status_code i40iw_sc_mr_fast_register(
>  		 LS_64(info->stag_idx, I40IWQPSQ_STAGINDEX) |
>  		 LS_64(I40IWQP_OP_FAST_REGISTER, I40IWQPSQ_OPCODE) |
>  		 LS_64(info->chunk_size, I40IWQPSQ_LPBLSIZE) |
> -		 LS_64(info->page_size, I40IWQPSQ_HPAGESIZE) |
> +		 LS_64(page_size, I40IWQPSQ_HPAGESIZE) |
>  		 LS_64(info->access_rights, I40IWQPSQ_STAGRIGHTS) |
>  		 LS_64(info->addr_type, I40IWQPSQ_VABASEDTO) |
>  		 LS_64(info->read_fence, I40IWQPSQ_READFENCE) |
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
> index f60f0e2..1c58ba6 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_type.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
> @@ -74,6 +74,11 @@ struct i40iw_cq_shadow_area {
>  struct i40iw_priv_cq_ops;
>  struct i40iw_hmc_ops;
>
> +enum i40iw_page_size {
> +	I40IW_PAGE_SIZE_4K = 0,

The initialization is not needed, enums start from 0.

> +	I40IW_PAGE_SIZE_2M
> +};
> +
>  enum i40iw_resource_indicator_type {
>  	I40IW_RSRC_INDICATOR_TYPE_ADAPTER = 0,
>  	I40IW_RSRC_INDICATOR_TYPE_CQ,
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--j+MD90OnwjQyWNYt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJcKOAAoJEORje4g2clin6wAQAMLw5zwqr0NRb0oMiCInnD+4
CzLWkJKp4hhmQ390vGRVYpAU/xb9YpUaTA9xUEcZP7Um1sVqFu58H6wTU+eOwXZ0
jYT9+WAMmuDPtjcr9MI/WJlIkTYimffp+bxVP6F9dHE9moh5RbqZdvm/xRczi9+j
Nj8quM8+MHc0aHf2gwrAJERFFQ8u9LOrSVjruC1nvIh+dzpEI8w6xJ0wOHUiqQ+n
myglc8mwp8pO15bp5HsLSLbabpiwhs2Ro1sMgiKilafnGn0auP29y75CEQgbhFjE
Vn2gUwIOHNFp6aA6aTPdnsrlXovUiKHRgPo/piah+sjgljKPa9NTcsUsn5URFsBn
N6sAG9zT452CNKDN5BzQiPCeUX0KsugDNlYRcve7c+scALqfxslD/OqgZ3zR3J63
880vATzmshgrcEsMx1G1MDTZc2Nk8BOlpPH6CzXBVa6dY+nzUZpGt5rOTh0VObqw
fgnMdAeXLZAtuuX7FsrtJwD/7diZ8EJtC9yqTnwdUTPDEh4AFmfKTBzSowUD23xS
q7+Q8h5nzP3GGNxuHNSDP9SEIj7EDKsGGszQrW+mXbgLtwuEBpkMaeoc5EC4wZoT
D0o4SiheFrxZhhkDZvVndUJT6vFLyYRYNP6zrK+EfzVHpFbq+Vy3+6aaybmAnK+U
3UYPHtYPGBr9K0fOf85c
=KH0e
-----END PGP SIGNATURE-----

--j+MD90OnwjQyWNYt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
