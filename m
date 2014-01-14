From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] IB/mlx5: Add support for resize CQ
Date: Tue, 14 Jan 2014 17:36:50 +0100
Message-ID: <1389717410.1585.67.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-10-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-10-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 14 janvier 2014 =C3=A0 17:45 +0200, Eli Cohen a =C3=A9crit :
> Implement resize CQ which is a mandatory verb in mlx5.
>=20
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Conflicts:
> 	include/linux/mlx5/device.h
> ---
>  drivers/infiniband/hw/mlx5/cq.c              | 282 +++++++++++++++++=
++++++++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h         |   3 +-
>  drivers/infiniband/hw/mlx5/user.h            |   3 +
>  drivers/net/ethernet/mellanox/mlx5/core/cq.c |   4 +-
>  include/linux/mlx5/cq.h                      |  12 +-
>  include/linux/mlx5/device.h                  |   2 +
>  6 files changed, 284 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/=
mlx5/cq.c
> index b4c122e..50b03a8 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -73,14 +73,24 @@ static void *get_cqe(struct mlx5_ib_cq *cq, int n=
)
>  	return get_cqe_from_buf(&cq->buf, n, cq->mcq.cqe_sz);
>  }
> =20
> +static u8 sw_ownership_bit(int n, int nent)
> +{
> +	return (n & nent) ? 1 : 0;
> +}
> +
>  static void *get_sw_cqe(struct mlx5_ib_cq *cq, int n)
>  {
>  	void *cqe =3D get_cqe(cq, n & cq->ibcq.cqe);
>  	struct mlx5_cqe64 *cqe64;
> =20
>  	cqe64 =3D (cq->mcq.cqe_sz =3D=3D 64) ? cqe : cqe + 64;
> -	return ((cqe64->op_own & MLX5_CQE_OWNER_MASK) ^
> -		!!(n & (cq->ibcq.cqe + 1))) ? NULL : cqe;
> +
> +	if (likely((cqe64->op_own) >> 4 !=3D MLX5_CQE_INVALID) &&
> +	    !((cqe64->op_own & MLX5_CQE_OWNER_MASK) ^ !!(n & (cq->ibcq.cqe =
+ 1)))) {
> +		return cqe;
> +	} else {
> +		return NULL;
> +	}
>  }
> =20
>  static void *next_cqe_sw(struct mlx5_ib_cq *cq)
> @@ -351,6 +361,11 @@ static void handle_atomics(struct mlx5_ib_qp *qp=
, struct mlx5_cqe64 *cqe64,
>  	qp->sq.last_poll =3D tail;
>  }
> =20
> +static void free_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_b=
uf *buf)
> +{
> +	mlx5_buf_free(&dev->mdev, &buf->buf);
> +}
> +
>  static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  			 struct mlx5_ib_qp **cur_qp,
>  			 struct ib_wc *wc)
> @@ -366,6 +381,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  	void *cqe;
>  	int idx;
> =20
> +repoll:
>  	cqe =3D next_cqe_sw(cq);
>  	if (!cqe)
>  		return -EAGAIN;
> @@ -379,7 +395,18 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  	 */
>  	rmb();
> =20
> -	/* TBD: resize CQ */
> +	opcode =3D cqe64->op_own >> 4;
> +	if (unlikely(opcode =3D=3D MLX5_CQE_RESIZE_CQ)) {
> +		if (likely(cq->resize_buf)) {
> +			free_cq_buf(dev, &cq->buf);
> +			cq->buf =3D *cq->resize_buf;
> +			kfree(cq->resize_buf);
> +			cq->resize_buf =3D NULL;
> +			goto repoll;
> +		} else {
> +			mlx5_ib_warn(dev, "unexpected resize cqe\n");
> +		}
> +	}
> =20
>  	qpn =3D ntohl(cqe64->sop_drop_qpn) & 0xffffff;
>  	if (!*cur_qp || (qpn !=3D (*cur_qp)->ibqp.qp_num)) {
> @@ -398,7 +425,6 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  	}
> =20
>  	wc->qp  =3D &(*cur_qp)->ibqp;
> -	opcode =3D cqe64->op_own >> 4;
>  	switch (opcode) {
>  	case MLX5_CQE_REQ:
>  		wq =3D &(*cur_qp)->sq;
> @@ -503,15 +529,11 @@ static int alloc_cq_buf(struct mlx5_ib_dev *dev=
, struct mlx5_ib_cq_buf *buf,
>  		return err;
> =20
>  	buf->cqe_size =3D cqe_size;
> +	buf->nent =3D nent;
> =20
>  	return 0;
>  }
> =20
> -static void free_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_b=
uf *buf)
> -{
> -	mlx5_buf_free(&dev->mdev, &buf->buf);
> -}
> -
>  static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *=
udata,
>  			  struct ib_ucontext *context, struct mlx5_ib_cq *cq,
>  			  int entries, struct mlx5_create_cq_mbox_in **cqb,
> @@ -576,16 +598,16 @@ static void destroy_cq_user(struct mlx5_ib_cq *=
cq, struct ib_ucontext *context)
>  	ib_umem_release(cq->buf.umem);
>  }
> =20
> -static void init_cq_buf(struct mlx5_ib_cq *cq, int nent)
> +static void init_cq_buf(struct mlx5_ib_cq *cq, struct mlx5_ib_cq_buf=
 *buf)
