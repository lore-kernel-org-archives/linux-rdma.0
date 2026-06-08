Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF244BCAAA
	for <linux-rdma@vger.kernel.org>; Mon,  8 Jun 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780930683; cv=none; b=DdlbgrYx9kyFmqv/W+fZwc+g6y4eUMKA3zJp/SYW72ot92SH64IGnf3bmR6liuUji/5Y5DRtyVCNdfcdssscpu8e4uCrEjXdbI36sb1KLBX+vGOaw+SL55HOiJvkE8kX4WIDueU+3bQaMAaMUUds8g7CW5zJId8bKQmGWxg9oQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780930683; c=relaxed/simple;
	bh=cYIYMH5YH93nvU4CuCBDolRm7nVT6PzjRzI67BbU3w8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoQ5TFH0yBgFrKQnuplOcvKgMG8XWAoUnWu6sbYJgzBCiMCM/j+yidWDk0cRICSUQfkvix55eyfX10V9ktHTVNe4S7df1aRLsQktYl29lUQZCyMBRCSE+aVaxoGniSl3lXBhvyPBr3d7OBl8myKCfjC5JHmsvozKSHZsFsgthy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=WOE3xm8j; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="WOE3xm8j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780930671; x=1812466671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6PoXcfYxuLbrgNeCBWZTGVAPRxY3J+cCU8MJULSX2VY=;
  b=WOE3xm8jiy3PhEnOSw+QLZjbTEJo2QI6QlDIwJwrl9BhfotHyUgJnp2l
   9L6eyugPCGwGj2OZhIJNAa4V80u6we7Oe+JkHAqewZL17yUTCeLDx5UYj
   bPdX/Foa7xS2cYHul89DZB7CSHEPY1hddNx4hKhLE0AB+H7/ozJ6z7lTV
   VDuaiEs7AinFumIkCHknoJXAxYvNKrEGZ9Mfiwk1B/lVANzCknQBelTBt
   UlD3ioc7xSbyf9lp1SlgKup3a+Burz8yV/DlnGSM40S5N9tJgdCFtz3qk
   4w+TEsIClBKZpqEZcZa5Mrz/kU4dN3QvnpItZS82ef8AyYYOFAU4FSxkG
   Q==;
X-CSE-ConnectionGUID: 15soStjVQ8qiSbWHclKS9A==
X-CSE-MsgGUID: Uut3Xu8HR7e3zxvI2KTHpA==
X-IronPort-AV: E=Sophos;i="6.24,194,1774310400"; 
   d="scan'208";a="21202017"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:57:47 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:12060]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.145:2525] with esmtp (Farcaster)
 id 0d4ef7ef-202c-42bb-bbe2-5880d0b39f17; Mon, 8 Jun 2026 14:57:47 +0000 (UTC)
X-Farcaster-Flow-ID: 0d4ef7ef-202c-42bb-bbe2-5880d0b39f17
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 8 Jun 2026 14:57:47 +0000
Received: from dev-dsk-tomsela-1c-ce9cc34e.eu-west-1.amazon.com (10.15.30.17)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 8 Jun 2026 14:57:45 +0000
Date: Mon, 8 Jun 2026 14:57:38 +0000
From: tom sela <tomsela@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <mrgolin@amazon.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Yonatan
 Nachum" <ynachum@amazon.com>
Subject: Re: [PATCH for-rc] RDMA/efa: Propagate destroy AH error
Message-ID: <20260608145738.GA43925@dev-dsk-tomsela-1c-ce9cc34e.eu-west-1.amazon.com>
References: <20260526073334.24905-1-tomsela@amazon.com>
 <20260602002223.GA644685@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260602002223.GA644685@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jun 01, 2026 at 09:22:23PM -0300, Jason Gunthorpe wrote:
> On Tue, May 26, 2026 at 07:33:34AM +0000, Tom Sela wrote:
> > AH destruction currently always returns success, ignoring any error
> > from the device. Propagate the actual device error so the caller can
> > handle failures appropriately.
> 
> Callers don't handle failures. Drivers are not permitted to fail
> destroy, if they do it probably will trigger a WARN_ON.
> 
> You can make some of an argument to allow failing destroy for user
> objects only, but not like this in general for kernel objects.
> 
> If your FW fails destroying a kernel object then the device is busted,
> you should reset it and succeed to destroy the kernel object anyhow.
> 
> Jason


This code is for user objects only. When destroy is called for a user object, the core code handles the failure gracefully and can retry cleanup at a later stage.

Currently we don't have a code path where destroy_ah actually fails in device, but we'd like the error propagation in place for completeness so that if a future FW change can return a transient error, we handle it correctly rather than silently ignoring it.

Would you prefer we explicitly guard this with a check for ibah->uobject
(i.e., only propagate the error when it's a user object).

Tom
