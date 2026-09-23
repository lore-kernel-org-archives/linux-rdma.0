Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15B3A2E00
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790171926; cv=none; b=JsBi1y5ezD20vOK6U0hUzgPVV72jSmcuAQnS9qeeesITawJb8ntTeKr8VaFSJ3/NWbHuJGXdVR2SRbIkZlbmf4Oe5oz/OLyXH1Uzpm4J3NARflnJPdzMBFlQXczo+r+EQuut08Sr5d8+jq7PKSxatOtE4a/P+G/nS0K0nMzluXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790171926; c=relaxed/simple;
	bh=JcRvjOOG0vTIRRxs7xhGPN3UzGHKC8QvSfO6xwJ11lE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Boxw7WQfIKhTFuGjVjz4PImeUVMhOU8K7EK1HSclFwKJjdCAw3/ggaWRO4G/NOuD7740lbcqPp/ppavtjh22Uaf7ZCTVwvKRCFu8LFaMQhSUCNTVilqrJDIc8yUL+cuQ0curJbjYXmpQPywBX/+XevDD4N7eNuqH4VxS6cxqiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gz/oK+Rv; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gz/oK+Rv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790171925; x=1821707925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D+jl2Oj0bAlgPBGT10TvY/N++HUHOtcfBKLwrONSWL8=;
  b=gz/oK+RvUeysL62hWdJEzEFzFlEVKpVVPWeL9O76jopiJcgRoPo9a8x2
   QJrQ8d2thf0wFY5810yGClo870rEQgmn9T+iqTNdj1bdbKaen76ozexoJ
   3EQUuUXXT+hVBw3yJkY2QYRVgTQsRdvOJanAeK8CF+YB10wqyT6Mso68m
   +aA33eqCVx1JUAzBvta4nlCbARY7U2V1qh17dOqpNJC7/DqgQUZaD/cC6
   l9l3Piwze0AGyJ388GngNVzN5tnv5mAwuFC1odkVsVS03VCz7gZbfsszM
   kn13jT/NUfRcL/qDUkGIxvq9oAqRuQngyXgcW8nKqanaXhjZkH9jYJl+k
   Q==;
X-CSE-ConnectionGUID: XlGR/QpLTIiO/F5MlDAGmw==
X-CSE-MsgGUID: mWRn5mGdTBOig0h+Me3xXg==
X-IronPort-AV: E=Sophos;i="6.27,118,1787011200"; 
   d="scan'208";a="29345932"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 13:58:43 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:5000]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.237:2525] with esmtp (Farcaster)
 id fe6cf305-f6fc-4199-a927-cabca2574faa; Wed, 23 Sep 2026 13:58:42 +0000 (UTC)
X-Farcaster-Flow-ID: fe6cf305-f6fc-4199-a927-cabca2574faa
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 23 Sep 2026 13:58:42 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 23 Sep 2026
 13:58:40 +0000
Date: Wed, 23 Sep 2026 13:58:34 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Firas
 Jahjah" <firasj@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring
 allocations
Message-ID: <20260923135834.GA1720@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260917105101.9365-1-mrgolin@amazon.com>
 <20260923105127.GP563127@unreal>
 <20260923115755.GE2545495@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260923115755.GE2545495@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Sep 23, 2026 at 08:57:55AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 01:51:27PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 17, 2026 at 10:51:01AM +0000, Michael Margolin wrote:
> > > RQ and CQ ring buffers require physically contiguous memory. On
> > > systems under memory pressure, high-order allocations can fail
> > > even when sufficient free memory exists because the allocator
> > > gives up after a single reclaim and compaction attempt for
> > > costly-order requests that lack __GFP_RETRY_MAYFAIL.
> > 
> > What sizes did you see fail, and in which flow?

In the recent cases we have seen (in customer/production environment)
it during order 7 (512KB) allocations for 32K entries RQ.
> 
> .. and many other drivers has spent alot of effort not having high
> order allocations like this because they just don't work.
> 

Unfortunately we cannot support non contiguous queues in some of the
devices but we are going to add this support where possible.

Michael

> Jason
