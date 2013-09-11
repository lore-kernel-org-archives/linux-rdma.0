From: meuh-zgzEX58YAwA@public.gmane.org
Subject: Re: [PATCH V4 7/9] IB/core: Add RoCE IP based addressing extensions
 for uverbs
Date: Wed, 11 Sep 2013 12:06:49 +0200
Message-ID: <6d494aa8d403e0c50b16f09fbd2c3ab6@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-8-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378824099-22150-8-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 10.09.2013 16:41, Or Gerlitz a =C3=A9crit=C2=A0:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add uverbs support for RoCE (IBoE) IP based addressing extensions
> towards user space libraries.
>=20
> Under ip based gid addressing, for RC QPs, QP attributes should conta=
in=20
> the
> Ethernet L2 destination. Until now, indicatings GID was sufficient.=20
> When
> using ip encoded in gids, the QP attributes should contain extended=20
> destination,
> indicating vlan and dmac as well. This is done via a new struct
> ib_uverbs_qp_dest_ex.
> This new structure is contained in a new struct ib_uverbs_modify_qp_e=
x=20
> that is
> used by MODIFY_QP_EX command. In order to make those changes=20
> seamlessly, those
> extended structures were added in the bottom of the current structure=
s.
> The new command also gets smac/alt_smac/vlan_id/alt_vlan_id. Those=20
> parameters
> are fixed in the QP context in order to enhance security.
> The extended dest is used a a pointer rather than as a inline fixed=20
> field
> in the sake of future scalability.
>=20
> Also, when the gid encodes ip address, the AH attributes should conta=
in=20
> also
> dmac. Therefore, ib_uverbs_create_ah was extended to contain those=20
> fields.
> When creating an AH, the user indicates the exact L2 ethernet=20
> destination
> parameters. This is done by a new CREATE_AH_EX command that uses a ne=
w=20
> struct
> ib_uverbs_create_ah_ex.
>=20
> struct ib_user_path_rec was extended too, to contain source and=20
> destination
> MAC and VLAN ID, this structure is of use by the rdma_ucm driver.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h          |    2 +
>  drivers/infiniband/core/uverbs_cmd.c      |  359=20
> ++++++++++++++++++++++-------
>  drivers/infiniband/core/uverbs_main.c     |    4 +-
>  drivers/infiniband/core/uverbs_marshall.c |  128 ++++++++++-
>  include/rdma/ib_marshall.h                |   12 +
>  include/uapi/rdma/ib_user_sa.h            |   34 +++-
>  include/uapi/rdma/ib_user_verbs.h         |  160 +++++++++++++-
>  7 files changed, 608 insertions(+), 91 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs.h=20
> b/drivers/infiniband/core/uverbs.h
> index d040b87..b0fcb0b 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -202,11 +202,13 @@ IB_UVERBS_DECLARE_CMD(create_qp);
>  IB_UVERBS_DECLARE_CMD(open_qp);
>  IB_UVERBS_DECLARE_CMD(query_qp);
>  IB_UVERBS_DECLARE_CMD(modify_qp);
> +IB_UVERBS_DECLARE_CMD(modify_qp_ex);
>  IB_UVERBS_DECLARE_CMD(destroy_qp);
>  IB_UVERBS_DECLARE_CMD(post_send);
>  IB_UVERBS_DECLARE_CMD(post_recv);
>  IB_UVERBS_DECLARE_CMD(post_srq_recv);
>  IB_UVERBS_DECLARE_CMD(create_ah);
> +IB_UVERBS_DECLARE_CMD(create_ah_ex);
>  IB_UVERBS_DECLARE_CMD(destroy_ah);
>  IB_UVERBS_DECLARE_CMD(attach_mcast);
>  IB_UVERBS_DECLARE_CMD(detach_mcast);
> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index f2b81b9..9a0c5d7 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1900,6 +1900,60 @@ static int modify_qp_mask(enum ib_qp_type
> qp_type, int mask)
>  	}
>  }
>=20
> +static void ib_uverbs_modify_qp_assign(struct ib_uverbs_modify_qp=20
> *cmd,
> +				       struct ib_qp_attr *attr,
> +				       struct ib_uverbs_qp_dest *dest,
> +				       struct ib_uverbs_qp_dest *alt_dest) {
> +	attr->qp_state		  =3D cmd->qp_state;
> +	attr->cur_qp_state	  =3D cmd->cur_qp_state;
> +	attr->path_mtu		  =3D cmd->path_mtu;
> +	attr->path_mig_state	  =3D cmd->path_mig_state;
> +	attr->qkey		  =3D cmd->qkey;
> +	attr->rq_psn		  =3D cmd->rq_psn;
> +	attr->sq_psn		  =3D cmd->sq_psn;
> +	attr->dest_qp_num	  =3D cmd->dest_qp_num;
> +	attr->qp_access_flags	  =3D cmd->qp_access_flags;
> +	attr->pkey_index	  =3D cmd->pkey_index;
> +	attr->alt_pkey_index	  =3D cmd->alt_pkey_index;
> +	attr->en_sqd_async_notify =3D cmd->en_sqd_async_notify;
> +	attr->max_rd_atomic	  =3D cmd->max_rd_atomic;
> +	attr->max_dest_rd_atomic  =3D cmd->max_dest_rd_atomic;
> +	attr->min_rnr_timer	  =3D cmd->min_rnr_timer;
> +	attr->port_num		  =3D cmd->port_num;
> +	attr->timeout		  =3D cmd->timeout;
> +	attr->retry_cnt		  =3D cmd->retry_cnt;
> +	attr->rnr_retry		  =3D cmd->rnr_retry;
> +	attr->alt_port_num	  =3D cmd->alt_port_num;
> +	attr->alt_timeout	  =3D cmd->alt_timeout;
> +
> +	memcpy(attr->ah_attr.grh.dgid.raw, dest->dgid, 16);
> +	attr->ah_attr.grh.flow_label        =3D dest->flow_label;
> +	attr->ah_attr.grh.sgid_index        =3D dest->sgid_index;
> +	attr->ah_attr.grh.hop_limit         =3D dest->hop_limit;
> +	attr->ah_attr.grh.traffic_class     =3D dest->traffic_class;
> +	attr->ah_attr.dlid		    =3D dest->dlid;
> +	attr->ah_attr.sl		    =3D dest->sl;
> +	attr->ah_attr.src_path_bits	    =3D dest->src_path_bits;
> +	attr->ah_attr.static_rate	    =3D dest->static_rate;
> +	attr->ah_attr.ah_flags		    =3D dest->is_global ?
> +					      IB_AH_GRH : 0;
> +	attr->ah_attr.port_num		    =3D dest->port_num;
> +
> +	memcpy(attr->alt_ah_attr.grh.dgid.raw, alt_dest->dgid, 16);
> +	attr->alt_ah_attr.grh.flow_label    =3D alt_dest->flow_label;
> +	attr->alt_ah_attr.grh.sgid_index    =3D alt_dest->sgid_index;
> +	attr->alt_ah_attr.grh.hop_limit     =3D alt_dest->hop_limit;
> +	attr->alt_ah_attr.grh.traffic_class =3D alt_dest->traffic_class;
> +	attr->alt_ah_attr.dlid		    =3D alt_dest->dlid;
> +	attr->alt_ah_attr.sl		    =3D alt_dest->sl;
> +	attr->alt_ah_attr.src_path_bits     =3D alt_dest->src_path_bits;
> +	attr->alt_ah_attr.static_rate       =3D alt_dest->static_rate;
> +	attr->alt_ah_attr.ah_flags	    =3D alt_dest->is_global
> +					      ? IB_AH_GRH : 0;
> +	attr->alt_ah_attr.port_num	    =3D alt_dest->port_num;
> +}
> +
> +
>  ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
>  			    const char __user *buf, int in_len,
>  			    int out_len)
> @@ -1926,51 +1980,13 @@ ssize_t ib_uverbs_modify_qp(struct=20
> ib_uverbs_file *file,
>  		goto out;
>  	}
>=20
> -	attr->qp_state 		  =3D cmd.qp_state;
> -	attr->cur_qp_state 	  =3D cmd.cur_qp_state;
> -	attr->path_mtu 		  =3D cmd.path_mtu;
> -	attr->path_mig_state 	  =3D cmd.path_mig_state;
> -	attr->qkey 		  =3D cmd.qkey;
> -	attr->rq_psn 		  =3D cmd.rq_psn;
> -	attr->sq_psn 		  =3D cmd.sq_psn;
> -	attr->dest_qp_num 	  =3D cmd.dest_qp_num;
> -	attr->qp_access_flags 	  =3D cmd.qp_access_flags;
> -	attr->pkey_index 	  =3D cmd.pkey_index;
> -	attr->alt_pkey_index 	  =3D cmd.alt_pkey_index;
> -	attr->en_sqd_async_notify =3D cmd.en_sqd_async_notify;
> -	attr->max_rd_atomic 	  =3D cmd.max_rd_atomic;
> -	attr->max_dest_rd_atomic  =3D cmd.max_dest_rd_atomic;
> -	attr->min_rnr_timer 	  =3D cmd.min_rnr_timer;
> -	attr->port_num 		  =3D cmd.port_num;
> -	attr->timeout 		  =3D cmd.timeout;
> -	attr->retry_cnt 	  =3D cmd.retry_cnt;
> -	attr->rnr_retry 	  =3D cmd.rnr_retry;
> -	attr->alt_port_num 	  =3D cmd.alt_port_num;
> -	attr->alt_timeout 	  =3D cmd.alt_timeout;
> -
> -	memcpy(attr->ah_attr.grh.dgid.raw, cmd.dest.dgid, 16);
> -	attr->ah_attr.grh.flow_label        =3D cmd.dest.flow_label;
> -	attr->ah_attr.grh.sgid_index        =3D cmd.dest.sgid_index;
> -	attr->ah_attr.grh.hop_limit         =3D cmd.dest.hop_limit;
> -	attr->ah_attr.grh.traffic_class     =3D cmd.dest.traffic_class;
> -	attr->ah_attr.dlid 	    	    =3D cmd.dest.dlid;
> -	attr->ah_attr.sl   	    	    =3D cmd.dest.sl;
> -	attr->ah_attr.src_path_bits 	    =3D cmd.dest.src_path_bits;
> -	attr->ah_attr.static_rate   	    =3D cmd.dest.static_rate;
> -	attr->ah_attr.ah_flags 	    	    =3D cmd.dest.is_global ? IB_AH_GRH=
 :=20
