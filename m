Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266806;
	b=xolOurC1bpQ87Wz6Wob+lXugiIYGsBp/HBzItw7NfrG24Nz+NIAt9usI/0LPTFkSHH7H
	 t1wyILpCT1B8DehaSWniZFGm6OBFrQb4yyQP3MsBcBtZZwWYEUoj91c8pzZETSwBIDfgu
	 qRgdsXfoOjtgbWhmiHFqSXQm/3lXlU9oHriyj1i3Cg35jNMNjt318pMqxs9/7J6H0yhI0
	 2uc3WsjscrbB8BQFVSNN6FHt3peAMi7DhkuE8JdZVm104S2QzykIrRH5EoRkNhcgrw2fb
	 7Iefd4kXeB1b3XfTjpoUtvmd6aO6xTlgFhH8Gt6IHZI94sLDk56HVYBxN5paQ+n+3bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266806;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=3eAv1cEdy32yYM8r6enZ9YmdYV3ELmvkNNHj5rXV/6E=;
	b=lE/Es+WCKkknrEysTJp3TXkfcyJ3fQie00X6mZH8pze5p1jWzNoXhsEaBrQpvVpKCi6Y
	 o+feT4BMQ7nzoat6oirPhxHXDh/TkvBA/t5nI3X24R1C/2QUUhzgpZ2Kd3+b89n5GIXE7
	 nxIUK9fzmFOQoNKNMWeOUDDvoHCXdd+CSFo+wI2634z6Q1bRLwoF+6Q9uWCEgZq0VyoVm
	 /sEBMaDNfq6GYELJCwsCsmaS2i5GYb/Wch7aoqWn0BjDUfxzXj9EAHSOvk4lalZD/KaaF
	 kDB3/eZ+oBekrl67HOJoNU4CSVpMVQGdxYKoeNvxJfIbBSpSoNXoxxABVTEVkFG8nZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dm7HLKwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A006606A31A;
	Thu, 29 Oct 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dm7HLKwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC151F01825;
	Thu, 29 Oct 2026 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793266806;
	bh=3eAv1cEdy32yYM8r6enZ9YmdYV3ELmvkNNHj5rXV/6E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dm7HLKwg3D6IephB+SDq+QcVxikrdJnWMIWS+JbRTSfoXSm860P4BjEIV0JVvVOwM
	 hMua5vxWMBRQ2z+ydxHwYjgQL99fvyC4hBd4NI50tycIQ7xhTKYe6HrOa/t9xzgSkm
	 I5wXVVXF5oA2CZCxlGgklYcp2P8fQBm/LhxRMZpHM/aCYOvVJLk93MjJjEOfqmJ+uQ
	 w8M4wKsVx1ZZKEsT02gx0M4mcghRhXlvIWG8JqFg4pyHYuPXnbYTUupO4xVE51uCLt
	 xQKngvQ9CXk0j2Y2bbx9w3VcTRI2r99ssB9QH05gliWALYjbbgB7MfXU2aAf6dJvDr
	 S3d8w462QemUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 073963AB1399;
	Thu, 29 Oct 2026 09:40:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: Only set num_doorbells on a fully
 initialized
 SF
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179326680482.1714515.15230223868854423149.git-patchwork-notify@kernel.org>
Date: Thu, 29 Oct 2026 09:40:04 +0000
References: <20261026084503.4122732-1-tariqt@nvidia.com>
In-Reply-To: <20261026084503.4122732-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 26 Oct 2026 10:45:03 +0200 you wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> The validation for the num_doorbells devlink param rejects values
> greater than num_channels. For lightweight SFs, this ends up accessing
> a NULL priv->eq_table, leading to a crash.
> 
> Fix that by rejecting setting num_doorbells on uninitialized SFs.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Only set num_doorbells on a fully initialized SF
    https://git.kernel.org/netdev/net/c/fa503935c2d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


