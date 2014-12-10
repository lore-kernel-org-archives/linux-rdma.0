From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/17] IB/core: Add support for extended query device
 caps
Date: Wed, 10 Dec 2014 14:04:36 +0100
Message-ID: <1418216676.11111.45.camel@opteya.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
	 <1415723783-2138-7-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-7-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 11 novembre 2014 =C3=A0 18:36 +0200, Haggai Eran a =C3=A9crit =
:
> From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>=20
> Add extensible query device capabilities verb to allow adding new fea=
tures.
> ib_uverbs_ex_query_device is added and copy_query_dev_fields is used =
to copy
> capability fields to be used by both ib_uverbs_query_device and
> ib_uverbs_ex_query_device.
>=20
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 121 ++++++++++++++++++++++--=
----------
>  drivers/infiniband/core/uverbs_main.c |   3 +-
>  include/rdma/ib_verbs.h               |   5 +-
>  include/uapi/rdma/ib_user_verbs.h     |  12 +++-
>  5 files changed, 98 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/co=
re/uverbs.h
> index 643c08a025a5..b716b0815644 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -258,5 +258,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
> =20
>  IB_UVERBS_DECLARE_EX_CMD(create_flow);
>  IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
> +IB_UVERBS_DECLARE_EX_CMD(query_device);
> =20
>  #endif /* UVERBS_H */
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 5ba2a86aab6a..74ad0d0de92b 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -378,6 +378,52 @@ err:
>  	return ret;
>  }
> =20
> +static void copy_query_dev_fields(struct ib_uverbs_file *file,
> +				  struct ib_uverbs_query_device_resp *resp,
> +				  struct ib_device_attr *attr)
> +{
> +	resp->fw_ver		=3D attr->fw_ver;
> +	resp->node_guid		=3D file->device->ib_dev->node_guid;
> +	resp->sys_image_guid	=3D attr->sys_image_guid;
> +	resp->max_mr_size	=3D attr->max_mr_size;
> +	resp->page_size_cap	=3D attr->page_size_cap;
> +	resp->vendor_id		=3D attr->vendor_id;
> +	resp->vendor_part_id	=3D attr->vendor_part_id;
> +	resp->hw_ver		=3D attr->hw_ver;
> +	resp->max_qp		=3D attr->max_qp;
> +	resp->max_qp_wr		=3D attr->max_qp_wr;
> +	resp->device_cap_flags	=3D attr->device_cap_flags;
> +	resp->max_sge		=3D attr->max_sge;
> +	resp->max_sge_rd	=3D attr->max_sge_rd;
> +	resp->max_cq		=3D attr->max_cq;
> +	resp->max_cqe		=3D attr->max_cqe;
> +	resp->max_mr		=3D attr->max_mr;
> +	resp->max_pd		=3D attr->max_pd;
> +	resp->max_qp_rd_atom	=3D attr->max_qp_rd_atom;
> +	resp->max_ee_rd_atom	=3D attr->max_ee_rd_atom;
> +	resp->max_res_rd_atom	=3D attr->max_res_rd_atom;
> +	resp->max_qp_init_rd_atom	=3D attr->max_qp_init_rd_atom;
> +	resp->max_ee_init_rd_atom	=3D attr->max_ee_init_rd_atom;
> +	resp->atomic_cap		=3D attr->atomic_cap;
> +	resp->max_ee			=3D attr->max_ee;
> +	resp->max_rdd			=3D attr->max_rdd;
> +	resp->max_mw			=3D attr->max_mw;
> +	resp->max_raw_ipv6_qp		=3D attr->max_raw_ipv6_qp;
> +	resp->max_raw_ethy_qp		=3D attr->max_raw_ethy_qp;
> +	resp->max_mcast_grp		=3D attr->max_mcast_grp;
> +	resp->max_mcast_qp_attach	=3D attr->max_mcast_qp_attach;
> +	resp->max_total_mcast_qp_attach	=3D attr->max_total_mcast_qp_attach=
;
> +	resp->max_ah			=3D attr->max_ah;
> +	resp->max_fmr			=3D attr->max_fmr;
> +	resp->max_map_per_fmr		=3D attr->max_map_per_fmr;
> +	resp->max_srq			=3D attr->max_srq;
> +	resp->max_srq_wr		=3D attr->max_srq_wr;
> +	resp->max_srq_sge		=3D attr->max_srq_sge;
> +	resp->max_pkeys			=3D attr->max_pkeys;
> +	resp->local_ca_ack_delay	=3D attr->local_ca_ack_delay;
> +	resp->phys_port_cnt		=3D file->device->ib_dev->phys_port_cnt;
> +}
> +
>  ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
>  			       const char __user *buf,
>  			       int in_len, int out_len)
> @@ -398,47 +444,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_=
file *file,
>  		return ret;
> =20
>  	memset(&resp, 0, sizeof resp);
> -
> -	resp.fw_ver 		       =3D attr.fw_ver;
> -	resp.node_guid 		       =3D file->device->ib_dev->node_guid;
> -	resp.sys_image_guid 	       =3D attr.sys_image_guid;
> -	resp.max_mr_size 	       =3D attr.max_mr_size;
> -	resp.page_size_cap 	       =3D attr.page_size_cap;
> -	resp.vendor_id 		       =3D attr.vendor_id;
> -	resp.vendor_part_id 	       =3D attr.vendor_part_id;
> -	resp.hw_ver 		       =3D attr.hw_ver;
> -	resp.max_qp 		       =3D attr.max_qp;
> -	resp.max_qp_wr 		       =3D attr.max_qp_wr;
> -	resp.device_cap_flags 	       =3D attr.device_cap_flags;
> -	resp.max_sge 		       =3D attr.max_sge;
> -	resp.max_sge_rd 	       =3D attr.max_sge_rd;
> -	resp.max_cq 		       =3D attr.max_cq;
> -	resp.max_cqe 		       =3D attr.max_cqe;
> -	resp.max_mr 		       =3D attr.max_mr;
> -	resp.max_pd 		       =3D attr.max_pd;
> -	resp.max_qp_rd_atom 	       =3D attr.max_qp_rd_atom;
> -	resp.max_ee_rd_atom 	       =3D attr.max_ee_rd_atom;
> -	resp.max_res_rd_atom 	       =3D attr.max_res_rd_atom;
> -	resp.max_qp_init_rd_atom       =3D attr.max_qp_init_rd_atom;
> -	resp.max_ee_init_rd_atom       =3D attr.max_ee_init_rd_atom;
> -	resp.atomic_cap 	       =3D attr.atomic_cap;
> -	resp.max_ee 		       =3D attr.max_ee;
> -	resp.max_rdd 		       =3D attr.max_rdd;
> -	resp.max_mw 		       =3D attr.max_mw;
> -	resp.max_raw_ipv6_qp 	       =3D attr.max_raw_ipv6_qp;
> -	resp.max_raw_ethy_qp 	       =3D attr.max_raw_ethy_qp;
> -	resp.max_mcast_grp 	       =3D attr.max_mcast_grp;
> -	resp.max_mcast_qp_attach       =3D attr.max_mcast_qp_attach;
> -	resp.max_total_mcast_qp_attach =3D attr.max_total_mcast_qp_attach;
> -	resp.max_ah 		       =3D attr.max_ah;
> -	resp.max_fmr 		       =3D attr.max_fmr;
> -	resp.max_map_per_fmr 	       =3D attr.max_map_per_fmr;
> -	resp.max_srq 		       =3D attr.max_srq;
> -	resp.max_srq_wr 	       =3D attr.max_srq_wr;
> -	resp.max_srq_sge 	       =3D attr.max_srq_sge;
> -	resp.max_pkeys 		       =3D attr.max_pkeys;
> -	resp.local_ca_ack_delay        =3D attr.local_ca_ack_delay;
> -	resp.phys_port_cnt	       =3D file->device->ib_dev->phys_port_cnt;
> +	copy_query_dev_fields(file, &resp, &attr);
> =20
>  	if (copy_to_user((void __user *) (unsigned long) cmd.response,
>  			 &resp, sizeof resp))
> @@ -3253,3 +3259,36 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs=
_file *file,
> =20
>  	return ret ? ret : in_len;
>  }
> +
> +int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
> +			      struct ib_udata *ucore,
> +			      struct ib_udata *uhw)
> +{
> +	struct ib_uverbs_ex_query_device_resp resp;
> +	struct ib_uverbs_ex_query_device  cmd;
> +	struct ib_device_attr attr;
> +	struct ib_device *device;
> +	int err;
> +
> +	device =3D file->device->ib_dev;
> +	if (ucore->inlen < sizeof(cmd))
> +		return -EINVAL;
> +
> +	err =3D ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
> +	if (err)
> +		return err;
> +

I believe you should had a check on cmd.comp_mask being 0.
ib_uverbs_ex_create_flow() has such check.

> +	err =3D device->query_device(device, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	copy_query_dev_fields(file, &resp.base, &attr);
> +	resp.comp_mask =3D 0;
> +
> +	err =3D ib_copy_to_udata(ucore, &resp, sizeof(resp));
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index 71ab83fde472..974025028790 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -122,7 +122,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uve=
rbs_file *file,
>  				    struct ib_udata *ucore,
>  				    struct ib_udata *uhw) =3D {
>  	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	=3D ib_uverbs_ex_create_flow,
> -	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	=3D ib_uverbs_ex_destroy_flow
> +	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	=3D ib_uverbs_ex_destroy_flow,
> +	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	=3D ib_uverbs_ex_query_device
>  };
> =20
>  static void ib_uverbs_add_one(struct ib_device *device);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 470a011d6fa4..97a999f9e4d8 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1662,7 +1662,10 @@ static inline int ib_copy_from_udata(void *des=
t, struct ib_udata *udata, size_t
> =20
>  static inline int ib_copy_to_udata(struct ib_udata *udata, void *src=
, size_t len)
>  {
> -	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
> +	size_t copy_sz;
> +
> +	copy_sz =3D min_t(size_t, len, udata->outlen);
> +	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0;
>  }
> =20
>  /**
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index 26daf55ff76e..ed8c3d9da42c 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -90,8 +90,9 @@ enum {
>  };
> =20
>  enum {
> +	IB_USER_VERBS_EX_CMD_QUERY_DEVICE =3D IB_USER_VERBS_CMD_QUERY_DEVIC=
E,
>  	IB_USER_VERBS_EX_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRESHOLD,
> -	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
> +	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
>  };
> =20
>  /*
> @@ -201,6 +202,15 @@ struct ib_uverbs_query_device_resp {
>  	__u8  reserved[4];
>  };
> =20
> +struct ib_uverbs_ex_query_device {
> +	__u32 comp_mask;

_ex command buffer are supposed to be aligned on 64bit boundary.
You should add some padding at the end of the structure and add a check
for it being 0.

> +};
> +
> +struct ib_uverbs_ex_query_device_resp {
> +	struct ib_uverbs_query_device_resp base;
> +	__u32 comp_mask;
> +};
> +

_ex response buffer are supposed to be aligned on 64bit boundary:
you should probably add padding at the end of the structure and ensure
it's cleared before send it to userspace.

See commit f21519b23c1b ('IB/core: extended command: an improved
infrastructure for uverbs commands').

Regards.

--=20
Yann Droneaud


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
