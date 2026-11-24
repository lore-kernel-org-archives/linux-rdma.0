Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531811;
	b=P82HXeZWkAfR07IM9ZkVL9anYB5Rxz0S9QNgnexnOI+YBnLxCgCsQ/Ss5whW3WsaykkT
	 QOqbY78eEygV+Bd/sWwQv0O/sylxmuwKGN1fbHNdKDs0KNLM0Nzkah0RTDrgs/v0dlmS/
	 3g7srLhz1KaKQZk8a/j5Vk13ZgWVkiNoQPHuIL3ce9i/GbW6nEF6DBnV6OlV9XHscn62P
	 Uyp7OfmmJVsps7atjlgwn4F3nGE0gTeMhycToWodcqXFBmg4noYwg6S+cWeo+3IbHy/Ue
	 KlT+9Lrxcmr0k5f4sy2bzPrBcp5sOSs1g2nDfDiSpR8k2hzJNgTTEhjwngWg6huAuNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531811;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Pcp4WguJuM1ZHv2DoyXLtgeQgZAlTFeImIh+QygQghQ=;
	b=NMAMeSIDZGHC3zAbjBgoyel13hIJwlVPvEOPCgUcMGeQk9RQXRVGnGQ/msow2uvk4RNg
	 rgRL+Pwz5Aj27Z2dDknIM9I6BCdFb2ysQ9vcPty+O0KwsMJpdEqrN9xdYjDrflWx32Y94
	 ZrPH57TpdusbKbdllS+nUtRvt1G/NFSa4vNJsZU7v5ODoJUm0N9BDpWgo5EZvI27dSR+f
	 Wjm0md7t1+yWXMPSMn3mrrgEo/926lhexq+Mq9H3tuQuAtr6mQUenpIN+Sa+nTai/snWr
	 BN/OXljvoVvg5Cekn2Ram3stIBCQPBaB9lHK8sLW6qtNL4CrrVq7R2Zfzta/sRFvPyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+G7dpSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F691606A321;
	Tue, 24 Nov 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+G7dpSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BC31F000C6;
	Tue, 24 Nov 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531810;
	bh=Pcp4WguJuM1ZHv2DoyXLtgeQgZAlTFeImIh+QygQghQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=b+G7dpSMo+Zvi6vhhv1+SQ14yBb6ksk/tNVqf5WLTDJFC3mlITWEOrefxEVFnIuWA
	 YVIDi/fkAwmMXR6y+DY9aOnKNQiP7fM7O4jTX5PbUC5KCvdRQ53ob9O8COAYBFQnOI
	 8l+KGseUBehJBGqijxqG2iYlkomWkODcvVubxw/cFraMJV4bVaDjH/FBR50YFZwqIz
	 3h9gKO1WGulKVkuMNnC4Uy+AIgmwwUJlFkv8ueTZClKUccM3cLzjRDNET2+d24krkS
	 q1qxn7tzn4AE+xYIS2YoYVLlRp1L1oQ91Q/R3Eu3l6XH4GGKYvQtWqMXP3dGxkY2K5
	 3mFiaLyqLhbsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773A23931128;
	Tue, 24 Nov 2026 14:50:10 +0000 (UTC)
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
Subject: Re: [PATCH net-next V3 0/2] net/mlx5e: Batch RCU grace periods on
 channel
 open and close
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179553180901.3581158.10974108466561376981.git-patchwork-notify@kernel.org>
Date: Tue, 24 Nov 2026 14:50:09 +0000
References: <20261119103935.2190627-1-tariqt@nvidia.com>
In-Reply-To: <20261119103935.2190627-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dtatulea@nvidia.com, gal@nvidia.com, hawk@kernel.org,
 john.fastabend@gmail.com, kees+treewide@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 lirongqing@baidu.com, mbloch@nvidia.com, richardcochran@gmail.com,
 saeedm@nvidia.com, sdf@fomichev.me

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 19 Nov 2026 12:39:33 +0200 you wrote:
> Hi,
> 
> This series by Carolina reduces the time mlx5e spends waiting for RCU
> grace periods when bringing an interface up or down with many channels.
> 
> Today the channel open and close flows call synchronize_net() per
> object. On close, RQ, ICOSQ, TX SQ and NAPI teardown each require a
> grace period, so the number of waits scales with the number of channels.
> TX SQ teardown adds a wait per traffic class, and XDP and QoS can add
> more. On activation, mlx5e_activate_channels() triggers the ICOSQ of
> every channel, and each trigger waits for its own grace period. With a
> large channel count this makes link down and link up slow.
> 
> [...]

Here is the summary with links:
  - [net-next,V3,1/2] net/mlx5e: Batch NAPI RCU grace periods on channel close
    https://git.kernel.org/netdev/net-next/c/b2c2b3c9fffc
  - [net-next,V3,2/2] net/mlx5e: Batch ICOSQ trigger RCU synchronization
    https://git.kernel.org/netdev/net-next/c/2da7b5cda895

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


