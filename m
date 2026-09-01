Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C27E43C048;
	Tue,  1 Sep 2026 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271455; cv=none; b=KBcxiNWXXPGWN4d7UMbH0mnd/8fgxnimNERi23O4C35uljCQobMzff64Dpfrx0Z1sSBsU0EGYjeH1Z5OiiUaJFVLuT8srznZxDqO5AHuunvEwJDQyLysaNR2KfSjx1whnVeKlG/Zi7Q8HmUh25eGg8sPGUFwD8r1SV9wpRtJF4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271455; c=relaxed/simple;
	bh=FjZcK7e1CF5aHDjOLRq3C1gu4xll2u1WO9cXVHsqbVQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RKQ1F1zF9K8srHaUuIf84d8APgLMVugqQkrKC1EUboGVxM52gKhuPxbX9dwKGal/zr4BvZgynwHuzGj0+awWc6AApKkgsf1R+NgHBKU3wUHSVf0+iHfAsodHoOZ1bvKpTAcqn/aF3O4Mf45VXAPTfD37fARnIsUQs09cg0SHZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPeL705n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPeL705n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD61F00A3D;
	Tue,  1 Sep 2026 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271453;
	bh=jpPELLiQ+nEEj5cM12bp3iMB765IticdEVx9fTL9+wE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MPeL705nZabJK8GgLiR6eiULKdE9rU/dWLPYNqKLzRRkSLTRxeNHXWrOCJhp6M6yK
	 TXHKEhzmETbreDVBXUU/8SZWyWT9/w4exAhdaupas+tHplDmFsnc/69qAeX6G2Rdwy
	 TLAegWbvV8gpT0zmQ7PEYRCiYxuLkxQN6A55+xdhWgDX9WNXletie7x0GJlz16hLbS
	 WEgF/XnRYMov4Y5U4PRqPl9HC9YMY1U+Ub9lOQNbpFtPlCxBFMd20mLNFGzG6IXwYN
	 tJsY+8kUuDC8WGG7vEBK/OF0Rfz7R3klLlwQkan1z69FYls2i5kDj4DtxynGd+SpKL
	 rqN8h+4JyOApA==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, jgg@ziepe.ca, 
 Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260816044510.3848996-1-shuangpeng.kernel@gmail.com>
References: <20260816044510.3848996-1-shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] IB/mlx4: Fix use-after-free on pkey sysfs registration
 failure
Message-Id: <178827145124.1380198.18104190586374811553.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 10:04:11 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 16 Aug 2026 00:45:10 -0400, Shuangpeng Bai wrote:
> register_pkey_tree() ignores errors from register_one_pkey_tree() and
> continues registering the remaining slaves. The per-slave error path has
> already released the pkey parent kobjects, but their pointers remain
> stored in the device. A later device cleanup therefore passes the stale
> pointers to kobject_put(), causing a use-after-free.
> 
> Clear the parent pointers after releasing a failed slave tree and skip
> unregistered trees during device cleanup. This preserves the existing
> best-effort registration behavior while preventing a second cleanup of
> the failed tree.
> 
> [...]

Applied, thanks!

[1/1] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
      https://git.kernel.org/rdma/rdma/c/1af874e9f4ce22

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

