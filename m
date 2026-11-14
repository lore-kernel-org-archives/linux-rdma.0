Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627006;
	b=fETr9+0t2EU6rkn7JggyrCoORZMcn66sMzeRLXWizf9C28VXyQ93ThfcY2dNT+bYWFb1
	 Du1xxQc70WWH/TTVA+vnDDhTibirdnPr6nVayzdwtq8tESFbs27LBNSY6itdmSWVqq24D
	 Mz5fF/F/DUJ58ObgifaanbD9IXpVNCqXi2cAAMXtDWK4xQqCKMtJCK+a4EK85Yw5WaHax
	 60uB1Ig01pyX0hbc1k+bK7EZEIa/MzQhHrnDVwW+MQvEiWUgtevNGF9gVXGmzPr9QE4xa
	 +3hPs2cc1U5LhzAZX4mKhrJwb6RXriIYHfyImw2v19oLHIdEOs9hpNPBptVHsesaaaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627006;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=ehDqbXkEBYDPCAc2yGAMtgdfuga34nmWnL94tsXLJ0w=;
	b=ynjQ6Ut30FB5O8Mh6UrE/7dbAquQBmmGzOmaYwq8CR5gxj4+/7p7m0BjgQJOwxmhzuVg
	 GcXkVkT4r/DHaBYbiVyb7xzPpAgXjFLcMGtPBOjIvBM5YDe/zBUWqIK+pwmTa3qGLeoHa
	 UfyOPYjH5TumrBYm3h7n0x6jQoQ9o/g7IdXozslXo1RhsXWF95+SUQsV9WK0PKGht0FJP
	 mkneKBjGOCPdK5EbnCwwAi/BVq80wlqahIjprCBUuKxVS/n1tufpur5HZgdoemrNKWs0/
	 hjexoRTAyu0/pfuMMxltGQsrsaqtjEVaoQXBDmP4p4J/T/vcOwmNJdBFhJznV0xrVkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k11hvWfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC03606A8BB;
	Sat, 14 Nov 2026 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k11hvWfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB231F000C8;
	Sat, 14 Nov 2026 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794627005;
	bh=ehDqbXkEBYDPCAc2yGAMtgdfuga34nmWnL94tsXLJ0w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=k11hvWfV/pEZhIJfACKh6bVZJWcJ9c1V9hYiN2Q/wQ8JJolk5hNpMY+aMx4CyShAm
	 YXIeduDpidI0wnUtpoTyg90eHAk3GRvckcvwaqN66NXTM0oeJUun94jqS2XqQPSKvK
	 S7OD8CUSJF1tGSyRd3WFyM40TyLOP/cHR+X+ejgXeSVnHbGV1i7+7i99/amMxhpzjK
	 jhVhfAlB1mSBi8jZ/uPp1cWeqGZiQO5By5Q1YcCqirhu1R6svNspjujQr3J5429awd
	 wREWuZOCQDOR+3nqslzxybXsI2R4zZIxMi47un6MIUoqyWJNhKbsMfEa3BJJMb9jNy
	 vqOWYlcdhRQqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B459E380821F;
	Sat, 14 Nov 2026 03:30:05 +0000 (UTC)
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
Subject: Re: [PATCH net-next] net: mana: Allocate queue MSI-X vectors on
 demand
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179462700464.1971357.5494475799168934446.git-patchwork-notify@kernel.org>
Date: Sat, 14 Nov 2026 03:30:04 +0000
References: <20261106063011.43293-1-ernis@linux.microsoft.com>
In-Reply-To: <20261106063011.43293-1-ernis@linux.microsoft.com>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, shradhagupta@linux.microsoft.com,
 sahilchandna@linux.microsoft.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 Nov 2026 22:30:11 -0800 you wrote:
> MANA allocates its entire MSI-X budget at probe time, even when the
> active event queues (EQs) use only a small part of it. With dynamic
> MSI-X, this budget can be num_online_cpus() + 1, leaving unused vectors
> that consume interrupt resources.
> 
> Remove eager allocation of queue vectors and use mana_gd_get_gic(),
> which already allocates a vector when an EQ needs one. Keep the HWC
> interrupt available during device initialization.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mana: Allocate queue MSI-X vectors on demand
    https://git.kernel.org/netdev/net-next/c/6964ff21c5d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


