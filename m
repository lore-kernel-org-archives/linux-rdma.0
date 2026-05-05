Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8B30DEDC
	for <linux-rdma@vger.kernel.org>; Tue,  5 May 2026 08:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777968938; cv=none; b=hJw+KzLXpG7m+p/h2mdtimf7RfjwVHPq3lQJr2Z3YOmc4W1WrsBmYtRtKSjlqouGO7o/giROTUcBSAAevQ38NW8QPUrtjyDtPqHXGJeb71BHZsSUZw/f+56kQOdx8f8/HANmBdEVCjlCoXtLEScirBtUgc85ys7V/K9+Cfcl6jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777968938; c=relaxed/simple;
	bh=04L6d6u7Ma2L9FSwu6VyCMzyYwg3Y7L4cDpXU8JOK2c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/6QewWsR5ir4Ima7RAU0VN+uCsrOA9agCLVudeASFUXPxKmMGzPALUZvcu7bw7GB0AVWTm/URqx9OIVNBQxGEqKPF0reRpruUPj+toY464Yg6Din6dwIX34Qi9xef1HmUu1sjdS31kPygyB+4ys5TCIwc8dPovvMTmw4hxDBPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UWvHvCrd; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UWvHvCrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1777968937; x=1809504937;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=h0BObsvEJ0yhP+azhahQbocTBbLRrizXS58UCKws6kQ=;
  b=UWvHvCrdbOIwvZgkVBS1P7ZqOv9DHbsugRd7iOZsR+Ur4XiH8WmAO1CK
   wj7r7OooxDXAYQy8eajfcfoYjAZFq/JvsaB19f/1ISRxxEMC6EeGPjQAS
   I3cD4kA54XpaqAEeQuN4E/kS6V+D/Yn0/8Y6NU00D2eQjTPt68oCARtAQ
   dZSWz4tTNz8rBETVFQyz4ukgG2dZtKqj6Svi7uSpqHksz1IIoh46CcrCC
   dk1qLK324XJV1aJADZLnbu/hY18+m9I3dvsMVq0KORWTOsgW+EHTGw54q
   vi3qejT6BkUAsC2aBk1hXs0Rzq8BdE4GDF9nJLKp8DRw5ZA6Vykq9OU65
   Q==;
X-CSE-ConnectionGUID: /B3FA7PZR2+iaOR4/iwNlQ==
X-CSE-MsgGUID: 5IRto+tHRauUgN9Q6GBBxA==
X-IronPort-AV: E=Sophos;i="6.23,217,1770595200"; 
   d="scan'208";a="18877262"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 08:15:34 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:20526]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.10:2525] with esmtp (Farcaster)
 id d68e9ad6-f5c6-4f94-a64f-768b65108d9c; Tue, 5 May 2026 08:15:34 +0000 (UTC)
X-Farcaster-Flow-ID: d68e9ad6-f5c6-4f94-a64f-768b65108d9c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 5 May 2026 08:15:32 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 5 May 2026
 08:15:30 +0000
Date: Tue, 5 May 2026 08:15:14 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <leon@kernel.org>, <linux-rdma@vger.kernel.org>, <mrgolin@amazon.com>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Yehuda
 Yitschak" <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afhL9DLUVhnVyzZu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, May 04, 2026 at 04:34:12AM -0300, Jason Gunthorpe wrote:
> On Sun, May 03, 2026 at 03:02:46PM +0000, Yonatan Nachum wrote:
> > Expose device P2P DMA support using the query device verbs.
> > If the device support P2P DMA, it can DMA directly to and from a peer
> > PCIe device
> 
> This doesn't seem right, this should be policed by failing to
> established p2p mappings and to fail mapping dmabufs not with random
> user space bits like this.

The motivation here is to avoid requiring userspace to speculatively
attempt registering accelerator MRs just to discover whether the device
supports P2P DMA. Beyond the API awkwardness, this also has a real
performance impact — initializing an accelerator context can take
seconds, and by advertising this as a device capability, userspace can
know upfront whether it's worth going down that path.

If I understand your suggestion correctly, you'd prefer to enforce this
in the reg MR path itself rather than exposing a capability bit. I see
two issues with that approach:
1. Userspace would still need to speculatively attempt a reg MR to
discover P2P support.

2. When we get a dmabuf, I can't distinguish what is the backing memory,
for example DRAM or accelerator memory and we can't just blindly fail
all cases.

Can you please clarify how you imagine this capbility to be used ?

> There are lots of things in our system that need this feedback to go
> down that path.

Can you please clarify what you mean here ?
