Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9ED2135AD
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 07:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704922; cv=none; b=MJr7+kgDuqHgI76RwJc/0Z8UZNjPMC8gDQwOlWNNCRSnh+XmAYF0h1v0OzeTttZ8CFsg6wXWOfGeLUIf9tfwcRcpSXXbVi9cXHDLlSsDW1HjqHisCea6cxj3x8qgK68LNfV506Sl8thEzSwFZ1ig2heIfgkbpLHnktZ1Ea9xoyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704922; c=relaxed/simple;
	bh=Sug++nzqPHSkL9VQ/Yeq0z8fUji8cwEw0dDmUFFZGT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEQgFqfEKpA6H59s1YnBeTvwHztYOAG/OLzbvwEi/44323AMNCL1Bm7Ppy7FjPtIjiLdmKlxuwrc8JGHMD98J/0D+l+EFuOtCNxjiEQqzePWKPTJI7vyJNi4hSnVUiwvFWeSnLZYVmyLtX1Sp6rnGqmcNC0hLTFqauT+iCeC8SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5Ii5JMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5Ii5JMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1EE1F000E9;
	Wed, 22 Jul 2026 07:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784704920;
	bh=mIWPOnsY6L5Rv8xd6WrwWxF1TeWY7vsZBsIXC76Uiqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H5Ii5JMUV82dPNoFIVueXujdrsRd5BAjFofycH+6iq2EJDhvYuVM/OPtaSNZwtYNX
	 Y2Doc2fHwhzg9B/xaFSwS9GYTuB2L00+kAd+5ZlOK/EbwsjLUwD+PBBXOcax70TXLn
	 dn9JyCIG+udCYZLlrf8tXvtC2L93paE7J+b4VYJ86eKwcS4pm6YG2bsDOdVxOF5IE6
	 3YjT+vAhe9MkRui17ETeP/ikJeRYQz4sdpWyUyBb9gjQ8ObowJw6zhApLt839mUQOl
	 wS+Gi9tBj3wOcffC9n+/qvyoAUWlBI/1mJEFCBYBIzTAH/xHrbRm86m2bJvW5t38rm
	 gXBGZxg2MLgZA==
Date: Wed, 22 Jul 2026 10:21:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Timothy Day <timday@thelustrecollective.com>
Cc: Michael Margolin <mrgolin@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	linux-rdma@vger.kernel.org, Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>, Marco Elver <elver@google.com>
Subject: Re: [PATCH v1 0/5] Support Clang context analysis for RDMA/efa
Message-ID: <20260722072156.GT110966@unreal>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
 <20260721111030.GH110966@unreal>
 <20260721202734.29592-1-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721202734.29592-1-timday@thelustrecollective.com>

On Tue, Jul 21, 2026 at 04:27:33PM -0400, Timothy Day wrote:
> On Tue, 21 Jul 2026 14:10:30 +0300, Leon Romanovsky wrote:
> > On Thu, Jul 16, 2026 at 11:16:53PM -0400, Timothy Day wrote:
> > > Hi,
> > >
> > > This series adds annotations for Clang's context analysis to the
> > > RDMA/efa driver.
> > >
> > > Clang context analysis was recently added in a series by Marco
> > > Elver [1]. This allows the compiler to validate different
> > > locking patterns at compile time. This series enables context
> > > analysis and adds new annotations.
> > >
> > > The series was built with Clang 23 (since the minimum Clang
> > > version for this feature was recently bumped to 23 in 7.2+ [2])
> > > with CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based this series
> > > on rdma/for-next.
> > >
> > > I'd appreciate reviews and suggestions. I'm especially interested
> > > in suggestions on how we can make this easier to enable in other
> > > parts of the rdma subsystem.
> >
> > Yes, this is precisely why I'm not rushing to apply it. It would
> > be far more compelling to first apply this context analysis to
> > drivers/infiniband/core, so we can evaluate both its benefits and
> > drawbacks.
> 
> That's fair - the context analysis work is still pretty new. There
> are some examples in other subsystems. I submitted a series to
> convert ext2 [1]. And there's some on-going work in the block layer
> to enable this for nvme and other drivers [2].
> 
> > On the other hand, converting drivers incrementally is the safer
> > approach.
> 
> The annotations should be a no-op without CONFIG_WARN_CONTEXT_ANALYSIS
> enabled.
> 
> Generally, I'm looking for false positives/negatives in the
> analysis and opportunities to create helper functions/macros
> to reduce the amount of manual annotation required. I started
> with smaller drivers to hopefully reduce the amount of churn
> required for larger components. Also, core code tends to have
> more complex locking patterns.
> 
> But I can prepare a series for core/, if there's interest
> in reviewing it. We can also hold off a bit if you want to
> wait for more adoption in other subsystems.

We can try with core patches first.

Thanks

> 
> Tim Day
> 
> [1] https://lore.kernel.org/linux-fsdevel/20260712165610.366474-1-timday@thelustrecollective.com/
> [2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
