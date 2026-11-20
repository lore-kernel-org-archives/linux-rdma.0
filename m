Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142414;
	b=Y6APXasn+3TruCnKURfi8p/bNoNkShbVhtvmuFVehtYCQWEKcOaiBcjT83UHA++z0YmZ
	 2wL32+gJ9STZiJFsF6ypjlgnRp4QNjHDgkIJZ91spgDBa9a7NJ443ANiTNjOvMnEY8i0R
	 PumbYhU8VGDVoUqWtbOEr6rxMRLj+ChgPOjBFQCh/zVdgqbUsBH52WFJtIM9Gan0Z+euw
	 rUfH7hDaFD2SEgOVsubZKWs6yqtYXsOL+DA3WGTkTbAvXygAi1f/L13cwV8PQ5eUGF7hn
	 jHzJAfRiv+fZJOkw1Gs1sg50S4tNAn3LVc6XqyANX6eM6fL4nAW/VKkiHCYwwquvxSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142414;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=zkb4KGS/rU88to2Q3/dDhQzFO/0JWY7PV9ThQpsdqe8=;
	b=nQnXtiFubZbMz/hGpwC+OHelzM7mStBHwZxvvNu6I2deYK0qMWtpNJ86DxOyv/Xio6y4
	 efnJu20fQW93VxzbGiZW/UjlVZajSGa9d2wndElkBRyF1Qxmik1BVcP9J8W3s6xrLsFtM
	 7STY1HlWnF6R4psdQ/xk39kcRHwAXiZnkYoMtGiXvo/zu6mCiPFCvMdcSHr16jTP5Tk4N
	 I27b9AD1+khKwSeG1YdGgsUEKhjpOstdM01zHLWUB7hsEIA3UmpUiE7EjlMXoK2u4eJhQ
	 aOCzlQgkADfSVWu1NcSPv0NjWppyzUVk+v+ap+osP5Ard+E4AfWtLM2AJFSyEQFQG3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XiF4DPPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3870C606A33A;
	Fri, 20 Nov 2026 02:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XiF4DPPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760E51F000D1;
	Fri, 20 Nov 2026 02:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142413;
	bh=zkb4KGS/rU88to2Q3/dDhQzFO/0JWY7PV9ThQpsdqe8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XiF4DPPL2mouSOQ+l9EcdGGMWwK/C9WTjqD8oEJv1OyvLUecMl9pF+NiO1UUGhY8E
	 1E47vzOnXdvzaU124SxPQzgPU36MaUN8jyhegFhTRXJvaSWircrjS8xetuwM4qJk+3
	 cBgaXrwtWuCX6iy8ASL7eg9G/gm53aA6z/5Rg122KFwO7u0onjfgcZQa4uZE1E1IzC
	 15SfvN1JqXwV+c+HzSENi38vQQAxcr5Cb+LlAKL0BvJb29m+2OuWWGjjARQmw4v9pj
	 z7qh3mnGe4r+RsRyEuzTEyP/nQA/gBY+qbn06sZnJ8TpYv0n0dtd7gpt7v3Y1/ETbW
	 xIVEQJzHdGGgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 6E52D3808209;
	Fri, 20 Nov 2026 02:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: SHAMPO: Do not merge packets with
 different
 kTLS RX state
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179514241203.3989712.957393796041614444.git-patchwork-notify@kernel.org>
Date: Fri, 20 Nov 2026 02:40:12 +0000
References: <20261118144042.1916204-1-tariqt@nvidia.com>
In-Reply-To: <20261118144042.1916204-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 benishay@nvidia.com, borisp@nvidia.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, gal@nvidia.com, khalidm@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, witu@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 16:40:42 +0200 you wrote:
> HW-GRO (SHAMPO) sessions are not terminated by HW when the kTLS RX
> offload indication in the CQE changes. The driver applies the offload
> metadata of the first packet in the session only, so ciphertext and
> plaintext can end up in the same skb under a single skb->decrypted
> indication, and resync requests carried by non-first packets are lost.
> 
> Do not merge a CQE whose decryption state differs from skb->decrypted,
> which the first packet of the session sets. Never merge a CQE that
> carries a resync request or a TLS error, so that each of them starts a
> session and is handled.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: SHAMPO: Do not merge packets with different kTLS RX state
    https://git.kernel.org/netdev/net/c/e421df3c8386

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


