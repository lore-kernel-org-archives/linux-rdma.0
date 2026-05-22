Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A237204A;
	Fri, 22 May 2026 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779474009; cv=none; b=Dhw46stAaeD0oV5am1Bm21H0B3AKXe6w2i1SQBvip3kqqvCd/F58A6IWsmXZZvfJh39X3zxB5PivOZLLbZuWmsvW2VgXrEeBwT50DORPUZ7LRqrt8CmMYDHynB657xbgUntZPzPHe1SRw3Nxq0DL2h/BFEHMhftUgLtugNxzPmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779474009; c=relaxed/simple;
	bh=NUoNLZkXE7mCPVDC6q+rsPMeKJv3VUIh65EIfkPD3sM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NTjC4CCPE1ifIafj84p/bjjlF3mlCTGFAxw0t1SDCBCyRTN33ohqgqaZ0Woen7L4LlfT5PoCPwxN4HKJ5F1tdoS7C88pt43sN/EPd/kVnAksJ+f/CRt4xcEVs5GoZ80pxFpgVq+bB6/A3o1+TDi5qTvXtY56HluuxvETomWqdM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFHjpT21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFHjpT21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E40B1F000E9;
	Fri, 22 May 2026 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779474008;
	bh=qM2p6TEmCfXL753GtJ3p2ebVls1ARMYe7b6ogYrro08=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=RFHjpT21c9Tdmt5V3Y7OffReXiagtN+25l/L1Swf6yVoJNkwQGEPUo4OGC6bnJMqK
	 hP54lmC6xu6cQ11deryvMqDHAfq9qjDs6iOAB5EmgwYpJiW2eqf1RJc8Q32/4vHiuC
	 S5fVQuXYO3e5xXZ3ZGwSbSzt3qAHNUd7EKqQBoDhgYoj4088K2O1niL+HQSVhfDLmy
	 ECQr0aMq9IrPUNYW/P9AOpCVGxJdyNMSr3NJ7UzvxE9Swi5Bzx4ki2QKJ7CjVgs9fb
	 i50b6tq7xyc/55P34erz0VpeZ8tb5v8b5rICjYIQULh8IhKMqKpxEdGjnzra9scptT
	 jnxXB5TLXmmHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BD03930FB9;
	Fri, 22 May 2026 18:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9] net: mana: Expose hardware diagnostic info
 via
 debugfs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177947401714.1320830.17170258046275289857.git-patchwork-notify@kernel.org>
Date: Fri, 22 May 2026 18:20:17 +0000
References: <20260519064621.772154-1-ernis@linux.microsoft.com>
In-Reply-To: <20260519064621.772154-1-ernis@linux.microsoft.com>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, shradhagupta@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, kees@kernel.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 May 2026 23:46:10 -0700 you wrote:
> Add debugfs entries to expose hardware configuration and diagnostic
> information that aids in debugging driver initialization and runtime
> operations without adding noise to dmesg.
> 
> The debugfs directory for each PCI device is named using pci_name()
> (the unique BDF address), and its creation and removal is integrated
> into mana_gd_setup() and mana_gd_cleanup_device() respectively, so
> that all callers (probe, remove, suspend, resume, shutdown) share a
> single code path.
> 
> [...]

Here is the summary with links:
  - [net-next,v9] net: mana: Expose hardware diagnostic info via debugfs
    https://git.kernel.org/netdev/net-next/c/c227f8aaf22c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


