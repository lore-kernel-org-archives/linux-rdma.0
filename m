Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B007B32AADB;
	Mon, 24 Aug 2026 19:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598068; cv=none; b=bMaI2gHudbtYhEYPbCbc5mAnlocNQjdaSzcjcTkaO4O3vfEMLiu080ANk9IQvCxcqXnbyxDwLsspVaR58/XsKRAedtiqngTZiTzayyDxZmU9SXeGbOUSTKDO8jr1ptIPegtmncXgsjIDLX7iPuvAG3vyRGPG/LnQR/y/t58iTk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598068; c=relaxed/simple;
	bh=ss29Ho8jfloNSHB3l0+lT8sdzOlc1XcpXcGpbxazr3M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WZHreeecak8WVqxUah5l0wF8ne4qRhq9iVNxn5LJi3KDuOO/0+PRPUdcCMQNDjcbdRePc4+aUJnpXSiPp9mfWPk6X25ZYsS3sXVrQmYnq3DZOWlSgCA6jAuxZZ+HIoIzDm4fQIkbIzleuR7Gy0wdpyL+KMJYszFDkz58DRIIsmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNDy7SFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNDy7SFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD881F000E9;
	Mon, 24 Aug 2026 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787598067;
	bh=1D6zSH2p7zNhEQcHhM31l8omj11fcFAzWOqFnURSKn8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PNDy7SFX+diXE3+aojkm7Nblce2e0t/r9IE33KRPRJA5HnalKqAeyAGXIsf2gvsxw
	 PyttKbHSt4PGFz2YtYWd93m7A+naKEiVc2P52QY8u6TRNqUvJd47kT4uZbbKrwgs+5
	 kTYLCyNLsXAow/JXq5DWjbRkuAx7bP/23HNXM8oMpPJX4ANgK0+m6FOWT2hhvVOE9E
	 VAPwJIgemG8l+y4Vot/Z9Yf8jROzGxwakgxV/4mwSwyNqoXMZtTCdA5NinHid1ekq9
	 857ulzFtZaA0yIiFssIOyd8klR1eAqaI1p+XnGxrK8loBtp1mffVx7/gXf6TRsHkMJ
	 m+gNmTHTMd0HQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 09F393924A4C;
	Mon, 24 Aug 2026 19:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: fix socket refcount leak in
 smc_switch_conns()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178759801486.3065827.12722922197149697052.git-patchwork-notify@kernel.org>
Date: Mon, 24 Aug 2026 19:00:14 +0000
References: <20260820144729.1019399-1-hidayath@linux.ibm.com>
In-Reply-To: <20260820144729.1019399-1-hidayath@linux.ibm.com>
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pasic@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Aug 2026 16:47:29 +0200 you wrote:
> smc_switch_conns() takes a reference on the SMC socket before dropping
> lgr->conns_lock, so the connection stays alive while the CDC slot is
> fetched:
> 
>         sock_hold(&smc->sk);
>         read_unlock_bh(&lgr->conns_lock);
>         /* pre-fetch buffer outside of send_lock, might sleep */
>         rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
>         if (rc)
>                 goto err_out;
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: fix socket refcount leak in smc_switch_conns()
    https://git.kernel.org/netdev/net/c/719296c4aa82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


