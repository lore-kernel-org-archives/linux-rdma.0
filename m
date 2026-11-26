Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795690207;
	b=CdLYsr2vgyeznZHHwBVH/+s7H7JtFTxuStEa0QawsVzAcd9YCD1Ds1JD+tApFvWu3GLn
	 ya3noddYaKTAyoBp+uXLqf6yji9IJ7XUwfNROYtZ6yWA7pfTRouEY47kzP6An2I9d6QkY
	 rUDu6dZC1mnKwkMs/hVzkCUA824JDVAT/vwhjQsAN50pOVifstgCgp0aof3hedQHVKzEO
	 Vo1Sb0tZDWILzQhQVclKmphUvHwkVSzgadBrIey0gYwz9xgWZJ5QOT10TMgJiR7lK53uk
	 cCH6IWpd9jbgKhnQA8k+QzmxQXLENoaSvz8covz3OTHKuxnsFwaUfTroHFVNmWc1qoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795690207;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=RAGDpCNfxKiB8/M15XUf+EmRm7rjiAlqeMsjC2/ZhGU=;
	b=o3ySth7IyM2xlqbZaqf8lY72OU2gPysoPJ7xJOf6oO3amM2PcbfcDiuMk8sTogSRl491
	 cd90EErBDEB49A2V2Bwhx1+eFRiajcfFrrdrLQmpMsGmDxd1otTJovjCIr860humbgs8T
	 rb3egKtko48DCdMe1XPZdQfj2l9MOoU0ekfbpuy1Ho+8JaNKJQFxChqKRYM1b4SCgw7Md
	 TjIrHFW8CSforsXeB/XHN8wgmAhhyMBOE+cRBdfvSCTwoudgTeF6ooTQBVZnRe3TnpUWH
	 LWjnAzxsXn4CdLNwDdXCs9Va404baDM/XxFTIQNGv5izwqSFCt8PgweeFFFc/iXNo6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJSMECBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5459F606A31C;
	Thu, 26 Nov 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJSMECBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7431F000EF;
	Thu, 26 Nov 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795690206;
	bh=RAGDpCNfxKiB8/M15XUf+EmRm7rjiAlqeMsjC2/ZhGU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mJSMECBZaRI3nTi1NWZDIB5UyRPSdPXhfi073W7qdz/utvwibOP7AmRpT4gD4W9v1
	 MtMQmP3UtyRdwiWl2nGZGKoOE5gpzrt2Za4iGzHWKUvmLvli80cYDRZICHOshrpU7v
	 fHFLyIv5UtO3sCckf+876CUH4mbFxPCtkU8SwHY5EVXJd2EVgVhfUyLB+7hyjn2BGV
	 FgCib0ABXQQUT4l8v+1d44Al3M1OY8bZANa9D19rn0EZFdNm08PsCqElPoZMPm32kS
	 6aYGynoGbNJ37AIEu/4H0tqCtxg30ZoUCN6Nsp61ZAV/kdmLPDbPhkE/SBN25kGwBO
	 I0bZKNUqZH4UQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B4643380A95A;
	Thu, 26 Nov 2026 10:50:06 +0000 (UTC)
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
Subject: Re: [PATCH net v2] net/mlx5e: Skip hairpin entries not ready in
 debugfs
 dump
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179569020553.1743253.12065164933418041046.git-patchwork-notify@kernel.org>
Date: Thu, 26 Nov 2026 10:50:05 +0000
References: <20261120021557.1630138-1-lcy8047@gmail.com>
In-Reply-To: <20261120021557.1630138-1-lcy8047@gmail.com>
To: Changyul Lee <lcy8047@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, gal@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 19 Nov 2026 21:15:57 -0500 you wrote:
> mlx5e_hairpin_flow_add() adds a new hairpin entry to hairpin_tbl and
> drops hairpin_tbl_lock before creating the hairpin, and sets hpe->hp
> only after mlx5e_hairpin_create() returns. Other users of the entry wait
> for res_ready, but debugfs_hairpin_table_dump_show() does not, so
> reading hairpin_table_dump in that window dereferences a NULL hpe->hp,
> or an ERR_PTR when the creation fails.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: Skip hairpin entries not ready in debugfs dump
    https://git.kernel.org/netdev/net-next/c/65413721880b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


