Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045805;
	b=hsUebw4qWkmqag/e946P5pgMvUf5d01YQNzwy1ry5JEJc0rcS0dOwcl64cORFq5yXcec
	 HEKTGuIwvZ4Vi2Dr3HWHh0R7Gijf9cumLfxPlpMWUTV1N9i0KSZ3wtPzFqsLkqCkyPpjK
	 0pnIKd6nBn2t6jXXUmawIWJqq6P2IINc4D46lVjwfFogJuiiR6LG1jlqJBS7EiRnDonsX
	 UZyy2iialR5zXPoNKxb0qZtdkjQGjRHB1ib2cHLNmnsMqyfY4nl78zB4L95y7lKBX1noT
	 TopGJ0Zej10J8eL4szcTvoiVHQiAmM9QREP6A0ZORzm3cqPjdum++Oh6NusOMaYNs8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045805;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=oJOFhz1pCpUgpYgypKdG2orjy9gPvBXNHNe+8O6151I=;
	b=3ZHHbcw1/+sQvg1AWwXON6iAGg1KaCqMRf++SdEBroVSbcHMtAuhaRGtH3hL8IhcC7t5
	 Dx9Z1YsflpQYjxnxkB1IkDCz3AP8gM3/EwLQYkFEgMBboUJQF/W0P0yp1GgEpE5VfbZmu
	 6ANPC7NaDqXZEduHGo9MffTVtM7wCCQfjbPA26sErboLwB3kG+qogFn2erq67vnsRJEhB
	 08UT5Fkq+s3T9qjdH9+ACRkq3ToYfw2DyoDsufh9YzDEIU/zulTTeAJMbZBZajU7SomNJ
	 /P/ewVnIRts/2FYNh7nqCl5pzD1MXMgFab6F0e0QJi1TW4/yNr5beTi6phP0x3vcUjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GyK/+mzi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6F606A325;
	Wed, 18 Nov 2026 23:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyK/+mzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800E61F000C4;
	Wed, 18 Nov 2026 23:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795045805;
	bh=oJOFhz1pCpUgpYgypKdG2orjy9gPvBXNHNe+8O6151I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=GyK/+mziuBGZPKhrL7mj1hYkE5nElViBmqmG07hgjp7/L2EDCGFqtZEAI6z3YyQ3P
	 w1EfM21LWD7rdaOa3kLsqhMBeby9gDtRTtTtZq9a3tlXUOryOxNHLkYfeBeS+dA80W
	 /YuJBbAbw5uGDMOyiwA4dNl9Nimn9CmQ93P0lr+B1K3TjD4Vwea4X2gjnhEb/ujTxu
	 XNULxnZQqwUyFEUEXWPf6hjOOyXRWspojJPe15i/Tes1OjRVJiuj0mbk7xX3HE0dwv
	 hWW7rJCi/XFDsVLotQaIDrcjapaimj0KDnOyaT2J7nPeG4QnVlcAppGVuzqEsZ3wAM
	 QCUQAfd2zGbWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7735B3808210;
	Wed, 18 Nov 2026 23:50:05 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Hold sync_lock while resetting VXLAN ports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179504580428.2624320.5569351185904692837.git-patchwork-notify@kernel.org>
Date: Wed, 18 Nov 2026 23:50:04 +0000
References: <20261113040323.2090829-1-lcy8047@gmail.com>
In-Reply-To: <20261113040323.2090829-1-lcy8047@gmail.com>
To: Changyul Lee <lcy8047@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, ayal@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Nov 2026 23:03:23 -0500 you wrote:
> mlx5_vxlan_reset_to_default() walks vxlan->htable without sync_lock
> and calls mlx5_vxlan_del_port() for each user port. mlx5e_nic_disable()
> and mlx5e_uplink_rep_disable() call it after rtnl_unlock(), so the
> udp_tunnel_nic work can run mlx5e_vxlan_unset_port() at the same time.
> If that removes and frees the entry saved as the next one in
> hash_for_each_safe(), the walk then reads freed memory.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Hold sync_lock while resetting VXLAN ports
    https://git.kernel.org/netdev/net/c/d61480a622be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


