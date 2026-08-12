Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4577C35F180;
	Wed, 12 Aug 2026 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498279; cv=none; b=GBzEoEARFQSfidOU+ZvAvvWIdSli/4cQ1h23MI6oknQkUl+gOjMX15Hnb4FmnUq7fxu/269wl+7JkYBUyRFvRKf7PcQUZVT/ntORBac3KjKi3riXyjiNGtAQy7Yg1p9xCUagpW2k8dYte4WhnuGEaa+V7DJM8Nrr6qisTrHACh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498279; c=relaxed/simple;
	bh=eb5NCY5bMC4d256bHcdostcP90LOUfDnXioDSecGz9w=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CFCbGxhjFOONn74zoiTchVjnh0+gSEJt8h5MzY9LHHnO+LN/Q0uw3etKVNBUFSLFvPARSSWAPV5y6i8Jm+ujnvqCmCHAy0osyocmvMGC0l+6iWOar3HlHwhB7CHgXlXCsYdHWpBjN1QyqW3LqfEhddBdWHOg8O7gJaBEmZapDu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VavCS3un; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VavCS3un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A491F00A3A;
	Wed, 12 Aug 2026 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786498277;
	bh=YfF+scVCwdFnE/RkUcVDb5S/LypZaPtc+WiAxbkhroI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VavCS3unZ2uO2e6bhcYE6WKxfmEh+IW6yHGfXRjVOrhZ3e3SYbLXkHoB2EQR8B/0y
	 6oEwR8RZApHyNhjDBoOYI7H19+AAvVMZWHZNxd/YpvmJPnqQ4NiVl1DGV2ENue9myl
	 BzMN4DxkWgsrOB0FDHqYVwHpULA9VyhIWurVJ97T4Ze/gxC1qxShc421Vhlm4Elvpv
	 1Aci6J+PzJ0zPOhi8PfGMndyrm0v4nMdVJ1NrV2hXAy/9rjIolx/HXShUHpXg568/E
	 CoXGfz0Xv3rXsjAw+krCMLNGkLik/+6pO0XXtQ5amtPzBD+2tbupwUMUmy/ZKLrIIm
	 0froDAgC7cIOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09E23809A3C;
	Wed, 12 Aug 2026 01:30:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V5 0/2] devlink: add generic device max_sfs
 parameter
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178649823338.1227528.10215520546627944699.git-patchwork-notify@kernel.org>
Date: Wed, 12 Aug 2026 01:30:33 +0000
References: <20260806073037.3001886-1-tariqt@nvidia.com>
In-Reply-To: <20260806073037.3001886-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 aleksandr.loktionov@intel.com, aleksander.lobakin@intel.com,
 akiyano@amazon.com, daniel.zahka@gmail.com, dsahern@kernel.org,
 gal@nvidia.com, jiri@nvidia.com, jiri@resnulli.us, corbet@lwn.net,
 leon@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, nikolay@nvidia.com,
 razor@blackwall.org, petrm@nvidia.com, przemyslaw.kitszel@intel.com,
 rkannoth@marvell.com, saeedm@nvidia.com, skhan@linuxfoundation.org,
 horms@kernel.org, vdumitrescu@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 6 Aug 2026 10:30:35 +0300 you wrote:
> Hi,
> 
> This series by Nikolay introduces a new generic devlink device
> parameter, max_sfs, to control the number of light-weight NIC
> subfunctions (SFs) that can be created on a device.
> 
> The first patch adds the generic devlink parameter and infrastructure
> support.
> The second patch implements support for the parameter in the mlx5
> driver.
> 
> [...]

Here is the summary with links:
  - [net-next,V5,1/2] devlink: add generic device max_sfs parameter
    https://git.kernel.org/netdev/net-next/c/26ba30221c03
  - [net-next,V5,2/2] net/mlx5: implement max_sfs parameter
    https://git.kernel.org/netdev/net-next/c/38c35fdd801e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


