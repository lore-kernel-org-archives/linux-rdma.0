Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E473264C7;
	Wed,  7 Oct 2026 01:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335409; cv=none; b=ukmW8NPCb9FxJ+30J4Ibpci/7D9nBEEG6jgJl2Oj0q6WXCDlvnzEk0jF1MQSowmmdpiAen1ErJbyxFayhHWVMr1CgnRv062brilnjfjMjFr9aQzDUsz+UHH6U3RMf9HN3U/NuX6FXoJeuiAxE/9irXzwEpJVx5UMU26w5PLrhsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335409; c=relaxed/simple;
	bh=OAEFQNxpYp0vBwjfk4osj+fbFUPx3uMdif5r1LktJfM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bGjfXiSqY5PTGsOOe34pL08TKkOM0sbRekL23mpfkjOCbYkLmM8x6hnom7fvU4bu6A06ajzIH3Vr+bkYjUTgdBejOlKbpFvdF3S+tedDJK3/qNwHhYBWkRGQXBxc5B1x1Eg38ZQeT6yL9U2QqoRjeS9l2fqM6RiMC7pvPEY8IQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXc2bLTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXc2bLTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B121F0089B;
	Wed,  7 Oct 2026 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335408;
	bh=VG+QoYiVuJKX4vmCyHOLe8C3D2f+QXqLOLKFg7cCqjY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=eXc2bLTs51+7brJ59EnxB46+eqkZK4VsfXKt+4wWmGLoPP/nY/+T76fXrSJ1raVxJ
	 RR7/WP2H8/c65l3nZFCjtHlyS/a2Dk3J8aplVoKpJn15gSKmtTX+nDc6HwBroZe2Xo
	 tA13OxeLxYX+gP16YvQ7Xz6IBiDLEA9DJSTNxY3ADuB3nYDncqv6VCb8rVXIX/X1E8
	 ul5DUyihn8fnKjvKgF6h+x+AYBzDrtRB5zTF53WgkTDj1OpwZMwbNKc/A/16I7sa0U
	 0o9QGzFhPftrYzzrZPcIykCfInNvPnRX/KdNlFox4Xbp4pq2vir51cA6ap4s5Sc38H
	 q51ISZGADaI/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A1C93806541;
	Wed,  7 Oct 2026 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net/mlx5: E-Switch,
 preserve max tx speed on vport state modification"
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179133540677.2853870.16853849463841520082.git-patchwork-notify@kernel.org>
Date: Wed, 07 Oct 2026 01:10:06 +0000
References: <20261004083531.216988-1-tariqt@nvidia.com>
In-Reply-To: <20261004083531.216988-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 4 Oct 2026 11:35:31 +0300 you wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> This reverts commit ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx
> speed on vport state modification").
> 
> mlx5_modify_vport_admin_state() and mlx5_esw_adj_vport_modify() query
> the vport's current max_tx_speed before modifying its state, and
> write that value back, to avoid resetting it to 0 as a side effect
> of an unrelated admin-state change.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net/mlx5: E-Switch, preserve max tx speed on vport state modification"
    https://git.kernel.org/netdev/net/c/86b785b18f8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


