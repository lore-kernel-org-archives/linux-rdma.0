Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.26.1.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840372;
	b=Bw742empEpVeOjL54lMGb29GcJoxp7UCF1zqp5tnsvKETDM92yO0R1LeZVj7TW9B+pay
	 mSxlspYIsG2YNzbglJXGvMXtHPTd/nhutzFATbyat8dn3ePgSR0hKHWSfzAwS3DV3/D9J
	 Q6slchfhlBXUnGphWvPq9+wXXZFsj16zhkb8u1SokTT+751ZWIL+Ap0CgEEd/9wZ3KFyy
	 7wDh2LBR2KQzOxvGbD4Dps6Dfj34g0rhM7Dd/qgD8f609DQqIwyb+BlfKU0FG3J7SzjTq
	 ZO6Ah6hClOYO7L7Up7IKLpnUhafMjxFU6+4l64J8tNewGYr2q3gnYjDkftpxpKKzjIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840372;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=yHkU/eQpIOVvPRpdYHIs1A5fmsQJ9YRZiIDgCtzG1xw=;
	b=QuD30xZNVsfuwPUiypBzkQ6j/LnJmwEvC/2tXePCmfAjySpyUs2Zm4R6PaGuEbDy+b73
	 jrw2vTqZ0wGRYFGm1B2P5OIpqdA7/3U+gLobrfFMX1omqNFlcG3MlhhmdoQ37wjKwrtoa
	 oAMN33FH1+eTVhDNkNmqSluFlOGDw6Mzbo31Mile8lRZ3VX0Nd6/3Pvnd/eVGkJT+zh9+
	 THvLdwthPc52Tkx8IrxC3ssbJxwqR/nOfX5IEYYBf0FcWms8Pm+iqdHfRyHUo5WN8DsPm
	 /B48tNjuj4JKq+HN5YMSmUWyjw+HH7vitEdL2AOXOssdnvuRo7TsR03jqPkufGVt2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=P2K6C7gT;
	arc=none smtp.remote-ip=52.26.1.71
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208F606A323;
	Mon, 16 Nov 2026 14:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6208F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=P2K6C7gT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794840371; x=1826376371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yHkU/eQpIOVvPRpdYHIs1A5fmsQJ9YRZiIDgCtzG1xw=;
  b=P2K6C7gTIULpHHdmkhZm+WkaFxhfNQPFPFKO4owAmZ8G9Mfw6WJG4CMj
   7HCMgQ8Za7NbS2hTOoI4I3nVTxuxz4GyUcVgyFL2KSAwjoa45tsgABF33
   RWGtqdfyMJBLjHrXa9dlnir4eg6NXSvCgJu8BrhqD2hmvgoyR1A7DuVXy
   +/yhXeDEe/PdJHM61QYFrQ12GzOWFL8Zen1iSbJ/coYNj9nyT74gQCedN
   o6vGv7FtH1SZA/GWQIZGmn7ODqGE+h//1WCYtUug0TSGC73WtBBRgCZU+
   cV9Mwksj8oonQ+IJD4E9tsO4LtaYpft4XzQY8Dj+p7J+sk9++0niha+d6
   A==;
X-CSE-ConnectionGUID: 2cH/PtqIRtmWUmrJVwLHZQ==
X-CSE-MsgGUID: QV0kFlsaTu6zsTtgFhlWPw==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34304353"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:46:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:25363]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 1dbcb6d8-5057-4a32-a2e8-282f5c74fe93; Mon, 16 Nov 2026 14:46:08 +0000 (UTC)
X-Farcaster-Flow-ID: 1dbcb6d8-5057-4a32-a2e8-282f5c74fe93
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:46:08 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:46:07 +0000
Date: Mon, 16 Nov 2026 14:46:04 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 05/13] RDMA/core: extended address handle
 attributes
