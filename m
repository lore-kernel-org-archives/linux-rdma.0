Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA98823909F
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 10:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783246128; cv=none; b=dEhzcCufCDW4qe48VhzIYMNfB0uPA/wR4lgMu6Y7tAXiA3wMnJxrMFDooTD3nJIXRK/RanUnZJqR0Rub1NEmtm/8D4+MXXsDPmHsbfvm3WqEs8JsnCLajYJiYsf9WdSruVa71wjkAaTEpxUSaxZrGnEg3u6b25N5wEXlsyVg1iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783246128; c=relaxed/simple;
	bh=k4m9rsvjiuXnCZIOK2iOlVb1R4LDgeC4bV7C8xV4HPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnpFEUwj2Tth5RnzGY1BUBMzA1v7Pvj5izphwYtiN/AQ4FzwwN04sWrltg/1i8qDtv4lpfIpzWqKR/1mtsah7+NmmU0i0F6yIN9eTDYwhOZejDCmXdx0li3W6hnV8p/LIBENe99q+21bsc7ve9LmRfk+53pe5LJdXDVTuMxVjxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXsnhgQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXsnhgQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DF01F000E9;
	Sun,  5 Jul 2026 10:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783246127;
	bh=UPFM+65RmEJH9css2laXjKTwbeCsWXaqzeuJMRMI5zI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jXsnhgQ0HId+yIT3JRnqYSOlfEtMSdn5s544DpsojoAtbxYfmmaaiaogRs9++ZkUr
	 zKkd+Zvm7O9Xl1SC0rot0YZFapCO71s+OV0/II2v49SUZf9dOVtxLO9KdY5U7wQFkI
	 aSVQndeW7GCS4LCNNCSDEjjw1CzCnDzimkMZnrAZIrkS5gks/cq/mWtNdJYIPugkWQ
	 MrJCzTKUJ8ppYFXLaWETjyQyCAmkZTCxVd9bwyrwrCjN3R8kiV/juyk8ZO4LBerpwE
	 j9laUqymr56Cn3kdQUOFWUcwEi40v4qTf4at8/FOxBUfLJOHMtTAHUIj2hnTRtVKD3
	 9p/r1bA/+MVOA==
Date: Sun, 5 Jul 2026 13:08:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Boshi Yu <boshiyu@linux.alibaba.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com
Subject: Re: [PATCH for-next v3 0/3] RDMA/erdma: Add DMA-BUF memory
 registration
Message-ID: <20260705100841.GA15188@unreal>
References: <20260618045120.51210-1-boshiyu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618045120.51210-1-boshiyu@linux.alibaba.com>

On Thu, Jun 18, 2026 at 12:51:02PM +0800, Boshi Yu wrote:
> Hi,
> 
> This patch series adds DMA-BUF memory registration support to the erdma
> driver:
> 
> - #1 renames get/put_mtt_entries to erdma_mem_init/uninit to better reflect
>      their purpose of initializing the struct erdma_mem.
> - #2 introduces struct erdma_mem_init_attr to pass parameters to
>      erdma_mem_init(), improving code maintainability and preparing for
>      DMA-BUF support.
> - #3 implements erdma_reg_user_mr_dmabuf() to enable DMA-BUF based user
>      memory registration using the revocable pinned dmabuf interface.
> 
> One known limitation: if the DEREG_MR command fails in the revoke
> callback, the driver can only log an error, since erdma does not
> support a function-level reset like irdma's request_reset() yet.

I hoped someone would comment on this. If revocation fails, the
hardware may continue accessing memory that the system considers
released.

From comment:
 * When a revocation occurs, the revoke callback will be called. The driver must
 * ensure that the region is no longer accessed when the callback returns. Any
 * subsequent access attempts should also probably cause an AE for MRs.

> We plan to introduce such a mechanism in future work.

That mechanism needs to be included in this series.

Thanks

> 
> Thanks,
> Boshi Yu
> 
> ---
> 
> v3:
>  - Patch#3: Switch to the revocable pinned dmabuf interface as
>    suggested by Jason Gunthorpe.
> 
> v2:
>  - Patch#2: Add validation for the return value of ib_umem_find_best_pgsz().
>   link: https://lore.kernel.org/all/20260518120637.16831-1-boshiyu@linux.alibaba.com/
> 
> v1:
>   link: https://lore.kernel.org/all/20260507053437.46211-1-boshiyu@linux.alibaba.com/
> 
> Boshi Yu (3):
>   RDMA/erdma: Rename get/put_mtt_entries to erdma_mem_init/uninit
>   RDMA/erdma: Introduce struct erdma_mem_init_attr
>   RDMA/erdma: Implement erdma_reg_user_mr_dmabuf
> 
>  drivers/infiniband/hw/erdma/erdma_main.c  |   1 +
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 262 +++++++++++++++-------
>  drivers/infiniband/hw/erdma/erdma_verbs.h |  17 ++
>  3 files changed, 201 insertions(+), 79 deletions(-)
> 
> -- 
> 2.46.0
> 
> 
