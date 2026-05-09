Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284932B2D7;
	Sat,  9 May 2026 02:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778292662; cv=none; b=L4vEaAmoGm08P3ffJ2dX8tSiTLTtECP7g/KHxReEsZUjVE7RKx2di3wS6+UpDvuVRN+ihiue4HZbQNODCbZ/FmF+c22sHG6izNWyPcRUnf9FNhYab1ljvvxTVN42bYp7iW8jA7Ykpxc5frsp5Rna46dMIqijjKqqxtSjWQXudjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778292662; c=relaxed/simple;
	bh=gpjiOZlTziOhBtPXoUAAQ13idW3W8B4lBEcXF09hAC8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fRKXOh1S0F8C+Ib4KmWSfxZ92KeKo09l/zjouxiA0FDn/35Lot781Jfp9FxjodeJ1Ntm2lnfpC4Rd0fuw/YKHqHv799eHajQ/5OcfVK9xOV7JA1vV2bWf39C5u2m3OXaGdX7igOtBX3pS9RxSJlCxYXTOuV8o8GStx3/R+Hbb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DV2d1VHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DV2d1VHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE158C2BCB0;
	Sat,  9 May 2026 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778292661;
	bh=gpjiOZlTziOhBtPXoUAAQ13idW3W8B4lBEcXF09hAC8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DV2d1VHJF5a4M5SxoMObg/BKN0kkxJsO4+3ndHyps1JB160cf5AHKlhbn9tYl0zrG
	 zRFBj0k4DOoB3JEsgaZrsaHkfMs8+KWPjFpS3IB+z9/mnBLtpQY7GFUmPzs/1y7SCp
	 3v8VxjHvcQKk4lTqYbAsDmJLCrHQifvT8Wacs9ZUYBtfL6ssUFKNCMpfn4BasloAnj
	 kFb6Ry6KZiyr+8pB8eopPkFU9NiUNKQqJnJtblS+O6fQ2HsgRgZUk2sQFp8zs58CzJ
	 rTpQ4zur9jgHRDa9V+7qTSZKH+8NW3gCCnZqqXLUFDjXnuJwbUFd1K6cMOQWomCBFk
	 MpqjmczRQvH8w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE6738119E7;
	Sat,  9 May 2026 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/3] net/mlx5: ICM page management in VHCA_ID
 mode
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177829261005.938343.11783726495806061348.git-patchwork-notify@kernel.org>
Date: Sat, 09 May 2026 02:10:10 +0000
References: <20260506133239.276237-1-tariqt@nvidia.com>
In-Reply-To: <20260506133239.276237-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, moshe@nvidia.com, agoldberger@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 6 May 2026 16:32:36 +0300 you wrote:
> Hi,
> 
> Find detailed description by Moshe below.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/3] net/mlx5: Relax capability check for eswitch query paths
    https://git.kernel.org/netdev/net-next/c/8ca32460815f
  - [net-next,V2,2/3] net/mlx5: Make debugfs page counters by function type dynamic
    https://git.kernel.org/netdev/net-next/c/5796d9fe0b88
  - [net-next,V2,3/3] net/mlx5: Add VHCA_ID page management mode support
    https://git.kernel.org/netdev/net-next/c/1fba57c91416

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


