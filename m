Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B93D522B;
	Thu,  5 Feb 2026 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770296314; cv=none; b=cx3Tzvqwd7VaJnDW8iFTFG2eUdk+EaxTh9+0+t7Ipff9Orr0l36CApQWERhi8GmiMNMOWx1PQUIejCDEAFv7nSd+TmjMvHKtoX4gal6v12zp0tpjNE1wJc++JP/P+XT0V0ypAYEBx56AVwUgK7BIqDEvTQ4zd76o1NmxhhlzJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770296314; c=relaxed/simple;
	bh=S2s8/bMyKmVdiSDHAWjHlKyaaSVCT0Yx1Zo2MXvJ1WI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tWvF+qBpiYSK+LkJVv2BlxAasgAZTk6CVEcnwA0eQ6jMViiT4G/LbvLBP2BgkD1LyrkHtyfL10IFGFyqkCDuVCcPALj1HluqPZ80F7IBR4Qoma5BcL7pUgIYhE1FyAT8m4Se57agbrcEIJWDnkFvN2xCHydA5mL3Sout/gR82SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkkng4ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkkng4ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184FAC4CEF7;
	Thu,  5 Feb 2026 12:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770296314;
	bh=S2s8/bMyKmVdiSDHAWjHlKyaaSVCT0Yx1Zo2MXvJ1WI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mkkng4ciZVY11wIeOZkrjjS1eW04HepM3zK7vDKNRh2Gzrz5ZYTA8oNpDipCVaBt6
	 Zju30QUlAMefAPOOjTGaXXLVUV1j3QM0oc/xRbw5x0XTqwH3O14ddftpyKslwxOuJF
	 OcB71+Bg3NLhejGFSqcv7La1FyMwzYLXBRiHjlMGoDhwM1PoGWqV82Mhxdku5fQFE2
	 2UhjTPRQ/72BvjUm3jWYNQcm6KAEIiosAvAhIiIB1Phz+pdAL8MGAyu1F4CrQ2hC6+
	 P6/bK3xP8hOEVKWZ28iCgV7/jIF+CMBcfVyIXI9aTucOTbYl1TK+nrvLj2dWceXko/
	 7twWrocbp3tEg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20260201-dmabuf-export-v3-0-da238b614fe3@nvidia.com>
References: <20260201-dmabuf-export-v3-0-da238b614fe3@nvidia.com>
Subject: Re: [PATCH rdma-next v3 0/3] RDMA: Add support for exporting
 dma-buf file descriptors
Message-Id: <177029631173.955437.5307722032449149162.b4-ty@kernel.org>
Date: Thu, 05 Feb 2026 07:58:31 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Sun, 01 Feb 2026 16:34:03 +0200, Edward Srouji wrote:
> This patch series introduces dma-buf export support for RDMA/InfiniBand
> devices, enabling userspace applications to export RDMA PCI-backed
> memory regions (such as device memory or mlx5 UAR pages) as dma-buf file
> descriptors.
> 
> This allows PCI device memory to be shared with other kernel subsystems
> (e.g., graphics or media) or between userspace processes, via the
> standard dma-buf interface, avoiding unnecessary copies and enabling
> efficient peer-to-peer (P2P) DMA transfers. See [1] for background on
> dma-buf.
> 
> [...]

Applied, thanks!

[1/3] RDMA/uverbs: Support external FD uobjects
      https://git.kernel.org/rdma/rdma/c/6b848074a32078
[2/3] RDMA/uverbs: Add DMABUF object type and operations
      https://git.kernel.org/rdma/rdma/c/e6738fe6cad448
[3/3] RDMA/mlx5: Implement DMABUF export ops
      https://git.kernel.org/rdma/rdma/c/992a14bb2150a1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

