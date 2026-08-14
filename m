Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B493C09FA;
	Fri, 14 Aug 2026 03:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786677878; cv=none; b=rV1aP2Y5F2otJCdLxY9yb0gBxXcAGz/TnrtZDD9w8F3H4u9dbUQujBOJOzzB2Om3oWCF9lZUCO2uxMdMS66wEEIirgLTKqT6c9YBliPJFhQI8i1j1v4CRhvJb+8lF+RRHtD2YMXg9b7X6QuuvMoBqNE4FEcWQC7LI1LeRdFFwos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786677878; c=relaxed/simple;
	bh=dnK4XQbvn2aFJeQxuwDNkBWiLT7GGTskBeethO2SpsI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=H1S61+9EqUgg797y1WuSv+XswtzRcXG4GcqbL7QmgXdWzpRNi5Ty5m+h7uhQRyYXpvpTdEh7jZN7Jm1MeFc9E3qBp9YnupzQoGrh8GTDsXRMvHTtOjEudv9/LN3gEgJP3MXtiSMFezKtOtn6RZyXB2I3yHbpI7AvNBbbQ9qWXcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVD7ugPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVD7ugPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8491F000E9;
	Fri, 14 Aug 2026 03:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786677877;
	bh=gIEgBcAoeJ7+WVpGgtS9J+mhRvHVlB8sFCT9Z+i46BQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iVD7ugPfb0FBtOaJyo6uAX8vK987ixi8cJwvSBJ2XigQ8x3PwSB1vruDavjCelg0V
	 G1aoIXq2ZRnqBUbFcAG6G2XxRR/yD5cchO6uF1IeXGjR3tDDvHD+qsum4s6xIful8s
	 960nsOlESE1eNpl0oAayJhZuKcfdzN2JzQvQLlWxrudW1mjkTO/PZLA7SsXZQZku2/
	 FIIXBW9VpOSbzsBm/OZNHdVaSEB+XvduhuMll+UPcWA3isbkJAcYZMxMipstJh5uDB
	 eHjH/tpz/9Oo9XlmfbfmZEgyZGk9ewVt7fNEUWsULUNV3HcgcFcANcXtYmeDDdkMbx
	 20frBZUCHkUjQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0CA13810900;
	Fri, 14 Aug 2026 03:23:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net/smc: close the SMC-D teardown window
 around
 the ghost send buffer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178667783138.3150297.14142348032693681009.git-patchwork-notify@kernel.org>
Date: Fri, 14 Aug 2026 03:23:51 +0000
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
In-Reply-To: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: dust.li@linux.alibaba.com, sidraya@linux.ibm.com, pabeni@redhat.com,
 davem@davemloft.net, kuba@kernel.org, wenjia@linux.ibm.com,
 alibuda@linux.alibaba.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, edumazet@google.com, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, horms@kernel.org,
 linux-s390@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 08 Aug 2026 02:21:22 -0500 you wrote:
> Both patches only matter on the SMC-D DMB-nocopy path, where the ghost send
> buffer exists, and the only in-tree provider of support_mmapped_rdmb is
> dibs_loopback. CONFIG_DIBS_LO is default n and its help calls it a testing aid,
> so on a stock config neither bug is reachable.
> 
> v1 moved smcd_buf_detach() after the drain. Dust Li replied that it does not
> fully eliminate the race and asked whether RCU is the better shape. He is right
> about the first part; I built both and measured them.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/smc: unregister the connection before draining the rx tasklet
    https://git.kernel.org/netdev/net/c/36cdf5d48ca1
  - [net,v2,2/2] net/smc: do not dereference an unset send buffer on the SMC-D teardown path
    https://git.kernel.org/netdev/net/c/b395dd319cea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


