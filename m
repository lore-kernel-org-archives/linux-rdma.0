Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C745041C;
	Tue, 29 Sep 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708594; cv=none; b=h7xYW3OHSKCljW3rw5kMDV/njjijWg7Os+M0knutkZ/TqsOQh/kKgNAPEtknxC/tcqxMQm4RajYYwd8ixrAz623Yh+0fRhyJc0ij9jWjDYZh0ROr+2YVZ9jUbvmjQSjGGEU19kyw10jgfe8/NwDtT7QyZxERrdbyIlCbMRMUAWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708594; c=relaxed/simple;
	bh=nhy5+dvlZcZLEGysnu/+lmDgQmWRQMyxJVGX1aaN4Lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKFDNCyqFNxb4fTYpar10rcFpTaSwK5dIqcfiv6NQldQfAiyLCzClPuOQIP/ULtwgcHZq8/YQPYjooId7xFZxQcpZGtTkvnRwxbN4ydQak0HjraiUkcLCdDkXfrnTws5h6br3fDIGte3UoIFeo9KGEyUNDgA2meNcVE9pYgG68Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+gBAYWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+gBAYWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DD71F000FF;
	Tue, 29 Sep 2026 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790708592;
	bh=/zWlnzUlPghRREx/QGtTaBt1y2emD+xRsU9R/Td5KSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A+gBAYWv/fIQDy3IwSCUFNKd+lzjrp6bF2IXM0vjDdprBPNjvtj6ci/zDq4MPsY02
	 fVPXLoGqV2yyJ1YOfSqkXZn48J1pM/5fd3brjvndHLk+hPRKxzkWyg1KFcyXTu1PPq
	 Q34bmeMZLseJpVjocBl8n5n1INm03C6dlAjRSkysufIYzc7B52B8gxRhKWmUkbgjHv
	 qHdSOy88g32k85+6wiyUJCAcCNLQTa7MH9YSDyWemrqVbXuTa/IF/nKSozOmcyMEGj
	 819tBtjebpWm8lBj94jMTRATB+//i5vhZ+JqK5QbiUYlOf6d+L0KM95Qa6FrMvIQuY
	 l5nWODLuamnNQ==
Date: Tue, 29 Sep 2026 22:03:08 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiale Yao <yaojiale02@163.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Matan Barak <matanb@mellanox.com>,
	Or Gerlitz <ogerlitz@mellanox.com>,
	Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx4: Do not allow the user to write to the clock
 page
Message-ID: <20260929190308.GM563127@unreal>
References: <20260926111150.3197004-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926111150.3197004-1-yaojiale02@163.com>

On Sat, Sep 26, 2026 at 07:11:50PM +0800, Jiale Yao wrote:
> mlx4_ib_mmap() maps the internal clock page to userspace through
> rdma_user_mmap_io(), which does not restrict write access. Userspace can
> request PROT_WRITE directly, or upgrade a read-only mapping later with
> mprotect() because VM_MAYWRITE remains set.
> 
> Reject VM_WRITE and clear VM_MAYWRITE, applying the same read-only policy
> as commit c660133c339f ("RDMA/mlx5: Do not allow the user to write to the
> clock page"). The rdma-core mlx4 provider requests this mapping with
> PROT_READ, so its existing behavior is unchanged.
> 
> Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 7266a6141944..6646a2633511 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1169,6 +1169,10 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
>  		struct mlx4_clock_params params;
>  		int ret;
>  
> +		if (vma->vm_flags & VM_WRITE)

It needs to be:
               if (vma->vm_flags & (VM_WRITE | VM_EXEC))

I fixed it locally.

Thanks

> +			return -EPERM;
> +		vm_flags_clear(vma, VM_MAYWRITE);
> +
>  		ret = mlx4_get_internal_clock_params(dev->dev, &params);
>  		if (ret)
>  			return ret;
> -- 
> 2.34.1
> 
