Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9476839AD2A;
	Tue, 28 Jul 2026 17:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785258202; cv=none; b=QPyfapbPB/inZLAnq6FT5l/crc2v3BAy16qo92ULTCCl1s5lxdgJtBlRRuTNiDLzQ1ahz2Eztdhv3lgZoNOBfnsaHVHarQAeKOhk+gZ1pN+ufH9fm1kE6l742EG7E6ZEviBNfA9rafhll4y33umMo3OWMvlrcVK1E9SB41yXSZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785258202; c=relaxed/simple;
	bh=u9pyGo/bX56GRdBwH3XeDez60k6oiGIzm/4ERQYMses=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pA6vGGcV9WulM0gWvN6PkX+iLncJJyQi//41I0uUKw2BPdyJ+Lgj79svXA4IPzEOPv1JcjzvwSOP+Nc2qP6Bt2kse543L6S//iwpV8qx/zv1DOAoQ6yRRFxon8+CI4pLQ3hUAGAN1vRIj+5iyobOG2EmM6lE/BMoMnNQx1iuDOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZ4pExMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZ4pExMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52771F000E9;
	Tue, 28 Jul 2026 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785258201;
	bh=u9pyGo/bX56GRdBwH3XeDez60k6oiGIzm/4ERQYMses=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZ4pExMOg1TE0BGLLjY/U2V0GXflmTbACqfxDmKcxeBh/LRCgbEFOp0z3LzviNade
	 MQ6gsZWQGLann+LGWiBImO+3wlnDltSMpelAtyzkdYVPRdUfoZaN0j2b1q7h+9jQy6
	 V4LbN7IafEFzmEibNaGn/+D2ATA8ZAmnZ0qrsf+7KBHE81RLbXd1tl4FM/7+cl2l3i
	 WxsOSdysVNJeP1NDXyk2hzskb3Oumz0fabAp9sAW2LJiO8/RH/mGfxBLuzU9WSVOSm
	 1ez7TuTYA5tq40aXRPR7rcyGr49hD61zwlRlFYZRstosjpdRxtXRCK8iU8wv6/oZ/G
	 G2fz22yXxez9g==
Date: Tue, 28 Jul 2026 11:03:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer
 access
Message-ID: <amjg1x6QuEHtGp4M@kbusch-mbp>
References: <20260715204008.3911275-1-zhipingz@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715204008.3911275-1-zhipingz@meta.com>

On Wed, Jul 15, 2026 at 01:39:55PM -0700, Zhiping Zhang wrote:
> This series adds TLP Processing Hints (TPH) support to the VFIO dma-buf
> export path, allowing importing drivers (e.g. mlx5) to use the
> exporter's steering tag when performing peer-to-peer DMA into a
> VFIO-owned device.

Thanks, Zhiping. This looks good to me.

Acked-by: Keith Busch <kbusch@kernel.org>
