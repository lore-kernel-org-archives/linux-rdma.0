Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DF33F787F;
	Thu, 16 Jul 2026 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784192639; cv=none; b=PSoe+Do1NwrRPucH3H7VzwwNcdA2jEb2yNK3rdeZvImvGMy9ff3xrd9w81RG3Tg6LuWdQ9zYF1/mx34amxQzpveLg4ArqbEMBrBK07iSn3jhBGS0GTZZ1Jn1tahzk26FLQZihz13DCyzwibbb9Sd9QZF+nMY/PcsRTr+f+75pRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784192639; c=relaxed/simple;
	bh=pYpjfXyIigAQKNbWwzr5akMBiD9Ypc/8EwZ9C8nqT7E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=opevcpaGpbAYd07Fd24leh2omhHd/f4c26T/Eo9fdIUH/KDuc+P4jD/IifQVGAKnLb8U/Znkgk1Req1Xp4/WReYdL4woRPwV4sGT862AUch1f92iiTnXTbafuUu2E7f+LiLVeEVu6xbSUc9MBgZGfAzeTSx3Z5EsgADWj5s9HAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6821F00A3F;
	Thu, 16 Jul 2026 09:03:47 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Potnuri Bharat Teja <bharat@chelsio.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mike Rapoport <rppt@kernel.org>
In-Reply-To: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
References: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] RDMA: use kmalloc() for remaining
 scratch buffers
Message-Id: <178419262546.309403.17930415763322484965.b4-ty@nvidia.com>
Date: Thu, 16 Jul 2026 05:03:45 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 15 Jul 2026 14:03:08 +0300, Leon Romanovsky wrote:
> The series [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
> kmalloc() [1] replaced direct page allocator use in RDMA buffers that
> have no page-specific requirements. Continue that cleanup for the remaining
> scratch buffers in cxgb4, mlx4, usnic and mlx5.
> 
> Use kmalloc() or kzalloc() to retain the existing physically contiguous
> storage and alignment while avoiding casts and allowing kfree() to derive
> the allocation size. The mlx5 patch converts every allocation tier in the
> shared UMR buffer allocator so its cleanup path does not mix allocator
> families.
> 
> [...]

Applied, thanks!

[1/4] RDMA/cxgb4: use kmalloc() for the PBL address array
      https://git.kernel.org/rdma/rdma/c/8d478a35ddd99c
[2/4] RDMA/mlx4: use kzalloc() for the fast registration page list
      https://git.kernel.org/rdma/rdma/c/1c549b0722a81d
[3/4] RDMA/usnic: use kmalloc() for the page pointer array
      https://git.kernel.org/rdma/rdma/c/50ba3490bf1567
[4/4] RDMA/mlx5: use kmalloc() for UMR translation buffers
      https://git.kernel.org/rdma/rdma/c/94db8be4a1772d

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

