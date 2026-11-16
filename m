Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.42.203.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840878;
	b=x1r4ZSNMThwXAiP+A8I5iw5Ku7OmNE7+0yfoKadXZAK/w4FCRsMPnD3vXrCNdZhv/2O1
	 gAuGLAFb/M9Wpnf+Zokj87lFIcWZvG5/UOqrM8LFzaIU7QcC9DgqucbJdM0ZYOMbBGT5E
	 982Uc4A9cn9XFjiKkszg4qz6biMCOqIJM7jHsqQawo9f8fscuD2ruPm9oLdZCrpb7RP7t
	 RikycW0/7BGgWyo0TdQe8SKeqOFfq7dJH+WKUq7rOH/uFSUPCJ7IgNqT8SRuREAlujG7L
	 RCM13vJqpBE8P/3yZoG75hKJG8yIL6KrzJkdMr62OKB9KbKP7QT/O6UDFKXBaX1xMsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840878;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=auZ3WSZmLvNGwzRGkLwD/FBsz8vvBa+KRvSTI3YBtpk=;
	b=LLJsTBQZzQ2IdtpoxToALWoAWp3Yp96t3RChIpUdpD/2dzdELtPMK354kRnWRJ6jIp3Y
	 3O1oELCp1jbZL8RVKjx2fsuWUz2jBN1zE6NLhs4Eex9fCAO3gNCPZvCIZKgqwfi4G8QKI
	 KySgzxlcZ49NEniYVNDye7oF2uAIl0GGzPEcgeaghFwART9wvsO+xOoKwK1/pHG3oJ8Vq
	 Mh4z6StUv04UwMzXSrplub/4m1aC66AW76GsuNCF2nzDO50Pl17r3tCILzJPhTCCpKyV8
	 9nWurgJwQfH7b22t0dt+9uHfSx4pjafkB1P0NOrwmj7+/jyGm187+vy0on6UH1oHLyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=e7R11ZZu;
	arc=none smtp.remote-ip=52.42.203.116
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51F6606A31C;
	Mon, 16 Nov 2026 14:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C51F6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=e7R11ZZu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794840877; x=1826376877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=auZ3WSZmLvNGwzRGkLwD/FBsz8vvBa+KRvSTI3YBtpk=;
  b=e7R11ZZuxFDnoq5G4FdSustmkiX8JJegJzjttjiLLjIf+yiY+G5EjzcF
   ELZUrXkq4Xug7J139mUXeaVrEELJboloW8BUi1NhS0rvWIUiYzEpj/HOf
   oC3XdHTgqY9J2LT6d94zjRSIeXZ6lUisuJcFBNt07JTJlUGKFWO9VCxcS
   Ah+Ry5QD5TXaYUKOLsiF1/OPht2lGJxuui8DtrFzC3J/1IH26B+O0tiFb
   S+ik0s9amyTZnrrwIgGykZMmXEOh58g7b1NyLMLd/oI62WDFkQYGogukN
   tYZocHL3+9+onLJJeEmoSFIi837nS06L68ov2PWRVlFdx8jWcECGGmr53
   g==;
X-CSE-ConnectionGUID: J+MpmXVfRlSiXlmjMvijXw==
X-CSE-MsgGUID: GSFQsYqwRV+5sHLSBFfhvg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34275785"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:54:35 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:15840]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id db228072-0798-47c3-8a2a-10656e373401; Mon, 16 Nov 2026 14:54:34 +0000 (UTC)
X-Farcaster-Flow-ID: db228072-0798-47c3-8a2a-10656e373401
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:54:34 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:54:33 +0000
Date: Mon, 16 Nov 2026 14:54:31 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 10/13] RDMA/core: queue pair attributes for
 unconnected transports
