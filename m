Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EC528851F
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 08:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733083; cv=none; b=fPTHqDbsF/Jd7gHgCb8eQH09g4UuyzdAGuxwvIA9FGGJv7o/fem/9dCXnNyEjwhrGl3HI0FhJ8PXEbYk+V7oxnDp4WSVm64ep0OHoU52vVVfcKT4VF7ECZned5SFNpTqg3aHz+hcv4vrgw15VLBPLLDbHmB3RHPVJYE/sWk9idU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733083; c=relaxed/simple;
	bh=sFC5k0vfyvHeouXldM3w12f2ecGvqslkQrBMq5h7prM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZI01F1t5GEmtRBGi/9nwQ3iO7rpvNrnZ2YZkzgK5OI1KDv4EdJbmIL+rN0B6AE4aPHkhyZVAngPTkzpFz0iXlIkMHlCPPXAu36rkq2X8FQeW6BWsp02V1qY0xvYqMf68nZvck4hHGeiTio/DRtqMvCG6CEHV+7NxSoquyjNs0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wv4+ui1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wv4+ui1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5801F000E9;
	Wed, 26 Aug 2026 08:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787733082;
	bh=rk3xhAR+Wa1i7ntCxHjrPOaWAVy5l/PI5fbJooCi2vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wv4+ui1QmEx58UdXD8DKWcwLy8/ixV+Tgxd0suEoTAdDXDDsG8dc8hKxj9OX6eDuR
	 41RV5qh1C6mzZ6TkqQXSqdPvKCqDDzKRonkqySW6TrL1QDGnYroqaa5nOZY6O0llvw
	 grKWpcF25Rb0yeecNnpOSyPSeM6oa4ycm7/0BdTEs8K3wHzb6aa0fYcG+dbgAa4yy7
	 Apgy9SRkH4vO+Vd0EHM2YwTKYMhvgdTaevqGvqWyD4iedkcNviyGwAwua+fH8JsAZN
	 d5mXjvnIAk7rJgMfjkPV5FlBn0Y1sVk5/hx/GO496Uww2swr81CpGLwq6CksbmftMW
	 BjiW/NUAhRfoQ==
Date: Wed, 26 Aug 2026 11:31:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yanze Zhang <zhang.yanze@zte.com.cn>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma v5 0/7] RDMA/zrdma: Add ZTE Dinghai Ethernet
 Protocol Driver for RDMA
Message-ID: <20260826083118.GB42790@unreal>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
 <20260822080723.3166603-1-zhang.yanze@zte.com.cn>
 <20260822114723.GB1449020@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822114723.GB1449020@ziepe.ca>

On Sat, Aug 22, 2026 at 08:47:23AM -0300, Jason Gunthorpe wrote:
> On Sat, Aug 22, 2026 at 04:07:23PM +0800, Yanze Zhang wrote:
> > Hi Jason, Leon,
> > 
> > Apologies, my previous ping was sent to an incorrect address for Jason.
> > Resending with the correct maintainer address from MAINTAINERS.
> > 
> > Gentle ping on this series [1]. I understand we are in the rc phase
> > and new drivers will likely be queued for the v7.3 merge window.
> > Just wanted to make sure nothing was missed or needs further action
> > from my side.
> >
> > [1] https://lore.kernel.org/linux-rdma/20260811093740.2607476-1-zhang.yanze@zte.com.cn/
> 
> Nobody has looked at it, you should be reviewing your sashiko remarks
> 
> https://sashiko.dev/#/patchset/20260811093740.2607476-1-zhang.yanze%40zte.com.cn
> 
> Lots of good points in there.

Jason,

The ZTE core driver was merged only recently:
https://lore.kernel.org/netdev/178598040988.599522.8462097247667886071.git-patchwork-notify@kernel.org/

There was little point in looking into the RDMA counterpart before the
core driver was in the tree.

Thanks

> 
> Jason
