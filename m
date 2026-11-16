Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.13.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840073;
	b=TVLPj9iwK5fDI5lhsdbiqUTXUsSN6SVEx6YWE4vsZ5ZIC1S2VllXBo6xaI45Gx+uUpEr
	 WwFZK52AoxGQ9+I0xWkid03mwEQu7QHnz6NoeeBDmoc6iLxsHJKmlFCfZB5NKVFy34uhF
	 BiBtzJqc6brChFUgf92KBk8BRasLNBgYffYcg/u0k3gf3MRvCAmTH5jmWycP2sxhhsD2y
	 eoSl/7WsHO+uWcDzsyfkyBn3el3hJg9WbcPmRLGh6GLVFPltjJ2avq+a/Gp9qLLYRukjX
	 uK1/SAh/lCYjlHRpVD/a0MPCadTspnxiuiNvkKObDsKv3bT7mjdT3SxHmL0M0F8Oq+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840073;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=JXa1QcikKWgDF2p/Bfqt3RbNcZx10hbexeJkt+gjmgs=;
	b=QokOioIa2E4lFMkpti6FsxSVYkUJSMS4wcDrc/B91k8EAH49NmjzEVFG3dYTrwjNr6zD
	 hn2aZFqFy2tCt7qD4FdP217gsuVTCRhKI9VoYF+wy0GjAsGCPIxvQzF+LxMljlt/Cq1L2
	 t99jc+WxYE4kHvZPeqVh3qDY6JsMvrPouPlODZrsH42CxKtcO6vjtO1waNLTvk8H6eMle
	 4jrSaL1+05Xa/hRdY5GYcGygqFyo6FrAoyW0/HYTnQWQl2u7/Ncj8oBuCDXufFw0rKAFC
	 lqYxM0PE9h+URvvAOYYl+RKH2w4S4b0/2T2mgAvBPrPDokUTn/MjvRCzD7y24fZCC4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=sp1gjBzR;
	arc=none smtp.remote-ip=52.13.214.179
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E839606A323;
	Mon, 16 Nov 2026 14:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E839606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=sp1gjBzR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794840072; x=1826376072;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JXa1QcikKWgDF2p/Bfqt3RbNcZx10hbexeJkt+gjmgs=;
  b=sp1gjBzRZ7YApt1wfjHcSQc19xbAXNVjIbJ4fho2u8/Cfg9EW9Cu/CQZ
   wzKQ8SO8+MGTb1otGmATuRhvrMSW9xF5LyJ1ZIBwVlfeR0zS5L9YPE/o2
   TsR6Ae6q4NaZ5BHvRCI2Sd5fBPXhR0+MTRo3ajC/GbQBO2ycaVXx6s9ap
   hf6vLRLc6f147ZUaVWzIjaY2jLMXLD46WNPpO1eDzWVpgOVUVHWh0mkh3
   SRAjqFhsyULV8RI9nafFMWvZeaH1D2JBr/cosqpsRDVnbjUuXjyALqG5u
   NHeJ5Kx4quNhXFsx92xYm88rxOvduGBCz/Z53wivW2hQHl/6OP1N7GuO5
   A==;
X-CSE-ConnectionGUID: foc6kBl4SPqzF9gQ8YO2EA==
X-CSE-MsgGUID: D94icTehQ9mOqlb0feqfaA==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34202829"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:41:09 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:14450]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 142b76be-01be-4102-b3ec-fc97cd8c0e8e; Mon, 16 Nov 2026 14:41:09 +0000 (UTC)
X-Farcaster-Flow-ID: 142b76be-01be-4102-b3ec-fc97cd8c0e8e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:41:09 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:41:07 +0000
Date: Mon, 16 Nov 2026 14:41:05 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 04/13] RDMA/core: add the reliable
 unconnected queue pair type
