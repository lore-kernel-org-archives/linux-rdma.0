Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792530046;
	b=4NnwORzSQd92kqLsAvP5HaCf6JXT0bFsR1nhP75AE9h8GZnX1OU/8tNAUJcTYtYGdbJC
	 g7ZGanWeQGCjRBdhWBe1CcLYAauztt6Rbh/jgeRZHFvgUCZ6V2qJWN3dV2kphu8kNmmTa
	 JuGYmVbnqGY2J9tTij4PY8SpUdG3/diZEfo9w8A7ulma7IlHjsjutqHXAZrZzBOkM71VM
	 9/kcUEdpXmkIB/GoNSIjVKo3P/a5RwerEw3hsU7O3X1+wS2z3vy5cE00uXt0DqCtwfzIW
	 IQkJUgBgN7GOI57p7VaprsoKMkQ3mKnXMyy1q2WBd3liofch84e59LdxBruiBHuDXFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530046;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=s7LHFRSXHic5XGEInYp0jAmgGHudXLNGKJjFiKqPrq4=;
	b=x+8OXnHWdA2SCN9KDQAKJt0MMJL10iH/H1v1ek83/wgaBfgexB7ZRr9AOzjh5Loz3lma
	 ULtYYSYsuO5pwFoPjEZ3xQ8EDPUN8Y+O7Kb2I2HTfiQZIK6DhBfUAgZw+hdxfCbsmkm4N
	 3UwdiBe+CwTnoOYORS7eNDJIVaCoiefCTRfs/APEjb+YmVoz35G37gxKXJx8rkBa0plEi
	 /AhxxFzyL8eY9KxU8Yzsab9VaFfVqhwFL7lqs24MRcgeP/k0ij9kml6SI3fku3+tfKlNp
	 vCAYjcmTEHHUTGm00CUkkTHPy5KZlqrNV/QSCwQKunK6FJpjwevclBW+JBLy/4XowIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQci7tJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E7606A326;
	Tue, 20 Oct 2026 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQci7tJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BAF1F000CA;
	Tue, 20 Oct 2026 21:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792530046;
	bh=s7LHFRSXHic5XGEInYp0jAmgGHudXLNGKJjFiKqPrq4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KQci7tJF+IYLQv12efD+MqxN8J1OOwJGnXlOocHPZKc29bqs7Rn4uxmeGPDrGl9/K
	 DlZh+oY49USpQZHxL+KjFEv0OW74s+5g6WrN4Umesz8ZSy4kJ9elFqSZiEMHh9kWav
	 cW5alHMgELP+qd4Mj0p1uOEq+HRuwVz7Fu6mmpjK8oo/udT3qTqa3lWAJSP6l6NSuA
	 cqQOtolImM7THpRhx7QSnEtpo7lCBakPYqUOtiVqaERF/8ITWp+Sdb+HOO0PPGlWHO
	 weVCueq+jZPslSqNq3gslFD+60qceaw0ggnoYot0rsoW8NUlJNaaAUwhpHsjhyVO50
	 Zc2yMZPTVRHfQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3B93809A09;
	Tue, 20 Oct 2026 21:00:46 +0000 (UTC)
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
Subject: Re: [PATCH net-next v3] net: mana: add BQL support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179253004477.208021.12583295837722282628.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 21:00:44 +0000
References: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
In-Reply-To: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netdev@vger.kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Oct 2026 17:49:37 -0400 you wrote:
> MANA doesn't support byte queue limits, so each TX queue can hold 256
> WQEs by default, and up to 16384, of up to 64 KB TSO packets, before the
> qdisc layer sees any backpressure. This adds latency to all the flows
> sharing a queue, and defeats AQM qdiscs such as fq_codel, which rely on
> BQL to keep the driver queues short.
> 
> Report the bytes queued and completed to BQL, except for the XDP_TX and
> XDP_REDIRECT frames. These share the SQs, but bypass the qdisc and are
> sent even when the queue is stopped, so BQL can't hold them back.
> Counting them would let sustained XDP traffic keep the queue stopped,
> starving the stack, and the TX watchdog would then either fire while the
> completions still arrive, or, if the XDP sends refreshed trans_start,
> not fire when the completions stop. The XDP SKBs are marked in their
> skb->cb, next to the WQE size, so that their completions are skipped as
> well.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: mana: add BQL support
    https://git.kernel.org/netdev/net-next/c/799cdeaa5c39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


