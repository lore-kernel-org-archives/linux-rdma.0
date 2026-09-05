Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB561D9A5F;
	Sat,  5 Sep 2026 20:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788640270; cv=none; b=ViJkLElnXU6h0tfIKNKiuckW92Y6uJX70yRLX7jAPuQikES5lpmL9upzOi/Zl1Rs20/hXKSB42yBabXntcWynS21WNIGOk2I+JeikSFUUGbcD+oQitzB6ey6hVKcAYyicQn41J4sCoTdTAJjX/C33aWQ0gaflof72ku52bOk8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788640270; c=relaxed/simple;
	bh=8nnmnAE20iGlGfEMdkHGIeDIaBITqRDCHBfLqe9WD4U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fNZ5Y9nbTxHPHqkaLQ7nB5jqdmYw4DQNlFe/dQyFDXEZm/dJPJTflWxQG3HYAGs4oJzQ9EZSsQg4dhl6MWoiNw+mOtMBDfj9Q25fuWcRHweQ6k8i5Od6yNrA0vObv4HL5km3tywxZ9dmRl1kRJHyvMExbkQxmKC2eZeikMLKQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iu3iIHVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iu3iIHVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7081F00A3A;
	Sat,  5 Sep 2026 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640269;
	bh=Z/TytDHXIdc5N78pnUKbJpTNvxp4fhYRli76ARDYJ8Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iu3iIHVQ/f5DKFt8VnqHXLt4+VHJ0nurwcJ0xY5/V43GO9gRkzeFu1otaGgZ7SjVM
	 9RtZT4KaohSt3K3Zpn5CPnLnbNk8s8ugky9j5M3oU6bWU5/GqF+62kujavnQGYl1Xj
	 kZa+M7OWvbep/T2x8ktdG8/NDgNoYbBJb6XO4Agmnct9qI75HsdxG9njZyvZ/seNiF
	 uzP3vjy8LuzfMClIVyTeLqs/RtplCQEYd4VtoOAa7s1BKZspfj1CJc1kVjMTl3nXJ/
	 2jWiADoWCvQ/Wbtwhlq1ViezgNZf0XFZEH0g6mHFtvPcStg/AQEULpDjjw6n+ffhvz
	 Oy/ZcniU+9qLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A073924FED;
	Sat,  5 Sep 2026 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: E-Switch,
 prevent mc_list repopulation during vport disable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178864020915.1345393.18226763979280316717.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:30:09 +0000
References: <20260902193854.3669035-1-tariqt@nvidia.com>
In-Reply-To: <20260902193854.3669035-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, gal@nvidia.com, lkayal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, maord@nvidia.com,
 mbloch@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:38:54 +0300 you wrote:
> From: Lama Kayal <lkayal@nvidia.com>
> 
> In mlx5_esw_vport_disable(), move esw_apply_vport_rx_mode() ahead
> of esw_vport_change_handle_locked() so vport->allmulti_rule is
> NULL before the change handler observes it.
> 
> During FW-fatal recovery the disable runs while dev->state ==
> INTERNAL_ERROR. The promisc query inside esw_update_vport_rx_mode()
> fails and returns early, leaving vport->allmulti_rule intact, so
> esw_update_vport_mc_promisc() runs and adds MLX5_ACTION_ADD entries
> to vport->mc_list whose flow rules are then installed in the FDB
> by esw_add_mc_addr(). esw_destroy_legacy_table() tears down the
> FDB with those refs still held, corrupting the sub-tree and
> leaving dangling flow_rule pointers in vport->mc_list.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: E-Switch, prevent mc_list repopulation during vport disable
    https://git.kernel.org/netdev/net/c/c0c6f4ba8a37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


