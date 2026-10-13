Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18FA51DAEB;
	Tue, 13 Oct 2026 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898207; cv=none; b=bs52rcMK6q7JE4klDMuyFWgt+794mYy6gzAHkEgbF9zdUpwckS4QJV4BCWwVTbk101C+VDQm4ah+MDBc5kROf9uktaUZ/f2v/dCIy3Bfp9kEOX3I/aJQWyOoKHTzd1CwmktBf9wfQwCWTyW3z6W+KtsKvrCX/6KrquxKRYnnpOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898207; c=relaxed/simple;
	bh=0OIxrzTH0lutXZr3elVg7t9/XANGWnxswvdHOUoI6No=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BhqEF1Qt5cUHOLH2djSNmxNPngDQAByzXXZESmcLPMcMAT0XNak2lu7MQy8aAQ2h4QXxQ9ygqbPCqSs0bXKFcbg3DyMERRlnTID/Vi54xHpwLJEepWUHoE4pvbmDlMUwFClLZtLTQJ+hxEb9ANkfiUAj8CWUfrVGjR8YbSC9p8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+UBSIaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+UBSIaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846DF1F000FF;
	Tue, 13 Oct 2026 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791898206;
	bh=HIwIHVH6V+wHDsnwX1/VeaTTnJXy7gnmijLG/MwJ4Wc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=m+UBSIaEwY2leLhwG3n1FqrEGm1zmkdivOsrphs9U8dzYBXZrlm0Q3CPUyK0P0EFj
	 gzYsmJqHWKw3jAYOOKXngSr2F4D+yArGwR1vXbN0Ga+2IYqkPAkYfpdNLFF1n5THcx
	 B6YUy1h2J8ZatBBWn0uwrs54l1Nx0uIYxQdou1kZuXJuyQ5P6A10/cVoDgU/OhvkKI
	 eQC/Lxij25ll0BgJ3GtAp3MKTSqgp44K3IE0HZtQ2jQX6V7uKCCYGIlRzcVV25ZTOp
	 ZB+0vMiQrjMDEHv7SdcnMwGnYOMQSuqutlbe0RdnEZa2ImTn4onDiBpK8iPXuM/H3Z
	 VB8xlWXmH5uJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775E53927077;
	Tue, 13 Oct 2026 13:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/mlx5: HWS,
 fix reformat release and meter offset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179189820527.305184.15761518876278213999.git-patchwork-notify@kernel.org>
Date: Tue, 13 Oct 2026 13:30:05 +0000
References: <20261007143830.1733583-1-acassen@corp.free.fr>
In-Reply-To: <20261007143830.1733583-1-acassen@corp.free.fr>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  7 Oct 2026 16:38:21 +0200 you wrote:
> This series fixes two issues in fs_hws found while offloading one tc
> rule with its own encap and meter:
> 
> - Releases L2 to L3 tunnel reformats to the pool they come from.
> - Makes a rule select its flow meter within the whole ASO bulk.
> 
> Alexandre
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
    https://git.kernel.org/netdev/net/c/39e02ddf74bb
  - [net,2/2] net/mlx5: HWS, fix flow meter offset within its bulk
    https://git.kernel.org/netdev/net/c/1b0aad53ad71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


