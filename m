Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE33815CE;
	Mon, 24 Aug 2026 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787595664; cv=none; b=bqxuF7e/V/7kXrvHRLIno5mrHXzpgBcs1FlJnXKtZnokSCiPUYdycGNnUgyie939v7W0ONLOw/+x5EcsC8Hga2qiSkBZ4tkFI+BMRgi1OZqto+A4hzF/rMFUFlzgPC57I1tlaKVfd13OH0v0RIgqdUvbH8+WzGT4i9Sfu6kjVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787595664; c=relaxed/simple;
	bh=F0dEvCUyQEyIj6qW4WR5Gl+pMQGgkZl2dYI6VyGEY1U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=u3GusjsDb/NFbotMrAIRPUY1Pw5ukmao/3wJijGa9YSSCUtlph72FGuCGzhQQPmZVvLbvBebA8/Dot1HWcUc4MigBqGsksSrshOoYd+3UFx75IpKcEb2nr+Zd4vbcTF6ZudSlxCGjUl4+7V5kE3ZA4JTqiCMiWgtky9DBxM0JZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrGbKR9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrGbKR9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6021F000E9;
	Mon, 24 Aug 2026 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787595663;
	bh=sETMReISMBe6rjtQEm20AuiXiK56X85vfYOV++AGSe0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VrGbKR9VGsJYoffJbq9RnobYFUSqZaedkdBTA9n+E0B8M/63QpKK2qWaY6o6GUbE5
	 Yy5mFkwiYeMj6Wn2sImSQDB4h8GlwgUpFEP7LV21npHJhCrl+N/X2lwWeQVEoZUcH9
	 9rLU3chh0c8FKvVXPacPV7VED0TUFNKreWGOXHxNgCNEIoEmPv+oqx2Cid1JDfF0V8
	 ff1cnVCX1dXwwd/2ld/uu2p4CdQeCe8G7wum/2xp/v84ZK47b9UQeQZOm7Glr5nNhe
	 Kwnr8dOiinRNdnlrPCI9+kVoW42AfuMNHDPhXwHz3eFIFqzu8biPlkPmxe4OnExdTd
	 TLVmIr73BSt1g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0FF863924A4C;
	Mon, 24 Aug 2026 18:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] xsk: pre-existing AF_XDP TX metadata fixes
 from
 Sashiko
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178759561065.3051903.3086695861982033843.git-patchwork-notify@kernel.org>
Date: Mon, 24 Aug 2026 18:20:10 +0000
References: <20260819160535.1472459-1-sdf@fomichev.me>
In-Reply-To: <20260819160535.1472459-1-sdf@fomichev.me>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, maxime.chevallier@bootlin.com,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com,
 maciej.fijalkowski@intel.com, sdf@fomichev.me, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 guoren@kernel.org, dtatulea@nvidia.com, witu@nvidia.com,
 martin.lau@kernel.org, yoong.siang.song@intel.com,
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 linux-csky@vger.kernel.org, leon@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Aug 2026 09:05:32 -0700 you wrote:
> A few fixes to address pre-existing issues from Sashiko review.
> 
> Notes on the feedback from net-next v1 posting [0]:
> - It correctly complains about ABI breakage for 32 bit systems, added
>   an explanation why I think we unlikely to have any 32 bit users with
>   launch time
> - mlx5 batching (pre existing) - I think my point in the comment still
>   stays (that we do not make it worse)
> - stmmac recycled descriptors (pre existing) - seems valid but I don't feel
>   confident sending a vibe-coded fix
> - stmmac queueMaxSDU vs taprio offload - don't think this is real but
>   we can fix separately later if it is (the existing issue with breaking
>   xsk seems more real)
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] xsk: align TX metadata layout across ABIs
    https://git.kernel.org/netdev/net/c/bd7d30bd1d38
  - [net,v3,2/3] xsk: honor XDP_TX_METADATA in zero-copy path
    https://git.kernel.org/netdev/net/c/a6e4b9a6deb9
  - [net,v3,3/3] net: stmmac: document oversized AF_XDP frame handling
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


