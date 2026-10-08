Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF784F55D2;
	Thu,  8 Oct 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791485417; cv=none; b=O1Q+5YwP2cygTkKgytFFTg6FbqquHt6TrPWskY+kxDhRyC9J2O2N2d2uN1PPlmqvx+FoCVhuHHPZyjo/9QQEHgvDMjwDWpaKFVKKE/xGVLpRcV5uARTFyZCSIiONF6ASukeHEBzMF7kNgybiBshhZsbuuQd8JPLmfI3siJFd1uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791485417; c=relaxed/simple;
	bh=TWauTdYi7aFdx//up6fGxPh6MopKTH1dGtHVw6qEgUk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GarLNPZbNYvrBzJv/pxvRt36sdSn7dYtNCnUHW88avioXql2U/0M6v4+40sniGM298LlLA04Ndc82sT5obis2YMq1KVMKE/Tk8CmnepeIfn+9SD4qhDa9KdeEqQ3ynj9zIpL97x0fTm/Pu5umKhHsyGFrgfIjhUn12Pvub/i43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFfpGFzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFfpGFzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0751D1F000FF;
	Thu,  8 Oct 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791485416;
	bh=YVEM8wubkfgoO6VY6b9IYQ8KVp9Yd8n0IdmY+rRBGSc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=BFfpGFzsiieIAVfuXPfu/MURAqPT0JE2yLer61po92pKP7i5yaaMpXbWBd5S77Y+/
	 2exjrNWIE8Yz5ZrGmdCoH2uGs4EZ5cg8fP9s+7AQF3KSXzObfzUBSl8/TdycypNhZs
	 ClNeepubg5wUDpjKmBUVURKJRlskvSzKnQxnC375oHnI/1Kc5rtshrUkf/JTqxR+HO
	 ensfrtFiK3ZP6igWqCSzE6hievyqC4VENFYWLsPxdlqpHibdK8ghzelMoCYtNMT9tO
	 wLSQldLmJ2LzbMuvUhxQib9EysdTUB9aPFrzs8wIQ0hiHMlAGV9z23x1fz/PGeOcqh
	 e5VNqT9huCP/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14CC380CEC8;
	Thu,  8 Oct 2026 18:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/smc: protect clcsock lifetime in smc_getname
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179148541452.391001.7821092438083356989.git-patchwork-notify@kernel.org>
Date: Thu, 08 Oct 2026 18:50:14 +0000
References: <20261008084444.787449-1-nicoyip.dev@gmail.com>
In-Reply-To: <20261008084444.787449-1-nicoyip.dev@gmail.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Oct 2026 16:44:44 +0800 you wrote:
> smc_getname() dereferences smc->clcsock without holding
> clcsock_release_lock. Link-group termination can release the CLC socket
> through smc_close_active_abort() while the SMC socket is still open,
> for example after shutdown(SHUT_WR).
> 
> A getsockname() caller can load smc->clcsock, then the termination worker
> can clear the pointer and call sock_release() before the caller accesses
> clcsock->ops or invokes getname(). This causes a use-after-free; if the
> worker clears the pointer before the load, it causes a NULL dereference.
> The syscall's file reference keeps the SMC socket alive but does not
> prevent asynchronous release of its CLC socket.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/smc: protect clcsock lifetime in smc_getname
    https://git.kernel.org/netdev/net/c/64a6b36b0e18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


