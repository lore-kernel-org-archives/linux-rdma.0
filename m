Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FB9371875;
	Thu, 26 Mar 2026 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534223; cv=none; b=EE4+95Cgj6DcYqlg4AJ9aQ28yrYAx4bOKYegBcCAIiG1lyre++hyTciVqLNSENLu1pKBUb1kN5f8JS2hSPF3RLcamVWUAf4wPRtZoWAAFk/f6sWLVf5KvvJ8AcxWf/CYGB/77aJ+BhZDOIKr6wIpHAxmZ1SXjwyM9rl98Je+QhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534223; c=relaxed/simple;
	bh=qDXpn8tSOCXVn4ZPGywJkTMJ+kkBMvnV1b47RKYboZE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NlH0hrU8G+IkBd6gSK/CCnuZ9M4LgQf3tSiQJasbf7MNu3MGKVjqd2DNHG9nimUGxiKkVL9ny8t42zsksenB7h/rnwYdU11KyeoakRB9277/Sp6Y1th7++McF4tXJUVz/dWUcSakuBKAn2EdpnT6FBbDwSo9Fgz/qlclNckDOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SylF9PGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SylF9PGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A1DC116C6;
	Thu, 26 Mar 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534222;
	bh=qDXpn8tSOCXVn4ZPGywJkTMJ+kkBMvnV1b47RKYboZE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SylF9PGH2EGpNlsTu2aaFYfkCFg3+gDznpF8mWO7WAGofPtiw69UUuUQQe7d1hszG
	 lqHMps1JSVsGxMMP5kK7S96qfLVDN5nCF++7xDNhVYHLsJy+izTuFIVwnBpGoEbMh6
	 pLKk1ODXxMDVNQtbdVxrTBAGw9RnGLQ6/kwNtCmwC0SicQdrvCZL+h8A+e040DijL0
	 ca+XUB4YponCWCJPTCleMzvQlRmlduu1w+tf0YO48UIRQHparfwfxVlkM7ravLdRl+
	 4TPRv9u+7sBT6H9DjDHc5N/KhBvT51MIp5ujvtADFmYPoLsv2tyi+JGJQIuae1jIFJ
	 oXtMuRg47nmgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CE5039EFA69;
	Thu, 26 Mar 2026 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mana: Set default number of queues to 16
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177453420903.2572343.6705987187482730782.git-patchwork-notify@kernel.org>
Date: Thu, 26 Mar 2026 14:10:09 +0000
References: <20260323194925.1766385-1-longli@microsoft.com>
In-Reply-To: <20260323194925.1766385-1-longli@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 23 Mar 2026 12:49:25 -0700 you wrote:
> Set the default number of queues per vPort to MANA_DEF_NUM_QUEUES (16),
> as 16 queues can achieve optimal throughput for typical workloads. The
> actual number of queues may be lower if it exceeds the hardware reported
> limit. Users can increase the number of queues up to max_queues via
> ethtool if needed.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mana: Set default number of queues to 16
    https://git.kernel.org/netdev/net-next/c/45b2b84ac6fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


