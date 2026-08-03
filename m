Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693353CCFB2;
	Mon,  3 Aug 2026 23:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785801073; cv=none; b=eTem5lKt3B196AuqzOtoS73G4oWjjb4N2gJQzvXBPYlyy5KFqbDTIjf0v5y6PMAhdgExWHlS7G4dFvUAvIdzuwxLkBd6RNDy9nifX1vRFBlwFkPPU+HfMo9k571/XUPP/Ju6DRZLdkXRIcBK9samnkTs+1S91W+fx9JU3hVEiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785801073; c=relaxed/simple;
	bh=L2kiIcI7Ce+AmuEsB3YZBOU6hc1VVc3zYK6zXpWmQUM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Aa3iW0ww3YMPk/alXZls2Rs+6gNqrE6O3zWrrR04+L211pV00iVFDOC0JeRISRuEFGonE0+DjCn6VQI19NLPa5lGim/mEeQvl+6bRvk23MAGUTNw2l5lVoO9VOX+ObvI5ztbjxWrIF4Wzkpc4jfaQZwDKiDKsSEraTXr3y5/+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkRYn8yG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkRYn8yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9061F000E9;
	Mon,  3 Aug 2026 23:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801064;
	bh=B4yhz+JQv0QMMgQVrxwyPdXvzn96hxmm8mw/fYkupHg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dkRYn8yGh74TjYjobcsupvOS3FRrRLYd6cOInE3TOiNWpDcNrujN0Indh9wOZKxVw
	 ej01a4pV8te8xzikOjLkSAlrhDSVOfvD4+7ethit34sQMSO3Xq3vynpRNbRXhgyWhl
	 xlzoXLS1Z2TLS+DePJy8rTxUnKc575FIikguZAMkayr8U5Bdjfn/Xg3of0RYOCLnAq
	 giq2gUJ0G3gwY2dNLcPYB7Le7xc3cksCq5QycHWD87aspIJUWvRRdy7jqLKUEKCJPR
	 iPnBf6PILULBZj7W5vT/2LgoQs6ktqXCkjc3EGwKxVpkjtkEeUgcL7RGyyoXmHhcou
	 piWz4OrX8iklA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A113924467;
	Mon,  3 Aug 2026 23:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] xsk: harden TX metadata validation against races
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178580102466.2881314.4527278917944249834.git-patchwork-notify@kernel.org>
Date: Mon, 03 Aug 2026 23:50:24 +0000
References: <20260727161959.885642-1-sdf@fomichev.me>
In-Reply-To: <20260727161959.885642-1-sdf@fomichev.me>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, aleksander.lobakin@intel.com, horms@kernel.org,
 magnus.karlsson@intel.com, maciej.fijalkowski@intel.com, witu@nvidia.com,
 alice.kernel@fastmail.im, dtatulea@nvidia.com, yoong.siang.song@intel.com,
 martin.lau@kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, leon@kernel.org,
 AutonomousCodeSecurity@microsoft.com, blbllhy@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jul 2026 09:19:53 -0700 you wrote:
> Cen Zhang reported a KASAN out-of-bounds read when AF_XDP is configured
> with a TX metadata area smaller than struct xsk_tx_metadata. The metadata
> is also shared with user space, so reading its flags more than once can
> produce inconsistent validation and processing decisions.
> 
> Require enough space for the flags and one request field, validate the
> launch-time field against the configured metadata length, and use one
> snapshot of the flags while processing each request. Carry the validated
> decision through completion handling so later user-space changes cannot
> enable an unrequested completion timestamp.
> 
> [...]

Here is the summary with links:
  - [net,1/6] xsk: require at least 16 bytes of TX metadata
    https://git.kernel.org/netdev/net/c/1bb30b181d9f
  - [net,2/6] xsk: pass TX metadata pointer by reference
    https://git.kernel.org/netdev/net/c/19366db6dfcc
  - [net,3/6] xsk: clear metadata pointer when no timestamp is requested
    https://git.kernel.org/netdev/net/c/9f60a67df8d3
  - [net,4/6] xsk: validate launch-time metadata size
    https://git.kernel.org/netdev/net/c/439ce2dddf3d
  - [net,5/6] xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
    https://git.kernel.org/netdev/net/c/ddd0d6c5bfe2
  - [net,6/6] xsk: validate metadata when processing requests
    https://git.kernel.org/netdev/net/c/849b1664dbda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


