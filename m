Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82F21CC71;
	Sun, 12 Apr 2026 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776030657; cv=none; b=KhkKUVuxXQd+O5DnnkETSXHgrcoGGGrby6QJLM17l3cCmislqeLfCz3LjAn6ZvUBrz8YNRV2JN7gWBGnOK9ZJ9GIrqmt6WNnk4raf/n68TkePsdcEFrGgZxNJC8Rxa2eMYUdAEU94COlaISayAWkRnXhSlFsbUo2+i356B/d/XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776030657; c=relaxed/simple;
	bh=2unedcp4QVEz504Sor1qZLz9fgHVioo3+2+wnGBLvr8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Y/RpKYWrO71US9t41r0Q6B+CAxbmotR6Aq8JKEel5etwyxt3lw9f1c8H3R9tnhsg03EX72xwbHsHrBjy2BObChxDf4Wrw9UKgej2X8jDhWQfW3SwFOq22LyF2BNQ2Zwq4JsCZAf+gMukeRaL2D9nluHyclMAhuYA8RDKl49plAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MILKKq/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MILKKq/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D3C2BCB0;
	Sun, 12 Apr 2026 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776030657;
	bh=2unedcp4QVEz504Sor1qZLz9fgHVioo3+2+wnGBLvr8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MILKKq/H1iYjA1nK/koKI5zRjSLElo7dseIj3TlBEYIZJhprQ4ciSpdi8L891jvIS
	 1itNkA7jvGGHFB5B3ZkQt143Kn83+/TyGdBWSHmoO8Iopm/7/1HyTlJnSA+BaKzkkM
	 qc7tlhuT3TdJD2TssKtEZ5y7h+RwROYJMIDRtxHZps9vCRoaIg8StxY0hK0CCzUpxV
	 nzvNUL42b2wA4rZBREV6YKUPz3z6c5me30DkawQlOV6f3wGVmdrT1RE1gS27ToAou2
	 50G7yQgjDCHKqDqN4i/P1s2Rr0ts5uppiUxrcEl9QvQTp/ZQ7wQIuYoikC8oHXArrY
	 t9lreqVUjaimQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9DC33809A8C;
	Sun, 12 Apr 2026 21:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5-next updates 2026-04-09
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177603062929.3833036.15590195095817856526.git-patchwork-notify@kernel.org>
Date: Sun, 12 Apr 2026 21:50:29 +0000
References: <20260409110431.154894-1-tariqt@nvidia.com>
In-Reply-To: <20260409110431.154894-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, leon@kernel.org, jgg@ziepe.ca,
 saeedm@nvidia.com, mbloch@nvidia.com, shayd@nvidia.com, parav@nvidia.com,
 joe@dama.to, horms@kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gal@nvidia.com,
 dtatulea@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Apr 2026 14:04:31 +0300 you wrote:
> Hi,
> 
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [pull-request] mlx5-next updates 2026-04-09
    https://git.kernel.org/netdev/net-next/c/f05b619d0fb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


