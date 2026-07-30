Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFD30674E;
	Thu, 30 Jul 2026 00:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785369658; cv=none; b=TLkL2phVacuTlkvNQeCdXj2PVe8NHExq1x5PsCLvnS19goPlEZuuBZ44qn53h3CSp/cx+0pEvgrB0vRYziinbIdPNtYnRhcntj6iaKHf19BLBhzLT4SXSr0d9LFmiyKAUoQa+J9rH56wcjt8O+uetH88JFNHnfdx7jzcrM3Yhlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785369658; c=relaxed/simple;
	bh=leXaSP8LFnt50FYIDTkJh/3Ttb1WuAj+UN1dnGYl1Yo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YkccpzsaYuZH9fw99ubUURW4pzr74KVdi12l36VSB/rcuTIFTmrHT33aHX+N2XV0z1u0oRTYxaNX7KnQ+UFfkEhCfyOSH32KKlIzGv8sl6x1lx4bINJZNz1NnPFht107evfHuTBVrRSR7TX0PmrQ2E8WvgMQFk4GBz22kGjX0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFt+cjxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFt+cjxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AB31F000E9;
	Thu, 30 Jul 2026 00:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369656;
	bh=c6/1QRTO6GU4trLCSIEcpqYa282SU3GNO1VjmD6rK3s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iFt+cjxvdciJHTRmCCn+jwCFCia17G7SHSmLQ5rB/WCRf0TwjbrOmk6zXHekh7vb7
	 QYpFhKtiSfaWYKBCD7wN/fwubgEgxlQcbWeTs1N/87PlPiik5+rRQ26s7SckmGswPE
	 gtdeZ709of8xdjUw/QFwLLwOmEyvQRMe4Ce5BEQStuhHLxTmdNniA1gdDO9kGlT7yS
	 dfdWgMuR0Q+2Fcu0SP+iWpRHkYWqo5QUL0rd7ge2GHVN6Gp8jzL6XXFVDu/m2WeWqE
	 /FIvD2mzytqE52zW2GEaL/+vfi3cA5jhQdVHefNAQpmoZc0CPGZEyK9JVvTprseBkQ
	 3UxOCfJkL/KOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D12A73926250;
	Thu, 30 Jul 2026 00:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dibs: fix use-after-free of dmb_node in loopback
 attach/detach/unregister
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178536962038.3288516.6334881564101626025.git-patchwork-notify@kernel.org>
Date: Thu, 30 Jul 2026 00:00:20 +0000
References: <20260727093530.968834-1-hidayath@linux.ibm.com>
In-Reply-To: <20260727093530.968834-1-hidayath@linux.ibm.com>
To: Hidayathulla Khan I <hidayath@linux.ibm.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 horms@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
 netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jul 2026 11:35:30 +0200 you wrote:
> dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
> look up the dmb_node under dmb_ht_lock, drop the lock and only then
> operate on the node's refcount. Nothing keeps the node alive across
> that window: __dibs_lo_unregister_dmb() removes the node from the hash
> table under the write lock and immediately frees it.
> 
> A concurrent final put can therefore free the node between the lookup
> and the refcount operation:
> 
> [...]

Here is the summary with links:
  - [net] dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister
    https://git.kernel.org/netdev/net/c/a10ea943356b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


