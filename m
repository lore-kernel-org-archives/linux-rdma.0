Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A2B31A07F;
	Wed, 10 Jun 2026 01:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781056215; cv=none; b=b/ImtL3XoS13dT/2Sr/OUkyHUdSAaw15T08N31KIdkpfdRfT0/X84QXP4aZOskNoPEH/EphKs+wKJFy6QviTHSiIMEK/ngOzMkHlWBT98EzlTAQgTQGAAwKSC8rR8wHggpe0aSr9esq2deOcRyQoiRL1zLLEf7tS1W5rssmUA3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781056215; c=relaxed/simple;
	bh=hwvxF8N1zvCFgMaupM71BHjj6goMqgmONQpn8qKsqT4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ib5IEBsqE3poKPKWaKpx6Hh77oALSIlZ4TZHK2+5bBWDLcNZg0CxXCqASUaANkuaZUwbUdbZnxfZUZdL9z9z/d6R7H9XryIsQ3WGwr9SOf2jzdG4+w5pP2k6QqdlCC3OxywicA7yhbC/kgQn8Ezu9ts2yGQcI0PSJ0Ku81eBko0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G29nJ7/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G29nJ7/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37411F00893;
	Wed, 10 Jun 2026 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781056210;
	bh=4R14I7pQe6DsGJffgE0TahCiSRdNUpxcyY0Y88/vvT0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=G29nJ7/e0YKC0tezdMnEyIYDz5rWu2bfKqbtneHMm3rmkpGkVpKsfxLxDqi0Ev1An
	 G7qwei/Sy/HsrOPkuLe/nzRXJMha09QClFFYg5FYzGI3Z8ZesySRGEIYCcvcRxc5Gj
	 IFWCG3Vu+rLaNphqytuJVuzdOzBLxUucnsPwgAXZadmKiIe3YfB73N87poeGhJR7kn
	 LlxSODrkmhvolwWlTcRgeEhH8KresTzN+m/1DhTwst8dOcrHkFo9WfLEA8MMe3SQl4
	 c2GUuo5ooedgMLc4U+Ko4ICznVGswheUOTddh3ZQTYChpec88L5D4KNZRPgHXtIswW
	 liknofMZnQ2cQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A043930A1F;
	Wed, 10 Jun 2026 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/rds: fix NULL deref in rds_ib_send_cqe_handler()
 on
 masked atomic completion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105620864.2788910.17895846835034675747.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 01:50:08 +0000
References: <20260606192447.1179255-2-bestswngs@gmail.com>
In-Reply-To: <20260606192447.1179255-2-bestswngs@gmail.com>
To: Weiming Shi <bestswngs@gmail.com>
Cc: netdev@vger.kernel.org, achender@kernel.org, pabeni@redhat.com,
 kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, xmei5@asu.edu

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  6 Jun 2026 12:24:48 -0700 you wrote:
> rds_ib_xmit_atomic() always programs a masked atomic opcode
> (IB_WR_MASKED_ATOMIC_CMP_AND_SWP or IB_WR_MASKED_ATOMIC_FETCH_AND_ADD)
> for every RDS atomic cmsg.  But the completion-side switch in
> rds_ib_send_unmap_op() only handles the non-masked opcodes, so a masked
> atomic completion falls through to default and returns rm == NULL while
> send->s_op is left set.  rds_ib_send_cqe_handler() then dereferences the
> NULL rm via rm->m_final_op, oopsing in softirq context.  An unprivileged
> AF_RDS sendmsg() of an atomic cmsg over an active RDS/IB connection
> triggers it; on hardware that natively accepts masked atomics (mlx4,
> mlx5) no extra setup is needed.
> 
> [...]

Here is the summary with links:
  - [net] net/rds: fix NULL deref in rds_ib_send_cqe_handler() on masked atomic completion
    https://git.kernel.org/netdev/net/c/34080db3e70d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


