Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6AD318B9C;
	Fri, 27 Mar 2026 02:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774577420; cv=none; b=RuvRmuh7IqYnbACJw+qejwXg19v8WaOJ1hR9R6y3c/KIdYt/shc5SiE0rGHcQmCGbX89/5azPuOHzw53/w4Mv8UFy+1QSaFm8C5bezi2v4MRp7bN4S9BVscjyXNf1iUJjidehiFhtktxxlnIRB2HBu+wbMtCTKcNxUG+ZEo+Glk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774577420; c=relaxed/simple;
	bh=XL2XaiBFzO/RZQtR+6VxjzdTf0vKl3oagcj/NyvFaCw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TOJLi0pNXK3KkKg9fNnjtJl4J9mln/3hJRQRnYroVBTG3ClPrWmk/hIiE/VvgfCAKOmT2EBsSG/mP/PWOiFY9pH6Bi3ZtagiGR+BM6FNu5iO5nItRoi8j2hwPWO6Jg9RzULKq3ANd0ZiulRYkjnPP5d0ztJSdiHzbfsD8ipIfsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fi06MZQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fi06MZQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCAFC116C6;
	Fri, 27 Mar 2026 02:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774577419;
	bh=XL2XaiBFzO/RZQtR+6VxjzdTf0vKl3oagcj/NyvFaCw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fi06MZQFzo1TMjvusqFERQeAbZ1Md7XigHXnhwPmpIgPyR1ypjJh6FirpHB/sHTkC
	 MeqxAlp5pAHTeYhBbSQrhE3Zr3PVdcY7FTvPSJi66CcAF8DNQctCHfMBE+e48WDkTz
	 7IY1bJh9pfV4y4qSuL2Zvu4YoSyvdn4eHtrMmfTy5zQasFlkNT+Zjj1k+Pea7H51ER
	 yJEvJP0HjLVBiVDrSXl9rkR5h7fcP41vajrT/XuACbWMMrtgdzIyFoEvcv206SF2KU
	 NVS4o6hwGoUaq/cuY8dZwmRUE3hSxsKUoDhWrYNe1Ami5rwkmMoM8apfeALp8HQ0f2
	 WPFT0pFNYunWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD263809A07;
	Fri, 27 Mar 2026 02:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2] net: mana: Fix RX skb truesize accounting
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177457740604.3263687.14878454384764628197.git-patchwork-notify@kernel.org>
Date: Fri, 27 Mar 2026 02:10:06 +0000
References: 
 <acLUhLpLum6qrD/N@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: 
 <acLUhLpLum6qrD/N@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Mar 2026 11:14:28 -0700 you wrote:
> MANA passes rxq->alloc_size to napi_build_skb() for all RX buffers.
> It is correct for fragment-backed RX buffers, where alloc_size matches
> the actual backing allocation used for each packet buffer. However, in
> the non-fragment RX path mana allocates a full page, or a higher-order
> page, per RX buffer. In that case alloc_size only reflects the usable
> packet area and not the actual backing memory.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mana: Fix RX skb truesize accounting
    https://git.kernel.org/netdev/net/c/f73896b4197e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


