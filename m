Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.1.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105594;
	b=OJTVyrfdGbVOie/duKGfUbIVcQ1gtQgW2WOBgqOABWYA0zy0MJJFZrp3kZg7mGif4fgT
	 lKsH0fwUSJ/Htg3//vqSNXFq5RWgWFkd2zQW6Gd4QGds7K2wibUMvZIxDHd1kGHYUIz2n
	 9T2+tGd1Ybd+FCa+/6ixkShwuGZwr7EAF94F8uA94vf5Ll5hzd1esLnnrnWl5+BVnBYJF
	 o24Y1JNHjW7OPSd+5oil3TE4HbC5VL9VHgOghB997TZvptaYKaUgPBWtsu2A5tlDvfQR6
	 6BFHhPOTPN9G1QYAMRvu3VsS9IM7qoMBqlF8k55pkXFdYYssxYXalR2+z43pRtMHU2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105594;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=gPgbW/BuctYysxO95YTVnB3oz509PtsasvmL7Et8Bh8=;
	b=EwxYmjNqaSQnlvZbRpEIffvvrcbmyJnkdcS6G5wBqDbd0q1Qs/ztTxicGrxwtmed7MYE
	 AouUOlTIsRxjiBe+Iii/AprLkvvYBtL3gxDlfkMZvNWkS7txQEn2CwfC92sp3+AeHSDni
	 aCbTKQQgVxixOUGZtAqILh4L4yU36tDLEdfi6REDDswUfczuz3KbcXC2enEAz10iccDC1
	 STMbZ+SL9xKm2eGdn4/sCfIV8UTnCNzy/Tz6dHyoic0+auWbxCyUHplm9vouhmBSJsotc
	 lgYC8p37L3TaawvCXs9xux3Bx5ygmGnr55XhcyPLNQhZgj7g9wBCjPXjLzCUNY2dnaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=cZvtGjyw;
	arc=none smtp.remote-ip=44.246.1.125
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3785606A339
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 16:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3785606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=cZvtGjyw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795105593; x=1826641593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gPgbW/BuctYysxO95YTVnB3oz509PtsasvmL7Et8Bh8=;
  b=cZvtGjywIzHr0S2fgCOcSK3OV+desIDQblF6wB7rumBOLbWWcikPCAAJ
   I2t4jlXy4i8CPnCJzYnr0UPjwf1nBo6tyDHEvX5Sk3swIfOGBocOlbdg5
   TkGxQp0KZehzZTtLcWfQbVcS/4eckXPppYcenE7J7nOZSzDIioi8nyLz6
   aYvXc8KmhbmI/XxAfe9RUEFwSA3/tsRFbnk5uafHSG0MTptlZI3ALN6YF
   GvfYpRebTQ7W5/LCYviMc1MUWjprcIeRN41WrGof0dYoLbgWQe9KnPCmL
   TgpV38B5zLRrKFzs3uahoEkUCReUI+N1WUn1DaD3f/hbicX4ktnbwuJ0+
   w==;
X-CSE-ConnectionGUID: oVlzZahWT3i5RwdOTvpOOg==
X-CSE-MsgGUID: UEJ03pyERFOU1volhW67xQ==
X-IronPort-AV: E=Sophos;i="6.27,221,1787011200"; 
   d="scan'208";a="34578483"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 16:26:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:8932]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 687d294d-5574-4d39-b346-857934f45a26; Thu, 19 Nov 2026 16:26:30 +0000 (UTC)
X-Farcaster-Flow-ID: 687d294d-5574-4d39-b346-857934f45a26
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 19 Nov 2026 16:26:30 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 19 Nov 2026
 16:26:28 +0000
Date: Thu, 19 Nov 2026 16:26:21 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Ilia Kolominsky <ikolomin@amazon.com>, <jgg@nvidia.com>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261119162601.GA4902@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261116112913.GI11319@unreal>
 <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261117125325.GE124972@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20261117125325.GE124972@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Nov 17, 2026 at 02:53:25PM +0200, Leon Romanovsky wrote:w3esq23

> On Tue, Nov 17, 2026 at 08:18:50AM +0000, Michael Margolin wrote:
> > On Mon, Nov 16, 2026 at 01:29:13PM +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> > > > EFA Completion actions let an application observe work request
> > > > completions without polling a completion queue: when a work request
> > > > completes, locally or at the remote side, the device performs an action
> > > > that the work request names, such as writing a value to a user buffer.
> > > 
> > > Why are these verbs EFA-specific? This looks like extension of already
> > > generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.
> > 
> > It is indeed an extension of Completion Counters, and later we plan to
> > connect the two by allowing a Completion Counter to be used as a
> > Completion Action, but unlike counters, actions mostly matter for
> > unordered transports where a completion count alone doesn't tell the
> > application which requests have completed, so it needs an efficient way
> > to track completion of specific requests.
> > 
> > Do you think these semantics can be useful for other providers at this
> > stage, or can we start with an EFA-specific interface and add a common
> > ABI later if required?
> 
> I think the idea and implementation is general enough to be picked by
> anyone who will decide to implement it later. Let's do it in common ABI,
> please.
> 
> Thanks
> 

Ok, makes sense.
Please see libibverbs API suggestion:
https://github.com/linux-rdma/rdma-core/pull/1865

Michael
