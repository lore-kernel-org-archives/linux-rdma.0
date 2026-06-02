Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732ED3A6B9D;
	Tue,  2 Jun 2026 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780435809; cv=none; b=uVFqO8WKDCX3VLYHOLHqD90heMv1VYMYiM9uEAmiptpOczspQSQvLl/U5OrOBGhkryX7rJa9HpF2UYqlNCdoFWvjke3qMtJ71nT0/KXlZtkPH19XOcmQptwO1RhaBdTwMZSBuAsfq/mRqN3zh15d0H39+CSapP6WlLiUqxVQGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780435809; c=relaxed/simple;
	bh=EybQnBMoxL9pB6EZAAy755FMVg0F44AFTkBuy545DAw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qExRJoF7ZlBeu2RE4G/tkGV9Xv6XgW9wcMEMITd1BKJkXYpu56Y04f8wzBUo4mFEyg5XeBNJdxg0g+yMLkYabKUepArVvVPnEZIdynzbyEocBcsjJEZ1CQ/YD3dZrrT/tvIu21qw01gdDneXlp2SRF25mcuKF94AvVvGs6CstpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGmp5p9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGmp5p9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F04D1F00893;
	Tue,  2 Jun 2026 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780435807;
	bh=fNztbHBTXfT03ZHeQleG2e86Ii5WrI1yJc7iP2ZJidc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NGmp5p9voh26f4zoK7UJWcX8n8YeIJk1Jcgx/48irsR5/ea1ktBQ0w/a0WhB1VdnT
	 r5XCwmFfhccSwOaLOqDkqBOTjM94bLQWsR5/2F6WakhAthcUJe5y4EdNHohKKxk6/Y
	 4/6VmWDYz9eatPmAJbDaLJjR5xSCjrYguy9/aZrtTD6vIua77UFHB6HpH2XTQEQqek
	 v4vmtsalNGasmwuiMpdjFB4WKSDyleGQlWNUeNwQBhTi4RkEJmeFABQnCJ3q9RIQf6
	 K8+6Z3nz1RI2MaXHEx8aDAo3DoYJ+wiz7lhIkp91vtwg8JSXg/QBHsH9hit0xtWc4e
	 Z2P9klkg/TmAQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AA53811A72;
	Tue,  2 Jun 2026 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V7 0/2] net/mlx5: Avoid payload in skb's linear
 part
 for better GRO-processing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178043580880.1057654.15648019430651033677.git-patchwork-notify@kernel.org>
Date: Tue, 02 Jun 2026 21:30:08 +0000
References: <20260601061522.398044-1-tariqt@nvidia.com>
In-Reply-To: <20260601061522.398044-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 ameryhung@gmail.com, david.laight.linux@gmail.com, cpaasch@openai.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 1 Jun 2026 09:15:20 +0300 you wrote:
> Hi,
> 
> This is V7 of a series originally submitted by Christoph.
> 
> When LRO is enabled on the MLX, mlx5e_skb_from_cqe_mpwrq_nonlinear
> copies parts of the payload to the linear part of the skb.
> 
> [...]

Here is the summary with links:
  - [net-next,V7,1/2] net/mlx5e: DMA-sync earlier in mlx5e_skb_from_cqe_mpwrq_nonlinear
    https://git.kernel.org/netdev/net-next/c/34d8c91a3d39
  - [net-next,V7,2/2] net/mlx5e: Avoid copying payload to the skb's linear part
    https://git.kernel.org/netdev/net-next/c/399f030cd612

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


