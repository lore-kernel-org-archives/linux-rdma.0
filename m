Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792794608;
	b=p/OSWAdCBIR9KKF2oWjWAHa4cusQwSmpWLP7yjmbNE8ZZFI0ZNx0quOMr48cd0XwTT3i
	 fnQNjtVaqV3jqX6xCGVEDK82Die60MAHb5kcVducoZyDry96Bmxk0c+bj6J8R4ZGq15Do
	 euA4ZzneJBx9PbktZI4F8GlwBOMZle+pGDcxqCs5Nvi6nWErwV80X43JkLo4mlcpYiWay
	 QuzjLjVA0ew4Qg95DbnWv6WGOWLtKTJBWBM+fC+Ig2a7d91W1W1JLdXkNT5GFAzKhOqKv
	 +lckDoXiIYtGamt8fj+3FfxhWsKqQtenO+ukl4eWzlCAz6Vv+s3ozEu/E+D7AXvnR7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792794608;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=QgJFkImAbtClHw4r0qZ3XecpuGhiWx/gyZSvPYkiMV0=;
	b=3/Iqy5eUI3uqJeREXwGFw3poKpKIOt9RzlxxdgjDzwRUIyPDLrl5F7RBzcicaXX69Vh+
	 mejumOpkwyWTC9i15GtizYJk5xklayIgMeYzVhZor3mEn+5tshxbhsEWDAMeQpk5DclCA
	 PVLPY6yyZBXoBnWB8Z0SEAJ+H0oIvo/FWrwiAkzKUqx5eEqvo8+mh5EfXGhFFjMZywk+w
	 p4AtB62n099x6aKH4qQg/w5iI2NeXtQWnZuwCM02SbUBd96vnlqUDhZASYEA/kvU1TbFr
	 3atRFfm2MdlXW5iogf/vH/MLSjg/CkADsfgze7khqdFazOj8lHRrwrACyDGfIOqtDSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lnMlHNdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDB0606A32F;
	Fri, 23 Oct 2026 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lnMlHNdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78271F01825;
	Fri, 23 Oct 2026 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792794607;
	bh=QgJFkImAbtClHw4r0qZ3XecpuGhiWx/gyZSvPYkiMV0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lnMlHNdvFIjl1q6+bFRztUt1pisjqpvuUZKPDilaIhUSQ0fqwfR2nbz/vOKAKyvD8
	 iQJ6Q1CSqrEAXwIBbtCuL7C/iF+z4ulcM9bCAlQjpjX6P1tXyFCOE7iA1bv3N5SQgF
	 P1QSbJLzkEkt7h8Y115LajIyOPgiKXlGuoIz9udVniuREApAwwNyWBAhiuI3N5F5a/
	 WVvmMs6Xk4GCYoM951ERIC8LznIMd5OV3MhxbIKkkNmhPtLhu6swSexTBjMQkADs3W
	 TzqG/klS0OpVxwB1Us3QN07cis3+axM3wUzmdqgJTh2kkiAYeOSxSbFF/rhgvyslia
	 Dhqnpv0J0Wayg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE55C391B158;
	Fri, 23 Oct 2026 22:30:07 +0000 (UTC)
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
Subject: Re: [PATCH net-next v6 0/2] net/rds: scope-aware sendmsg connection
 cache
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179279460632.1302120.16132684698512630001.git-patchwork-notify@kernel.org>
Date: Fri, 23 Oct 2026 22:30:06 +0000
References: <20261020002816.3087414-1-achender@kernel.org>
In-Reply-To: <20261020002816.3087414-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Oct 2026 17:28:14 -0700 you wrote:
> Hi all,
> 
> This is v6 of the sendmsg connection-cache scope fix (v1 at [1], v2 at
> [2], v3 at [3], v4 at [4], v5 at [5]), against net-next as Jakub
> suggested: neither issue has been observed in the field, and both were
> found by inspection while reworking this cache for the
> connection-lifetime series.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/2] net/rds: include the scope id in the sendmsg connection cache check
    https://git.kernel.org/netdev/net/c/b7dfff5e3eb3
  - [net-next,v6,2/2] net/rds: keep the connected peer's scope id apart from the bound one
    https://git.kernel.org/netdev/net/c/3fe64a5f670d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


