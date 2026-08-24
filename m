Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC57337E5F3;
	Mon, 24 Aug 2026 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598072; cv=none; b=cpe1VJ/y33CPcGvtm46ZrTJwX2KxY9XIWCvDiE7vZg+PjUvUBS+a/bE9nzSx7Ea9ypmu/pr6W3DupcoXmDM++yivRzdTcrZ4+b/P85zMImTX0kAqRswWrgA2b5KQsEbDd1zf2BrG3rVB5wgpDgBp/ARhqtXnmX5yZeMqE27HFl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598072; c=relaxed/simple;
	bh=hCT4p/LEZBjGcd2EcduGDyWXLfsfIOXHCjYzS/BSUw0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=C/ahMLuwB2WL9tvvqmz4XRB2Ios91LkPnjXWfuXwj0NvI7GMWQX9JylktQ2+vmG5L+t0NHgrQPTXNZJtybSKxJrIx4cH4tAz8YbySWx2ewqwd4jNMLkBtyFaerhYPPCSqzPHB9aoa8pGFBnR4s6WPaF/IpUaGCWMmceh7+EUS1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrvJRe5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrvJRe5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581201F000E9;
	Mon, 24 Aug 2026 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787598070;
	bh=tZhHx0drxuV9ZFaaQ92JfmWOMZtlbOVIH7BJt5dg7OM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZrvJRe5oQ9zPuD3okkGibbiCC8L2VBIPBA3v82KJYqXe67hjQ45xM1RWC1APNWQFO
	 V7yRgC0EC/OzsOT+uDBArbfdEuHd+l98ntosR8KaJTPtR62+sKhFieanALb0h401P9
	 ABxtQuVRqPfsZookTKgRjHKpUqyFH41+0OjOJVLPnRbY2+uLs3frEP18mV5ri3UESr
	 KQ6RGd7wYAFeNehgFd95BpDeHeC37/fPri5NWfnPsLvps9hggBSZTOFMVJLf6A6aYK
	 3MpBsnp8UokxD84Ddc6TK27F98+5Y5qE+yfpDqX+Mi0IQ5wzCvHCE1JAHh3IIPI6ZW
	 OAOzyd1Ip9QDQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1983E3924A4C;
	Mon, 24 Aug 2026 19:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net/smc: fix use-after-free in
 smc_rx_pipe_buf_release()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178759801763.3065827.11467340361243073030.git-patchwork-notify@kernel.org>
Date: Mon, 24 Aug 2026 19:00:17 +0000
References: <20260820074642.966856-1-hidayath@linux.ibm.com>
In-Reply-To: <20260820074642.966856-1-hidayath@linux.ibm.com>
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pasic@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Aug 2026 09:46:40 +0200 you wrote:
> smc_rx_pipe_buf_release() tests sk_state before taking the socket lock
> and then dereferences conn->rmb_desc and conn->lgr. A concurrent close
> runs smc_conn_free() in between, which releases those structures. On the
> is_reg_err path smcr_buf_unuse() frees the descriptor outright, so this
> is a use-after-free.
> 
> Patch 2/2 fixes this by taking the socket lock first and testing
> conn->freed instead. smc_conn_free() sets that flag before releasing
> anything, under the same lock, so the two paths exclude each other.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/smc: stop killed, freed and out_of_sync sharing a byte
    https://git.kernel.org/netdev/net/c/db51a8658c11
  - [net,v2,2/2] net/smc: fix use-after-free in smc_rx_pipe_buf_release()
    https://git.kernel.org/netdev/net/c/c924884743e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


