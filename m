Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900132ED40;
	Thu,  1 Oct 2026 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790816415; cv=none; b=cj42hFI4VUbW+7Kmwl/rMwn5EiLF9MqLeJ1L5QwsP591kFqgWiVniYRpvYxcS1Uqw5YSIFIeCCY8cZ3j/vhWiXSQei5iSVsp9g4tWeePAbXUPBfzWleZidJqNV/7+JO5xKbe/JNvcw6nubELXfNs/JdLiCxgISVAiDU5L+mE2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790816415; c=relaxed/simple;
	bh=WQEgXq5WVB1r1zuEt23++l7VKTq19csvlUHx/Uj4QJ8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EG3CM5GOUVbnwb1DGVW47mZqlgMrua894aFe7SfcvwRSH0ujstQorGpmAKCSz+noiB5WRdVctSdiB5u/KP1BgYSCqWzo3yOZZQjf+s74z6kBOd+JdRjZvFuDSXpWa24vidl5WH/I9tMgAWF5+A95t9gMbGlIOZ+IpnYHJvBQm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E6+fm54t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6+fm54t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806D81F000FF;
	Thu,  1 Oct 2026 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790816413;
	bh=C5yUNv7tikueVHRi9pXuTNwTr/4p4aH3fS5wUQBrUdU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=E6+fm54tNYgsWFEc/hU2Lyt/8E6nX34RyimPL3u875ZOOEIgAIchjKxgQOG46IZNa
	 6H834WGJCbQ6z5IJCoBsVqF/YK5oFj8YzUcZAz0/4LRxiKStOI1NmndKb6gZTFxgfq
	 f42rLjH2YbBmE34Zf4hwzFwyv3Buc8ADHiWOHeQQZuHLXGok7WVHyYFZZaVvURCkmr
	 p+vWdpi8d/9H5cd+MVtVpqdSvS23b0wL4Sc9GPLO28tI+oFyuZaMOa9I2Cjp7HbeBV
	 Br3SjlyRmvC8pCHsBKY0hg1y3rP9pAoZ6OMlzR1OsDYhGO1p8rQOnMWiWlBWw0n7wM
	 LTqLuAH++DvBQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 772713AA6A61;
	Thu,  1 Oct 2026 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Hold a socket reference for transmit work
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179081641202.2197065.16814720129705673403.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 01:00:12 +0000
References: <20260927075120.3695060-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260927075120.3695060-1-nicoyip.dev@gmail.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 ubraun@linux.vnet.ibm.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 27 Sep 2026 15:51:20 +0800 you wrote:
> SMC transmit work is queued without holding a socket reference. After
> an active close has cancelled tx_work, a received CDC message can queue
> it again while the socket is in SMC_PEERCLOSEWAIT1. Passive close can
> then reach SMC_CLOSED, call smc_conn_free() and drop the last socket
> reference before smc_tx_work() acquires the socket lock. The worker
> then accesses the freed socket.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Hold a socket reference for transmit work
    https://git.kernel.org/netdev/net-next/c/1bc449382b3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


