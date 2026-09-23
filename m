Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735F2C11E4
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181534; cv=none; b=imvxNTiNYyiTLYMsGBV6L8xy6/2v1+yn6ytYWMS/JhhPg9gz6inj81vgUwCz3T6Vyv7xuklss/QrMzFyH1F4piMzx81Cr2ZG2u67fuCJmy2xrhJW2Sh0tWfYqebGcKeMYO9E6lOHDjdy8SORKfZ4mnQbUmYKx1oAFLKfYJmVizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181534; c=relaxed/simple;
	bh=soNEb4YjJvr1GGAglazHWwBaJWTJ2C495iv8iBFNVLI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpXmHu9cBTMTXgBPi5XB62u336+vuCf+w6QPKqO2kuc1ef1ciqakuqiOTe8ZVZDBeFQF3aFEuhAmvnzyy5ZZ4hZEaTWPeX6PcTSB7jbzGoPJ9T0nMtQXr6j3tnWgogInqB9yrmbLLJmpax6hGjHRdmRLnT4pFrQhDA+0psAhz00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IN11EssB; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IN11EssB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790181531; x=1821717531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Xd92BODXuPhThCDBXZuZnX7eNkXiwZeiSebGOu8ynRA=;
  b=IN11EssBGzQIli1WUyEA0wKy0V3wc03cz9Ez1d7xdeYHVwy+nj0nKC01
   g5XNZVnKi3wgZ15nPbcRXWcdClfZEe2pQ0j67ZijE1kj9+sJZ/L5b5hJz
   hgDeTckKwjFrpTrmA8pvIRBu10qbtu3WArfrkcuv5fQm/y9S9yhIHC7Pn
   pXtEKkQXeNaMv/1P7w2GIEwRbwhRZh7+79Y3CcaINY2iD8D4G4mYA8Zxv
   1tbxLe36Rbobl9CW2lyNaIuk4aC5R+l6Hd/WdEAciMWsYEQpSXJn5fxfx
   zq81atjgK2091yAuJLBlFBHINv55jB2FYpZtfEJrNevoP8wTtQJy8mtTp
   Q==;
X-CSE-ConnectionGUID: 3gHGyzGoSGO7iKwjNQn41Q==
X-CSE-MsgGUID: wXArTsWqTyWJUj9OjGz/Qw==
X-IronPort-AV: E=Sophos;i="6.27,118,1787011200"; 
   d="scan'208";a="29366895"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 16:38:45 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:9722]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.27:2525] with esmtp (Farcaster)
 id b0fdcbcb-bf42-4e8e-ba53-1da326c4b70f; Wed, 23 Sep 2026 16:38:45 +0000 (UTC)
X-Farcaster-Flow-ID: b0fdcbcb-bf42-4e8e-ba53-1da326c4b70f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 23 Sep 2026 16:38:40 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 23 Sep 2026
 16:38:38 +0000
Date: Wed, 23 Sep 2026 16:38:30 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yonatan Nachum <ynachum@amazon.com>, <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afoPWiiEwk5igB/N@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, May 05, 2026 at 12:40:10PM -0300, Jason Gunthorpe wrote:
> On Tue, May 05, 2026 at 08:15:14AM +0000, Yonatan Nachum wrote:
> > On Mon, May 04, 2026 at 04:34:12AM -0300, Jason Gunthorpe wrote:
> > > On Sun, May 03, 2026 at 03:02:46PM +0000, Yonatan Nachum wrote:
> > > > Expose device P2P DMA support using the query device verbs.
> > > > If the device support P2P DMA, it can DMA directly to and from a peer
> > > > PCIe device
> > > 
> > > This doesn't seem right, this should be policed by failing to
> > > established p2p mappings and to fail mapping dmabufs not with random
> > > user space bits like this.
> > 
> > The motivation here is to avoid requiring userspace to speculatively
> > attempt registering accelerator MRs just to discover whether the device
> > supports P2P DMA.
> 
> This isn't how the kernel works there isn't a "this device can do
> p2p", the question is always answered with pairs of devices. There is
> no way for a single device to know it doesn't do p2p with any other
> device in the system.
> 
> > Beyond the API awkwardness, this also has a real
> > performance impact — initializing an accelerator context can take
> > seconds, and by advertising this as a device capability, userspace can
> > know upfront whether it's worth going down that path.
> 
> This seems like a misconfiguration. Since so much of this topologcal
> information is not discoverable at run time usually systems have an
> external data file explaining how to best use the system. I wouldn't
> expect the runtime to be trying to probe this at run time.
> 
> If you *really* want probing then it has to be dmabuf based because
> you must probe with pairs of PCI devices.
> 
> > 2. When we get a dmabuf, I can't distinguish what is the backing memory,
> > for example DRAM or accelerator memory and we can't just blindly fail
> > all cases.
> 
> You must rely on the p2p subsystem to make this determination and the
> dmabuf exporter has to call into it. This will deal with those
> problems.
> 
> Jason

Jason,

I'm reviving this conversation since it is becoming an
increasing need to reduce the long startup times. The major
part of this time is related to CUDA device initialization
needed only to allocate GPU memory, export a dmabuf, and
test accessibility via MR registration. Since obtaining a
dmabuf fd requires CUDA initialization, which is exactly
the cost we are trying to avoid, we are looking for a
solution that doesn't require dmabuf.

I have two options in mind:

1. Introduce a new (common or EFA-specific) verb that takes
   a peer device BDF and queries the p2p subsystem,
   returning something like:

   pci_p2pdma_distance(peer, self, false) > 0 &&
   EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)

2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
   directly to userspace. As you already stated, this is a
   bit awkward as a device isn't expected to be aware of
   system topology, but since EFA lives in the cloud it is
   partially aware of the platform configuration and in
   particular the ability to access peer devices over PCIe.

I would like to hear your perspective on this.

Michael

