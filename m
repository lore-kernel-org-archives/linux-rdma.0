Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A931AF0BB;
	Tue, 21 Jul 2026 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662250; cv=none; b=hzpj19/OJBkmnybrdI5A9Ro7ji9qrdtMRaT4kfKF6pOAPNC91sID5SWD4z6EPG1X+VA+zags+jXKa/PaViVOewL254nuVJWFy5OYiECM8cVeAwMQqmCQZb4J/Gfpf8DoU2woRG+ZDkcUltS/pKVwzm/YysLVTfZdUcBwrdNJJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662250; c=relaxed/simple;
	bh=LeZq21KAtmQ+4YYVlMjx+4SGdZKkpwLSKULiF9jlklQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CmusoqamTM0TBAz/zqd+HqMoS0lgp1rSOSBclIPqNEXzm7/rO7sZDH6hafDH3kU2VQVRif7y31gDP6F0Zf73UyEd7mj502mBSj4/hU89v7xydDhtV/7ljo+KUpePB1c9Tja6v0pe4kl+3TzjLkTMV9JPBwCPN4Q0sDJOnVo9Ofs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPoITf4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPoITf4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67021F00A3D;
	Tue, 21 Jul 2026 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784662248;
	bh=AGzERM2SkKDls/FXLDQeUTzgCiAHckNLJwaStuLHoHE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=YPoITf4JsQZT3WvPxRakMaPTTqxxAgr8FQ2j/LHzvTXm542pEDaE/Dka7WQ/FXLqY
	 TMZIlttIzxddocV8Ga85gETUIQNXlPbXU1LbmFg2s9cHXJeUQVfumbNQtdyb7xIKfb
	 P9Q4ymI15SNfOTATAZiZONlB5WCXj8uyQ4ey9Yer1PBvXg+Ql72ydnowT7YKndJskG
	 WmUxHuRKM7lGCvVt9RbwtHw5WnLaaWlsKhK8UbYEL9C9+AjIak71t3EpW5IpfQR8Iq
	 t/AtyhAK5IlOX8ZdcwdvkKsU02UOq4gC7B4e4aJQDvVhW0myPY0sc0F+IMnIL0+pwf
	 BeRh0D5VAKxFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A8F39253FB;
	Tue, 21 Jul 2026 19:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: Fix inet6_addr_lst NULL dereference when IPv6
 is
 disabled
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178466221813.987340.12217737947871914296.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 19:30:18 +0000
References: <20260709162723.367523-1-Ilia.Gavrilov@infotecs.ru>
In-Reply-To: <20260709162723.367523-1-Ilia.Gavrilov@infotecs.ru>
To: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 ka-cheong.poon@oracle.com, santosh.shilimkar@oracle.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Jul 2026 16:27:54 +0000 you wrote:
> When booting with the 'ipv6.disable=1' parameter, inet6_addr_lst
> is never initialized because inet6_init() exits before addrconf_init()
> is called to initialize it. An attempt to bind an RDS socket to
> an ipv6 address results in a crash in __ipv6_chk_addr_and_flags()
> 
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:__ipv6_chk_addr_and_flags+0x1df/0x7e0
> Call Trace:
>  <TASK>
>  ipv6_chk_addr+0x3b/0x50
>  rds_tcp_laddr_check+0x155/0x3b0 [rds_tcp]
>  rds_trans_get_preferred+0x15d/0x2d0 [rds]
>  ? trace_hardirqs_on+0x2d/0x110
>  rds_bind+0x1433/0x1d60 [rds]
>  ? rds_remove_bound+0xd50/0xd50 [rds]
>  ? aa_af_perm+0x250/0x250
>  ? __might_fault+0xde/0x190
>  ? __sys_bind+0x1dc/0x210
>  __sys_bind+0x1dc/0x210
>  ? __ia32_sys_socketpair+0x100/0x100
>  ? restore_fpregs_from_fpstate+0x53/0x100
>  __x64_sys_bind+0x73/0xb0
>  ? syscall_enter_from_user_mode+0x1c/0x50
>  do_syscall_64+0x34/0x80
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> RIP: 0033:0x7f47f8269ea9
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled
    https://git.kernel.org/netdev/net/c/9c805e592a29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


