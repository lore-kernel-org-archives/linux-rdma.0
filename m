Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F78A26738D;
	Tue, 28 Jul 2026 01:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202247; cv=none; b=XeaUUKEPKcLdTcH3mVw8dXTTPjavK7KlS73SvWFSl8mGy3FrL4VZiLlUvIJ6BrRrmfcgCgYARE/vNbB/VkCsDIFz0WFJ4noLBnecRIno6hv2n+fYhMTMBxwb7MYezvxdMyZr3B75/LuyB8RnyCYQS1O5RHrQlvxxvlZqMT63Emg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202247; c=relaxed/simple;
	bh=CFMzz9guSAvIBsLAVo1MKptZ+FsUSCoMkkbqTvlguxU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=F1/brCfN8UDllhThsLA4Fysd84WvWXYoob8Mh25QxFqrUcZpNBMKVBMSC/EP8dhPIKj0ewTv/yRIM6H0HDCb4vi1UgcSYSFTXxrJXpgmPXWgI5ijfhYqQjhWCe7zY2S/eqwXn5p4mDUBFTP4aCk4XEo8UXBM9FkkKAjgOHjTIEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=essXwa7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="essXwa7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333231F00A3A;
	Tue, 28 Jul 2026 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785202246;
	bh=Vi3icP0TZ6KP4vQFea+c8YVm5sorsC9qkwHvtd7cSJs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=essXwa7DoUPln2WbkZpOLcK9Mk9aPCkQadtRlIesS07djFwcXYkDE7C/E4pnqDprd
	 8UKCgj8YPESWFwJq+nE/iVL54icH/bMVs/MCYNyrsXjJqthXnSI3vG5Jy5wGQzsoVC
	 6NXHJJwlnPHxhyaNDPo9XgzpnwFrKzaQiOpHpPRvi0iHzncNtDClfjNS4Bu7o8Kpii
	 YFC/AMfHQup0cynvCLOF1dUA/mYgAwocZFEEAS46InfbOyMnpjvkCsBUBx5fsDivUU
	 3EU2PLfk6iZ8pY7mw/NmvGC0Lu3e2y9DgsLcEWyLL4V2mYT1FQUcEMg/qp5mPaMCQM
	 cjBLHLo9PDGJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 937EB380CEDA;
	Tue, 28 Jul 2026 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: SHAMPO,
 Remove dead CWR handling in GRO header update
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520221113.1492617.15511883311920492719.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:30:11 +0000
References: <20260723072829.1864366-1-tariqt@nvidia.com>
In-Reply-To: <20260723072829.1864366-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, chia-yu.chang@nokia-bell-labs.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jul 2026 10:28:29 +0300 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> mlx5e_shampo_update_ipv{4,6}_tcp_hdr() runs only from the
> gro_count > 1 path in mlx5e_shampo_flush_skb(). HW-GRO flushes the
> current session on a CWR packet and delivers it as a single-segment
> skb via napi_gro_receive(), so the aggregated (gro_count > 1) skb
> never carries a CWR-set TCP header.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: SHAMPO, Remove dead CWR handling in GRO header update
    https://git.kernel.org/netdev/net-next/c/defbb6534ff3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


