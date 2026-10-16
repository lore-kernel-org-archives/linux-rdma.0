Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C382253B0;
	Fri, 16 Oct 2026 02:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116607; cv=none; b=XBbD12iFNxyXq8psh1EPlfQoEQjGWP/TL2pH/oBPnPvGShHAb/KTJh2lb5WMmv0KNYSJmoLQ5OnHuJLGqr14AwVw5JA6kakzxgzBxNI658lcZ1sfEJTMQUqosvoTlGodBjtv0S0E1pOi6fBqgqx4Ey/vD79fTmdur0ayk+DO3Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116607; c=relaxed/simple;
	bh=8kkZFsuiz0auIp4TPMz2lTi1ked1gHc5TreNeKkusRg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=mco8dEhLxVPTuvNKsbszY0W1XziN8YrG7Ux0zKe1AKVw4tTV7j4Rc9Eww4QLofeR/wP9yzZzVuNC+SR9R1UNeo2IGdjchvBeOylmW2RdYQzQqLadTU/vEf2YllbY8WG1Y7pc85jY5PJyG14h+n3KgGIaRWYAnlPkdv2gm5CRD34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntIiEnZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntIiEnZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8550A1F000C4;
	Fri, 16 Oct 2026 02:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792116606;
	bh=ovnm/qowvJZT7R3W4KnHOmuenJoKcJJNqA48GQ0sZcQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ntIiEnZpZw8bbP84KIMVBu18OYYHJmCe5aAgzUie5YLM6PRRvVIHD1huhqTfefaAb
	 7SJ72QoGK+FBO8YHvvHKXCYLMwqldUX2VJhaS8aGStWzUcdu10ZGXM91bUQXoQOivk
	 cLugOZY56FvwPA5j7fkZQY87/VDs1OVP7hKLf4zss6hPZGmlJCAg3tRsvBCfFYaBAw
	 Mr1DmqVj+UOZR/0qQiy7URGdApnHTXbBYtxVVGwRwJnUpk+hk1c0hZK6q3JgvpCoVi
	 DN2cNWLDqz0NegTYBgX6yX5Hk67jeTqb7s1QpG/031O12BrLT7ijBioIaSDY5D3FjF
	 tAnUQdIzqCZ+g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 774D73808209;
	Fri, 16 Oct 2026 02:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] RDS/IB: validate receive fragment completions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211660497.15365.17816447060855250887.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 02:10:04 +0000
References: <20261013025729.40815-1-shubham@octane.security>
In-Reply-To: <20261013025729.40815-1-shubham@octane.security>
To: Shubham Antil <shubham@octane.security>
Cc: netdev@vger.kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 andy.grover@oracle.com, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, gio@octane.security, tjdqudcks0424@naver.com,
 robert@octane.security, paolo@octane.security, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Oct 2026 08:27:29 +0530 you wrote:
> rds_ib_process_recv() accounts every receive fragment as contributing
> min(i_recv_data_rem, RDS_FRAG_SIZE) bytes, regardless of the completion
> length. When a completion is shorter than the header-declared amount,
> receive accounting can advance beyond the payload supplied by the
> completion.
> 
> Only an IB_WC_RECV completion has the buffer layout expected by this
> receive path. Other successful completion opcodes must not be interpreted
> as ordinary receive completions.
> 
> [...]

Here is the summary with links:
  - [net,v4] RDS/IB: validate receive fragment completions
    https://git.kernel.org/netdev/net/c/65cf6863606b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


