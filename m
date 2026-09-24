Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7109936C0D6
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 19:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790278241; cv=none; b=XCtZimmaIgotZhF9/crbnsbk/+nGjW2pITnVl+R9+wEe7CmoV05maEf1tVi7i9AYcylndHMNZuBSmDOrjo8QnbxCTEaqm6MCYxV1QJD5Hmsz5J6PA4scIHcZwV+fWgxvICpQPSm9nfq8yHrXTm/Lbdhi4pKWeoIUixWUCO0E1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790278241; c=relaxed/simple;
	bh=riDlXqLhEgaze4m9ouKXRgtvYKe5c3x77PBBhyh4GB4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyOT10+fwdFM0KcUMCuvxV+LkhiIFq6nIao1vlnALL3Ndttk/U09eY7EDDamnt6bk79lbMshCLbsFSisLBghwc4hNGQFiId9Q4SpeGMFnUR+rQhvhxwZDWbGhSSEc3i8ayCH00jg2J9UyNVhsTsx5CSj52K1aCeIbPWQPtSfg2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=SLKnkwH7; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="SLKnkwH7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790278239; x=1821814239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WMdEZrglqrkucArEzIofClARa/TngBT96VOJnQEVEAs=;
  b=SLKnkwH7ElfWUNdEf5nk5Yh98McjNO6TpoEXSztI68VH9JZ5ztjlyZBa
   hP12QEpcp2T4fwvye/9qJ3s8Jfs7uVAttQIOg1meqps8TC1GQX5RSB8u0
   FV/sRw6iNHEnBtc2DcJ3/6MTGW/TjwuDM9uDaEb3f/eLagQNkAT7GR/Jh
   +LrBcvGi8isZKygjQsTQyL4FFC8dcVgSO7hKz58oc3NlZVosJJ3dMUR63
   GSzX+NDj79aq4m5326EFrM3I+MjqVPQWwLkJmmhJEMJJsJwioj+XoLkQh
   qosu9/ur0Y6muXJ9n5ugPLP/OHl0bCTe8PSxT+m/F4O3I2Rn0dWXEtDQJ
   Q==;
X-CSE-ConnectionGUID: nPKPzOoJQSWu5SN+mn3rMA==
X-CSE-MsgGUID: wy9tQE9ZRIemqvdk55gVug==
X-IronPort-AV: E=Sophos;i="6.27,121,1787011200"; 
   d="scan'208";a="29373975"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 19:30:36 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:14099]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.110:2525] with esmtp (Farcaster)
 id 7eaefb71-23c1-4a86-ae2a-b5902aee3967; Thu, 24 Sep 2026 19:30:36 +0000 (UTC)
X-Farcaster-Flow-ID: 7eaefb71-23c1-4a86-ae2a-b5902aee3967
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 19:30:36 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Thu, 24 Sep 2026
 19:30:34 +0000
Date: Thu, 24 Sep 2026 19:30:26 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yonatan Nachum <ynachum@amazon.com>, <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260924182201.GB9354@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Sep 24, 2026 at 03:22:01PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 24, 2026 at 03:29:13PM +0000, Michael Margolin wrote:
> 
> > > > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> > > >    directly to userspace. As you already stated, this is a
> > > >    bit awkward as a device isn't expected to be aware of
> > > >    system topology, but since EFA lives in the cloud it is
> > > >    partially aware of the platform configuration and in
> > > >    particular the ability to access peer devices over PCIe.
> > > 
> > > If you already know your VMs are always safe what is even the issue?
> > > What are you probing for?
> > > 
> > > Lets please not hack around bad userspace with even worse kernel uAPI.
> > 
> > The EFA device already knows this attribute. The problem is that this
> > information is not exposed to userspace today.
> > 
> > So if I go back to our original proposal - exposing the
> > EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
> > attribute that says "this device does not block PCIe peer access on its
> > end." It's not a topology claim, it's a device property, similar to how
> > we already expose RDMA read/write support.
> 
> And how does that help you if you actually need reachability? You
> haven't said directly what you are even trying to achieve (though I
> have a pretty good guess).

On some platforms P2P is blocked at the device level despite the fact
that the peer GPU is reachable over PCIe. This mainly happens in
multi-instance setups where there is a need to manage PCIe bandwidth
or prevent noisy neighbor effects. Today we check this attribute on the
device during MR registration, so libfabric's EFA provider allocates
GPU memory and attempts to register an MR to get this information.
This process is costly, thus we are trying to replace it with a simple
capability check.

> 
> If all your VMs can do P2P then what is the issue? If you need
> pairwise reachability then you have to use dmabuf.

As I describe above, this is not the case.

> 
> Precompute it and use a topology file like everyone else?

This is an option but it seems like a big overkill for the simple check
that we need.

> 
> Inject a topology file into your VMs, like some others?
> 
> Jason
