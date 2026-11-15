Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794752208;
	b=5kO00CARzqCnL9+z/6SP0SswUjtaqEMhDa5B6StG+vUvP7yZFLMt6pqYn+xnqpwhkQ1Q
	 EFOPkROnHh5KC/g4RYobMN9J/tOWWfpDL10F1g86aFHxI8EmnJfWGJqkl0/ulx2mnMypS
	 1ba86UHByZT2OTUyiH82oiIj1/joIaSoKN2+WLNrd/ddlSVTTi9D47G6QW4TeULb8QRNK
	 l/0pX/jgVfNLZEFSVsL3i/GbkHwCrOBafGR8w0eu8OOrICfmmF8VQn/UkCXtKqfbdDBvC
	 ANLzvo+E2mWCrhlWCYHQupZDyTIN4+9IgGthjIIy+tByzYrNIbWDBpoEgrd1YvN9gEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794752208;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=huwbC1l+9r0wljSvxnr8ZJq2SXOpIvTdnSv9YCe3Au0=;
	b=1Ss8z2AiQrAl/QP1iJ/3iaKu6TTfz+h+8vtwTBmA8gIIzPcVE6jXEjkKuVzohqiLPV2q
	 6bHCrE18iKfwZWXLJe56L1FkIbmAeU2otyZcsJGc23yH5Whu45ImwukSvHTairOrFMxOe
	 3TiyAUzzh2SYsBP+fzgknwAv5LYAV7Ws171RUstwO+3nGPcR8Z7Pcd5byviuKZbz+IPj4
	 XGt1AhrhvkJ9shQoJN/tQ1vysRgGwGVlElvvpUJS+wG55A+07BjuRRXJOhwR49xG4ldJE
	 lI97yYvUYEwmOGi2nldbmiT0K/SF1Xp4zRUaXgEHzdGNW90USbev24KbVIJAMuys4gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m33yeqLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22F606A31D;
	Sun, 15 Nov 2026 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m33yeqLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A807A1F000C4;
	Sun, 15 Nov 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794752208;
	bh=huwbC1l+9r0wljSvxnr8ZJq2SXOpIvTdnSv9YCe3Au0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m33yeqLVE/jP4GGsoh/5CxW6bgDvJo1gRWvKNGQvwS5MUhrW32w96WyvL05e5IN08
	 j6CmeXNBiRQ5U7lS4Y//2YRIZMV2xz0HJ0yvWunCa59tOxgpxVqbYkmCO5U1d1rkpT
	 zSjr75qIjrGaW2wPZtw5Bv1JBk3GjKIFNij3GIozyUA50wngC+Yj3XWaFpm00cx2Vs
	 zuZKOClm1g21q63VCDOZqeQmITU9YB+xDS0pu+INrVIp5LNz7IvOsf/ymun036zRDc
	 uB1tdhvbs3zrt2u+ux+TrhRI9uf/KsuA2t38uZDf43sKDc+KUDvl6zHMxFrHNLOdvz
	 5oBqU2kqrU6UQ==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 linux-rdma@vger.kernel.org, Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shiraz.saleem@intel.com>, 
 Mustafa Ismail <mustafa.ismail@intel.com>, 
 "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261111092505.3121847-1-lee@jaeyeong.cc>
References: <20261111092505.3121847-1-lee@jaeyeong.cc>
Subject: Re: [PATCH] RDMA/irdma: publish APBVT entries after hardware setup
Message-Id: <179475220544.1329479.13364191091798828242.b4-ty@kernel.org>
Date: Sun, 15 Nov 2026 09:16:45 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 11 Nov 2026 09:25:09 +0000, Jaeyeong Lee wrote:
> irdma_add_apbvt() inserts a new entry into apbvt_hash_tbl before
> sending the CQP command that creates the hardware entry. If the command
> fails, the entry is freed without being removed from the hash table. A
> later lookup of the same port traverses the freed entry.
> 
> Removing the entry on failure is not sufficient because another thread
> can find it and increment use_cnt while the CQP command is in progress.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: publish APBVT entries after hardware setup
      https://git.kernel.org/rdma/rdma/c/a9ab64bd0d331e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

