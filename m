Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793412608;
	b=FJQkY5mwJQ7+nZJJlgouuCIZKwksueln4EG/9XfXdtaAyCooXo8HYI2aYz8OlKgySIXe
	 lvaVJvOQX4XXJ+Cb+dwvv1cOjs4gAvq9CCXa0/6h/gsuTvvax5hVWdnaARa2c2MV1fU5F
	 BY1OyE5Oy1U6v8nlzPTMI6i+cvAV4i/UYlhikAd9I1JV/9oKN7FMEWb2606ixxTZiUKuQ
	 z5yvoLNgDAI4AD9tupJCweBlQIrnRQ9mjTR0pFDJzxbdoywLLoAgrofcNwwoD/PVdiOeX
	 yaZ1n1dhk8pyM2HCb87yKKV77RDc4mYyrwwjW3rf2gX9ztQyYqz4k3m3BITUdADedqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793412608;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=jlWXuM6CgwNlYrY/zuqREoyfjwZny9ketxuynQw8QGs=;
	b=i6a+gdKc6Y3LPQ8gUJ3eQwrYO2jv5oJDbP69NnPp6u0ixMTtTnumhRfStZ8beVuwJJeU
	 +bng+ukg7DsqxvNcNKgX4rNaRAJu0fzRCAFaMcd6T7MZGaT3waAPwM8HK6VYmWvi/AXIN
	 kp3BNG6vIw/lsxAohlmtCjhNhuRES0hET5mVc2niMraWS7dkbdY3VXSKRmtgf9EI8+K/B
	 H6Zu/8Quc7FS5s7gp26sk8CUgf7KNz6zkhKF6q6RDIGVzRhjK3VEdhGM0dk1ujucb82IC
	 UDfpRE6RSunoCw7nsMEjKUJnlXkhHZsuY7mNlKswgIKxw1FSL4kSz3mzEqtBxq8JX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdT5lsoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5A606A31F;
	Sat, 31 Oct 2026 02:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdT5lsoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6ED1F00A02;
	Sat, 31 Oct 2026 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793412608;
	bh=jlWXuM6CgwNlYrY/zuqREoyfjwZny9ketxuynQw8QGs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KdT5lsoJ4Y3JISyGqhJaLfTqTmu7AKVUwdYO0kqPea7yoln81VVtSMe4b096slvOC
	 JnR8hUtrld2FQVkvgs9iUxw/ZyJhMygO8vCmxm3pD2iaCRtFXNFKcMvU1ErOIi9eR5
	 zONrpPM0rGL9ayKJWXlk+IePkYKczfXZYVNAyZL8zVvU0+4izZXNICw9arqW7MArVF
	 ycI0hF50X370NB7y7QTesQHEduDHvBqRnXlLY0E1MivxLmHWpAJ2jWOx3v0m1s7RdO
	 XN2Ef74wwckiaUxf50ZTerYPwl9R+lnMu+oCgrzuVudyIMQFl6IgKl3aQEbvZXqHzI
	 OtANW7hyoin7g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 030663800479;
	Sat, 31 Oct 2026 02:10:08 +0000 (UTC)
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
Subject: Re: [PATCH net] net/smc: fix limit_smc_hs sysctl on big-endian
 architecture
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179341260654.1900554.4006093969665591085.git-patchwork-notify@kernel.org>
Date: Sat, 31 Oct 2026 02:10:06 +0000
References: <20261028225350.3753-1-fmancera@suse.de>
In-Reply-To: <20261028225350.3753-1-fmancera@suse.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, jaka@linux.ibm.com, horms@kernel.org,
 pabeni@redhat.com, kuba@kernel.org, edumazet@kernel.org, davem@davemloft.net,
 guwen@linux.alibaba.com, tonylu@linux.alibaba.com, mjambigi@linux.ibm.com,
 sidraya@linux.ibm.com, dust.li@linux.alibaba.com, alibuda@linux.alibaba.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Oct 2026 23:53:50 +0100 you wrote:
> net->smc.limit_smc_hs is a bool, but its sysctl entry uses
> proc_dointvec_minmax() with .maxlen = sizeof(int), so the handler
> accesses four bytes at the address of a one-byte field.
> 
> On little-endian this works with the extra bytes being written in struct
> padding. On big-endian (tested on s390x) the bool sits at the most
> significant byte of the int therefore the bool stays false and the "1"
> goes into padding. The sysctl reads back 1 but SMC sockets created
> afterwards see limit_smc_hs as disabled.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix limit_smc_hs sysctl on big-endian architecture
    https://git.kernel.org/netdev/net/c/162cf592b577

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


