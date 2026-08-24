Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD2353A73;
	Mon, 24 Aug 2026 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598672; cv=none; b=DLkkqc2f91fCCsZASPKk7lUoA0ndPCTdOB9bHEatJ3ysxQoLiyrSVnyXbJ59EssjhislwPqElQTlBRCgMRSOmHJLhh/jxWsju2Au0rTYeWB4MGASnCOJ/jCGiZHP5B3/bRBB9fqQIQKhb23P4CGIHBzDIDZlGJam0MIzba8D1GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598672; c=relaxed/simple;
	bh=PHHOGK61N4x8xH3mE1NIQa4WWO4g54voMMeOKvBCp2I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HX1oUWBrcYJDexxUYARaCDE7LF2rDrcI6+85cE3mD/+puAn4njC4CT8/k/R9iQyAORFLyD+TqmV1DyDoa17xULFqovCIyQSv50jbY57Ox+eqJNKvJFL9wV0W27ntoUnq+ziF8/sDnHbrQCObaxQDmNLHBv/eYanwBHO8OTEpXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTLSMvsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTLSMvsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67CF1F00A3E;
	Mon, 24 Aug 2026 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787598670;
	bh=gRqYaFP71RYXxDbVtmJnm3PU5E9JC49RTvlpnEabZ+0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lTLSMvsKW0LawBviXbc9JqQ9kYIKUW3qe+M/nFO+lTrNS0QLxo40l/nyYYmPUjpPj
	 9OxahpFl25DzXxAi/R0ISljw2OKT4PY9FTUOQmYcoqx3xZ7UhqEVqWUF480EOr46Ja
	 7sI8N3aLNXg2FezYIrlEcCdWIgetW/oUaRrD1T8V7iFipzav1woXiVu3kHkadQiNo5
	 xzScb/0Ub/4qWrAic+eZAnB2ymBCdlk5ON+SNo6G1v8dWHM/WXmJR8U9Sz6wDbFgQK
	 6mim1iR6ZCGGCoS6DmHAl6igkklkd98pMklesTr5JuscJpTgQdx8o8o3txHz8jjxi+
	 hfx5NBBhbHzpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939BB3924A4C;
	Mon, 24 Aug 2026 19:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mana: Cap MSI-X vectors to the device MSI-X
 table
 size
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178759861814.3069565.10209025813207370256.git-patchwork-notify@kernel.org>
Date: Mon, 24 Aug 2026 19:10:18 +0000
References: <20260821183736.733296-1-longli@microsoft.com>
In-Reply-To: <20260821183736.733296-1-longli@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Aug 2026 11:37:36 -0700 you wrote:
> mana_gd_query_max_resources() sizes gc->num_msix_usable from resp.max_msix
> and the CPU count, but never from the device MSI-X table. On a 1792 vCPU
> M-series VM that yields 1793 while the table has 1024 entries, and
> mana_gd_setup_remaining_irqs() then walks indices 1..1792, running off the
> end of the region mapped by msix_map_region():
> 
>   BUG: unable to handle page fault for address: ff8e347f8b99800c
>   RIP: 0010:msix_prepare_msi_desc+0x7a/0x90
>   RAX: 0000000000004000 RBX: ff4330cb164ea780 RCX: ff8e347f8b998000
>   Call Trace:
>    <TASK>
>    __msi_domain_alloc_irqs+0x13a/0x440
>    msi_domain_alloc_irq_at+0x149/0x1b0
>    mana_gd_setup+0x351/0x890
>    mana_gd_probe+0x274/0x390
>    </TASK>
> 
> [...]

Here is the summary with links:
  - [net] net: mana: Cap MSI-X vectors to the device MSI-X table size
    https://git.kernel.org/netdev/net/c/2c7493f98014

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


