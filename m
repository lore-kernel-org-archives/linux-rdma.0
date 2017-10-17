From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 08/12] i40iw: Reinitialize IEQ on MTU change
Date: Tue, 17 Oct 2017 09:15:07 +0000
Message-ID: <CY1PR0701MB20123ECBE7D8235BD2F9FD8D884C0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
 <20171016204605.37512-9-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-9-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shiraz Saleem
>=20
> On a netdev MTU change event, the iWARP
> Exception Queue (IEQ) buffers may not be sized properly to handle the new
> MTU.
>=20
> Reinitialize the IEQ with new MTU size on MTU change event.
>=20
> Also, add define for the max ethernet frame size field in IEQ QP context
> instead of the snd_mss define which is for iWARP QPs' MSS field.

How do you handle any open iWARP connections on mtu change?=20

>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c |  5 ++++-
>  drivers/infiniband/hw/i40iw/i40iw_d.h    |  3 +++
>  drivers/infiniband/hw/i40iw/i40iw_main.c | 19 +++++++++++++++++--
>  drivers/infiniband/hw/i40iw/i40iw_p.h    |  1 +
>  drivers/infiniband/hw/i40iw/i40iw_puda.c |  2 +-
>  5 files changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> index eabbd6d..c790f8b 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> @@ -348,7 +348,10 @@ void i40iw_change_l2params(struct i40iw_sc_vsi
> *vsi, struct i40iw_l2params *l2pa
>  	u16 qs_handle;
>  	int i;
>=20
> -	vsi->mtu =3D l2params->mtu;
> +	if (vsi->mtu !=3D l2params->mtu) {
> +		vsi->mtu =3D l2params->mtu;
> +		i40iw_reinitialize_ieq(dev);
> +	}
>=20
>  	i40iw_fill_qos_list(l2params->qs_handle_list);
>  	for (i =3D 0; i < I40IW_MAX_USER_PRIORITY; i++) { diff --git
> a/drivers/infiniband/hw/i40iw/i40iw_d.h
> b/drivers/infiniband/hw/i40iw/i40iw_d.h
> index 17ed45b..f1a6ce6c9 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_d.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
> @@ -1107,6 +1107,9 @@
>  #define I40IWQPC_SNDMSS_SHIFT 16
>  #define I40IWQPC_SNDMSS_MASK (0x3fffUL <<
> I40IWQPC_SNDMSS_SHIFT)
>=20
> +#define I40IW_UDA_QPC_MAXFRAMESIZE_SHIFT 16 #define
> +I40IW_UDA_QPC_MAXFRAMESIZE_MASK (0x3fffUL <<
> +I40IW_UDA_QPC_MAXFRAMESIZE_SHIFT)
> +
>  #define I40IWQPC_VLANTAG_SHIFT 32
>  #define I40IWQPC_VLANTAG_MASK (0xffffULL <<
> I40IWQPC_VLANTAG_SHIFT)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c
> b/drivers/infiniband/hw/i40iw/i40iw_main.c
> index dc6b3387..e824296 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_main.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
> @@ -964,8 +964,8 @@ static enum i40iw_status_code
> i40iw_initialize_ieq(struct i40iw_device *iwdev)
>  	info.pd_id =3D 2;
>  	info.sq_size =3D 8192;
>  	info.rq_size =3D 8192;
> -	info.buf_size =3D 2048;
> -	info.tx_buf_cnt =3D 16384;
> +	info.buf_size =3D iwdev->vsi.mtu + VLAN_ETH_HLEN;
> +	info.tx_buf_cnt =3D 4096;
>  	status =3D i40iw_puda_create_rsrc(&iwdev->vsi, &info);
>  	if (status)
>  		i40iw_pr_err("ieq create fail\n");
> @@ -973,6 +973,21 @@ static enum i40iw_status_code
> i40iw_initialize_ieq(struct i40iw_device *iwdev)  }
>=20
>  /**
> + * i40iw_reinitialize_ieq - destroy and re-create ieq
> + * @dev: iwarp device
> + */
> +void i40iw_reinitialize_ieq(struct i40iw_sc_dev *dev) {
> +	struct i40iw_device *iwdev =3D (struct i40iw_device *)dev->back_dev;
> +
> +	i40iw_puda_dele_resources(&iwdev->vsi,
> I40IW_PUDA_RSRC_TYPE_IEQ, false);
> +	if (i40iw_initialize_ieq(iwdev)) {
> +		iwdev->reset =3D true;
> +		i40iw_request_reset(iwdev);
> +	}
> +}
> +
> +/**
>   * i40iw_hmc_setup - create hmc objects for the device
>   * @iwdev: iwarp device
>   *
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_p.h
> b/drivers/infiniband/hw/i40iw/i40iw_p.h
> index e217a12..717fbe7 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_p.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_p.h
> @@ -121,5 +121,6 @@ enum i40iw_status_code
> i40iw_allocate_virt_mem(struct i40iw_hw *hw,  enum i40iw_status_code
> i40iw_free_virt_mem(struct i40iw_hw *hw,
>  					   struct i40iw_virt_mem *mem);
>  u8 i40iw_get_encoded_wqe_size(u32 wqsize, bool cqpsq);
> +void i40iw_reinitialize_ieq(struct i40iw_sc_dev *dev);
>=20
>  #endif
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c
> b/drivers/infiniband/hw/i40iw/i40iw_puda.c
> index 71914b3..d75fc81 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
> @@ -491,7 +491,7 @@ static void i40iw_puda_qp_setctx(struct
> i40iw_puda_rsrc *rsrc)
>  		      LS_64(qp->hw_rq_size, I40IWQPC_RQSIZE) |
>  		      LS_64(qp->hw_sq_size, I40IWQPC_SQSIZE));
>=20
> -	set_64bit_val(qp_ctx, 48, LS_64(1514, I40IWQPC_SNDMSS));
> +	set_64bit_val(qp_ctx, 48, LS_64(rsrc->buf_size,
> +I40IW_UDA_QPC_MAXFRAMESIZE));
>  	set_64bit_val(qp_ctx, 56, 0);
>  	set_64bit_val(qp_ctx, 64, 1);
>=20
> --
> 2.8.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
