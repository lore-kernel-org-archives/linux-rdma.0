Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0295384238;
	Thu,  9 Apr 2026 09:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726836; cv=none; b=KMgZFdx97K9iLlbLEctn+10bU1MXYUfgEnR/RqFcEWbJC96i4kmMCq9Ws5e6b3w3rTqHZNAKFPfEAJE9xLQMWgiGDZdSrIps1U+DNjtzMY88FfonWA3S7lnWD0isorKXNOHza4JMwt/Er4OklcPrfFZIjKC5tP2F71vzmm4gvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726836; c=relaxed/simple;
	bh=5O1CTbz3y6Fxj30PrEGRISgfKCJJTiI0h1dPKtDIzmo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MiEQKjxb1BJgrG0kH01Hu7ZOdRSGr7EkImGr4N2ChNAQTAqYUCFRSt54a4zOaGq/IN/tpxgKmqiv0GVGPxDouIuBLeTZVWy83qmuQa+4LPBRYaiOq01CO04Gyj6BIuLpx1zS0s/2bfjbiOS52tf5LEqFihdAwN6rSEdyowqStTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTVtoiY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTVtoiY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081EFC4CEF7;
	Thu,  9 Apr 2026 09:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775726835;
	bh=5O1CTbz3y6Fxj30PrEGRISgfKCJJTiI0h1dPKtDIzmo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=OTVtoiY7K6b7o+Dbiii+kcnDV0IyqsBTbny5TqVa1MTfp1QY7hCdqlpbdwYTdVURa
	 YVa9F4WA9yiTdTZz01cVBxHf5S/P8nmIbfRiZ2/35uTsNzcLpcCwNhigHKTS0Qj9Ka
	 omUPlLhy5n1QXagYcV4a/g7YBj3F/2ULA0NXl9EptPVsJD5Xmef1HswCtiY3A5Hezu
	 l6IRqt9p25jep48gdiDTsoUn0SUBNsnxTO8QkO2gLK9C3HcYkmQcfdseNEcA+jjf7d
	 6ycKCELhnvLLrbQmUw4SU0IwmSlKimRppN83KsZ7AA036GPLcndgHog5FAxFa4xCVY
	 yUFvZkRAlMAIA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20260403090028.137783-1-tariqt@nvidia.com>
References: <20260403090028.137783-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-04-03
Message-Id: <177572683245.1600199.17083844109770489832.b4-ty@kernel.org>
Date: Thu, 09 Apr 2026 05:27:12 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 03 Apr 2026 12:00:26 +0300, Tariq Toukan wrote:
> This series contains mlx5 shared updates as preparation for upcoming
> features.
> 
> Regards,
> Tariq
> 
> Moshe Shemesh (2):
>   net/mlx5: Rename MLX5_PF page counter type to MLX5_SELF
>   net/mlx5: Add icm_mng_function_id_mode cap bit
> 
> [...]

Applied, thanks!

[1/2] net/mlx5: Rename MLX5_PF page counter type to MLX5_SELF
      https://git.kernel.org/rdma/rdma/c/f9e3bd43d55f24
[2/2] net/mlx5: Add icm_mng_function_id_mode cap bit
      https://git.kernel.org/rdma/rdma/c/a1bac8b70ede33

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

