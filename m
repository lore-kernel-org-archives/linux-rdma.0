From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Wed, 23 Sep 2015 10:23:15 -0700
Message-ID: <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com>
References: <1443023567-13259-1-git-send-email-hch@lst.de> <1443023567-13259-2-git-send-email-hch@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443023567-13259-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Christoph-


> On Sep 23, 2015, at 8:52 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>=20
> Avoid the need to query for device attributes and store them in a
> separate structure by merging struct ib_device_attr into struct
> ib_device.  This matches how the device structures are used in most
> Linux subsystems.

Getting rid of ib_query_device() makes sense. Moving the device
attributes into ib_device is nice. Getting rid of ib_device_attr
is of questionable value. Why do we need to go there?

IB core API changes generate merge conflicts with feature work
in the ULPs. It=E2=80=99s a pain for maintainers. In this particular
case, keeping ib_device_attr would greatly reduce ULP churn.


> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
> drivers/infiniband/core/cm.c                       |  12 +-
> drivers/infiniband/core/cma.c                      |   8 -
> drivers/infiniband/core/device.c                   |  20 ---
> drivers/infiniband/core/fmr_pool.c                 |  20 +--
> drivers/infiniband/core/sysfs.c                    |  14 +-
> drivers/infiniband/core/uverbs_cmd.c               | 128 +++++++-----=
----
> drivers/infiniband/core/verbs.c                    |   8 +-
> drivers/infiniband/hw/cxgb3/iwch_provider.c        |  60 +++-----
> drivers/infiniband/hw/cxgb4/provider.c             |  64 +++-----
> drivers/infiniband/hw/mlx4/main.c                  | 167 ++++++++++++=
---------
> drivers/infiniband/hw/mlx5/main.c                  | 116 ++++++------=
--
> drivers/infiniband/hw/mthca/mthca_provider.c       |  77 +++++-----
> drivers/infiniband/hw/nes/nes_verbs.c              |  94 +++++-------
> drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  40 ++++-
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  49 ------
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   2 -
> drivers/infiniband/hw/qib/qib_verbs.c              |  86 +++++------
> drivers/infiniband/hw/usnic/usnic_ib_main.c        |   3 +-
> drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  50 ++----
> drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   4 +-
> drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  19 +--
> drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  14 +-
> drivers/infiniband/ulp/ipoib/ipoib_main.c          |  21 +--
> drivers/infiniband/ulp/iser/iscsi_iser.c           |   4 +-
> drivers/infiniband/ulp/iser/iscsi_iser.h           |   2 -
> drivers/infiniband/ulp/iser/iser_memory.c          |   9 +-
> drivers/infiniband/ulp/iser/iser_verbs.c           |  38 ++---
> drivers/infiniband/ulp/isert/ib_isert.c            |  43 ++----
> drivers/infiniband/ulp/isert/ib_isert.h            |   1 -
> drivers/infiniband/ulp/srp/ib_srp.c                |  32 ++--
> drivers/infiniband/ulp/srpt/ib_srpt.c              |  15 +-
> drivers/infiniband/ulp/srpt/ib_srpt.h              |   3 -
> .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  21 +--
> drivers/staging/rdma/amso1100/c2.h                 |   3 -
> drivers/staging/rdma/amso1100/c2_pd.c              |   6 +-
> drivers/staging/rdma/amso1100/c2_provider.c        |  23 +--
> drivers/staging/rdma/amso1100/c2_rnic.c            |  63 +++-----
> drivers/staging/rdma/ehca/ehca_hca.c               |  78 +++++-----
> drivers/staging/rdma/ehca/ehca_iverbs.h            |   3 +-
> drivers/staging/rdma/ehca/ehca_main.c              |   3 +-
> drivers/staging/rdma/hfi1/verbs.c                  |  89 +++++------
> drivers/staging/rdma/ipath/ipath_verbs.c           |  90 +++++------
> include/rdma/ib_verbs.h                            |  98 ++++++------
> net/rds/ib.c                                       |  28 +---
> net/rds/iw.c                                       |  23 +--
> net/sunrpc/xprtrdma/frwr_ops.c                     |   7 +-
> net/sunrpc/xprtrdma/svc_rdma_transport.c           |  48 +++---
> net/sunrpc/xprtrdma/verbs.c                        |  23 +--
> net/sunrpc/xprtrdma/xprt_rdma.h                    |   1 -
> 49 files changed, 723 insertions(+), 1107 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/c=
m.c
> index ea4db9c..56c7a70 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -3749,16 +3749,6 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
> }
> EXPORT_SYMBOL(ib_cm_init_qp_attr);
>=20
> -static void cm_get_ack_delay(struct cm_device *cm_dev)
> -{
> -	struct ib_device_attr attr;
> -
> -	if (ib_query_device(cm_dev->ib_device, &attr))
> -		cm_dev->ack_delay =3D 0; /* acks will rely on packet life time */
> -	else
> -		cm_dev->ack_delay =3D attr.local_ca_ack_delay;
> -}
> -
> static ssize_t cm_show_counter(struct kobject *obj, struct attribute =
*attr,
> 			       char *buf)
> {
> @@ -3870,7 +3860,7 @@ static void cm_add_one(struct ib_device *ib_dev=
ice)
> 		return;
>=20
> 	cm_dev->ib_device =3D ib_device;
> -	cm_get_ack_delay(cm_dev);
> +	cm_dev->ack_delay =3D ib_device->local_ca_ack_delay;
> 	cm_dev->going_down =3D 0;
> 	cm_dev->device =3D device_create(&cm_class, &ib_device->dev,
> 				       MKDEV(0, 0), NULL,
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index b1ab13f..077c4e2 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1847,7 +1847,6 @@ static int iw_conn_req_handler(struct iw_cm_id =
*cm_id,
> 	struct rdma_id_private *listen_id, *conn_id;
> 	struct rdma_cm_event event;
> 	int ret;
> -	struct ib_device_attr attr;
> 	struct sockaddr *laddr =3D (struct sockaddr *)&iw_event->local_addr;
> 	struct sockaddr *raddr =3D (struct sockaddr *)&iw_event->remote_addr=
;
>=20
> @@ -1888,13 +1887,6 @@ static int iw_conn_req_handler(struct iw_cm_id=
 *cm_id,
> 	memcpy(cma_src_addr(conn_id), laddr, rdma_addr_size(laddr));
> 	memcpy(cma_dst_addr(conn_id), raddr, rdma_addr_size(raddr));
>=20
> -	ret =3D ib_query_device(conn_id->id.device, &attr);
> -	if (ret) {
> -		mutex_unlock(&conn_id->handler_mutex);
> -		rdma_destroy_id(new_cm_id);
> -		goto out;
> -	}
> -
> 	memset(&event, 0, sizeof event);
> 	event.event =3D RDMA_CM_EVENT_CONNECT_REQUEST;
> 	event.param.conn.private_data =3D iw_event->private_data;
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/co=
re/device.c
> index 1763911..cca2c70 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -89,7 +89,6 @@ static int ib_device_check_mandatory(struct ib_devi=
ce *device)
> 		size_t offset;
> 		char  *name;
> 	} mandatory_table[] =3D {
> -		IB_MANDATORY_FUNC(query_device),
> 		IB_MANDATORY_FUNC(query_port),
> 		IB_MANDATORY_FUNC(query_pkey),
> 		IB_MANDATORY_FUNC(query_gid),
> @@ -628,25 +627,6 @@ void ib_dispatch_event(struct ib_event *event)
> EXPORT_SYMBOL(ib_dispatch_event);
>=20
> /**
> - * ib_query_device - Query IB device attributes
> - * @device:Device to query
> - * @device_attr:Device attributes
> - *
> - * ib_query_device() returns the attributes of a device through the
> - * @device_attr pointer.
> - */
> -int ib_query_device(struct ib_device *device,
> -		    struct ib_device_attr *device_attr)
> -{
> -	struct ib_udata uhw =3D {.outlen =3D 0, .inlen =3D 0};
> -
> -	memset(device_attr, 0, sizeof(*device_attr));
> -
> -	return device->query_device(device, device_attr, &uhw);
> -}
> -EXPORT_SYMBOL(ib_query_device);
> -
> -/**
>  * ib_query_port - Query IB port attributes
>  * @device:Device to query
>  * @port_num:Port number to query
> diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/=
core/fmr_pool.c
> index 9f5ad7c..b5b48c0 100644
> --- a/drivers/infiniband/core/fmr_pool.c
> +++ b/drivers/infiniband/core/fmr_pool.c
> @@ -212,7 +212,6 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_=
pd             *pd,
> {
> 	struct ib_device   *device;
> 	struct ib_fmr_pool *pool;
> -	struct ib_device_attr *attr;
> 	int i;
> 	int ret;
> 	int max_remaps;
> @@ -228,25 +227,10 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct i=
b_pd             *pd,
> 		return ERR_PTR(-ENOSYS);
> 	}
>=20
> -	attr =3D kmalloc(sizeof *attr, GFP_KERNEL);
> -	if (!attr) {
> -		printk(KERN_WARNING PFX "couldn't allocate device attr struct\n");
> -		return ERR_PTR(-ENOMEM);
> -	}
> -
> -	ret =3D ib_query_device(device, attr);
> -	if (ret) {
> -		printk(KERN_WARNING PFX "couldn't query device: %d\n", ret);
> -		kfree(attr);
> -		return ERR_PTR(ret);
> -	}
> -
> -	if (!attr->max_map_per_fmr)
> +	if (!device->max_map_per_fmr)
> 		max_remaps =3D IB_FMR_MAX_REMAPS;
> 	else
> -		max_remaps =3D attr->max_map_per_fmr;
> -
> -	kfree(attr);
> +		max_remaps =3D device->max_map_per_fmr;
>=20
> 	pool =3D kmalloc(sizeof *pool, GFP_KERNEL);
> 	if (!pool) {
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/cor=
e/sysfs.c
> index 34cdd74..373a1a6 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -614,18 +614,12 @@ static ssize_t show_sys_image_guid(struct devic=
e *device,
> 				   struct device_attribute *dev_attr, char *buf)
> {
> 	struct ib_device *dev =3D container_of(device, struct ib_device, dev=
);
> -	struct ib_device_attr attr;
> -	ssize_t ret;
> -
> -	ret =3D ib_query_device(dev, &attr);
> -	if (ret)
> -		return ret;
>=20
> 	return sprintf(buf, "%04x:%04x:%04x:%04x\n",
> -		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[0]),
> -		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[1]),
> -		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[2]),
> -		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[3]));
> +		       be16_to_cpu(((__be16 *) &dev->sys_image_guid)[0]),
> +		       be16_to_cpu(((__be16 *) &dev->sys_image_guid)[1]),
> +		       be16_to_cpu(((__be16 *) &dev->sys_image_guid)[2]),
> +		       be16_to_cpu(((__be16 *) &dev->sys_image_guid)[3]));
> }
>=20
> static ssize_t show_node_guid(struct device *device,
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 8adb71f..5be062f 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -289,9 +289,6 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_fi=
le *file,
> 	struct ib_uverbs_get_context      cmd;
> 	struct ib_uverbs_get_context_resp resp;
> 	struct ib_udata                   udata;
> -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> -	struct ib_device_attr		  dev_attr;
> -#endif
> 	struct ib_ucontext		 *ucontext;
> 	struct file			 *filp;
> 	int ret;
> @@ -340,10 +337,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_f=
ile *file,
> 	ucontext->odp_mrs_count =3D 0;
> 	INIT_LIST_HEAD(&ucontext->no_private_counters);
>=20
> -	ret =3D ib_query_device(ib_dev, &dev_attr);
> -	if (ret)
> -		goto err_free;
> -	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
> +	if (!(ib_dev->device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
> 		ucontext->invalidate_range =3D NULL;
>=20
> #endif
> @@ -393,48 +387,47 @@ err:
>=20
> static void copy_query_dev_fields(struct ib_uverbs_file *file,
> 				  struct ib_device *ib_dev,
> -				  struct ib_uverbs_query_device_resp *resp,
> -				  struct ib_device_attr *attr)
> +				  struct ib_uverbs_query_device_resp *resp)
> {
> -	resp->fw_ver		=3D attr->fw_ver;
> +	resp->fw_ver		=3D ib_dev->fw_ver;
> 	resp->node_guid		=3D ib_dev->node_guid;
> -	resp->sys_image_guid	=3D attr->sys_image_guid;
> -	resp->max_mr_size	=3D attr->max_mr_size;
> -	resp->page_size_cap	=3D attr->page_size_cap;
> -	resp->vendor_id		=3D attr->vendor_id;
> -	resp->vendor_part_id	=3D attr->vendor_part_id;
> -	resp->hw_ver		=3D attr->hw_ver;
> -	resp->max_qp		=3D attr->max_qp;
> -	resp->max_qp_wr		=3D attr->max_qp_wr;
> -	resp->device_cap_flags	=3D attr->device_cap_flags;
> -	resp->max_sge		=3D attr->max_sge;
> -	resp->max_sge_rd	=3D attr->max_sge_rd;
> -	resp->max_cq		=3D attr->max_cq;
> -	resp->max_cqe		=3D attr->max_cqe;
> -	resp->max_mr		=3D attr->max_mr;
> -	resp->max_pd		=3D attr->max_pd;
> -	resp->max_qp_rd_atom	=3D attr->max_qp_rd_atom;
> -	resp->max_ee_rd_atom	=3D attr->max_ee_rd_atom;
> -	resp->max_res_rd_atom	=3D attr->max_res_rd_atom;
> -	resp->max_qp_init_rd_atom	=3D attr->max_qp_init_rd_atom;
> -	resp->max_ee_init_rd_atom	=3D attr->max_ee_init_rd_atom;
> -	resp->atomic_cap		=3D attr->atomic_cap;
> -	resp->max_ee			=3D attr->max_ee;
> -	resp->max_rdd			=3D attr->max_rdd;
> -	resp->max_mw			=3D attr->max_mw;
> -	resp->max_raw_ipv6_qp		=3D attr->max_raw_ipv6_qp;
> -	resp->max_raw_ethy_qp		=3D attr->max_raw_ethy_qp;
> -	resp->max_mcast_grp		=3D attr->max_mcast_grp;
> -	resp->max_mcast_qp_attach	=3D attr->max_mcast_qp_attach;
> -	resp->max_total_mcast_qp_attach	=3D attr->max_total_mcast_qp_attach=
;
> -	resp->max_ah			=3D attr->max_ah;
> -	resp->max_fmr			=3D attr->max_fmr;
> -	resp->max_map_per_fmr		=3D attr->max_map_per_fmr;
> -	resp->max_srq			=3D attr->max_srq;
> -	resp->max_srq_wr		=3D attr->max_srq_wr;
> -	resp->max_srq_sge		=3D attr->max_srq_sge;
> -	resp->max_pkeys			=3D attr->max_pkeys;
> -	resp->local_ca_ack_delay	=3D attr->local_ca_ack_delay;
> +	resp->sys_image_guid	=3D ib_dev->sys_image_guid;
> +	resp->max_mr_size	=3D ib_dev->max_mr_size;
> +	resp->page_size_cap	=3D ib_dev->page_size_cap;
> +	resp->vendor_id		=3D ib_dev->vendor_id;
> +	resp->vendor_part_id	=3D ib_dev->vendor_part_id;
> +	resp->hw_ver		=3D ib_dev->hw_ver;
> +	resp->max_qp		=3D ib_dev->max_qp;
> +	resp->max_qp_wr		=3D ib_dev->max_qp_wr;
> +	resp->device_cap_flags	=3D ib_dev->device_cap_flags;
> +	resp->max_sge		=3D ib_dev->max_sge;
> +	resp->max_sge_rd	=3D ib_dev->max_sge_rd;
> +	resp->max_cq		=3D ib_dev->max_cq;
> +	resp->max_cqe		=3D ib_dev->max_cqe;
> +	resp->max_mr		=3D ib_dev->max_mr;
> +	resp->max_pd		=3D ib_dev->max_pd;
> +	resp->max_qp_rd_atom	=3D ib_dev->max_qp_rd_atom;
> +	resp->max_ee_rd_atom	=3D ib_dev->max_ee_rd_atom;
> +	resp->max_res_rd_atom	=3D ib_dev->max_res_rd_atom;
> +	resp->max_qp_init_rd_atom	=3D ib_dev->max_qp_init_rd_atom;
> +	resp->max_ee_init_rd_atom	=3D ib_dev->max_ee_init_rd_atom;
> +	resp->atomic_cap		=3D ib_dev->atomic_cap;
> +	resp->max_ee			=3D ib_dev->max_ee;
> +	resp->max_rdd			=3D ib_dev->max_rdd;
> +	resp->max_mw			=3D ib_dev->max_mw;
> +	resp->max_raw_ipv6_qp		=3D ib_dev->max_raw_ipv6_qp;
> +	resp->max_raw_ethy_qp		=3D ib_dev->max_raw_ethy_qp;
> +	resp->max_mcast_grp		=3D ib_dev->max_mcast_grp;
> +	resp->max_mcast_qp_attach	=3D ib_dev->max_mcast_qp_attach;
> +	resp->max_total_mcast_qp_attach	=3D ib_dev->max_total_mcast_qp_atta=
ch;
> +	resp->max_ah			=3D ib_dev->max_ah;
> +	resp->max_fmr			=3D ib_dev->max_fmr;
> +	resp->max_map_per_fmr		=3D ib_dev->max_map_per_fmr;
> +	resp->max_srq			=3D ib_dev->max_srq;
> +	resp->max_srq_wr		=3D ib_dev->max_srq_wr;
> +	resp->max_srq_sge		=3D ib_dev->max_srq_sge;
> +	resp->max_pkeys			=3D ib_dev->max_pkeys;
> +	resp->local_ca_ack_delay	=3D ib_dev->local_ca_ack_delay;
> 	resp->phys_port_cnt		=3D ib_dev->phys_port_cnt;
> }
>=20
> @@ -445,8 +438,6 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_f=
ile *file,
> {
> 	struct ib_uverbs_query_device      cmd;
> 	struct ib_uverbs_query_device_resp resp;
> -	struct ib_device_attr              attr;
> -	int                                ret;
>=20
> 	if (out_len < sizeof resp)
> 		return -ENOSPC;
> @@ -454,12 +445,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_=
file *file,
> 	if (copy_from_user(&cmd, buf, sizeof cmd))
> 		return -EFAULT;
>=20
> -	ret =3D ib_query_device(ib_dev, &attr);
> -	if (ret)
> -		return ret;
> -
> 	memset(&resp, 0, sizeof resp);
> -	copy_query_dev_fields(file, ib_dev, &resp, &attr);
> +	copy_query_dev_fields(file, ib_dev, &resp);
>=20
> 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
> 			 &resp, sizeof resp))
> @@ -984,10 +971,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *=
file,
> 	}
>=20
> 	if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
> -		struct ib_device_attr attr;
> -
> -		ret =3D ib_query_device(pd->device, &attr);
> -		if (ret || !(attr.device_cap_flags &
> +		if (!(pd->device->device_cap_flags &
> 				IB_DEVICE_ON_DEMAND_PAGING)) {
> 			pr_debug("ODP support not available\n");
> 			ret =3D -EINVAL;
> @@ -3473,7 +3457,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_=
file *file,
> {
> 	struct ib_uverbs_ex_query_device_resp resp;
> 	struct ib_uverbs_ex_query_device  cmd;
> -	struct ib_device_attr attr;
> 	int err;
>=20
> 	if (ucore->inlen < sizeof(cmd))
> @@ -3494,26 +3477,29 @@ int ib_uverbs_ex_query_device(struct ib_uverb=
s_file *file,
> 	if (ucore->outlen < resp.response_length)
> 		return -ENOSPC;
>=20
> -	memset(&attr, 0, sizeof(attr));
> -
> -	err =3D ib_dev->query_device(ib_dev, &attr, uhw);
> -	if (err)
> -		return err;
> +	if (ib_dev->query_device) {
> +		int err =3D ib_dev->query_device(ib_dev, uhw);
> +		if (err)
> +			return err;
> +	} else {
> + 		if (uhw->inlen || uhw->outlen)
> + 			return -EINVAL;
> +	}
>=20
> -	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
> +	copy_query_dev_fields(file, ib_dev, &resp.base);
> 	resp.comp_mask =3D 0;
>=20
> 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
> 		goto end;
>=20
> #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> -	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> +	resp.odp_caps.general_caps =3D ib_dev->odp_caps.general_caps;
> 	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.rc_odp_caps;
> +		ib_dev->odp_caps.per_transport_caps.rc_odp_caps;
> 	resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.uc_odp_caps;
> +		ib_dev->odp_caps.per_transport_caps.uc_odp_caps;
> 	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.ud_odp_caps;
> +		ib_dev->odp_caps.per_transport_caps.ud_odp_caps;
> 	resp.odp_caps.reserved =3D 0;
> #else
> 	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
> @@ -3523,13 +3509,13 @@ int ib_uverbs_ex_query_device(struct ib_uverb=
s_file *file,
> 	if (ucore->outlen < resp.response_length + sizeof(resp.timestamp_mas=
k))
> 		goto end;
>=20
> -	resp.timestamp_mask =3D attr.timestamp_mask;
> +	resp.timestamp_mask =3D ib_dev->timestamp_mask;
> 	resp.response_length +=3D sizeof(resp.timestamp_mask);
>=20
> 	if (ucore->outlen < resp.response_length + sizeof(resp.hca_core_cloc=
k))
> 		goto end;
>=20
> -	resp.hca_core_clock =3D attr.hca_core_clock;
> +	resp.hca_core_clock =3D ib_dev->hca_core_clock;
> 	resp.response_length +=3D sizeof(resp.hca_core_clock);
>=20
> end:
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/cor=
e/verbs.c
> index bbbfd59..34ece9ec 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -226,12 +226,6 @@ EXPORT_SYMBOL(rdma_port_get_link_layer);
> struct ib_pd *ib_alloc_pd(struct ib_device *device)
> {
> 	struct ib_pd *pd;
> -	struct ib_device_attr devattr;
> -	int rc;
> -
> -	rc =3D ib_query_device(device, &devattr);
> -	if (rc)
> -		return ERR_PTR(rc);
>=20
> 	pd =3D device->alloc_pd(device, NULL, NULL);
> 	if (IS_ERR(pd))
> @@ -242,7 +236,7 @@ struct ib_pd *ib_alloc_pd(struct ib_device *devic=
e)
> 	pd->local_mr =3D NULL;
> 	atomic_set(&pd->usecnt, 0);
>=20
> -	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
> +	if (device->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
> 		pd->local_dma_lkey =3D device->local_dma_lkey;
> 	else {
> 		struct ib_mr *mr;
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/in=
finiband/hw/cxgb3/iwch_provider.c
> index 99ae2ab..db4c08c 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1174,43 +1174,6 @@ static u64 fw_vers_string_to_u64(struct iwch_d=
ev *iwch_dev)
> 	       (fw_mic & 0xffff);
> }
>=20
> -static int iwch_query_device(struct ib_device *ibdev, struct ib_devi=
ce_attr *props,
> -			     struct ib_udata *uhw)
> -{
> -
> -	struct iwch_dev *dev;
> -
> -	PDBG("%s ibdev %p\n", __func__, ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	dev =3D to_iwch_dev(ibdev);
> -	memset(props, 0, sizeof *props);
> -	memcpy(&props->sys_image_guid, dev->rdev.t3cdev_p->lldev->dev_addr,=
 6);
> -	props->hw_ver =3D dev->rdev.t3cdev_p->type;
> -	props->fw_ver =3D fw_vers_string_to_u64(dev);
> -	props->device_cap_flags =3D dev->device_cap_flags;
> -	props->page_size_cap =3D dev->attr.mem_pgsizes_bitmask;
> -	props->vendor_id =3D (u32)dev->rdev.rnic_info.pdev->vendor;
> -	props->vendor_part_id =3D (u32)dev->rdev.rnic_info.pdev->device;
> -	props->max_mr_size =3D dev->attr.max_mr_size;
> -	props->max_qp =3D dev->attr.max_qps;
> -	props->max_qp_wr =3D dev->attr.max_wrs;
> -	props->max_sge =3D dev->attr.max_sge_per_wr;
> -	props->max_sge_rd =3D 1;
> -	props->max_qp_rd_atom =3D dev->attr.max_rdma_reads_per_qp;
> -	props->max_qp_init_rd_atom =3D dev->attr.max_rdma_reads_per_qp;
> -	props->max_cq =3D dev->attr.max_cqs;
> -	props->max_cqe =3D dev->attr.max_cqes_per_cq;
> -	props->max_mr =3D dev->attr.max_mem_regs;
> -	props->max_pd =3D dev->attr.max_pds;
> -	props->local_ca_ack_delay =3D 0;
> -	props->max_fast_reg_page_list_len =3D T3_MAX_FASTREG_DEPTH;
> -
> -	return 0;
> -}
> -
> static int iwch_query_port(struct ib_device *ibdev,
> 			   u8 port, struct ib_port_attr *props)
> {
> @@ -1433,7 +1396,6 @@ int iwch_register_device(struct iwch_dev *dev)
> 	dev->ibdev.phys_port_cnt =3D dev->rdev.port_info.nports;
> 	dev->ibdev.num_comp_vectors =3D 1;
> 	dev->ibdev.dma_device =3D &(dev->rdev.rnic_info.pdev->dev);
> -	dev->ibdev.query_device =3D iwch_query_device;
> 	dev->ibdev.query_port =3D iwch_query_port;
> 	dev->ibdev.query_pkey =3D iwch_query_pkey;
> 	dev->ibdev.query_gid =3D iwch_query_gid;
> @@ -1484,6 +1446,28 @@ int iwch_register_device(struct iwch_dev *dev)
> 	dev->ibdev.iwcm->rem_ref =3D iwch_qp_rem_ref;
> 	dev->ibdev.iwcm->get_qp =3D iwch_get_qp;
>=20
> +	memcpy(&dev->ibdev.sys_image_guid,
> +		dev->rdev.t3cdev_p->lldev->dev_addr, 6);
> +	dev->ibdev.hw_ver =3D dev->rdev.t3cdev_p->type;
> +	dev->ibdev.fw_ver =3D fw_vers_string_to_u64(dev);
> +	dev->ibdev.device_cap_flags =3D dev->device_cap_flags;
> +	dev->ibdev.page_size_cap =3D dev->attr.mem_pgsizes_bitmask;
> +	dev->ibdev.vendor_id =3D (u32)dev->rdev.rnic_info.pdev->vendor;
> +	dev->ibdev.vendor_part_id =3D (u32)dev->rdev.rnic_info.pdev->device=
;
> +	dev->ibdev.max_mr_size =3D dev->attr.max_mr_size;
> +	dev->ibdev.max_qp =3D dev->attr.max_qps;
> +	dev->ibdev.max_qp_wr =3D dev->attr.max_wrs;
> +	dev->ibdev.max_sge =3D dev->attr.max_sge_per_wr;
> +	dev->ibdev.max_sge_rd =3D 1;
> +	dev->ibdev.max_qp_rd_atom =3D dev->attr.max_rdma_reads_per_qp;
> +	dev->ibdev.max_qp_init_rd_atom =3D dev->attr.max_rdma_reads_per_qp;
> +	dev->ibdev.max_cq =3D dev->attr.max_cqs;
> +	dev->ibdev.max_cqe =3D dev->attr.max_cqes_per_cq;
> +	dev->ibdev.max_mr =3D dev->attr.max_mem_regs;
> +	dev->ibdev.max_pd =3D dev->attr.max_pds;
> +	dev->ibdev.local_ca_ack_delay =3D 0;
> +	dev->ibdev.max_fast_reg_page_list_len =3D T3_MAX_FASTREG_DEPTH;
> +
> 	ret =3D ib_register_device(&dev->ibdev, NULL);
> 	if (ret)
> 		goto bail1;
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infinib=
and/hw/cxgb4/provider.c
> index 8f115b4..84e9b5d 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -305,45 +305,6 @@ static int c4iw_query_gid(struct ib_device *ibde=
v, u8 port, int index,
> 	return 0;
> }
>=20
> -static int c4iw_query_device(struct ib_device *ibdev, struct ib_devi=
ce_attr *props,
> -			     struct ib_udata *uhw)
> -{
> -
> -	struct c4iw_dev *dev;
> -
> -	PDBG("%s ibdev %p\n", __func__, ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	dev =3D to_c4iw_dev(ibdev);
> -	memset(props, 0, sizeof *props);
> -	memcpy(&props->sys_image_guid, dev->rdev.lldi.ports[0]->dev_addr, 6=
);
> -	props->hw_ver =3D CHELSIO_CHIP_RELEASE(dev->rdev.lldi.adapter_type)=
;
> -	props->fw_ver =3D dev->rdev.lldi.fw_vers;
> -	props->device_cap_flags =3D dev->device_cap_flags;
> -	props->page_size_cap =3D T4_PAGESIZE_MASK;
> -	props->vendor_id =3D (u32)dev->rdev.lldi.pdev->vendor;
> -	props->vendor_part_id =3D (u32)dev->rdev.lldi.pdev->device;
> -	props->max_mr_size =3D T4_MAX_MR_SIZE;
> -	props->max_qp =3D dev->rdev.lldi.vr->qp.size / 2;
> -	props->max_qp_wr =3D dev->rdev.hw_queue.t4_max_qp_depth;
> -	props->max_sge =3D T4_MAX_RECV_SGE;
> -	props->max_sge_rd =3D 1;
> -	props->max_res_rd_atom =3D dev->rdev.lldi.max_ird_adapter;
> -	props->max_qp_rd_atom =3D min(dev->rdev.lldi.max_ordird_qp,
> -				    c4iw_max_read_depth);
> -	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
> -	props->max_cq =3D dev->rdev.lldi.vr->qp.size;
> -	props->max_cqe =3D dev->rdev.hw_queue.t4_max_cq_depth;
> -	props->max_mr =3D c4iw_num_stags(&dev->rdev);
> -	props->max_pd =3D T4_MAX_NUM_PD;
> -	props->local_ca_ack_delay =3D 0;
> -	props->max_fast_reg_page_list_len =3D t4_max_fr_depth(use_dsgl);
> -
> -	return 0;
> -}
> -
> static int c4iw_query_port(struct ib_device *ibdev, u8 port,
> 			   struct ib_port_attr *props)
> {
> @@ -529,7 +490,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
> 	dev->ibdev.phys_port_cnt =3D dev->rdev.lldi.nports;
> 	dev->ibdev.num_comp_vectors =3D  dev->rdev.lldi.nciq;
> 	dev->ibdev.dma_device =3D &(dev->rdev.lldi.pdev->dev);
> -	dev->ibdev.query_device =3D c4iw_query_device;
> 	dev->ibdev.query_port =3D c4iw_query_port;
> 	dev->ibdev.query_pkey =3D c4iw_query_pkey;
> 	dev->ibdev.query_gid =3D c4iw_query_gid;
> @@ -581,6 +541,30 @@ int c4iw_register_device(struct c4iw_dev *dev)
> 	dev->ibdev.iwcm->rem_ref =3D c4iw_qp_rem_ref;
> 	dev->ibdev.iwcm->get_qp =3D c4iw_get_qp;
>=20
> +	memcpy(&dev->ibdev.sys_image_guid,
> +		dev->rdev.lldi.ports[0]->dev_addr, 6);
> +	dev->ibdev.hw_ver =3D CHELSIO_CHIP_RELEASE(dev->rdev.lldi.adapter_t=
ype);
> +	dev->ibdev.fw_ver =3D dev->rdev.lldi.fw_vers;
> +	dev->ibdev.device_cap_flags =3D dev->device_cap_flags;
> +	dev->ibdev.page_size_cap =3D T4_PAGESIZE_MASK;
> +	dev->ibdev.vendor_id =3D (u32)dev->rdev.lldi.pdev->vendor;
> +	dev->ibdev.vendor_part_id =3D (u32)dev->rdev.lldi.pdev->device;
> +	dev->ibdev.max_mr_size =3D T4_MAX_MR_SIZE;
> +	dev->ibdev.max_qp =3D dev->rdev.lldi.vr->qp.size / 2;
> +	dev->ibdev.max_qp_wr =3D dev->rdev.hw_queue.t4_max_qp_depth;
> +	dev->ibdev.max_sge =3D T4_MAX_RECV_SGE;
> +	dev->ibdev.max_sge_rd =3D 1;
> +	dev->ibdev.max_res_rd_atom =3D dev->rdev.lldi.max_ird_adapter;
> +	dev->ibdev.max_qp_rd_atom =3D min(dev->rdev.lldi.max_ordird_qp,
> +				    c4iw_max_read_depth);
> +	dev->ibdev.max_qp_init_rd_atom =3D dev->ibdev.max_qp_rd_atom;
> +	dev->ibdev.max_cq =3D dev->rdev.lldi.vr->qp.size;
> +	dev->ibdev.max_cqe =3D dev->rdev.hw_queue.t4_max_cq_depth;
> +	dev->ibdev.max_mr =3D c4iw_num_stags(&dev->rdev);
> +	dev->ibdev.max_pd =3D T4_MAX_NUM_PD;
> +	dev->ibdev.local_ca_ack_delay =3D 0;
> +	dev->ibdev.max_fast_reg_page_list_len =3D t4_max_fr_depth(use_dsgl)=
;
> +
> 	ret =3D ib_register_device(&dev->ibdev, NULL);
> 	if (ret)
> 		goto bail1;
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/h=
w/mlx4/main.c
> index a25048b..33d8557 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -356,15 +356,12 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4=
_ib_dev *ibdev,
> 	return real_index;
> }
>=20
> -static int mlx4_ib_query_device(struct ib_device *ibdev,
> -				struct ib_device_attr *props,
> -				struct ib_udata *uhw)
> +static int mlx4_ib_query_device(struct ib_device *ibdev, struct ib_u=
data *uhw)
> {
> 	struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
> 	struct ib_smp *in_mad  =3D NULL;
> 	struct ib_smp *out_mad =3D NULL;
> 	int err =3D -ENOMEM;
> -	int have_ib_ports;
> 	struct mlx4_uverbs_ex_query_device cmd;
> 	struct mlx4_uverbs_ex_query_device_resp resp =3D {.comp_mask =3D 0};
> 	struct mlx4_clock_params clock_params;
> @@ -399,102 +396,135 @@ static int mlx4_ib_query_device(struct ib_dev=
ice *ibdev,
> 	if (err)
> 		goto out;
>=20
> -	memset(props, 0, sizeof *props);
> +	if (!mlx4_is_slave(dev->dev))
> +		err =3D mlx4_get_internal_clock_params(dev->dev, &clock_params);
> +
> +	if (uhw->outlen >=3D resp.response_length + sizeof(resp.hca_core_cl=
ock_offset)) {
> +		resp.response_length +=3D sizeof(resp.hca_core_clock_offset);
> +		if (!err && !mlx4_is_slave(dev->dev)) {
> +			resp.comp_mask |=3D QUERY_DEVICE_RESP_MASK_TIMESTAMP;
> +			resp.hca_core_clock_offset =3D clock_params.offset % PAGE_SIZE;
> +		}
> +	}
> +
> +	if (uhw->outlen) {
> +		err =3D ib_copy_to_udata(uhw, &resp, resp.response_length);
> +		if (err)
> +			goto out;
> +	}
> +out:
> +	kfree(in_mad);
> +	kfree(out_mad);
> +
> +	return err;
> +}
> +
> +static int mlx4_ib_init_device_flags(struct ib_device *ibdev)
> +{
> +	struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
> +	struct ib_smp *in_mad  =3D NULL;
> +	struct ib_smp *out_mad =3D NULL;
> +	int err =3D -ENOMEM;
> +	int have_ib_ports;
> +	struct mlx4_uverbs_ex_query_device_resp resp =3D {.comp_mask =3D 0}=
;
> +	struct mlx4_clock_params clock_params;
> +
> +	resp.response_length =3D offsetof(typeof(resp), response_length) +
> +		sizeof(resp.response_length);
> +	in_mad  =3D kzalloc(sizeof *in_mad, GFP_KERNEL);
> +	out_mad =3D kmalloc(sizeof *out_mad, GFP_KERNEL);
> +	if (!in_mad || !out_mad)
> +		goto out;
> +
> +	init_query_mad(in_mad);
> +	in_mad->attr_id =3D IB_SMP_ATTR_NODE_INFO;
> +
> +	err =3D mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS,
> +			   1, NULL, NULL, in_mad, out_mad);
> +	if (err)
> +		goto out;
>=20
> 	have_ib_ports =3D num_ib_ports(dev->dev);
>=20
> -	props->fw_ver =3D dev->dev->caps.fw_ver;
> -	props->device_cap_flags    =3D IB_DEVICE_CHANGE_PHY_PORT |
> +	ibdev->fw_ver =3D dev->dev->caps.fw_ver;
> +	ibdev->device_cap_flags    =3D IB_DEVICE_CHANGE_PHY_PORT |
> 		IB_DEVICE_PORT_ACTIVE_EVENT		|
> 		IB_DEVICE_SYS_IMAGE_GUID		|
> 		IB_DEVICE_RC_RNR_NAK_GEN		|
> 		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR)
> -		props->device_cap_flags |=3D IB_DEVICE_BAD_PKEY_CNTR;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_BAD_PKEY_CNTR;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
> -		props->device_cap_flags |=3D IB_DEVICE_BAD_QKEY_CNTR;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_BAD_QKEY_CNTR;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_APM && have_ib_ports)
> -		props->device_cap_flags |=3D IB_DEVICE_AUTO_PATH_MIG;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_AUTO_PATH_MIG;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_UD_AV_PORT)
> -		props->device_cap_flags |=3D IB_DEVICE_UD_AV_PORT_ENFORCE;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_UD_AV_PORT_ENFORCE;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IPOIB_CSUM)
> -		props->device_cap_flags |=3D IB_DEVICE_UD_IP_CSUM;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_UD_IP_CSUM;
> 	if (dev->dev->caps.max_gso_sz &&
> 	    (dev->dev->rev_id !=3D MLX4_IB_CARD_REV_A0) &&
> 	    (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH))
> -		props->device_cap_flags |=3D IB_DEVICE_UD_TSO;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_UD_TSO;
> 	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
> -		props->device_cap_flags |=3D IB_DEVICE_LOCAL_DMA_LKEY;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_LOCAL_DMA_LKEY;
> 	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
> 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
> 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
> -		props->device_cap_flags |=3D IB_DEVICE_MEM_MGT_EXTENSIONS;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_MEM_MGT_EXTENSIONS;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC)
> -		props->device_cap_flags |=3D IB_DEVICE_XRC;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_XRC;
> 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW)
> -		props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW;
> 	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN) {
> 		if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_WIN_TYPE_2B)
> -			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2B;
> +			ibdev->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2B;
> 		else
> -			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2A;
> -	if (dev->steering_support =3D=3D  MLX4_STEERING_MODE_DEVICE_MANAGED=
)
> -		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
> +			ibdev->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2A;
> +		if (dev->steering_support =3D=3D  MLX4_STEERING_MODE_DEVICE_MANAGE=
D)
> +			ibdev->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
> 	}
>=20
> -	props->vendor_id	   =3D be32_to_cpup((__be32 *) (out_mad->data + 36=
)) &
> +	ibdev->vendor_id	   =3D be32_to_cpup((__be32 *) (out_mad->data + 36=
)) &
> 		0xffffff;
> -	props->vendor_part_id	   =3D dev->dev->persist->pdev->device;
> -	props->hw_ver		   =3D be32_to_cpup((__be32 *) (out_mad->data + 32))=
;
> -	memcpy(&props->sys_image_guid, out_mad->data +	4, 8);
> -
> -	props->max_mr_size	   =3D ~0ull;
> -	props->page_size_cap	   =3D dev->dev->caps.page_size_cap;
> -	props->max_qp		   =3D dev->dev->quotas.qp;
> -	props->max_qp_wr	   =3D dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SP=
ARE;
> -	props->max_sge		   =3D min(dev->dev->caps.max_sq_sg,
> +	ibdev->vendor_part_id	   =3D dev->dev->persist->pdev->device;
> +	ibdev->hw_ver		   =3D be32_to_cpup((__be32 *) (out_mad->data + 32))=
;
> +	memcpy(&ibdev->sys_image_guid, out_mad->data +	4, 8);
> +
> +	ibdev->max_mr_size	   =3D ~0ull;
> +	ibdev->page_size_cap	   =3D dev->dev->caps.page_size_cap;
> +	ibdev->max_qp		   =3D dev->dev->quotas.qp;
> +	ibdev->max_qp_wr	   =3D dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SP=
ARE;
> +	ibdev->max_sge		   =3D min(dev->dev->caps.max_sq_sg,
> 					 dev->dev->caps.max_rq_sg);
> -	props->max_sge_rd =3D props->max_sge;
> -	props->max_cq		   =3D dev->dev->quotas.cq;
> -	props->max_cqe		   =3D dev->dev->caps.max_cqes;
> -	props->max_mr		   =3D dev->dev->quotas.mpt;
> -	props->max_pd		   =3D dev->dev->caps.num_pds - dev->dev->caps.reser=
ved_pds;
> -	props->max_qp_rd_atom	   =3D dev->dev->caps.max_qp_dest_rdma;
> -	props->max_qp_init_rd_atom =3D dev->dev->caps.max_qp_init_rdma;
> -	props->max_res_rd_atom	   =3D props->max_qp_rd_atom * props->max_qp=
;
> -	props->max_srq		   =3D dev->dev->quotas.srq;
> -	props->max_srq_wr	   =3D dev->dev->caps.max_srq_wqes - 1;
> -	props->max_srq_sge	   =3D dev->dev->caps.max_srq_sge;
> -	props->max_fast_reg_page_list_len =3D MLX4_MAX_FAST_REG_PAGES;
> -	props->local_ca_ack_delay  =3D dev->dev->caps.local_ca_ack_delay;
> -	props->atomic_cap	   =3D dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_A=
TOMIC ?
> +	ibdev->max_sge_rd	   =3D ibdev->max_sge;
> +	ibdev->max_cq		   =3D dev->dev->quotas.cq;
> +	ibdev->max_cqe		   =3D dev->dev->caps.max_cqes;
> +	ibdev->max_mr		   =3D dev->dev->quotas.mpt;
> +	ibdev->max_pd		   =3D dev->dev->caps.num_pds - dev->dev->caps.reser=
ved_pds;
> +	ibdev->max_qp_rd_atom	   =3D dev->dev->caps.max_qp_dest_rdma;
> +	ibdev->max_qp_init_rd_atom =3D dev->dev->caps.max_qp_init_rdma;
> +	ibdev->max_res_rd_atom	   =3D ibdev->max_qp_rd_atom * ibdev->max_qp=
;
> +	ibdev->max_srq		   =3D dev->dev->quotas.srq;
> +	ibdev->max_srq_wr	   =3D dev->dev->caps.max_srq_wqes - 1;
> +	ibdev->max_srq_sge	   =3D dev->dev->caps.max_srq_sge;
> +	ibdev->max_fast_reg_page_list_len =3D MLX4_MAX_FAST_REG_PAGES;
> +	ibdev->local_ca_ack_delay  =3D dev->dev->caps.local_ca_ack_delay;
> +	ibdev->atomic_cap	   =3D dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_A=
TOMIC ?
> 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
> -	props->masked_atomic_cap   =3D props->atomic_cap;
> -	props->max_pkeys	   =3D dev->dev->caps.pkey_table_len[1];
> -	props->max_mcast_grp	   =3D dev->dev->caps.num_mgms + dev->dev->cap=
s.num_amgms;
> -	props->max_mcast_qp_attach =3D dev->dev->caps.num_qp_per_mgm;
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -					   props->max_mcast_grp;
> -	props->max_map_per_fmr =3D dev->dev->caps.max_fmr_maps;
> -	props->hca_core_clock =3D dev->dev->caps.hca_core_clock * 1000UL;
> -	props->timestamp_mask =3D 0xFFFFFFFFFFFFULL;
> +	ibdev->masked_atomic_cap   =3D ibdev->atomic_cap;
> +	ibdev->max_pkeys	   =3D dev->dev->caps.pkey_table_len[1];
> +	ibdev->max_mcast_grp	   =3D dev->dev->caps.num_mgms + dev->dev->cap=
s.num_amgms;
> +	ibdev->max_mcast_qp_attach =3D dev->dev->caps.num_qp_per_mgm;
> +	ibdev->max_total_mcast_qp_attach =3D ibdev->max_mcast_qp_attach *
> +					   ibdev->max_mcast_grp;
> +	ibdev->max_map_per_fmr =3D dev->dev->caps.max_fmr_maps;
> +	ibdev->hca_core_clock =3D dev->dev->caps.hca_core_clock * 1000UL;
> +	ibdev->timestamp_mask =3D 0xFFFFFFFFFFFFULL;
>=20
> 	if (!mlx4_is_slave(dev->dev))
> 		err =3D mlx4_get_internal_clock_params(dev->dev, &clock_params);
>=20
> -	if (uhw->outlen >=3D resp.response_length + sizeof(resp.hca_core_cl=
ock_offset)) {
> -		resp.response_length +=3D sizeof(resp.hca_core_clock_offset);
> -		if (!err && !mlx4_is_slave(dev->dev)) {
> -			resp.comp_mask |=3D QUERY_DEVICE_RESP_MASK_TIMESTAMP;
> -			resp.hca_core_clock_offset =3D clock_params.offset % PAGE_SIZE;
> -		}
> -	}
> -
> -	if (uhw->outlen) {
> -		err =3D ib_copy_to_udata(uhw, &resp, resp.response_length);
> -		if (err)
> -			goto out;
> -	}
> out:
> 	kfree(in_mad);
> 	kfree(out_mad);
> @@ -2298,6 +2328,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>=20
> 	spin_lock_init(&iboe->lock);
>=20
> +	if (mlx4_ib_init_device_flags(&ibdev->ib_dev))
> +		goto err_map;
> +
> 	if (init_node_data(ibdev))
> 		goto err_map;
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> index 32f20d0..c27b7ab 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -203,9 +203,7 @@ static int mlx5_query_node_desc(struct mlx5_ib_de=
v *dev, char *node_desc)
> 				    MLX5_REG_NODE_DESC, 0, 0);
> }
>=20
> -static int mlx5_ib_query_device(struct ib_device *ibdev,
> -				struct ib_device_attr *props,
> -				struct ib_udata *uhw)
> +static int mlx5_ib_init_device_flags(struct ib_device *ibdev)
> {
> 	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
> 	struct mlx5_core_dev *mdev =3D dev->mdev;
> @@ -214,90 +212,86 @@ static int mlx5_ib_query_device(struct ib_devic=
e *ibdev,
> 	int max_sq_sg;
> 	u64 min_page_size =3D 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
>=20
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	memset(props, 0, sizeof(*props));
> 	err =3D mlx5_query_system_image_guid(ibdev,
> -					   &props->sys_image_guid);
> +					   &ibdev->sys_image_guid);
> 	if (err)
> 		return err;
>=20
> -	err =3D mlx5_query_max_pkeys(ibdev, &props->max_pkeys);
> +	err =3D mlx5_query_max_pkeys(ibdev, &ibdev->max_pkeys);
> 	if (err)
> 		return err;
>=20
> -	err =3D mlx5_query_vendor_id(ibdev, &props->vendor_id);
> +	err =3D mlx5_query_vendor_id(ibdev, &ibdev->vendor_id);
> 	if (err)
> 		return err;
>=20
> -	props->fw_ver =3D ((u64)fw_rev_maj(dev->mdev) << 32) |
> +	ibdev->fw_ver =3D ((u64)fw_rev_maj(dev->mdev) << 32) |
> 		(fw_rev_min(dev->mdev) << 16) |
> 		fw_rev_sub(dev->mdev);
> -	props->device_cap_flags    =3D IB_DEVICE_CHANGE_PHY_PORT |
> +	ibdev->device_cap_flags    =3D IB_DEVICE_CHANGE_PHY_PORT |
> 		IB_DEVICE_PORT_ACTIVE_EVENT		|
> 		IB_DEVICE_SYS_IMAGE_GUID		|
> 		IB_DEVICE_RC_RNR_NAK_GEN;
>=20
> 	if (MLX5_CAP_GEN(mdev, pkv))
> -		props->device_cap_flags |=3D IB_DEVICE_BAD_PKEY_CNTR;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_BAD_PKEY_CNTR;
> 	if (MLX5_CAP_GEN(mdev, qkv))
> -		props->device_cap_flags |=3D IB_DEVICE_BAD_QKEY_CNTR;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_BAD_QKEY_CNTR;
> 	if (MLX5_CAP_GEN(mdev, apm))
> -		props->device_cap_flags |=3D IB_DEVICE_AUTO_PATH_MIG;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_AUTO_PATH_MIG;
> 	if (MLX5_CAP_GEN(mdev, xrc))
> -		props->device_cap_flags |=3D IB_DEVICE_XRC;
> -	props->device_cap_flags |=3D IB_DEVICE_MEM_MGT_EXTENSIONS;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_XRC;
> +	ibdev->device_cap_flags |=3D IB_DEVICE_MEM_MGT_EXTENSIONS;
> 	if (MLX5_CAP_GEN(mdev, sho)) {
> -		props->device_cap_flags |=3D IB_DEVICE_SIGNATURE_HANDOVER;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_SIGNATURE_HANDOVER;
> 		/* At this stage no support for signature handover */
> -		props->sig_prot_cap =3D IB_PROT_T10DIF_TYPE_1 |
> +		ibdev->sig_prot_cap =3D IB_PROT_T10DIF_TYPE_1 |
> 				      IB_PROT_T10DIF_TYPE_2 |
> 				      IB_PROT_T10DIF_TYPE_3;
> -		props->sig_guard_cap =3D IB_GUARD_T10DIF_CRC |
> +		ibdev->sig_guard_cap =3D IB_GUARD_T10DIF_CRC |
> 				       IB_GUARD_T10DIF_CSUM;
> 	}
> 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
> -		props->device_cap_flags |=3D IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
>=20
> -	props->vendor_part_id	   =3D mdev->pdev->device;
> -	props->hw_ver		   =3D mdev->pdev->revision;
> +	ibdev->vendor_part_id	   =3D mdev->pdev->device;
> +	ibdev->hw_ver		   =3D mdev->pdev->revision;
>=20
> -	props->max_mr_size	   =3D ~0ull;
> -	props->page_size_cap	   =3D ~(min_page_size - 1);
> -	props->max_qp		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp);
> -	props->max_qp_wr	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
> +	ibdev->max_mr_size	   =3D ~0ull;
> +	ibdev->page_size_cap	   =3D ~(min_page_size - 1);
> +	ibdev->max_qp		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp);
> +	ibdev->max_qp_wr	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
> 	max_rq_sg =3D  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
> 		     sizeof(struct mlx5_wqe_data_seg);
> 	max_sq_sg =3D (MLX5_CAP_GEN(mdev, max_wqe_sz_sq) -
> 		     sizeof(struct mlx5_wqe_ctrl_seg)) /
> 		     sizeof(struct mlx5_wqe_data_seg);
> -	props->max_sge =3D min(max_rq_sg, max_sq_sg);
> -	props->max_sge_rd =3D props->max_sge;
> -	props->max_cq		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_cq);
> -	props->max_cqe =3D (1 << MLX5_CAP_GEN(mdev, log_max_eq_sz)) - 1;
> -	props->max_mr		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
> -	props->max_pd		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_pd);
> -	props->max_qp_rd_atom	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_ra_req=
_qp);
> -	props->max_qp_init_rd_atom =3D 1 << MLX5_CAP_GEN(mdev, log_max_ra_r=
es_qp);
> -	props->max_srq		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_srq);
> -	props->max_srq_wr =3D (1 << MLX5_CAP_GEN(mdev, log_max_srq_sz)) - 1=
;
> -	props->local_ca_ack_delay  =3D MLX5_CAP_GEN(mdev, local_ca_ack_dela=
y);
> -	props->max_res_rd_atom	   =3D props->max_qp_rd_atom * props->max_qp=
;
> -	props->max_srq_sge	   =3D max_rq_sg - 1;
> -	props->max_fast_reg_page_list_len =3D (unsigned int)-1;
> -	props->atomic_cap	   =3D IB_ATOMIC_NONE;
> -	props->masked_atomic_cap   =3D IB_ATOMIC_NONE;
> -	props->max_mcast_grp	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
> -	props->max_mcast_qp_attach =3D MLX5_CAP_GEN(mdev, max_qp_mcg);
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -					   props->max_mcast_grp;
> -	props->max_map_per_fmr =3D INT_MAX; /* no limit in ConnectIB */
> +	ibdev->max_sge =3D min(max_rq_sg, max_sq_sg);
> +	ibdev->max_sge_rd =3D ibdev->max_sge;
> +	ibdev->max_cq		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_cq);
> +	ibdev->max_cqe =3D (1 << MLX5_CAP_GEN(mdev, log_max_eq_sz)) - 1;
> +	ibdev->max_mr		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
> +	ibdev->max_pd		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_pd);
> +	ibdev->max_qp_rd_atom	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_ra_req=
_qp);
> +	ibdev->max_qp_init_rd_atom =3D 1 << MLX5_CAP_GEN(mdev, log_max_ra_r=
es_qp);
> +	ibdev->max_srq		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_srq);
> +	ibdev->max_srq_wr =3D (1 << MLX5_CAP_GEN(mdev, log_max_srq_sz)) - 1=
;
> +	ibdev->local_ca_ack_delay  =3D MLX5_CAP_GEN(mdev, local_ca_ack_dela=
y);
> +	ibdev->max_res_rd_atom	   =3D ibdev->max_qp_rd_atom * ibdev->max_qp=
;
> +	ibdev->max_srq_sge	   =3D max_rq_sg - 1;
> +	ibdev->max_fast_reg_page_list_len =3D (unsigned int)-1;
> +	ibdev->atomic_cap	   =3D IB_ATOMIC_NONE;
> +	ibdev->masked_atomic_cap   =3D IB_ATOMIC_NONE;
> +	ibdev->max_mcast_grp	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
> +	ibdev->max_mcast_qp_attach =3D MLX5_CAP_GEN(mdev, max_qp_mcg);
> +	ibdev->max_total_mcast_qp_attach =3D ibdev->max_mcast_qp_attach *
> +					   ibdev->max_mcast_grp;
> +	ibdev->max_map_per_fmr =3D INT_MAX; /* no limit in ConnectIB */
>=20
> #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> 	if (MLX5_CAP_GEN(mdev, pg))
> -		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> -	props->odp_caps =3D dev->odp_caps;
> +		ibdev->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> +	ibdev->odp_caps =3D dev->odp_caps;
> #endif
>=20
> 	return 0;
> @@ -1013,26 +1007,14 @@ static void get_ext_port_caps(struct mlx5_ib_=
dev *dev)
>=20
> static int get_port_caps(struct mlx5_ib_dev *dev)
> {
> -	struct ib_device_attr *dprops =3D NULL;
> 	struct ib_port_attr *pprops =3D NULL;
> 	int err =3D -ENOMEM;
> 	int port;
> -	struct ib_udata uhw =3D {.inlen =3D 0, .outlen =3D 0};
>=20
> 	pprops =3D kmalloc(sizeof(*pprops), GFP_KERNEL);
> 	if (!pprops)
> 		goto out;
>=20
> -	dprops =3D kmalloc(sizeof(*dprops), GFP_KERNEL);
> -	if (!dprops)
> -		goto out;
> -
> -	err =3D mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
> -	if (err) {
> -		mlx5_ib_warn(dev, "query_device failed %d\n", err);
> -		goto out;
> -	}
> -
> 	for (port =3D 1; port <=3D MLX5_CAP_GEN(dev->mdev, num_ports); port+=
+) {
> 		err =3D mlx5_ib_query_port(&dev->ib_dev, port, pprops);
> 		if (err) {
> @@ -1041,16 +1023,15 @@ static int get_port_caps(struct mlx5_ib_dev *=
dev)
> 			break;
> 		}
> 		dev->mdev->port_caps[port - 1].pkey_table_len =3D
> -						dprops->max_pkeys;
> +						dev->ib_dev.max_pkeys;
> 		dev->mdev->port_caps[port - 1].gid_table_len =3D
> 						pprops->gid_tbl_len;
> 		mlx5_ib_dbg(dev, "pkey_table_len %d, gid_table_len %d\n",
> -			    dprops->max_pkeys, pprops->gid_tbl_len);
> +			    dev->ib_dev.max_pkeys, pprops->gid_tbl_len);
> 	}
>=20
> out:
> 	kfree(pprops);
> -	kfree(dprops);
>=20
> 	return err;
> }
> @@ -1394,7 +1375,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *=
mdev)
> 	dev->ib_dev.uverbs_ex_cmd_mask =3D
> 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
>=20
> -	dev->ib_dev.query_device	=3D mlx5_ib_query_device;
> 	dev->ib_dev.query_port		=3D mlx5_ib_query_port;
> 	dev->ib_dev.query_gid		=3D mlx5_ib_query_gid;
> 	dev->ib_dev.query_pkey		=3D mlx5_ib_query_pkey;
> @@ -1460,6 +1440,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev =
*mdev)
> 	if (err)
> 		goto err_rsrc;
>=20
> +	err =3D mlx5_ib_init_device_flags(&dev->ib_dev);
> +	if (err)
> +		goto err_rsrc;
> +
> 	err =3D ib_register_device(&dev->ib_dev, NULL);
> 	if (err)
> 		goto err_odp;
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/i=
nfiniband/hw/mthca/mthca_provider.c
> index dc2d48c..28d7a8b 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -57,25 +57,19 @@ static void init_query_mad(struct ib_smp *mad)
> 	mad->method    	   =3D IB_MGMT_METHOD_GET;
> }
>=20
> -static int mthca_query_device(struct ib_device *ibdev, struct ib_dev=
ice_attr *props,
> -			      struct ib_udata *uhw)
> +static int mthca_init_device_flags(struct ib_device *ibdev)
> {
> 	struct ib_smp *in_mad  =3D NULL;
> 	struct ib_smp *out_mad =3D NULL;
> 	int err =3D -ENOMEM;
> 	struct mthca_dev *mdev =3D to_mdev(ibdev);
>=20
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> 	in_mad  =3D kzalloc(sizeof *in_mad, GFP_KERNEL);
> 	out_mad =3D kmalloc(sizeof *out_mad, GFP_KERNEL);
> 	if (!in_mad || !out_mad)
> 		goto out;
>=20
> -	memset(props, 0, sizeof *props);
> -
> -	props->fw_ver              =3D mdev->fw_ver;
> +	ibdev->fw_ver              =3D mdev->fw_ver;
>=20
> 	init_query_mad(in_mad);
> 	in_mad->attr_id =3D IB_SMP_ATTR_NODE_INFO;
> @@ -85,46 +79,46 @@ static int mthca_query_device(struct ib_device *i=
bdev, struct ib_device_attr *pr
> 	if (err)
> 		goto out;
>=20
> -	props->device_cap_flags    =3D mdev->device_cap_flags;
> -	props->vendor_id           =3D be32_to_cpup((__be32 *) (out_mad->da=
ta + 36)) &
> +	ibdev->device_cap_flags    =3D mdev->device_cap_flags;
> +	ibdev->vendor_id           =3D be32_to_cpup((__be32 *) (out_mad->da=
ta + 36)) &
> 		0xffffff;
> -	props->vendor_part_id      =3D be16_to_cpup((__be16 *) (out_mad->da=
ta + 30));
> -	props->hw_ver              =3D be32_to_cpup((__be32 *) (out_mad->da=
ta + 32));
> -	memcpy(&props->sys_image_guid, out_mad->data +  4, 8);
> -
> -	props->max_mr_size         =3D ~0ull;
> -	props->page_size_cap       =3D mdev->limits.page_size_cap;
> -	props->max_qp              =3D mdev->limits.num_qps - mdev->limits.=
reserved_qps;
> -	props->max_qp_wr           =3D mdev->limits.max_wqes;
> -	props->max_sge             =3D mdev->limits.max_sg;
> -	props->max_sge_rd          =3D props->max_sge;
> -	props->max_cq              =3D mdev->limits.num_cqs - mdev->limits.=
reserved_cqs;
> -	props->max_cqe             =3D mdev->limits.max_cqes;
> -	props->max_mr              =3D mdev->limits.num_mpts - mdev->limits=
=2Ereserved_mrws;
> -	props->max_pd              =3D mdev->limits.num_pds - mdev->limits.=
reserved_pds;
> -	props->max_qp_rd_atom      =3D 1 << mdev->qp_table.rdb_shift;
> -	props->max_qp_init_rd_atom =3D mdev->limits.max_qp_init_rdma;
> -	props->max_res_rd_atom     =3D props->max_qp_rd_atom * props->max_q=
p;
> -	props->max_srq             =3D mdev->limits.num_srqs - mdev->limits=
=2Ereserved_srqs;
> -	props->max_srq_wr          =3D mdev->limits.max_srq_wqes;
> -	props->max_srq_sge         =3D mdev->limits.max_srq_sge;
> -	props->local_ca_ack_delay  =3D mdev->limits.local_ca_ack_delay;
> -	props->atomic_cap          =3D mdev->limits.flags & DEV_LIM_FLAG_AT=
OMIC ?
> +	ibdev->vendor_part_id      =3D be16_to_cpup((__be16 *) (out_mad->da=
ta + 30));
> +	ibdev->hw_ver              =3D be32_to_cpup((__be32 *) (out_mad->da=
ta + 32));
> +	memcpy(&ibdev->sys_image_guid, out_mad->data +  4, 8);
> +
> +	ibdev->max_mr_size         =3D ~0ull;
> +	ibdev->page_size_cap       =3D mdev->limits.page_size_cap;
> +	ibdev->max_qp              =3D mdev->limits.num_qps - mdev->limits.=
reserved_qps;
> +	ibdev->max_qp_wr           =3D mdev->limits.max_wqes;
> +	ibdev->max_sge             =3D mdev->limits.max_sg;
> +	ibdev->max_sge_rd          =3D ibdev->max_sge;
> +	ibdev->max_cq              =3D mdev->limits.num_cqs - mdev->limits.=
reserved_cqs;
> +	ibdev->max_cqe             =3D mdev->limits.max_cqes;
> +	ibdev->max_mr              =3D mdev->limits.num_mpts - mdev->limits=
=2Ereserved_mrws;
> +	ibdev->max_pd              =3D mdev->limits.num_pds - mdev->limits.=
reserved_pds;
> +	ibdev->max_qp_rd_atom      =3D 1 << mdev->qp_table.rdb_shift;
> +	ibdev->max_qp_init_rd_atom =3D mdev->limits.max_qp_init_rdma;
> +	ibdev->max_res_rd_atom     =3D ibdev->max_qp_rd_atom * ibdev->max_q=
p;
> +	ibdev->max_srq             =3D mdev->limits.num_srqs - mdev->limits=
=2Ereserved_srqs;
> +	ibdev->max_srq_wr          =3D mdev->limits.max_srq_wqes;
> +	ibdev->max_srq_sge         =3D mdev->limits.max_srq_sge;
> +	ibdev->local_ca_ack_delay  =3D mdev->limits.local_ca_ack_delay;
> +	ibdev->atomic_cap          =3D mdev->limits.flags & DEV_LIM_FLAG_AT=
OMIC ?
> 					IB_ATOMIC_HCA : IB_ATOMIC_NONE;
> -	props->max_pkeys           =3D mdev->limits.pkey_table_len;
> -	props->max_mcast_grp       =3D mdev->limits.num_mgms + mdev->limits=
=2Enum_amgms;
> -	props->max_mcast_qp_attach =3D MTHCA_QP_PER_MGM;
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -					   props->max_mcast_grp;
> +	ibdev->max_pkeys           =3D mdev->limits.pkey_table_len;
> +	ibdev->max_mcast_grp       =3D mdev->limits.num_mgms + mdev->limits=
=2Enum_amgms;
> +	ibdev->max_mcast_qp_attach =3D MTHCA_QP_PER_MGM;
> +	ibdev->max_total_mcast_qp_attach =3D ibdev->max_mcast_qp_attach *
> +					   ibdev->max_mcast_grp;
> 	/*
> 	 * If Sinai memory key optimization is being used, then only
> 	 * the 8-bit key portion will change.  For other HCAs, the
> 	 * unused index bits will also be used for FMR remapping.
> 	 */
> 	if (mdev->mthca_flags & MTHCA_FLAG_SINAI_OPT)
> -		props->max_map_per_fmr =3D 255;
> +		ibdev->max_map_per_fmr =3D 255;
> 	else
> -		props->max_map_per_fmr =3D
> +		ibdev->max_map_per_fmr =3D
> 			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
>=20
> 	err =3D 0;
> @@ -1305,7 +1299,6 @@ int mthca_register_device(struct mthca_dev *dev=
)
> 	dev->ib_dev.phys_port_cnt        =3D dev->limits.num_ports;
> 	dev->ib_dev.num_comp_vectors     =3D 1;
> 	dev->ib_dev.dma_device           =3D &dev->pdev->dev;
> -	dev->ib_dev.query_device         =3D mthca_query_device;
> 	dev->ib_dev.query_port           =3D mthca_query_port;
> 	dev->ib_dev.modify_device        =3D mthca_modify_device;
> 	dev->ib_dev.modify_port          =3D mthca_modify_port;
> @@ -1377,6 +1370,10 @@ int mthca_register_device(struct mthca_dev *de=
v)
>=20
> 	mutex_init(&dev->cap_mask_mutex);
>=20
> +	ret =3D mthca_init_device_flags(&dev->ib_dev);
> +	if (ret)
> +		return ret;
> +
> 	ret =3D ib_register_device(&dev->ib_dev, NULL);
> 	if (ret)
> 		return ret;
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniba=
nd/hw/nes/nes_verbs.c
> index 51a0a9c..19d50b2 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -487,61 +487,6 @@ static int nes_map_mr_sg(struct ib_mr *ibmr,
> }
>=20
> /**
> - * nes_query_device
> - */
> -static int nes_query_device(struct ib_device *ibdev, struct ib_devic=
e_attr *props,
> -			    struct ib_udata *uhw)
> -{
> -	struct nes_vnic *nesvnic =3D to_nesvnic(ibdev);
> -	struct nes_device *nesdev =3D nesvnic->nesdev;
> -	struct nes_ib_device *nesibdev =3D nesvnic->nesibdev;
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	memset(props, 0, sizeof(*props));
> -	memcpy(&props->sys_image_guid, nesvnic->netdev->dev_addr, 6);
> -
> -	props->fw_ver =3D nesdev->nesadapter->firmware_version;
> -	props->device_cap_flags =3D nesdev->nesadapter->device_cap_flags;
> -	props->vendor_id =3D nesdev->nesadapter->vendor_id;
> -	props->vendor_part_id =3D nesdev->nesadapter->vendor_part_id;
> -	props->hw_ver =3D nesdev->nesadapter->hw_rev;
> -	props->max_mr_size =3D 0x80000000;
> -	props->max_qp =3D nesibdev->max_qp;
> -	props->max_qp_wr =3D nesdev->nesadapter->max_qp_wr - 2;
> -	props->max_sge =3D nesdev->nesadapter->max_sge;
> -	props->max_cq =3D nesibdev->max_cq;
> -	props->max_cqe =3D nesdev->nesadapter->max_cqe;
> -	props->max_mr =3D nesibdev->max_mr;
> -	props->max_mw =3D nesibdev->max_mr;
> -	props->max_pd =3D nesibdev->max_pd;
> -	props->max_sge_rd =3D 1;
> -	switch (nesdev->nesadapter->max_irrq_wr) {
> -		case 0:
> -			props->max_qp_rd_atom =3D 2;
> -			break;
> -		case 1:
> -			props->max_qp_rd_atom =3D 8;
> -			break;
> -		case 2:
> -			props->max_qp_rd_atom =3D 32;
> -			break;
> -		case 3:
> -			props->max_qp_rd_atom =3D 64;
> -			break;
> -		default:
> -			props->max_qp_rd_atom =3D 0;
> -	}
> -	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
> -	props->atomic_cap =3D IB_ATOMIC_NONE;
> -	props->max_map_per_fmr =3D 1;
> -
> -	return 0;
> -}
> -
> -
> -/**
>  * nes_query_port
>  */
> static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib=
_port_attr *props)
> @@ -3869,7 +3814,6 @@ struct nes_ib_device *nes_init_ofa_device(struc=
t net_device *netdev)
> 	nesibdev->ibdev.num_comp_vectors =3D 1;
> 	nesibdev->ibdev.dma_device =3D &nesdev->pcidev->dev;
> 	nesibdev->ibdev.dev.parent =3D &nesdev->pcidev->dev;
> -	nesibdev->ibdev.query_device =3D nes_query_device;
> 	nesibdev->ibdev.query_port =3D nes_query_port;
> 	nesibdev->ibdev.query_pkey =3D nes_query_pkey;
> 	nesibdev->ibdev.query_gid =3D nes_query_gid;
> @@ -3906,6 +3850,44 @@ struct nes_ib_device *nes_init_ofa_device(stru=
ct net_device *netdev)
> 	nesibdev->ibdev.post_send =3D nes_post_send;
> 	nesibdev->ibdev.post_recv =3D nes_post_recv;
>=20
> +	memcpy(&nesibdev->ibdev.sys_image_guid,
> +			nesvnic->netdev->dev_addr, 6);
> +
> +	nesibdev->ibdev.fw_ver =3D nesdev->nesadapter->firmware_version;
> +	nesibdev->ibdev.device_cap_flags =3D nesdev->nesadapter->device_cap=
_flags;
> +	nesibdev->ibdev.vendor_id =3D nesdev->nesadapter->vendor_id;
> +	nesibdev->ibdev.vendor_part_id =3D nesdev->nesadapter->vendor_part_=
id;
> +	nesibdev->ibdev.hw_ver =3D nesdev->nesadapter->hw_rev;
> +	nesibdev->ibdev.max_mr_size =3D 0x80000000;
> +	nesibdev->ibdev.max_qp =3D nesibdev->max_qp;
> +	nesibdev->ibdev.max_qp_wr =3D nesdev->nesadapter->max_qp_wr - 2;
> +	nesibdev->ibdev.max_sge =3D nesdev->nesadapter->max_sge;
> +	nesibdev->ibdev.max_cq =3D nesibdev->max_cq;
> +	nesibdev->ibdev.max_cqe =3D nesdev->nesadapter->max_cqe;
> +	nesibdev->ibdev.max_mr =3D nesibdev->max_mr;
> +	nesibdev->ibdev.max_mw =3D nesibdev->max_mr;
> +	nesibdev->ibdev.max_pd =3D nesibdev->max_pd;
> +	nesibdev->ibdev.max_sge_rd =3D 1;
> +	switch (nesdev->nesadapter->max_irrq_wr) {
> +		case 0:
> +			nesibdev->ibdev.max_qp_rd_atom =3D 2;
> +			break;
> +		case 1:
> +			nesibdev->ibdev.max_qp_rd_atom =3D 8;
> +			break;
> +		case 2:
> +			nesibdev->ibdev.max_qp_rd_atom =3D 32;
> +			break;
> +		case 3:
> +			nesibdev->ibdev.max_qp_rd_atom =3D 64;
> +			break;
> +		default:
> +			nesibdev->ibdev.max_qp_rd_atom =3D 0;
> +	}
> +	nesibdev->ibdev.max_qp_init_rd_atom =3D nesibdev->ibdev.max_qp_rd_a=
tom;
> +	nesibdev->ibdev.atomic_cap =3D IB_ATOMIC_NONE;
> +	nesibdev->ibdev.max_map_per_fmr =3D 1;
> +
> 	nesibdev->ibdev.iwcm =3D kzalloc(sizeof(*nesibdev->ibdev.iwcm), GFP_=
KERNEL);
> 	if (nesibdev->ibdev.iwcm =3D=3D NULL) {
> 		ib_dealloc_device(&nesibdev->ibdev);
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/inf=
iniband/hw/ocrdma/ocrdma_main.c
> index 9bf430e..00ddcf9 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -145,7 +145,6 @@ static int ocrdma_register_device(struct ocrdma_d=
ev *dev)
> 	dev->ibdev.num_comp_vectors =3D dev->eq_cnt;
>=20
> 	/* mandatory verbs. */
> -	dev->ibdev.query_device =3D ocrdma_query_device;
> 	dev->ibdev.query_port =3D ocrdma_query_port;
> 	dev->ibdev.modify_port =3D ocrdma_modify_port;
> 	dev->ibdev.query_gid =3D ocrdma_query_gid;
> @@ -207,6 +206,45 @@ static int ocrdma_register_device(struct ocrdma_=
dev *dev)
> 		dev->ibdev.destroy_srq =3D ocrdma_destroy_srq;
> 		dev->ibdev.post_srq_recv =3D ocrdma_post_srq_recv;
> 	}
> +
> +	memcpy(&dev->ibdev.fw_ver, &dev->attr.fw_ver[0],
> +	       min(sizeof(dev->attr.fw_ver), sizeof(dev->ibdev.fw_ver)));
> +	ocrdma_get_guid(dev, (u8 *)&dev->ibdev.sys_image_guid);
> +	dev->ibdev.max_mr_size =3D dev->attr.max_mr_size;
> +	dev->ibdev.page_size_cap =3D 0xffff000;
> +	dev->ibdev.vendor_id =3D dev->nic_info.pdev->vendor;
> +	dev->ibdev.vendor_part_id =3D dev->nic_info.pdev->device;
> +	dev->ibdev.hw_ver =3D dev->asic_id;
> +	dev->ibdev.max_qp =3D dev->attr.max_qp;
> +	dev->ibdev.max_ah =3D OCRDMA_MAX_AH;
> +	dev->ibdev.max_qp_wr =3D dev->attr.max_wqe;
> +
> +	dev->ibdev.device_cap_flags =3D IB_DEVICE_CURR_QP_STATE_MOD |
> +					IB_DEVICE_RC_RNR_NAK_GEN |
> +					IB_DEVICE_SHUTDOWN_PORT |
> +					IB_DEVICE_SYS_IMAGE_GUID |
> +					IB_DEVICE_LOCAL_DMA_LKEY |
> +					IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	dev->ibdev.max_sge =3D min(dev->attr.max_send_sge, dev->attr.max_sr=
q_sge);
> +	dev->ibdev.max_sge_rd =3D 0;
> +	dev->ibdev.max_cq =3D dev->attr.max_cq;
> +	dev->ibdev.max_cqe =3D dev->attr.max_cqe;
> +	dev->ibdev.max_mr =3D dev->attr.max_mr;
> +	dev->ibdev.max_mw =3D dev->attr.max_mw;
> +	dev->ibdev.max_pd =3D dev->attr.max_pd;
> +	dev->ibdev.atomic_cap =3D 0;
> +	dev->ibdev.max_fmr =3D 0;
> +	dev->ibdev.max_map_per_fmr =3D 0;
> +	dev->ibdev.max_qp_rd_atom =3D
> +	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
> +	dev->ibdev.max_qp_init_rd_atom =3D dev->attr.max_ord_per_qp;
> +	dev->ibdev.max_srq =3D dev->attr.max_srq;
> +	dev->ibdev.max_srq_sge =3D dev->attr.max_srq_sge;
> +	dev->ibdev.max_srq_wr =3D dev->attr.max_rqe;
> +	dev->ibdev.local_ca_ack_delay =3D dev->attr.local_ca_ack_delay;
> +	dev->ibdev.max_fast_reg_page_list_len =3D dev->attr.max_pages_per_f=
rmr;
> +	dev->ibdev.max_pkeys =3D 1;
> +
> 	return ib_register_device(&dev->ibdev, NULL);
> }
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/in=
finiband/hw/ocrdma/ocrdma_verbs.c
> index 2deaa2a..45b151c 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -98,55 +98,6 @@ int  ocrdma_del_gid(struct ib_device *device,
> 	return 0;
> }
>=20
> -int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_at=
tr *attr,
> -			struct ib_udata *uhw)
> -{
> -	struct ocrdma_dev *dev =3D get_ocrdma_dev(ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	memset(attr, 0, sizeof *attr);
> -	memcpy(&attr->fw_ver, &dev->attr.fw_ver[0],
> -	       min(sizeof(dev->attr.fw_ver), sizeof(attr->fw_ver)));
> -	ocrdma_get_guid(dev, (u8 *)&attr->sys_image_guid);
> -	attr->max_mr_size =3D dev->attr.max_mr_size;
> -	attr->page_size_cap =3D 0xffff000;
> -	attr->vendor_id =3D dev->nic_info.pdev->vendor;
> -	attr->vendor_part_id =3D dev->nic_info.pdev->device;
> -	attr->hw_ver =3D dev->asic_id;
> -	attr->max_qp =3D dev->attr.max_qp;
> -	attr->max_ah =3D OCRDMA_MAX_AH;
> -	attr->max_qp_wr =3D dev->attr.max_wqe;
> -
> -	attr->device_cap_flags =3D IB_DEVICE_CURR_QP_STATE_MOD |
> -					IB_DEVICE_RC_RNR_NAK_GEN |
> -					IB_DEVICE_SHUTDOWN_PORT |
> -					IB_DEVICE_SYS_IMAGE_GUID |
> -					IB_DEVICE_LOCAL_DMA_LKEY |
> -					IB_DEVICE_MEM_MGT_EXTENSIONS;
> -	attr->max_sge =3D min(dev->attr.max_send_sge, dev->attr.max_srq_sge=
);
> -	attr->max_sge_rd =3D 0;
> -	attr->max_cq =3D dev->attr.max_cq;
> -	attr->max_cqe =3D dev->attr.max_cqe;
> -	attr->max_mr =3D dev->attr.max_mr;
> -	attr->max_mw =3D dev->attr.max_mw;
> -	attr->max_pd =3D dev->attr.max_pd;
> -	attr->atomic_cap =3D 0;
> -	attr->max_fmr =3D 0;
> -	attr->max_map_per_fmr =3D 0;
> -	attr->max_qp_rd_atom =3D
> -	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
> -	attr->max_qp_init_rd_atom =3D dev->attr.max_ord_per_qp;
> -	attr->max_srq =3D dev->attr.max_srq;
> -	attr->max_srq_sge =3D dev->attr.max_srq_sge;
> -	attr->max_srq_wr =3D dev->attr.max_rqe;
> -	attr->local_ca_ack_delay =3D dev->attr.local_ca_ack_delay;
> -	attr->max_fast_reg_page_list_len =3D dev->attr.max_pages_per_frmr;
> -	attr->max_pkeys =3D 1;
> -	return 0;
> -}
> -
> struct net_device *ocrdma_get_netdev(struct ib_device *ibdev, u8 port=
_num)
> {
> 	struct ocrdma_dev *dev;
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/in=
finiband/hw/ocrdma/ocrdma_verbs.h
> index 62d6608..64a8258 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> @@ -51,8 +51,6 @@ int ocrdma_post_recv(struct ib_qp *, struct ib_recv=
_wr *,
> int ocrdma_poll_cq(struct ib_cq *, int num_entries, struct ib_wc *wc)=
;
> int ocrdma_arm_cq(struct ib_cq *, enum ib_cq_notify_flags flags);
>=20
> -int ocrdma_query_device(struct ib_device *, struct ib_device_attr *p=
rops,
> -			struct ib_udata *uhw);
> int ocrdma_query_port(struct ib_device *, u8 port, struct ib_port_att=
r *props);
> int ocrdma_modify_port(struct ib_device *, u8 port, int mask,
> 		       struct ib_port_modify *props);
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniba=
nd/hw/qib/qib_verbs.c
> index de6cb6f..9e1af0b 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -1567,55 +1567,6 @@ full:
> 	}
> }
>=20
> -static int qib_query_device(struct ib_device *ibdev, struct ib_devic=
e_attr *props,
> -			    struct ib_udata *uhw)
> -{
> -	struct qib_devdata *dd =3D dd_from_ibdev(ibdev);
> -	struct qib_ibdev *dev =3D to_idev(ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -	memset(props, 0, sizeof(*props));
> -
> -	props->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> -		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> -		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> -		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> -	props->page_size_cap =3D PAGE_SIZE;
> -	props->vendor_id =3D
> -		QIB_SRC_OUI_1 << 16 | QIB_SRC_OUI_2 << 8 | QIB_SRC_OUI_3;
> -	props->vendor_part_id =3D dd->deviceid;
> -	props->hw_ver =3D dd->minrev;
> -	props->sys_image_guid =3D ib_qib_sys_image_guid;
> -	props->max_mr_size =3D ~0ULL;
> -	props->max_qp =3D ib_qib_max_qps;
> -	props->max_qp_wr =3D ib_qib_max_qp_wrs;
> -	props->max_sge =3D ib_qib_max_sges;
> -	props->max_sge_rd =3D ib_qib_max_sges;
> -	props->max_cq =3D ib_qib_max_cqs;
> -	props->max_ah =3D ib_qib_max_ahs;
> -	props->max_cqe =3D ib_qib_max_cqes;
> -	props->max_mr =3D dev->lk_table.max;
> -	props->max_fmr =3D dev->lk_table.max;
> -	props->max_map_per_fmr =3D 32767;
> -	props->max_pd =3D ib_qib_max_pds;
> -	props->max_qp_rd_atom =3D QIB_MAX_RDMA_ATOMIC;
> -	props->max_qp_init_rd_atom =3D 255;
> -	/* props->max_res_rd_atom */
> -	props->max_srq =3D ib_qib_max_srqs;
> -	props->max_srq_wr =3D ib_qib_max_srq_wrs;
> -	props->max_srq_sge =3D ib_qib_max_srq_sges;
> -	/* props->local_ca_ack_delay */
> -	props->atomic_cap =3D IB_ATOMIC_GLOB;
> -	props->max_pkeys =3D qib_get_npkeys(dd);
> -	props->max_mcast_grp =3D ib_qib_max_mcast_grps;
> -	props->max_mcast_qp_attach =3D ib_qib_max_mcast_qp_attached;
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -		props->max_mcast_grp;
> -
> -	return 0;
> -}
> -
> static int qib_query_port(struct ib_device *ibdev, u8 port,
> 			  struct ib_port_attr *props)
> {
> @@ -2225,7 +2176,6 @@ int qib_register_ib_device(struct qib_devdata *=
dd)
> 	ibdev->phys_port_cnt =3D dd->num_pports;
> 	ibdev->num_comp_vectors =3D 1;
> 	ibdev->dma_device =3D &dd->pcidev->dev;
> -	ibdev->query_device =3D qib_query_device;
> 	ibdev->modify_device =3D qib_modify_device;
> 	ibdev->query_port =3D qib_query_port;
> 	ibdev->modify_port =3D qib_modify_port;
> @@ -2272,6 +2222,42 @@ int qib_register_ib_device(struct qib_devdata =
*dd)
> 	ibdev->dma_ops =3D &qib_dma_mapping_ops;
> 	ibdev->get_port_immutable =3D qib_port_immutable;
>=20
> +	ibdev->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> +		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> +		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> +		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> +	ibdev->page_size_cap =3D PAGE_SIZE;
> +	ibdev->vendor_id =3D
> +		QIB_SRC_OUI_1 << 16 | QIB_SRC_OUI_2 << 8 | QIB_SRC_OUI_3;
> +	ibdev->vendor_part_id =3D dd->deviceid;
> +	ibdev->hw_ver =3D dd->minrev;
> +	ibdev->sys_image_guid =3D ib_qib_sys_image_guid;
> +	ibdev->max_mr_size =3D ~0ULL;
> +	ibdev->max_qp =3D ib_qib_max_qps;
> +	ibdev->max_qp_wr =3D ib_qib_max_qp_wrs;
> +	ibdev->max_sge =3D ib_qib_max_sges;
> +	ibdev->max_sge_rd =3D ib_qib_max_sges;
> +	ibdev->max_cq =3D ib_qib_max_cqs;
> +	ibdev->max_ah =3D ib_qib_max_ahs;
> +	ibdev->max_cqe =3D ib_qib_max_cqes;
> +	ibdev->max_mr =3D dev->lk_table.max;
> +	ibdev->max_fmr =3D dev->lk_table.max;
> +	ibdev->max_map_per_fmr =3D 32767;
> +	ibdev->max_pd =3D ib_qib_max_pds;
> +	ibdev->max_qp_rd_atom =3D QIB_MAX_RDMA_ATOMIC;
> +	ibdev->max_qp_init_rd_atom =3D 255;
> +	/* props->max_res_rd_atom */
> +	ibdev->max_srq =3D ib_qib_max_srqs;
> +	ibdev->max_srq_wr =3D ib_qib_max_srq_wrs;
> +	ibdev->max_srq_sge =3D ib_qib_max_srq_sges;
> +	/* props->local_ca_ack_delay */
> +	ibdev->atomic_cap =3D IB_ATOMIC_GLOB;
> +	ibdev->max_pkeys =3D qib_get_npkeys(dd);
> +	ibdev->max_mcast_grp =3D ib_qib_max_mcast_grps;
> +	ibdev->max_mcast_qp_attach =3D ib_qib_max_mcast_qp_attached;
> +	ibdev->max_total_mcast_qp_attach =3D ibdev->max_mcast_qp_attach *
> +		ibdev->max_mcast_grp;
> +
> 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
> 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/in=
finiband/hw/usnic/usnic_ib_main.c
> index 34c49b8..459bd34 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -374,7 +374,6 @@ static void *usnic_ib_device_add(struct pci_dev *=
dev)
> 		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST) |
> 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
>=20
> -	us_ibdev->ib_dev.query_device =3D usnic_ib_query_device;
> 	us_ibdev->ib_dev.query_port =3D usnic_ib_query_port;
> 	us_ibdev->ib_dev.query_pkey =3D usnic_ib_query_pkey;
> 	us_ibdev->ib_dev.query_gid =3D usnic_ib_query_gid;
> @@ -401,6 +400,8 @@ static void *usnic_ib_device_add(struct pci_dev *=
dev)
> 	us_ibdev->ib_dev.get_dma_mr =3D usnic_ib_get_dma_mr;
> 	us_ibdev->ib_dev.get_port_immutable =3D usnic_port_immutable;
>=20
> +	if (usnic_ib_init_device_flags(&us_ibdev->ib_dev))
> +		goto err_fwd_dealloc;
>=20
> 	if (ib_register_device(&us_ibdev->ib_dev, NULL))
> 		goto err_fwd_dealloc;
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/i=
nfiniband/hw/usnic/usnic_ib_verbs.c
> index 7df4382..c343ff9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -247,9 +247,7 @@ enum rdma_link_layer usnic_ib_port_link_layer(str=
uct ib_device *device,
> 	return IB_LINK_LAYER_ETHERNET;
> }
>=20
> -int usnic_ib_query_device(struct ib_device *ibdev,
> -			  struct ib_device_attr *props,
> -			  struct ib_udata *uhw)
> +int usnic_ib_init_device_flags(struct ib_device *ibdev)
> {
> 	struct usnic_ib_dev *us_ibdev =3D to_usdev(ibdev);
> 	union ib_gid gid;
> @@ -257,49 +255,31 @@ int usnic_ib_query_device(struct ib_device *ibd=
ev,
> 	struct ethtool_cmd cmd;
> 	int qp_per_vf;
>=20
> -	usnic_dbg("\n");
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> 	mutex_lock(&us_ibdev->usdev_lock);
> 	us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
> 	us_ibdev->netdev->ethtool_ops->get_settings(us_ibdev->netdev, &cmd);
> -	memset(props, 0, sizeof(*props));
> 	usnic_mac_ip_to_gid(us_ibdev->ufdev->mac, us_ibdev->ufdev->inaddr,
> 			&gid.raw[0]);
> -	memcpy(&props->sys_image_guid, &gid.global.interface_id,
> +	memcpy(&ibdev->sys_image_guid, &gid.global.interface_id,
> 		sizeof(gid.global.interface_id));
> -	usnic_ib_fw_string_to_u64(&info.fw_version[0], &props->fw_ver);
> -	props->max_mr_size =3D USNIC_UIOM_MAX_MR_SIZE;
> -	props->page_size_cap =3D USNIC_UIOM_PAGE_SIZE;
> -	props->vendor_id =3D PCI_VENDOR_ID_CISCO;
> -	props->vendor_part_id =3D PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC;
> -	props->hw_ver =3D us_ibdev->pdev->subsystem_device;
> +	usnic_ib_fw_string_to_u64(&info.fw_version[0], &ibdev->fw_ver);
> +	ibdev->max_mr_size =3D USNIC_UIOM_MAX_MR_SIZE;
> +	ibdev->page_size_cap =3D USNIC_UIOM_PAGE_SIZE;
> +	ibdev->vendor_id =3D PCI_VENDOR_ID_CISCO;
> +	ibdev->vendor_part_id =3D PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC;
> +	ibdev->hw_ver =3D us_ibdev->pdev->subsystem_device;
> 	qp_per_vf =3D max(us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_WQ],
> 			us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_RQ]);
> -	props->max_qp =3D qp_per_vf *
> +	ibdev->max_qp =3D qp_per_vf *
> 		atomic_read(&us_ibdev->vf_cnt.refcount);
> -	props->device_cap_flags =3D IB_DEVICE_PORT_ACTIVE_EVENT |
> +	ibdev->device_cap_flags =3D IB_DEVICE_PORT_ACTIVE_EVENT |
> 		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> -	props->max_cq =3D us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ] *
> +	ibdev->max_cq =3D us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ] *
> 		atomic_read(&us_ibdev->vf_cnt.refcount);
> -	props->max_pd =3D USNIC_UIOM_MAX_PD_CNT;
> -	props->max_mr =3D USNIC_UIOM_MAX_MR_CNT;
> -	props->local_ca_ack_delay =3D 0;
> -	props->max_pkeys =3D 0;
> -	props->atomic_cap =3D IB_ATOMIC_NONE;
> -	props->masked_atomic_cap =3D props->atomic_cap;
> -	props->max_qp_rd_atom =3D 0;
> -	props->max_qp_init_rd_atom =3D 0;
> -	props->max_res_rd_atom =3D 0;
> -	props->max_srq =3D 0;
> -	props->max_srq_wr =3D 0;
> -	props->max_srq_sge =3D 0;
> -	props->max_fast_reg_page_list_len =3D 0;
> -	props->max_mcast_grp =3D 0;
> -	props->max_mcast_qp_attach =3D 0;
> -	props->max_total_mcast_qp_attach =3D 0;
> -	props->max_map_per_fmr =3D 0;
> +	ibdev->max_pd =3D USNIC_UIOM_MAX_PD_CNT;
> +	ibdev->max_mr =3D USNIC_UIOM_MAX_MR_CNT;
> +	ibdev->atomic_cap =3D IB_ATOMIC_NONE;
> +	ibdev->masked_atomic_cap =3D ibdev->atomic_cap;
> 	/* Owned by Userspace
> 	 * max_qp_wr, max_sge, max_sge_rd, max_cqe */
> 	mutex_unlock(&us_ibdev->usdev_lock);
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/i=
nfiniband/hw/usnic/usnic_ib_verbs.h
> index 0bd04ef..5737688 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -23,9 +23,7 @@
>=20
> enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *devic=
e,
> 						u8 port_num);
> -int usnic_ib_query_device(struct ib_device *ibdev,
> -				struct ib_device_attr *props,
> -			  struct ib_udata *uhw);
> +int usnic_ib_init_device_flags(struct ib_device *ibdev);
> int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
> 				struct ib_port_attr *props);
> enum rdma_protocol_type
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infini=
band/ulp/ipoib/ipoib_cm.c
> index 3ae9726..737d273 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -1522,8 +1522,7 @@ static void ipoib_cm_create_srq(struct net_devi=
ce *dev, int max_sge)
> int ipoib_cm_dev_init(struct net_device *dev)
> {
> 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> -	int i, ret;
> -	struct ib_device_attr attr;
> +	int max_srq_sge, i;
>=20
> 	INIT_LIST_HEAD(&priv->cm.passive_ids);
> 	INIT_LIST_HEAD(&priv->cm.reap_list);
> @@ -1540,19 +1539,13 @@ int ipoib_cm_dev_init(struct net_device *dev)
>=20
> 	skb_queue_head_init(&priv->cm.skb_queue);
>=20
> -	ret =3D ib_query_device(priv->ca, &attr);
> -	if (ret) {
> -		printk(KERN_WARNING "ib_query_device() failed with %d\n", ret);
> -		return ret;
> -	}
> -
> -	ipoib_dbg(priv, "max_srq_sge=3D%d\n", attr.max_srq_sge);
> +	ipoib_dbg(priv, "max_srq_sge=3D%d\n", priv->ca->max_srq_sge);
>=20
> -	attr.max_srq_sge =3D min_t(int, IPOIB_CM_RX_SG, attr.max_srq_sge);
> -	ipoib_cm_create_srq(dev, attr.max_srq_sge);
> +	max_srq_sge =3D min_t(int, IPOIB_CM_RX_SG, priv->ca->max_srq_sge);
> +	ipoib_cm_create_srq(dev, max_srq_sge);
> 	if (ipoib_cm_has_srq(dev)) {
> -		priv->cm.max_cm_mtu =3D attr.max_srq_sge * PAGE_SIZE - 0x10;
> -		priv->cm.num_frags  =3D attr.max_srq_sge;
> +		priv->cm.max_cm_mtu =3D max_srq_sge * PAGE_SIZE - 0x10;
> +		priv->cm.num_frags  =3D max_srq_sge;
> 		ipoib_dbg(priv, "max_cm_mtu =3D 0x%x, num_frags=3D%d\n",
> 			  priv->cm.max_cm_mtu, priv->cm.num_frags);
> 	} else {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_ethtool.c
> index 078cadd..3db380d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> @@ -40,15 +40,11 @@ static void ipoib_get_drvinfo(struct net_device *=
netdev,
> 			      struct ethtool_drvinfo *drvinfo)
> {
> 	struct ipoib_dev_priv *priv =3D netdev_priv(netdev);
> -	struct ib_device_attr *attr;
> -
> -	attr =3D kmalloc(sizeof(*attr), GFP_KERNEL);
> -	if (attr && !ib_query_device(priv->ca, attr))
> -		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
> -			 "%d.%d.%d", (int)(attr->fw_ver >> 32),
> -			 (int)(attr->fw_ver >> 16) & 0xffff,
> -			 (int)attr->fw_ver & 0xffff);
> -	kfree(attr);
> +
> +	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
> +		 "%d.%d.%d", (int)(priv->ca->fw_ver >> 32),
> +		 (int)(priv->ca->fw_ver >> 16) & 0xffff,
> +		 (int)priv->ca->fw_ver & 0xffff);
>=20
> 	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dma_device),
> 		sizeof(drvinfo->bus_info));
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infi=
niband/ulp/ipoib/ipoib_main.c
> index 2cbf687..7675de1 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1757,26 +1757,7 @@ int ipoib_add_pkey_attr(struct net_device *dev=
)
>=20
> int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_dev=
ice *hca)
> {
> -	struct ib_device_attr *device_attr;
> -	int result =3D -ENOMEM;
> -
> -	device_attr =3D kmalloc(sizeof *device_attr, GFP_KERNEL);
> -	if (!device_attr) {
> -		printk(KERN_WARNING "%s: allocation of %zu bytes failed\n",
> -		       hca->name, sizeof *device_attr);
> -		return result;
> -	}
> -
> -	result =3D ib_query_device(hca, device_attr);
> -	if (result) {
> -		printk(KERN_WARNING "%s: ib_query_device failed (ret =3D %d)\n",
> -		       hca->name, result);
> -		kfree(device_attr);
> -		return result;
> -	}
> -	priv->hca_caps =3D device_attr->device_cap_flags;
> -
> -	kfree(device_attr);
> +	priv->hca_caps =3D hca->device_cap_flags;
>=20
> 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
> 		priv->dev->hw_features =3D NETIF_F_SG |
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infin=
iband/ulp/iser/iscsi_iser.c
> index 5647fa5..0e82598 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -648,7 +648,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *=
ep,
>=20
> 		ib_conn =3D &iser_conn->ib_conn;
> 		if (ib_conn->pi_support) {
> -			u32 sig_caps =3D ib_conn->device->dev_attr.sig_prot_cap;
> +			u32 sig_caps =3D ib_conn->device->ib_device->sig_prot_cap;
>=20
> 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
> 			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
> @@ -660,7 +660,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *=
ep,
> 		 * max fastreg page list length.
> 		 */
> 		shost->sg_tablesize =3D min_t(unsigned short, shost->sg_tablesize,
> -			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> +			ib_conn->device->ib_device->max_fast_reg_page_list_len);
> 		shost->max_sectors =3D min_t(unsigned int,
> 			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
>=20
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infin=
iband/ulp/iser/iscsi_iser.h
> index 271aa71..72c6ed9 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
> @@ -380,7 +380,6 @@ struct iser_reg_ops {
>  *
>  * @ib_device:     RDMA device
>  * @pd:            Protection Domain for this device
> - * @dev_attr:      Device attributes container
>  * @mr:            Global DMA memory region
>  * @event_handler: IB events handle routine
>  * @ig_list:	   entry in devices list
> @@ -393,7 +392,6 @@ struct iser_reg_ops {
> struct iser_device {
> 	struct ib_device             *ib_device;
> 	struct ib_pd	             *pd;
> -	struct ib_device_attr	     dev_attr;
> 	struct ib_mr	             *mr;
> 	struct ib_event_handler      event_handler;
> 	struct list_head             ig_list;
> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infi=
niband/ulp/iser/iser_memory.c
> index d78eafb..53b1db9 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -69,15 +69,14 @@ static struct iser_reg_ops fmr_ops =3D {
>=20
> int iser_assign_reg_ops(struct iser_device *device)
> {
> -	struct ib_device_attr *dev_attr =3D &device->dev_attr;
> +	struct ib_device *ib_dev =3D device->ib_device;
>=20
> 	/* Assign function handles  - based on FMR support */
> -	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr =
&&
> -	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr=
) {
> +	if (ib_dev->alloc_fmr && ib_dev->dealloc_fmr &&
> +	    ib_dev->map_phys_fmr && ib_dev->unmap_fmr) {
> 		iser_info("FMR supported, using FMR for registration\n");
> 		device->reg_ops =3D &fmr_ops;
> -	} else
> -	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
> +	} else if (ib_dev->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS)=
 {
> 		iser_info("FastReg supported, using FastReg for registration\n");
> 		device->reg_ops =3D &fastreg_ops;
> 	} else {
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infin=
iband/ulp/iser/iser_verbs.c
> index a66b9de..aff0df9 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -78,34 +78,28 @@ static void iser_event_handler(struct ib_event_ha=
ndler *handler,
>  */
> static int iser_create_device_ib_res(struct iser_device *device)
> {
> -	struct ib_device_attr *dev_attr =3D &device->dev_attr;
> +	struct ib_device *ib_dev =3D device->ib_device;
> 	int ret, i, max_cqe;
>=20
> -	ret =3D ib_query_device(device->ib_device, dev_attr);
> -	if (ret) {
> -		pr_warn("Query device failed for %s\n", device->ib_device->name);
> -		return ret;
> -	}
> -
> 	ret =3D iser_assign_reg_ops(device);
> 	if (ret)
> 		return ret;
>=20
> 	device->comps_used =3D min_t(int, num_online_cpus(),
> -				 device->ib_device->num_comp_vectors);
> +				 ib_dev->num_comp_vectors);
>=20
> 	device->comps =3D kcalloc(device->comps_used, sizeof(*device->comps)=
,
> 				GFP_KERNEL);
> 	if (!device->comps)
> 		goto comps_err;
>=20
> -	max_cqe =3D min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
> +	max_cqe =3D min(ISER_MAX_CQ_LEN, ib_dev->max_cqe);
>=20
> 	iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n"=
,
> -		  device->comps_used, device->ib_device->name,
> -		  device->ib_device->num_comp_vectors, max_cqe);
> +		  device->comps_used, ib_dev->name,
> +		  ib_dev->num_comp_vectors, max_cqe);
>=20
> -	device->pd =3D ib_alloc_pd(device->ib_device);
> +	device->pd =3D ib_alloc_pd(ib_dev);
> 	if (IS_ERR(device->pd))
> 		goto pd_err;
>=20
> @@ -116,7 +110,7 @@ static int iser_create_device_ib_res(struct iser_=
device *device)
> 		comp->device =3D device;
> 		cq_attr.cqe =3D max_cqe;
> 		cq_attr.comp_vector =3D i;
> -		comp->cq =3D ib_create_cq(device->ib_device,
> +		comp->cq =3D ib_create_cq(ib_dev,
> 					iser_cq_callback,
> 					iser_cq_event_callback,
> 					(void *)comp,
> @@ -464,7 +458,7 @@ static int iser_create_ib_conn_res(struct ib_conn=
 *ib_conn)
> 	struct iser_conn *iser_conn =3D container_of(ib_conn, struct iser_co=
nn,
> 						   ib_conn);
> 	struct iser_device	*device;
> -	struct ib_device_attr *dev_attr;
> +	struct ib_device	*ib_dev;
> 	struct ib_qp_init_attr	init_attr;
> 	int			ret =3D -ENOMEM;
> 	int index, min_index =3D 0;
> @@ -472,7 +466,7 @@ static int iser_create_ib_conn_res(struct ib_conn=
 *ib_conn)
> 	BUG_ON(ib_conn->device =3D=3D NULL);
>=20
> 	device =3D ib_conn->device;
> -	dev_attr =3D &device->dev_attr;
> +	ib_dev =3D device->ib_device;
>=20
> 	memset(&init_attr, 0, sizeof init_attr);
>=20
> @@ -503,16 +497,16 @@ static int iser_create_ib_conn_res(struct ib_co=
nn *ib_conn)
> 		iser_conn->max_cmds =3D
> 			ISER_GET_MAX_XMIT_CMDS(ISER_QP_SIG_MAX_REQ_DTOS);
> 	} else {
> -		if (dev_attr->max_qp_wr > ISER_QP_MAX_REQ_DTOS) {
> +		if (ib_dev->max_qp_wr > ISER_QP_MAX_REQ_DTOS) {
> 			init_attr.cap.max_send_wr  =3D ISER_QP_MAX_REQ_DTOS + 1;
> 			iser_conn->max_cmds =3D
> 				ISER_GET_MAX_XMIT_CMDS(ISER_QP_MAX_REQ_DTOS);
> 		} else {
> -			init_attr.cap.max_send_wr =3D dev_attr->max_qp_wr;
> +			init_attr.cap.max_send_wr =3D ib_dev->max_qp_wr;
> 			iser_conn->max_cmds =3D
> -				ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr);
> +				ISER_GET_MAX_XMIT_CMDS(ib_dev->max_qp_wr);
> 			iser_dbg("device %s supports max_send_wr %d\n",
> -				 device->ib_device->name, dev_attr->max_qp_wr);
> +				 device->ib_device->name, ib_dev->max_qp_wr);
> 		}
> 	}
>=20
> @@ -756,7 +750,7 @@ iser_calc_scsi_params(struct iser_conn *iser_conn=
,
>=20
> 	sg_tablesize =3D DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
> 	sup_sg_tablesize =3D min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
> -				 device->dev_attr.max_fast_reg_page_list_len);
> +				 device->ib_device->max_fast_reg_page_list_len);
>=20
> 	if (sg_tablesize > sup_sg_tablesize) {
> 		sg_tablesize =3D sup_sg_tablesize;
> @@ -799,7 +793,7 @@ static void iser_addr_handler(struct rdma_cm_id *=
cma_id)
>=20
> 	/* connection T10-PI support */
> 	if (iser_pi_enable) {
> -		if (!(device->dev_attr.device_cap_flags &
> +		if (!(device->ib_device->device_cap_flags &
> 		      IB_DEVICE_SIGNATURE_HANDOVER)) {
> 			iser_warn("T10-PI requested but not supported on %s, "
> 				  "continue without T10-PI\n",
> @@ -841,7 +835,7 @@ static void iser_route_handler(struct rdma_cm_id =
*cma_id)
> 		goto failure;
>=20
> 	memset(&conn_param, 0, sizeof conn_param);
> -	conn_param.responder_resources =3D device->dev_attr.max_qp_rd_atom;
> +	conn_param.responder_resources =3D device->ib_device->max_qp_rd_ato=
m;
> 	conn_param.initiator_depth     =3D 1;
> 	conn_param.retry_count	       =3D 7;
> 	conn_param.rnr_retry_count     =3D 6;
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infini=
band/ulp/isert/ib_isert.c
> index c96717a..2bceb9a 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -95,22 +95,6 @@ isert_qp_event_callback(struct ib_event *e, void *=
context)
> 	}
> }
>=20
> -static int
> -isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *=
devattr)
> -{
> -	int ret;
> -
> -	ret =3D ib_query_device(ib_dev, devattr);
> -	if (ret) {
> -		isert_err("ib_query_device() failed: %d\n", ret);
> -		return ret;
> -	}
> -	isert_dbg("devattr->max_sge: %d\n", devattr->max_sge);
> -	isert_dbg("devattr->max_sge_rd: %d\n", devattr->max_sge_rd);
> -
> -	return 0;
> -}
> -
> static struct isert_comp *
> isert_comp_get(struct isert_conn *isert_conn)
> {
> @@ -164,7 +148,7 @@ isert_create_qp(struct isert_conn *isert_conn,
> 	 * Also, still make sure to have at least two SGEs for
> 	 * outgoing control PDU responses.
> 	 */
> -	attr.cap.max_send_sge =3D max(2, device->dev_attr.max_sge - 2);
> +	attr.cap.max_send_sge =3D max(2, device->ib_device->max_sge - 2);
> 	isert_conn->max_sge =3D attr.cap.max_send_sge;
>=20
> 	attr.cap.max_recv_sge =3D 1;
> @@ -296,8 +280,7 @@ isert_free_comps(struct isert_device *device)
> }
>=20
> static int
> -isert_alloc_comps(struct isert_device *device,
> -		  struct ib_device_attr *attr)
> +isert_alloc_comps(struct isert_device *device)
> {
> 	int i, max_cqe, ret =3D 0;
>=20
> @@ -317,7 +300,7 @@ isert_alloc_comps(struct isert_device *device,
> 		return -ENOMEM;
> 	}
>=20
> -	max_cqe =3D min(ISER_MAX_CQ_LEN, attr->max_cqe);
> +	max_cqe =3D min(ISER_MAX_CQ_LEN, device->ib_device->max_cqe);
>=20
> 	for (i =3D 0; i < device->comps_used; i++) {
> 		struct ib_cq_init_attr cq_attr =3D {};
> @@ -353,17 +336,15 @@ out_cq:
> static int
> isert_create_device_ib_res(struct isert_device *device)
> {
> -	struct ib_device_attr *dev_attr;
> +	struct ib_device *ib_dev =3D device->ib_device;
> 	int ret;
>=20
> -	dev_attr =3D &device->dev_attr;
> -	ret =3D isert_query_device(device->ib_device, dev_attr);
> -	if (ret)
> -		return ret;
> +	isert_dbg("devattr->max_sge: %d\n", ib_dev->max_sge);
> +	isert_dbg("devattr->max_sge_rd: %d\n", ib_dev->max_sge_rd);
>=20
> 	/* asign function handlers */
> -	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
> -	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
> +	if (ib_dev->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
> +	    ib_dev->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
> 		device->use_fastreg =3D 1;
> 		device->reg_rdma_mem =3D isert_reg_rdma;
> 		device->unreg_rdma_mem =3D isert_unreg_rdma;
> @@ -373,11 +354,11 @@ isert_create_device_ib_res(struct isert_device =
*device)
> 		device->unreg_rdma_mem =3D isert_unmap_cmd;
> 	}
>=20
> -	ret =3D isert_alloc_comps(device, dev_attr);
> +	ret =3D isert_alloc_comps(device);
> 	if (ret)
> 		return ret;
>=20
> -	device->pd =3D ib_alloc_pd(device->ib_device);
> +	device->pd =3D ib_alloc_pd(ib_dev);
> 	if (IS_ERR(device->pd)) {
> 		ret =3D PTR_ERR(device->pd);
> 		isert_err("failed to allocate pd, device %p, ret=3D%d\n",
> @@ -386,7 +367,7 @@ isert_create_device_ib_res(struct isert_device *d=
evice)
> 	}
>=20
> 	/* Check signature cap */
> -	device->pi_capable =3D dev_attr->device_cap_flags &
> +	device->pi_capable =3D ib_dev->device_cap_flags &
> 			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
>=20
> 	return 0;
> @@ -723,7 +704,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, =
struct rdma_cm_event *event)
> 	/* Set max inflight RDMA READ requests */
> 	isert_conn->initiator_depth =3D min_t(u8,
> 				event->param.conn.initiator_depth,
> -				device->dev_attr.max_qp_init_rd_atom);
> +				device->ib_device->max_qp_init_rd_atom);
> 	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth=
);
>=20
> 	ret =3D isert_conn_setup_qp(isert_conn, cma_id);
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infini=
band/ulp/isert/ib_isert.h
> index e87f9b0..17ff8b0 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.h
> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
> @@ -210,7 +210,6 @@ struct isert_device {
> 	struct isert_comp	*comps;
> 	int                     comps_used;
> 	struct list_head	dev_node;
> -	struct ib_device_attr	dev_attr;
> 	int			(*reg_rdma_mem)(struct iscsi_conn *conn,
> 						    struct iscsi_cmd *cmd,
> 						    struct isert_rdma_wr *wr);
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index 35cddbb..bc07477 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3440,27 +3440,17 @@ free_host:
> static void srp_add_one(struct ib_device *device)
> {
> 	struct srp_device *srp_dev;
> -	struct ib_device_attr *dev_attr;
> 	struct srp_host *host;
> 	int mr_page_shift, p;
> 	u64 max_pages_per_mr;
>=20
> -	dev_attr =3D kmalloc(sizeof *dev_attr, GFP_KERNEL);
> -	if (!dev_attr)
> -		return;
> -
> -	if (ib_query_device(device, dev_attr)) {
> -		pr_warn("Query device failed for %s\n", device->name);
> -		goto free_attr;
> -	}
> -
> 	srp_dev =3D kmalloc(sizeof *srp_dev, GFP_KERNEL);
> 	if (!srp_dev)
> -		goto free_attr;
> +		return;
>=20
> 	srp_dev->has_fmr =3D (device->alloc_fmr && device->dealloc_fmr &&
> 			    device->map_phys_fmr && device->unmap_fmr);
> -	srp_dev->has_fr =3D (dev_attr->device_cap_flags &
> +	srp_dev->has_fr =3D (device->device_cap_flags &
> 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
> 	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
> 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
> @@ -3475,23 +3465,23 @@ static void srp_add_one(struct ib_device *dev=
ice)
> 	 * minimum of 4096 bytes. We're unlikely to build large sglists
> 	 * out of smaller entries.
> 	 */
> -	mr_page_shift		=3D max(12, ffs(dev_attr->page_size_cap) - 1);
> +	mr_page_shift		=3D max(12, ffs(device->page_size_cap) - 1);
> 	srp_dev->mr_page_size	=3D 1 << mr_page_shift;
> 	srp_dev->mr_page_mask	=3D ~((u64) srp_dev->mr_page_size - 1);
> -	max_pages_per_mr	=3D dev_attr->max_mr_size;
> +	max_pages_per_mr	=3D device->max_mr_size;
> 	do_div(max_pages_per_mr, srp_dev->mr_page_size);
> 	srp_dev->max_pages_per_mr =3D min_t(u64, SRP_MAX_PAGES_PER_MR,
> 					  max_pages_per_mr);
> 	if (srp_dev->use_fast_reg) {
> 		srp_dev->max_pages_per_mr =3D
> 			min_t(u32, srp_dev->max_pages_per_mr,
> -			      dev_attr->max_fast_reg_page_list_len);
> +			      device->max_fast_reg_page_list_len);
> 	}
> 	srp_dev->mr_max_size	=3D srp_dev->mr_page_size *
> 				   srp_dev->max_pages_per_mr;
> -	pr_debug("%s: mr_page_shift =3D %d, dev_attr->max_mr_size =3D %#llx=
, dev_attr->max_fast_reg_page_list_len =3D %u, max_pages_per_mr =3D %d,=
 mr_max_size =3D %#x\n",
> -		 device->name, mr_page_shift, dev_attr->max_mr_size,
> -		 dev_attr->max_fast_reg_page_list_len,
> +	pr_debug("%s: mr_page_shift =3D %d, device->max_mr_size =3D %#llx, =
device->max_fast_reg_page_list_len =3D %u, max_pages_per_mr =3D %d, mr_=
max_size =3D %#x\n",
> +		 device->name, mr_page_shift, device->max_mr_size,
> +		 device->max_fast_reg_page_list_len,
> 		 srp_dev->max_pages_per_mr, srp_dev->mr_max_size);
>=20
> 	INIT_LIST_HEAD(&srp_dev->dev_list);
> @@ -3519,17 +3509,13 @@ static void srp_add_one(struct ib_device *dev=
ice)
> 	}
>=20
> 	ib_set_client_data(device, &srp_client, srp_dev);
> -
> -	goto free_attr;
> +	return;
>=20
> err_pd:
> 	ib_dealloc_pd(srp_dev->pd);
>=20
> free_dev:
> 	kfree(srp_dev);
> -
> -free_attr:
> -	kfree(dev_attr);
> }
>=20
> static void srp_remove_one(struct ib_device *device, void *client_dat=
a)
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniba=
nd/ulp/srpt/ib_srpt.c
> index d65533e..7e086ea 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -343,10 +343,10 @@ static void srpt_get_ioc(struct srpt_port *spor=
t, u32 slot,
> 	memset(iocp, 0, sizeof *iocp);
> 	strcpy(iocp->id_string, SRPT_ID_STRING);
> 	iocp->guid =3D cpu_to_be64(srpt_service_guid);
> -	iocp->vendor_id =3D cpu_to_be32(sdev->dev_attr.vendor_id);
> -	iocp->device_id =3D cpu_to_be32(sdev->dev_attr.vendor_part_id);
> -	iocp->device_version =3D cpu_to_be16(sdev->dev_attr.hw_ver);
> -	iocp->subsys_vendor_id =3D cpu_to_be32(sdev->dev_attr.vendor_id);
> +	iocp->vendor_id =3D cpu_to_be32(sdev->device->vendor_id);
> +	iocp->device_id =3D cpu_to_be32(sdev->device->vendor_part_id);
> +	iocp->device_version =3D cpu_to_be16(sdev->device->hw_ver);
> +	iocp->subsys_vendor_id =3D cpu_to_be32(sdev->device->vendor_id);
> 	iocp->subsys_device_id =3D 0x0;
> 	iocp->io_class =3D cpu_to_be16(SRP_REV16A_IB_IO_CLASS);
> 	iocp->io_subclass =3D cpu_to_be16(SRP_IO_SUBCLASS);
> @@ -3204,14 +3204,11 @@ static void srpt_add_one(struct ib_device *de=
vice)
> 	init_waitqueue_head(&sdev->ch_releaseQ);
> 	spin_lock_init(&sdev->spinlock);
>=20
> -	if (ib_query_device(device, &sdev->dev_attr))
> -		goto free_dev;
> -
> 	sdev->pd =3D ib_alloc_pd(device);
> 	if (IS_ERR(sdev->pd))
> 		goto free_dev;
>=20
> -	sdev->srq_size =3D min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
> +	sdev->srq_size =3D min(srpt_srq_size, sdev->device->max_srq_wr);
>=20
> 	srq_attr.event_handler =3D srpt_srq_event;
> 	srq_attr.srq_context =3D (void *)sdev;
> @@ -3225,7 +3222,7 @@ static void srpt_add_one(struct ib_device *devi=
ce)
> 		goto err_pd;
>=20
> 	pr_debug("%s: create SRQ #wr=3D %d max_allow=3D%d dev=3D %s\n",
> -		 __func__, sdev->srq_size, sdev->dev_attr.max_srq_wr,
> +		 __func__, sdev->srq_size, sdev->device->max_srq_wr,
> 		 device->name);
>=20
> 	if (!srpt_service_guid)
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniba=
nd/ulp/srpt/ib_srpt.h
> index 5faad8ac..0df7d61 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -379,8 +379,6 @@ struct srpt_port {
>  * @mr:            L_Key (local key) with write access to all local m=
emory.
>  * @srq:           Per-HCA SRQ (shared receive queue).
>  * @cm_id:         Connection identifier.
> - * @dev_attr:      Attributes of the InfiniBand device as obtained d=
uring the
> - *                 ib_client.add() callback.
>  * @srq_size:      SRQ size.
>  * @ioctx_ring:    Per-HCA SRQ.
>  * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.l=
ist.
> @@ -395,7 +393,6 @@ struct srpt_device {
> 	struct ib_pd		*pd;
> 	struct ib_srq		*srq;
> 	struct ib_cm_id		*cm_id;
> -	struct ib_device_attr	dev_attr;
> 	int			srq_size;
> 	struct srpt_recv_ioctx	**ioctx_ring;
> 	struct list_head	rch_list;
> diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/dr=
ivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> index c29d2ce..2701a39 100644
> --- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> +++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> @@ -2070,32 +2070,13 @@ static int kiblnd_net_init_pools(kib_net_t *n=
et, __u32 *cpts, int ncpts)
>=20
> static int kiblnd_hdev_get_attr(kib_hca_dev_t *hdev)
> {
> -	struct ib_device_attr *attr;
> -	int rc;
> -
> 	/* It's safe to assume a HCA can handle a page size
> 	 * matching that of the native system */
> 	hdev->ibh_page_shift =3D PAGE_SHIFT;
> 	hdev->ibh_page_size  =3D 1 << PAGE_SHIFT;
> 	hdev->ibh_page_mask  =3D ~((__u64)hdev->ibh_page_size - 1);
>=20
> -	LIBCFS_ALLOC(attr, sizeof(*attr));
> -	if (attr =3D=3D NULL) {
> -		CERROR("Out of memory\n");
> -		return -ENOMEM;
> -	}
> -
> -	rc =3D ib_query_device(hdev->ibh_ibdev, attr);
> -	if (rc =3D=3D 0)
> -		hdev->ibh_mr_size =3D attr->max_mr_size;
> -
> -	LIBCFS_FREE(attr, sizeof(*attr));
> -
> -	if (rc !=3D 0) {
> -		CERROR("Failed to query IB device: %d\n", rc);
> -		return rc;
> -	}
> -
> +	hdev->ibh_mr_size =3D hdev->ibh_ibdev->max_mr_size;
> 	if (hdev->ibh_mr_size =3D=3D ~0ULL) {
> 		hdev->ibh_mr_shift =3D 64;
> 		return 0;
> diff --git a/drivers/staging/rdma/amso1100/c2.h b/drivers/staging/rdm=
a/amso1100/c2.h
> index d619d73..dda3a5e 100644
> --- a/drivers/staging/rdma/amso1100/c2.h
> +++ b/drivers/staging/rdma/amso1100/c2.h
> @@ -306,9 +306,6 @@ struct c2_dev {
> 	struct list_head eh_wakeup_list;	/* event wakeup list */
> 	wait_queue_head_t req_vq_wo;
>=20
> -	/* Cached RNIC properties */
> -	struct ib_device_attr props;
> -
> 	struct c2_pd_table pd_table;
> 	struct c2_qp_table qp_table;
> 	int ports;		/* num of GigE ports */
> diff --git a/drivers/staging/rdma/amso1100/c2_pd.c b/drivers/staging/=
rdma/amso1100/c2_pd.c
> index f3e81dc..ef99b41 100644
> --- a/drivers/staging/rdma/amso1100/c2_pd.c
> +++ b/drivers/staging/rdma/amso1100/c2_pd.c
> @@ -74,13 +74,13 @@ int c2_init_pd_table(struct c2_dev *c2dev)
> {
>=20
> 	c2dev->pd_table.last =3D 0;
> -	c2dev->pd_table.max =3D c2dev->props.max_pd;
> +	c2dev->pd_table.max =3D c2dev->ibdev.max_pd;
> 	spin_lock_init(&c2dev->pd_table.lock);
> -	c2dev->pd_table.table =3D kmalloc(BITS_TO_LONGS(c2dev->props.max_pd=
) *
> +	c2dev->pd_table.table =3D kmalloc(BITS_TO_LONGS(c2dev->ibdev.max_pd=
) *
> 					sizeof(long), GFP_KERNEL);
> 	if (!c2dev->pd_table.table)
> 		return -ENOMEM;
> -	bitmap_zero(c2dev->pd_table.table, c2dev->props.max_pd);
> +	bitmap_zero(c2dev->pd_table.table, c2dev->ibdev.max_pd);
> 	return 0;
> }
>=20
> diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/st=
aging/rdma/amso1100/c2_provider.c
> index 25c3f00..92d91a8 100644
> --- a/drivers/staging/rdma/amso1100/c2_provider.c
> +++ b/drivers/staging/rdma/amso1100/c2_provider.c
> @@ -63,20 +63,6 @@
> #include "c2_provider.h"
> #include "c2_user.h"
>=20
> -static int c2_query_device(struct ib_device *ibdev, struct ib_device=
_attr *props,
> -			   struct ib_udata *uhw)
> -{
> -	struct c2_dev *c2dev =3D to_c2dev(ibdev);
> -
> -	pr_debug("%s:%u\n", __func__, __LINE__);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	*props =3D c2dev->props;
> -	return 0;
> -}
> -
> static int c2_query_port(struct ib_device *ibdev,
> 			 u8 port, struct ib_port_attr *props)
> {
> @@ -523,7 +509,7 @@ static ssize_t show_rev(struct device *dev, struc=
t device_attribute *attr,
> {
> 	struct c2_dev *c2dev =3D container_of(dev, struct c2_dev, ibdev.dev)=
;
> 	pr_debug("%s:%u\n", __func__, __LINE__);
> -	return sprintf(buf, "%x\n", c2dev->props.hw_ver);
> +	return sprintf(buf, "%x\n", c2dev->ibdev.hw_ver);
> }
>=20
> static ssize_t show_fw_ver(struct device *dev, struct device_attribut=
e *attr,
> @@ -532,9 +518,9 @@ static ssize_t show_fw_ver(struct device *dev, st=
ruct device_attribute *attr,
> 	struct c2_dev *c2dev =3D container_of(dev, struct c2_dev, ibdev.dev)=
;
> 	pr_debug("%s:%u\n", __func__, __LINE__);
> 	return sprintf(buf, "%x.%x.%x\n",
> -		       (int) (c2dev->props.fw_ver >> 32),
> -		       (int) (c2dev->props.fw_ver >> 16) & 0xffff,
> -		       (int) (c2dev->props.fw_ver & 0xffff));
> +		       (int) (c2dev->ibdev.fw_ver >> 32),
> +		       (int) (c2dev->ibdev.fw_ver >> 16) & 0xffff,
> +		       (int) (c2dev->ibdev.fw_ver & 0xffff));
> }
>=20
> static ssize_t show_hca(struct device *dev, struct device_attribute *=
attr,
> @@ -828,7 +814,6 @@ int c2_register_device(struct c2_dev *dev)
> 	dev->ibdev.phys_port_cnt =3D 1;
> 	dev->ibdev.num_comp_vectors =3D 1;
> 	dev->ibdev.dma_device =3D &dev->pcidev->dev;
> -	dev->ibdev.query_device =3D c2_query_device;
> 	dev->ibdev.query_port =3D c2_query_port;
> 	dev->ibdev.query_pkey =3D c2_query_pkey;
> 	dev->ibdev.query_gid =3D c2_query_gid;
> diff --git a/drivers/staging/rdma/amso1100/c2_rnic.c b/drivers/stagin=
g/rdma/amso1100/c2_rnic.c
> index d2a6d96..2173e5b 100644
> --- a/drivers/staging/rdma/amso1100/c2_rnic.c
> +++ b/drivers/staging/rdma/amso1100/c2_rnic.c
> @@ -120,7 +120,7 @@ static void c2_adapter_term(struct c2_dev *c2dev)
> /*
>  * Query the adapter
>  */
> -static int c2_rnic_query(struct c2_dev *c2dev, struct ib_device_attr=
 *props)
> +static int c2_rnic_query(struct c2_dev *c2dev)
> {
> 	struct c2_vq_req *vq_req;
> 	struct c2wr_rnic_query_req wr;
> @@ -156,47 +156,30 @@ static int c2_rnic_query(struct c2_dev *c2dev, =
struct ib_device_attr *props)
> 	if (err)
> 		goto bail2;
>=20
> -	props->fw_ver =3D
> +	c2dev->ibdev.fw_ver =3D
> 		((u64)be32_to_cpu(reply->fw_ver_major) << 32) |
> 		((be32_to_cpu(reply->fw_ver_minor) & 0xFFFF) << 16) |
> 		(be32_to_cpu(reply->fw_ver_patch) & 0xFFFF);
> -	memcpy(&props->sys_image_guid, c2dev->netdev->dev_addr, 6);
> -	props->max_mr_size         =3D 0xFFFFFFFF;
> -	props->page_size_cap       =3D ~(C2_MIN_PAGESIZE-1);
> -	props->vendor_id           =3D be32_to_cpu(reply->vendor_id);
> -	props->vendor_part_id      =3D be32_to_cpu(reply->part_number);
> -	props->hw_ver              =3D be32_to_cpu(reply->hw_version);
> -	props->max_qp              =3D be32_to_cpu(reply->max_qps);
> -	props->max_qp_wr           =3D be32_to_cpu(reply->max_qp_depth);
> -	props->device_cap_flags    =3D c2dev->device_cap_flags;
> -	props->max_sge             =3D C2_MAX_SGES;
> -	props->max_sge_rd          =3D C2_MAX_SGE_RD;
> -	props->max_cq              =3D be32_to_cpu(reply->max_cqs);
> -	props->max_cqe             =3D be32_to_cpu(reply->max_cq_depth);
> -	props->max_mr              =3D be32_to_cpu(reply->max_mrs);
> -	props->max_pd              =3D be32_to_cpu(reply->max_pds);
> -	props->max_qp_rd_atom      =3D be32_to_cpu(reply->max_qp_ird);
> -	props->max_ee_rd_atom      =3D 0;
> -	props->max_res_rd_atom     =3D be32_to_cpu(reply->max_global_ird);
> -	props->max_qp_init_rd_atom =3D be32_to_cpu(reply->max_qp_ord);
> -	props->max_ee_init_rd_atom =3D 0;
> -	props->atomic_cap          =3D IB_ATOMIC_NONE;
> -	props->max_ee              =3D 0;
> -	props->max_rdd             =3D 0;
> -	props->max_mw              =3D be32_to_cpu(reply->max_mws);
> -	props->max_raw_ipv6_qp     =3D 0;
> -	props->max_raw_ethy_qp     =3D 0;
> -	props->max_mcast_grp       =3D 0;
> -	props->max_mcast_qp_attach =3D 0;
> -	props->max_total_mcast_qp_attach =3D 0;
> -	props->max_ah              =3D 0;
> -	props->max_fmr             =3D 0;
> -	props->max_map_per_fmr     =3D 0;
> -	props->max_srq             =3D 0;
> -	props->max_srq_wr          =3D 0;
> -	props->max_srq_sge         =3D 0;
> -	props->max_pkeys           =3D 0;
> -	props->local_ca_ack_delay  =3D 0;
> +	memcpy(&c2dev->ibdev.sys_image_guid, c2dev->netdev->dev_addr, 6);
> +	c2dev->ibdev.max_mr_size         =3D 0xFFFFFFFF;
> +	c2dev->ibdev.page_size_cap       =3D ~(C2_MIN_PAGESIZE-1);
> +	c2dev->ibdev.vendor_id           =3D be32_to_cpu(reply->vendor_id);
> +	c2dev->ibdev.vendor_part_id      =3D be32_to_cpu(reply->part_number=
);
> +	c2dev->ibdev.hw_ver              =3D be32_to_cpu(reply->hw_version)=
;
> +	c2dev->ibdev.max_qp              =3D be32_to_cpu(reply->max_qps);
> +	c2dev->ibdev.max_qp_wr           =3D be32_to_cpu(reply->max_qp_dept=
h);
> +	c2dev->ibdev.device_cap_flags    =3D c2dev->device_cap_flags;
> +	c2dev->ibdev.max_sge             =3D C2_MAX_SGES;
> +	c2dev->ibdev.max_sge_rd          =3D C2_MAX_SGE_RD;
> +	c2dev->ibdev.max_cq              =3D be32_to_cpu(reply->max_cqs);
> +	c2dev->ibdev.max_cqe             =3D be32_to_cpu(reply->max_cq_dept=
h);
> +	c2dev->ibdev.max_mr              =3D be32_to_cpu(reply->max_mrs);
> +	c2dev->ibdev.max_pd              =3D be32_to_cpu(reply->max_pds);
> +	c2dev->ibdev.max_qp_rd_atom      =3D be32_to_cpu(reply->max_qp_ird)=
;
> +	c2dev->ibdev.max_res_rd_atom     =3D be32_to_cpu(reply->max_global_=
ird);
> +	c2dev->ibdev.max_qp_init_rd_atom =3D be32_to_cpu(reply->max_qp_ord)=
;
> +	c2dev->ibdev.atomic_cap          =3D IB_ATOMIC_NONE;
> +	c2dev->ibdev.max_mw              =3D be32_to_cpu(reply->max_mws);
>=20
>  bail2:
> 	vq_repbuf_free(c2dev, reply);
> @@ -576,7 +559,7 @@ int c2_rnic_init(struct c2_dev *c2dev)
> 		goto bail4;
>=20
> 	/* Initialize cached the adapter limits */
> -	err =3D c2_rnic_query(c2dev, &c2dev->props);
> +	err =3D c2_rnic_query(c2dev);
> 	if (err)
> 		goto bail5;
>=20
> diff --git a/drivers/staging/rdma/ehca/ehca_hca.c b/drivers/staging/r=
dma/ehca/ehca_hca.c
> index e8b1bb6..aa0828a 100644
> --- a/drivers/staging/rdma/ehca/ehca_hca.c
> +++ b/drivers/staging/rdma/ehca/ehca_hca.c
> @@ -50,8 +50,7 @@ static unsigned int limit_uint(unsigned int value)
> 	return min_t(unsigned int, value, INT_MAX);
> }
>=20
> -int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr=
 *props,
> -		      struct ib_udata *uhw)
> +int ehca_init_device_limits(struct ib_device *ibdev)
> {
> 	int i, ret =3D 0;
> 	struct ehca_shca *shca =3D container_of(ibdev, struct ehca_shca,
> @@ -72,8 +71,6 @@ int ehca_query_device(struct ib_device *ibdev, stru=
ct ib_device_attr *props,
> 		IB_DEVICE_PORT_ACTIVE_EVENT,  HCA_CAP_PORT_ACTIVE_EVENT,
> 	};
>=20
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
>=20
> 	rblock =3D ehca_alloc_fw_ctrlblock(GFP_KERNEL);
> 	if (!rblock) {
> @@ -87,55 +84,54 @@ int ehca_query_device(struct ib_device *ibdev, st=
ruct ib_device_attr *props,
> 		goto query_device1;
> 	}
>=20
> -	memset(props, 0, sizeof(struct ib_device_attr));
> -	props->page_size_cap   =3D shca->hca_cap_mr_pgsize;
> -	props->fw_ver          =3D rblock->hw_ver;
> -	props->max_mr_size     =3D rblock->max_mr_size;
> -	props->vendor_id       =3D rblock->vendor_id >> 8;
> -	props->vendor_part_id  =3D rblock->vendor_part_id >> 16;
> -	props->hw_ver          =3D rblock->hw_ver;
> -	props->max_qp          =3D limit_uint(rblock->max_qp);
> -	props->max_qp_wr       =3D limit_uint(rblock->max_wqes_wq);
> -	props->max_sge         =3D limit_uint(rblock->max_sge);
> -	props->max_sge_rd      =3D limit_uint(rblock->max_sge_rd);
> -	props->max_cq          =3D limit_uint(rblock->max_cq);
> -	props->max_cqe         =3D limit_uint(rblock->max_cqe);
> -	props->max_mr          =3D limit_uint(rblock->max_mr);
> -	props->max_mw          =3D limit_uint(rblock->max_mw);
> -	props->max_pd          =3D limit_uint(rblock->max_pd);
> -	props->max_ah          =3D limit_uint(rblock->max_ah);
> -	props->max_ee          =3D limit_uint(rblock->max_rd_ee_context);
> -	props->max_rdd         =3D limit_uint(rblock->max_rd_domain);
> -	props->max_fmr         =3D limit_uint(rblock->max_mr);
> -	props->max_qp_rd_atom  =3D limit_uint(rblock->max_rr_qp);
> -	props->max_ee_rd_atom  =3D limit_uint(rblock->max_rr_ee_context);
> -	props->max_res_rd_atom =3D limit_uint(rblock->max_rr_hca);
> -	props->max_qp_init_rd_atom =3D limit_uint(rblock->max_act_wqs_qp);
> -	props->max_ee_init_rd_atom =3D limit_uint(rblock->max_act_wqs_ee_co=
ntext);
> +	ibdev->page_size_cap   =3D shca->hca_cap_mr_pgsize;
> +	ibdev->fw_ver          =3D rblock->hw_ver;
> +	ibdev->max_mr_size     =3D rblock->max_mr_size;
> +	ibdev->vendor_id       =3D rblock->vendor_id >> 8;
> +	ibdev->vendor_part_id  =3D rblock->vendor_part_id >> 16;
> +	ibdev->hw_ver          =3D rblock->hw_ver;
> +	ibdev->max_qp          =3D limit_uint(rblock->max_qp);
> +	ibdev->max_qp_wr       =3D limit_uint(rblock->max_wqes_wq);
> +	ibdev->max_sge         =3D limit_uint(rblock->max_sge);
> +	ibdev->max_sge_rd      =3D limit_uint(rblock->max_sge_rd);
> +	ibdev->max_cq          =3D limit_uint(rblock->max_cq);
> +	ibdev->max_cqe         =3D limit_uint(rblock->max_cqe);
> +	ibdev->max_mr          =3D limit_uint(rblock->max_mr);
> +	ibdev->max_mw          =3D limit_uint(rblock->max_mw);
> +	ibdev->max_pd          =3D limit_uint(rblock->max_pd);
> +	ibdev->max_ah          =3D limit_uint(rblock->max_ah);
> +	ibdev->max_ee          =3D limit_uint(rblock->max_rd_ee_context);
> +	ibdev->max_rdd         =3D limit_uint(rblock->max_rd_domain);
> +	ibdev->max_fmr         =3D limit_uint(rblock->max_mr);
> +	ibdev->max_qp_rd_atom  =3D limit_uint(rblock->max_rr_qp);
> +	ibdev->max_ee_rd_atom  =3D limit_uint(rblock->max_rr_ee_context);
> +	ibdev->max_res_rd_atom =3D limit_uint(rblock->max_rr_hca);
> +	ibdev->max_qp_init_rd_atom =3D limit_uint(rblock->max_act_wqs_qp);
> +	ibdev->max_ee_init_rd_atom =3D limit_uint(rblock->max_act_wqs_ee_co=
ntext);
>=20
> 	if (EHCA_BMASK_GET(HCA_CAP_SRQ, shca->hca_cap)) {
> -		props->max_srq         =3D limit_uint(props->max_qp);
> -		props->max_srq_wr      =3D limit_uint(props->max_qp_wr);
> -		props->max_srq_sge     =3D 3;
> +		ibdev->max_srq         =3D limit_uint(ibdev->max_qp);
> +		ibdev->max_srq_wr      =3D limit_uint(ibdev->max_qp_wr);
> +		ibdev->max_srq_sge     =3D 3;
> 	}
>=20
> -	props->max_pkeys           =3D 16;
> +	ibdev->max_pkeys           =3D 16;
> 	/* Some FW versions say 0 here; insert sensible value in that case *=
/
> -	props->local_ca_ack_delay  =3D rblock->local_ca_ack_delay ?
> +	ibdev->local_ca_ack_delay  =3D rblock->local_ca_ack_delay ?
> 		min_t(u8, rblock->local_ca_ack_delay, 255) : 12;
> -	props->max_raw_ipv6_qp     =3D limit_uint(rblock->max_raw_ipv6_qp);
> -	props->max_raw_ethy_qp     =3D limit_uint(rblock->max_raw_ethy_qp);
> -	props->max_mcast_grp       =3D limit_uint(rblock->max_mcast_grp);
> -	props->max_mcast_qp_attach =3D limit_uint(rblock->max_mcast_qp_atta=
ch);
> -	props->max_total_mcast_qp_attach
> +	ibdev->max_raw_ipv6_qp     =3D limit_uint(rblock->max_raw_ipv6_qp);
> +	ibdev->max_raw_ethy_qp     =3D limit_uint(rblock->max_raw_ethy_qp);
> +	ibdev->max_mcast_grp       =3D limit_uint(rblock->max_mcast_grp);
> +	ibdev->max_mcast_qp_attach =3D limit_uint(rblock->max_mcast_qp_atta=
ch);
> +	ibdev->max_total_mcast_qp_attach
> 		=3D limit_uint(rblock->max_total_mcast_qp_attach);
>=20
> 	/* translate device capabilities */
> -	props->device_cap_flags =3D IB_DEVICE_SYS_IMAGE_GUID |
> +	ibdev->device_cap_flags =3D IB_DEVICE_SYS_IMAGE_GUID |
> 		IB_DEVICE_RC_RNR_NAK_GEN | IB_DEVICE_N_NOTIFY_CQ;
> 	for (i =3D 0; i < ARRAY_SIZE(cap_mapping); i +=3D 2)
> 		if (rblock->hca_cap_indicators & cap_mapping[i + 1])
> -			props->device_cap_flags |=3D cap_mapping[i];
> +			ibdev->device_cap_flags |=3D cap_mapping[i];
>=20
> query_device1:
> 	ehca_free_fw_ctrlblock(rblock);
> diff --git a/drivers/staging/rdma/ehca/ehca_iverbs.h b/drivers/stagin=
g/rdma/ehca/ehca_iverbs.h
> index 80e6a3d..75c9876 100644
> --- a/drivers/staging/rdma/ehca/ehca_iverbs.h
> +++ b/drivers/staging/rdma/ehca/ehca_iverbs.h
> @@ -44,8 +44,7 @@
>=20
> #include "ehca_classes.h"
>=20
> -int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr=
 *props,
> -		      struct ib_udata *uhw);
> +int ehca_init_device_limits(struct ib_device *ibdev);
>=20
> int ehca_query_port(struct ib_device *ibdev, u8 port,
> 		    struct ib_port_attr *props);
> diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/=
rdma/ehca/ehca_main.c
> index 8246418..285e560 100644
> --- a/drivers/staging/rdma/ehca/ehca_main.c
> +++ b/drivers/staging/rdma/ehca/ehca_main.c
> @@ -484,7 +484,6 @@ static int ehca_init_device(struct ehca_shca *shc=
a)
> 	shca->ib_device.phys_port_cnt       =3D shca->num_ports;
> 	shca->ib_device.num_comp_vectors    =3D 1;
> 	shca->ib_device.dma_device          =3D &shca->ofdev->dev;
> -	shca->ib_device.query_device        =3D ehca_query_device;
> 	shca->ib_device.query_port          =3D ehca_query_port;
> 	shca->ib_device.query_gid           =3D ehca_query_gid;
> 	shca->ib_device.query_pkey          =3D ehca_query_pkey;
> @@ -545,7 +544,7 @@ static int ehca_init_device(struct ehca_shca *shc=
a)
> 		shca->ib_device.post_srq_recv       =3D ehca_post_srq_recv;
> 	}
>=20
> -	return ret;
> +	return ehca_init_device_limits(&shca->ib_device);
> }
>=20
> static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
> diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma=
/hfi1/verbs.c
> index 6e2da7e..bfc3c95 100644
> --- a/drivers/staging/rdma/hfi1/verbs.c
> +++ b/drivers/staging/rdma/hfi1/verbs.c
> @@ -1367,57 +1367,6 @@ int hfi1_verbs_send(struct hfi1_qp *qp, struct=
 ahg_ib_header *ahdr,
> 	return ret;
> }
>=20
> -static int query_device(struct ib_device *ibdev,
> -			struct ib_device_attr *props,
> -			struct ib_udata *uhw)
> -{
> -	struct hfi1_devdata *dd =3D dd_from_ibdev(ibdev);
> -	struct hfi1_ibdev *dev =3D to_idev(ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -	memset(props, 0, sizeof(*props));
> -
> -	props->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> -		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> -		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> -		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> -
> -	props->page_size_cap =3D PAGE_SIZE;
> -	props->vendor_id =3D
> -		dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
> -	props->vendor_part_id =3D dd->pcidev->device;
> -	props->hw_ver =3D dd->minrev;
> -	props->sys_image_guid =3D ib_hfi1_sys_image_guid;
> -	props->max_mr_size =3D ~0ULL;
> -	props->max_qp =3D hfi1_max_qps;
> -	props->max_qp_wr =3D hfi1_max_qp_wrs;
> -	props->max_sge =3D hfi1_max_sges;
> -	props->max_sge_rd =3D hfi1_max_sges;
> -	props->max_cq =3D hfi1_max_cqs;
> -	props->max_ah =3D hfi1_max_ahs;
> -	props->max_cqe =3D hfi1_max_cqes;
> -	props->max_mr =3D dev->lk_table.max;
> -	props->max_fmr =3D dev->lk_table.max;
> -	props->max_map_per_fmr =3D 32767;
> -	props->max_pd =3D hfi1_max_pds;
> -	props->max_qp_rd_atom =3D HFI1_MAX_RDMA_ATOMIC;
> -	props->max_qp_init_rd_atom =3D 255;
> -	/* props->max_res_rd_atom */
> -	props->max_srq =3D hfi1_max_srqs;
> -	props->max_srq_wr =3D hfi1_max_srq_wrs;
> -	props->max_srq_sge =3D hfi1_max_srq_sges;
> -	/* props->local_ca_ack_delay */
> -	props->atomic_cap =3D IB_ATOMIC_GLOB;
> -	props->max_pkeys =3D hfi1_get_npkeys(dd);
> -	props->max_mcast_grp =3D hfi1_max_mcast_grps;
> -	props->max_mcast_qp_attach =3D hfi1_max_mcast_qp_attached;
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -		props->max_mcast_grp;
> -
> -	return 0;
> -}
> -
> static inline u16 opa_speed_to_ib(u16 in)
> {
> 	u16 out =3D 0;
> @@ -2025,7 +1974,6 @@ int hfi1_register_ib_device(struct hfi1_devdata=
 *dd)
> 	ibdev->phys_port_cnt =3D dd->num_pports;
> 	ibdev->num_comp_vectors =3D 1;
> 	ibdev->dma_device =3D &dd->pcidev->dev;
> -	ibdev->query_device =3D query_device;
> 	ibdev->modify_device =3D modify_device;
> 	ibdev->query_port =3D query_port;
> 	ibdev->modify_port =3D modify_port;
> @@ -2071,6 +2019,43 @@ int hfi1_register_ib_device(struct hfi1_devdat=
a *dd)
> 	ibdev->dma_ops =3D &hfi1_dma_mapping_ops;
> 	ibdev->get_port_immutable =3D port_immutable;
>=20
> +	ibdev->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> +		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> +		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> +		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> +
> +	ibdev->page_size_cap =3D PAGE_SIZE;
> +	ibdev->vendor_id =3D
> +		dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
> +	ibdev->vendor_part_id =3D dd->pcidev->device;
> +	ibdev->hw_ver =3D dd->minrev;
> +	ibdev->sys_image_guid =3D ib_hfi1_sys_image_guid;
> +	ibdev->max_mr_size =3D ~0ULL;
> +	ibdev->max_qp =3D hfi1_max_qps;
> +	ibdev->max_qp_wr =3D hfi1_max_qp_wrs;
> +	ibdev->max_sge =3D hfi1_max_sges;
> +	ibdev->max_sge_rd =3D hfi1_max_sges;
> +	ibdev->max_cq =3D hfi1_max_cqs;
> +	ibdev->max_ah =3D hfi1_max_ahs;
> +	ibdev->max_cqe =3D hfi1_max_cqes;
> +	ibdev->max_mr =3D dev->lk_table.max;
> +	ibdev->max_fmr =3D dev->lk_table.max;
> +	ibdev->max_map_per_fmr =3D 32767;
> +	ibdev->max_pd =3D hfi1_max_pds;
> +	ibdev->max_qp_rd_atom =3D HFI1_MAX_RDMA_ATOMIC;
> +	ibdev->max_qp_init_rd_atom =3D 255;
> +	/* ibdev->max_res_rd_atom */
> +	ibdev->max_srq =3D hfi1_max_srqs;
> +	ibdev->max_srq_wr =3D hfi1_max_srq_wrs;
> +	ibdev->max_srq_sge =3D hfi1_max_srq_sges;
> +	/* ibdev->local_ca_ack_delay */
> +	ibdev->atomic_cap =3D IB_ATOMIC_GLOB;
> +	ibdev->max_pkeys =3D hfi1_get_npkeys(dd);
> +	ibdev->max_mcast_grp =3D hfi1_max_mcast_grps;
> +	ibdev->max_mcast_qp_attach =3D hfi1_max_mcast_qp_attached;
> +	ibdev->max_total_mcast_qp_attach =3D ibdev->max_mcast_qp_attach *
> +		ibdev->max_mcast_grp;
> +
> 	strncpy(ibdev->node_desc, init_utsname()->nodename,
> 		sizeof(ibdev->node_desc));
>=20
> diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/stagi=
ng/rdma/ipath/ipath_verbs.c
> index 15633ec..16f4cea 100644
> --- a/drivers/staging/rdma/ipath/ipath_verbs.c
> +++ b/drivers/staging/rdma/ipath/ipath_verbs.c
> @@ -1511,57 +1511,6 @@ bail:
> 	return 0;
> }
>=20
> -static int ipath_query_device(struct ib_device *ibdev, struct ib_dev=
ice_attr *props,
> -			      struct ib_udata *uhw)
> -{
> -	struct ipath_ibdev *dev =3D to_idev(ibdev);
> -
> -	if (uhw->inlen || uhw->outlen)
> -		return -EINVAL;
> -
> -	memset(props, 0, sizeof(*props));
> -
> -	props->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> -		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> -		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> -		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> -	props->page_size_cap =3D PAGE_SIZE;
> -	props->vendor_id =3D
> -		IPATH_SRC_OUI_1 << 16 | IPATH_SRC_OUI_2 << 8 | IPATH_SRC_OUI_3;
> -	props->vendor_part_id =3D dev->dd->ipath_deviceid;
> -	props->hw_ver =3D dev->dd->ipath_pcirev;
> -
> -	props->sys_image_guid =3D dev->sys_image_guid;
> -
> -	props->max_mr_size =3D ~0ull;
> -	props->max_qp =3D ib_ipath_max_qps;
> -	props->max_qp_wr =3D ib_ipath_max_qp_wrs;
> -	props->max_sge =3D ib_ipath_max_sges;
> -	props->max_sge_rd =3D ib_ipath_max_sges;
> -	props->max_cq =3D ib_ipath_max_cqs;
> -	props->max_ah =3D ib_ipath_max_ahs;
> -	props->max_cqe =3D ib_ipath_max_cqes;
> -	props->max_mr =3D dev->lk_table.max;
> -	props->max_fmr =3D dev->lk_table.max;
> -	props->max_map_per_fmr =3D 32767;
> -	props->max_pd =3D ib_ipath_max_pds;
> -	props->max_qp_rd_atom =3D IPATH_MAX_RDMA_ATOMIC;
> -	props->max_qp_init_rd_atom =3D 255;
> -	/* props->max_res_rd_atom */
> -	props->max_srq =3D ib_ipath_max_srqs;
> -	props->max_srq_wr =3D ib_ipath_max_srq_wrs;
> -	props->max_srq_sge =3D ib_ipath_max_srq_sges;
> -	/* props->local_ca_ack_delay */
> -	props->atomic_cap =3D IB_ATOMIC_GLOB;
> -	props->max_pkeys =3D ipath_get_npkeys(dev->dd);
> -	props->max_mcast_grp =3D ib_ipath_max_mcast_grps;
> -	props->max_mcast_qp_attach =3D ib_ipath_max_mcast_qp_attached;
> -	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
> -		props->max_mcast_grp;
> -
> -	return 0;
> -}
> -
> const u8 ipath_cvt_physportstate[32] =3D {
> 	[INFINIPATH_IBCS_LT_STATE_DISABLED] =3D IB_PHYSPORTSTATE_DISABLED,
> 	[INFINIPATH_IBCS_LT_STATE_LINKUP] =3D IB_PHYSPORTSTATE_LINKUP,
> @@ -2175,7 +2124,6 @@ int ipath_register_ib_device(struct ipath_devda=
ta *dd)
> 	dev->phys_port_cnt =3D 1;
> 	dev->num_comp_vectors =3D 1;
> 	dev->dma_device =3D &dd->pcidev->dev;
> -	dev->query_device =3D ipath_query_device;
> 	dev->modify_device =3D ipath_modify_device;
> 	dev->query_port =3D ipath_query_port;
> 	dev->modify_port =3D ipath_modify_port;
> @@ -2219,6 +2167,44 @@ int ipath_register_ib_device(struct ipath_devd=
ata *dd)
> 	dev->dma_ops =3D &ipath_dma_mapping_ops;
> 	dev->get_port_immutable =3D ipath_port_immutable;
>=20
> +	dev->device_cap_flags =3D IB_DEVICE_BAD_PKEY_CNTR |
> +		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> +		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> +		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
> +	dev->page_size_cap =3D PAGE_SIZE;
> +	dev->vendor_id =3D
> +		IPATH_SRC_OUI_1 << 16 | IPATH_SRC_OUI_2 << 8 | IPATH_SRC_OUI_3;
> +	dev->vendor_part_id =3D idev->dd->ipath_deviceid;
> +	dev->hw_ver =3D idev->dd->ipath_pcirev;
> +
> +	dev->sys_image_guid =3D idev->sys_image_guid;
> +
> +	dev->max_mr_size =3D ~0ull;
> +	dev->max_qp =3D ib_ipath_max_qps;
> +	dev->max_qp_wr =3D ib_ipath_max_qp_wrs;
> +	dev->max_sge =3D ib_ipath_max_sges;
> +	dev->max_sge_rd =3D ib_ipath_max_sges;
> +	dev->max_cq =3D ib_ipath_max_cqs;
> +	dev->max_ah =3D ib_ipath_max_ahs;
> +	dev->max_cqe =3D ib_ipath_max_cqes;
> +	dev->max_mr =3D idev->lk_table.max;
> +	dev->max_fmr =3D idev->lk_table.max;
> +	dev->max_map_per_fmr =3D 32767;
> +	dev->max_pd =3D ib_ipath_max_pds;
> +	dev->max_qp_rd_atom =3D IPATH_MAX_RDMA_ATOMIC;
> +	dev->max_qp_init_rd_atom =3D 255;
> +	/* dev->max_res_rd_atom */
> +	dev->max_srq =3D ib_ipath_max_srqs;
> +	dev->max_srq_wr =3D ib_ipath_max_srq_wrs;
> +	dev->max_srq_sge =3D ib_ipath_max_srq_sges;
> +	/* dev->local_ca_ack_delay */
> +	dev->atomic_cap =3D IB_ATOMIC_GLOB;
> +	dev->max_pkeys =3D ipath_get_npkeys(idev->dd);
> +	dev->max_mcast_grp =3D ib_ipath_max_mcast_grps;
> +	dev->max_mcast_qp_attach =3D ib_ipath_max_mcast_qp_attached;
> +	dev->max_total_mcast_qp_attach =3D dev->max_mcast_qp_attach *
> +		dev->max_mcast_grp;
> +
> 	snprintf(dev->node_desc, sizeof(dev->node_desc),
> 		 IPATH_IDSTR " %s", init_utsname()->nodename);
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ed3f181..ef8783a 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -190,54 +190,6 @@ struct ib_cq_init_attr {
> 	u32		flags;
> };
>=20
> -struct ib_device_attr {
> -	u64			fw_ver;
> -	__be64			sys_image_guid;
> -	u64			max_mr_size;
> -	u64			page_size_cap;
> -	u32			vendor_id;
> -	u32			vendor_part_id;
> -	u32			hw_ver;
> -	int			max_qp;
> -	int			max_qp_wr;
> -	int			device_cap_flags;
> -	int			max_sge;
> -	int			max_sge_rd;
> -	int			max_cq;
> -	int			max_cqe;
> -	int			max_mr;
> -	int			max_pd;
> -	int			max_qp_rd_atom;
> -	int			max_ee_rd_atom;
> -	int			max_res_rd_atom;
> -	int			max_qp_init_rd_atom;
> -	int			max_ee_init_rd_atom;
> -	enum ib_atomic_cap	atomic_cap;
> -	enum ib_atomic_cap	masked_atomic_cap;
> -	int			max_ee;
> -	int			max_rdd;
> -	int			max_mw;
> -	int			max_raw_ipv6_qp;
> -	int			max_raw_ethy_qp;
> -	int			max_mcast_grp;
> -	int			max_mcast_qp_attach;
> -	int			max_total_mcast_qp_attach;
> -	int			max_ah;
> -	int			max_fmr;
> -	int			max_map_per_fmr;
> -	int			max_srq;
> -	int			max_srq_wr;
> -	int			max_srq_sge;
> -	unsigned int		max_fast_reg_page_list_len;
> -	u16			max_pkeys;
> -	u8			local_ca_ack_delay;
> -	int			sig_prot_cap;
> -	int			sig_guard_cap;
> -	struct ib_odp_caps	odp_caps;
> -	uint64_t		timestamp_mask;
> -	uint64_t		hca_core_clock; /* in KHZ */
> -};
> -
> enum ib_mtu {
> 	IB_MTU_256  =3D 1,
> 	IB_MTU_512  =3D 2,
> @@ -1608,7 +1560,6 @@ struct ib_device {
> 	int		           (*get_protocol_stats)(struct ib_device *device,
> 							 union rdma_protocol_stats *stats);
> 	int		           (*query_device)(struct ib_device *device,
> -						   struct ib_device_attr *device_attr,
> 						   struct ib_udata *udata);
> 	int		           (*query_port)(struct ib_device *device,
> 						 u8 port_num,
> @@ -1829,6 +1780,52 @@ struct ib_device {
> 	u8                           node_type;
> 	u8                           phys_port_cnt;
>=20
> +	u64			fw_ver;
> +	__be64			sys_image_guid;
> +	u64			max_mr_size;
> +	u64			page_size_cap;
> +	u32			vendor_id;
> +	u32			vendor_part_id;
> +	u32			hw_ver;
> +	int			max_qp;
> +	int			max_qp_wr;
> +	int			device_cap_flags;
> +	int			max_sge;
> +	int			max_sge_rd;
> +	int			max_cq;
> +	int			max_cqe;
> +	int			max_mr;
> +	int			max_pd;
> +	int			max_qp_rd_atom;
> +	int			max_ee_rd_atom;
> +	int			max_res_rd_atom;
> +	int			max_qp_init_rd_atom;
> +	int			max_ee_init_rd_atom;
> +	enum ib_atomic_cap	atomic_cap;
> +	enum ib_atomic_cap	masked_atomic_cap;
> +	int			max_ee;
> +	int			max_rdd;
> +	int			max_mw;
> +	int			max_raw_ipv6_qp;
> +	int			max_raw_ethy_qp;
> +	int			max_mcast_grp;
> +	int			max_mcast_qp_attach;
> +	int			max_total_mcast_qp_attach;
> +	int			max_ah;
> +	int			max_fmr;
> +	int			max_map_per_fmr;
> +	int			max_srq;
> +	int			max_srq_wr;
> +	int			max_srq_sge;
> +	unsigned int		max_fast_reg_page_list_len;
> +	u16			max_pkeys;
> +	u8			local_ca_ack_delay;
> +	int			sig_prot_cap;
> +	int			sig_guard_cap;
> +	struct ib_odp_caps	odp_caps;
> +	uint64_t		timestamp_mask;
> +	uint64_t		hca_core_clock; /* in KHZ */
> +
> 	/**
> 	 * The following mandatory functions are used only at device
> 	 * registration.  Keep functions such as these at the end of this
> @@ -1917,9 +1914,6 @@ int ib_register_event_handler  (struct ib_event=
_handler *event_handler);
> int ib_unregister_event_handler(struct ib_event_handler *event_handle=
r);
> void ib_dispatch_event(struct ib_event *event);
>=20
> -int ib_query_device(struct ib_device *device,
> -		    struct ib_device_attr *device_attr);
> -
> int ib_query_port(struct ib_device *device,
> 		  u8 port_num, struct ib_port_attr *port_attr);
>=20
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 2d3f2ab..9ec4f39 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -120,40 +120,30 @@ void rds_ib_dev_put(struct rds_ib_device *rds_i=
bdev)
> static void rds_ib_add_one(struct ib_device *device)
> {
> 	struct rds_ib_device *rds_ibdev;
> -	struct ib_device_attr *dev_attr;
>=20
> 	/* Only handle IB (no iWARP) devices */
> 	if (device->node_type !=3D RDMA_NODE_IB_CA)
> 		return;
>=20
> -	dev_attr =3D kmalloc(sizeof *dev_attr, GFP_KERNEL);
> -	if (!dev_attr)
> -		return;
> -
> -	if (ib_query_device(device, dev_attr)) {
> -		rdsdebug("Query device failed for %s\n", device->name);
> -		goto free_attr;
> -	}
> -
> 	rds_ibdev =3D kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
> 				 ibdev_to_node(device));
> 	if (!rds_ibdev)
> -		goto free_attr;
> +		return;
>=20
> 	spin_lock_init(&rds_ibdev->spinlock);
> 	atomic_set(&rds_ibdev->refcount, 1);
> 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
>=20
> -	rds_ibdev->max_wrs =3D dev_attr->max_qp_wr;
> -	rds_ibdev->max_sge =3D min(dev_attr->max_sge, RDS_IB_MAX_SGE);
> +	rds_ibdev->max_wrs =3D device->max_qp_wr;
> +	rds_ibdev->max_sge =3D min(device->max_sge, RDS_IB_MAX_SGE);
>=20
> -	rds_ibdev->fmr_max_remaps =3D dev_attr->max_map_per_fmr?: 32;
> -	rds_ibdev->max_fmrs =3D dev_attr->max_fmr ?
> -			min_t(unsigned int, dev_attr->max_fmr, fmr_pool_size) :
> +	rds_ibdev->fmr_max_remaps =3D device->max_map_per_fmr?: 32;
> +	rds_ibdev->max_fmrs =3D device->max_fmr ?
> +			min_t(unsigned int, device->max_fmr, fmr_pool_size) :
> 			fmr_pool_size;
>=20
> -	rds_ibdev->max_initiator_depth =3D dev_attr->max_qp_init_rd_atom;
> -	rds_ibdev->max_responder_resources =3D dev_attr->max_qp_rd_atom;
> +	rds_ibdev->max_initiator_depth =3D device->max_qp_init_rd_atom;
> +	rds_ibdev->max_responder_resources =3D device->max_qp_rd_atom;
>=20
> 	rds_ibdev->dev =3D device;
> 	rds_ibdev->pd =3D ib_alloc_pd(device);
> @@ -183,8 +173,6 @@ static void rds_ib_add_one(struct ib_device *devi=
ce)
>=20
> put_dev:
> 	rds_ib_dev_put(rds_ibdev);
> -free_attr:
> -	kfree(dev_attr);
> }
>=20
> /*
> diff --git a/net/rds/iw.c b/net/rds/iw.c
> index 3df0295..32be82a 100644
> --- a/net/rds/iw.c
> +++ b/net/rds/iw.c
> @@ -60,30 +60,20 @@ LIST_HEAD(iw_nodev_conns);
> static void rds_iw_add_one(struct ib_device *device)
> {
> 	struct rds_iw_device *rds_iwdev;
> -	struct ib_device_attr *dev_attr;
>=20
> 	/* Only handle iwarp devices */
> 	if (device->node_type !=3D RDMA_NODE_RNIC)
> 		return;
>=20
> -	dev_attr =3D kmalloc(sizeof *dev_attr, GFP_KERNEL);
> -	if (!dev_attr)
> -		return;
> -
> -	if (ib_query_device(device, dev_attr)) {
> -		rdsdebug("Query device failed for %s\n", device->name);
> -		goto free_attr;
> -	}
> -
> 	rds_iwdev =3D kmalloc(sizeof *rds_iwdev, GFP_KERNEL);
> 	if (!rds_iwdev)
> -		goto free_attr;
> +		return;
>=20
> 	spin_lock_init(&rds_iwdev->spinlock);
>=20
> -	rds_iwdev->dma_local_lkey =3D !!(dev_attr->device_cap_flags & IB_DE=
VICE_LOCAL_DMA_LKEY);
> -	rds_iwdev->max_wrs =3D dev_attr->max_qp_wr;
> -	rds_iwdev->max_sge =3D min(dev_attr->max_sge, RDS_IW_MAX_SGE);
> +	rds_iwdev->dma_local_lkey =3D !!(device->device_cap_flags & IB_DEVI=
CE_LOCAL_DMA_LKEY);
> +	rds_iwdev->max_wrs =3D device->max_qp_wr;
> +	rds_iwdev->max_sge =3D min(device->max_sge, RDS_IW_MAX_SGE);
>=20
> 	rds_iwdev->dev =3D device;
> 	rds_iwdev->pd =3D ib_alloc_pd(device);
> @@ -111,8 +101,7 @@ static void rds_iw_add_one(struct ib_device *devi=
ce)
> 	list_add_tail(&rds_iwdev->list, &rds_iw_devices);
>=20
> 	ib_set_client_data(device, &rds_iw_client, rds_iwdev);
> -
> -	goto free_attr;
> +	return;
>=20
> err_mr:
> 	if (rds_iwdev->mr)
> @@ -121,8 +110,6 @@ err_pd:
> 	ib_dealloc_pd(rds_iwdev->pd);
> free_dev:
> 	kfree(rds_iwdev);
> -free_attr:
> -	kfree(dev_attr);
> }
>=20
> static void rds_iw_remove_one(struct ib_device *device, void *client_=
data)
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frw=
r_ops.c
> index 4d0221c..ffda763 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -190,12 +190,11 @@ static int
> frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
> 	     struct rpcrdma_create_data_internal *cdata)
> {
> -	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> 	int depth, delta;
>=20
> 	ia->ri_max_frmr_depth =3D
> 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
> -			      devattr->max_fast_reg_page_list_len);
> +			      ia->ri_device->max_fast_reg_page_list_len);
> 	dprintk("RPC:       %s: device's max FR page list len =3D %u\n",
> 		__func__, ia->ri_max_frmr_depth);
>=20
> @@ -222,8 +221,8 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdm=
a_ep *ep,
> 	}
>=20
> 	ep->rep_attr.cap.max_send_wr *=3D depth;
> -	if (ep->rep_attr.cap.max_send_wr > devattr->max_qp_wr) {
> -		cdata->max_requests =3D devattr->max_qp_wr / depth;
> +	if (ep->rep_attr.cap.max_send_wr > ia->ri_device->max_qp_wr) {
> +		cdata->max_requests =3D ia->ri_device->max_qp_wr / depth;
> 		if (!cdata->max_requests)
> 			return -EINVAL;
> 		ep->rep_attr.cap.max_send_wr =3D cdata->max_requests *
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xp=
rtrdma/svc_rdma_transport.c
> index 502dcec..3e4d345 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -828,10 +828,10 @@ static struct svc_xprt *svc_rdma_accept(struct =
svc_xprt *xprt)
> 	struct rdma_conn_param conn_param;
> 	struct ib_cq_init_attr cq_attr =3D {};
> 	struct ib_qp_init_attr qp_attr;
> -	struct ib_device_attr devattr;
> +	struct ib_device *dev;
> 	int uninitialized_var(dma_mr_acc);
> 	int need_dma_mr =3D 0;
> -	int ret;
> +	int ret =3D 0;
> 	int i;
>=20
> 	listen_rdma =3D container_of(xprt, struct svcxprt_rdma, sc_xprt);
> @@ -852,20 +852,15 @@ static struct svc_xprt *svc_rdma_accept(struct =
svc_xprt *xprt)
> 	dprintk("svcrdma: newxprt from accept queue =3D %p, cm_id=3D%p\n",
> 		newxprt, newxprt->sc_cm_id);
>=20
> -	ret =3D ib_query_device(newxprt->sc_cm_id->device, &devattr);
> -	if (ret) {
> -		dprintk("svcrdma: could not query device attributes on "
> -			"device %p, rc=3D%d\n", newxprt->sc_cm_id->device, ret);
> -		goto errout;
> -	}
> +	dev =3D newxprt->sc_cm_id->device;
>=20
> 	/* Qualify the transport resource defaults with the
> 	 * capabilities of this particular device */
> -	newxprt->sc_max_sge =3D min((size_t)devattr.max_sge,
> +	newxprt->sc_max_sge =3D min((size_t)dev->max_sge,
> 				  (size_t)RPCSVC_MAXPAGES);
> -	newxprt->sc_max_sge_rd =3D min_t(size_t, devattr.max_sge_rd,
> +	newxprt->sc_max_sge_rd =3D min_t(size_t, dev->max_sge_rd,
> 				       RPCSVC_MAXPAGES);
> -	newxprt->sc_max_requests =3D min((size_t)devattr.max_qp_wr,
> +	newxprt->sc_max_requests =3D min((size_t)dev->max_qp_wr,
> 				   (size_t)svcrdma_max_requests);
> 	newxprt->sc_sq_depth =3D RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_max_req=
uests;
>=20
> @@ -873,16 +868,16 @@ static struct svc_xprt *svc_rdma_accept(struct =
svc_xprt *xprt)
> 	 * Limit ORD based on client limit, local device limit, and
> 	 * configured svcrdma limit.
> 	 */
> -	newxprt->sc_ord =3D min_t(size_t, devattr.max_qp_rd_atom, newxprt->=
sc_ord);
> +	newxprt->sc_ord =3D min_t(size_t, dev->max_qp_rd_atom, newxprt->sc_=
ord);
> 	newxprt->sc_ord =3D min_t(size_t,	svcrdma_ord, newxprt->sc_ord);
>=20
> -	newxprt->sc_pd =3D ib_alloc_pd(newxprt->sc_cm_id->device);
> +	newxprt->sc_pd =3D ib_alloc_pd(dev);
> 	if (IS_ERR(newxprt->sc_pd)) {
> 		dprintk("svcrdma: error creating PD for connect request\n");
> 		goto errout;
> 	}
> 	cq_attr.cqe =3D newxprt->sc_sq_depth;
> -	newxprt->sc_sq_cq =3D ib_create_cq(newxprt->sc_cm_id->device,
> +	newxprt->sc_sq_cq =3D ib_create_cq(dev,
> 					 sq_comp_handler,
> 					 cq_event_handler,
> 					 newxprt,
> @@ -892,7 +887,7 @@ static struct svc_xprt *svc_rdma_accept(struct sv=
c_xprt *xprt)
> 		goto errout;
> 	}
> 	cq_attr.cqe =3D newxprt->sc_max_requests;
> -	newxprt->sc_rq_cq =3D ib_create_cq(newxprt->sc_cm_id->device,
> +	newxprt->sc_rq_cq =3D ib_create_cq(dev,
> 					 rq_comp_handler,
> 					 cq_event_handler,
> 					 newxprt,
> @@ -920,7 +915,7 @@ static struct svc_xprt *svc_rdma_accept(struct sv=
c_xprt *xprt)
> 		"    cap.max_send_sge =3D %d\n"
> 		"    cap.max_recv_sge =3D %d\n",
> 		newxprt->sc_cm_id, newxprt->sc_pd,
> -		newxprt->sc_cm_id->device, newxprt->sc_pd->device,
> +		dev, newxprt->sc_pd->device,
> 		qp_attr.cap.max_send_wr,
> 		qp_attr.cap.max_recv_wr,
> 		qp_attr.cap.max_send_sge,
> @@ -956,9 +951,9 @@ static struct svc_xprt *svc_rdma_accept(struct sv=
c_xprt *xprt)
> 	 *	of an RDMA_READ. IB does not.
> 	 */
> 	newxprt->sc_reader =3D rdma_read_chunk_lcl;
> -	if (devattr.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
> +	if (dev->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
> 		newxprt->sc_frmr_pg_list_len =3D
> -			devattr.max_fast_reg_page_list_len;
> +			dev->max_fast_reg_page_list_len;
> 		newxprt->sc_dev_caps |=3D SVCRDMA_DEVCAP_FAST_REG;
> 		newxprt->sc_reader =3D rdma_read_chunk_frmr;
> 	}
> @@ -966,24 +961,20 @@ static struct svc_xprt *svc_rdma_accept(struct =
svc_xprt *xprt)
> 	/*
> 	 * Determine if a DMA MR is required and if so, what privs are requi=
red
> 	 */
> -	if (!rdma_protocol_iwarp(newxprt->sc_cm_id->device,
> -				 newxprt->sc_cm_id->port_num) &&
> -	    !rdma_ib_or_roce(newxprt->sc_cm_id->device,
> -			     newxprt->sc_cm_id->port_num))
> +	if (!rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
> +	    !rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num))
> 		goto errout;
>=20
> 	if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
> -	    !(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
> +	    !(dev->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
> 		need_dma_mr =3D 1;
> 		dma_mr_acc =3D IB_ACCESS_LOCAL_WRITE;
> -		if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
> -					newxprt->sc_cm_id->port_num) &&
> +		if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
> 		    !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
> 			dma_mr_acc |=3D IB_ACCESS_REMOTE_WRITE;
> 	}
>=20
> -	if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
> -				newxprt->sc_cm_id->port_num))
> +	if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num))
> 		newxprt->sc_dev_caps |=3D SVCRDMA_DEVCAP_READ_W_INV;
>=20
> 	/* Create the DMA MR if needed, otherwise, use the DMA LKEY */
> @@ -998,8 +989,7 @@ static struct svc_xprt *svc_rdma_accept(struct sv=
c_xprt *xprt)
> 		}
> 		newxprt->sc_dma_lkey =3D newxprt->sc_phys_mr->lkey;
> 	} else
> -		newxprt->sc_dma_lkey =3D
> -			newxprt->sc_cm_id->device->local_dma_lkey;
> +		newxprt->sc_dma_lkey =3D dev->local_dma_lkey;
>=20
> 	/* Post receive buffers */
> 	for (i =3D 0; i < newxprt->sc_max_requests; i++) {
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index 4f405bc..9864ec0 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -515,7 +515,6 @@ int
> rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int=
 memreg)
> {
> 	struct rpcrdma_ia *ia =3D &xprt->rx_ia;
> -	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> 	int rc;
>=20
> 	ia->ri_dma_mr =3D NULL;
> @@ -535,19 +534,12 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, stru=
ct sockaddr *addr, int memreg)
> 		goto out2;
> 	}
>=20
> -	rc =3D ib_query_device(ia->ri_device, devattr);
> -	if (rc) {
> -		dprintk("RPC:       %s: ib_query_device failed %d\n",
> -			__func__, rc);
> -		goto out3;
> -	}
> -
> 	if (memreg =3D=3D RPCRDMA_FRMR) {
> 		/* Requires both frmr reg and local dma lkey */
> -		if (((devattr->device_cap_flags &
> +		if (((ia->ri_device->device_cap_flags &
> 		     (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) !=3D
> 		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) ||
> -		      (devattr->max_fast_reg_page_list_len =3D=3D 0)) {
> +		      (ia->ri_device->max_fast_reg_page_list_len =3D=3D 0)) {
> 			dprintk("RPC:       %s: FRMR registration "
> 				"not supported by HCA\n", __func__);
> 			memreg =3D RPCRDMA_MTHCAFMR;
> @@ -621,20 +613,19 @@ int
> rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
> 				struct rpcrdma_create_data_internal *cdata)
> {
> -	struct ib_device_attr *devattr =3D &ia->ri_devattr;
> 	struct ib_cq *sendcq, *recvcq;
> 	struct ib_cq_init_attr cq_attr =3D {};
> 	int rc, err;
>=20
> -	if (devattr->max_sge < RPCRDMA_MAX_IOVS) {
> +	if (ia->ri_device->max_sge < RPCRDMA_MAX_IOVS) {
> 		dprintk("RPC:       %s: insufficient sge's available\n",
> 			__func__);
> 		return -ENOMEM;
> 	}
>=20
> 	/* check provider's send/recv wr limits */
> -	if (cdata->max_requests > devattr->max_qp_wr)
> -		cdata->max_requests =3D devattr->max_qp_wr;
> +	if (cdata->max_requests > ia->ri_device->max_qp_wr)
> +		cdata->max_requests =3D ia->ri_device->max_qp_wr;
>=20
> 	ep->rep_attr.event_handler =3D rpcrdma_qp_async_error_upcall;
> 	ep->rep_attr.qp_context =3D ep;
> @@ -716,11 +707,11 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct=
 rpcrdma_ia *ia,
>=20
> 	/* Client offers RDMA Read but does not initiate */
> 	ep->rep_remote_cma.initiator_depth =3D 0;
> -	if (devattr->max_qp_rd_atom > 32)	/* arbitrary but <=3D 255 */
> +	if (ia->ri_device->max_qp_rd_atom > 32)	/* arbitrary but <=3D 255 *=
/
> 		ep->rep_remote_cma.responder_resources =3D 32;
> 	else
> 		ep->rep_remote_cma.responder_resources =3D
> -						devattr->max_qp_rd_atom;
> +						ia->ri_device->max_qp_rd_atom;
>=20
> 	ep->rep_remote_cma.retry_count =3D 7;
> 	ep->rep_remote_cma.flow_control =3D 0;
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xp=
rt_rdma.h
> index 34be575d..f612e1f 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -69,7 +69,6 @@ struct rpcrdma_ia {
> 	struct completion	ri_done;
> 	int			ri_async_rc;
> 	unsigned int		ri_max_frmr_depth;
> -	struct ib_device_attr	ri_devattr;
> 	struct ib_qp_attr	ri_qp_attr;
> 	struct ib_qp_init_attr	ri_qp_init_attr;
> };
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