Message-ID: <20261116144604.GD34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-5-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-5-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:38PM -0800, Eric Davis wrote:
> An unconnected transport over UET resolves a peer by both its network
> address and its queue pair number. The write() create-AH command has no
> room for additional attributes. Add rdma_ah_attr_ex to carry new
> attributes, reach it through rdma_ah_init_attr, and add an ioctl method
> that supports it.
> 
> rdma_create_user_ah() now takes the init attributes rather than the
> address alone, so callers pass the wider set.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/user_mad.c         |  4 +-
>  drivers/infiniband/core/uverbs.h           |  3 ++
>  drivers/infiniband/core/uverbs_cmd.c       | 60 ++++++++++++++----------
>  drivers/infiniband/core/uverbs_std_types.c | 74 +++++++++++++++++++++++++++++-
>  drivers/infiniband/core/verbs.c            | 43 +++++++++--------
>  include/rdma/ib_verbs.h                    | 20 ++++++--
>  include/uapi/rdma/ib_user_ioctl_cmds.h     |  7 +++
>  include/uapi/rdma/ib_user_ioctl_verbs.h    |  9 ++++
>  8 files changed, 173 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
> index c3ef9f85c7eb..05e2898f0a6a 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -512,6 +512,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
>  	struct ib_umad_packet *packet;
>  	struct ib_mad_agent *agent;
>  	struct rdma_ah_attr ah_attr;
> +	struct rdma_ah_init_attr init_attr = {};
>  	struct ib_ah *ah;
>  	__be64 *tid;
>  	int ret, hdr_len, copy_offset, rmpp_active;
> @@ -569,7 +570,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
>  		rdma_ah_set_dgid_raw(&ah_attr, packet->mad.hdr.gid);
>  	}
>  
> -	ah = rdma_create_user_ah(agent->qp->pd, &ah_attr, NULL);
> +	init_attr.ah_attr = &ah_attr;
> +	ah = rdma_create_user_ah(agent->qp->pd, &init_attr, NULL);
>  	if (IS_ERR(ah)) {
>  		ret = PTR_ERR(ah);
>  		goto err_up;
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 728e09b41992..6aaac1c309f0 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -236,6 +236,9 @@ int ib_uverbs_dealloc_xrcd(struct ib_uobject *uobject, struct ib_xrcd *xrcd,
>  int uverbs_dealloc_mw(struct ib_mw *mw);
>  void ib_uverbs_detach_umcast(struct ib_qp *qp,
>  			     struct ib_uqp_object *uobj);
> +int copy_ah_attr_from_uverbs_ah(struct ib_device *dev,
> +				struct rdma_ah_attr *rdma_attr,
> +				const struct ib_uverbs_ah_attr *uverb_attr);
>  
>  struct bundle_alloc_head {
>  	struct_group_tagged(bundle_alloc_head_hdr, hdr,
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index e4fdfa0d9548..cca386b2c3f0 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1746,6 +1746,37 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
>  	}
>  }
>  
> +/* The ib_uverbs_ah_attr counterpart of copy_ah_attr_from_uverbs() below,
> + * which takes the modify QP layout. This one also rejects an invalid port.
> + */
> +int copy_ah_attr_from_uverbs_ah(struct ib_device *dev,
> +				struct rdma_ah_attr *rdma_attr,
> +				const struct ib_uverbs_ah_attr *uverb_attr)
> +{
> +	if (!rdma_is_port_valid(dev, uverb_attr->port_num))
> +		return -EINVAL;
> +
> +	rdma_attr->type = rdma_ah_find_type(dev, uverb_attr->port_num);
> +	rdma_ah_set_make_grd(rdma_attr, false);
> +	rdma_ah_set_dlid(rdma_attr, uverb_attr->dlid);
> +	rdma_ah_set_sl(rdma_attr, uverb_attr->sl);
> +	rdma_ah_set_path_bits(rdma_attr, uverb_attr->src_path_bits);
> +	rdma_ah_set_static_rate(rdma_attr, uverb_attr->static_rate);
> +	rdma_ah_set_port_num(rdma_attr, uverb_attr->port_num);
> +
> +	if (uverb_attr->is_global) {
> +		rdma_ah_set_grh(rdma_attr, NULL, uverb_attr->grh.flow_label,
> +				uverb_attr->grh.sgid_index,
> +				uverb_attr->grh.hop_limit,
> +				uverb_attr->grh.traffic_class);
> +		rdma_ah_set_dgid_raw(rdma_attr, uverb_attr->grh.dgid);
> +	} else {
> +		rdma_ah_set_ah_flags(rdma_attr, 0);
> +	}
> +
> +	return 0;
> +}
> +
>  static void copy_ah_attr_from_uverbs(struct ib_device *dev,
>  				     struct rdma_ah_attr *rdma_attr,
>  				     struct ib_uverbs_qp_dest *uverb_attr)
> @@ -2435,6 +2466,7 @@ static int ib_uverbs_create_ah(struct uverbs_attr_bundle *attrs)
>  	struct ib_pd			*pd;
>  	struct ib_ah			*ah;
>  	struct rdma_ah_attr		attr = {};
> +	struct rdma_ah_init_attr	init_attr = {};
>  	int ret;
>  	struct ib_device *ib_dev;
>  
> @@ -2446,36 +2478,18 @@ static int ib_uverbs_create_ah(struct uverbs_attr_bundle *attrs)
>  	if (IS_ERR(uobj))
>  		return PTR_ERR(uobj);
>  
> -	if (!rdma_is_port_valid(ib_dev, cmd.attr.port_num)) {
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
>  	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
>  	if (IS_ERR(pd)) {
>  		ret = PTR_ERR(pd);
>  		goto err;
>  	}
>  
> -	attr.type = rdma_ah_find_type(ib_dev, cmd.attr.port_num);
> -	rdma_ah_set_make_grd(&attr, false);
> -	rdma_ah_set_dlid(&attr, cmd.attr.dlid);
> -	rdma_ah_set_sl(&attr, cmd.attr.sl);
> -	rdma_ah_set_path_bits(&attr, cmd.attr.src_path_bits);
> -	rdma_ah_set_static_rate(&attr, cmd.attr.static_rate);
> -	rdma_ah_set_port_num(&attr, cmd.attr.port_num);
> -
> -	if (cmd.attr.is_global) {
> -		rdma_ah_set_grh(&attr, NULL, cmd.attr.grh.flow_label,
> -				cmd.attr.grh.sgid_index,
> -				cmd.attr.grh.hop_limit,
> -				cmd.attr.grh.traffic_class);
> -		rdma_ah_set_dgid_raw(&attr, cmd.attr.grh.dgid);
> -	} else {
> -		rdma_ah_set_ah_flags(&attr, 0);
> -	}
> +	ret = copy_ah_attr_from_uverbs_ah(ib_dev, &attr, &cmd.attr);
> +	if (ret)
> +		goto err_put;
>  
> -	ah = rdma_create_user_ah(pd, &attr, &attrs->driver_udata);
> +	init_attr.ah_attr = &attr;
> +	ah = rdma_create_user_ah(pd, &init_attr, &attrs->driver_udata);
>  	if (IS_ERR(ah)) {
>  		ret = PTR_ERR(ah);
>  		goto err_put;
> diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
> index e160786e1df1..856d85945393 100644
> --- a/drivers/infiniband/core/uverbs_std_types.c
> +++ b/drivers/infiniband/core/uverbs_std_types.c
> @@ -184,6 +184,77 @@ DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MW,
>  			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_mw),
>  			    &UVERBS_METHOD(UVERBS_METHOD_MW_DESTROY));
>  
> +/* Creating an address handle is still a write() command whose request
> + * struct cannot grow. A transport (reliable unconnected) that resolves a
> + * peer using both transport and network addresses requires additional
> + * fields in the address handle. Here the address handle create command is
> + * made available as an ioctl method, where additional attributes can be
> + * carried.
> + */
> +static int UVERBS_HANDLER(UVERBS_METHOD_AH_EX_CREATE)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> +		attrs, UVERBS_ATTR_CREATE_AH_EX_HANDLE);
> +	struct ib_pd *pd =
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE);
> +	struct ib_device *ib_dev = attrs->context->device;
> +	struct ib_uverbs_ah_attr_ex uah;
> +	struct rdma_ah_init_attr init_attr = {};
> +	struct rdma_ah_attr_ex attr = {};
> +	struct ib_ah *ah;
> +	int ret;
> +
> +	/* Only a reliable unconnected device has a use for the extended
> +	 * attributes.
> +	 */
> +	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_RU))
> +		return -EOPNOTSUPP;
> +
> +	ret = uverbs_copy_from_or_zero(&uah, attrs,
> +				       UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX);
> +	if (ret)
> +		return ret;
> +
> +	ret = copy_ah_attr_from_uverbs_ah(ib_dev, &attr.ah_attr, &uah.ah_attr);
> +	if (ret)
> +		return ret;
> +
> +	if (uah.remote_qpn & IB_UVERBS_QPN_UET_RESERVED_MASK)
> +		return -EINVAL;

