Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2343A6B8A;
	Thu, 16 Jul 2026 20:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784235037; cv=none; b=jCgSCLDDvlcuwhzGUdJYCw6CGHClOnZZu868O8R3Y6GJakQESQX1CiBB0J2ino+8K+aL2xSR2YCr3+/jSJlGLE+tfnNp6Ai3mOCR/hWTsT01RnP1edCKxRU28p0q2OewKwRoEoTLVf+rdi0s79cC4MuUGNvIFT6Oal2pAN3c30w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784235037; c=relaxed/simple;
	bh=uokFDej1e2n4uZb119NAiwJQhLWB7biCse5nX3/bQYQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=iKxNCpcFFtwcFhtRGPMf9RDV65MLCO/sGVVprdD/DFARPTQzfZG32CglG+wGtOakpha8AcJ1BesaRktjlZrKZojXwx3HyLlPsDYHLLRvWqpUQ0SGX7aJFHtpLynpw6ixI3Hq0GxLsWh1zGwxbwXKDsMyj+4abU7BB/wJ1qNHUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBeB+S/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBeB+S/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303261F000E9;
	Thu, 16 Jul 2026 20:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784235034;
	bh=yFO/Wzv+nMPvX8WDsiGkqM1rToC8Sr3/WlWeJWR+YEU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NBeB+S/NtCBqv47/eZJU/pXf52Mc0d/ChRUiqxB3NlccnsjOci5nEObGidkcrTMcc
	 us9QlMSPnBJxh3w92NmqUcbfRFW2DbG/6n/1EjysTVVtBKrm/u0DqQhotd5FL5ID4G
	 GEb/j2tGSsJZvYIkVB/iWeGF9BA22prMF7X4ld9aLAIWS5WmDYzpVBRkiThTMtkFnP
	 VR9IfvJdaZKJrbYus9KTN7CLwjAZMuaXoXhXnQ/r6sng+HfRKZlHhtiWVZRnyMiGB/
	 NfZTeFAmp+qzfqi/69JUcWsWMk0VOSGb8pCzxXTvaOSU7Z3JV3jheGgP8MG8TvFzex
	 rta7OezU7Xhhw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56944380A95A;
	Thu, 16 Jul 2026 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v7 0/2] rdma: display resource limits in
 curr/max format
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178423500714.1415745.12369872060313952704.git-patchwork-notify@kernel.org>
Date: Thu, 16 Jul 2026 20:50:07 +0000
References: <20260716115237.1859633-1-cui.tao@linux.dev>
In-Reply-To: <20260716115237.1859633-1-cui.tao@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: dsahern@kernel.org, leonro@nvidia.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, cuitao@kylinos.cn

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 16 Jul 2026 19:52:35 +0800 you wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> This series adds support for displaying RDMA device resource limits in
> curr/max format in the rdma tool, building on the kernel uapi attribute
> RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX which has landed in linux-next
> (kernel commit 5911f6d6e7cc [1]).
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v7,1/2] rdma: update uapi headers
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=39eb3a40d967
  - [iproute2-next,v7,2/2] rdma: display resource limits in curr/max format
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=35a237091c24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


