Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279300;
	b=ERMV1Z29Jtu7icKcKhPEs6YNfvtzsORIGlOmFLYftIhT2gzFpaEUPh58tG7pENXPufPQ
	 s7eCsE6LuI0S6lr11+D1TzxhrfL8UaAka16WOqKsPAzQg//BUpGKOp/Btwxd+C9z4YRF3
	 ugXaAMzfxYLaEKCc5zkWFT1xcU6Rli5hOpYOCAmdEhl59cRZGd4ipnTFWTJF+bjXFFX0O
	 yL5olLXNDmTPd8u1Zy+5jchds3v/yZHhzgn1ROkVnUBQmyy4SSJ42vO/QMGaQ8DcZrPyS
	 TmXQQbD7Yy2vJ/Ommf0w+kUGF77ItL/yVf6BeM9g9ZKEKouoBFr5wveqCWTbmbJXftA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279300;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=37BqSPaLGXkb00s/yp9Kn2TLThdnaCIQm7fcXVq2/08=;
	b=j6Ueyeke5ZMRioFPEBacbG/DZEMUsoxmYU2Aj0AUpiL+H32ayUUZ7GbzBxTLKvxwnDku
	 QLv52MSNtxhNILfQjtGxk2edeXD7RQ8Wk1zZ06+3uDk5cCRMwQBVmN6votTAt7Usw4398
	 Y+fLtvqVEMJRBmkaFNXb8Hjv3FutIPmTJQRS3AdZvex3P5Mzm7sGQjOC+K0Nn1YE9vsfa
	 CyWcINhkl1rV1l3J7/PAetlutWGTYXcx8q9k5P6NMy29HO5f6tIpRP66u5HYdpzMpd09w
	 945RC+aA2F2yHAEL/fq1FPbLkS8SL03BjWZCPi8XcdetYYXyyy6Gc0LNvrE0R/rcOrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrKeimxV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65060A5BE1;
	Tue, 10 Nov 2026 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrKeimxV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DDD1F0089F;
	Tue, 10 Nov 2026 02:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279300;
	bh=37BqSPaLGXkb00s/yp9Kn2TLThdnaCIQm7fcXVq2/08=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mrKeimxVTNHqvEEoW4yJbklTo7oO1sPcdm9CikJbWcE3KM2mU0GtOQ28QMV4+sizC
	 YtG4H7Ln6h1PWafcsPeUAU80pThwq7ZEhOkz0qZRFqVd0soInnZ4Dwt0azHX9FKK+p
	 ssQLcuqeGkkC8hyZAWYDUOgALPyy6ww/v9h6/FyLT2yGj6WdiWCVre7wC3xM4VDqSP
	 msHSrYegq7dQ2+hJvwUxpa+qjOo3zEenBd4tED6r5P78uAx0ty4q/fPLw2qxV9gKsk
	 OAu+pC4NRjXzQs+d54MdTpH5eTUEIJmTr4bpbace1CEBmDFmmpLsWvkQIyyVh6J8VL
	 qI4C6NBIY2sOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 20F23391AFCB;
	Tue, 10 Nov 2026 02:55:00 +0000 (UTC)
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
Subject: Re: [PATCH net V2] net/mlx5: Use only loaded devices for PTP clock
 operations
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179427929867.3612825.12798869470920457824.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 02:54:58 +0000
References: <20261104183158.758314-1-tariqt@nvidia.com>
In-Reply-To: <20261104183158.758314-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, markb@mellanox.com,
 mbloch@nvidia.com, moshe@mellanox.com, richardcochran@gmail.com,
 saeedm@mellanox.com, saeedm@nvidia.com, shshitrit@nvidia.com,
 horms@kernel.org, tglx@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Nov 2026 20:31:58 +0200 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The PTP periodic worker and PTP operations access PCI registers through
> the function backing the PTP clock. The PTP clock remains registered
> when a PCI function is suspended, so these paths can still access the
> function after it has been unloaded.
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5: Use only loaded devices for PTP clock operations
    https://git.kernel.org/netdev/net/c/908561cc4b4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


