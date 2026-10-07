Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F9470453
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791363869; cv=none; b=VCbyK+/28GyaRVBaYFxVkJTZ+lV/rnZG88kpGI/wpbizpW3EI+L2wcgNtnfH2Y+ne/wjoljAwSGX/C3/HYqEHiu1CDHCA0jWBP0261EbbKVqgTM9AbcnIYVeO5R0VGPpdbU2zFf/LmOUsp+JbMbi0rmvDXJqWzTznrZFk33LdBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791363869; c=relaxed/simple;
	bh=L8tr8+ST5O/EsUfYyBFQTAp1C2FVxit5AQRMTXnK23w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCGAI3n5kJktDowVroGFUG8Fj/7ckBF5lRPR+6W9quGyww3OJ4qZ5lRjSa4YvL7yq+v8AMqqEgZ/KT4olBxeCWkfImpC8EmwW9I5VVbyuQenVX/r3qW3jyqwkSip4osTAKJq1KltxE1ocVrA7/MPOgLbF8ZtxuyRWTdDVkJJXzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UzldNDFS; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UzldNDFS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1791363708; x=1822899708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iF+zR/4AZgqGUPJCetE9udRh5YILLUK9XTYtZXmF+Ig=;
  b=UzldNDFSnsIoEuwltnpO6+ljjrVTZqPWGLYmIATW/AhrPUGZaRII/3YA
   HtlP6xWWONjiILsj3MvZNQv1grNyo8O0yEuqzQeJSV2j9bCUBJXicEw6k
   Vw51nhUe8/bL2ngcqSijbhiLqtFLaHMO5NtAk+PPYLgpI0xqHGpFfcn3g
   +O4tVFaFvLn28azAFWCfyey+iZqnvqjLr5fufmWeGEkkkOHtJuNimh9mG
   CDqGdDFcNtUUYqKsvky08Rk5VskrPvVO79ZrBlDm1o8ahqbZCcCUHmF3B
   ABewyw5466R25bJNEqJdyuL7jhpyeKbkPCwWPRBuh0IbUeHPtFKEUqaNj
   w==;
X-CSE-ConnectionGUID: 9DmZTcXTRGyGQoBEStagfw==
X-CSE-MsgGUID: KWik/i5kScyxYqA6U0zFtA==
X-IronPort-AV: E=Sophos;i="6.27,144,1787011200"; 
   d="scan'208";a="30654322"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 09:01:45 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31997]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.9.224:2525] with esmtp (Farcaster)
 id 3efcf297-7a1b-4471-8d1c-0ae6f54e51c8; Wed, 7 Oct 2026 09:01:45 +0000 (UTC)
X-Farcaster-Flow-ID: 3efcf297-7a1b-4471-8d1c-0ae6f54e51c8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 7 Oct 2026 09:01:45 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 7 Oct 2026
 09:01:43 +0000
Date: Wed, 7 Oct 2026 09:01:36 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Leon Romanovsky <leon@kernel.org>, Yonatan Nachum <ynachum@amazon.com>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20261007090136.GA35552@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
 <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261001155333.GP3401365@unreal>
 <20261002145241.GV1616761@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261002145241.GV1616761@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D032UWB004.ant.amazon.com (10.13.139.136) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Oct 02, 2026 at 11:52:41AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 01, 2026 at 06:53:33PM +0300, Leon Romanovsky wrote:
> 
> > > Looked at Leon's patches and it does seem like the right place to expose
> > > such peer relations. Although it wouldn't help with our immediate need,
> > > maybe we can add a sysfs interface on top of Leon's patches to expose
> > > the gathered accessiblity (and maybe also performance) information.
> > > 
> > > Leon, what is your opinion on this?
> > 
> > ACPI tables are available here /sys/firmware/acpi/tables/, this will
> > include our new p2p HMAT extension.

I was iterating over Jason's idea and what I imagine is an interface
that contains already parsed data at PCI level, like:

/sys/firmware/acpi/p2p/
├── 0000:55:00.0/          # RDMA NIC
│   ├── 0000:59:00.0/      # → GPU (reachable peer)
│   │   ├── latency_ns     # 200
│   │   └── bandwidth_mbs  # 32000
│   └── 0000:5a:00.0/      # → GPU (reachable peer)
│       ├── latency_ns     # 200
│       └── bandwidth_mbs  # 32000
│
├── 0000:59:00.0/          # GPU
│   ├── 0000:55:00.0/      # → RDMA NIC (reachable peer)
│   │   ├── latency_ns     # 200
│   │   └── bandwidth_mbs  # 32000
│   └── 0000:56:00.0/      # → RDMA NIC (reachable peer)
│       ├── latency_ns     # 200
│       └── bandwidth_mbs  # 32000
│
├── 0000:9a:00.0/          # NVMe
│   └── 0000:55:00.0/      # → RDMA NIC (reachable peer)
│       ├── latency_ns     # 300
│       └── bandwidth_mbs  # 12000

> 
> ACPI is nice and general, but..
> 
> Doesn't AWS have something already to convay VM instance type
> configuration information? That's pretty normal these days isn't it?

There is but both options doesn't help in the short term and long term I
think, as you mentioned, that ACPI is a more general solution and it
doesn't require any additional dependencies.

Michael

> Jason