This check seems to belong to the specific driver.

> +
> +	attr.remote_qpn = uah.remote_qpn;
> +
> +	init_attr.ah_attr = &attr.ah_attr;
> +	init_attr.ah_attr_ex = &attr;
> +
> +	ah = rdma_create_user_ah(pd, &init_attr, &attrs->driver_udata);
> +	if (IS_ERR(ah))
> +		return PTR_ERR(ah);
> +
> +	ah->uobject = uobj;
> +	uobj->object = ah;
> +	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_AH_EX_HANDLE);
> +
> +	return 0;
> +}
> +
> +DECLARE_UVERBS_NAMED_METHOD(
> +	UVERBS_METHOD_AH_EX_CREATE,

Since AH create has no ioctl method yet, would it work to add a general UVERBS_METHOD_AH_CREATE,
with the remote QPN as an optional attribute? That would work for any device, keep the QPN
optional, and leave room for other per-AH attributes without a new struct.

> +	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_HANDLE,
> +			UVERBS_OBJECT_AH,
> +			UVERBS_ACCESS_NEW,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE,
> +			UVERBS_OBJECT_PD,
> +			UVERBS_ACCESS_READ,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX,
> +			   UVERBS_ATTR_STRUCT(struct ib_uverbs_ah_attr_ex,
> +					      remote_qpn),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_UHW());
> +
>  DECLARE_UVERBS_NAMED_METHOD_DESTROY(
>  	UVERBS_METHOD_AH_DESTROY,
>  	UVERBS_ATTR_IDR(UVERBS_ATTR_DESTROY_AH_HANDLE,
> @@ -193,7 +264,8 @@ DECLARE_UVERBS_NAMED_METHOD_DESTROY(
>  
>  DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_AH,
>  			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_ah),
> -			    &UVERBS_METHOD(UVERBS_METHOD_AH_DESTROY));
> +			    &UVERBS_METHOD(UVERBS_METHOD_AH_DESTROY),
> +			    &UVERBS_METHOD(UVERBS_METHOD_AH_EX_CREATE));
>  
>  DECLARE_UVERBS_NAMED_METHOD_DESTROY(
>  	UVERBS_METHOD_FLOW_DESTROY,
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index ccdb08284432..7e3cfebebf75 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -561,24 +561,23 @@ rdma_update_sgid_attr(struct rdma_ah_attr *ah_attr,
>  }
>  
>  static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
> -				     struct rdma_ah_attr *ah_attr,
> -				     u32 flags,
> -				     struct ib_udata *udata,
> -				     struct net_device *xmit_slave)
> +				     struct rdma_ah_init_attr *init_attr,
> +				     struct ib_udata *udata)
>  {
> -	struct rdma_ah_init_attr init_attr = {};
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	struct ib_device *device = pd->device;
>  	struct ib_ah *ah;
>  	int ret;
>  
> -	might_sleep_if(flags & RDMA_CREATE_AH_SLEEPABLE);
> +	might_sleep_if(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE);
>  
>  	if (!udata && !device->ops.create_ah)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
>  	ah = rdma_zalloc_drv_obj_gfp(
>  		device, ib_ah,
> -		(flags & RDMA_CREATE_AH_SLEEPABLE) ? GFP_KERNEL : GFP_ATOMIC);
> +		(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE) ? GFP_KERNEL :
> +								GFP_ATOMIC);
>  	if (!ah)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -586,14 +585,12 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  	ah->pd = pd;
>  	ah->type = ah_attr->type;
>  	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
> -	init_attr.ah_attr = ah_attr;
> -	init_attr.flags = flags;
> -	init_attr.xmit_slave = xmit_slave;
>  
>  	if (udata)
> -		ret = device->ops.create_user_ah(ah, &init_attr, udata);
> +		ret = device->ops.create_user_ah(ah, init_attr, udata);
>  	else
> -		ret = device->ops.create_ah(ah, &init_attr, NULL);
> +		ret = device->ops.create_ah(ah, init_attr, NULL);
> +
>  	if (ret) {
>  		if (ah->sgid_attr)
>  			rdma_put_gid_attr(ah->sgid_attr);
> @@ -619,6 +616,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>  			     u32 flags)
>  {
> +	struct rdma_ah_init_attr init_attr = {};
>  	const struct ib_gid_attr *old_sgid_attr;
>  	struct net_device *slave;
>  	struct ib_ah *ah;
> @@ -634,7 +632,12 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>  		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
>  		return ERR_CAST(slave);
>  	}
> -	ah = _rdma_create_ah(pd, ah_attr, flags, NULL, slave);
> +
> +	init_attr.ah_attr = ah_attr;
> +	init_attr.flags = flags;
> +	init_attr.xmit_slave = slave;
> +
> +	ah = _rdma_create_ah(pd, &init_attr, NULL);
>  	rdma_lag_put_ah_roce_slave(slave);
>  	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
>  	return ah;
> @@ -646,18 +649,21 @@ EXPORT_SYMBOL(rdma_create_ah);
>   * given address vector.
>   * It resolves destination mac address for ah attribute of RoCE type.
>   * @pd: The protection domain associated with the address handle.
> - * @ah_attr: The attributes of the address vector.
> + * @init_attr: The address vector, and for an extended handle the
> + *             attributes beyond it.
>   * @udata: pointer to user's input output buffer information need by
>   *         provider driver.
>   *
> - * It returns 0 on success and returns appropriate error code on error.
>   * The address handle is used to reference a local or global destination
>   * in all UD QP post sends.
> + *
> + * Return: the address handle, or an ERR_PTR on error.
>   */
>  struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
> -				  struct rdma_ah_attr *ah_attr,
> +				  struct rdma_ah_init_attr *init_attr,
>  				  struct ib_udata *udata)
>  {
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	const struct ib_gid_attr *old_sgid_attr;
>  	struct ib_ah *ah;
>  	int err;
> @@ -674,8 +680,9 @@ struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
>  		}
>  	}
>  
> -	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE,
> -			     udata, NULL);
> +	init_attr->flags |= RDMA_CREATE_AH_SLEEPABLE;
> +
> +	ah = _rdma_create_ah(pd, init_attr, udata);
>  
>  out:
>  	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 8d74ed4fc581..68f7a271cf7a 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -974,10 +974,14 @@ struct ib_mr_status {
>   */
>  __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
>  
> +struct rdma_ah_attr_ex;
> +
>  struct rdma_ah_init_attr {
>  	struct rdma_ah_attr *ah_attr;
>  	u32 flags;
>  	struct net_device *xmit_slave;
> +	/* set to name a peer by both transport+network addresses */
> +	struct rdma_ah_attr_ex *ah_attr_ex;
>  };
>  
>  enum rdma_ah_attr_type {
> @@ -1016,6 +1020,11 @@ struct rdma_ah_attr {
>  	};
>  };
>  
> +struct rdma_ah_attr_ex {
> +	struct rdma_ah_attr	ah_attr;
> +	u32			remote_qpn;
> +};
> +
>  enum ib_wc_status {
>  	IB_WC_SUCCESS,
>  	IB_WC_LOC_LEN_ERR,
> @@ -3893,16 +3902,18 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>   * rdma_create_user_ah - Creates an address handle for the given address vector.
>   * It resolves destination mac address for ah attribute of RoCE type.
>   * @pd: The protection domain associated with the address handle.
> - * @ah_attr: The attributes of the address vector.
> + * @init_attr: The address vector, and for an extended handle the
> + *             attributes beyond it.
>   * @udata: pointer to user's input output buffer information need by
>   *         provider driver.
>   *
> - * It returns 0 on success and returns appropriate error code on error.
>   * The address handle is used to reference a local or global destination
>   * in all UD QP post sends.
> + *
> + * Return: the address handle, or an ERR_PTR on error.
>   */
>  struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
> -				  struct rdma_ah_attr *ah_attr,
> +				  struct rdma_ah_init_attr *init_attr,
>  				  struct ib_udata *udata);
>  /**
>   * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
> @@ -4981,7 +4992,8 @@ static inline struct ib_global_route
>  	return &attr->grh;
>  }
>  
> -static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr, void *dgid)
> +static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr,
> +					const void *dgid)
>  {
>  	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
>  
> diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
> index 816b3107464f..40fcd4bd1b5e 100644
> --- a/include/uapi/rdma/ib_user_ioctl_cmds.h
> +++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
> @@ -410,6 +410,13 @@ enum uverbs_attrs_xrcd_destroy_ids {
>  
>  enum uverbs_methods_ah {
>  	UVERBS_METHOD_AH_DESTROY,
> +	UVERBS_METHOD_AH_EX_CREATE,
> +};
> +
> +enum uverbs_attrs_create_ah_ex_cmd_attr_ids {
> +	UVERBS_ATTR_CREATE_AH_EX_HANDLE,
> +	UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE,
> +	UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX,
>  };
>  
>  enum uverbs_attrs_ah_destroy_ids {
> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
> index c568ed365c28..4975771290eb 100644
> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
> @@ -323,6 +323,15 @@ struct ib_uverbs_buffer_desc {
>  #define IB_UVERBS_QPN_UET_RESERVED_MASK		0x7f000000
>  #define IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT	0x80000000
>  
> +/* An address handle that names a peer using both transport+network addresses.
> + * Used for reliable unconnected QPs in both work request address handles and
> + * a Job address table.
> + */
> +struct ib_uverbs_ah_attr_ex {
> +	struct ib_uverbs_ah_attr ah_attr;
> +	__u32 remote_qpn;

With the remote QPN in the AH, a sender needs an AH per (address, QP) pair. That's N peers x M QPs
AH objects, each a syscall and a kernel object. On UD and SRD the AH is the address, and the QPN
and Q_Key go in the WR.

Is there something in UET that needs the QPN bound to the AH? Could the AH stay the network
address, with the QPN given per WR, and an AH-level QPN left optional for the address table?

Michael

> +};
> +
>  enum ib_uverbs_comp_cntr_entry {
>  	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
>  	IB_UVERBS_COMP_CNTR_ENTRY_ERR,
> 
> -- 
> 2.56.0
> 
