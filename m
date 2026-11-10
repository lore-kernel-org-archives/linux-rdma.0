Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334982;
	b=3Gz30Szllv/fWBzsmL7+VIdQSKnRkpzDZVZxHM/m4HXf3T/P3h0nreCfQvhfeYS246jI
	 6xMcxtyNKEVKmzunA/IpFM2PbPYbex46wtVSUyZJhcJ0U25e/1Ju1ZPt5z6R7yMmTJ8iN
	 z0I4PZx3l0pc0RNWGgR3RLmMzPn/lbo9sB3NznZgBfozc39lq/R7h0fpJuLeYfXX5sCUQ
	 z2ES7xYW4oUxRssjQIa4Pb2Qh0nMpflxfc2tqM4u3uim3KrcHdh6Ctj8pZY/y5Bifpy28
	 OaPnWL4iRJStgl8NwTt5k0BYBI08skhtMq/ytRRhTmadRTwLlcRBQOPjOR309z7APhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334982;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=nM4EMErCeXJNQs+7ozPXWBVLaYZr0fUdSK86cNZxul0=;
	b=Tk/9dfRsFnR2LJEYJHm+cFzV1z3MH60mHPODDX/gUZm9748FCLBHrWGiPXtWK0VYWPUn
	 IMonKva487P5wcz+szZ5McUAAKYvvb13HFrme5HzutBD5ebk5iY/ZHqcwViG+uud6P60p
	 zDQ/cBS9DI4enXk3py/9ivYQwsMtQ+VC19phtuUR4gpM7e2wpAvq53K1f5n7fVNk91v1D
	 +PiHVy5ZVgdcho5KehsMh1P5jPVPzGkuxnHY6vQIDqbN56NItzoBScpQ+H8PH8cd8I5Lb
	 MQwgo9NIiSpBD2SX7IhjWz2YYwhNLxI6JCtgQbcvksyFtXdNlHJJc3l858s3TI/I8gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FuHErv1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D542606A320;
	Tue, 10 Nov 2026 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FuHErv1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04A31F008A1;
	Tue, 10 Nov 2026 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794334981;
	bh=nM4EMErCeXJNQs+7ozPXWBVLaYZr0fUdSK86cNZxul0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FuHErv1guC8Yh9nbEeBWMhChLKI+Kefs48Hz19+LPzcu7/KuyXGDfceKcbxYfCUB2
	 YzPF84dwM/0ETHxVlsN3B1hyoucuFatp395mjRAZprR1DDh99pOiBTjx2z1WcfjnDW
	 W9br8BLBLUq5QpBcpGfEszxaGHTk+2cEquZfjeC3WxA29gv630zWxEaIEGwIZ0uxOh
	 Gqk8Yv1x3vLKgDJTQdQGiXYM7uCksrDaXcazPVOoNykR+kFXJ6anV9IcLLjp49bzE1
	 Ej/Ztev/qtfqqdGGlewMLgEpAhiUssepi6NNs1my4/ADfUEEhRgXj8dA8HT8Z3cfuv
	 /JUWGlBnLbNIA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B31439D608B;
	Tue, 10 Nov 2026 18:23:01 +0000 (UTC)
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
Subject: Re: [PATCH net] net: mana: fix XDP_REDIRECT of pre-allocated RX
 buffers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179433498045.4118637.10096653969989484640.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 18:23:00 +0000
References: <20261102064324.806414-1-orgads@gmail.com>
In-Reply-To: <20261102064324.806414-1-orgads@gmail.com>
To: Orgad Shaneh <orgads@gmail.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, longli@microsoft.com, dipayanroy@linux.microsoft.com,
 hamzamahfooz@linux.microsoft.com, gargaditya@linux.microsoft.com,
 ernis@linux.microsoft.com, falakreyaz@gmail.com, jbrandeb@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 Nov 2026 06:43:24 +0000 you wrote:
> mana_pre_alloc_rxbufs() fills the RX rings with plain pages from
> dev_alloc_pages() (from_pool == false), but the rxq is registered with
> MEM_TYPE_PAGE_POOL and mana_run_xdp() builds every xdp_buff with that
> rxq info. mana_rx_skb() frees a !from_pool buffer correctly on
> XDP_PASS, XDP_TX and XDP_DROP, but a redirected buffer is freed through
> its memory model: __xdp_return() hands the plain page to
> page_pool_put_full_netmem(). This triggers the WARN in
> include/net/page_pool/helpers.h, breaks the page refcount, RX refills
> fail and the queue stops receiving.
> 
> [...]

Here is the summary with links:
  - [net] net: mana: fix XDP_REDIRECT of pre-allocated RX buffers
    https://git.kernel.org/netdev/net/c/67869597fab0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


