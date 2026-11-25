Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.1.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624937;
	b=u6cJzuInCjnyc+d6v/1KxBByT+WnndxIOdAD0UIeGA4k7JTUoSA4FLZPoK8jNraDMyJZ
	 Rbalq5ykpT/dQN5N8eHq2KvTTOmBCF7eciJ9gZlAF/cfewoPC8DFH0tJw2FHxJgcLDFe2
	 aGAN7rnsnY4s2RilSRD5bDYXVQ+r3dhXoDmMpsryIim+e8t0tGU38+/12Bb5CfEO2dEpQ
	 MZLatRSkV3AHIGP7D+SgGwVjW4NVDEiNVLjtIO4yrr2lJwGmVuRUCX4OSypHN+dy04K7x
	 9qpsyAsuZKMFoQAluO7nlM3dqot75YZS7+azbHIkyJzDgr54NqPZJ0rBqRfMmo1vOnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624937;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=ziOhoaECYcAsdhepPTsnSBH3rmuIM4XKASbRaD5rkY4=;
	b=ud5ojQVj1jhe41Q+zry6vsWNBEwqpqviGi59jkQO85i2wfQRZ5YtZOW332/o6vAFl8gy
	 D+cAaJ2AONBkZP11ErqVH//DuHlmotES6BdCwyTWtkJNtujOkh5NM1EWZyzj2BkiPhj+2
	 G7kXmaF/Z/Fnhw6OpFMrbekLiwRagCeoPJRXC/h0fDyt0zZkYNOoa8QmMX1Yj/JJwxczb
	 FPEXRQVCxUjT6rSEnOrDUxVLcG8Nf9d7XY0GuRwnJrDeXWNsLXL4+cZiyGYwoKe5VaQTJ
	 U3/CEgNGKsqWWfR7mOBElErYJMHm9zo4+hNOAE69rao1ziLulBO7r2uakgyi1IPVDEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=NZc3oDSs;
	arc=none smtp.remote-ip=44.246.1.125
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0424606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 16:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0424606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=NZc3oDSs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795624936; x=1827160936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ziOhoaECYcAsdhepPTsnSBH3rmuIM4XKASbRaD5rkY4=;
  b=NZc3oDSsIYAFzTkmjKhum5zEd0I3vdFeKvNmTXXlfFhvepqmdY+AQ2Hk
   xpwrII5Zh6icBwoGLSLBtCSS6EEQe4kjh8f2vWpUq6ZQiIGEGE0jmY9MO
   CVqRcTxV/H9sKpaXwNgmLiUExgIR5Um6IKkHoIjXcE4G+fs2onqdxebiw
   vSpDsAOfq1A+kxWGnPXPZNHyfLDZeW3Oe6/ZhFOH1OsvH604724lx4wFT
   YXOz2bxkblgElyPhVrWwD6zRSGcCGw370oLmG7LyJR3JSRMs8IGeIVXmS
   nhcd+qcWJlV+QnVT4dthhMYDRlr4UZ7ghhbAIqUdZAk9+wNKJxli97rd0
   A==;
X-CSE-ConnectionGUID: ct+wpBkvSaqH2jP2lgbqRg==
X-CSE-MsgGUID: X1VryS1nQIOsgLll7CD9lQ==
X-IronPort-AV: E=Sophos;i="6.27,233,1787011200"; 
   d="scan'208";a="35099672"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 16:42:14 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:7475]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.48:2525] with esmtp (Farcaster)
 id 7dfe0dd4-b64f-4ca7-b391-668852874a4e; Wed, 25 Nov 2026 16:42:14 +0000 (UTC)
X-Farcaster-Flow-ID: 7dfe0dd4-b64f-4ca7-b391-668852874a4e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Wed, 25 Nov 2026 16:42:13 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Wed, 25 Nov 2026
 16:42:12 +0000
Date: Wed, 25 Nov 2026 16:42:04 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Ilia Kolominsky <ikolomin@amazon.com>, <jgg@nvidia.com>,
	<linux-rdma@vger.kernel.org>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261125164204.GA33524@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261116112913.GI11319@unreal>
 <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261117125325.GE124972@unreal>
 <20261119162601.GA4902@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
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
In-Reply-To: <20261119162601.GA4902@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Nov 19, 2026 at 04:26:21PM +0000, Michael Margolin wrote:
> On Tue, Nov 17, 2026 at 02:53:25PM +0200, Leon Romanovsky wrote:w3esq23
> 
> > On Tue, Nov 17, 2026 at 08:18:50AM +0000, Michael Margolin wrote:
> > > On Mon, Nov 16, 2026 at 01:29:13PM +0200, Leon Romanovsky wrote:
> > > > On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> > > > > EFA Completion actions let an application observe work request
> > > > > completions without polling a completion queue: when a work request
> > > > > completes, locally or at the remote side, the device performs an action
> > > > > that the work request names, such as writing a value to a user buffer.
> > > > 
> > > > Why are these verbs EFA-specific? This looks like extension of already
> > > > generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.
> > > 
> > > It is indeed an extension of Completion Counters, and later we plan to
> > > connect the two by allowing a Completion Counter to be used as a
> > > Completion Action, but unlike counters, actions mostly matter for
> > > unordered transports where a completion count alone doesn't tell the
> > > application which requests have completed, so it needs an efficient way
> > > to track completion of specific requests.
> > > 
> > > Do you think these semantics can be useful for other providers at this
> > > stage, or can we start with an EFA-specific interface and add a common
> > > ABI later if required?
> > 
> > I think the idea and implementation is general enough to be picked by
> > anyone who will decide to implement it later. Let's do it in common ABI,
> > please.
> > 
> > Thanks
> > 
> 
> Ok, makes sense.
> Please see libibverbs API suggestion:
> https://github.com/linux-rdma/rdma-core/pull/1865
> 

Hi Jason, Leon,

While moving completion actions to a common ABI, we have two questions
we'd like your input on before sending patches.

First, completion counters and completion actions are getting very
close. A counter is updated by completions on the QPs it's attached to.
An action is performed when a work request that names it completes.
Both are "do something on completion", and a counter could be one type
of action. We're looking at modeling them as one object, with QP attach
and WR triggering options as properties. That would mean renaming
UVERBS_OBJECT_COMP_CNTR and its methods to COMP_ACTION, of course
keeping compatibility. Does the merged model make sense to you, and is
a rename like that acceptable at this stage?

Second, a more general question about out-of-tree drivers. We backport
new core uverbs objects in our out-of-tree EFA driver by registering
them with the core IDs on older kernels, so rdma-core has one path
everywhere. That doesn't work once a new object goes past
UVERBS_API_OBJ_KEY_NUM_CORE, because uapi_key_obj() rejects the ID
before the driver is involved. The driver could register the object in
its own namespace instead. But then rdma-core would need a fallback:
either a retry with a different object ID, or using an ID the kernel
reports through an optional attribute. Would something like that be
acceptable in rdma-core?

Happy to send an RFC if it's easier to discuss over code.

Thanks,
Michael

