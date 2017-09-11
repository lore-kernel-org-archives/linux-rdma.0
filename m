From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx4: Add inline-receive support
Date: Mon, 11 Sep 2017 15:42:50 +0300
Message-ID: <20170911124250.GH3405@mtr-leonro.local>
References: <20170621062628.7416-1-leon@kernel.org>
 <43e0de1a-7d1f-9ee5-6f8e-3a09fc7cc19c@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <43e0de1a-7d1f-9ee5-6f8e-3a09fc7cc19c-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 08:25:37PM +0800, oulijun wrote:
> =E5=9C=A8 2017/6/21 14:26, Leon Romanovsky =E5=86=99=E9=81=93:
> > From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When inline-receive is enabled, the HCA may write received
> > data into the receive WQE.
> >
> > Inline-receive is enabled by setting its matching bit in
> > the QP context and each single-packet message with payload
> > not exceeding the receive WQE size will be delivered to
> > the WQE.
> >
> > The completion report will indicate that the payload was placed to the =
WQE.
> >
> > It includes:
> > 1) Return maximum supported size of inline-receive by the hardware
> > in query_device vendor's data part.
> > 2) Enable the feature when requested by the vendor data input.
> >
> > Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > Hi Doug,
> >
> > This patch is based on commit 4931c6ef04b4 ("net/mlx4_en: Optimized sin=
gle ring steering")
> > from Dave's net-next
> >
> > Thanks
> > ---
> >  drivers/infiniband/hw/mlx4/main.c    |  7 +++++++
> >  drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +++
> >  drivers/infiniband/hw/mlx4/qp.c      | 32 +++++++++++++++++++++++++---=
----
> >  include/uapi/rdma/mlx4-abi.h         |  3 ++-
> >  4 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> > index 75b2f7d4cd95..2c7d24b99fec 100644
> > --- a/drivers/infiniband/hw/mlx4/main.c
> > +++ b/drivers/infiniband/hw/mlx4/main.c
> > @@ -563,6 +563,13 @@ static int mlx4_ib_query_device(struct ib_device *=
ibdev,
> >  		}
> >  	}
> >
> > +	if (uhw->outlen >=3D resp.response_length +
> > +	    sizeof(resp.max_inl_recv_sz)) {
> > +		resp.response_length +=3D sizeof(resp.max_inl_recv_sz);
> > +		resp.max_inl_recv_sz  =3D dev->dev->caps.max_rq_sg *
> > +			sizeof(struct mlx4_wqe_data_seg);
> > +	}
> > +
> >  	if (uhw->outlen) {
> >  		err =3D ib_copy_to_udata(uhw, &resp, resp.response_length);
> >  		if (err)
> > diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/=
hw/mlx4/mlx4_ib.h
> > index c2b9cbf4da05..e8989c7585a7 100644
> > --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > @@ -319,6 +319,7 @@ struct mlx4_ib_qp {
> >  	u8			sq_no_prefetch;
> >  	u8			state;
> >  	int			mlx_type;
> > +	u32			inl_recv_sz;
> >  	struct list_head	gid_list;
> >  	struct list_head	steering_rules;
> >  	struct mlx4_ib_buf	*sqp_proxy_rcv;
> > @@ -624,6 +625,8 @@ struct mlx4_uverbs_ex_query_device_resp {
> >  	__u32 comp_mask;
> >  	__u32 response_length;
> >  	__u64 hca_core_clock_offset;
> > +	__u32 max_inl_recv_sz;
> > +	__u32 reserved;
> >  };
> >
> >  static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
> > diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
> > index 996e9058e515..76125bf4bea9 100644
> > --- a/drivers/infiniband/hw/mlx4/qp.c
> > +++ b/drivers/infiniband/hw/mlx4/qp.c
> > @@ -377,7 +377,8 @@ static int send_wqe_overhead(enum mlx4_ib_qp_type t=
ype, u32 flags)
> >  }
> >
> >  static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
> > -		       int is_user, int has_rq, struct mlx4_ib_qp *qp)
> > +		       int is_user, int has_rq, struct mlx4_ib_qp *qp,
> > +		       u32 inl_recv_sz)
> >  {
> >  	/* Sanity check RQ size before proceeding */
> >  	if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE=
 ||
> > @@ -385,18 +386,24 @@ static int set_rq_size(struct mlx4_ib_dev *dev, s=
truct ib_qp_cap *cap,
> >  		return -EINVAL;
> >
> >  	if (!has_rq) {
> > -		if (cap->max_recv_wr)
> > +		if (cap->max_recv_wr || inl_recv_sz)
> >  			return -EINVAL;
> >
> >  		qp->rq.wqe_cnt =3D qp->rq.max_gs =3D 0;
> >  	} else {
> > +		u32 max_inl_recv_sz =3D dev->dev->caps.max_rq_sg *
> > +			sizeof(struct mlx4_wqe_data_seg);
> > +		u32 wqe_size;
> > +
> >  		/* HW requires >=3D 1 RQ entry with >=3D 1 gather entry */
> > -		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge))
> > +		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge ||
> > +				inl_recv_sz > max_inl_recv_sz))
> >  			return -EINVAL;
> >
> >  		qp->rq.wqe_cnt	 =3D roundup_pow_of_two(max(1U, cap->max_recv_wr));
> >  		qp->rq.max_gs	 =3D roundup_pow_of_two(max(1U, cap->max_recv_sge));
> > -		qp->rq.wqe_shift =3D ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_d=
ata_seg));
> > +		wqe_size =3D qp->rq.max_gs * sizeof(struct mlx4_wqe_data_seg);
> > +		qp->rq.wqe_shift =3D ilog2(max_t(u32, wqe_size, inl_recv_sz));
> >  	}
> >
> >  	/* leave userspace return values as they were, so as not to break ABI=
 */