>  {
>  	int i;
>  	void *cqe;
>  	struct mlx5_cqe64 *cqe64;
> =20
> -	for (i =3D 0; i < nent; i++) {
> -		cqe =3D get_cqe(cq, i);
> -		cqe64 =3D (cq->buf.cqe_size =3D=3D 64) ? cqe : cqe + 64;
> -		cqe64->op_own =3D 0xf1;
> +	for (i =3D 0; i < buf->nent; i++) {
> +		cqe =3D get_cqe_from_buf(buf, i, buf->cqe_size);
> +		cqe64 =3D buf->cqe_size =3D=3D 64 ? cqe : cqe + 64;
> +		cqe64->op_own =3D MLX5_CQE_INVALID << 4;
>  	}
>  }
> =20
> @@ -610,7 +632,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *d=
ev, struct mlx5_ib_cq *cq,
>  	if (err)
>  		goto err_db;
> =20
> -	init_cq_buf(cq, entries);
> +	init_cq_buf(cq, &cq->buf);
> =20
>  	*inlen =3D sizeof(**cqb) + sizeof(*(*cqb)->pas) * cq->buf.buf.npage=
s;
>  	*cqb =3D mlx5_vzalloc(*inlen);
> @@ -836,7 +858,7 @@ int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_co=
unt, u16 cq_period)
>  	in->ctx.cq_period =3D cpu_to_be16(cq_period);
>  	in->ctx.cq_max_count =3D cpu_to_be16(cq_count);
>  	in->field_select =3D cpu_to_be32(fsel);
> -	err =3D mlx5_core_modify_cq(&dev->mdev, &mcq->mcq, in);
> +	err =3D mlx5_core_modify_cq(&dev->mdev, &mcq->mcq, in, sizeof(*in))=
;
>  	kfree(in);
> =20
>  	if (err)
> @@ -845,9 +867,235 @@ int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_=
count, u16 cq_period)
>  	return err;
>  }
> =20
> +static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *c=
q,
> +		       int entries, struct ib_udata *udata, int *npas,
> +		       int *page_shift, int *cqe_size)
> +{
> +	struct mlx5_ib_resize_cq ucmd;
> +	struct ib_umem *umem;
> +	int err;
> +	int npages;
> +	struct ib_ucontext *context =3D cq->buf.umem->context;
> +
> +	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
> +		return -EFAULT;
> +

You might also write

         err =3D ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
         if (err)
                 return err;

Then you should check reserved fields being set to the default value:
As noted by Daniel Vetter in its article "Botching up ioctls"[1]
  "Check *all* unused fields and flags and all the padding for whether=20
   it's 0, and reject the ioctl if that's not the case. Otherwise your=20
   nice plan for future extensions is going right down the gutters=20
   since someone *will* submit an ioctl struct with random stack=20
   garbage in the yet unused parts. Which then bakes in the ABI that=20
   those fields can never be used for anything else but garbage."
It's  important to ensure that reserved fields are set to known value,
so that it will be possible to use them latter to extend the ABI.

[1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

         if (ucmd.reserved0 || ucmd.reserved1)
                 return -EINVAL;

> +	umem =3D ib_umem_get(context, ucmd.buf_addr, entries * ucmd.cqe_siz=
e,
> +			   IB_ACCESS_LOCAL_WRITE, 1);
> +	if (IS_ERR(umem)) {
> +		err =3D PTR_ERR(umem);
> +		return err;
> +	}
> +
> +	mlx5_ib_cont_pages(umem, ucmd.buf_addr, &npages, page_shift,
> +			   npas, NULL);
> +
> +	cq->resize_umem =3D umem;
> +	*cqe_size =3D ucmd.cqe_size;
> +
> +	return 0;
> +}
> +


>  int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_uda=
ta *udata)
>  {
> -	return -ENOSYS;
> +	struct mlx5_ib_dev *dev =3D to_mdev(ibcq->device);
> +	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
> +	struct mlx5_modify_cq_mbox_in *in;
> +	int err;
> +	int npas;
> +	int page_shift;
> +	int inlen;
> +	int uninitialized_var(cqe_size);
> +	unsigned long flags;
> +
> +	if (!(dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_RESIZE_CQ)) {
> +		pr_info("Firmware does not support resize CQ\n");
> +		return -ENOSYS;
> +	}
> +
> +	if (entries < 1)
> +		return -EINVAL;
> +
> +	entries =3D roundup_pow_of_two(entries + 1);
> +	if (entries > dev->mdev.caps.max_cqes + 1)
> +		return -EINVAL;
> +
> +	if (entries =3D=3D ibcq->cqe + 1)
> +		return 0;
> +
> +	mutex_lock(&cq->resize_mutex);
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> +	if (udata) {
> +		err =3D resize_user(dev, cq, entries, udata, &npas, &page_shift,
> +				  &cqe_size);
> +	} else {
> +		cqe_size =3D 64;
> +		err =3D resize_kernel(dev, cq, entries, cqe_size);
> +		if (!err) {
> +			npas =3D cq->resize_buf->buf.npages;
> +			page_shift =3D cq->resize_buf->buf.page_shift;
> +		}
> +	}
> +
> +	if (err)
> +		goto ex;
> +
> +	inlen =3D sizeof(*in) + npas * sizeof(in->pas[0]);
> +	in =3D mlx5_vzalloc(inlen);
> +	if (!in) {
> +		err =3D -ENOMEM;
> +		goto ex_resize;
> +	}
> +
> +	if (udata)
> +		mlx5_ib_populate_pas(dev, cq->resize_umem, page_shift,
> +				     in->pas, 0);
> +	else
> +		mlx5_fill_page_array(&cq->resize_buf->buf, in->pas);
> +
> +	in->field_select =3D cpu_to_be32(MLX5_MODIFY_CQ_MASK_LOG_SIZE  |
> +				       MLX5_MODIFY_CQ_MASK_PG_OFFSET |
> +				       MLX5_MODIFY_CQ_MASK_PG_SIZE);
> +	in->ctx.log_pg_sz =3D page_shift - MLX5_ADAPTER_PAGE_SHIFT;
> +	in->ctx.cqe_sz_flags =3D cqe_sz_to_mlx_sz(cqe_size) << 5;
> +	in->ctx.page_offset =3D 0;
> +	in->ctx.log_sz_usr_page =3D cpu_to_be32(ilog2(entries) << 24);
> +	in->hdr.opmod =3D cpu_to_be16(MLX5_CQ_OPMOD_RESIZE);
> +	in->cqn =3D cpu_to_be32(cq->mcq.cqn);
> +
> +	err =3D mlx5_core_modify_cq(&dev->mdev, &cq->mcq, in, inlen);
> +	if (err)
> +		goto ex_alloc;
> +
> +	if (udata) {
> +		cq->ibcq.cqe =3D entries - 1;
> +		ib_umem_release(cq->buf.umem);
> +		cq->buf.umem =3D cq->resize_umem;
> +		cq->resize_umem =3D NULL;
> +	} else {
> +		struct mlx5_ib_cq_buf tbuf;
> +		int resized =3D 0;
> +
> +		spin_lock_irqsave(&cq->lock, flags);
> +		if (cq->resize_buf) {
> +			err =3D copy_resize_cqes(cq);
> +			if (!err) {
> +				tbuf =3D cq->buf;
> +				cq->buf =3D *cq->resize_buf;
> +				kfree(cq->resize_buf);
> +				cq->resize_buf =3D NULL;
> +				resized =3D 1;
> +			}
> +		}
> +		cq->ibcq.cqe =3D entries - 1;
> +		spin_unlock_irqrestore(&cq->lock, flags);
> +		if (resized)
> +			free_cq_buf(dev, &tbuf);
> +	}
> +	mutex_unlock(&cq->resize_mutex);
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Is everything in this section really critical.
=46or example, allocating and setting 'in' structure or releasing the
ressources could probably move outside the mutex protected section ?

> +
> +	mlx5_vfree(in);
> +	return 0;
> +
> +ex_alloc:
> +	mlx5_vfree(in);
> +
> +ex_resize:
> +	if (udata)
> +		un_resize_user(cq);
> +	else
> +		un_resize_kernel(dev, cq);
> +ex:
> +	mutex_unlock(&cq->resize_mutex);
> +	return err;
>  }
> =20

