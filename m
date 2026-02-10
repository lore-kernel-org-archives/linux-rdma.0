Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA3036E476;
	Tue, 10 Feb 2026 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770735610; cv=none; b=CVPAVmw2/6gAtrHVakJkPuYntQQ1D5nHePvFwhqiSkQ6LqFOt00ex3/cEWUtFy9s9YtjSPlnVTmcpMC9pHMnGW9x1A4/pKlRhyTAeHzJmMteVwfKQrAL74AuvADWxxNkunX5UpkOiKQL//+cL25rGZY+ZXhsLAY8HHayPswoEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770735610; c=relaxed/simple;
	bh=tKMNJiUTGeWqAqxNWcIQZshtd5oLRcw41cmdLNIwTw4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=f+ixl9Ss42JcNp73lWCtqDTdoUGoybyVjZfNPN9VBWXDIHCGLK29YcdCgtXzoWMTCEp6Q4dwfIVeq5QMVpM7B9ezroAg7yZarFf6Ka1jTvUHHhFtqoW0Uheul76e0FIUsVPj9+RbLzQLP32Rwzx9CbFa6+rEt6TRptgUpF2SFF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/ZcX4MK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/ZcX4MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B21C116C6;
	Tue, 10 Feb 2026 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770735610;
	bh=tKMNJiUTGeWqAqxNWcIQZshtd5oLRcw41cmdLNIwTw4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=r/ZcX4MKiMlrAcZWzEGalYIEP5T3KlUlFXO7uXC+HlW8W3uY57z2Pcjps2/qzo7hA
	 y0eZLmGSNw17eL3DMqZeMv38yzyBQq/rWc8lMpAKrM55Mfnn0zVyRdD6KRqho8WF1X
	 BiGHB65AvqillyjLSU1gOUfiretr0Ypex4nec/jUXun78qA4kZ7nf7wbWIqLgOGMGF
	 y6fXiTyGL50YShSsrHOWZLVuVwp3Tt7bmEFN71duqSBWSm0xwf7mlj/XuCZpV4YxzW
	 qffgfDvV+gqay/kOQwRSDzCtZWKjhc/2mbS3I9VmyCnCsHUkanMXPqrkMxlc8pAa2d
	 vGu0NfRTR/qrw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8517139D609B;
	Tue, 10 Feb 2026 15:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: remove declarations of
 mlx5e_shampo_{fill_umr,dealloc_hd}
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177073560508.3544204.5534906377848723317.git-patchwork-notify@kernel.org>
Date: Tue, 10 Feb 2026 15:00:05 +0000
References: <20260206-shampo-v1-1-75b20c6657e5@kernel.org>
In-Reply-To: <20260206-shampo-v1-1-75b20c6657e5@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 06 Feb 2026 11:18:51 +0000 you wrote:
> These functions were recently removed by commit 24cf78c73831
> ("net/mlx5e: SHAMPO, Switch to header memcpy"), however,
> their declarations were left behind.
> 
> This patch removes those declarations.
> 
> Flagged by review-prompts while I was exercising Orc mode locally.
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: remove declarations of mlx5e_shampo_{fill_umr,dealloc_hd}
    https://git.kernel.org/netdev/net-next/c/ad1f18e985cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


