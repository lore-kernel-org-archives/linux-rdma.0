Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4133E023E
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 08:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190580; cv=none; b=CSTd4lF8O20gbe1YVBXCvWsuiDExs0Ptgxj2X5ZBqIV+ViYw/5SL1BXA5d19eQz5ybjbnvP6QoXOjFQeghnRHG052WLkt8c2Dw7TNbpEClfatcVNJIGw1xpEYmwkRMrnoXJqkB66jZSI6j58F4NpYs26NARzFELp6sSRfwyK8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190580; c=relaxed/simple;
	bh=e2hvFdm0Hw4Ak9kfR1ipcVfTicVokFl6sE2LDdeLcQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJDvMjOfShJJr6ULE+jZr+W6ko8Z35+7Ea2dQerKUmYLIuzu/oi40Ebf/OzA2E/AOfbxEDJ0hD2cYPBhXPz5/FTFtoyUQjGurglveJUKqBkP6Uq+G/1ADVL//85c/2DMpzOe8PrGNpTCxJenz1kE5XUSD6DCmPJqNRJ4kKe5tW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwd2vaF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwd2vaF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CE51F000E9;
	Thu, 16 Jul 2026 08:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784190579;
	bh=d7wvA4lxw+og79HUyAcWK3sODR5pGlJfUOAmer1mla0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fwd2vaF52NFXi5fV9Ka89aWNeKcwxynA0hWGBrsM7F05bMDWuttPfCOMJAMQke9Jw
	 Lf7POAv+yCi+773On4VNCoVEpz6r6V7HpzhxnIowr8LsN1YOmGBZ2rSsery9xPKHs/
	 SkjKIvTGofYv/4FWsQChihVNqS7Vh6BBWWqYRWsTYg+VhsCf9ny2h2X7F0fAFgsJ0o
	 wgf8mbW+cZ20bPSf5pMatuJ3yzDWdQGhLnST6v9inooOrjg/ipSSjqjqQlGovMo98N
	 HRoWMv6Wf0kbfCMlrpIvOJP1fvz7ieNoTUuSvBBYjOtTyQGCzYsPoTFiHytjgL48gu
	 1tSe9ACl+aUUQ==
Date: Thu, 16 Jul 2026 11:29:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next v8 0/5] Introduce Completion Counters
Message-ID: <20260716082934.GB70906@unreal>
References: <20260707203427.6923-1-mrgolin@amazon.com>
 <20260708123640.GA9082@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260715073958.GA21197@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715073958.GA21197@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Wed, Jul 15, 2026 at 07:39:58AM +0000, Michael Margolin wrote:
> On Wed, Jul 08, 2026 at 12:36:40PM +0000, Michael Margolin wrote:
> > On Tue, Jul 07, 2026 at 08:34:22PM +0000, Michael Margolin wrote:
> > > Add core infrastructure for Completion Counters, a light-weight
> > > alternative to polling CQ for tracking operation completions. The
> > > related rdma-core support is linked in [1].
> > > 
> > > Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
> > > modify and read methods for both success and error counters. Add a QP
> > > attach method on the QP object to associate a completion counter with a
> > > queue pair.
> > > 
> > > Add EFA Completion Counters support as first implementer.
> > > 
> > > [1] https://github.com/linux-rdma/rdma-core/pull/1701
> > > 
> > 
> > Walked over Sashiko's comments, most of them are about usage count
> > which is handled in a follow-up patch in the series. The others don't
> > seem to be real issues.
> > 
> > https://sashiko.dev/#/patchset/20260707203427.6923-1-mrgolin%40amazon.com
> > 
> > Jason, Leon do you have any other comments?
> > 
> > Michael
> >
> 
> I need your feedback on this series, specifically on the ABI changes
> (and libibverbs), to unblock progress in upper layers that depend on
> this support (libfabric, NCCL).

We are primarily waiting for the relevant rdma-core PR to be ready.

Thanks
