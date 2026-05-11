Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC8426699
	for <linux-rdma@vger.kernel.org>; Mon, 11 May 2026 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523364; cv=none; b=NhlIcVbm/GvH8h7RmoLIWsrMcQjKJv7TU5HSqLb/eLTk2au+G5YRIV4U4qYb93V/A0N5jUqjeFMJCdR/BUrFGr4460snj1LmbuWK2qClaWC9RuRRSenF0QE84myhiWZoppxr268KqD+Xu43886WLT1GadXE5f5LbyKcpYAjqvn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523364; c=relaxed/simple;
	bh=yb2YjtVXYgmVq9BQLe+O7lXhDN4PtroSGZqRR60ENyg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NFkE7GWJXobZb/Y91kvNzWQkKEeWT24aBd5mWxpcNNqkUl5fqv0KZUfnI9l94LLZZddnEZOnyomaiMIU0XercKdzsCdTWfQUL0wlvinuYC/4Ovo1Lajc/RmXEvNmW+o0OgAnpcBBOzBqTOpGB9ersut/VF5C6WYaPgbUCq9KSls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIE9r946; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIE9r946"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046A9C2BCB0;
	Mon, 11 May 2026 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778523364;
	bh=yb2YjtVXYgmVq9BQLe+O7lXhDN4PtroSGZqRR60ENyg=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=uIE9r946TqCsEaqLw6edYEO04WjuhcbbzANSrepn9q441UL1Gmw1MwxJQUgVtSdxO
	 DXKkyDihgQyqMOPx3N9xSEXw5ySxRy2szUJgGM3e3roBMhbcOCqoKsWOZ/dyTZEM6I
	 jgM0icHpW3wBuhnXJ7l4BECn4yOLfJckOJ3NRQsJv3c7Aehd72tKttqO4yfuI9uZ9Y
	 MYXnVTByERqLds9+grPiMpSJ7v16mEugllYfxureukE0e3aYwSjnx4DkELNlJnD01F
	 W0c7PTdqrCUqzVsdcPQ80skdLd/efbfSNQooLavVldk2DG5ggBMVtPmOPET1X4yfxQ
	 +QNg3D0X6i28Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260503023349.1959-1-lirongqing@baidu.com>
References: <20260503023349.1959-1-lirongqing@baidu.com>
Subject: Re: [PATCH] IB/mlx5: Reduce spinlock contention by moving free
 operations outside
Message-Id: <177852336169.2270663.6626791600164932129.b4-ty@kernel.org>
Date: Mon, 11 May 2026 14:16:01 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 02 May 2026 22:33:49 -0400, lirongqing wrote:
> The functions kfree() and kvfree() can occasionally trigger a long
> chain of calls or face contention in the slab allocator. Executing
> these inside a spinlock increases the risk of CPU stalls and increases
> lock contention under heavy event load.
> 
> Move the memory freeing logic out of the critical sections in devx.c
> by using temporary lists and local flags. This narrows the lock's
> scope to only protect the list integrity and state transitions.
> 
> [...]

Applied, thanks!

[1/1] IB/mlx5: Reduce spinlock contention by moving free operations outside
      https://git.kernel.org/rdma/rdma/c/f4b27971e6e7d5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