> 0;
> -	attr->ah_attr.port_num 	    	    =3D cmd.dest.port_num;
> -
> -	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd.alt_dest.dgid, 16);
> -	attr->alt_ah_attr.grh.flow_label    =3D cmd.alt_dest.flow_label;
> -	attr->alt_ah_attr.grh.sgid_index    =3D cmd.alt_dest.sgid_index;
> -	attr->alt_ah_attr.grh.hop_limit     =3D cmd.alt_dest.hop_limit;
> -	attr->alt_ah_attr.grh.traffic_class =3D cmd.alt_dest.traffic_class;
> -	attr->alt_ah_attr.dlid 	    	    =3D cmd.alt_dest.dlid;
> -	attr->alt_ah_attr.sl   	    	    =3D cmd.alt_dest.sl;
> -	attr->alt_ah_attr.src_path_bits     =3D cmd.alt_dest.src_path_bits;
> -	attr->alt_ah_attr.static_rate       =3D cmd.alt_dest.static_rate;
> -	attr->alt_ah_attr.ah_flags 	    =3D cmd.alt_dest.is_global ? IB_AH_=
GRH=20
> : 0;
> -	attr->alt_ah_attr.port_num 	    =3D cmd.alt_dest.port_num;
> +	ib_uverbs_modify_qp_assign(&cmd, attr, &cmd.dest, &cmd.alt_dest);
> +	memset(attr->ah_attr.dmac, 0, sizeof(attr->ah_attr.dmac));
> +	attr->vlan_id =3D 0xFFFF;
> +	memset(attr->smac, 0, sizeof(attr->smac));
> +	memset(attr->alt_ah_attr.dmac, 0, sizeof(attr->alt_ah_attr.dmac));
> +	attr->alt_vlan_id =3D 0xFFFF;
> +	memset(attr->alt_smac, 0, sizeof(attr->alt_smac));
>=20
>  	if (qp->real_qp =3D=3D qp) {
>  		ret =3D qp->device->modify_qp(qp, attr,
> @@ -1992,6 +2008,111 @@ out:
>  	return ret;
>  }
>=20
> +ssize_t ib_uverbs_modify_qp_ex(struct ib_uverbs_file *file,
> +			       const char __user *buf, int in_len,
> +			       int out_len)
> +{
> +	struct ib_uverbs_modify_qp_ex cmd;
> +	struct ib_uverbs_qp_dest_ex   dest_ex;
> +	struct ib_uverbs_qp_dest_ex   alt_dest_ex;
> +	struct ib_uverbs_qp_dest     *dest;
> +	struct ib_uverbs_qp_dest     *alt_dest;
> +	struct ib_udata               udata;
> +	struct ib_qp                 *qp;
> +	struct ib_qp_attr	     *attr;
> +	int                           ret;
> +
> +	if (copy_from_user(&cmd, buf, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	INIT_UDATA(&udata, buf + sizeof(cmd), NULL, in_len - sizeof(cmd),
> +		   out_len);
> +
> +	attr =3D kmalloc(sizeof(*attr), GFP_KERNEL);
> +	if (!attr)
> +		return -ENOMEM;
> +
> +	qp =3D idr_read_qp(cmd.qp_handle, file->ucontext);
> +	if (!qp) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!(cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_DEST_EX) ||
> +	    copy_from_user(&dest_ex, cmd.dest_ex, sizeof(dest_ex)))
> +		dest =3D &cmd.dest;
> +	else
> +		dest =3D (struct ib_uverbs_qp_dest *)&dest_ex;
> +

errors from copy_from_user() must be returned to user: EFAULT




> +ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
> +			    const char __user *buf, int in_len,
> +			    int out_len)
> +{
> +	struct ib_uverbs_create_ah_ex	 cmd_ex;
> +	struct ib_uverbs_create_ah	*cmd =3D (struct ib_uverbs_create_ah *)
> +					       ((void *)&cmd_ex +
> +						sizeof(cmd_ex.comp_mask));

What ?!

It's not aligned

>=20
>  static void ib_uverbs_add_one(struct ib_device *device);
> diff --git a/drivers/infiniband/core/uverbs_marshall.c
> b/drivers/infiniband/core/uverbs_marshall.c
> index e7bee46..7f7a7e2 100644
> --- a/drivers/infiniband/core/uverbs_marshall.c
> +++ b/drivers/infiniband/core/uverbs_marshall.c
> @@ -31,6 +31,7 @@
>   */
>=20
>  #include <linux/export.h>
> +#include <linux/etherdevice.h>
>  #include <rdma/ib_marshall.h>
>=20
>  void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
> @@ -52,6 +53,17 @@ void ib_copy_ah_attr_to_user(struct=20
> ib_uverbs_ah_attr *dst,
>  }
>  EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
>=20
> +void ib_copy_ah_attr_to_user_ex(struct ib_uverbs_ah_attr_ex *dst,
> +				struct ib_ah_attr *src)
> +{
> +	dst->comp_mask =3D 0;
> +	ib_copy_ah_attr_to_user((struct ib_uverbs_ah_attr *)
> +				dst, src);
> +	dst->comp_mask |=3D IB_UVERBS_AH_ATTR_DMAC;
> +	memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
> +}
> +EXPORT_SYMBOL(ib_copy_ah_attr_to_user_ex);
> +
>  void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
>  			     struct ib_qp_attr *src)
>  {
> @@ -65,15 +77,15 @@ void ib_copy_qp_attr_to_user(struct=20
> ib_uverbs_qp_attr *dst,
>  	dst->dest_qp_num	=3D src->dest_qp_num;
>  	dst->qp_access_flags	=3D src->qp_access_flags;
>=20
> +	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
> +	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
> +
>  	dst->max_send_wr	=3D src->cap.max_send_wr;
>  	dst->max_recv_wr	=3D src->cap.max_recv_wr;
>  	dst->max_send_sge	=3D src->cap.max_send_sge;
>  	dst->max_recv_sge	=3D src->cap.max_recv_sge;
>  	dst->max_inline_data	=3D src->cap.max_inline_data;
>=20
> -	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
> -	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
> -
>  	dst->pkey_index		=3D src->pkey_index;
>  	dst->alt_pkey_index	=3D src->alt_pkey_index;
>  	dst->en_sqd_async_notify =3D src->en_sqd_async_notify;
> @@ -91,6 +103,63 @@ void ib_copy_qp_attr_to_user(struct=20
> ib_uverbs_qp_attr *dst,
>  }
>  EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
>=20
> +void ib_copy_qp_attr_to_user_ex(struct ib_uverbs_qp_attr_ex *dst,
> +				struct ib_qp_attr *src)
> +{
> +	struct ib_uverbs_ah_attr_ex ah_attr_ex;
> +	struct ib_uverbs_ah_attr_ex alt_ah_attr_ex;
> +
> +	ib_copy_qp_attr_to_user((struct ib_uverbs_qp_attr *)
> +				dst, src);
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_AH_EX &&
> +	    !is_zero_ether_addr(src->ah_attr.dmac)) {
> +		ib_copy_ah_attr_to_user_ex(&ah_attr_ex, &src->ah_attr);
> +		if (dst->ah_attr_ex =3D=3D NULL ||
> +		    copy_to_user(dst->ah_attr_ex, &ah_attr_ex,
> +				 sizeof(ah_attr_ex)))

copy_to_user() error should be returned to user.

> +			dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_AH_EX;
> +	} else {
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_AH_EX;
> +	}
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_AH_EX &&
> +	    !is_zero_ether_addr(src->alt_ah_attr.dmac)) {
> +		ib_copy_ah_attr_to_user_ex(&alt_ah_attr_ex, &src->alt_ah_attr);
> +		if (dst->alt_ah_attr_ex =3D=3D NULL ||
> +		    copy_to_user(dst->alt_ah_attr_ex, &alt_ah_attr_ex,
> +				 sizeof(alt_ah_attr_ex)))

copy_to_user() error should be returned to user.

> +			dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_AH_EX;
> +	} else {
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_AH_EX;
> +	}
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_SMAC &&
> +	    !is_zero_ether_addr(src->smac))
> +		memcpy(dst->smac, src->smac, sizeof(dst->smac));
> +	else
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_SMAC;
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_SMAC &&
> +	    !is_zero_ether_addr(src->alt_smac))
> +		memcpy(dst->alt_smac, src->alt_smac, sizeof(dst->alt_smac));
> +	else
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_ALT_SMAC;
> +
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_SMAC &&
> +	    src->vlan_id !=3D 0xFFFF)
> +		dst->vlan_id =3D src->vlan_id;
> +	else
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_VID;
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_VID &&
> +	    src->vlan_id !=3D 0xFFFF)
> +		dst->vlan_id =3D src->vlan_id;
> +	else
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_VID;
> +	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_VID &&
> +	    src->alt_vlan_id !=3D 0xFFFF)
> +		dst->alt_vlan_id =3D src->alt_vlan_id;
> +	else
> +		dst->comp_mask &=3D ~IB_UVERBS_QP_ATTR_VID;
> +}
> +EXPORT_SYMBOL(ib_copy_qp_attr_to_user_ex);
> +
>  void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
>  			      struct ib_sa_path_rec *src)
>  {


> diff --git a/include/uapi/rdma/ib_user_sa.h=20
> b/include/uapi/rdma/ib_user_sa.h
> index cfc7c9b..8a24e10 100644
> --- a/include/uapi/rdma/ib_user_sa.h
> +++ b/include/uapi/rdma/ib_user_sa.h
> @@ -48,7 +48,13 @@ enum {
>  struct ib_path_rec_data {
>  	__u32	flags;
>  	__u32	reserved;
> -	__u32	path_rec[16];
> +	__u32	path_rec[20];
> +};
> +
> +enum ibv_kern_path_rec_attr_mask {
> +	IB_USER_PATH_REC_ATTR_DMAC =3D 1ULL << 0,
> +	IB_USER_PATH_REC_ATTR_SMAC =3D 1ULL << 1,
> +	IB_USER_PATH_REC_ATTR_VID  =3D 1ULL << 2
>  };
>=20
>  struct ib_user_path_rec {
> @@ -73,4 +79,30 @@ struct ib_user_path_rec {
>  	__u8	preference;
>  };
>=20
> +struct ib_user_path_rec_ex {
> +	__u8	dgid[16];
> +	__u8	sgid[16];
> +	__be16	dlid;
> +	__be16	slid;
> +	__u32	raw_traffic;
> +	__be32	flow_label;
> +	__u32	reversible;
> +	__u32	mtu;
> +	__be16	pkey;
> +	__u8	hop_limit;
> +	__u8	traffic_class;
> +	__u8	numb_path;
> +	__u8	sl;
> +	__u8	mtu_selector;
> +	__u8	rate_selector;
> +	__u8	rate;
> +	__u8	packet_life_time_selector;
> +	__u8	packet_life_time;
> +	__u8	preference;
> +	__u32   comp_mask;
> +	__u8	smac[ETH_ALEN];
> +	__u8	dmac[ETH_ALEN];
> +	u16	vlan_id;
> +};
> +
>  #endif /* IB_USER_SA_H */
> diff --git a/include/uapi/rdma/ib_user_verbs.h
> b/include/uapi/rdma/ib_user_verbs.h
> index 0b233c5..f1939cf 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -37,6 +37,7 @@
>  #define IB_USER_VERBS_H
>=20
>  #include <linux/types.h>
> +#include <linux/if_ether.h>
>=20
>  /*
>   * Increment this value if any changes that break userspace ABI
> @@ -88,7 +89,9 @@ enum {
>  	IB_USER_VERBS_CMD_CREATE_XSRQ,
>  	IB_USER_VERBS_CMD_OPEN_QP,
>  	IB_USER_VERBS_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRESHOLD,
> -	IB_USER_VERBS_CMD_DESTROY_FLOW
> +	IB_USER_VERBS_CMD_DESTROY_FLOW,
> +	IB_USER_VERBS_CMD_MODIFY_QP_EX,
> +	IB_USER_VERBS_CMD_CREATE_AH_EX
>  };
>=20
>  /*
> @@ -394,6 +397,24 @@ struct ib_uverbs_ah_attr {
>  	__u8  reserved;
>  };
>=20
> +enum ib_uverbs_ah_attr_mask {
> +	IB_UVERBS_AH_ATTR_DMAC,
> +	IB_UVERBS_AH_ATTR_VID
> +};
> +
> +struct ib_uverbs_ah_attr_ex {
> +	struct ib_uverbs_global_route grh;
> +	__u16 dlid;
> +	__u8  sl;
> +	__u8  src_path_bits;
> +	__u8  static_rate;
> +	__u8  is_global;
> +	__u8  port_num;
> +	__u8  reserved;
> +	__u32 comp_mask;
> +	__u8  dmac[ETH_ALEN];
> +};
> +
>  struct ib_uverbs_qp_attr {
>  	__u32	qp_attr_mask;
>  	__u32	qp_state;
> @@ -432,6 +453,65 @@ struct ib_uverbs_qp_attr {
>  	__u8	reserved[5];
>  };
>=20
> +enum ib_uverbs_qh_attr_mask {
> +	IB_UVERBS_QP_ATTR_AH_EX		=3D 1 << 0,
> +	IB_UVERBS_QP_ATTR_ALT_AH_EX	=3D 1 << 1,
> +	IB_UVERBS_QP_ATTR_SMAC		=3D 1 << 2,
> +	IB_UVERBS_QP_ATTR_ALT_SMAC	=3D 1 << 3,
> +	IB_UVERBS_QP_ATTR_VID		=3D 1 << 4,
> +	IB_UVERBS_QP_ATTR_ALT_VID	=3D 1 << 5,
> +};
> +
> +struct ib_uverbs_qp_attr_ex {
> +	__u32	qp_attr_mask;
> +	__u32	qp_state;
> +	__u32	cur_qp_state;
> +	__u32	path_mtu;
> +	__u32	path_mig_state;
> +	__u32	qkey;
> +	__u32	rq_psn;
> +	__u32	sq_psn;
> +	__u32	dest_qp_num;
> +	__u32	qp_access_flags;
> +
> +	/* deprecated for extension */
> +	struct ib_uverbs_ah_attr ah_attr;
> +	/* deprecated for extension */
> +	struct ib_uverbs_ah_attr alt_ah_attr;
> +
> +	/* ib_qp_cap */
> +	__u32	max_send_wr;
> +	__u32	max_recv_wr;
> +	__u32	max_send_sge;
> +	__u32	max_recv_sge;
> +	__u32	max_inline_data;
> +
> +	__u16	pkey_index;
> +	__u16	alt_pkey_index;
> +	__u8	en_sqd_async_notify;
> +	__u8	sq_draining;
> +	__u8	max_rd_atomic;
> +	__u8	max_dest_rd_atomic;
> +	__u8	min_rnr_timer;
> +	__u8	port_num;
> +	__u8	timeout;
> +	__u8	retry_cnt;
> +	__u8	rnr_retry;
> +	__u8	alt_port_num;
> +	__u8	alt_timeout;
> +	__u8	reserved[5];
> +
> +	__u32   comp_mask;
> +	/* represents: struct ib_uverbs_ah_attr_ex * __user */
> +	void __user *ah_attr_ex;
> +	/* represents: struct ib_uverbs_ah_attr_ex * __user */
> +	void __user *alt_ah_attr_ex;
> +	__u8	smac[ETH_ALEN];
> +	__u8	alt_smac[ETH_ALEN];
> +	__u16	vlan_id;
> +	__u16	alt_vlan_id;
> +};
> +
>  struct ib_uverbs_create_qp {
>  	__u64 response;
>  	__u64 user_handle;
> @@ -492,6 +572,27 @@ struct ib_uverbs_qp_dest {
>  	__u8  port_num;
>  };
>=20
> +enum ib_uverbs_qp_dest_attr_mask {
> +	IB_UVERBS_QP_DEST_ATTR_DMAC =3D 1ULL << 0
> +};
> +
> +struct ib_uverbs_qp_dest_ex {
> +	__u8  dgid[16];
> +	__u32 flow_label;
> +	__u16 dlid;
> +	__u16 reserved;
> +	__u8  sgid_index;
> +	__u8  hop_limit;
> +	__u8  traffic_class;
> +	__u8  sl;
> +	__u8  src_path_bits;
> +	__u8  static_rate;
> +	__u8  is_global;
> +	__u8  port_num;
> +	__u32 comp_mask;
> +	__u8  dmac[ETH_ALEN];
> +};
> +
>  struct ib_uverbs_query_qp {
>  	__u64 response;
>  	__u32 qp_handle;
> @@ -563,6 +664,54 @@ struct ib_uverbs_modify_qp {
>  	__u64 driver_data[0];
>  };
>=20
> +enum ib_uverbs_modify_qp_ex_comp_mask {
> +	IB_UVERBS_MODIFY_QP_EX_SMAC		      =3D (1ULL << 0),
> +	IB_UVERBS_MODIFY_QP_EX_ALT_SMAC		      =3D (1ULL << 1),
> +	IB_UVERBS_MODIFY_QP_EX_VID		      =3D (1ULL << 2),
> +	IB_UVERBS_MODIFY_QP_EX_ALT_VID		      =3D (1ULL << 3),
> +	IB_UVERBS_MODIFY_QP_EX_DEST_EX		      =3D (1ULL << 4),
> +	IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX	      =3D (1ULL << 5)
> +};
> +
> +struct ib_uverbs_modify_qp_ex {
> +	__u32 comp_mask;
> +	struct ib_uverbs_qp_dest dest;
> +	struct ib_uverbs_qp_dest alt_dest;
> +	__u32 qp_handle;
> +	__u32 attr_mask;
> +	__u32 qkey;
> +	__u32 rq_psn;
> +	__u32 sq_psn;
> +	__u32 dest_qp_num;
> +	__u32 qp_access_flags;
> +	__u16 pkey_index;
> +	__u16 alt_pkey_index;
> +	__u8  qp_state;
> +	__u8  cur_qp_state;
> +	__u8  path_mtu;
> +	__u8  path_mig_state;
> +	__u8  en_sqd_async_notify;
> +	__u8  max_rd_atomic;
> +	__u8  max_dest_rd_atomic;
> +	__u8  min_rnr_timer;
> +	__u8  port_num;
> +	__u8  timeout;
> +	__u8  retry_cnt;
> +	__u8  rnr_retry;
> +	__u8  alt_port_num;
> +	__u8  alt_timeout;
> +	__u8  reserved[2];
> +	__u8  smac[ETH_ALEN];
> +	__u8  alt_smac[ETH_ALEN];
> +	__u16 vid;
> +	__u16 alt_vid;
> +	/* represents: struct ib_uverbs_qp_dest_ex * __user */
> +	void __user *dest_ex;
> +	/* represents: struct ib_uverbs_qp_dest_ex * __user */
> +	void __user *alt_dest_ex;
> +	__u64 driver_data[0];
> +};
> +
>  struct ib_uverbs_modify_qp_resp {
>  };
>=20
> @@ -672,6 +821,15 @@ struct ib_uverbs_create_ah {
>  	struct ib_uverbs_ah_attr attr;
>  };
>=20
> +struct ib_uverbs_create_ah_ex {
> +	__u32 comp_mask;


This create a hole or introduced unaligned access depending on the=20
64bits ABI.

The way this structure is used to map a struct ib_uverbs_create_ah seem=
s=20
wrong.

> +	__u64 response;
> +	__u64 user_handle;
> +	__u32 pd_handle;
> +	__u32 reserved;
> +	struct ib_uverbs_ah_attr_ex attr;
> +};
> +
>  struct ib_uverbs_create_ah_resp {
>  	__u32 ah_handle;
>  };


I haven't dig too much on others new structures, but sure, they deserve=
=20
a thorough review.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
