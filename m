Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DF326AC3;
	Fri, 13 Feb 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770998270; cv=none; b=Lj+jxzuAO3nVZdoT26ymUfFYDdAVMVkUvTKDq5mKoJbjXEYoBusX4f1JJSXSeA2ZJioDLEYSJKBAXvRKAtBGhPirc6iW5Q6to2rn0u6GhjfTfAbloEbFDW+7t483YQkxJ2N4YG2vj5DgdOilynH2eDg3cEpEJpnUFO/bYamm6tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770998270; c=relaxed/simple;
	bh=HvQGvbAd3NJbRP0dl8wfJtSlFFQwKsB8qcfxscFtbdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdFtTAIzpvarW6hutI5BC2iAAW1P5drTrNIFY2WBaLrR3sMMIe7kllV352OKixWYmlo7XcgJGREXpyGj8oP5r8+e3wBS8eRac5IkkCL45NB+6ERU8+hC9tcSIuewAvZtkK3i1qox6guDEgUfKebrjfhRg0Lulu71D8D9EiIgnOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hh1C8s5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh1C8s5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6A3C116C6;
	Fri, 13 Feb 2026 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770998269;
	bh=HvQGvbAd3NJbRP0dl8wfJtSlFFQwKsB8qcfxscFtbdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hh1C8s5rJiU38LVvZcurQ3B3+JlGd+a2YrirMLX10eOZ17SXeXHibI+wV6PlWEKIw
	 ORtpqXgjNA4e6kimDUX0bhD62ODIRtHPCS5fuM0PiMqMa4vrRbUNcI0qBG1Da+IXBi
	 3JKSlFu3nGbiIkk5v/L76cTjkeqcIrFzOVTiLL/1uOSukhCLlIv9b+HCD3471yrWf5
	 rM/FNH5bproPGqR0G+jC9XYb+pOC5ON6v7ZPs6spKDikQmr1iQie7F12qH8vmZNqD8
	 /kBcR5jqRH8KWCdm74p+uASx5Ttb+F6SFK0DDxLswrSoamw0VQs6piAmjHGsMMIvBr
	 vPWQkSJFkxzUw==
Date: Fri, 13 Feb 2026 17:57:31 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 05/10] RDMA: Provide documentation about the uABI
 compatibility rules
Message-ID: <20260213155731.GT12887@unreal>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <5-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <20260213102347.GL12887@unreal>
 <20260213125658.GF1218606@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213125658.GF1218606@nvidia.com>

On Fri, Feb 13, 2026 at 08:56:58AM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 13, 2026 at 12:23:47PM +0200, Leon Romanovsky wrote:
> > On Thu, Feb 05, 2026 at 09:45:39PM -0400, Jason Gunthorpe wrote:
> > > Write down how all of this is supposed to work using the new helpers.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  include/rdma/ib_verbs.h | 81 +++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 81 insertions(+)
> > 
> > Can we add these rules to Chris's review-prompts?
> 
> Yes, I was thinking about the same thing, not sure how to do that

As a start, you can put it into Documentation folder.
Here https://lore.kernel.org/all/20260212124208.187e53ae@kernel.org,
Jakub says that Chris is changing prompts to consult with Documentation/*.

Thanks

> 
> Jason
> 
