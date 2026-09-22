Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD264383994
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072973; cv=none; b=GIfFJ+W3C2lYzIvyHQrLsmBTE5Wy3zpLpsUmyzUTLi26Dtp32KjIGQKRzN46nvlmaQGVU14kELyvKihj7ZdZccbGOrL7PbNF9njEJQ3okgmBUFQwGuu1tZog1WgICNlsso3ozHvtL9IMk1fEo0G228iPmrlO6hcsbn0S9mrGPc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072973; c=relaxed/simple;
	bh=EztkWm1GbDca9lutXZLmHwHpmP9VAJP0yvawaEJDbEI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBdTIJQDMB+JkLv3Py1C8yAkO/AhLvMVLizKfuqxT3+mpC/2OBpbGxl9IP8/5HHA/DMMjr//K/kLaPdNfLYctvmh4fx/hjOt4rcPxjIL8Oh4uKvZHHDcPvnS56bE2uoLD4jtOroFiWZYxbqr/7yE3X68a9nXzVWUXQcrJQbKeJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FPYvCOsP; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FPYvCOsP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790072971; x=1821608971;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+5a1+oJoc7Y/SJMYFKr5lhCbb4PJJBjcL1/HapSFDdo=;
  b=FPYvCOsPPUFIA3IwC96iketbZOsYDHRZfAzyW9dZrklVM3A6ru58cD4C
   G2q8K2gdL1C2cq6BJ+eB9EoC0uq3L+6g7dHR0fD9nBFb842jp4vk4Xlkr
   GPAx+uzZfpr46XyO/JTdlgwDrdiCv3qB8ZuEnCLuyfxEG3NddX06amXAU
   2pfwwBzRKzRXBXjlf2YHe4vtNwxoXQJmTvkjqQ3sVUcUzH4xpuft7kAel
   zFKyel6d4nG+TR76yF6GMcvJoVJ4BAQ0EGW22Aq/zbOd0ceN7mZmpodRq
   XMOZ+09k+BO71LpigDg0gaIyY5xOEFvMdTmD8kL3eBxLY5AvIy4ZkS6+I
   A==;
X-CSE-ConnectionGUID: iMZJ/rHnTxK86prkRS+TwQ==
X-CSE-MsgGUID: TPj1WznMRJ+LmfaU18FssA==
X-IronPort-AV: E=Sophos;i="6.27,116,1787011200"; 
   d="scan'208";a="29325570"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 10:29:29 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:19397]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.208:2525] with esmtp (Farcaster)
 id ceb449b8-ab5c-438b-be17-f1f550bc2897; Tue, 22 Sep 2026 10:29:28 +0000 (UTC)
X-Farcaster-Flow-ID: ceb449b8-ab5c-438b-be17-f1f550bc2897
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 22 Sep 2026 10:29:28 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Tue, 22 Sep 2026
 10:29:27 +0000
Date: Tue, 22 Sep 2026 10:29:18 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Yonatan Nachum <ynachum@amazon.com>, <jgg@nvidia.com>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>
Subject: Re: [PATCH for-next v2 0/2] RDMA/efa: Add support for MR relaxed
 ordering
Message-ID: <20260922083925.GA10377@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260824073057.1046630-1-ynachum@amazon.com>
 <20260914065601.GA21454@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <20260915110909.GI13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260915110909.GI13683@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Sep 15, 2026 at 02:09:09PM +0300, Leon Romanovsky wrote:w3esq23

> On Mon, Sep 14, 2026 at 06:56:01AM +0000, Yonatan Nachum wrote:
> > On Mon, Aug 24, 2026 at 07:30:55AM +0000, Yonatan Nachum wrote:
> > > Changelog:
> > > v2:
> > >  * Remove the relaxed ordering device capability.
> > > v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/
> > > 
> > > -------------------------------------------------------------------------
> > > Add support for MR relaxed ordering access flag, allowing userspace to
> > > create PCIe relaxed ordering MRs.
> > > 
> > > Dana Malachi (2):
> > >   RDMA/efa: Use device ABI MR permissions instead of verbs flags
> > >   RDMA/efa: Pass relaxed ordering flag to device
> > > 
> > >  drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
> > >  drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
> > >  drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
> > >  drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
> > >  4 files changed, 21 insertions(+), 6 deletions(-)
> > > 
> > > -- 
> > > 2.50.1
> > >
> > 
> > Hi, kind reminder for this series.
> > I reviewed the Sashiko comments and no changes are needed.
> 
> It is always good to know, even three weeks after the review was
> performed by Sashiko.
> 
> Please refrain from sending new features during the merge window, as we
> mostly ignore submissions during that period.
> 
> Thanks

Leon, do you want us to resend it?

