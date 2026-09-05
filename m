Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E783A9632;
	Sat,  5 Sep 2026 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639680; cv=none; b=r+XRCSXhHr5wRKhshuiEM81NJ0oTt5gpA1PFCBVOrACPT1Iif3EEkiYD4DrmwhHM5Yc8jhk+ff7Ycey0Ty5KjQuWCBq8IA/sKGCcV4zHmlfOYwFFM7FJjp/Q7xL7xHPv95qKKJlpcyv9M6ysKimVpay8FM2zX8aTq4qUcbwPQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639680; c=relaxed/simple;
	bh=UeXx2CQskLNi31I/Q9pxOcY6Q08XZOFZae+MRQWA+lU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=i4sMzBdcbef8PzIL6UWTtna+gRpc8yW8+mo6bhKuUg2/z0lHLYZPE/zXWq9Gwg8Vs6gOXELzulRbb+EqfSZPhgZd5d8RoOU9nTGzTbqbls8ciUkRPguhYTzd4p/lHcGjOtYnEYU1Mdq6E6SZ0Eega01uVMAtDbXFLEZMDH+/SvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CESo50uR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CESo50uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE66A1F00A3D;
	Sat,  5 Sep 2026 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639679;
	bh=GSAPy7aQ1sCPtzFfspGLqF/TrMFWOSJ9H/p/vQrcFs0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CESo50uRHX1yDUHhJr6WsA3jwXraynGkxNLJe1meTXaGBBZV4sWBjmi51w03EmIhT
	 J6dcmzzaCq28ylTpz2jLh0/t8lW61blDRKBL5Zb4PDslDHvoOrTNzQj7DgENhciBWH
	 /FTCZmCH/Oe0XqqkdGQaF1fFQzrjJr/miRSkEIMj3zHzgVzWrX4jCd0Ld0GQbWOlxB
	 Ch9XksMluebaB9eGUnQRTMo3fvJbKGLAUuR9ulg7HhPXf/RJCe9N6S/DysNCXdLVGp
	 SmFzJjJKkY67d2DEHpGO4oOzepM67iSNp7GTY5Dv6Y7hhFCWikTgn+rVsZhnxN4Abb
	 c7lbH7qTVQRRw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568D33924FED;
	Sat,  5 Sep 2026 20:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net/mlx5e: RS FEC variant fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178863961888.1343052.2330784257627019651.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:20:18 +0000
References: <20260902164634.3657606-1-tariqt@nvidia.com>
In-Reply-To: <20260902164634.3657606-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 dtatulea@nvidia.com, eranbe@nvidia.com, gal@nvidia.com, jianbol@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com, shshitrit@nvidia.com,
 ychemla@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 19:46:31 +0300 you wrote:
> Hi,
> 
> This series by Shahar fixes three related bugs in the RS FEC handling
> for mlx5e, all stemming from incomplete coverage of the three RS FEC
> hardware variants: RS_528_514 (bit 2), RS_544_514_INTERLEAVED_QUAD
> (bit 4), and RS_544_514 (bit 7).
> 
> [...]

Here is the summary with links:
  - [net,1/3] net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD
    https://git.kernel.org/netdev/net/c/802eedcc0b25
  - [net,2/3] net/mlx5e: Fix setting RS FEC after remapping
    https://git.kernel.org/netdev/net/c/b9d755c5a375
  - [net,3/3] net/mlx5e: Fix reporting support for all RS FEC variants
    https://git.kernel.org/netdev/net/c/c84ce45a7a3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


