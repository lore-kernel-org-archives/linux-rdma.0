Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840567;
	b=DfMjvnZ9z5+YJfvDLebtQa+6Au68X0xyTWRkewxlEEpKFuRyCSjbd71Bef3vclNxBqv/
	 lnbYMbXYL+KXuHb8kcpzVBJJBPu/7lO4XWKVua/SLzPsIuqIIwhajbx9OTgICgQGoFwsM
	 eBCJf01UDkoHO4uXNYDCVszV84//W//208gHYWrwD0ILG6V+SZnxhzGo6qXIdNdU8a8bl
	 aF7DqX54Czk2KGpNPqRVx/fXSs9Xd8AL9syDMS24OAnmbKr55t+SrJ3woUHeEeE5oC8Ym
	 jIxtCK6nJLg5YNA8fBCLrvQOzpU7IQuOs42K6MH5Yn6ERuLezcDKnlO/r9iHpN5NcGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840567;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=NXpgx+0i44M78UoKTUMCrjnivVPP6RYflxKJSh7MlM8=;
	b=CzRt8dRbTiLqE+cV0iqSivBizBhTCAokyfs6WhF5cZ/FVWFMiTwy8UNuonYrgqpo5k9h
	 qyAylcR0k2GucGAhOPek0HlJ4XwcpTbXT/os/VjUinIr589L7yo6TgSVpdZioprzO+Thl
	 OE88x/dnX45ESAwa+LK4QH2PNrXk5QLsEhGfo8nOTHm2nzx7mxa+EuAFW9u4fTO+IdfY+
	 UmPt0o+PHzavY3r94Vzc0ppt4+hXkwxzxD8kkNlljM9imxQYDTxzyNCF6CGLkiVQVZKLc
	 K0XKgizRB8NizVhIpvLeetX9+jnD3UK/fchShSe3BHDA6o5xyI08hBSK1R4UwLBDykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=MGkczmmh;
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A037606A31C;
	Mon, 16 Nov 2026 14:49:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A037606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=MGkczmmh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794840567; x=1826376567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NXpgx+0i44M78UoKTUMCrjnivVPP6RYflxKJSh7MlM8=;
  b=MGkczmmh5GszmJhXCdnYxxTrj9/dS2UAYeBbgJZJHM1BhPrbQf1q4UZl
   MdfryitN3D4uRdA9A8bnkkA2gdoI5T3X8QTRV2XD3pLInlO2s1r3zOrWy
   Xu5+65Z6PvmZRkjURiZAXOnUDNzf/V+LarETqErE7doI7LuEZSVEO4+l9
   WI75SF2W9pqpiH3XhJ4gNNgePSI2L72ln6KORqNL8lyxjMEQvdPAV//fV
   Y545pcDRpzUtXT+xBqfDvZCy34mae7w1BtzOROblId/EbfE6ZO/LPZoXe
   cNplH28x1jqwWVN/Lv+79MOfV1UDJP5rA0iYfJ/q/6X0yjWJa98xIwxNG
   A==;
X-CSE-ConnectionGUID: M3STGN+QSAi9SiATBRgxjg==
X-CSE-MsgGUID: AGu0K+1RT92bHetxeJ7ORw==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34045607"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:49:24 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:4750]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id c863a0ff-fd35-4842-871c-91283f3f0497; Mon, 16 Nov 2026 14:49:24 +0000 (UTC)
X-Farcaster-Flow-ID: c863a0ff-fd35-4842-871c-91283f3f0497
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:49:23 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:49:22 +0000
Date: Mon, 16 Nov 2026 14:49:20 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 06/13] RDMA/core: query the semantics a
 queue pair type guarantees
