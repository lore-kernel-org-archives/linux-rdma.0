Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D332D0E3;
	Tue, 18 Aug 2026 02:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018466; cv=none; b=DzHCAThSBxMdf98LX1bkaQ2aB2h8KYRAtKzgm+RDoc6mLpKPl3GzSJwC96XCQaEz4MoIQurBNaW+nsYNdeJyyq4t7qrYCuHNRTw+UVzgu0yNCymYDydRRGPAFGgwr2VWUKfLEPvBIhowhbVuMHvMZegvJtLLjbMWIC/ukOPrC6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018466; c=relaxed/simple;
	bh=UZmPAs+JDqMD8U8qTsIGXPIC7tbTxho9HFYn7CRw7cw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=amZ8ilKg73xYVc9rgiSPC/KK6FnJadbxaoVvt5lgzz60d47IH0mArJBZZp8ca9BXfcDs9kYpYeKUIf+lB5yvy2Z5OAjUg8Jueh+kMkR2R/tLlzBIiGfl9vNE91RITgQ6ehNkE9c1tXCschsKcB1cIBv1YntDVuqBH0E7QiFCK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgEbZnuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgEbZnuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E490C1F000E9;
	Tue, 18 Aug 2026 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787018462;
	bh=9Cc+IAkOF9gBXh3S8xt7Ms3StQLidJcbpioAoJQD/bw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KgEbZnuuiBNCP0R/gCwcD9tg2XQvppMX3EbatmVDr364wV8+3my6TNOrr1OcMss+z
	 oo6vmROpCDkibrDLqhCWrZfw9Ej1iBaAOW4d/j+52ZN1pwalgDpWbyD8+bImpLOT9z
	 UnsTrZMYOOaSzHJ+Hkq4V+OWZ3AFz13Exyo5kzY4WtB1sdCExtavccHHIY2eHeFudV
	 SGnV8Min1icNPdvEpoBQ7/hL5+SpWdduDCgC/IF5Ss0BK1rbZ0PQ8uLHHT16qga76r
	 LJeDS8cA3SYOEzf1guJ7e1E7avBYdKS4ntk75/7t8W0wmSalhIA8gGgu2molmpdMNQ
	 XVfSNXHje2o2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199823926279;
	Tue, 18 Aug 2026 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 0/5] net/mlx5: HWS misc enhancements
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178701841389.1828497.12446938123072918694.git-patchwork-notify@kernel.org>
Date: Tue, 18 Aug 2026 02:00:13 +0000
References: <20260816142045.3289452-1-tariqt@nvidia.com>
In-Reply-To: <20260816142045.3289452-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, valex@nvidia.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 jacob.e.keller@intel.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org,
 vdogaru@nvidia.com, kliteyn@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 16 Aug 2026 17:20:40 +0300 you wrote:
> Hi,
> 
> This series by Yevgeny brings several misc improvements to the mlx5 HWS
> driver.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,V3,1/5] net/mlx5: HWS, Print more details for bad completion
    https://git.kernel.org/netdev/net-next/c/dcb09aae194c
  - [net-next,V3,2/5] net/mlx5: HWS, Log syndrome on STC modify failure
    https://git.kernel.org/netdev/net-next/c/d4c34eebf18b
  - [net-next,V3,3/5] net/mlx5: HWS, Set the num of queues only when alloc succeeded
    https://git.kernel.org/netdev/net-next/c/5d3ff6671b62
  - [net-next,V3,4/5] net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
    https://git.kernel.org/netdev/net-next/c/7e34d2ada9c2
  - [net-next,V3,5/5] net/mlx5: HWS, Remove redundant FW command when reading caps
    https://git.kernel.org/netdev/net-next/c/bc502b3f69a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


