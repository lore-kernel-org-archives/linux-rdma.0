Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E362F1FC9;
	Sun,  5 Apr 2026 19:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775416967; cv=none; b=k6F9ThL71OZ89MmHNKjCyuXqarlItt5Z/mBV33dnlfqHlFpOFmC5UNJdJFtLSu++5ZiscCvGNxIlfnQmE19ZfwwITndJoviRsOlMvI8SZQjQqt/hNQD3Q8n/Wu2j5K8/S5cQBbIbCFSplb3KHAF4dJ5s9SI0DGeG0k2vRxlRQUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775416967; c=relaxed/simple;
	bh=zlGVdjZym/ggnuiF/r1Dn/kupJT9wsr/28GKVLVmXfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMtWpj4zhjx/iYU9tzMSvQkbxKHY52gbKhYGDhqyPKhfdAiyyUmRFU2r8U5d4UKUXGF9hEjXxQbw3EM+eJ6lWFPVVYdWImuyhJ9TUOpSApufDbuuOhucchJp49fYlsAC+XBHQbkvgrjPobsb9+FMBt8+zBfVmyJx7CmPVOTW7iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIZGY7YI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIZGY7YI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2D0C116C6;
	Sun,  5 Apr 2026 19:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775416967;
	bh=zlGVdjZym/ggnuiF/r1Dn/kupJT9wsr/28GKVLVmXfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIZGY7YIM0+ZuTqKW/8MlP9fmsyUfrOqq8oLRIksCPr1kFwQX7/PHn91qnwpGqch/
	 B3GG4BlYZXaOpg+s2pZOTRuJOB8d0Sego5EiNVm0uDqViOIURRJQmpuYJcKGreV047
	 xG4/YbU8M3MpAX+s6GDkR3aDdxUxLUd79nWX1Nk7u5msSfwoKFi7X35sPPpo/Gp16u
	 OfEO7cVtHCONCHq4KkE9DsdkeFZ0VQ6MAPlSmiOuqtmkASxlOOVM5kNRBa7ls3BPW3
	 xioNBk17jvw87KepOQahdJnfrr287gZeoS27/urixJ/WDXhEH6BBxdteSLJi5V48dc
	 36rmnMWLTeu0w==
Date: Sun, 5 Apr 2026 22:22:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, haggaie@mellanox.com,
	jgg@ziepe.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/2] Fix loopback leaks and return paths
Message-ID: <20260405192244.GD86584@unreal>
References: <20260404230759.15131-1-prathameshdeshpande7@gmail.com>
 <20260405130924.18901-1-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405130924.18901-1-prathameshdeshpande7@gmail.com>

On Sun, Apr 05, 2026 at 02:09:21PM +0100, Prathamesh Deshpande wrote:
> This series fixes a return-value bug in the transport domain allocation 
> path and refactors the loopback enablement logic to resolve reference 
> count leaks and premature hardware deactivation.
> 
> In v7, the patchset is split into two parts:
> 1. A direct fix for the return-value bug and mutex initialization.
> 2. A refactor of the loopback state machine to ensure symmetric counter 
>    updates and correct hardware toggling at zero-count transitions.
> 
> The split allows for cleaner bisection and separates the immediate 
> bug fixes from the lifecycle improvements identified during review.
> 
> Prathamesh Deshpande (2):
>   IB/mlx5: Fix success return path and mutex initialization
>   IB/mlx5: Fix loopback refcounting leaks and premature disable
> 
>  drivers/infiniband/hw/mlx5/main.c | 45 ++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 22 deletions(-)

If you want this series to be taken seriously, please submit each new
revision as a new thread, rather than replying to a previous one.

Thanks

> 
> -- 
> 2.43.0
> 
