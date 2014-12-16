From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/17] IB/core: Add support for extended query device
 caps
Date: Tue, 16 Dec 2014 13:33:56 +0100
Message-ID: <1418733236.2779.26.camel@opteya.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
	 <1418310266-9584-7-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-7-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le jeudi 11 d=C3=A9cembre 2014 =C3=A0 17:04 +0200, Haggai Eran a =C3=A9=
crit :
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
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 124 +++++++++++++++++++++++-=
----------
>  drivers/infiniband/core/uverbs_main.c |   3 +-
>  include/rdma/ib_verbs.h               |   5 +-
>  include/uapi/rdma/ib_user_verbs.h     |  14 +++-
>  5 files changed, 103 insertions(+), 44 deletions(-)
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
> index 5ba2a86aab6a..c7a43624c96b 100644
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
> @@ -3253,3 +3259,39 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs=
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
> +	if (cmd.reserved)
> +		return -EINVAL;
> +
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


This is not the place to do this: as I'm guessing the purpose of this=20
change from the patch in '[PATCH v3 07/17] IB/core: Add flags for on=20
demand paging support', you're trying to handle uverbs call from=20
a userspace program using a previous, shorter ABI.

But that's hidding bug where userspace will get it wrong at passing the=
=20
correct buffer / size for all others uverb calls.

That cannot work that way.

In a previous patchset [1], I've suggested to add a check in=20
ib_copy_{from,to}_udata()[2][3] in order to check the input/output
buffer size to not read/write past userspace provided buffer
boundaries: in case of mismatch an error would be returned to
userspace.

With the suggested change here, buffer overflow won't happen,
but the error is silently ignored, allowing uverb to return a
partial result, which is likely not expected by userspace as
it's a bit difficult to handle it gracefully.

So this has to be removed, and a check on userspace response
buffer must be added to ib_uverbs_ex_query_device() instead.

[1] "[PATCH 00/22] infiniband: improve userspace input check"

http://marc.info/?i=3Dcover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] "[PATCH 03/22] infiniband: ib_copy_from_udata(): check input length=
"

http://mid.gmane.org/2bf102a41c51f61965ee09df827abe8fefb523a9.137684740=
3.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] "[PATCH 04/22] infiniband: ib_copy_to_udata(): check output length"

http://mid.gmane.org/d27716a3a1c180f832d153a7402f65ea8a75b734.137684740=
3.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
