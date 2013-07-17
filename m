From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Wed, 17 Jul 2013 23:31:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805B9484@ORSMSX109.amr.corp.intel.com>
References: <1372873336-13694-1-git-send-email-ogerlitz@mellanox.com>
 <1372873336-13694-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372873336-13694-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
> +			      const char __user *buf, int in_len,
> +			      int out_len)
> +{
> +	struct ib_uverbs_create_flow	  cmd;
> +	struct ib_uverbs_create_flow_resp resp;
> +	struct ib_uobject		  *uobj;
> +	struct ib_flow			  *flow_id;
> +	struct ib_kern_flow_attr	  *kern_flow_attr;
> +	struct ib_flow_attr		  *flow_attr;
> +	struct ib_qp			  *qp;
> +	int err = 0;
> +	void *kern_spec;
> +	void *ib_spec;
> +	int i;
> +
> +	if (out_len < sizeof(resp))
> +		return -ENOSPC;
> +
> +	if (copy_from_user(&cmd, buf, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
> +	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
> +		return -EPERM;
> +
> +	if (cmd.flow_attr.num_of_specs) {
> +		kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
> +		if (!kern_flow_attr)
> +			return -ENOMEM;
> +
> +		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
> +		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
> +				   cmd.flow_attr.size - sizeof(cmd))) {
> +			err = -EFAULT;
> +			goto err_free_attr;
> +		}
> +	} else {
> +		kern_flow_attr = &cmd.flow_attr;
> +	}
> +
> +	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
> +	if (!uobj) {
> +		err = -ENOMEM;
> +		goto err_free_attr;
> +	}
> +	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
> +	down_write(&uobj->mutex);
> +
> +	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
> +	if (!qp) {
> +		err = -EINVAL;
> +		goto err_uobj;
> +	}
> +
> +	flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
> +	if (!flow_attr) {
> +		err = -ENOMEM;
> +		goto err_put;
> +	}
> +
> +	flow_attr->type = kern_flow_attr->type;
> +	flow_attr->priority = kern_flow_attr->priority;
> +	flow_attr->num_of_specs = kern_flow_attr->num_of_specs;
> +	flow_attr->port = kern_flow_attr->port;
> +	flow_attr->flags = kern_flow_attr->flags;
> +	flow_attr->size = sizeof(*flow_attr);
> +
> +	kern_spec = kern_flow_attr + 1;
> +	ib_spec = flow_attr + 1;
> +	for (i = 0; i < flow_attr->num_of_specs; i++) {
> +		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
> +		if (err)
> +			goto err_free;
> +		flow_attr->size +=
> +			((struct _ib_flow_spec *)ib_spec)->size;
> +		kern_spec += ((struct ib_kern_spec *)kern_spec)->size;
> +		ib_spec += ((struct _ib_flow_spec *)ib_spec)->size;

I didn't see where the ib_kern_spec size field was validated.  Maybe add this check to kern_spec_to_ib_spec?

> +	}
> +	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
> +	if (IS_ERR(flow_id)) {
> +		err = PTR_ERR(flow_id);
> +		goto err_free;
> +	}
> +	flow_id->qp = qp;
> +	flow_id->uobject = uobj;
> +	uobj->object = flow_id;
> +
> +	err = idr_add_uobj(&ib_uverbs_rule_idr, uobj);
> +	if (err)
> +		goto destroy_flow;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	resp.flow_handle = uobj->id;
> +
> +	if (copy_to_user((void __user *)(unsigned long) cmd.response,
> +			 &resp, sizeof(resp))) {
> +		err = -EFAULT;
> +		goto err_copy;
> +	}
> +
> +	put_qp_read(qp);
> +	mutex_lock(&file->mutex);
> +	list_add_tail(&uobj->list, &file->ucontext->rule_list);
> +	mutex_unlock(&file->mutex);
> +
> +	uobj->live = 1;
> +
> +	up_write(&uobj->mutex);
> +	kfree(flow_attr);
> +	if (cmd.flow_attr.num_of_specs)
> +		kfree(kern_flow_attr);
> +	return in_len;
> +err_copy:
> +	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
> +destroy_flow:
> +	ib_destroy_flow(flow_id);
> +err_free:
> +	kfree(flow_attr);
> +err_put:
> +	put_qp_read(qp);
> +err_uobj:
> +	put_uobj_write(uobj);
> +err_free_attr:
> +	if (cmd.flow_attr.num_of_specs)
> +		kfree(kern_flow_attr);
> +	return err;
> +}
> +
> +ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
> +			       const char __user *buf, int in_len,
> +			       int out_len) {
> +	struct ib_uverbs_destroy_flow	cmd;
> +	struct ib_flow			*flow_id;
> +	struct ib_uobject		*uobj;
> +	int				ret;
> +
> +	if (copy_from_user(&cmd, buf, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
> +			      file->ucontext);
> +	if (!uobj)
> +		return -EINVAL;
> +	flow_id = uobj->object;
> +
> +	ret = ib_destroy_flow(flow_id);
> +	if (!ret)
> +		uobj->live = 0;
> +
> +	put_uobj_write(uobj);
> +
> +	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
> +
> +	mutex_lock(&file->mutex);
> +	list_del(&uobj->list);
> +	mutex_unlock(&file->mutex);
> +
> +	put_uobj(uobj);
> +
> +	return ret ? ret : in_len;
> +}
> +
>  static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
>  				struct ib_uverbs_create_xsrq *cmd,
>  				struct ib_udata *udata)
> diff --git a/drivers/infiniband/core/uverbs_main.c
> b/drivers/infiniband/core/uverbs_main.c
> index e4e7b24..75ad86c 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -73,6 +73,7 @@ DEFINE_IDR(ib_uverbs_cq_idr);
>  DEFINE_IDR(ib_uverbs_qp_idr);
>  DEFINE_IDR(ib_uverbs_srq_idr);
>  DEFINE_IDR(ib_uverbs_xrcd_idr);
> +DEFINE_IDR(ib_uverbs_rule_idr);
> 
>  static DEFINE_SPINLOCK(map_lock);
>  static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
> @@ -113,7 +114,9 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file
> *file,
>  	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
>  	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
>  	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
> -	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp
> +	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
> +	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
> +	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
>  };
> 
>  static void ib_uverbs_add_one(struct ib_device *device);
> @@ -212,6 +215,14 @@ static int ib_uverbs_cleanup_ucontext(struct
> ib_uverbs_file *file,
>  		kfree(uobj);
>  	}
> 
> +	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
> +		struct ib_flow *flow_id = uobj->object;
> +
> +		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
> +		ib_destroy_flow(flow_id);
> +		kfree(uobj);
> +	}
> +
>  	list_for_each_entry_safe(uobj, tmp, &context->qp_list, list) {
>  		struct ib_qp *qp = uobj->object;
>  		struct ib_uqp_object *uqp =
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 1390a0f..4fe1f1c 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -923,6 +923,7 @@ struct ib_ucontext {
>  	struct list_head	srq_list;
>  	struct list_head	ah_list;
>  	struct list_head	xrcd_list;
> +	struct list_head	rule_list;
>  	int			closing;
>  };
> 
> diff --git a/include/uapi/rdma/ib_user_verbs.h
> b/include/uapi/rdma/ib_user_verbs.h
> index 61535aa..8c67534 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -86,7 +86,9 @@ enum {
>  	IB_USER_VERBS_CMD_OPEN_XRCD,
>  	IB_USER_VERBS_CMD_CLOSE_XRCD,
>  	IB_USER_VERBS_CMD_CREATE_XSRQ,
> -	IB_USER_VERBS_CMD_OPEN_QP
> +	IB_USER_VERBS_CMD_OPEN_QP,
> +	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
> +	IB_USER_VERBS_CMD_DESTROY_FLOW
>  };
> 
>  /*
> @@ -694,6 +696,90 @@ struct ib_uverbs_detach_mcast {
>  	__u64 driver_data[0];
>  };
> 
> +struct ib_kern_eth_filter {
> +	__u8  dst_mac[6];
> +	__u8  src_mac[6];
> +	__be16 ether_type;
> +	__be16 vlan_tag;
> +};
> +
> +struct ib_kern_spec_eth {
> +	__u32  type;
> +	__u16  size;
> +	__u16  reserved;
> +	struct ib_kern_eth_filter val;
> +	struct ib_kern_eth_filter mask;
> +};
> +
> +struct ib_kern_ipv4_filter {
> +	__be32 src_ip;
> +	__be32 dst_ip;
> +};
> +
> +struct ib_kern_spec_ipv4 {
> +	__u32  type;
> +	__u16  size;
> +	__u16  reserved;
> +	struct ib_kern_ipv4_filter val;
> +	struct ib_kern_ipv4_filter mask;
> +};
> +
> +struct ib_kern_tcp_udp_filter {
> +	__be16 dst_port;
> +	__be16 src_port;
> +};
> +
> +struct ib_kern_spec_tcp_udp {
> +	__u32  type;
> +	__u16  size;
> +	__u16  reserved;
> +	struct ib_kern_tcp_udp_filter val;
> +	struct ib_kern_tcp_udp_filter mask;
> +};
> +
> +struct ib_kern_spec {
> +	union {
> +		struct {
> +			__u32 type;
> +			__u16 size;
> +		};
> +		struct ib_kern_spec_eth	    eth;
> +		struct ib_kern_spec_ipv4    ipv4;
> +		struct ib_kern_spec_tcp_udp tcp_udp;
> +	};
> +};
> +
> +struct ib_kern_flow_attr {
> +	__u32 type;
> +	__u16 size;
> +	__u16 priority;
> +	__u8  num_of_specs;
> +	__u8  reserved[2];
> +	__u8  port;
> +	__u32 flags;
> +	/* Following are the optional layers according to user request
> +	 * struct ib_flow_spec_xxx
> +	 * struct ib_flow_spec_yyy
> +	 */
> +};
> +
> +struct ib_uverbs_create_flow  {
> +	__u32 comp_mask;
> +	__u64 response;
> +	__u32 qp_handle;
> +	struct ib_kern_flow_attr flow_attr;
> +};
> +
> +struct ib_uverbs_create_flow_resp {
> +	__u32 comp_mask;
> +	__u32 flow_handle;
> +};
> +
> +struct ib_uverbs_destroy_flow  {
> +	__u32 comp_mask;
> +	__u32 flow_handle;
> +};

The ib_uvers structures contain a comp_mask field, but I didn't see that those were used.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
