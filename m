Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABA53CF668;
	Thu, 11 Jun 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173813; cv=none; b=lkWlrURAlMHWt5OIsqSrVEG7F7Wahz4iCAwfrgkOUcSKk6XieOvrq9tAAfdvUZjax/JATQWx3uEcqgrJAF6ypoSSjyNpOW+R0QI19MNDM/eM2q8ur4YwPSwuFuL3jaVpOkAIGeS1ejIOOc7TNOu23pVViPds1vbdlxTovSqKr4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173813; c=relaxed/simple;
	bh=OuZq3mVXMyVCm3+JjWF0hDZdBa6jW2Dn70qt3Gy9++Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QN34/CsxuBIl8zSjMAoQ6gEyvy8J68WBrvsJEwr2vT97K+a7H0Bfhh6w+4AvG6e9LMMKLZ+FR0UQQaAlpOaheGOCGPexD1cCV3xD/g+qHhR6hlOzOV23JoLjl5n2+l0fpuc3IrlMcrH4dGHcphHaxQl7VMbK1CH/ithFg7tvT+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHYfCA6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHYfCA6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7421F00898;
	Thu, 11 Jun 2026 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781173812;
	bh=CP7oJgGA3nydKgnxv8123M2/WZl/0X4Xrg6IbE6BQa0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aHYfCA6P1GvUrORi8Y70gryGkYr0iG0zvtFgnYrZ36etcSj3A3o5DwZI5EY9jCUhg
	 Xk1PFKGnkNwS+3OqCqSAihdBHQTt290pMNobRQhvKjvgV2pwMaM5kuYwaDRnJ1qgOi
	 dVI4LKYFmrdkRpsJTy7Zm8CxdowC6IzBRxXDsfILALL+dCuo7Qs12jCs45tCpKLapR
	 SGbAcYLw7dsgwsR7vYa5Mq+R+euYrFO6jCfO2dwDnKvDNYjw3MD/2I7diYEwDtIybk
	 1Fy8X5I5nnNVhVfh67Zd553cy5NqE5GjqQwS8mEI31xPEjeJQbncnaElYy8PGHxV0K
	 viFz7OlVdNpGw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B153930E48;
	Thu, 11 Jun 2026 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net: rds: convert rds to getsockopt_iter
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178117380939.3882694.7758300491117426990.git-patchwork-notify@kernel.org>
Date: Thu, 11 Jun 2026 10:30:09 +0000
References: <20260608-getsock_more-v3-0-706ecf2ea332@debian.org>
In-Reply-To: <20260608-getsock_more-v3-0-706ecf2ea332@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 andy.grover@oracle.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 08 Jun 2026 02:44:56 -0700 you wrote:
> This series continues the conversion of the remaining proto_ops getsockopt
> callbacks to the new getsockopt_iter callback introduced in commit
> 67fab22a7adc ("net: add getsockopt_iter callback to proto_ops"), this time
> for RDS.
> 
> RDS is a little more involved than the protocols converted so far, because
> the RDS_INFO_* options snapshot kernel state directly into the destination
> buffer: the info producers memcpy into the pages under a spinlock via
> kmap_atomic() and so must not fault.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] selftests: net: rds: add getsockopt() conversion test
    https://git.kernel.org/netdev/net-next/c/b74360369e13
  - [net-next,v3,2/2] rds: convert to getsockopt_iter
    https://git.kernel.org/netdev/net-next/c/6e94eeb2a2a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


