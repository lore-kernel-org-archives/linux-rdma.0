Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC433A1C9;
	Wed,  5 Aug 2026 02:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785897046; cv=none; b=EGD8HymLTfyFQqleB3Gpg+Q2j5ebG8C2PSTRfHYW6GzxldSE7WV5Otw3iXTXVw950SXLEqlM6ke++vwR60Osa3ZjLali8cXps/IXL716i8pBAJoBQ5btVCeLcLMc/ammqgdPIhaSlF4CGoMWAP8+dZJDxl2jTT4iGL+7ubeukyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785897046; c=relaxed/simple;
	bh=/nyC35CZsnj3F+uNxslimiltB1Rebboj1tePpRdJsJc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=IzwU/rvNtct4qc9pEXPZeSiJs92KLUrmdAJe8C2Smk8Ncx2VupMGZyC55ruwvW0Swmc6lotCY6l5/gog8nlmLCB2sIeshmbGDeAGtDpwQAk/kSeFuDT/IvfrggIStjYc1QJDO5jkVz51ETwxWz03PurOIhJdIT6czuyRKptLtWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oy0oknDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oy0oknDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1571F000E9;
	Wed,  5 Aug 2026 02:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785897045;
	bh=nFcMsLsV/jsKseSOOqELWn2P4wAKKeGU4iN4a8UsJFc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=oy0oknDyHA+OAlOzhYAX9hoUX3RLHMDGXKloFEv7KZ4vUbIGxYwUZs3XzUk3oQN8n
	 ig4Wb3ng2IEUCSbfm1R7NFyictZwaBcU1h91pGu2sGbm3ixKw1IbPdgPlHn21N353+
	 JgFt1rDtUCH9fjnNfLsDKN5dgzz0xjXU/7aKaWH4sBVIiCE53ikzq189uRqTF2Bm9L
	 qJP20tScKA6kRTBhMUzSE27/yiFclV4BwqczZz+PFSt+/heowhPHtyBZg2y8YDdghi
	 59HOyQJ3UwSWx6OONYT2f3mndgxyDe9bVuXWFHXvPlM2EocrF4DgfaXYfHaj7m2j8J
	 aYiHGJhd+Opng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0921392446E;
	Wed,  5 Aug 2026 02:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/mlx5e: fix BQL reset on SQ re-activation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178589700540.3883535.9164170371503603124.git-patchwork-notify@kernel.org>
Date: Wed, 05 Aug 2026 02:30:05 +0000
References: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
In-Reply-To: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, dtatulea@nvidia.com,
 almasrymina@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 03 Aug 2026 16:47:29 -0700 you wrote:
> From: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> mlx5e_queue_start() deactivates and re-activates all channels but closes
> only the queue being restarted. mlx5e_activate_txqsq() then
> unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
> of channels that kept their in-flight TX WQEs. The next completion then
> over-charges and trips the BUG_ON() in dql_completed():
> 
> [...]

Here is the summary with links:
  - [net,v3] net/mlx5e: fix BQL reset on SQ re-activation
    https://git.kernel.org/netdev/net/c/e7386770be1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


