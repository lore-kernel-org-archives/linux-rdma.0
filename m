From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: Add support for extended query device caps
Date: Mon, 16 Feb 2015 21:56:06 +0100
Message-ID: <1424120166.32606.17.camel@opteya.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com>
	 <1423394932-2965-2-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423394932-2965-2-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le dimanche 08 f=C3=A9vrier 2015 =C3=A0 13:28 +0200, Haggai Eran a =C3=A9=
crit :
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add extensible query device capabilities verb to allow adding new fea=
tures.
> ib_uverbs_ex_query_device is added and copy_query_dev_fields is used =
to copy
> capability fields to be used by both ib_uverbs_query_device and
> ib_uverbs_ex_query_device.
>=20
> Following the discussion about this patch [1], the code now validates=
 the
> command's comp_mask is zero, returning -EINVAL for unknown values, in=
 order to
> allow extending the verb in the future.
>=20
> The verb also checks the user-space provided response buffer size and=
 only
> fills in capabilities that will fit in the buffer. In attempt to foll=
ow the
> spirit of presentation [2] by Tzahi Oved that was presented during Op=
enFabrics
> Alliance International Developer Workshop 2013, the comp_mask bits wi=
ll only
> describe which fields are valid. Furthermore, fields that can simply =
be
> cleared when they are not supported, do not require a comp_mask bit a=
t all.
> The verb returns a response_length field containing the actual number=
 of bytes
> written by the kernel, so that a newer version running on an older ke=
rnel can
> tell which fields were actually returned.
>=20
> [1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3=
=2E19
>     http://thread.gmane.org/gmane.linux.kernel.api/7889/
>=20
> [2] https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_04=
23/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.=
pdf
>=20
> Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 131 +++++++++++++++++++++++-=
----------
>  drivers/infiniband/core/uverbs_main.c |   1 +
>  include/uapi/rdma/ib_user_verbs.h     |  12 ++++
>  4 files changed, 104 insertions(+), 41 deletions(-)
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
> index b7943ff16ed3..8f507538c42b 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -400,6 +400,52 @@ err:
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
> @@ -420,47 +466,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_=
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
> @@ -3287,3 +3293,46 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs=
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

Please an empty line after, or may be, move this in device declaration.

> +	if (ucore->inlen < sizeof(cmd))
> +		return -EINVAL;
> +
> +	err =3D ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
> +	if (err)
> +		return err;
> +
> +	if (cmd.comp_mask)
> +		return -EINVAL;
> +
> +	if (cmd.reserved)
> +		return -EINVAL;
> +
> +	resp.response_length =3D sizeof(resp);
> +
> +	if (ucore->outlen < resp.response_length)
> +		return -ENOSPC;
> +
> +	err =3D device->query_device(device, &attr);
> +	if (err)
> +		return err;
> +
> +	copy_query_dev_fields(file, &resp.base, &attr);
> +	resp.comp_mask =3D 0;
> +
> +	err =3D ib_copy_to_udata(ucore, &resp, resp.response_length);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index 5db1a8cc388d..259dcc7779f5 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -123,6 +123,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uve=
rbs_file *file,
>  				    struct ib_udata *uhw) =3D {
>  	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	=3D ib_uverbs_ex_create_flow,
>  	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	=3D ib_uverbs_ex_destroy_flow,
> +	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	=3D ib_uverbs_ex_query_device,
>  };
> =20
>  static void ib_uverbs_add_one(struct ib_device *device);
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index 867cc5084afb..f0f799afd856 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -90,6 +90,7 @@ enum {
>  };
> =20
>  enum {
> +	IB_USER_VERBS_EX_CMD_QUERY_DEVICE =3D IB_USER_VERBS_CMD_QUERY_DEVIC=
E,
>  	IB_USER_VERBS_EX_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRESHOLD,
>  	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
>  };
> @@ -201,6 +202,17 @@ struct ib_uverbs_query_device_resp {
>  	__u8  reserved[4];
>  };
> =20
> +struct ib_uverbs_ex_query_device {
> +	__u32 comp_mask;
> +	__u32 reserved;
> +};
> +
> +struct ib_uverbs_ex_query_device_resp {
> +	struct ib_uverbs_query_device_resp base;
> +	__u32 comp_mask;
> +	__u32 response_length;
> +};
> +
>  struct ib_uverbs_query_port {
>  	__u64 response;
>  	__u8  port_num;

Everything else seems OK for me. Thanks a lot the new patch with all th=
e
fixes.

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
