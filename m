From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 3/7] IB/core: Add idr based standard types
Date: Wed, 5 Apr 2017 17:05:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB10F97B@ORSMSX109.amr.corp.intel.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491301907-32290-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
> +	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object),
> 0),
> +	.destroy_object = uverbs_free_cq,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_qp = {
> +	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object),
> 0),
> +	.destroy_object = uverbs_free_qp,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_mw = {
> +	.type = UVERBS_TYPE_ALLOC_IDR(0),
> +	.destroy_object = uverbs_free_mw,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_mr = {
> +	/* 1 is used in order to free the MR after all the MWs */
> +	.type = UVERBS_TYPE_ALLOC_IDR(1),
> +	.destroy_object = uverbs_free_mr,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_srq = {
> +	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object),
> 0),
> +	.destroy_object = uverbs_free_srq,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_ah = {
> +	.type = UVERBS_TYPE_ALLOC_IDR(0),
> +	.destroy_object = uverbs_free_ah,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_flow = {
> +	.type = UVERBS_TYPE_ALLOC_IDR(0),
> +	.destroy_object = uverbs_free_flow,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_wq = {
> +	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object),
> 0),
> +	.destroy_object = uverbs_free_wq,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table = {
> +	.type = UVERBS_TYPE_ALLOC_IDR(0),
> +	.destroy_object = uverbs_free_rwq_ind_tbl,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd = {
> +	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object),
> 0),
> +	.destroy_object = uverbs_free_xrcd,
> +};
> +
> +const struct uverbs_obj_idr_type uverbs_type_attrs_pd = {
> +	/* 2 is used in order to free the PD after MRs */
> +	.type = UVERBS_TYPE_ALLOC_IDR(2),
> +	.destroy_object = uverbs_free_pd,
> +};

I wonder if it wouldn't make more sense to have destroy order be independent from object creation assumptions.  For example, QPs must be destroyed prior to their associated CQs.  This code works, since the CQ is passed in during QP creation and ends up on the list correctly, but I wonder if all hardware would actually need that restriction.  Basically, the destroy order value as used is not actually capturing the true destroy order; there are other assumptions baked into the code.

Otherwise:

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
