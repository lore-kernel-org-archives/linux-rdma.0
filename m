Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CDD3E024D;
	Mon, 12 Oct 2026 07:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791791623; cv=none; b=sCF77yath4/jJL/tbjopBrUa/q45lUBH6buT9tyX7Qi1tTln+oqJGrnZNe5+HGPSWtBo4GaRsIhJ/TeSMMgELmyAiSgpxbE9sJcu1WdKojZzy0sZ7HsS5VVl9ngfdE5P7qM4p10awl1O2jJjvq6zkTOucdYmXzVeg0MxBiNuCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791791623; c=relaxed/simple;
	bh=Mp3af3DUjSlGf+Yabe6tfJyxoYJfVX7iuIoKxqEbOVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7EX9JFEF+G7KuqKro9AjrsTjmkHyMcX1F/c79Qf0UkxBp2nNyvJnhIyKkQwYEi7GY4baExzFqRbXDNxLOu38f91YXIIkpzBqXxdI6LcarJuSXAa6OOKQV4JcI+Yroh3Wa7qMrFtwkDYuKWL4+lLDYu//VAFBITUG1X8L8l1Zio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mo25ptoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mo25ptoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F321F0089B;
	Mon, 12 Oct 2026 07:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791791622;
	bh=b4yNuSLl8k5GH73j18Gm/oMFF2vw/gWuwsjeYE0/kyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mo25ptoR2Uc/R/JX8KAD2Y9WXYivUPepbZB0wxkh/4KS7IBNgZoT2U+nNiLVQUCgC
	 figB52VHKbJPP8RNFtUexVaRPugJ1PUZAtWa89pssDM1aQoSyZExZgwJ54hWtDUQty
	 CJYNZJApDAfZY8ziAJ9tJZlpIxgW7AAyciZo5NOP0H6Bd9CXdCzeaycCLc6N60M+fJ
	 WtONNyo2tkX1zM+5Mqvfbd+eemoMdaMREHhKfDRtejtUrsYRDuV7KXIryOx4MlUYTa
	 pkHglHkCl1gkqmfRcNy8YxzkiouSm2HRInFIioKZ1LYOdumsJmcYUYKEhSniK4qJgF
	 Dq7ElIff2q8pw==
Date: Mon, 12 Oct 2026 10:53:37 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
	Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel software CQ notifications before
 teardown
Message-ID: <20261012075337.GA219304@unreal>
References: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>

On Thu, Oct 08, 2026 at 03:12:02PM +0100, Prathamesh Deshpande wrote:
> GSI completions queue notify_work to invoke the CQ completion handler.
> CQ destruction drains hardware events and core polling, but does not
> cancel this software notifier. Queued or running work can therefore
> access a freed CQ, or restart polling after ib_free_cq() has drained it.
> 
> Cancel notify_work in the pre-destroy callback, before core polling is
> stopped and CQ memory is released. Skip user CQs, which do not initialize
> this work item.
> 
> Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
> Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 3 +++
>  1 file changed, 3 insertions(+)

I applied the patch because the change is worthwhile, but the description is
incorrect. GSI is handled internally by mlx5 CQs and QPs and is stopped
before the CQ is destroyed.

Thanks
