Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5342434408;
	Tue, 22 Sep 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086018; cv=none; b=UX6IaT/EBS679bmH3aY6zVFZP3OBnHP8djuqaiH3hBNIWvOL6lfz4t7jZsg/Jm+Yu2gPiplCIemzHvdZi56aDYUua6N8rYA7lijdMlj/rNhMlsFIBdh0kPPVhB4HUIgYjFjA3Pw/xgWP7rQYDHUKcJi7h3AnT2AUiq5KHZLCFOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086018; c=relaxed/simple;
	bh=Ab6VLiURMeVmj2kT0Pnx0Vi0Cryu18twXpKjCl+8eyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuOld8xoWA777Y4zFKyuHI64Y7VR7ZbKOwYfuq8UgGWt/a7uSHhzR/rKkWwnlIj738Te991DMZQBqx2T9wNB/6Y4qsnwMZQKOKT/zVBJN43on2fR58BfsDWQsivmeuEeeX0IyQnPHrZbgsRe7gr0/U8/FUb/HRCeFEqiuFUAv1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Te7BBp7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Te7BBp7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB31F000FF;
	Tue, 22 Sep 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086016;
	bh=zGOdSloDA68Nekx4bjuhH4FjzDmUEr+Zb1RVHTBtpk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Te7BBp7pxZ05tJUGL23/L547RbXBTMwPTtziJ69d+9pNqzlI579Lqx6j1TD2b9PLz
	 xMNCT1bvIAloC5njtuY02/MfVR+6YVrcJPHmGex58wXU3kD2lKzuC3DGlNYqPNZsT4
	 oZSxvu7LoJbMaHmTsv90nujC4b4lO2VKwgvY4hqLJgZbk8pLFYIH9GGj+t9kobXohQ
	 wIU+x/5MR5RTIoXtWYEETeYGqiiThGgV+A4g/3p8CQfdOJ6cz32Uzu+vWT/RQmnZiE
	 CrJ0RL2maBv1oAqaWqfngPgxywZsCPU6tm6wgfgav3Q97cuVEws2IgWWYgWWh7gNrg
	 tPHlPq5U64Zfw==
Date: Tue, 22 Sep 2026 17:06:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com,
	jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next 0/5] RDMA/mana_ib: Streamline kernel UD/GSI
 posting and completion handling
Message-ID: <20260922140651.GJ563127@unreal>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>

On Wed, Sep 16, 2026 at 06:48:30AM -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> This series updates the kernel UD/GSI work-request and completion paths in
> the MANA RDMA driver. The existing completion path copies CQE information
> into shadow entries and then walks the QPs attached to a CQ to produce
> work completions. This adds bookkeeping and a second pass over information
> that is already available when processing the CQE.
> 
> Generate work completions directly from CQEs and the corresponding posted
> shadow entries instead. Keep only QPs requiring software flushing on the
> CQ's error lists, and use the caller's remaining completion budget to
> retire their outstanding requests. The explicit GSI send-drain path adds
> the QP to the error list and invokes the CQ handler.
> 
> The shared GDMA SGE writer and explicit-index doorbell helper are included
> with their first users so this series does not depend on a later GDMA
> change. The WQE definitions and polling context also provide groundwork
> for a separate kernel RC series; RC posting, PSN/FSN processing, hardware
> error-CQE handling.

I read the commit messages, but couldn't find much information about what
you are doing or why. They only describe the implementation, in AI prose.

Thanks

> 
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Konstantin Taranov (5):
>   RDMA/mana_ib: Optimize shadow queue bookkeeping
>   RDMA/mana_ib: Revise UD send posting and WQE definitions
>   RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
>   RDMA/mana_ib: Make kernel CQ arming robust
>   RDMA/mana_ib: Poll UD completions and flush software error QPs
> 
>  drivers/infiniband/hw/mana/cq.c               | 315 +++++++++++++-----
>  drivers/infiniband/hw/mana/mana_ib.h          | 101 +++++-
>  drivers/infiniband/hw/mana/qp.c               |  78 +++--
>  drivers/infiniband/hw/mana/shadow_queue.h     |  60 ++--
>  drivers/infiniband/hw/mana/wr.c               | 141 ++++----
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  43 ++-
>  include/net/mana/gdma.h                       |   9 +-
>  7 files changed, 527 insertions(+), 220 deletions(-)
> 
> 
> base-commit: 63367df6e7255067ad6a83abe0d2799dfa491876
> -- 
> 2.43.0
