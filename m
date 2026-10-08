Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAC63B3C0F;
	Thu,  8 Oct 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791481810; cv=none; b=SuijHt8uvhR3uHxvth0XAjYT+RDM+4/LNMdU7jBFaWLmh7I6OE0FNs797IqjewTNBUEg6LEGXPgDWfezD+G27bgc10YLYT/8MzJW3BD1aU4repKXg+UIxxcz5JCfG5YlFnQqUqRFR3/Zf8IUGYQILqhqLRqaDpj4GHhvof/Ir5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791481810; c=relaxed/simple;
	bh=TUvUUXllTc6eNpEER8QJkCPOrI3EAlLz1SjqM8uSpYs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Imb176FBmblbzj1QbzSlbjBPRzB3qPdrXFNpSk/11JbJge7lCDZQLljS6JBZ0spI44bDbq+dmw6hXzeOgloNJfOdQ8QH6xPrH+i8Qe/CQTG0ImS4t35e/sTS+c+FHol7R/xMNDa9T/jLK9hXsYaHmNYZOorEo1CboibtiVaj/wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ed+BZ5gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ed+BZ5gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468301F000FF;
	Thu,  8 Oct 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791481809;
	bh=bbf892qVAu2p6RQcZnFrS2jd5CGTl+B0MWLIpreU0x0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ed+BZ5giRvDHW/LX7QtVxXXaK2td0Ne+Q7Mh2A+aTwBLZlamsBIXNXA3H0WeO05iN
	 EEutzmRdBarnTD/1bQA3Ly9EP2nCMHYZhdy5a4Y4yFmGaFsHMg6+4ztq1CI2IZ+PrI
	 uGEd9svyd3aRxAVekn4eb9Y32Fvcfoi2BINnSdivEGpw1PVvTRUYgNOudgipalro8C
	 sXfu+JuyvXHDREHbnhDZ8yPJFyPfCs7HeyqOgDtZp3pUo+zvBn8IUTZ+8jWsp7alqa
	 6e4+n3/GQRLorw6YjbEyIi7PyK7u/jfmITlNLQSEBBQQ6MdyBw5Z8qeOlooZ/1Y7Wh
	 Qy7TdYNK5aFJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3B9380AAFF;
	Thu,  8 Oct 2026 17:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mana: reserve RX buffer headroom to fix
 forwarding performance
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179148180777.369078.5370771541534290369.git-patchwork-notify@kernel.org>
Date: Thu, 08 Oct 2026 17:50:07 +0000
References: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>
In-Reply-To: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netdev@vger.kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, leitao@debian.org, jacob.e.keller@intel.com,
 ssengar@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  2 Oct 2026 21:36:47 -0400 you wrote:
> Commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
> instead of full pages to improve memory efficiency.") started handing
> out RX buffers with zero headroom so that two buffers fit into one page
> at the default MTU.
> 
> The MANA TX path, however, stores the per scatter-gather entry DMA
> mappings in `struct mana_skb_head` at skb->head, and mana_start_xmit()
> therefore calls skb_cow_head(skb, MANA_HEADROOM). The port advertises
> this requirement as ndev->needed_headroom = MANA_HEADROOM.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mana: reserve RX buffer headroom to fix forwarding performance
    https://git.kernel.org/netdev/net/c/259c4a519100

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


