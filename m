Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143606;
	b=MiTnqBwCT2NMzaxrK88Mk+QCgJuxcTOO5IaW6yvWkhoc5OT0YlSdV/ghAJlb8KKfZ6pZ
	 ZTBsgAsEA6RdV0inROjitXnKREyvlXypgyMCaXddvTs6XRsDPOncxaADkayAnhPTquthd
	 Jfh8APF80qC1L2BXiTFcbSuOlP1QGTEwWEU8xl0wutskbZ+NSnB2oVwPWiVSTaO0RNufo
	 /8OKYcwHLhFZCIeUC+73uDUfL8OsbO7WrihlM0PIYApvdbM4NRRO5GwRjRNwX5izFWSpd
	 tPbfgO0T3vJ6vU7zzN5i16HXJF06+bu6Tk3TkeUdyZu6a+UyG8gdfU/mN9FJ1TL5HdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143606;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=qktbnfEhNNez/lzMHTyNA/lbMwrcpXm/Mlb5Iq1ae+0=;
	b=v74PTiAgtto8n3feOhZ8Uowz59hwmhqDapIBPkmFEOSDhoy86VSy+ccBxM4KOIj+yitf
	 mitB9wt2egqWTkjp2b29AK45WgB8lIrj6gACMCHbLJ9jtc4Cyk3u+FDVytsKwmwh7y+Td
	 t9imJ2Hx2/WvO2AgE8fGqmVdBwPl753IQ18G4BV0PEjQOCVkZn8ZnB9xxNPZ/3Ie21cwQ
	 jaYvyHK5jPmHUDL2ByJKFJ5PSz55QYtbtUyJ7AFBN+lPiIUzLTCTzzQhlQ5wqJrijkAKD
	 l0R9g76DjYNyoJZ61CEqgF8pq5qZIpgO3oXJUZXP4HgQbKLAfyMLY94+vIi07A2IBng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jlp4T34e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A8606A320;
	Fri, 20 Nov 2026 03:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jlp4T34e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B21F000C4;
	Fri, 20 Nov 2026 03:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795143606;
	bh=qktbnfEhNNez/lzMHTyNA/lbMwrcpXm/Mlb5Iq1ae+0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Jlp4T34eg6yU6s2UPlGM9DIqbFbUyKxQJR7O9/QF4ye8+OptxtRCgF9NO4UkV40gj
	 Gdr1vexRy+5POOAKBbgpMYM+8QjZntZFxGaNnOzVV8kYmW5rtq/qYfL+os2smo0H21
	 ZK9GQ+ZAuFUdxlyH6B83jRySLg8JIB51RwojmjckdVtDHV77n+gUb4+YEg3psDppIa
	 cuQ2ExJ7vcKadPuVyEB9O0i8TdxMAXoZ+tJ1Od54dbSc2cXlkCQr0rAbggW0a7W3nk
	 9q2ny2S5YAKZU1hrV8FDaG9id7uzlO6S0Cw0MYT8zXLpvoVtBOnDRCXdOOkPs1uHsd
	 vMGLMhyGrgZYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3793808209;
	Fri, 20 Nov 2026 03:00:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net: mana: Set 1 usec / 1 comp as default and minimum
 interrupt moderation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179514360504.3995675.11210185436639539772.git-patchwork-notify@kernel.org>
Date: Fri, 20 Nov 2026 03:00:05 +0000
References: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
In-Reply-To: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, longli@microsoft.com,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, mawasthi@linux.microsoft.com,
 leitao@debian.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 paulros@microsoft.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 Nov 2026 12:44:04 -0800 you wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> The existing code sets interrupt moderation defaults to 0 usec and 0
> completions, which may cause CQ starvation of our NIC HW, and TX time
> out error like:
> mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 14: transmit queue 4 timed out 63434 ms
> 
> [...]

Here is the summary with links:
  - [net] net: mana: Set 1 usec / 1 comp as default and minimum interrupt moderation
    https://git.kernel.org/netdev/net/c/325e921a7aa1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


