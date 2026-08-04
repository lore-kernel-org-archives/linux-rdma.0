Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610BF3AE18C;
	Tue,  4 Aug 2026 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785807651; cv=none; b=U9YHtql6Gtm58XC+V2khE1nray3HRmmIZpcZtc7EJ8ObKhfmmLDwc7koVM5gmVO3rdYJk4m3iOItL5NkWltKg7+ATxlg3ERPD6oR6DbBZ56kVJ6OAfoTNwEqlHieMdmqWDHQKEIMz9g1kUleo3Ja3yx5gtqG88fTQJiKFftSseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785807651; c=relaxed/simple;
	bh=OlyPsavO4AG/TrNzvmzHFW0E9iajCaEweVuz7ty+5KM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ITQKpiVJG/B1QB6BSI7VR9Ck2lnKRmTYAH9aOoNOg+hyId/m5O8yi0HhjVtwxmIOBU4tXjGkltvVUFyAsjZI/3upUZXVja8uSf9H5+rLVORCGgqh5h8MPLjegtqNVeQ8YO5O5cl3XBPa+vl1WeKATEwYxQwjbzoGRIBjjiNv7D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WThhLCYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WThhLCYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C11F000E9;
	Tue,  4 Aug 2026 01:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785807650;
	bh=EDtwLm8dym/9qtiT0Z1EIaV3dPzjJjAZqq7Lv0LSazc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WThhLCYFdcqruKDK5cJqL6adeaRCgsJLouOknMJmDnW5H1icHxhECjFiojHjeXca8
	 nrCgLsvZGzoO8XWuRqVArs+9mMZSdSUc57nmSyN+AbaGTEtej6WJtKdxJ4mBaaXXiZ
	 0HWuzsolMfgYCklUeXORzWVoPM5UC91HGT45AUmlmldC5ZNyMBHYN4bbHp7Cu7L4zd
	 npveRXVRnRVEla7n3PgJFexEKE0t4hPtLph62AkxHk7q0Gs90MnglCBJrdsuHRmFQk
	 xFXNOpKvngwJ2wHO6/EqEFPFSj655Rk4yenF0p+Vs0BlSb6LiLYdYylkqT534z6vl7
	 pOBXBqzx6Zzbw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1989C3924467;
	Tue,  4 Aug 2026 01:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/1] net: smc: smc_rx_splice() can underflow VM
 page
 refcounts
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178580761063.2910544.8003426313480974364.git-patchwork-notify@kernel.org>
Date: Tue, 04 Aug 2026 01:40:10 +0000
References: <20260730145552.360287-1-enjou1224z@gmail.com>
In-Reply-To: <20260730145552.360287-1-enjou1224z@gmail.com>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com,
 stefan.raspl@linux.ibm.com, vega@nebusec.ai, lx24@stu.ynu.edu.cn,
 d4n.for.sec@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jul 2026 22:55:51 +0800 you wrote:
> From: Daming Li <d4n.for.sec@gmail.com>
> 
> From: Daming Li <d4n.for.sec@gmail.com>
> 
> Bug details:
> 
> The bug is in the VM-backed SMC-R splice path in
> `smc_rx_splice()`. It builds a multi-page `splice_pipe_desc` and hands
> it to `splice_to_pipe()`, but it does not take page references for all
> candidate pages before doing so.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: smc: fix splice entry lifetime imbalance in smc_rx_splice
    https://git.kernel.org/netdev/net/c/5d9686af2976

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


