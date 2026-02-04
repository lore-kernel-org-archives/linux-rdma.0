Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2B13AEF34;
	Wed,  4 Feb 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227206; cv=none; b=FXIlXl90BZp6aVdxsUeindl2YNjAjs2BD4qQRIB57Juc+6jSHbiy1ZWxQmejJC//utbyOrjyB7QeAdURU+6mjSAyZREJZh5O35K4xRfK67fLpOqkP0hdPo2LYc27Dfh3jdqu4kCizEOOu37tSDdFJBCUfZddOh8sYSOf0FdP4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227206; c=relaxed/simple;
	bh=FMpw7MCRAxpI19L4sGevw2nu0PxGdX+AeHvLnk4cicI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6ycxXMZOep0IPWv6PtUtd5h9h+xPI4gtL2H/6EtGGL7h3XAO1WaXE6MPvx4FY0Ke3cgaUODty98p/uABDaXz+qumEOVcULjtcHJJxdbNh7BmRsIGlDjTD6LY/Z/V2OC+7e2jSP8wOzLAOC1neemg5PL6oWCBVm3SRjDADCRDJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzkRWBw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzkRWBw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB82C4CEF7;
	Wed,  4 Feb 2026 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770227206;
	bh=FMpw7MCRAxpI19L4sGevw2nu0PxGdX+AeHvLnk4cicI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jzkRWBw5SRTHOnH2WrKCixE194N9KteMRjsWqxVBh77I2GYd4fIfzp+bCnNG85nxP
	 mIoPqkXKBv5WrAzFq3HjkaL19vBm2oeao367b+NzYTxEk1UEBtWpEy8ivuTxRo0SG+
	 mVLItx4FeEsI6cqoFa+VzasG5xvYzOuJ4Ng2W8MiXmL0VTajKTXPgN83SjcIKEwtvW
	 8GbMjn0zlR1Jm2eD9vrYSVuo3us4qQPR8BLpNY9O8OxMBKccja2gjnJk+RR0j0wobv
	 hpq+UhtMsbl39u80kZN0BiUNZq8hrOKqle/SvXeJL08Cs1jIZHcyzv6V8oJlxlykSZ
	 kXPoQuHcRuO2g==
Date: Wed, 4 Feb 2026 19:46:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Konstantin Taranov <kotaranov@linux.microsoft.com>,
	kotaranov@microsoft.com, shirazsaleem@microsoft.com,
	longli@microsoft.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next 1/1] RDMA/mana_ib: return PD number to the user
Message-ID: <20260204174643.GA12824@unreal>
References: <20260204135813.870538-1-kotaranov@linux.microsoft.com>
 <20260204142827.GF2328995@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204142827.GF2328995@ziepe.ca>

On Wed, Feb 04, 2026 at 10:28:27AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 04, 2026 at 05:58:13AM -0800, Konstantin Taranov wrote:
> > From: Konstantin Taranov <kotaranov@microsoft.com>
> > 
> > Implement returning to userspace applications PDNs of created PDs.
> > Allow users to request short PDNs which are 16 bits.
> 
> Why does userspace ever need to see a PDN? Please justify that in the
> commit message

Probably for the debug and we have restrack for it.

Thanks

> 
> Jason
