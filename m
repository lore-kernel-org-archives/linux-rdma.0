Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793997619;
	b=yrln11jG+3NfdudLLeaeU9IzzJOMhOYiFjMzxt5+s6HCwhEIWD2bN2BSK5xknR07frOM
	 Stpi5ioPc/dZ5OrYqe2R6kJs36GjKB+R3ijC0Ckevo0VZkFnrlIs6rD3O8BX8GcrSg7L3
	 3pWzQaHFSED+E130nsdw3NXK3DkjF0NcgK/tYtlXsztRgEJ/2BtsRCWmC4cRDBTSIg80H
	 jq5boRPL4MckcHBs1VX6/zMLM/CcELwYFtZCMZVZ21Q3VobnsU9E/vxrmGbyxB7D53ToO
	 hOfsksor941emokf1Nj1gtWK9FzeqKGW/7VrbyHtsuULv5VqvBq/Mr8vbe4VarXMphw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793997619;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=9JGXQWOdZTpjpg7isLPEgUXEisp9QAVDWGiK0jmFxb8=;
	b=EnRMWXR4hRLR6S5A6j0r81pIO6QIlhDD6xXRxGSALIiOqRnrSe3MiGD3p4abxJfdNhdY
	 8H0EuoBZFZwi59DMQLn9iH5adzxzW/51Mgtbt/foX5ALV4xpDM2Xvz8zH29tJjO4HBiiv
	 Qfk6J/KAk/EX+cexJi9yfvzjDLu+KCZqbSs9o0FLeaITJsKRHeHELadiW0c8fi7wfQlMd
	 W8fklIByGJZQe9viHzAEFIjaFdRXvErAGmuAg8thmjsiQWTfM2oXz2vkvl6pF9HfJ6WMx
	 uglyoLsWRYwc0COwXzrZ+RJ3DampH7sPC2FOncaZc8z2DwizGQr6IIvZjYA+jFzstMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HMsxMf/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE7F606A332;
	Fri,  6 Nov 2026 20:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HMsxMf/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452041F0089F;
	Fri,  6 Nov 2026 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997619;
	bh=9JGXQWOdZTpjpg7isLPEgUXEisp9QAVDWGiK0jmFxb8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=HMsxMf/76WqOIXbIKkpw4MKq1u6/NLXV9UG7hplvuaGPln0LOEtXG/RwqrjuaAWB2
	 YeNz6ihGPM5KIHmcb84htYfmM14Go0JgcVG2xGxsiMxTNPaqB55jyrPFfVGGxABGYK
	 y7nYOMoLQEdIwFfCbxvrJLaUcrUlaAjmAvtWMJjO13l+LOh0a/SzNIavDqNWIHlJry
	 basZXQXv0lhTdAjZzR5kWDHfLBHMhVKY+KbLxGjUNm5aBQcjKlXrF4cSglfFXYCCvp
	 qt597okWuRwvV0jabii/1XCwb/XQ4aHvwYTffcO8/bsMRWWmSpIGiimr9AOw2RZej1
	 qW9Xj1ZFbKlig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BDFC3A5499A;
	Fri,  6 Nov 2026 20:40:19 +0000 (UTC)
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
Subject: Re: [PATCH net v2] net/mlx5e: IPOIB, Fix QPN lookup race
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179399761792.859444.16113939657791512927.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 20:40:17 +0000
References: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
In-Reply-To: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, dtatulea@nvidia.com, cjubran@nvidia.com,
 cratiu@nvidia.com, erezsh@mellanox.com, valex@mellanox.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 31 Oct 2026 22:57:13 +0000 you wrote:
> The parent RX completion path can load a QPN hash entry before
> mlx5i_pkey_del_qpn() unlinks and frees it, then dereference freed memory.
> 
> Use RCU hlist operations and defer freeing with kfree_rcu(). The existing
> RCU read-side section in mlx5e_napi_poll() covers the lookup. Keep ht_lock
> for writers and acquire it before looking up the entry to delete.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: IPOIB, Fix QPN lookup race
    https://git.kernel.org/netdev/net/c/29066b0fc046

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


