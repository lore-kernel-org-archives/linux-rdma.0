Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795227607;
	b=qNXNJ7zUonZONi14T2o7RVWb/HGdbxsfzmAHw1/9W9kq3NoebR1uiBZrGic5LLcGmcfS
	 xBcLubCnUhrDrdUhTWRV7FHPyqUBmHUvmNtKD8nQYL+qbkIZdW/4aCCFSbY+S1AHk05vC
	 77LMkLeWptgCyFmvIkgxC89outxnCNvdTiDJ+X5yaYKfqyfSapMqw7w2U2oyLckWSSbLC
	 NMQRuv4CV9M0h4fL3KMQdVSReFLpNRSJw1QOnmQuIr3gwd57UAV9onaME3BriHwr8ls94
	 8PRDWNuJe9+LLBmNYcNzoQiQZrH+FcbSVFAs4NFiIvdy2dGETmsNJcV2Y9viIcoixHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795227607;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=5bb5dXJJvw0JnaBAaPJTs5AX0PNe+223A/FD0MAQX1w=;
	b=jFSbgX+chpPj+TcIJfVnbiDKG7sMcAsYVsH7KZeQg+DGBYYr2ye4syMhPkBbZxfWWlPA
	 x7v/5i0NMfJcf+J0xECtNTHRDwewTfH1HpmP0Jf9RC/+Yvj5TP6pwAd1LxujJtfqipX74
	 wUgALkxEhCbXF+6sAc+mx+RKTi0Jq+L9QbnUJ0vgloLEzxppTKcyR29tlUGU80E02NnAd
	 gQZ4QbP8DE2AsCl5hpX5NW+tou/34RxDCXdoD8FVUuvCnAN0l9MZ7J2tQjhjq8bMpv/fE
	 Y5woyLcLtq/cAOLu9XuAxNpMkx2tTOw2NkzczFZnq1pBokkt+bx62qTjJXqu6QY83lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZTJMWXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2CF606A683;
	Sat, 21 Nov 2026 02:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZTJMWXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF50D1F000C4;
	Sat, 21 Nov 2026 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795227606;
	bh=5bb5dXJJvw0JnaBAaPJTs5AX0PNe+223A/FD0MAQX1w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kZTJMWXgqlw65cUFpICIoXICOXWUKUeDM8Be5xQ+sRNM42jDRs8aIwBLOnmRn2+sm
	 MARwLqaZlMJSNcfHMvP+lQNPdkG1gR6Cuazq3q17yUiTy5RnwIofUeYba6edWiqesz
	 d4tPQOKiQ9LgDQYqLHngrgS+RkU4gjMy/IImOCCSJWfcGZCp9zD2J0RUZsc9ZPL2hV
	 w+GzVVEMNlTe1Ceh5M+nSDvZthjyJThVgeYARbppih6rNhAD6EwmB1a8Emd/pVA4aq
	 /sjUaIL/LgMiiRCHNibRo6AuxpGBODzqayIAjZiyFzXxhaunCSocVurRCBb+vNkH/V
	 nnSGm57GK5X1g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B45F6380AA5E;
	Sat, 21 Nov 2026 02:20:06 +0000 (UTC)
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
Subject: Re: [PATCH net-next v2] net/mlx5e: kTLS,
 Simplify error unwind in mlx5e_ktls_set_feature_rx()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179522760553.891197.15403336647032541613.git-patchwork-notify@kernel.org>
Date: Sat, 21 Nov 2026 02:20:05 +0000
References: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
In-Reply-To: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, tariqt@nvidia.com, horms@kernel.org,
 saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com, borisp@nvidia.com,
 witu@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 luoxuanqiang@kylinos.cn

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 11:58:46 +0900 you wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
> handling is nested in the conditions and the main flow is conditional.
> 
> Handle the disable case first, handle the error cases in conditionals,
> and keep the main flow unconditional. Use goto to unlock on the early
> returns.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/mlx5e: kTLS, Simplify error unwind in mlx5e_ktls_set_feature_rx()
    https://git.kernel.org/netdev/net-next/c/d23de0bd0bfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


