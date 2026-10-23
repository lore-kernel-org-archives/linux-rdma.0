Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792791007;
	b=bZv8Yi3L+zZ9HHll6nXTG6mWyY/Lf6a83FWIXPIp+T2GJrumsKXPFbf+JXiKbfBp+VHn
	 pRfjHwPQ01cpkRn1BR4VyCeDVUnT2VZHr5EDc9qYuQbqeDop+3DfcUg+p517TiNfIb/4E
	 6uJ1c/xo/6YNXms7B9wTqCTqPn0K+prNeZEXPfsrvLj0mLO2gzxD7BQ6Dy2mCnIU40X7P
	 IkY4C/F3dnxhVXlEkl9ypmX9TfA6RZQhlVSlh5BIxVkjW2k8ZgDjhJx17yjxAYrX0UzPU
	 iFNLiKhk0RlYyXePDM6WznxsncLDUaCVGpmxsoT1MhanXy2gxhNq53T0/sxtAwidDEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791007;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=w1NTQGAFkLyljwKnxC/RywEhW5IGslkSpTWudefCZiw=;
	b=Lo05LFyHscg/p9js3rKIVc5PlZNMzFDUdSY2WBeUMjeO7UUAIa1nNtc8w9Ku672Mh1hP
	 wcmQpDnoXqN0eGS5SDRiP9n8cAdYXAg++iqlbQOy3+ES0yHU9zg4vPeFw8+SciwHfDoWh
	 QzO9fLqP24DCqjk414bBEfNqV/yWP4F34qnRdQSmoi2qFN2Yu4cvMeDsa58UjT8oAZ6Y/
	 81UopgjuTwGBa5WvKPlNGazJjT2ysWgKPNNCAaprXeUkDnOuAOCsu9oDEIQW9cISD8tWj
	 4jz4cbg36OGR5qrivwuhWijyGHMEkbi/YJ4ivi8dsM7E4Lopfa4bNMvhrvhGHmgTtvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCky4xFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42831606A325;
	Fri, 23 Oct 2026 21:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCky4xFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F2A1F01825;
	Fri, 23 Oct 2026 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792791006;
	bh=w1NTQGAFkLyljwKnxC/RywEhW5IGslkSpTWudefCZiw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=fCky4xFmMMLpCDaa+uPWBzHv3RKnphUrOrIIGdsxTluGY9JOPaYw4mD9DL02bZ9IW
	 ELxp2wxrxct3SGwIRWHXdzawUds+ZWh/aG2i8MAO6KhvR7UzOUroVZUyIGav/997pj
	 wa4uMrJmjHUD/jOksQHqAjJMM1f+D71onWn8pmaQZp1t3s6Wuko47YIUwfoA7e9EhG
	 MAVOqNcG5tI/HKp1PejMDeW7qGB+NXcwMTet/xEPjKUgYl+XPTXAizbQuQcB+Y6aDa
	 oRBVxg0M434ZxWgPx+XmJ+i1hLDXJ1/bLGXyrgHQEPa0xqV7huexr5PrZ/YT8k9ULl
	 CaagYJlizFd5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE5BE391B157;
	Fri, 23 Oct 2026 21:30:06 +0000 (UTC)
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
Subject: Re: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179279100557.1280672.16030816624562750403.git-patchwork-notify@kernel.org>
Date: Fri, 23 Oct 2026 21:30:05 +0000
References: <20261021062805.3466208-1-tariqt@nvidia.com>
In-Reply-To: <20261021062805.3466208-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 borisp@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com,
 dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 raeds@nvidia.com, rrameshbabu@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Oct 2026 09:28:05 +0300 you wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
> makes it possible to merge those packets in a silly way:
> IP|UDP|PSP1|payload1|PSP2|payload2|...
> 
> That happens because the HW GRO machinery doesn't know about PSP and
> considers it part of the UDP payload.
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: SHAMPO: Do not merge PSP packets
    https://git.kernel.org/netdev/net/c/46bd2bf65b93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


