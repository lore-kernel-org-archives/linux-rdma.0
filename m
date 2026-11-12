Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447606;
	b=ttU3BjwvMNJpafM2K7K6TnjY3HjKvQwA6fyvfCG3YqdCKuvjK8ooxs+CkgTECKHl7d4C
	 6MuJN4BhNZ/9qU4h8XZ8zpVCGIbmV1SJrLQAQDHrubbdrc5B8lqZi4ZYVPRgUzLQ+0mCh
	 loLLlbM9iCvs4Esuu0F8puoaW7GkUzumWDjK3pJpOmu2K6LLUHQHksSBrlSy/e+AmiHyi
	 5usX5Q78kegPYpOPC8o6OFj0FIm6+X7VmhUvglLkoc8eEH7RmZfz7xwCap61vFP/8nyNZ
	 aSl6gfaBJJaI+anhoK5Rj/rXYjz2IzqiLB62BJML5pTXZaY3Ndma0L4KbBvedxTaXHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447606;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=LOnj0qQyAmBFZA7CPZLjLdhnZUabULtOXuzIaolklQQ=;
	b=US0xirKh6IlYWGosIcHRwNwGhvkCAF0XvrKDjs/r9eP+Gbs/+zOOkFLdWOMTXty2WT+D
	 sLF5MFmzfzJLQdGEdPOjfCczZn18hq/N7kRzGpvWkjOBjS0helsyKDmGUls4vylupzPxD
	 /tAYV73fZ695rR7MdHlk94brFdY0IWWjgRYJEVibZwF7XsjesHIbsIB1QbFt383ByBh7P
	 Y/IGFLFMn7lYeHP4MfjYRRcjIMB253MWXI0DHHoRcKXCMEElYcbsVGo6HXBfRNflIBKcs
	 KyUY+PCflx5IpfB3tLWecyFC8CI/8a/JtLQyAdhzlzHg7KQqNCpbQ7mAfFvoA24t7PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFisZ+7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A3E606A324;
	Thu, 12 Nov 2026 01:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFisZ+7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5CE1F00A05;
	Thu, 12 Nov 2026 01:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447606;
	bh=LOnj0qQyAmBFZA7CPZLjLdhnZUabULtOXuzIaolklQQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WFisZ+7+LNJWNasboFKnGCx5bXq25rCmj9XWLngl2/+ztX6/UgM5kZpk56q4HMh9+
	 M4ivNU3CAWDMzFNdBsSdot/FRX6qEWAaGIGmRVvvme9K4QHb4w6qIc0LbWFtQ26T9K
	 FGoXE8m2v4Goly63/pqHLzjzIVQl+E7qFpXuBfod/C1ncFYATDR0as3z7f5iYQBGO5
	 nRpKaVNYfcaBBhYFNBxou//0mhx28HlV0YM6VllmY4WEOnpstAjpbc1vBkGbBL9lHf
	 W6ejcxJGrBx9F65ThS28y94WCmtYR0HXoIQUJsqHYJAjiBJlJvDZN+BpOSy962Fc+c
	 MgZLb3VuTgqYg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 210BB391AFCF;
	Thu, 12 Nov 2026 01:40:06 +0000 (UTC)
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
Subject: Re: [PATCH net v3] net/mlx5e: SHAMPO,
 Disable end padding when relaxed ordering is supported
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179444760468.1758664.5040902108212727861.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 01:40:04 +0000
References: <20261110035723.26587-1-dengjiabin2023@gmail.com>
In-Reply-To: <20261110035723.26587-1-dengjiabin2023@gmail.com>
To: Jiabin Deng <dengjiabin2023@gmail.com>
Cc: netdev@vger.kernel.org, dtatulea@nvidia.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Nov 2026 11:57:23 +0800 you wrote:
> When SHAMPO and relaxed ordering writes are enabled, aligned RQ end
> padding can corrupt received TCP data. Due to reordering, alignment
> padding written at the end of one packet can overwrite data from the
> next packet.
> 
> The current RQ end padding selection avoids alignment padding for LRO,
> but not for SHAMPO. Extend the condition to SHAMPO to prevent this
> corruption.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported
    https://git.kernel.org/netdev/net/c/68c183619f24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


