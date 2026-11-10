Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279293;
	b=Uu6y/Vqu4I0+2y8jxCKvCa9VcnAlVnpPSlSiAsozXd83IXZPqSpV9etIi1LuPvFHJ/k9
	 q+Z/EQZD7mnuGHEIG2clHsxpNSwc5PIlwDjfHW+8YxCtPz1E5eg9dc++JN+FENQqT+CBQ
	 3X4nyHP4LRNOf3/8V4HhkQgYEox6eg5Ar46IEKAGv3W0/rutcaaHP28U9ztcCfAnvd/Rq
	 3U2mhQ+YjaFrjAZG0QKmA4F5hBtmPgwvh2i+jlCphdtO1VR9fxhAYOjHzkmg5P0lxKRTH
	 8gagMSa1dqRzfzQd8fyuX1anEZFpFdpI5XFEQJnmt49Qke6C3M69WO9HTHV3smLm+Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279293;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=P35GSSNzzC0rRZvfy6DMvzwx7n6r2uQ1meu+ZQtPiJw=;
	b=wm8IoWNFVyM1KS0NfW40O1+Y3vQbBhWdoUI8ZY88ZFTo7RhUyyWlVvT5Mi51wlqDyD08
	 6eNvjXhVHVLylCxag8Vw6YsGeBhh5l3DTkBTEoAf2JuXIyD0Mp1+DxNjCl2j6+wJNWniv
	 8JF2IxRQ5F5fZwphyAvZpmjQ8351ktdg1QAIepfc+HDM7lIaiks2VMh+tUK9oGVyti7uH
	 IrvqtGKqYMJRbvDeJiMResnphjffMmdZKfVkACzxivCNVEEFuHFYgpAez/U8Clraa1Cgl
	 1fK9ZljSiC5y93eIAvTkpe2iDaZPNstmnCByvlkSsB/3wv5arJZdT42A2q1J/QJF84Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFpoR2YH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E153960A3838;
	Tue, 10 Nov 2026 02:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFpoR2YH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7311F008A5;
	Tue, 10 Nov 2026 02:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279292;
	bh=P35GSSNzzC0rRZvfy6DMvzwx7n6r2uQ1meu+ZQtPiJw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=QFpoR2YH2bx5ZEgzfMGcpbCOXcP0YwVlrwvDMl6NrAux0Bhomq6ASRusCtdVPqyBQ
	 aGiutVslavhD3dRGZJTeJEBlFz77TJVuXchvCNrK7DKuhuMwI6Sp0Nb+KrvCRJbDbQ
	 rLhueVRplCT1W/6OJUHndBDT3H0D8HnDnkKBsKQrvG076mzcXmkW2e7NmVlUiEuleF
	 AMbEPO5HdZWeLaw0EGFVzPZYP/sz1HFx4pHNWOZIb+VFSmMhVAXm/Tertt+/HgHEwP
	 +1Lf8rBYPd8HOJL+5vEqFX+vtLvhGIkK5PvtTdtUrMqDldvQtpTVTkrkjdV1oYbipQ
	 R4mfZBv5a0W7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B04C391AFCB;
	Tue, 10 Nov 2026 02:54:52 +0000 (UTC)
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
Subject: Re: [PATCH net V2] net/mlx5: Bridge, fix bogus MDB offload errors
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179427929117.3612825.9836725011993171044.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 02:54:51 +0000
References: <20261104183715.771390-1-tariqt@nvidia.com>
In-Reply-To: <20261104183715.771390-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, bsoares.it@gmail.com, cratiu@nvidia.com, gal@nvidia.com,
 jianbol@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, maord@nvidia.com, mbloch@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, vladbu@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Nov 2026 20:37:15 +0200 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> MDB add operations are queued on the switchdev deferred queue
> (SWITCHDEV_F_DEFER), while vlan object deletions are handled
> synchronously.
> A 'bridge vlan del' can overtake an MDB add that is still queued, and
> the vlan is already gone by the time the driver is called.
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5: Bridge, fix bogus MDB offload errors
    https://git.kernel.org/netdev/net/c/c714f324eac1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


