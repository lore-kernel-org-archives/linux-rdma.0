Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFAA4AB3C0
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774806; cv=none; b=CEjn2aQQUzyUtUbpfY1RBjsU/DXUgXbDHNq+Rsx/uXY231uaCBGCD9oEKuRyEt1zqjCBMFWfz5QQurIiow+IyMUWjFu1DjwSfbKdEGxjNulOw+UICMGYfETzv50UQIUr46raW1wPCiWr/odNHMSJEMARIOOx2CakyomVtEYnpds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774806; c=relaxed/simple;
	bh=uyEIIJ/mGUGVJUJfpxmz9UQhkNhB1cfJ6nk9Zt00O2E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWKjcm6lptjVLeHP167eyn1wW/CWtlG/i/aPdIpSaQJ3mIW2HPkAhW4IzuEmTZsoWzlcw3cbbbd0rwsvlDsrfVXft9AlQpHXgD0sMJG8cC0eIgTHF3Ukmspomc1qcGwwauy031WOb7v12lPIH3BcqlxmrFmmZcxHlXrWvFtkezw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=nhHpr8R+; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="nhHpr8R+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790774792; x=1822310792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pacHPRvcWj1zddp+qYE52X+2c5dbs2QfQH9YW3mVgxg=;
  b=nhHpr8R+Gzlth0PJ1Ph563rg56jcfyUSkh1KCbdekF1WOPrtmjuqQDU2
   vIgxLSNUzpa0GZE0FiGNj8V+q1PxBQaOGCLv10zIPe4Z5MyHL1s1DMSFb
   M5FeNwyL+gMIZVjcXmkskoF/so8Ig10XoYGwNk2hmhNq7Sos6cNZjITuP
   sln9AD68hYhy4jsgh22i9To/TuR3jU/z1/AE4t/IJZWLX8cxnIIqk+hQC
   5bMxtoCu9jZLHjiZ516hgMeRa83JqvIqsGg4hlOBMCkHiN3OLk4kBr955
   pBbrKBqCMhsl31wnHFXHf7x+S0gPXFckoNEfgpB0vF/rCMLr+Adm//+Zm
   g==;
X-CSE-ConnectionGUID: dvNwLEtHTvyzpiMSI2XqcA==
X-CSE-MsgGUID: QNIy+kL7S2WBZ/lGVJHKHQ==
X-IronPort-AV: E=Sophos;i="6.27,132,1787011200"; 
   d="scan'208";a="29943741"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 13:26:22 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:14105]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.237:2525] with esmtp (Farcaster)
 id aacfb9f0-eb61-4664-bbcf-f55767fbf7d0; Wed, 30 Sep 2026 13:26:22 +0000 (UTC)
X-Farcaster-Flow-ID: aacfb9f0-eb61-4664-bbcf-f55767fbf7d0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 30 Sep 2026 13:26:22 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 30 Sep 2026
 13:26:20 +0000
Date: Wed, 30 Sep 2026 13:26:13 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yonatan Nachum <ynachum@amazon.com>, <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260503150246.2349679-1-ynachum@amazon.com>
 <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260925125512.GM9354@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Sep 25, 2026 at 09:55:12AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 24, 2026 at 07:30:26PM +0000, Michael Margolin wrote:
> > On Thu, Sep 24, 2026 at 03:22:01PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 24, 2026 at 03:29:13PM +0000, Michael Margolin wrote:
> > > 
> > > > > > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> > > > > >    directly to userspace. As you already stated, this is a
> > > > > >    bit awkward as a device isn't expected to be aware of
> > > > > >    system topology, but since EFA lives in the cloud it is
> > > > > >    partially aware of the platform configuration and in
> > > > > >    particular the ability to access peer devices over PCIe.
> > > > > 
> > > > > If you already know your VMs are always safe what is even the issue?
> > > > > What are you probing for?
> > > > > 
> > > > > Lets please not hack around bad userspace with even worse kernel uAPI.
> > > > 
> > > > The EFA device already knows this attribute. The problem is that this
> > > > information is not exposed to userspace today.
> > > > 
> > > > So if I go back to our original proposal - exposing the
> > > > EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
> > > > attribute that says "this device does not block PCIe peer access on its
> > > > end." It's not a topology claim, it's a device property, similar to how
> > > > we already expose RDMA read/write support.
> > > 
> > > And how does that help you if you actually need reachability? You
> > > haven't said directly what you are even trying to achieve (though I
> > > have a pretty good guess).
> > 
> > On some platforms P2P is blocked at the device level despite the fact
> > that the peer GPU is reachable over PCIe.
> 
> This idea just doesn't exist in Linux.. It is completely inappropriate
> for a PCI device to declare it knows something about the
> topology. That's not how PCI works, it is the wrong place for your VM
> to signal information about the PCI routing through the EFA driver.
> 
> That needs to come up to the P2P subsystem.
> 
> > This mainly happens in multi-instance setups where there is a need
> > to manage PCIe bandwidth or prevent noisy neighbor effects. Today we
> > check this attribute on the device during MR registration, so
> > libfabric's EFA provider allocates GPU memory and attempts to
> > register an MR to get this information.  This process is costly,
> > thus we are trying to replace it with a simple capability check.
> 
> Which is the right thing to do, again if it is slow go talk to the
> people who are making it slow..
> 
> > > Precompute it and use a topology file like everyone else?
> > 
> > This is an option but it seems like a big overkill for the simple
> > check that we need.
> 
> Maybe there is some other place you can inject into the VM a 'this vm
> does not support p2p' flag that userspace can see?
> 
> Leon has been working on some ACPI enhancements for this, perhaps that
> new table could be distilled down to a single sysfs under an acpi
> directory?

Looked at Leon's patches and it does seem like the right place to expose
such peer relations. Although it wouldn't help with our immediate need,
maybe we can add a sysfs interface on top of Leon's patches to expose
the gathered accessiblity (and maybe also performance) information.

Leon, what is your opinion on this?

Michael

> 
> Jason
