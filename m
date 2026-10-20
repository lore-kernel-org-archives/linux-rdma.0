Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503007;
	b=cM/+9yPwqNeVCI+c/9D7U+eoTJChJS6Z0NbspT5pTdQYGpwud4BezNOl7OvAHKSg4f4l
	 OEOtlJE1QwZ1xsS8AJ1xdjLFaLdH2r3u3cXVedKbEI/254hnteS2oDKjdMg+eLtjKYPoN
	 36f/EDI0mUfDSNSzMo86ADq5pdUvbcxhI9/g7wsopXKgCRvcSt9ezZTm4q6uFqc7Z7n4H
	 NctyN8lL/4sbBw2uzg8nKZiG7z1OCcEe0T+/8GzwD0SfoIStpLgAvpxcIQfyiU8jWjSD+
	 GXBmbE5yy0cgKwXElCQ5so5DHQfCOyDd5X1W1Lz62Jt6ND1Yp5aaF/eS7YZDekkLlxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503007;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=ciBCLFFfdynq4lsUG55fI2F6uUqgK4iiXQfZ6rBTv0I=;
	b=je1I5zb910MkebDMbfVUHFFSXFGh+LoCEsPbZ2tulq9ck1o7Iah+zQHSTgxyeQVaKIxR
	 4ZHiG6K1fNGT46dIqXiX+Id/5/FpCxmVTlnAXr0TcHE9i/4w4XAI8Dj18grif1pfITc0a
	 9PvWMALSGKyDzyGF6vN5+akUEWMJPZabtO+rP9mzdA9UAmgPvgsA7ZcXe2F6EUMTfAZj8
	 /AZhI0f4+uMPowKiWf1/tVA0d9PGvXh8h2EWSndkire3L8MLtxeiG6IVudJhuPkjxTWTD
	 HR8YcVWdo1aJXqMIVgP50tNMvb6GZVXe2gApINO1G8aLsI4lOxmn7rVwjLvmi8LBUsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcKZD1oX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093EE606A327;
	Tue, 20 Oct 2026 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcKZD1oX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C31D1F000C4;
	Tue, 20 Oct 2026 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503006;
	bh=ciBCLFFfdynq4lsUG55fI2F6uUqgK4iiXQfZ6rBTv0I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hcKZD1oXeuDLETZgVsSn5CNwUhnEW7gwaeJQRkJ9IKTkGMTSTMQuqxb6jvZFV7I8r
	 XLJEkWiqlZNYJSVtXtO+70U+4SOcnLqZ/WWN5NjGQoTlzX2UANCZ3Y0L24c9KdKZWX
	 aFegMJO6KjPTRKmB7ydHCALfnWbH/1ow+A+ZsmH15jKFmRxRLqP1rY5A9+Mp4YYrBB
	 3j57y5fn61VR5iftvw8xI7KN9OgE2CaPCn/+RWp2RO7gz+ZyjgGKAA/Wx5kMljOi++
	 OMK4mIVTGbLlKQMwaNEk7dDdBk367tCPvrPE7rN5zsw65R3la/W+mxO5JYfySc+C5z
	 7yrM9nJKa0ZlA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7769A3808209;
	Tue, 20 Oct 2026 13:30:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery
 warn
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179250300528.3738467.329098127637644607.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 13:30:05 +0000
References: <20261015080218.1102172-1-tariqt@nvidia.com>
In-Reply-To: <20261015080218.1102172-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, gal@nvidia.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 richardcochran@gmail.com, saeedm@nvidia.com, shshitrit@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 15 Oct 2026 11:02:18 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
> sq->channel. The excessive port timestamp delta recovery path
> incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
> pointer dereference. Use sq->netdev instead.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix NULL deref in PTP TX timestamp recovery warn
    https://git.kernel.org/netdev/net/c/0df412012a26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


