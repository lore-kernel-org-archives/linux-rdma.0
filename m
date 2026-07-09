Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900483F58D9;
	Thu,  9 Jul 2026 08:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586436; cv=none; b=quQ0Metok7rxQsNqEULkoYqNTFQGvF1T3aIgXL7rXAqMEat2tf3BCl447rXKTY6pQ+JDJp12kYMGPO4lzvtg8H+huGZmRSaXXWGN5+JWKtzLIesnNcv2cYp79sxMJ/iIMNj8W5IS1jJt5+hCkfHJiJxq6JRqwB2JEpIsL3FQOlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586436; c=relaxed/simple;
	bh=nBg16d7Yjy7B5fWx6V3/qp+hKHibbqmdH5J1pM3LZ28=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fPSsv2Zk5ffvkcpAw5imsu/QxwNb6m91PRkHZdizGHSMPocoJmmO7OX+aV1LttWY/eH5eZdEm9JoNg/08pC/KAPGwjMcMpD4WrGgWFLfUPAu3zAr/rrLiASa+ALVzL19KBWv3SbEKCKWAgGHG3ljVOggmrqsBz9LdpqzyS0VGbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdlUnV/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdlUnV/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67501F00A3D;
	Thu,  9 Jul 2026 08:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783586433;
	bh=1IFk7s47QMIsomVBCl7/1xNIncgQK2Sx8uCGIBdxw9A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=JdlUnV/R0QivABb+RYilnfURn7aljoSe+rrwA53yG97phFGiMMnpX6Vw2Z9nj9SnB
	 U+ztG0Vxm9qtNRLiuxCMdzkzd4pxTaahKBBK6YHC82gp2e2bMxXR6KnXVwz9pU6Po7
	 Uc6DSVhhAeGMk9raNgxpeARgaw3qjfo6NNz9+uUjEyIr9mu7KbyGfaQc/H5DpW1g72
	 dTqdZ8t4DvzgIDCQSqvEatiXX1xEMy2TKG9Aif1mLr5mIDyY6897KvzHfZj5jvMjr2
	 d2Hs2KfDM7PFvJP5/lPX/8D6pNs0NFLE71SIVdRmEoSlmonv5M246y8wVoHqT2cqva
	 Z5JZV6Xxo1ypw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A7C3939F13;
	Thu,  9 Jul 2026 08:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] Fix MANA RX with bounce buffering
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178358641138.3333608.7004028070817400784.git-patchwork-notify@kernel.org>
Date: Thu, 09 Jul 2026 08:40:11 +0000
References: <20260702041237.617719-1-decui@microsoft.com>
In-Reply-To: <20260702041237.617719-1-decui@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, kees@kernel.org, jacob.e.keller@intel.com,
 ssengar@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  1 Jul 2026 21:12:35 -0700 you wrote:
> With swiotlb=force, the MANA NIC fails to work properly due to commit
> 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead
> of full pages to improve memory efficiency.").
> 
> This happens because, with the standard MTU=1500, the aforementioned
> commit uses page pool frags with PP_FLAG_DMA_MAP, but fails to call
> page_pool_dma_sync_for_cpu() to sync the received packet for CPU acces
> before handing the RX buffer to the stack.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: mana: Validate the packet length reported by the NIC
    https://git.kernel.org/netdev/net/c/2e2a83b4998a
  - [net,v3,2/2] net: mana: Sync page pool RX frags for CPU
    https://git.kernel.org/netdev/net/c/c72a0f09c57f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