> > @@ -719,9 +726,6 @@ static int create_qp_common(struct mlx4_ib_dev *dev=
, struct ib_pd *pd,
> >  	if (init_attr->sq_sig_type =3D=3D IB_SIGNAL_ALL_WR)
> >  		qp->sq_signal_bits =3D cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
> >
> > -	err =3D set_rq_size(dev, &init_attr->cap, !!pd->uobject, qp_has_rq(in=
it_attr), qp);
> > -	if (err)
> > -		goto err;
> >
> >  	if (pd->uobject) {
> >  		struct mlx4_ib_create_qp ucmd;
> > @@ -731,6 +735,12 @@ static int create_qp_common(struct mlx4_ib_dev *de=
v, struct ib_pd *pd,
> >  			goto err;
> >  		}
> >
> > +		err =3D set_rq_size(dev, &init_attr->cap, !!pd->uobject,
> > +				  qp_has_rq(init_attr), qp, ucmd.inl_recv_sz);
> > +		if (err)
> > +			goto err;
> > +
> > +		qp->inl_recv_sz =3D ucmd.inl_recv_sz;
> >  		qp->sq_no_prefetch =3D ucmd.sq_no_prefetch;
> >
> >  		err =3D set_user_sq_size(dev, qp, &ucmd);
> > @@ -760,6 +770,11 @@ static int create_qp_common(struct mlx4_ib_dev *de=
v, struct ib_pd *pd,
> >  				goto err_mtt;
> >  		}
> >  	} else {
> > +		err =3D set_rq_size(dev, &init_attr->cap, !!pd->uobject,
> > +				  qp_has_rq(init_attr), qp, 0);
> > +		if (err)
> > +			goto err;
> > +
> >  		qp->sq_no_prefetch =3D 0;
> >
> >  		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
> > @@ -1657,6 +1672,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
> >  		}
> >  	}
> >
> > +	if (qp->inl_recv_sz)
> > +		context->param3 |=3D cpu_to_be32(1 << 25);
> > +
> >  	if (ibqp->qp_type =3D=3D IB_QPT_GSI || ibqp->qp_type =3D=3D IB_QPT_SM=
I)
> >  		context->mtu_msgmax =3D (IB_MTU_4096 << 5) | 11;
> >  	else if (ibqp->qp_type =3D=3D IB_QPT_RAW_PACKET)
> > diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
> > index af431752655c..bf3bdba2f326 100644
> > --- a/include/uapi/rdma/mlx4-abi.h
> > +++ b/include/uapi/rdma/mlx4-abi.h
> > @@ -101,7 +101,8 @@ struct mlx4_ib_create_qp {
> >  	__u8	log_sq_bb_count;
> >  	__u8	log_sq_stride;
> >  	__u8	sq_no_prefetch;
> > -	__u8	reserved[5];
> > +	__u32	inl_recv_sz;
> > +	__u8	reserved;
> >  };
> >
> >  #endif /* MLX4_ABI_USER_H */
> > --
> > 2.13.1
> >
> Hi=EF=BC=8C Leon
>   I have a questions:
>   1. It will be enabled by attr_mask by defining the MACRO in libibverbs.=
so in next future?
>      For example, IB_RECV_INLINE

This feature was exposed via private include/uapi/rdma/mlx4-abi.h and
will be used in our direct verbs without any changes to libibverbs and
flows. The user of this feature is supposed to work with mlx4dv header
directly.

Thanks

>
> thanks
> Lijun Ou
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > .
> >
>
>

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm2hMoACgkQ5GN7iDZy
WKcABQ//cN7u9cMBAd0D2SDk41QAAg9NSeDBU/NSFlylStygl+irlqyPeCtSqGZ2
KoB12mijwUSTEp5rgLdJpVl9CKh7vIFeTj61mHnQRIg2TIKp7zbVKYaUJG7FRo+F
jqipeF8T0dD9KBYZF0q035hw1n63Ti/Qwu4k6vSTNs/7xHH6z0+Ymw6Ksp0LokGe
a3/3f8qWLos++AiVuq7XhbyLprwMz6MpqnbBppUEtf82HrP0UlvASXdfgfVYYG7W
Xx4e/NbP8GmzHxojVF2F9ibepmGb11rYEYAk89GF7nw61fZg54RZ35OvWzkgt4O5
gU0Zfb2epwj+5cvuuuwBB8S/ehNzos8ICwdmSCDLd0Efk4lk4Vwrrlkzyn58yB8x
qNpst75BN378FnVNGLl4XuWkaXdIzE7C32qIOe3lHlCwg3E8DRd0ctobb2CnzAJo
oQjOtkxc7oBj6N08KPV5pLAkbjJ2gqTQguEu8N2CO56B+dpAxKqR0fnxjPcGO+qE
CEYZqniJJ11suMqFM39yZzCHGBCiZJ6fjy3rkWqPGSe99D9K17aTmPJm8uFViCwS
H13SCsQOGYjOJ1CS4yOb6+d1FYvqHv2nMG8I2ybi44nl+qC16CoWqAmshuersXEI
J4/aAhWMQVzZLUk19j/EJzyKS8mea2/11SFL24AkXR5LcyJi1UM=
=Cr2V
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
