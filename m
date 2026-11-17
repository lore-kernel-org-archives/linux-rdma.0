Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794928807;
	b=wZtzaN3Hz+ceQ1iKpspW3j99vHWDLEw+1x0x+hW4Pm5AbQ4yqKqX4GZWrD0RUg/jeeV0
	 FU4QjLUgPWoAQZojI13Xb2llfHK1xSvxEL4BYfLOW/Q98NKr+Z8pqadi6rclLqD7GKrE1
	 niRpS+7J1K+8HUcckY3PKUS9ON7cojv0xwee0FE0VDcFeaq3TVHBuQMiMnOre7FzqUwMQ
	 g1zIFtrbQCNKDKH9Sk1QnkiL8hIgzZRziPcta20MUrdgHsedW9h45kVx8vdsVSLWJAtJQ
	 v7VzTU7axO8xHk0Kj6c4Y/c5lBKH6DSH7VYd7EVeFIaI+1bBGDhN/eH51/M6tfFY0LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794928807;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=PkIFmFtwbAtscvXm7vxYpdbkMg7D4KGy35orKtrMaio=;
	b=GUJgfal/BJQ8iiN/KvK5+/NTlpxVf4tcwNTmM+U7vih5g/PzukkkDJEPditA0Cj7luBb
	 7FWu1mfp/YltirNdZGG2kecyEYZcRxLA6EPGY7FJkjT2yIeMJM/EnMcFuOVn/NQpu6vaQ
	 T332Vl2FLZ4QhIFBKbZ52Pjca4NfMlGPcrkjSzzpATwjDn+BJLUeQgs2YMz+eyMHnRjiF
	 T7jU+HP7Dva1ymeHZQzltSAn30U6qHajBGKa2Zdt8W9NJWxrDKH91uxYadDXOcNi8V8Of
	 KmllDO/BYW+Pa8e+iPWtbtINmubYdU6qOIRCUqVLAjUC5BY0eMGvd4cWmbO/YMeby2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pj7UCWr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E881606A883;
	Tue, 17 Nov 2026 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pj7UCWr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072C21F000C5;
	Tue, 17 Nov 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794928807;
	bh=PkIFmFtwbAtscvXm7vxYpdbkMg7D4KGy35orKtrMaio=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Pj7UCWr9KAlzoDzlHno3oeDebGjaWoV8m9NmEnzzFB9TKXWRXrqk3FHj0rCnthdHr
	 ViMzg+2PxPfXVm88Il1xCgB8EZzrkk7zNNZod18rlLLefZ+oxHaNabyoV6vfPqISfi
	 020Aj8eV6JLx6CVuxPeJ8xQRM5BsTiOsPYvDadfc94fotZ4WYxIkDZoA/FTAB5px/z
	 ckajyEDQ3m973eYF8YFqZvEK3FNxU6sL3eSa4l2paN8gm3rRMdVzPkSBb7zZfN0wwz
	 UFlpM+mis/sGF5YRiE7Nyg6tpONgct0EilQWnk2HW8KhIba5P7YnaEpNVu1FSywEGx
	 iT5UGK74Mdt9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F1586392705E;
	Tue, 17 Nov 2026 15:20:06 +0000 (UTC)
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
Subject: Re: [PATCH net V2] net/mlx5e: rep,
 Fix races between devcom PAIR event and uplink close
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179492880552.651948.8613852135284978672.git-patchwork-notify@kernel.org>
Date: Tue, 17 Nov 2026 15:20:05 +0000
References: <20261112182403.3646298-1-tariqt@nvidia.com>
In-Reply-To: <20261112182403.3646298-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, markzhang@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 12 Nov 2026 20:24:03 +0200 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> mlx5e_sqs2vport_stop() frees each rep_sq and its per-peer send-to-vport
> rules (rep_sq->sq_peer) while holding only the uplink's priv->state_lock
> (it runs from the ndo_stop -> mlx5e_deactivate_priv_channels ->
> mlx5e_rep_deactivate_channels path).
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
    https://git.kernel.org/netdev/net/c/5e9b2ad9b838

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


