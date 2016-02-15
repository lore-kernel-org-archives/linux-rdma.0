From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs] Add QP creation flags, support blocking
 self multicast loopback
Date: Mon, 15 Feb 2016 13:14:37 -0500
Message-ID: <56C2158D.50801@redhat.com>
References: <1455198849-32192-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EXA5sU9eDhSWktKaXs2TpxQufUtLDSTAT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455198849-32192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EXA5sU9eDhSWktKaXs2TpxQufUtLDSTAT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 08:54 AM, Yishai Hadas wrote:
> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add QP creation flags, specifically add a flag to indicate that
> the QP will not receive self multicast loopback traffic.
>=20
> To pass the QP creation flags to the kernel need to add
> ibv_cmd_create_qp_ex2 API which follows the extended scheme
> and uses the CREATE_QP_EX command.
> ibv_cmd_create_qp_ex API doesn't follow the extended scheme,
> it uses the CREATE_QP command and can't be used.

I've been reviewing this patchset and this is just *ugly*.  This seems
like an example of where proper gcc library symbol versions could be
used to avoid this being so ugly.

> To prevent code duplication common code of above 2
> functions was shared.
>=20
> Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Doug,
>=20
> This patch from Eran addressed some issues that we
> found in some extra code review on V0,
> details below.
>=20
> It's sent over previous features for libibverbs
> rereg_mr and memory window that are pending your
> merge.
>=20
> Patch can be taken also from my public GIT=20
> at openfabrics.
>=20
> git://openfabrics.org/~yishaih/libibverbs.git
>=20
> branch: for-upstream. (on top of previous features)
> branch: mc_loopback_prev (on top of master)
>=20
> Yishai
> =20
> Change from v0:
> - Improve commit message.
> - Drop some redundant code at ibv_cmd_create_qp_ex2.
> - Fix error checking as part of ibv_cmd_create_qp_ex.
>=20
>=20
>  include/infiniband/driver.h   |   9 ++
>  include/infiniband/kern-abi.h |  53 ++++++++----
>  include/infiniband/verbs.h    |   9 +-
>  src/cmd.c                     | 194 +++++++++++++++++++++++++++++-----=
--------
>  src/libibverbs.map            |   1 +
>  5 files changed, 193 insertions(+), 73 deletions(-)
>=20
> diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
> index 1b0802d..053ad5f 100644
> --- a/include/infiniband/driver.h
> +++ b/include/infiniband/driver.h
> @@ -190,6 +190,15 @@ int ibv_cmd_create_qp_ex(struct ibv_context *conte=
xt,
>  			 struct ibv_qp_init_attr_ex *attr_ex,
>  			 struct ibv_create_qp *cmd, size_t cmd_size,
>  			 struct ibv_create_qp_resp *resp, size_t resp_size);
> +int ibv_cmd_create_qp_ex2(struct ibv_context *context,
> +			  struct verbs_qp *qp, int vqp_sz,
> +			  struct ibv_qp_init_attr_ex *qp_attr,
> +			  struct ibv_create_qp_ex *cmd,
> +			  size_t cmd_core_size,
> +			  size_t cmd_size,
> +			  struct ibv_create_qp_resp_ex *resp,
> +			  size_t resp_core_size,
> +			  size_t resp_size);
>  int ibv_cmd_open_qp(struct ibv_context *context,
>  		    struct verbs_qp *qp,  int vqp_sz,
>  		    struct ibv_qp_open_attr *attr,
> diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-ab=
i.h
> index d4ef58e..31da4be 100644
> --- a/include/infiniband/kern-abi.h
> +++ b/include/infiniband/kern-abi.h
> @@ -110,6 +110,8 @@ enum {
>  enum {
>  	IB_USER_VERBS_CMD_QUERY_DEVICE_EX =3D IB_USER_VERBS_CMD_EXTENDED_MASK=
 |
>  					    IB_USER_VERBS_CMD_QUERY_DEVICE,
> +	IB_USER_VERBS_CMD_CREATE_QP_EX =3D IB_USER_VERBS_CMD_EXTENDED_MASK |
> +					 IB_USER_VERBS_CMD_CREATE_QP,
>  	IB_USER_VERBS_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_EXTENDED_MASK +
>  					IB_USER_VERBS_CMD_THRESHOLD,
>  	IB_USER_VERBS_CMD_DESTROY_FLOW
> @@ -570,28 +572,35 @@ struct ibv_kern_qp_attr {
>  	__u8	reserved[5];
>  };
> =20
> +#define IBV_CREATE_QP_COMMON	\
> +	__u64 user_handle;	\
> +	__u32 pd_handle;	\
> +	__u32 send_cq_handle;	\
> +	__u32 recv_cq_handle;	\
> +	__u32 srq_handle;	\
> +	__u32 max_send_wr;	\
> +	__u32 max_recv_wr;	\
> +	__u32 max_send_sge;	\
> +	__u32 max_recv_sge;	\
> +	__u32 max_inline_data;	\
> +	__u8  sq_sig_all;	\
> +	__u8  qp_type;		\
> +	__u8  is_srq;		\
> +	__u8  reserved
> +
>  struct ibv_create_qp {
>  	__u32 command;
>  	__u16 in_words;
>  	__u16 out_words;
>  	__u64 response;
> -	__u64 user_handle;
> -	__u32 pd_handle;
> -	__u32 send_cq_handle;
> -	__u32 recv_cq_handle;
> -	__u32 srq_handle;
> -	__u32 max_send_wr;
> -	__u32 max_recv_wr;
> -	__u32 max_send_sge;
> -	__u32 max_recv_sge;
> -	__u32 max_inline_data;
> -	__u8  sq_sig_all;
> -	__u8  qp_type;
> -	__u8  is_srq;
> -	__u8  reserved;
> +	IBV_CREATE_QP_COMMON;
>  	__u64 driver_data[0];
>  };
> =20
> +struct ibv_create_qp_common {
> +	IBV_CREATE_QP_COMMON;
> +};
> +
>  struct ibv_open_qp {
>  	__u32 command;
>  	__u16 in_words;
> @@ -617,6 +626,19 @@ struct ibv_create_qp_resp {
>  	__u32 reserved;
>  };
> =20
> +struct ibv_create_qp_ex {
> +	struct ex_hdr	hdr;
> +	struct ibv_create_qp_common base;
> +	__u32 comp_mask;
> +	__u32 create_flags;
> +};
> +
> +struct ibv_create_qp_resp_ex {
> +	struct ibv_create_qp_resp base;
> +	__u32 comp_mask;
> +	__u32 response_length;
> +};
> +
>  struct ibv_qp_dest {
>  	__u8  dgid[16];
>  	__u32 flow_label;
> @@ -1074,7 +1096,8 @@ enum {
>  	IB_USER_VERBS_CMD_OPEN_QP_V2 =3D -1,
>  	IB_USER_VERBS_CMD_CREATE_FLOW_V2 =3D -1,
>  	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 =3D -1,
> -	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 =3D -1
> +	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 =3D -1,
> +	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 =3D -1,
>  };
> =20
>  struct ibv_modify_srq_v3 {
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 8eb1f08..6451d0f 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -600,7 +600,12 @@ struct ibv_qp_init_attr {
>  enum ibv_qp_init_attr_mask {
>  	IBV_QP_INIT_ATTR_PD		=3D 1 << 0,
>  	IBV_QP_INIT_ATTR_XRCD		=3D 1 << 1,
> -	IBV_QP_INIT_ATTR_RESERVED	=3D 1 << 2
> +	IBV_QP_INIT_ATTR_CREATE_FLAGS  =3D 1 << 2,
> +	IBV_QP_INIT_ATTR_RESERVED	=3D 1 << 3
> +};
> +
> +enum ibv_qp_create_flags {
> +	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       =3D 1 << 1,
>  };
> =20
>  struct ibv_qp_init_attr_ex {
> @@ -615,6 +620,8 @@ struct ibv_qp_init_attr_ex {
>  	uint32_t		comp_mask;
>  	struct ibv_pd	       *pd;
>  	struct ibv_xrcd	       *xrcd;
> +	uint32_t                create_flags;
> +
>  };
> =20
>  enum ibv_qp_open_attr_mask {
> diff --git a/src/cmd.c b/src/cmd.c
> index 9aa072e..b8c51ce 100644
> --- a/src/cmd.c
> +++ b/src/cmd.c
> @@ -743,6 +743,135 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
>  	return 0;
>  }
> =20
> +static int create_qp_ex_common(struct verbs_qp *qp,
> +			       struct ibv_qp_init_attr_ex *qp_attr,
> +			       struct verbs_xrcd *vxrcd,
> +			       struct ibv_create_qp_common *cmd)
> +{
> +	cmd->user_handle =3D (uintptr_t)qp;
> +
> +	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
> +		vxrcd =3D container_of(qp_attr->xrcd, struct verbs_xrcd, xrcd);
> +		cmd->pd_handle	=3D vxrcd->handle;
> +	} else {
> +		if (!(qp_attr->comp_mask & IBV_QP_INIT_ATTR_PD))
> +			return EINVAL;
> +
> +		cmd->pd_handle	=3D qp_attr->pd->handle;
> +		cmd->send_cq_handle =3D qp_attr->send_cq->handle;
> +
> +		if (qp_attr->qp_type !=3D IBV_QPT_XRC_SEND) {
> +			cmd->recv_cq_handle =3D qp_attr->recv_cq->handle;
> +			cmd->srq_handle =3D qp_attr->srq ? qp_attr->srq->handle :
> +							 0;
> +		}
> +	}
> +
> +	cmd->max_send_wr     =3D qp_attr->cap.max_send_wr;
> +	cmd->max_recv_wr     =3D qp_attr->cap.max_recv_wr;
> +	cmd->max_send_sge    =3D qp_attr->cap.max_send_sge;
> +	cmd->max_recv_sge    =3D qp_attr->cap.max_recv_sge;
> +	cmd->max_inline_data =3D qp_attr->cap.max_inline_data;
> +	cmd->sq_sig_all	     =3D qp_attr->sq_sig_all;
> +	cmd->qp_type         =3D qp_attr->qp_type;
> +	cmd->is_srq	     =3D !!qp_attr->srq;
> +	cmd->reserved	     =3D 0;
> +
> +	return 0;
> +}
> +
> +static void create_qp_handle_resp_common(struct ibv_context *context,
> +					 struct verbs_qp *qp,
> +					 struct ibv_qp_init_attr_ex *qp_attr,
> +					 struct ibv_create_qp_resp *resp,
> +					 struct verbs_xrcd *vxrcd,
> +					 int vqp_sz)
> +{
> +	if (abi_ver > 3) {
> +		qp_attr->cap.max_recv_sge    =3D resp->max_recv_sge;
> +		qp_attr->cap.max_send_sge    =3D resp->max_send_sge;
> +		qp_attr->cap.max_recv_wr     =3D resp->max_recv_wr;
> +		qp_attr->cap.max_send_wr     =3D resp->max_send_wr;
> +		qp_attr->cap.max_inline_data =3D resp->max_inline_data;
> +	}
> +
> +	qp->qp.handle		=3D resp->qp_handle;
> +	qp->qp.qp_num		=3D resp->qpn;
> +	qp->qp.context		=3D context;
> +	qp->qp.qp_context	=3D qp_attr->qp_context;
> +	qp->qp.pd		=3D qp_attr->pd;
> +	qp->qp.send_cq		=3D qp_attr->send_cq;
> +	qp->qp.recv_cq		=3D qp_attr->recv_cq;
> +	qp->qp.srq		=3D qp_attr->srq;
> +	qp->qp.qp_type		=3D qp_attr->qp_type;
> +	qp->qp.state		=3D IBV_QPS_RESET;
> +	qp->qp.events_completed =3D 0;
> +	pthread_mutex_init(&qp->qp.mutex, NULL);
> +	pthread_cond_init(&qp->qp.cond, NULL);
> +
> +	qp->comp_mask =3D 0;
> +	if (vext_field_avail(struct verbs_qp, xrcd, vqp_sz) &&
> +	    (qp_attr->comp_mask & IBV_QP_INIT_ATTR_XRCD)) {
> +		qp->comp_mask |=3D VERBS_QP_XRCD;
> +		qp->xrcd =3D vxrcd;
> +	}
> +}
> +
> +enum {
> +	CREATE_QP_EX2_SUP_CREATE_FLAGS =3D IBV_QP_CREATE_BLOCK_SELF_MCAST_LB,=

> +};
> +
> +int ibv_cmd_create_qp_ex2(struct ibv_context *context,
> +			  struct verbs_qp *qp, int vqp_sz,
> +			  struct ibv_qp_init_attr_ex *qp_attr,
> +			  struct ibv_create_qp_ex *cmd,
> +			  size_t cmd_core_size,
> +			  size_t cmd_size,
> +			  struct ibv_create_qp_resp_ex *resp,
> +			  size_t resp_core_size,
> +			  size_t resp_size)
> +{
> +	struct verbs_xrcd *vxrcd =3D NULL;
> +	int err;
> +
> +	if (qp_attr->comp_mask >=3D IBV_QP_INIT_ATTR_RESERVED)
> +		return EINVAL;
> +
> +	if (resp_core_size <
> +	    offsetof(struct ibv_create_qp_resp_ex, response_length) +
> +	    sizeof(resp->response_length))
> +		return EINVAL;
> +
> +	memset(cmd, 0, cmd_core_size);
> +
> +	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_QP_EX, re=
sp,
> +			       resp_core_size, resp_size);
> +
> +	err =3D create_qp_ex_common(qp, qp_attr, vxrcd, &cmd->base);
> +	if (err)
> +		return err;
> +
> +	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_CREATE_FLAGS) {
> +		if (qp_attr->create_flags & ~CREATE_QP_EX2_SUP_CREATE_FLAGS)
> +			return EINVAL;
> +		if (cmd_core_size < offsetof(struct ibv_create_qp_ex, create_flags) =
+
> +				    sizeof(qp_attr->create_flags))
> +			return EINVAL;
> +		cmd->create_flags =3D qp_attr->create_flags;
> +	}
> +
> +	err =3D write(context->cmd_fd, cmd, cmd_size);
> +	if (err !=3D cmd_size)
> +		return errno;
> +
> +	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
> +
> +	create_qp_handle_resp_common(context, qp, qp_attr, &resp->base, vxrcd=
,
> +				     vqp_sz);
> +
> +	return 0;
> +}
> +
>  int ibv_cmd_create_qp_ex(struct ibv_context *context,
>  			 struct verbs_qp *qp, int vqp_sz,
>  			 struct ibv_qp_init_attr_ex *attr_ex,
> @@ -750,52 +879,22 @@ int ibv_cmd_create_qp_ex(struct ibv_context *cont=
ext,
>  			 struct ibv_create_qp_resp *resp, size_t resp_size)
>  {
>  	struct verbs_xrcd *vxrcd =3D NULL;
> +	int err;
> =20
>  	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
> =20
> -	if (attr_ex->comp_mask >=3D IBV_QP_INIT_ATTR_RESERVED)
> +	if (attr_ex->comp_mask > (IBV_QP_INIT_ATTR_XRCD | IBV_QP_INIT_ATTR_PD=
))
>  		return ENOSYS;
> =20
> -	cmd->user_handle     =3D (uintptr_t) qp;
> -
> -	if (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD) {
> -		vxrcd =3D container_of(attr_ex->xrcd, struct verbs_xrcd, xrcd);
> -		cmd->pd_handle	=3D vxrcd->handle;
> -	} else {
> -		if (!(attr_ex->comp_mask & IBV_QP_INIT_ATTR_PD))
> -			return EINVAL;
> -
> -		cmd->pd_handle	=3D attr_ex->pd->handle;
> -		cmd->send_cq_handle =3D attr_ex->send_cq->handle;
> -
> -		if (attr_ex->qp_type !=3D IBV_QPT_XRC_SEND) {
> -			cmd->recv_cq_handle =3D attr_ex->recv_cq->handle;
> -			cmd->srq_handle =3D attr_ex->srq ? attr_ex->srq->handle : 0;
> -		}
> -	}
> -
> -	cmd->max_send_wr     =3D attr_ex->cap.max_send_wr;
> -	cmd->max_recv_wr     =3D attr_ex->cap.max_recv_wr;
> -	cmd->max_send_sge    =3D attr_ex->cap.max_send_sge;
> -	cmd->max_recv_sge    =3D attr_ex->cap.max_recv_sge;
> -	cmd->max_inline_data =3D attr_ex->cap.max_inline_data;
> -	cmd->sq_sig_all	     =3D attr_ex->sq_sig_all;
> -	cmd->qp_type         =3D attr_ex->qp_type;
> -	cmd->is_srq	     =3D !!attr_ex->srq;
> -	cmd->reserved	     =3D 0;
> +	err =3D create_qp_ex_common(qp, attr_ex, vxrcd,
> +				  (struct ibv_create_qp_common *)&cmd->user_handle);
> +	if (err)
> +		return err;
> =20
>  	if (write(context->cmd_fd, cmd, cmd_size) !=3D cmd_size)
>  		return errno;
> =20
> -	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
> -
> -	if (abi_ver > 3) {
> -		attr_ex->cap.max_recv_sge    =3D resp->max_recv_sge;
> -		attr_ex->cap.max_send_sge    =3D resp->max_send_sge;
> -		attr_ex->cap.max_recv_wr     =3D resp->max_recv_wr;
> -		attr_ex->cap.max_send_wr     =3D resp->max_send_wr;
> -		attr_ex->cap.max_inline_data =3D resp->max_inline_data;
> -	}
> +	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
> =20
>  	if (abi_ver =3D=3D 4) {
>  		struct ibv_create_qp_resp_v4 *resp_v4 =3D
> @@ -813,26 +912,7 @@ int ibv_cmd_create_qp_ex(struct ibv_context *conte=
xt,
>  			resp_size - sizeof *resp);
>  	}
> =20
> -	qp->qp.handle		=3D resp->qp_handle;
> -	qp->qp.qp_num		=3D resp->qpn;
> -	qp->qp.context		=3D context;
> -	qp->qp.qp_context	=3D attr_ex->qp_context;
> -	qp->qp.pd		=3D attr_ex->pd;
> -	qp->qp.send_cq		=3D attr_ex->send_cq;
> -	qp->qp.recv_cq		=3D attr_ex->recv_cq;
> -	qp->qp.srq		=3D attr_ex->srq;
> -	qp->qp.qp_type		=3D attr_ex->qp_type;
> -	qp->qp.state		=3D IBV_QPS_RESET;
> -	qp->qp.events_completed =3D 0;
> -	pthread_mutex_init(&qp->qp.mutex, NULL);
> -	pthread_cond_init(&qp->qp.cond, NULL);
> -
> -	qp->comp_mask =3D 0;
> -	if (vext_field_avail(struct verbs_qp, xrcd, vqp_sz) &&
> -			    (attr_ex->comp_mask & IBV_QP_INIT_ATTR_XRCD)) {
> -		qp->comp_mask |=3D VERBS_QP_XRCD;
> -		qp->xrcd =3D vxrcd;
> -	}
> +	create_qp_handle_resp_common(context, qp, attr_ex, resp, vxrcd, vqp_s=
z);
> =20
>  	return 0;
>  }
> diff --git a/src/libibverbs.map b/src/libibverbs.map
> index d934b50..a150416 100644
> --- a/src/libibverbs.map
> +++ b/src/libibverbs.map
> @@ -114,6 +114,7 @@ IBVERBS_1.1 {
>  		ibv_cmd_close_xrcd;
>  		ibv_cmd_create_srq_ex;
>  		ibv_cmd_create_qp_ex;
> +		ibv_cmd_create_qp_ex2;
>  		ibv_cmd_open_qp;
>  		ibv_cmd_rereg_mr;
> =20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--EXA5sU9eDhSWktKaXs2TpxQufUtLDSTAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWwhWOAAoJELgmozMOVy/dBdAQAJtZJ0/kfMSf3BjPOYboarSG
DFoJY9xDZqsnG6tGvQiLQkkRsO/rQRgHqYy8uALTJdXeOxiZQEyLwaavPNgDBow+
Afdr8FyAPk1Mg7buZUgkvlP0CKg5kRvVzk8i60b9pE1sTrFg6b/X4jMfMegTwcC0
1lL6mjiFh35ndoPyKLR7A+FFm0YYQ5WqH7ShNpRHhc/gTzC6vFtASZu3Pkr2lGdl
zUQktqbW8PbaGPZvpHal4vjoCLOEQob69HdB359Vj/+vO08LIwKAP7+gvtNkvJ07
pyek/XpihsaUzbW2MYJFVm2lYOoOo/fFK4M5BL8aSb2WAtKxYOMGDQJJpzzevuwJ
+I7ZTDO9n8xiHZOiFU9wHCsIUlDjtrFzbfIEGb0xxz6UjqXrXT2gtQg7Uv/h4v74
8veULA71sAO9huAsmPq8pSAZgMmffSaUZ4S5J6uzdoNxgeLmc83g0z6V+55fxX82
PXwhqg21MRcLyK8XZufZNTCkRvJcff5DrRfryZ9yy9Bq5xgy4plKZdbMlD1/kt8Q
Ak4jODcfbWQeAvRnMyMbjWB1qLvknawoCUVhLrSXcPXZ55ZWff4dHGz39GDB3b0G
GLymignXa/UGi0hMNbGRJQK84LFUjiTjA9El/ajLxyc1MyWYk1syM7J1YQd9G/+x
PTIVmgfqzt6nM9+SkpTV
=I7tU
-----END PGP SIGNATURE-----

--EXA5sU9eDhSWktKaXs2TpxQufUtLDSTAT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
