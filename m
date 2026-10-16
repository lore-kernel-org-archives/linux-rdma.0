Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE85329E4B;
	Fri, 16 Oct 2026 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792112414; cv=none; b=r2blD5sCP/LzKyaX1ImWeogBLBLD5BTwQoJaYvVBTau5Tvb/LrgDBMIBLzH+6HjtPCdHcR3cCS7UiGxwiAvJkZz//IlbFPEompG+DEEkulvS68juAMBY8vuF7PbsQ3HQSejNTyQ2sOx+y2sv+EVwSfksX6qYUWcf6QfgkO/mFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792112414; c=relaxed/simple;
	bh=M+lF2V+s3RKHalZpr1IoxQdWhIlxVnAXPXp4a++Kbh8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jjaOVpzWxUvpL7SQolE/zCWfFSgC0jpsWwkDjmjXUn7UIpgfl5HPlqeViVhcEgYdZw+2vNTQv+EWlKQGTsrZOAor8hwbRwkAZ5RyHX5RrS6hKfoREoxnHWgikDMuPlWKKVxfQq0IsfVTTubzSR/CttwVAR4wPqNEu49v5oSUAKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJGPyUBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJGPyUBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055D21F000C4;
	Fri, 16 Oct 2026 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792112413;
	bh=SWGYEoC8BjEi5kwYZ2SLu9ZWtC7sTOWuH/6Ow7Wiuys=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=HJGPyUBy4E7Ma4Q8ROLT1g9OW6iLLZAL+DqFSHErCq5VvpRtXFxJPHukE4FfsLWJW
	 emN1GDwqIPj8b/r8KEMxTdd6E2YIjObchBg1RiA3EXeI5PakbGH42DLoPm+IOPvKSJ
	 YyUMgMNWSm63IFHumlsAc+3/F6+Z7jkTen1C7VlwbiMY0r6/xHeMRyZp9Mm9oRaRkC
	 fF+J3ohM4xF2k45Jz2i8WieXOs8SLX87jiJDjfxZtHqjsS9RMkxA2PTeIJ/HgTtiNo
	 JYJkFZKOgNB+MIioOSKEB3bwdWWerSuUUdJBaPSpMCB+sDWE4OmxI1dnlXmten/rtK
	 hUILpu9qa4hDw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15AD3808209;
	Fri, 16 Oct 2026 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mlx5e: Fix use-after-free of the MACsec
 xarray
 entry on RX SC deletion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211241152.4182913.11538884926508718217.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 01:00:11 +0000
References: <20261010032115.93545-1-18983559317@163.com>
In-Reply-To: <20261010032115.93545-1-18983559317@163.com>
To: Binbin Deng <18983559317@163.com>
Cc: borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Oct 2026 11:21:15 +0800 you wrote:
> In macsec_del_rxsc_ctx(), the RX secure channel is torn down with:
> 
> 	list_del_rcu(&rx_sc->rx_sc_list_element);
> 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> 	dst_release(&rx_sc->md_dst->dst);
> 	kfree(rx_sc->sc_xarray_element);
> 	kfree_rcu_mightsleep(rx_sc);
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mlx5e: Fix use-after-free of the MACsec xarray entry on RX SC deletion
    https://git.kernel.org/netdev/net-next/c/ad17ad50b8dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