> =20
>=20
>  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_=
cq *cq,
> -			struct mlx5_modify_cq_mbox_in *in)
> +			struct mlx5_modify_cq_mbox_in *in, int in_sz)
                                                            ^^^^^^^^^^

Should probably be 'unsigned' ? size_t ?

>  {
>  	struct mlx5_modify_cq_mbox_out out;
>  	int err;
> =20
>  	memset(&out, 0, sizeof(out));
>  	in->hdr.opcode =3D cpu_to_be16(MLX5_CMD_OP_MODIFY_CQ);
> -	err =3D mlx5_cmd_exec(dev, in, sizeof(*in), &out, sizeof(out));
> +	err =3D mlx5_cmd_exec(dev, in, in_sz, &out, sizeof(out));
>  	if (err)
>  		return err;
> =20
> @@ -158,7 +166,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *de=
v, struct mlx5_core_cq *cq);
>  int mlx5_core_query_cq(struct mlx5_core_dev *dev, struct mlx5_core_c=
q *cq,
>  		       struct mlx5_query_cq_mbox_out *out);
>  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_=
cq *cq,
> -			struct mlx5_modify_cq_mbox_in *in);
> +			struct mlx5_modify_cq_mbox_in *in, int in_sz);
                                                            ^^^^^^^^^^
same here.

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> index dbb03ca..87e2371 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -710,6 +711,7 @@ struct mlx5_modify_cq_mbox_in {
> =20
>  struct mlx5_modify_cq_mbox_out {
>  	struct mlx5_outbox_hdr	hdr;
> +	u8			rsvd[8];
>  };
> =20
>  struct mlx5_enable_hca_mbox_in {
>=20

It not clear why 8 bytes are needed here ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
