Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9141231327F
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 06:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789368979; cv=none; b=ZxIBefQBbBElk4MfG9QA6WQzJzPuLOVxjUyDnO6rmNY0UrpMdOXODuCBNR48+v45djX1jU3wiGEocxIsZXyCCHZfczrwhTbN/lTmyM03kJO5CDaZo+4nhe7s2+rsP0trQ9UEk6IKftTibH6N5GCv9q2sjecmSjh1aMYRmerZ2U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789368979; c=relaxed/simple;
	bh=SvOvNHzPTdu1BTgNdYFTAQnVHd3F6OkZvHYjocSQwq0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyniWN/q92JqVfGZMNXNxew5E+3tX5DpoIrFrO+FxmkfpiQRzpzXt18ukVyiCHLebGSUhv+M75eFiE7YlS6x/EDz3MTiFtwpwFkv+XE8fDhInXslBi+YeSjvJ+LnklE3Dg2gpdcDYYsGNpE7yo4tyIFw203sTgCM9/ZzFhaWX3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UzsKZEMw; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UzsKZEMw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1789368978; x=1820904978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6XjCGCBF8SEQW1fuo64bPhrOaoCe3/laNFtXQp/mt+Y=;
  b=UzsKZEMw8z+Q8B7BrI/tlke3Od3DLtyZXAQm7dWspRe86PDhwdv1UqXv
   5KMfNQCr1Spz1rXmt7DAIKOVvZpPYDNquZh8aEtwo69zn5jScgDm8w4vK
   cYyz6ne91OzaYxImkGSMteafUu14I4AHVBcr8YBpphYmopel+zR8vj3pn
   PandivpcxkW6WIZtLLSGX2rrS1m1fmQy/5xiv6sGYpVu8QOSTIDtz0S4J
   Yf+BCCgYzqeFvJABElB4PlazIDSE56ARuNWfqQMrNrLWviGlw29WQh2vf
   dA2JuQvQu0gqofucaJ+w2ks2xwlmliJbNLA45VxVBVUAOGsuMel7CHfEU
   Q==;
X-CSE-ConnectionGUID: Th0RnCSZQwOee5Sr8+B8qw==
X-CSE-MsgGUID: GJ6wgctxQdCU/vHDXw1V6Q==
X-IronPort-AV: E=Sophos;i="6.27,102,1787011200"; 
   d="scan'208";a="28635201"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 06:56:16 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:23985]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.159:2525] with esmtp (Farcaster)
 id 966d2ea6-08ea-46ed-8ac7-447d9762e093; Mon, 14 Sep 2026 06:56:15 +0000 (UTC)
X-Farcaster-Flow-ID: 966d2ea6-08ea-46ed-8ac7-447d9762e093
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 14 Sep 2026 06:56:15 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Mon, 14 Sep 2026
 06:56:14 +0000
Date: Mon, 14 Sep 2026 06:56:01 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>
Subject: Re: [PATCH for-next v2 0/2] RDMA/efa: Add support for MR relaxed
 ordering
Message-ID: <20260914065601.GA21454@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260824073057.1046630-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260824073057.1046630-1-ynachum@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Aug 24, 2026 at 07:30:55AM +0000, Yonatan Nachum wrote:
> Changelog:
> v2:
>  * Remove the relaxed ordering device capability.
> v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/
> 
> -------------------------------------------------------------------------
> Add support for MR relaxed ordering access flag, allowing userspace to
> create PCIe relaxed ordering MRs.
> 
> Dana Malachi (2):
>   RDMA/efa: Use device ABI MR permissions instead of verbs flags
>   RDMA/efa: Pass relaxed ordering flag to device
> 
>  drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
>  drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
>  drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
>  drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
>  4 files changed, 21 insertions(+), 6 deletions(-)
> 
> -- 
> 2.50.1
>

Hi, kind reminder for this series.
I reviewed the Sashiko comments and no changes are needed.

Thanks.
