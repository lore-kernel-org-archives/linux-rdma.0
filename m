Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.35.192.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839906;
	b=m6K8xHIn+iv6pJLZaCQIS4sPQIfTH8OGGAJLDs0fCtvSsGu3o+G3oeSLKqaUJiSHKkvb
	 g6Dsd9TRgeXQ3gFX6z9+JulyY12F2seDvhIF6oMAWfUe5eSxOtBNkty1RjfNez9RrUIOf
	 7aJeZFiZyGp+ZfT1JYaXlhq/S3axdvt7YYG6rBdsf8gR/zfCluOj1abTktQXPfkOKrkFg
	 nU0vaACYsJ8/F5c2VSBXbiCVIr3PHZIZkIJmiSoSS9sWVa426GWeqx+GNl0Ikn5HYcNww
	 sBSERPYyfYq7+pqymWj3RrXDLAtFNpyTJC0GIrj5CchXtEnH40JEhR7+c6clI2vnvhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839906;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=kXXhrm8w7eFXeMZAcj0fnQO8WCYBFN/DOgKKglO5YNs=;
	b=xFV3hrsG5RViTN8BeZx9OoHHi1oVCHw4uGh5QEktig3P6zxM/e+WWckWbjMbMePQDHSb
	 e5ttbeRYO/CoIg/zI6wXFUNhwCwCI/roYFCz9sjORqUoiZs3TZySxtd33y/f3fVloKVuU
	 pTx77Wxdm3w6m52esNpSHIf8DJ3XPd5OXylOyvbNcWbuTVUruxxQfoQ6+3dNT55ZP3PrR
	 mPG53acG2hzOSUtjs7w44OpH/HIqVmFfw++WXQKDZwtaZ4PiwKr0QfVettaR5h46ikDop
	 QAinNU6jLq994E+OsspEpq1wfhSQiWv6xLZ9g0hNJZ+0Q95DExjDvP52xfo5Ro/n90g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DQn3elN3;
	arc=none smtp.remote-ip=52.35.192.45
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26AB606A31C;
	Mon, 16 Nov 2026 14:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E26AB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DQn3elN3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794839905; x=1826375905;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kXXhrm8w7eFXeMZAcj0fnQO8WCYBFN/DOgKKglO5YNs=;
  b=DQn3elN3t2jSoCydvhWy4gzglVAvkx86ujANuL92COWVosecWR9Z7RJS
   6Z0ldf04WeJBWbAqLq1UTqjzSrfDPrR29fO/LKKgEegVPMhJMj9L23hST
   ZeGm8Zta18YtUAZKZ3hkycKos/yhwQFdf+XqPiN+xhO61Ze9uKRtEn376
   LXKYd+mhoqGN/zMQJvd9F7cnka6XFyJJ/mwbgcz2Tv7qW/uj/rmDgTGLl
   OY7I5mxOjs5uZ5Nd/8ABEC7aMkhBZp6DfEQJMuSDlEnT7NJRBBu6aIFjJ
   M25cfjSsRfol3qmG+fHBVjWuIqWYvqs+hDAF0HBwsurp3hMIcdm43hP4k
   w==;
X-CSE-ConnectionGUID: 1IWu+aFKTOSy3btmbwTTyg==
X-CSE-MsgGUID: K9S6Dc9bTZuXm3ZhpQ4uAA==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="33972313"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:38:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:5609]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 035ecc8b-73a9-4d0e-958a-7362a6387d6a; Mon, 16 Nov 2026 14:38:22 +0000 (UTC)
X-Farcaster-Flow-ID: 035ecc8b-73a9-4d0e-958a-7362a6387d6a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:38:22 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 14:38:21 +0000
Date: Mon, 16 Nov 2026 14:38:18 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Eric Davis <eric.davis@broadcom.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 03/13] RDMA/core: report the reliable
 unconnected device capabilities
Message-ID: <20261116143818.GB34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-3-3e7e7ffed2e9@broadcom.com>
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
In-Reply-To: <20261109-uet-ib-core-v3-3-3e7e7ffed2e9@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Nov 09, 2026 at 08:00:36PM -0800, Eric Davis wrote:
> Add the capability bits a device uses to advertise reliable unconnected
> support alongside additional features: the transport itself, 64-bit
> immediate data, 64-bit memory keys, caller-chosen keys, and the four
> memory region access restrictions.
> 
> Report the job, job key, and address table limits through the extended
> query_device response so userspace can size against them.
> 
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>
> ---
>  drivers/infiniband/core/uverbs_cmd.c |  3 +++
>  include/rdma/ib_verbs.h              | 14 ++++++++++++++
>  include/uapi/rdma/ib_user_verbs.h    | 27 +++++++++++++++++++++++++++
>  3 files changed, 44 insertions(+)
> 

> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index 565301594634..df3e72aee9a8 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -300,6 +300,10 @@ struct ib_uverbs_ex_query_device_resp {
>  	__aligned_u64 max_dm_size;
>  	__u32 xrc_odp_caps;
>  	__u32 reserved;
> +	__u32 max_job_ids; /* jobs allocated at once, not a JobID */
> +	__u32 max_job_keys; /* job keys allocated at once */
> +	__u32 max_addr_entries; /* largest address table of one job */
> +	__u32 reserved2;
>  };
>  
>  struct ib_uverbs_query_port {
> @@ -1370,6 +1374,29 @@ enum ib_uverbs_device_cap_flags {
>  	IB_UVERBS_DEVICE_ATOMIC_WRITE = 1ULL << 40,
>  	/* CoCo guest with DMA bounce buffering required */
>  	IB_UVERBS_DEVICE_CC_DMA_BOUNCE = 1ULL << 41,
> +	/* Reliable unconnected QPs, jobs, job keys and address tables */
> +	IB_UVERBS_DEVICE_RU = 1ULL << 42,

Does RU have to imply jobs? Leaving out the job ops works fine: the objects disappear and alloc_job
returns EOPNOTSUPP. The only way userspace can tell is max_job_ids == 0, though.

Would a separate cap bit for jobs make sense, so IB_UVERBS_DEVICE_RU means just the QP type?

Michael

