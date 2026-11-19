Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047020;
	b=X42MEu4v/D5rzlX6pkWRHTotS8JhJcNVTJzcXM6+qR2o0wLHtMT05YrGdw26w2JmjA5B
	 mukhbSCsEa5Es1/EeUxoNwkRuz4oEPwSQNYrVThy8rOykEJv8CJT5cNdpAg5IQgsCAWou
	 RRGSyu2YV6gbltlAZr6GIlxPzt/fHiktt6gIUbqSZqzGLShdHw5qS+l2HxxFGzu6scZvH
	 gnxxdPmSawjzQMOE4bYVDz/LqVfDUGl7aeqpdrPETymFUec0zq2zcWzHbFWHBcm1JSYvf
	 LLpfL5APwWZXiybsftP37GIi51DRuiL0kn0+2y9w7jmXmbelaN2MFaU9DpG+IvXGZtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047020;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=9RLjj9BndOZAoQkYjupQIjSIxTscoonLAUIfz9OP5z4=;
	b=TBF7lNQuG6LJlaqj/h5E3MnynCUwQdXxQ5+BXcJygWEAR1r+pJOCRgUU9+cyuiZ+xT4r
	 QJhOnFJ9AE4szimDrPLt2UUcycV2lo2kcICX9Lby7M7cVckRdmhi/Yh0PJg7Xu0KophRb
	 r4y9RsmxcX+7uytOxLFfYpGY6g59HaOaQeJ6p5yjcYqo07oX8DPfKyj8rtPMfjhA2VdeI
	 etpKHoXIgINPkTSLKrQAphbwzEnQ2iNG7hlgEZKRCIHbPiskeRBCiHnRwfFCD1gZTZm9d
	 orwsxscWPuCYbWlcENFMe7zuSQt7xsMQvjhl5MGmjTZJEuuviGvdmsdFPOas3ep1MIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1XtHK+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776660A5BCD;
	Thu, 19 Nov 2026 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1XtHK+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807781F000C8;
	Thu, 19 Nov 2026 00:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795047020;
	bh=9RLjj9BndOZAoQkYjupQIjSIxTscoonLAUIfz9OP5z4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=K1XtHK+tMpaxoUDOpZjCP+jUgn9CvF940EYKiv/y/NSPS/aYBQMaGodWGJBVndkd7
	 Ew7hIDrfdabktgeOjbSQzHewM6gmYqVdnx4cd8aNfNX0nEDZrpVvPzpqNIx6xpYCTE
	 5gbH9nslf8nVHBWQrq3vS1BREYI3CVIMBWptknNQTwvP2g3JsYR//22OhDieMUIqRl
	 wZIpMez8mw8U/6J/ZK+OJe/Xi8+INLXbSrXtiXCIS9e6H6AcI6cfe6GJq/ABVa7Z0m
	 JND/Y0ANVYJVqdU6lEg5vsypNjzxbhrm+ReYn7f4kmwkI6BTrASO77Bw0zqtwQarIs
	 rZrb6tAhnb7VQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773183808210;
	Thu, 19 Nov 2026 00:10:20 +0000 (UTC)
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
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179504701903.2637749.7879620797013573164.git-patchwork-notify@kernel.org>
Date: Thu, 19 Nov 2026 00:10:19 +0000
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
In-Reply-To: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
To: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
Cc: davem@davemloft.net, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, andrew+netdev@lunn.ch,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, gal@nvidia.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, noren@nvidia.com, cjubran@nvidia.com,
 bjorn@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Nov 2026 09:05:58 -0800 you wrote:
> From: Dimitri Daskalakis <daskald@meta.com>
> 
> Since commit 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split
> settings"), mlx5 no longer reports tcp-data-split from
> mlx5e_ethtool_get_ringparam() and the reply carries only the stored
> config. With the default config (auto) the attribute is omitted, so the
> device looks like it does not support tcp-data-split, even while HW-GRO
> is on and SHAMPO is splitting headers.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] net/mlx5e: advertise tcp-data-split support
    https://git.kernel.org/netdev/net-next/c/db368b0d1fc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


