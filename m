Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE6B3D544;
	Wed,  6 May 2026 02:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778034063; cv=none; b=mb70ylOfzHLqsN+KrBwWT9iDY2aBdDWA4IWmTF9vvAORoAUGCJw/Sj7nquiOrGC39B4xy6UcDAHKrTocFmytiISFe6L2xRY3vJeGzd4oxf7TvncDIk7Dc5jouVsIEkjN+fZWgg588TUEcduJR6kbpU8hJPgSwxqVQ/4S5/Ey6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778034063; c=relaxed/simple;
	bh=c0k6ikNWaJJQXZADZuc6qsuJuBiSPfQ2PnBNVo+U2/M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=U/uXdizmcAEyAHsrbdRDuRqOHCUDT0bnRtQ87jjxETwQnCslMOhjq8WbhdQ5GO2hmv2SjFyKtZWa0FRVLKQSznPBUPNdHBYyPANZAjOY4JaqeiWJTE4HAd+ltqKPPyV+SmHdjb5E/S5os+4Rctb0sALE79DLO4vTYgYmIkpyT/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=db/en0jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="db/en0jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DD4C2BCB4;
	Wed,  6 May 2026 02:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778034063;
	bh=c0k6ikNWaJJQXZADZuc6qsuJuBiSPfQ2PnBNVo+U2/M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=db/en0jkAXb0n2sQE1cmE0Si9r2El5d4PX+P+/zN9clUr5FTN3OsYgKO+jdztTrLU
	 yN8S+XjBSqqBURIcarMEv8ygL115hRr/2aPGhDuNKVAmYJkSDdVvxgLJ0DBb8b7/TQ
	 abCb5ZjdDtrP4TaBlWxZ7ROKues1fvb6vttjSoGGvP5YBu7t0sWqTPbyc9dQbwNYEF
	 Z0ds/BRYbabMchNGo2HbdQGPLbKjD05wersApO9WShRdT3GXSvkjuUTrKGYCMNGl34
	 89TFsHPE9sAZV5iJ4+JYCobKmIQl1iC6PkqKVwDUl1ONThmfwXrfLXrMu5cKWth5nX
	 ivLeun0vZWx8g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CD443930780;
	Wed,  6 May 2026 02:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3 0/3] net/mlx5e: PSP fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177803401330.2352352.15778480397241073113.git-patchwork-notify@kernel.org>
Date: Wed, 06 May 2026 02:20:13 +0000
References: <20260504181100.269334-1-tariqt@nvidia.com>
In-Reply-To: <20260504181100.269334-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, borisp@nvidia.com,
 saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 daniel.zahka@gmail.com, willemdebruijn.kernel@gmail.com, cratiu@nvidia.com,
 raeds@nvidia.com, rrameshbabu@nvidia.com, dtatulea@nvidia.com,
 kees@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 4 May 2026 21:10:57 +0300 you wrote:
> Hi,
> 
> This patchset provides bug fixes from Cosmin to the mlx5e PSP feature.
> 
> Thanks,
> Tariq.
> 
> [...]

Here is the summary with links:
  - [net,V3,1/3] net/mlx5e: psp: Fix invalid access on PSP dev registration fail
    https://git.kernel.org/netdev/net/c/ae9582cd0b9c
  - [net,V3,2/3] net/mlx5e: psp: Expose only a fully initialized priv->psp
    https://git.kernel.org/netdev/net/c/50690733db59
  - [net,V3,3/3] net/mlx5e: psp: Hook PSP dev reg/unreg to profile enable/disable
    https://git.kernel.org/netdev/net/c/c4a5c46199b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


