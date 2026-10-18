Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E39C2D1913;
	Sun, 18 Oct 2026 11:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792323167; cv=none; b=sXT4XuRvy0VnRST7RPc4bWNJsamwD9ukeLOQWWI26pB7O5CMfjV37+SBHNSWp2D7NW5TG6ScIOSJGClNGZSXzf955dAnWGO/V4E0rJvjVAQeU7uMtnM6Uf5d8y9Ex1nHQjmzhpUYps7IhmO3HbnP8QBPFDftOeeiWr/Leqkm5s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792323167; c=relaxed/simple;
	bh=hcDxf/pzon44FLgAKrlxoFQ1+HnjSVVhTcdqzIIB8rY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qinPdBh3dYEBSSq53MHASqlzEtioduu2voQAJR9RPNnAyDAbtUZCAd8L8QauvJXYGCGzIlOxii4eJHZDUe7IKaAsV5TUJZxrPT2GMciAuKUIf3NCGv9/tPRolOB26BN8+luImwz9Tj0lyu37iHJXax9XJdRCksTjjhTgXuCGHX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/D0hgMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/D0hgMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C63F1F000C4;
	Sun, 18 Oct 2026 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792323165;
	bh=47k6rJMwcjQJjTImnf5DOBQ6a2OntryoiFRap2rObvs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=h/D0hgMVz5rl/qpXlUyLev+eBe42ydAo1pkXl6FhNUYu69tKFEB5hLEq4DzcGhJue
	 Oy8//0PrfXog4unrlFErcBPGrHE9oZEhIYujhSWGzRjdGzGaRGZt+i6S31cwxsK9BA
	 0Ren9dv3mNU28cWueQyuTXPUb0762Bu9dLtefGpsYM08+BtX1zKHUk1NiujkVyTNTV
	 gQT9DF2W1rPYr+0OXt5+yaXt1yJfG2KoIyKtRyeip0ezIQzicuAmO6cAyXsWNP/SqL
	 BTlJj7uHCn9UCXR9JCFwIZmjT6gAyZeikQlRSr0lxWjVZre8e6QsvTA/8BNnAA7PM9
	 h4NFUHxQqz5AQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Deep Shah <deepshah146@gmail.com>
Cc: linux-rdma@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
In-Reply-To: <20261015083637.200958-1-deepshah146@gmail.com>
References: <20261015083637.200958-1-deepshah146@gmail.com>
Subject: Re: [PATCH rdma-rc 0/2] RDMA/uverbs: Fix DMABUF lifetime bugs
Message-Id: <179232316273.14756.10050537831811124188.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 07:32:42 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 15 Oct 2026 08:36:35 +0000, Deep Shah wrote:
> Fix two lifetime bugs in the uverbs DMABUF export path. Patch 1 fixes
> leaked uobject and ufile references when the uverbs FD is closed first.
> Patch 2 fixes a use-after-free when dma-buf release races with ufile
> cleanup.
> 
> Tested on mainline 4056b3c9d3c9 in x86_64 QEMU with KASAN and lockdep,
> using test-only siw export hooks. The unpatched kernel reproduces both
> bugs. Patch 1 fixes the leak, confirmed by tracing ufile release. With
> both patches, the same tests complete without KASAN or lockdep reports.
> 
> [...]

Applied, thanks!

[1/2] RDMA/uverbs: Fix uobject leak in DMABUF release
      https://git.kernel.org/rdma/rdma/c/4a953ee228f554
[2/2] RDMA/uverbs: Fix DMABUF use-after-free during ufile cleanup
      https://git.kernel.org/rdma/rdma/c/2854f9025d4ef6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

