Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047019;
	b=QezBtyU8WUg1s5C1A+mQy/DvNper9DRnZGCNBTdQ2bU/YfDFMhGlmPPyi9ryOg1xWlL3
	 n87/Cfd4rL8H4VdVRhiHZ3OhFb6pKflEpZk+xejOpMR99iDfs0K71TMwxgvoxmXMeOpR9
	 4mBL1+z+7EtMfa0Ed1bZ1UiO82VKGgQhsHXwQDgwRAygMPtZEkXVMEr165QFa+4qw35a2
	 oNnpkZgO7XZZTPmYmjbwj4DQvzEOX+EtCnFQnnKDgbuy2xIXZjY0HChq1KXnTEicZr2If
	 oWszckKEMFlaGrlr6+RWGHZ8lXin6ONtck/7A9ajwTwLuP4GtG239RFyGd0sSE8zShg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047019;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=9DdegPMLQ2pfaXK5/7QOz67S/60AgrqPFSiPq7PN+r8=;
	b=IXYLyXdaEBoHoIo/GrJ7zOpG4zgCOYoRvcHj7lot479wX3gm5qXPKI3Hbqyp/nkhqGDA
	 gYveiujueBbOl6Q1K4UTvdF6EyGV6y0ZZeJFLLnusBBCx6j79MmdY0VRknmqowEjyB1RL
	 AlRnKWajOZKCiTf4J/dc5oKno9DuHSqEcKB+W8qqKwoVzeVzAvTVOtdzeScR20RbfLMmL
	 Z4SMfvPdITSTk9Hfai95ZzS9jHH63qGVBAJtzbdQGxYophpHJdofK3ZCDCcP+EgYTe/Jg
	 4SxV1D2yG21VGghLYIFADt+PsG4cbLA3pOCIW7xjgW8fe9nAK8xc/PhrFiVKPHe/a4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vx5X83iC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89960A3834;
	Thu, 19 Nov 2026 00:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vx5X83iC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065331F000C4;
	Thu, 19 Nov 2026 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795047019;
	bh=9DdegPMLQ2pfaXK5/7QOz67S/60AgrqPFSiPq7PN+r8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Vx5X83iCPc1PfYSQqI/bUfkjxxmP6l45i6IX2VuAUM6UdIEX/A1wWk9kVtyYfxFYf
	 5+ViOfUci7Dhc667M2arkYICDZY/pKBw91IT5mh59+SJCpooHDQRAhdAjrMx5jOdKC
	 07jMCEJgAecFHLmlC8jo3jCj+kHCZeSKA2MvRRnPbVv4j/V6mRvTumxytCkCKF7dtL
	 XoRYGqd67lWcuAL8qrKE+bK6uNtSDTI7/L+ItVzSDtfxFO4jVxud3c0tfkUbS85fuQ
	 ht5PryTHSQkdfQYJP7fkEnKRUXORsVSx2+UFZO7mTmo4DEJpgRzZVgP5mwwl1cCK/0
	 bxGnT6WKnJaqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15173808210;
	Thu, 19 Nov 2026 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: set the lkey of every SGE in
 smcr_tx_rdma_writes()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179504701752.2637749.9567972883939360454.git-patchwork-notify@kernel.org>
Date: Thu, 19 Nov 2026 00:10:17 +0000
References: <20261114-b4-disp-dd99cd41-v1-1-009e1c022346@proton.me>
In-Reply-To: <20261114-b4-disp-dd99cd41-v1-1-009e1c022346@proton.me>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: edumazet@kernel.org, mjambigi@linux.ibm.com, pabeni@redhat.com,
 kuba@kernel.org, alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
 davem@davemloft.net, dust.li@linux.alibaba.com, horms@kernel.org,
 tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, guwen@linux.alibaba.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 14 Nov 2026 09:14:58 -0500 you wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smcr_tx_rdma_writes() sets the lkey of an SGE only for a virtually
> contiguous send buffer; for a physically contiguous one it leaves the
> lkey the work request slot already holds. With net.smc.smcr_buf_type=2
> a send buffer falls back to vzalloc() when alloc_pages() fails, so one
> link carries both kinds, and a slot last used by a virtually contiguous
> buffer posts the DMA address of a physically contiguous one under the
> earlier buffer's MR lkey. That write fails, the link goes down and,
> with no link to switch to, the link group is terminated with all of
> its connections.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: set the lkey of every SGE in smcr_tx_rdma_writes()
    https://git.kernel.org/netdev/net-next/c/752c59c85423

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


