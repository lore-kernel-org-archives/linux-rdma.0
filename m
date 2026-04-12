Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF80021CC71;
	Sun, 12 Apr 2026 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776030636; cv=none; b=isnLeXAX+qqpwirFT+spy0en5K/bu/gc2S1EYDdYHH4q6qBeXYsbspcf1dZc+jKuN+h4w2ZC/6MrPU7ctCIhpywZLq9QyD7TbZiDVycGRPYfwZ262AS21GHsRQH3Wv1833qLZEBW0skCDxbzrX9LAZifcgMVAfZ+lOh81FQK4wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776030636; c=relaxed/simple;
	bh=ttZYdveUkveKhhd9BkfJxk7vHZmSLGfhZwk5jjz6iZw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TzWSe/hCyLmmyLvt9tG1xScdAoXagoBoqU6yHak/KQqYFdFYxz7ZORwcgcDQSow8yjWcTibAMQqHJuCAxM+3SfZCpHPxE0QAluqXfGcJDk4CjNtp4t7jL2INxk81heDh7FiDaOaok2xFqDwsv8aaf8WOtxaq2rvGZh/F2Vrqnl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqZRdoLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqZRdoLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9A0C19424;
	Sun, 12 Apr 2026 21:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776030636;
	bh=ttZYdveUkveKhhd9BkfJxk7vHZmSLGfhZwk5jjz6iZw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sqZRdoLyhrfTuFHPPUUabfF4ZopFWT+G20EXEBzkzGDWABhVkBofsnCVcN5HXsRC2
	 z0aprpmx080mPMdrQRADKU8+g5Ze2hpEUUtjdS7X0Q6zgeW+0/lUo82vWHg9HjqpvI
	 fPFuwtstBfGmbW+dxmsv6tWPRFbXFigOpgoqbTbypOhtkmVlFADDbaFvyZBMlcU3lz
	 j+tIUIJKjddvs8TWbnqFYszI5/maQ8riyADTV4ndZLYotyBHetCGK7Zm6jFqYGBbxi
	 hWqhzoBTznMr7kFdgCDPeOl8UlqSS32zV/CfRrXkesn9qnECsQ0z3hkrQlL+RXtT1x
	 iWqAvE/SwfRew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D2F3809A8C;
	Sun, 12 Apr 2026 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mlx5 misc fixes 2026-04-09
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177603060880.3833036.16496161564678609068.git-patchwork-notify@kernel.org>
Date: Sun, 12 Apr 2026 21:50:08 +0000
References: <20260409202852.158059-1-tariqt@nvidia.com>
In-Reply-To: <20260409202852.158059-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, borisp@nvidia.com,
 saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com, jianbol@nvidia.com,
 kees@kernel.org, lkayal@nvidia.com, michal.swiatkowski@linux.intel.com,
 gal@nvidia.com, royno@nvidia.com, roid@nvidia.com, raeds@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, dtatulea@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Apr 2026 23:28:50 +0300 you wrote:
> Hi,
> 
> This small patchset provides misc bug fixes from Gal to the mlx5 Eth
> driver.
> 
> Thanks,
> Tariq.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/mlx5e: Fix features not applied during netdev registration
    https://git.kernel.org/netdev/net/c/9994ad4df82d
  - [net,2/2] net/mlx5e: IPsec, fix ASO poll timeout with read_poll_timeout_atomic()
    https://git.kernel.org/netdev/net/c/edccdd1eb947

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