Message-ID: <20261116144105.GC34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-4-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-4-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:37PM -0800, Eric Davis wrote:
> Add IB_QPT_RU and its userspace counterpart, together with the field
> layout of a reliable unconnected queue pair number used by UET.
> 
> Such a number uses all 32 bits, unlike the 24-bit InfiniBand and RoCE
> one, so exempt it from the restrack assertion that no queue pair number
> sets the top byte.
> 
> A relative number is named within a job, so pairs in two jobs may share
> one, but restrack keys a queue pair by its number alone. Until it keys
> them by more, refuse the second such pair with -EADDRINUSE rather than
> leave it untracked.
> 
> The provider posts its work requests, so the write post_send and
> post_recv commands refuse such a queue pair.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/restrack.c      | 15 ++++++++++++++-
>  drivers/infiniband/core/uverbs_cmd.c    | 14 ++++++++++++++
>  drivers/infiniband/core/verbs.c         | 13 +++++++++++++
>  include/rdma/ib_verbs.h                 |  1 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h | 21 +++++++++++++++++++++
>  5 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
> index a8b838fdc7b5..a75af79adf2c 100644
> --- a/drivers/infiniband/core/restrack.c
> +++ b/drivers/infiniband/core/restrack.c
> @@ -241,7 +241,20 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
>  		/* Special case to ensure that LQPN points to right QP */
>  		struct ib_qp *qp = container_of(res, struct ib_qp, res);
>  
> -		WARN_ONCE(qp->qp_num >> 24 || qp->port >> 8,
> +		/* An InfiniBand/RoCE QP number is 24 bits and the top byte is
> +		 * where the port is folded in for SMI and GSI. A reliable
> +		 * unconnected pair is an exception as its QP number is a
> +		 * full 32b wide, though of the top byte only the absolute bit
> +		 * may be set. An absolute number whose low bits are 0 or 1
> +		 * still conflicts SMI/GSI on port 128, which takes a device
> +		 * with both RU and MADs on that many ports. Two RU pairs in
> +		 * different jobs may also share a relative number, and
> +		 * create_qp() refuses the second.
> +		 */
> +		WARN_ONCE(qp->port >> 8 ||
> +			  (qp->qp_type != IB_QPT_RU && qp->qp_num >> 24) ||
> +			  (qp->qp_type == IB_QPT_RU &&
> +			   qp->qp_num & IB_UVERBS_QPN_UET_RESERVED_MASK),

The QPN checks here, and the EADDRINUSE on a duplicate RU QPN, seem to exist only because restrack
keys QPs by their number. The nldev LQPN get and counter bind could find a QP by number and port
without that key. Would allocating QP IDs like other objects work? Duplicate RU QPNs would still
need some way to tell them apart in nldev, but that seems separate from the QPN layout.

Michael

>  			  "QP number 0x%0X and port 0x%0X", qp->qp_num,
>  			  qp->port);
>  		res->id = qp->qp_num;
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index ed55fbbdfc18..e4fdfa0d9548 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2058,6 +2058,12 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
>  		goto out;
>  	}
>  
> +	/* reliable unconnected work requests are posted by the provider */
> +	if (qp->qp_type == IB_QPT_RU) {
> +		ret = -EOPNOTSUPP;
> +		goto out_put;
> +	}
> +
>  	is_ud = qp->qp_type == IB_QPT_UD;
>  	sg_ind = 0;
>  	last = NULL;
> @@ -2335,6 +2341,14 @@ static int ib_uverbs_post_recv(struct uverbs_attr_bundle *attrs)
>  		goto out;
>  	}
>  
> +	/* reliable unconnected work requests are posted by the provider */
> +	if (qp->qp_type == IB_QPT_RU) {
> +		rdma_lookup_put_uobject(&qp->uobject->uevent.uobject,
> +					UVERBS_LOOKUP_READ);
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	resp.bad_wr = 0;
>  	ret = qp->device->ops.post_recv(qp->real_qp, wr, &bad_wr);
>  
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 1299125752d8..ccdb08284432 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1333,10 +1333,23 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
>  		goto err_security;
>  
>  	rdma_restrack_add(&qp->res);
> +
> +	/* restrack keys a QP by its number alone, so an RU QP whose number
> +	 * another QP has, as one in another job may, is refused rather than
> +	 * left untracked
> +	 */
> +	if (qp->qp_type == IB_QPT_RU && !qp->res.valid) {
> +		ret = -EADDRINUSE;
> +		goto err_track;
> +	}
> +
>  	return qp;
>  
