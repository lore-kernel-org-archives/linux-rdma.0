Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0825A9443
	for <linux-rdma@vger.kernel.org>; Thu,  9 Apr 2026 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775759835; cv=none; b=QI5PrOngv1hooFKdMNEYeqozxE+pAP2L+yXFJPygrSWnqrk+ErSabcDCbrbK519rF0QgUViXGn3h6xq72VTCujHPjhcnneLgbZ+VWrQCPJtaLkz2841CsYjYXDFvkkTGK9mPjrxqCPpduNuTcMegdRNHrGTn5LN/+O7RvsL8vZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775759835; c=relaxed/simple;
	bh=xEeqe5Dlav2jGn9/ikM3OaDN8wWqh5ad1IBSYlxjn7Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ShBNR9QxcFjC80rsyzvSlRDbkMagWmEShxPHS/oKh+Ig00+oO9VecLPPzHxhF7ZELUp/d1mZkq83vWylGHiOlQlvL7BwRJuBctgxoxn8hZtaFis4tTkSD89L3pUzgsVj1VQqgPr4Xf9APtOOAs3wL4hd4DkBWyZeC0x3V2/7ICA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=XqW9GZQm; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="XqW9GZQm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775759834; x=1807295834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UM1LrM124tJ8nwOzS184pP0GGP8MpnlobEb7PuK6Nhg=;
  b=XqW9GZQm51qnDxhW/nXxryW7yc5ACk4KTP3kjP5lI5YGrvsFVM0l+/fa
   AXgs5RlFxavNnPcjM7Qf19OLqMBvjpXbBlvhEv7rm78sS7Ys3LxKUqWXQ
   lxKqVt3VBe1LvmWojZAOF9k8PIUJ/i1IHOBhFEGSlQal/is6oqq1EvVtx
   Giz/ZiWufvfukPFyyAjYu1VAqYLW268ElJWhinRN+jVLDSnMGAU3bW6DR
   rtIhvK0MQDEI4Z/nhq6v603yaz1bUkewVTJLxhHIabSxcoaWs19dKc1Ld
   72tUYWw2TrX5R0o9E0qTX1rhvkBLkWkB2Jy4Pzr/1FAzT9uall7MGupOR
   A==;
X-CSE-ConnectionGUID: xudm2GMmQCCpTeqEgsjuoA==
X-CSE-MsgGUID: jVhGR5KEQoeKbB2LZtjupw==
X-IronPort-AV: E=Sophos;i="6.23,170,1770595200"; 
   d="scan'208";a="16939052"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 18:37:11 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:17406]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.68:2525] with esmtp (Farcaster)
 id 2d7eae16-e41e-454f-a8a0-d2163f6f9adc; Thu, 9 Apr 2026 18:37:10 +0000 (UTC)
X-Farcaster-Flow-ID: 2d7eae16-e41e-454f-a8a0-d2163f6f9adc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 9 Apr 2026 18:37:09 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Thu, 9 Apr 2026
 18:37:07 +0000
Date: Thu, 9 Apr 2026 18:36:59 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <leon@kernel.org>, <linux-rdma@vger.kernel.org>, <sleybo@amazon.com>,
	<matua@amazon.com>, <gal.pressman@linux.dev>, Yonatan Nachum
	<ynachum@amazon.com>
Subject: Re: [PATCH for-next 1/4] RDMA/core: Add Completion Counters support
Message-ID: <20260409183659.GA30050@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260407115424.13359-1-mrgolin@amazon.com>
 <20260407115424.13359-2-mrgolin@amazon.com>
 <20260407141731.GC3357077@nvidia.com>
 <20260409160007.GA24340@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260409161357.GL3357077@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260409161357.GL3357077@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Apr 09, 2026 at 01:13:57PM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 09, 2026 at 04:00:07PM +0000, Michael Margolin wrote:
> 
> > EFA actually has a single counter object type that can count all events
> > as you suggest here, but I chose to define a single container for
> > success and error completion counts in core for three main reasons:
> > 
> > 1. Consistency with userspace - we usually have a 1:1 mapping between
> >    rdma-core and kernel objects.
> 
> Well here we would have two kernel objects right?

In this patch it's a single kernel object that consists of two counters.
If I understand your suggestion right, we will have a single rdma-core
object backed by two kernel/device objects.
> 
> > 2. Although the UE spec does not define HW interfaces, it does couple
> >    success and error counting.
> 
> It's just counting, it seem slike the api is you get a counter and
> when certain events happen it counts. You get to pick what incrs that
> counter.

They are pretty aligned with Libfabric where completion counter is a
pair of success+error.
> 
> > 3. A single object for success and error completions gives more freedom
> >    to device implementations. For instance, it allows optimizing device
> >    HW resources by implementing the error counter in a less performant
> >    way.
> 
> This can be done anyhow by choosing fast/slow counters based on the
> requested bits to count. If userspace requests an error only counter
> it can be routed properly.

Then we might need to specify this early during creation to allow
certain optimizations.

I'm ok with your suggestion and agree it will simplify things on core
side but want to clarify that it might have a bit higher demands on
devices. What do you think?

Michael
