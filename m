Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840843;
	b=1QhZ9gBprVNHmYZc/fmIqBS17Af+EnOv7UMM5ZRd2iB1QSGabwvwlclD4nx9sBTaY7/E
	 1R/YwgR77toxs1W7xOLEx/D8ZmLbLSFh9YZvZrYt+kBnfSzPgVPfQRz57Bea0dUTpS219
	 fS/7IABjBnUJYeVj4/2p7CgrvVC6otb6lur8KXq9CAe021+BgEY/hSWLneW2bEYWkj93k
	 qr/ZpI1GJYOZSOpUrBOmUhoWL1O+VALOfMLhlv3WESNz3/Wrjcf6Vni3O09xR/FL5UeFc
	 4MFQLD3NjtIHtUI8LQD87+0qPA7H6jWBxcFRI1sOBj4XH26RH7ivBq5/slkH10xY4DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840843;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=0i/LOmrDHR/OReztfT6RwEjbP+gjJaT+0s9NKABX+2w=;
	b=tTK3queUTZ3SK+gnDtyv0X2ANqZEdvDtcq8F50Yrti4EOZ/Ijoqk7pN3P9kf4HUo8low
	 pppb7sRfLIDCjnGuaUWHMznCig8e/0uVyQyk5NcUxTJdqCtUBnd+AOFCVAAPYisl6df5o
	 dJZq0Z7cxW80We28KnDksLA8mmHF3nHap9hkZvcvhYgqbGdDw8Fw1f38J0mrG02kvVhoa
	 lK+FJzbS/B/YCggUj51ROyxMJsqtKw8l7+qUD0mEcEbu9gZaVnsXJl+BmJD51pBeCmV/K
	 LBDu0puiXatMaCoJRG9wPsAff3nY5g41GAELZagrGMplvZpLEAm6WeMC/ZL8xiRvPQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=do+7EKt1;
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D4D606A323;
	Mon, 16 Nov 2026 14:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7D4D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=do+7EKt1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794840842; x=1826376842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0i/LOmrDHR/OReztfT6RwEjbP+gjJaT+0s9NKABX+2w=;
  b=do+7EKt1pzITG7GRUF1YnEbKfwK+zgxGUzmKfrr1I99+TXbQyQZAtonM
   2ZIsIXbCXJmA3/3RiChkFecCwLOUhV9+T2bPWsfJ18UBKLevCMQ699cm7
   O4bmWYCwwiu/+RtKqXt8au7KosiXUOojYH+obpXcvIUJ5exRprQeCH4Vi
   IsJZyAEw2Yxmhvns1c8pkcq4ccUkd90Nv5Sg02Nxg9cu+MmQSojxRXtK/
   aidfZH98dGPsi+vV4G31qTOnv4pEcQdmdIOkY8uCyacCx+6OrgV91YuMF
   gCSEj/JiJNePqwi/ue+lc7HKibKgxQ/Dr1rgDSxyJuKMZAmS3ZDwtwjY5
   Q==;
X-CSE-ConnectionGUID: hlO2pxI6QniV7z+IZj5F7Q==
X-CSE-MsgGUID: StbdGpIxSIu+OMTztknlYg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34046061"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:54:02 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:6923]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 32000435-e3e7-4cf3-a0e9-0054f96fe4b3; Mon, 16 Nov 2026 14:54:01 +0000 (UTC)
X-Farcaster-Flow-ID: 32000435-e3e7-4cf3-a0e9-0054f96fe4b3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:54:01 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:54:00 +0000
Date: Mon, 16 Nov 2026 14:53:58 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 09/13] RDMA/core: create a queue pair ready
 to send
Message-ID: <20261116145357.GF34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-9-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-9-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:42PM -0800, Eric Davis wrote:
> Some transports have nothing to negotiate, so a queue pair can be ready
> to send the moment it exists and the modify sequence carries no useful
> information. Let a reliable unconnected queue pair be created with the
> attributes that sequence would have supplied, in the same form the
> modify command uses, and apply them as that modify to RTS once the
> queue pair exists, so its checks run. A queue pair whose modify fails
> is destroyed, and a later modify may change no more than those
> attributes.
> 
> Note that the QP handle field is refused, since the create is what makes
> the handle.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/uverbs.h              |  7 +++
>  drivers/infiniband/core/uverbs_cmd.c          |  6 +++
>  drivers/infiniband/core/uverbs_std_types_qp.c | 74 +++++++++++++++++++++++++++
>  drivers/infiniband/core/verbs.c               |  7 ++-
>  include/uapi/rdma/ib_user_ioctl_cmds.h        |  1 +
>  5 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 65a217bf65b5..59015a7a52f6 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -325,6 +325,13 @@ int ib_uverbs_copy_qp_attr(struct uverbs_attr_bundle *attrs,
>  			   const struct ib_uverbs_ex_modify_qp *src,
>  			   u32 mask);
>  
> +/* what a reliable unconnected QP is created ready to send with, and all a
> + * later modify may change
> + */
> +#define QP_ATTR_RU_MASK		(IB_QP_STATE | IB_QP_PKEY_INDEX |	\
> +				 IB_QP_PORT | IB_QP_ACCESS_FLAGS |	\
> +				 IB_QP_PATH_MTU)
> +

