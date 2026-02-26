Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941132D4805;
	Thu, 26 Feb 2026 10:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772100637; cv=none; b=iDvkJ1/+72uJPht+bDjsaj23pm4jJTn7FKA96GLa3YNZ36f8apUSdJTHZqjgE44wKIRDcs7yU/9xFWDriwxm2V/KF9XaFftaVP3G6Q6i6vgRlNtJFnbXVzB77dcP9L+EwYNJrDjySFuSkOjIYG0cR2Yw+mvli2WIKCity2nuZ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772100637; c=relaxed/simple;
	bh=OOec1l6d7yBEUrYf/oSgYiUEniykn/mgb4ahxOg/szs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cxEEQ3I/s04WzDjfLuEFwJykU6NF3xSrynleTPXyJuZF+K7+oJILO0CArYoo/IlPg0wwexvhrel2efbHl2NsPUO59swribiaxYcEoHmGKunsojFx3FkE1x+WFvbt65/PZeZyvzLFqz46pMgPjNlOj8LeWTsbQ9WjR6uNb5iKtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMF7jBr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMF7jBr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CECC19422;
	Thu, 26 Feb 2026 10:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100637;
	bh=OOec1l6d7yBEUrYf/oSgYiUEniykn/mgb4ahxOg/szs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AMF7jBr1UkOwE6dRa2ScYMTYyqPVb8+m5YauzlxMdJDk+ijLGVyAMzt94ORCKKWm3
	 7d1Ge7ADqEJO/7qaACUyIe8owYexdpRVF5C2fX8N9VqC/0Soa5hsHjh6mm+XhHfkbX
	 VGfd3oEGK0PnofDltaNTPaQY7/VuyYvihNqnRPOdSXuM9oJno8h8uM+y+sH6Pap3PN
	 NNIxPxjaCam5g/63tn1FwAxXSqFtp3XHpOaOaOjwCpwUori+AJdmAivu+jtyfvPPSK
	 /xSDhtt4+4sN7KvBOwFEUN5vyWdlp8Or5KboHOLd38A+5B+p86Ds41Q1e/66bPmuIf
	 /F4TyGWxylTKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DE2380A977;
	Thu, 26 Feb 2026 10:10:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net/mlx5e: SHAMPO,
 Allow high order pages in zerocopy mode
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177210064179.1142974.16555075271250106665.git-patchwork-notify@kernel.org>
Date: Thu, 26 Feb 2026 10:10:41 +0000
References: <20260223204155.1783580-1-tariqt@nvidia.com>
In-Reply-To: <20260223204155.1783580-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, richardcochran@gmail.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, gal@nvidia.com,
 dtatulea@nvidia.com, cratiu@nvidia.com, asml.silence@gmail.com,
 dw@davidwei.uk

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 23 Feb 2026 22:41:40 +0200 you wrote:
> Hi,
> 
> This series adds support for high order pages when io_uring/devmem
> zero copy is used.
> 
> See detailed description by Dragos below.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Make mlx5e_rq_param naming consistent
    https://git.kernel.org/netdev/net-next/c/376cf4227401
  - [net-next,02/15] net/mlx5e: Extract striding rq param calculation in function
    https://git.kernel.org/netdev/net-next/c/d3a99b71a29c
  - [net-next,03/15] net/mlx5e: Extract max_xsk_wqebbs into its own function
    https://git.kernel.org/netdev/net-next/c/a2ff2f5f808f
  - [net-next,04/15] net/mlx5e: Expose and rename xsk channel parameter function
    https://git.kernel.org/netdev/net-next/c/ba4f39c256f5
  - [net-next,05/15] net/mlx5e: Alloc xsk channel param out of mlx5e_open_xsk()
    https://git.kernel.org/netdev/net-next/c/8a96b9144f18
  - [net-next,06/15] net/mlx5e: Move xsk param into new option container struct
    https://git.kernel.org/netdev/net-next/c/099efb294e0a
  - [net-next,07/15] net/mlx5e: Drop unused channel parameters
    https://git.kernel.org/netdev/net-next/c/3707a73854c1
  - [net-next,08/15] net/mlx5e: SHAMPO, Always calculate page size
    https://git.kernel.org/netdev/net-next/c/dff1c3164a69
  - [net-next,09/15] net/mlx5e: Set page_pool order based on calculated page_shift
    https://git.kernel.org/netdev/net-next/c/3a145cf492a3
  - [net-next,10/15] net/mlx5e: Alloc rq drop page based on calculated page_shift
    https://git.kernel.org/netdev/net-next/c/0285cc3dac1b
  - [net-next,11/15] net/mlx5e: RX, Make page frag bias more robust
    https://git.kernel.org/netdev/net-next/c/8611660778bf
  - [net-next,12/15] net/mlx5e: Add queue config ops for page size
    https://git.kernel.org/netdev/net-next/c/0fa8c9335760
  - [net-next,13/15] net/mlx5e: Pass netdev queue config to param calculations
    https://git.kernel.org/netdev/net-next/c/585cfa99d357
  - [net-next,14/15] net/mlx5e: Add param helper to calculate max page size
    https://git.kernel.org/netdev/net-next/c/5b6e0ddb3686
  - [net-next,15/15] net/mlx5e: SHAMPO, Allow high order pages in zerocopy mode
    https://git.kernel.org/netdev/net-next/c/df5135fced85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


