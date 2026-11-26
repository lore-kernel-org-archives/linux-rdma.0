Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795690806;
	b=K2ZUNbxe0pJG+h6B/0fa24pbFUeRV87mYz742asD0CkSbw7f0I0dgbH85QjuaXFNN677
	 QuxOvVs6VddelgVdZBJ/h8mjpbffg84RtufrYOo8ZCWcHagESoXQ+Z3xZ4NTIO3mpon8c
	 TjKRUOstfJuoTU+RfJ4BFo+Lm1S0OwlLzJ2GdytySaWH7hXmSQuJC1NCEnlf9oHQwrRk/
	 GNesC0X+U4lyP/R6k8KUEuvj4HBDMphps0KaduC0GKPJCHzMKKkL/4k5UUn/Uh5sVWIu8
	 ZK8UyhcOrLzRmY3I4M63iU8b6SHlP+TdvFe5a24SL+wdUyq1a+SzzYuuEa9LkmXlWeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795690806;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=P7WOki1fLGaeak+JkWZkty6grxAVOxRWnTkGYsL2nic=;
	b=raP0TcboIQ+Yb2bvLtFMgYBl0C4vCtyDc1ahXQE8J3X9UNiXQFNjvMjTrJjeGvcmjFiL
	 4xTmY4y0OU9QWs7VZLkKzwT/F4CTO1udtYgmXNCIFjEWn0IhONucIsgYWjogwS1kJihJE
	 q10qI8jb7J7Xua8mq+V0l7ZOxw0HxSCZ0yk/ReGEUCzzdprll9r9qHCJFc0vad8VAaWio
	 FDlxux/xwvZgi2WZ8CzjAJwKoPJTLR0Hxw2uqejtaUwyj+eM3aBHBJchiK7yUGn4bOVt7
	 DzrcNheYdV4IfVpDyN/fHvCCsFTEu7AfWVNVnQz5qS5+lp/9zesk6b1dIWfVsAvYYYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNCyUWAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC80606A31C;
	Thu, 26 Nov 2026 11:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNCyUWAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFFC1F000C4;
	Thu, 26 Nov 2026 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795690806;
	bh=P7WOki1fLGaeak+JkWZkty6grxAVOxRWnTkGYsL2nic=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iNCyUWAd6qCIjsPqslDn6/s9o6z2VtFp0bOoKPNiNtRFZWPOLos86S9v2XXnTFQpF
	 5n4dNFGSUflQd40OfmCWBPhMj0a1XTfJQhS/aPfjYQxQnGo0nLRhPHCAgz1SCkE7oz
	 IYzkCSotkTgoD3AzdmT/YRswEIb1OyEc54ePug9tQW6eZBs4WTs/IC2HfrDpMK9THj
	 m6p0yhBvLkt1RzlOz/Y1vDDxYygx7SIGeacUhOGs0ICwLL3C2fB+HoXXyuEgylKLjF
	 JXzxamX/uAcOR7dIP8VWS1pVUThU6ehreYPhsJ2qNZcfXq7JVcL9nVwX2pygKo+0H2
	 2F+ZQOgE6P7Eg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3F2380A962;
	Thu, 26 Nov 2026 11:00:06 +0000 (UTC)
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
Subject: Re: [PATCH net v2] net/mlx5e: IPsec,
 Fix RX mapped ID leak when adding a rule fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179569080477.1746679.10791522789512013648.git-patchwork-notify@kernel.org>
Date: Thu, 26 Nov 2026 11:00:04 +0000
References: <20261120025501.1675212-1-lcy8047@gmail.com>
In-Reply-To: <20261120025501.1675212-1-lcy8047@gmail.com>
To: Changyul Lee <lcy8047@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, borisp@nvidia.com, jianbol@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 19 Nov 2026 21:55:01 -0500 you wrote:
> In switchdev mode, rx_add_rule() calls
> mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
> the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
> frees the modify header but leaves the ID in the XArray, and
> mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
> packet offload SA leaks one of the 2047 IDs. Once they are used up, no
> new inbound SA can be offloaded until the IPsec context is cleaned up.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: IPsec, Fix RX mapped ID leak when adding a rule fails
    https://git.kernel.org/netdev/net-next/c/a6e391baedf3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


