Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693A0380FCC;
	Sat, 22 Aug 2026 20:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787431266; cv=none; b=hdWY0p2r2aYndeJzy0xsnf8HdAIvUTeXaq2JkNz8w/VjgRKxSCumS1fCrhDkc2idXdf4TxkhuPK17DsB6c436osFHg3h1MH+mselRQ3hNErcMwGkjTDk/4mAmGnXWjBJQyXBEutDEe7y0CxM8Op7nnZ1B5bK06DaghF9s9oT5Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787431266; c=relaxed/simple;
	bh=IR2wLuYQOSE+aMyK2ErvQGVSciuh8LGlAZSiFFC2Z2E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=iez/6lMGkGybu4sk7JhKiXK6MJB11oo8Wnoj+m/DHu6PGtJZJcU+d3akL/9JPyFEZ4aK+qCRh1uwGvG4R1yzY6UJEiK3+0relx8m0TiI1WVEM/wTv56knwxw9P45PxYLGWtpx9y2ELO6cGfe659ZEvriy/e7yht95IiY7U8IDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONAtDSIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONAtDSIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931881F000E9;
	Sat, 22 Aug 2026 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787431264;
	bh=t6sqrQxCWB3rzPouF9yMKAVTFwqFJESx3h3EIMtjiP0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ONAtDSIe8DQAjp4WBuHIlWEhZOScs1lAHHuoEEfNWM6oqMFJgVlGQ0bJp6rc+Fzk6
	 pRz4XnhYt3Pca7W5dTynv6UDjoy1AgcqdC3l5qeMsYf9NxjAwm7yytFsicgpRU5cGG
	 5nUU5x22e19xr4H74EB/vcKZwx7kunnH9zxOFDLXUcD+Pjts4BZV3gGQWiCl3E/J6i
	 cYUeTZ9GfvN5/hoBOwJOGlYYkCVZxLds27lEao7t2P/wsU17iKKcBgWFxNy2ZCE2sN
	 9rutEyWiz4zNM07q4Cgz5+2zkblCMxZOICL3aAuqCwpbpGR8qXx5n6zWe6V3W6Qbcf
	 dyc9pwfCTmJfw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93965380CEF9;
	Sat, 22 Aug 2026 20:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v7 0/3] net/smc: fix out-of-bounds and use-after-free
 in
 SMC-Rv2 LLC processing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178743121314.1821669.490736256443928861.git-patchwork-notify@kernel.org>
Date: Sat, 22 Aug 2026 20:40:13 +0000
References: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
In-Reply-To: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, wenjia@linux.ibm.com, kuba@kernel.org,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 leitao@debian.org, horms@kernel.org, mjambigi@linux.ibm.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 guangguan.wang@linux.alibaba.com, kees@kernel.org, gustavoars@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Aug 2026 11:33:03 +0900 you wrote:
> Patch 1 fixes a use-after-free of the LLC queue entry in
> smc_llc_srv_add_link(), patch 2 bounds the peer's rkey counts, and patch 3
> carries the tail of an oversized v2 message in the queue entry so that both
> readers are bounded by what arrived. All three are tagged for stable: a
> tree that takes 1 and 2 without 3 still deletes rkeys read from whatever an
> earlier message left in the shared receive buffer.
> 
> [...]

Here is the summary with links:
  - [net,v7,1/3] net/smc: fix use-after-free of the LLC qentry in smc_llc_srv_add_link()
    https://git.kernel.org/netdev/net/c/a42a459ef0e5
  - [net,v7,2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
    https://git.kernel.org/netdev/net/c/2d1e7c5aaa33
  - [net,v7,3/3] net/smc: carry oversized SMC-Rv2 LLC messages in the queue entry
    https://git.kernel.org/netdev/net/c/8d3c1ab82c11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