Since this gates both the create attributes and every later modify, another RU implementation
can't add an attribute it needs without changing core. Q_Key and RNR retry are examples for SRD.
Would it work to have the mask list everything that could make sense for RU, and let each driver
refuse what it doesn't support?

>  int ib_uverbs_kern_spec_to_ib_spec_filter(enum ib_flow_spec_type type,
>  					  const void *kern_spec_mask,
>  					  const void *kern_spec_val,
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 140f1cf91527..afe891e7b42d 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1913,6 +1913,12 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
>  		goto out;
>  	}
>  
> +	if (qp->qp_type == IB_QPT_RU &&
> +	    (cmd->base.attr_mask & ~QP_ATTR_RU_MASK)) {
> +		ret = -EINVAL;
> +		goto release_qp;
> +	}
> +
>  	if ((cmd->base.attr_mask & IB_QP_AV)) {
>  		if (cmd->base.attr_mask & IB_QP_STATE &&
>  		    cmd->base.qp_state == IB_QPS_RTR) {
> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
> index 30fc20fb251f..249206d2992f 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
> @@ -79,6 +79,55 @@ static void set_caps(struct ib_qp_init_attr *attr,
>  	}
>  }
>  
> +/* The attributes the QP would be modified with via modify_qp calls. Used for
> + * implementations that support having QPs be in RTS immediately after QP
> + * creation. These attributes arrive in the same format the modify command
> + * uses so that converter serves both, and they are applied as that modify
> + * to RTS, once the QP exists.
> + */
> +static int create_qp_attr_set(struct uverbs_attr_bundle *attrs,
> +			      struct ib_device *device,
> +			      struct ib_qp_init_attr *attr,
> +			      struct ib_qp_attr *qp_attr, u32 *mask)
> +{
> +	struct ib_uverbs_ex_modify_qp uqpa = {};
> +	int ret;
> +
> +	*mask = 0;
> +
> +	if (!uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_ATTR))
> +		return 0;
> +
> +	if (attr->qp_type != IB_QPT_RU)
> +		return -EOPNOTSUPP;

Could creating ready to send be driven by the attribute rather than the QP type, both in
create_qp_attr_set() and in the RTS step after create? UD and other connectionless QPs don't need
INIT/RTR to negotiate anything either. A driver that supports it for a type would accept it, and
others would refuse it.

Michael

> +
> +	ret = uverbs_copy_from_or_zero(&uqpa, attrs,
> +				       UVERBS_ATTR_CREATE_QP_ATTR);
> +	if (ret)
> +		return ret;
> +
> +	/* the create is what makes the handle, can't be one specified */
> +	if (uqpa.base.qp_handle)
> +		return -EINVAL;
> +
> +	if (uqpa.reserved || uqpa.base.reserved[0] || uqpa.base.reserved[1])
> +		return -EINVAL;
> +
> +	if ((uqpa.base.attr_mask & ~QP_ATTR_RU_MASK) ||
> +	    ((uqpa.base.attr_mask & IB_QP_STATE) &&
> +	     uqpa.base.qp_state != IB_QPS_RTS))
> +		return -EINVAL;
> +
> +	ret = ib_uverbs_copy_qp_attr(attrs, device, qp_attr, &uqpa,
> +				     uqpa.base.attr_mask);
> +	if (ret)
> +		return ret;
> +
> +	*mask = uqpa.base.attr_mask;
> +
> +	return 0;
> +}
> +
>  static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  	struct uverbs_attr_bundle *attrs)
>  {
> @@ -86,6 +135,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  		uverbs_attr_get_uobject(attrs, UVERBS_ATTR_CREATE_QP_HANDLE),
>  		typeof(*obj), uevent.uobject);
>  	struct ib_qp_init_attr attr = {};
> +	struct ib_qp_attr qp_attr = {};
> +	u32 qp_attr_mask;
>  	struct ib_uverbs_qp_cap cap = {};
>  	struct ib_rwq_ind_table *rwq_ind_tbl = NULL;
>  	struct ib_qp *qp;
> @@ -214,6 +265,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  		attr.create_flags |= IB_QP_CREATE_SOURCE_QPN;
>  	}
>  
> +	ret = create_qp_attr_set(attrs, device, &attr, &qp_attr,
> +				 &qp_attr_mask);
> +	if (ret)
> +		return ret;
> +
>  	srq = uverbs_attr_get_obj(attrs,
>  				  UVERBS_ATTR_CREATE_QP_SRQ_HANDLE);
>  	if (!IS_ERR(srq)) {
> @@ -264,6 +320,20 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  	obj->uevent.uobject.object = qp;
>  	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_QP_HANDLE);
>  
> +	/* A reliable unconnected QP is ready to send once created. What the
> +	 * caller passed is applied as the modify to RTS it stands in for, so
> +	 * the modify's checks run. A failure here destroys the QP.
> +	 */
> +	if (attr.qp_type == IB_QPT_RU) {
> +		qp_attr.qp_state = IB_QPS_RTS;
> +		/* the driver's data was for create, there is none for this */
> +		ret = ib_modify_qp_with_udata(qp, &qp_attr,
> +					      qp_attr_mask | IB_QP_STATE,
> +					      uverbs_get_cleared_udata(attrs));
> +		if (ret)
> +			return ret;
> +	}
> +
