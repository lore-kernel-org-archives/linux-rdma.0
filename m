Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794970212;
	b=eUN6O7tLFHs42v3+Tw32WtMnAIfPZcEGbRg0i/oXTwqC1Q5jPYeY4uJmwOP0LxM8isUP
	 +DmzlErkT7OxqTDCldgAVkCDSg215WvZ1CM9gPbkY5NlSejlXuyCHfP1GJ6Q/7VQFhA9w
	 oTAHDeC6BK6shv5hRZaAoFAV2KDBD3fbeaX3swBMx+U8/IS+/mkbYUjZh/b3wcM6jgIQs
	 E6LP4hu+tx4OdWtE8va/NwoIN5wfIPDcNdHkwYLFy6bwQk3IeXHAP0kyuBiisJeLwWJ4a
	 c1EK5+5yu4ortIAF4sCJYwsi0fOr/nMFjDjGQnMRDWEbrFnXC5+JQs60mUGy5WAEEHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794970212;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=tbCnf2CdLlNVulpjS0KApyUbQiUtzgwHBEFdOPcFhp8=;
	b=iYT+N/n26X7ZcU7dYNTH29+Po5d5nmmruocfSDFz1siG/P1/SAbYQka3vUzD+U/12pP/
	 nQ9AqCHkSbGTbmB8CCBSgQX/tylUgo7iDDMI+QxJ8yPb/J1WuovsPW7wh0GoNHNZH4SLl
	 xBrwsctTw688bxw9E174yIslvE4DM6DhRkSaKPjNbzfhVg0UEqS41vFa2Qwk40YqZ5ob9
	 FEJYT4AK/WPbFr1fDvDEdVeOb9zdQsORBVZ8ykGdTLflILvE7fgwh9HOVo4cH4b9Qy0Cc
	 BaEGpumvwUsNQKaEJ7IBiy/wJsn6WeVbDEDfDFZ4urT4LthSxm/nKESH5297Mio8wFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkabkAO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F098D606A33D;
	Wed, 18 Nov 2026 02:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkabkAO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803EB1F000CC;
	Wed, 18 Nov 2026 02:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794970211;
	bh=tbCnf2CdLlNVulpjS0KApyUbQiUtzgwHBEFdOPcFhp8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TkabkAO3wec5U6wzkHhwX0oISBYq7OFAuMYDvZNaRNa5b6haen7ON+nsGjxws9eHB
	 jZ8g+fSXgB6X5I1RU/m/sB3vcYXZclP8mULwR4XR/46yYujCuSkyme+cqtWgurlLtU
	 gL/SuSKxKMfrnvzPZ1y1RZUmOQq24bWQUIXjNIpUUgXHUYYVGcjwrkPXp7aQwC6G6V
	 OVPoYEEfX6fY2WLz1ixzSAHQLzfU/i1ljTUTTcDzBgE2iPe5GV555ADtVM0AFAdQFz
	 9COn6ecNg+8sCd8b1guxMM/qxSro7SZWboeMKYroArLXThKlbnER0oUeZAzsB7CvwQ
	 xuAGqaAfUEprA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77402392B1FF;
	Wed, 18 Nov 2026 02:50:11 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Fix XSK pool corruption when switching
 channels
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179497021002.1430642.9809813861373019082.git-patchwork-notify@kernel.org>
Date: Wed, 18 Nov 2026 02:50:10 +0000
References: <20261115072934.353341-1-tariqt@nvidia.com>
In-Reply-To: <20261115072934.353341-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cjubran@nvidia.com, daniel@iogearbox.net,
 gal@nvidia.com, hawk@kernel.org, john.fastabend@gmail.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 noren@nvidia.com, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 15 Nov 2026 09:29:34 +0200 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> When the device supports tis_tir_td_order, mlx5e_safe_switch_params()
> closes the old channels only after the new ones are activated.  With an
> AF_XDP socket bound, the old and the new channel hold an XSK RQ on the
> same pool.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix XSK pool corruption when switching channels
    https://git.kernel.org/netdev/net/c/ff1ee9cc8993

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


