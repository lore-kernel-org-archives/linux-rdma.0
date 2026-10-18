Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC8547C108;
	Sun, 18 Oct 2026 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792324611; cv=none; b=df+KXO9qghLCtA2fLdcHSpZ04V8U2bXCBIXAW4X5wbSKRNyHTse8znXKo8vEjbJc7/zK5IfeS9Yb/62Qv0m//yXdiP+A8f2xu7fd4XGhPbCUxq+xKEXcR80b1ayuU5hMkNwAAvEpiZLwDbwJuPb1HygRYdEtnkVx+hjt6IfPq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792324611; c=relaxed/simple;
	bh=C/0zi3llrng/v5XLCiA2BZV88a5kZ0g+9QgJyOaMYAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6mmFRvihUGpO2fLFDfOxXg0hoBazGRFJIbF9rGbfmw07vbSTgVby65Hpa+sphcthOM6OxJd4mmTJvZgelg+Et8kaHnLZs3MJpfcfmt4VUBUYmu4FkleR5g1RgB/HJntwIaNFWpoQ9A8S0xPTNgZ5Ia7G1JPYep0WVjERb3dsw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha/hj1wH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha/hj1wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757E1F000C4;
	Sun, 18 Oct 2026 11:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792324610;
	bh=DC8qMP+tN6JBnrgzbUtEYIqOpeK2hV8dxa52Rbq12Ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ha/hj1wHWo+H6HokqYYPpAc/F9zmRBO4VWBhPWRgYwkaMKURsjrbi6oZOmSWbV2rA
	 eK0p0vGc98TRVKgaDLBwVzef9MEXsu8sqidTrcdVbY6vSgQMw/MVWOE8A1VJd6Sxcl
	 DiBvI/EALpH7CKd2Kv7i5w1jrpRt32xC/rGDUn1bQaAyAJidbs6kSKuup1yBmOpk27
	 CzZ/Ypp2EgVZxzwyIiFZ3Tp5+W9BZduIN5lhFWxKuIaMw2jTYWda7yb508iW3RbMRK
	 UnJ9W5PPa372y+uOoQcFMQam4Hsf7eOe3b2gyqA28X4aKuEfuJYQmM03VYN1x9m0Dg
	 112cCOxs7StGQ==
Date: Sun, 18 Oct 2026 14:56:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Maor Gottlieb <maorg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next 0/3] Various core fixes spotted by LLMs
Message-ID: <20261018115615.GA64621@unreal>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>

On Thu, Oct 15, 2026 at 02:58:59PM +0300, Leon Romanovsky wrote:
> A batch of core fixes for various issues identified by LLMs.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Leon Romanovsky (3):
>       RDMA/core: Preserve the selected source GID on failed AH modification
>       RDMA/core: Free unpublished port statistics after initial-read failure
>       RDMA/core: Reject LAG selection when source MAC lookup fails

After some deliberation, I applied these patches anyway. Sashiko pointed out
an issue unrelated to the patches.

Thanks

> 
>  drivers/infiniband/core/lag.c   | 12 ++++++++----
>  drivers/infiniband/core/sysfs.c |  9 +++++++--
>  drivers/infiniband/core/verbs.c |  3 ++-
>  3 files changed, 17 insertions(+), 7 deletions(-)
> ---
> base-commit: 66196a559be5963b1ced18418c876caf9bfb76e6
> change-id: 20261015-ib-core-fixes-fa78b7068672
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 
> 
