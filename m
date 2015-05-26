From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-BUmcmmAb0Fc@public.gmane.org>
Subject: Re: [PATCH] libmlx5: Implement missing open_qp verb
Date: Tue, 26 May 2015 18:48:10 +0200
Message-ID: <20150526184810.1f703414@dingo>
References: <20150518110249.33fb161d@dingo>
	<1432655263.28905.115.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432655263.28905.115.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-BUmcmmAb0Fc@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Doug,

On Tue, 26 May 2015 11:47:43 -0400
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 2015-05-18 at 11:02 +0200, S=C3=A9bastien Dugu=C3=A9 wrote:
> >   Commit 0c7ac1083831 added XRC support for mlx5, however this is m=
issing
> > the open_qp verb.
> >=20
> > Signed-off-by: S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
>=20
> Patch looks reasonable.  However, I didn't review it to make sure tha=
t
> it interacts with other libmlx5 internals properly, just for the obvi=
ous
> things (locks handled properly, proper error unwind, etc).  I'm assum=
ing
> Eli will process this, for now I'm removing it from patchworks (Eli
> isn't listed as a maintainer there so he can't remove it, which
> highlights one of the difficulties of this list being used for both
> kernel and user space patches...there are lots of user space maintain=
ers
> and most of them aren't list as such in patchworks).

  Yep, I was hoping for Eli to acknowledge it one way or the other, but=
 still
no news so far.

  Thanks.

  S=C3=A9bastien.

>=20
> > ---
> >  src/mlx5.c  |  1 +
> >  src/mlx5.h  |  2 ++
> >  src/verbs.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 41 insertions(+)
> >=20
> > diff --git a/src/mlx5.c b/src/mlx5.c
> > index d02328881992..39f59975d3d2 100644
> > --- a/src/mlx5.c
> > +++ b/src/mlx5.c
> > @@ -579,6 +579,7 @@ static int mlx5_init_context(struct verbs_devic=
e *vdev,
> >  	context->ibv_ctx.ops =3D mlx5_ctx_ops;
> > =20
> >  	verbs_set_ctx_op(v_ctx, create_qp_ex, mlx5_create_qp_ex);
> > +	verbs_set_ctx_op(v_ctx, open_qp, mlx5_open_qp);
> >  	verbs_set_ctx_op(v_ctx, open_xrcd, mlx5_open_xrcd);
> >  	verbs_set_ctx_op(v_ctx, close_xrcd, mlx5_close_xrcd);
> >  	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
> > diff --git a/src/mlx5.h b/src/mlx5.h
> > index 6ad79fe324d3..f548e51ee338 100644
> > --- a/src/mlx5.h
> > +++ b/src/mlx5.h
> > @@ -613,6 +613,8 @@ void *mlx5_get_send_wqe(struct mlx5_qp *qp, int=
 n);
> >  int mlx5_copy_to_recv_wqe(struct mlx5_qp *qp, int idx, void *buf, =
int size);
> >  int mlx5_copy_to_send_wqe(struct mlx5_qp *qp, int idx, void *buf, =
int size);
> >  int mlx5_copy_to_recv_srq(struct mlx5_srq *srq, int idx, void *buf=
, int size);
> > +struct ibv_qp *mlx5_open_qp(struct ibv_context *context,
> > +			    struct ibv_qp_open_attr *attr);
> >  struct ibv_xrcd *mlx5_open_xrcd(struct ibv_context *context,
> >  				struct ibv_xrcd_init_attr *xrcd_init_attr);
> >  int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num);
> > diff --git a/src/verbs.c b/src/verbs.c
> > index 8ddf4e631c9f..dc899bce4e00 100644
> > --- a/src/verbs.c
> > +++ b/src/verbs.c
> > @@ -1122,6 +1122,44 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct=
 ibv_qp_attr *attr,
> >  	return ret;
> >  }
> > =20
> > +struct ibv_qp *mlx5_open_qp(struct ibv_context *context,
> > +			    struct ibv_qp_open_attr *attr)
> > +{
> > +	struct ibv_open_qp cmd;
> > +	struct ibv_create_qp_resp resp;
> > +	struct mlx5_qp *qp;
> > +	int ret;
> > +	struct mlx5_context *ctx =3D to_mctx(context);
> > +
> > +	qp =3D calloc(1, sizeof(*qp));
> > +
> > +	if (!qp)
> > +		return NULL;
> > +
> > +	ret =3D ibv_cmd_open_qp(context, &qp->verbs_qp, sizeof(qp->verbs_=
qp),
> > +			      attr, &cmd, sizeof(cmd), &resp, sizeof(resp));
> > +	if (ret)
> > +		goto err;
> > +
> > +	pthread_mutex_lock(&ctx->qp_table_mutex);
> > +	ret =3D mlx5_store_qp(ctx, qp->verbs_qp.qp.qp_num, qp);
> > +
> > +	if (ret) {
> > +		pthread_mutex_unlock(&ctx->qp_table_mutex);
> > +		fprintf(stderr, "mlx5_store_qp failed ret=3D%d\n", ret);
> > +		goto destroy;
> > +	}
> > +	pthread_mutex_unlock(&ctx->qp_table_mutex);
> > +
> > +	return (struct ibv_qp *)&qp->verbs_qp;
> > +
> > +destroy:
> > +	ibv_cmd_destroy_qp(&qp->verbs_qp.qp);
> > +err:
> > +	free(qp);
> > +	return NULL;
> > +}
> > +
> >  struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_att=
r *attr)
> >  {
> >  	struct mlx5_ah *ah;
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