Message-ID: <20261116145431.GG34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:43PM -0800, Eric Davis wrote:
> A queue pair on an unconnected transport is created with more than the
> connected attributes. A job key authorizing it to act within a job, the
> initiator identity it sends under, and the ordering guarantees the caller
> wants it to keep.
> 
> The QP holds a reference to its job key for as long as it lives, so the
> job cannot go away underneath it.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/uverbs_std_types_qp.c | 173 ++++++++++++++++++++++++++
>  drivers/infiniband/core/verbs.c               |   5 +
>  include/rdma/ib_verbs.h                       |  14 +++
>  include/uapi/rdma/ib_user_ioctl_cmds.h        |   3 +
>  4 files changed, 195 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
> index 249206d2992f..a1112083fb73 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
> @@ -79,6 +79,157 @@ static void set_caps(struct ib_qp_init_attr *attr,
>  	}
>  }
>  
> +/* A QP may relax what its type guarantees on this device, but not ask for
> + * more than the device advertises for it.
> + */
> +static int create_qp_semantics_check(struct ib_device *device,
> +				     const struct ib_qp_semantics *req)
> +{
> +	struct ib_qp_semantics adv = {};
> +	u32 m = req->comp_mask;
> +	int ret;
> +
> +	if (!device->ops.query_qp_semantics)
> +		return -EOPNOTSUPP;
> +
> +	ret = device->ops.query_qp_semantics(device, IB_QPT_RU, &adv);
> +	if (ret)
> +		return ret;
> +
> +	if (m & ~adv.comp_mask)
> +		return -EINVAL;
> +
> +	if (((m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER) &&
> +	     (req->msg_order & ~adv.msg_order)) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_RAW) &&
> +	     req->max_rdma_raw_size > adv.max_rdma_raw_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAR) &&
> +	     req->max_rdma_war_size > adv.max_rdma_war_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAW) &&
> +	     req->max_rdma_waw_size > adv.max_rdma_waw_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_PDU) &&
> +	     req->max_pdu > adv.max_pdu) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_IMM) &&
> +	     req->imm_data_size > adv.imm_data_size) ||
> +	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE) &&
> +	     (req->usage_flags & ~adv.usage_flags)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/* Process the optional creation attributes. A job to act within, a source
> + * identity, a set of ordering guarantees to ask for. They and the checks on
> + * a requested QP number belong to a reliable unconnected QP.
> + */
> +static int create_qp_opt_attrs(struct uverbs_attr_bundle *attrs,
> +			       struct ib_device *device, struct ib_pd *pd,
> +			       struct ib_qp_init_attr *attr,
> +			       struct ib_qp_semantics *sem)
> +{
> +	struct ib_uverbs_qp_semantics usem = {};
> +	struct ib_jkey *jkey;
> +	bool has_semantics;
> +	u32 m;
> +	int ret;
> +
> +	has_semantics = uverbs_attr_is_valid(attrs,
> +					     UVERBS_ATTR_CREATE_QP_SEMANTICS);
> +
> +	if (attr->qp_type != IB_QPT_RU) {
> +		if (has_semantics ||
> +		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID) ||
> +		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY))
> +			return -EOPNOTSUPP;
> +
> +		return 0;
> +	}
> +
> +	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID)) {
> +		ret = uverbs_copy_from(&attr->src_id, attrs,
> +				       UVERBS_ATTR_CREATE_QP_SRC_ID);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY)) {
> +		jkey = uverbs_attr_get_obj(attrs,
> +					   UVERBS_ATTR_CREATE_QP_JOB_KEY);
> +		if (IS_ERR(jkey))
> +			return PTR_ERR(jkey);
> +
> +		/* a key acts within the PD it was made on */
> +		if (jkey->pd != pd)
> +			return -EINVAL;
> +
> +		attr->jkey = jkey;
> +	}
> +
> +	if (attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
> +		if (attr->source_qpn & IB_UVERBS_QPN_UET_RESERVED_MASK)
> +			return -EINVAL;
> +
> +		/* a relative QP is named within a job, so it needs a key */
> +		if (!(attr->source_qpn &
> +		      IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT) &&
> +		    !attr->jkey)
> +			return -EINVAL;

On a device without jobs, these two checks together mean a caller can only choose a QPN that has
the absolute bit set. Is that rule meant for RU in general, or only for UET?

Michael