Message-ID: <20261116144920.GE34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-6-3e7e7ffed2e9@broadcom.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20261109-uet-ib-core-v3-6-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:39PM -0800, Eric Davis wrote:
> An unconnected transport orders far less than a connected one, and how
> much varies by device. Add a device method that reports, for a queue pair
> type, which operations it orders against which and up to what size the
> data stays in that order, the largest packet it puts on the wire, how
> wide an immediate it carries, and whether that immediate consumes a
> posted receive.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/device.c                  |  1 +
>  drivers/infiniband/core/uverbs.h                  | 13 ++++
>  drivers/infiniband/core/uverbs_std_types_device.c | 90 ++++++++++++++++++++++-
>  include/rdma/ib_verbs.h                           | 15 ++++
>  include/uapi/rdma/ib_user_ioctl_cmds.h            |  6 ++
>  include/uapi/rdma/ib_user_ioctl_verbs.h           | 65 ++++++++++++++++
>  6 files changed, 189 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 7c65a9373701..8b1563de4726 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -3011,6 +3011,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
>  	SET_DEVICE_OP(dev_ops, query_port);
>  	SET_DEVICE_OP(dev_ops, query_port_speed);
>  	SET_DEVICE_OP(dev_ops, query_qp);
> +	SET_DEVICE_OP(dev_ops, query_qp_semantics);
>  	SET_DEVICE_OP(dev_ops, query_srq);
>  	SET_DEVICE_OP(dev_ops, query_ucontext);
>  	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 6aaac1c309f0..2160985f18e9 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -407,5 +407,18 @@ static inline void ib_uverbs_comp_dev(struct ib_uverbs_device *dev)
>  	complete(&dev->comp);
>  }
>  
> +/* the semantics fields, ordering bits and usage flags uverbs knows of */
> +#define QP_SEMANTICS_MASK_ALL	((IB_UVERBS_QP_SEMANTICS_MASK_USAGE << 1) - 1)
> +#define QP_ORDER_ALL		((IB_UVERBS_QP_ORDER_WAW << 1) - 1)
> +#define QP_USAGE_ALL		IB_UVERBS_QP_USAGE_IMM_DATA_RQ
> +
> +/* the ordering bits each data-ordering size limits */
> +#define QP_ORDER_RAW_SIZED	(IB_UVERBS_QP_ORDER_RDMA_RAW |	\
> +				 IB_UVERBS_QP_ORDER_RAW)
> +#define QP_ORDER_WAR_SIZED	(IB_UVERBS_QP_ORDER_RDMA_WAR |	\
> +				 IB_UVERBS_QP_ORDER_WAR)
> +#define QP_ORDER_WAW_SIZED	(IB_UVERBS_QP_ORDER_RDMA_WAW |	\
> +				 IB_UVERBS_QP_ORDER_WAW)
> +
>  
>  #endif /* UVERBS_H */
> diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
> index db65032e80b4..4fed4e79a3d2 100644
> --- a/drivers/infiniband/core/uverbs_std_types_device.c
> +++ b/drivers/infiniband/core/uverbs_std_types_device.c
> @@ -591,6 +591,93 @@ DECLARE_UVERBS_NAMED_METHOD(
>  			    UVERBS_ATTR_TYPE(u32),
>  			    UA_OPTIONAL));
>  
> +/* What a QP type guarantees on this device. Which operations it orders
> + * against, how large a packet it puts on the wire, how wide an immediate it
> + * carries.
> + */
> +static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_QP_SEMANTICS)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uverbs_qp_semantics resp = {};
> +	struct ib_qp_semantics sem = {};
> +	struct ib_ucontext *ucontext;
> +	struct ib_device *ib_dev;
> +	enum ib_qp_type qp_type;
> +	int ret;
> +
> +	ucontext = ib_uverbs_get_ucontext(attrs);
> +	if (IS_ERR(ucontext))
> +		return PTR_ERR(ucontext);
> +	ib_dev = ucontext->device;
> +
> +	if (!ib_dev->ops.query_qp_semantics)
> +		return -EOPNOTSUPP;
> +
> +	ret = uverbs_get_const(&qp_type, attrs,
> +			       UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE);
> +	if (ret)
> +		return ret;
> +
> +	/* only the types userspace can create, less the driver type, whose
> +	 * subtypes one answer can't describe
> +	 */
> +	switch (qp_type) {
> +	case IB_UVERBS_QPT_RC:
> +	case IB_UVERBS_QPT_UC:
> +	case IB_UVERBS_QPT_UD:
> +	case IB_UVERBS_QPT_RAW_PACKET:
> +	case IB_UVERBS_QPT_XRC_INI:
> +	case IB_UVERBS_QPT_XRC_TGT:
> +	case IB_UVERBS_QPT_RU:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = ib_dev->ops.query_qp_semantics(ib_dev, qp_type, &sem);
> +	if (ret)
> +		return ret;
> +
> +	/* only the fields, bits and flags uverbs knows of reach userspace */
> +	resp.comp_mask = sem.comp_mask & QP_SEMANTICS_MASK_ALL;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER)
> +		resp.msg_order = sem.msg_order & QP_ORDER_ALL;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_RAW)
> +		resp.max_rdma_raw_size = sem.max_rdma_raw_size;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_WAR)
> +		resp.max_rdma_war_size = sem.max_rdma_war_size;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_WAW)
> +		resp.max_rdma_waw_size = sem.max_rdma_waw_size;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_PDU)
> +		resp.max_pdu = sem.max_pdu;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_USAGE)
> +		resp.usage_flags = sem.usage_flags & QP_USAGE_ALL;
> +	if (resp.comp_mask & IB_UVERBS_QP_SEMANTICS_MASK_IMM)
> +		resp.imm_data_size = sem.imm_data_size;
> +
> +	/* a pair whose data-ordering size is 0 is not ordered */
> +	if (!resp.max_rdma_raw_size)
> +		resp.msg_order &= ~QP_ORDER_RAW_SIZED;
> +	if (!resp.max_rdma_war_size)
> +		resp.msg_order &= ~QP_ORDER_WAR_SIZED;
> +	if (!resp.max_rdma_waw_size)
> +		resp.msg_order &= ~QP_ORDER_WAW_SIZED;
> +
> +	return uverbs_copy_to_struct_or_zero(
> +		attrs, UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP, &resp,
> +		sizeof(resp));
> +}
> +
> +DECLARE_UVERBS_NAMED_METHOD(
> +	UVERBS_METHOD_QUERY_QP_SEMANTICS,
> +	UVERBS_ATTR_CONST_IN(UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE,
> +			     enum ib_uverbs_qp_type,
> +			     UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP,
> +			    UVERBS_ATTR_STRUCT(struct ib_uverbs_qp_semantics,
> +					       imm_data_size),
> +			    UA_MANDATORY));
> +
>  DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
>  			      &UVERBS_METHOD(UVERBS_METHOD_GET_CONTEXT),
>  			      &UVERBS_METHOD(UVERBS_METHOD_INVOKE_WRITE),
> @@ -600,7 +687,8 @@ DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
>  			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_CONTEXT),
>  			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_TABLE),
>  			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_ENTRY),
> -			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS));
> +			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS),
> +			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_QP_SEMANTICS));
>  
>  const struct uapi_definition uverbs_def_obj_device[] = {
>  	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_DEVICE),
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 68f7a271cf7a..003b70424429 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2496,6 +2496,18 @@ struct ib_counters {
>  	atomic_t	usecnt;
>  };
>  
> +/* what a queue pair of a given type guarantees (query_qp_semantics) */
> +struct ib_qp_semantics {
> +	u32	comp_mask;		/* enum ib_uverbs_qp_semantics_mask */
> +	u32	msg_order;		/* enum ib_uverbs_qp_msg_order */
> +	u32	max_rdma_raw_size;
> +	u32	max_rdma_war_size;
> +	u32	max_rdma_waw_size;
> +	u32	max_pdu;
> +	u32	usage_flags;		/* enum ib_uverbs_qp_usage_flags */
> +	u8	imm_data_size;		/* bits */
> +};
> +
>  struct ib_counters_read_attr {
>  	u64	*counters_buff;
>  	u32	ncounters;
> @@ -2751,6 +2763,9 @@ struct ib_device_ops {
>  				       int mr_access_flags, struct ib_pd *pd,
>  				       struct ib_udata *udata);
>  	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
> +	int (*query_qp_semantics)(struct ib_device *device,
> +				  enum ib_qp_type qp_type,
> +				  struct ib_qp_semantics *sem);
>  	struct ib_mr *(*alloc_mr)(struct ib_pd *pd, enum ib_mr_type mr_type,
>  				  u32 max_num_sg);
>  	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
> diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
> index 40fcd4bd1b5e..fb746257eb2c 100644
> --- a/include/uapi/rdma/ib_user_ioctl_cmds.h
> +++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
> @@ -77,6 +77,12 @@ enum uverbs_methods_device {
>  	UVERBS_METHOD_QUERY_GID_ENTRY,
>  	UVERBS_METHOD_QUERY_PORT_SPEED,
>  	UVERBS_METHOD_QUERY_COMP_CNTR_CAPS,
> +	UVERBS_METHOD_QUERY_QP_SEMANTICS,
> +};
> +
> +enum uverbs_attrs_query_qp_semantics_attr_ids {
> +	UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE,
> +	UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP,
>  };
>  
>  enum uverbs_attrs_invoke_write_cmd_attr_ids {
> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
> index 4975771290eb..9ae45f7d3dc0 100644
> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
> @@ -323,6 +323,52 @@ struct ib_uverbs_buffer_desc {
>  #define IB_UVERBS_QPN_UET_RESERVED_MASK		0x7f000000
>  #define IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT	0x80000000
>  
> +enum ib_uverbs_qp_semantics_mask {
> +	IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER	= 1 << 0,
> +	IB_UVERBS_QP_SEMANTICS_MASK_RAW		= 1 << 1,
> +	IB_UVERBS_QP_SEMANTICS_MASK_WAR		= 1 << 2,
> +	IB_UVERBS_QP_SEMANTICS_MASK_WAW		= 1 << 3,
> +	IB_UVERBS_QP_SEMANTICS_MASK_PDU		= 1 << 4,
> +	IB_UVERBS_QP_SEMANTICS_MASK_IMM		= 1 << 5,
> +	IB_UVERBS_QP_SEMANTICS_MASK_USAGE	= 1 << 6,
> +};
> +
> +/* Ordering guarantees between operations on one QP. "X after Y" means an
> + * X may not pass a Y posted before it. A bit that is clear means the pair
> + * does not order that combination, and an application that needs it must
> + * wait for the earlier completion.
> + */

These bits describe ordering at the target. Is completion order meant to be covered too? It can
differ from placement order, and it can differ between the send queue (completions vs post order)
and the receive queue (receive completions vs the sender's order). Would it make sense to report
those separately, so an app knows whether it can rely on in-order send completions, for example
for selective signaling?

> +enum ib_uverbs_qp_msg_order {
> +	/* atomic after atomic */
> +	IB_UVERBS_QP_ORDER_ATOMIC_RAR	= 1 << 0,
> +	IB_UVERBS_QP_ORDER_ATOMIC_RAW	= 1 << 1,
> +	IB_UVERBS_QP_ORDER_ATOMIC_WAR	= 1 << 2,
> +	IB_UVERBS_QP_ORDER_ATOMIC_WAW	= 1 << 3,
> +	/* rma after rma */
> +	IB_UVERBS_QP_ORDER_RDMA_RAR	= 1 << 4,
> +	IB_UVERBS_QP_ORDER_RDMA_RAW	= 1 << 5,
> +	IB_UVERBS_QP_ORDER_RDMA_WAR	= 1 << 6,
> +	IB_UVERBS_QP_ORDER_RDMA_WAW	= 1 << 7,
> +	/* send against send, rma and atomic */
> +	IB_UVERBS_QP_ORDER_RAS		= 1 << 8,
> +	IB_UVERBS_QP_ORDER_SAR		= 1 << 9,
> +	IB_UVERBS_QP_ORDER_SAS		= 1 << 10,
> +	IB_UVERBS_QP_ORDER_SAW		= 1 << 11,
> +	IB_UVERBS_QP_ORDER_WAS		= 1 << 12,
> +	/* rma or atomic against rma or atomic, in any mix, so each also
> +	 * covers its RDMA_ and ATOMIC_ bit
> +	 */
> +	IB_UVERBS_QP_ORDER_RAR		= 1 << 13,
> +	IB_UVERBS_QP_ORDER_RAW		= 1 << 14,
> +	IB_UVERBS_QP_ORDER_WAR		= 1 << 15,
> +	IB_UVERBS_QP_ORDER_WAW		= 1 << 16,
> +};
> +
> +enum ib_uverbs_qp_usage_flags {
> +	/* immediate data consumes a posted receive */
> +	IB_UVERBS_QP_USAGE_IMM_DATA_RQ	= 1 << 0,

Some devices can do either per QP: an RDMA write with immediate either consumes a posted receive or
completes without one. With the subset check in 10, how would such a device advertise both, and how
would an app ask for the mode that doesn't consume a receive? It seems more like a mode the QP is
created with than a guarantee to relax. Would a separate create-time choice fit better, with the
device reporting which modes it supports?

Michael

> +};
> +
>  /* An address handle that names a peer using both transport+network addresses.
>   * Used for reliable unconnected QPs in both work request address handles and
>   * a Job address table.
> @@ -332,6 +378,25 @@ struct ib_uverbs_ah_attr_ex {
>  	__u32 remote_qpn;
>  };
>  
> +struct ib_uverbs_qp_semantics {
> +	__u32 comp_mask;		/* enum ib_uverbs_qp_semantics_mask */
> +	__u32 msg_order;		/* enum ib_uverbs_qp_msg_order */
> +	/*
> +	 * Data ordering: the largest transfer, in bytes, for which the target
> +	 * memory reflects the order of the pair under its RDMA_ and plain
> +	 * msg_order bits. 0 if not provided, and those bits are then clear.
> +	 * The sizes don't limit the ATOMIC_ bits. There is no read-after-read
> +	 * size, as two reads leave memory unchanged.
> +	 */
> +	__u32 max_rdma_raw_size;	/* read after write */
> +	__u32 max_rdma_war_size;	/* write after read */
> +	__u32 max_rdma_waw_size;	/* write after write */
> +	__u32 max_pdu;			/* largest packet, bytes */
> +	__u32 usage_flags;		/* enum ib_uverbs_qp_usage_flags */
> +	__u8  imm_data_size;		/* widest immediate, in bits */
> +	__u8  reserved[3];
> +};
> +
>  enum ib_uverbs_comp_cntr_entry {
>  	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
>  	IB_UVERBS_COMP_CNTR_ENTRY_ERR,
> 
> -- 
> 2.56.0
> 
