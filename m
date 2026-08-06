Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18943B6C0A;
	Thu,  6 Aug 2026 02:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982258; cv=none; b=Ccl+XgH5SZd4uzJvNpWDk5+GXDuJAvhHtEvct5hKrxrIEUKQgo9UlITUv+IQ4RJ1PsFN1fZt3sUF2pLwmEgUdX4/K4LEVjSRsvv2VPV9darqstJ97kzsDoJTtsP8YDOM5X8Hy8evyy0Z3xc2hX0mFynJY48/mq2stWXOKhuNeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982258; c=relaxed/simple;
	bh=tVp6hopkLoClBZHEuYEK03FImvUVLO+r+9mw28Qxszc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=g1RuhyjnBmKGV+zby9cWoMpvIsbLzcNykQ1CSMTXFuX1RPF/BJgJuMLtNw91WzIxcE6wzlcY1m55w+m2/Mn3l9AM/FLVxxicZ/baXk6PDHuqR9932YCHaPNDXsjKunbtGh4Sqwj1ROR/Kkl4bHKTA/Q1c8MqMRdMVLF1G7fKnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gg3iw0r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gg3iw0r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B504D1F00A3A;
	Thu,  6 Aug 2026 02:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785982256;
	bh=fG8YyX5+FM3+qtg7vf2rwkr7TWZHBCe8tUbM58H/onM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gg3iw0r71uSxDDckoTEnrDwEPW97ytIRqLaIxjwbV3W4Xg8GKgEdL+pK87hSrkFYL
	 rs4A7zMHJRlp3CqPl2ftn0rVH6x1aOgRqfTaQhzL6slVB1AhckDOYXGo3Z8htdO1db
	 kG0H8PpMXJfBEL11DmBN1qIDc0/+WLewSpDPq1rYKYGWcXGSGufG2lzMew5cFOaFdr
	 G9MXIHUEvPoIOZViDPRVaKdpXzreW1V8cvxCTscv1KWULzjaalRYueP+bPqd+zoecK
	 VkTLiUm4pdYo8ARxCmwCv5XHCm0dQ/qxgBoF0lYcCzkk0Ye9MmL7b7aqn5O63UOV36
	 040rhN+Oos2ng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939C8392FFF5;
	Thu,  6 Aug 2026 02:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/3] net/mlx5: allocate doorbells from dma
 pools
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178598221613.607412.5420802741029885207.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 02:10:16 +0000
References: <20260803132520.2891860-1-tariqt@nvidia.com>
In-Reply-To: <20260803132520.2891860-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 noren@nvidia.com, saeedm@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 3 Aug 2026 16:25:17 +0300 you wrote:
> Hi,
> 
> This series by Nimrod extends the mlx5 internal DMA pool infrastructure
> to doorbell objects.
> 
> Doorbell allocations currently use a separate pgdir allocator. Moving
> them to the common mlx5 DMA pool implementation keeps the same coherent
> DMA allocation model while sharing the pool code used by mlx5_frag_buf.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/3] net/mlx5: initialize doorbell dma pools
    https://git.kernel.org/netdev/net-next/c/46f636cd620e
  - [net-next,V2,2/3] net/mlx5: allocate doorbells from dma pools
    https://git.kernel.org/netdev/net-next/c/c29235677f5e
  - [net-next,V2,3/3] net/mlx5: add debugfs stats for doorbell dma pools
    https://git.kernel.org/netdev/net-next/c/b7cfcc9d3dfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


