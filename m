Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003607;
	b=IeTaGqKb9lE4ccMioj3ArrLCWsJAcn3IliE22+QYcY5aoNBJ0H8UP2sBRGKHvC0DKQy4
	 cE+aazQpnFhM5HK9GlobrP1+yRN0mtDiyRupGIFB8II0nNI8oaDoyQ2ryr6UD0hMT6gYq
	 6AlQjxn3gMiBqkomI3uTMldDvcld6t87smbb1yTOf2B62hGeq2o4JE6VVOIr2LtQY4F0o
	 4hmexQ6KWMugKfYq8h8pPG72tj/gbUVXT7mIZxpgQef9bp3SpUm4+jjhgZ9MsNE12K15v
	 O+H0mCNzokVxUgCc8dLwDh9rOjQq8UgAlgfgCiM3utH94Xyim7vaMYnEjzQ9OVOiHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003607;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=XF+1Knmn0XuRqRSB8aofDteqe8NFHgivVbWmlItkZ7Y=;
	b=jjamebL8RIamoHON/B6CnvE14HDlCdn3mLIJbBtgF/N9eGKxYKvEKTWv4gMSarDJGtgX
	 NEkeqLFUH1DeypM5edf2yuTyni8iIrUsJzBJkb1Z/UDgRdbskSvhrl1sJH/kirwjOCnzd
	 cLF8BQjSeTAp0ejOtOlG0oRYgeG93WRUXXAyNnENeN9nVSfLLAmhfyX74xyMK/4NuaHgV
	 LiotnIbxQU1BaBwb5zGKSOcLrIXmKZY6Nq48yMxCy5SX/FoXY0jxDJeUHTexoO0xMLb7C
	 NvfM+AHSye21DsXNS9aVmhwZLptoB1i742yGi1YbjlpbUK6KSMgSECAO198FlVAhtmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jXX0lI3i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAC5606A326;
	Fri,  6 Nov 2026 22:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jXX0lI3i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89351F0089F;
	Fri,  6 Nov 2026 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794003606;
	bh=XF+1Knmn0XuRqRSB8aofDteqe8NFHgivVbWmlItkZ7Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jXX0lI3igzd2P8zM8oiOqB6YZFPmdUtNMbKjPyBdyIA0w9ofOIbIcsI0nmKZSKCTE
	 Gj7xOC/k2m6lQxjGUw2Ei4tmYsF7do+wt/f+bH8CNaEyy45yMazDPmGJAupFyMcors
	 PAhYZR8aDLXfErfcNIjtRTMp4ziLYhHKCpMEMc4hkd5Cz3aH+Jh7M10t1SKSQRW8Xi
	 uee4NBU6DyhtwPY/2jbKLkmIxBKKR04A8uMb5UCB8mmGalWxzR3M7xf6QtCmsvDjte
	 nfN9cYmJFyfDhw1EJOoiMM/zaSnH9f19Ydz4lCzXy3s0usMpzgiNr5TtuFh3JhCGjQ
	 Z4LV/ZIXhB9vg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B1E33A54A01;
	Fri,  6 Nov 2026 22:20:06 +0000 (UTC)
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
Subject: Re: [PATCH net-next] net/mlx4: drop the unused is_supported callback
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179400360543.903397.1123811450749688598.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 22:20:05 +0000
References: <20261103122109.1798144-1-pdmorrow@gmail.com>
In-Reply-To: <20261103122109.1798144-1-pdmorrow@gmail.com>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: tariqt@nvidia.com, horms@kernel.org, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 Nov 2026 12:21:08 +0000 you wrote:
> Since commit 557d80138618 ("net/mlx4: always create the eth and ib
> auxiliary devices"), both is_supported callbacks return true, so the
> checks in add_drivers() and delete_drivers() no longer decide
> anything. Drop the callbacks and keep the aux device table as an array
> of suffixes.
> 
> Tested with this change applied to 6.12.113 on an Azure VM with two
> ConnectX-3 VFs: both auxiliary devices are created at boot, and
> removing mlx4_ib, mlx4_en and mlx4_core deletes them cleanly.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx4: drop the unused is_supported callback
    https://git.kernel.org/netdev/net-next/c/6ee8e8d9227c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


