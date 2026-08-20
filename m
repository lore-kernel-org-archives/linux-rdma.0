Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC023B71C7;
	Thu, 20 Aug 2026 19:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787254286; cv=none; b=JBulT9DJHTUCapSLjT/13n6o48rfj7hvCpNxLi37+JmEmb7OYunM2+yYok23OUJxDUbpM65BLZs54r6QNNG5fvhw1NWteYKYFN75lezUnPiPgVowMYg8z9e/JYHMVe28pb/0xDMiKM0lVGcqFNz+5FZ89uKJ358oOmJgGLdFY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787254286; c=relaxed/simple;
	bh=2YGgCLueFGzHzAZtjRHbPjJ69dBl8mPBXyDEI005LgI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nHwCzkQJvp1p54r+Puz+Xb1oef5ZXRMFBoW23rwp3qFTfEuifrRkT/c0h3qbcIPae6KHaZ4toOMfkJmJ53d0aAKOm9FD/eAwAZi3LUvAwfDw8/gS0BrlsrmeqCbNZFkixeVB1NhRFWGxP58h3WXhKpWTa4kpEAdV6LBJ6He0mwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dj8AOmkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dj8AOmkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8901F00A3E;
	Thu, 20 Aug 2026 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787254282;
	bh=Vut9tB6aGR5P6rHIS3bzMb6wpOEqmEZAU4oqUggGbRk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dj8AOmkmuCliwM7MAWzVDfom7c/s/c1Xu6/vx778p9b7qrNbKFVdZuJl3PM1DApU+
	 y39bckq0mYqYP947ECuqXbG46QKBS+HZu4ebtT5DSwsiDuDaRaysqr3aSBp4no+MRu
	 cnC8NBNQRnEdp8wKt+OVJWSlI4eFyoOLHwVdPJq2fiauB9OjL+L7UMcGtjiVb5EHco
	 xqKYsG/4JmJdB8guitsmz+0qqqCKJrLJVXlFqtpKvuSxVVg2OfP3vX8pH2BWzI17Kp
	 JuZiP3ROm67WvOZDALA9IuVwVOcIq6m3isSj9emy73sptiGXzgXzmwKcCPpdnryKY6
	 8YJ0b2gbqtPNw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A023924459;
	Thu, 20 Aug 2026 19:30:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net/mlx5: Preserve speed and state across vport
 modify commands
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178725423213.446762.7439713881137610450.git-patchwork-notify@kernel.org>
Date: Thu, 20 Aug 2026 19:30:32 +0000
References: <20260816065015.3280733-1-tariqt@nvidia.com>
In-Reply-To: <20260816065015.3280733-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 ajayachandra@nvidia.com, edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca,
 jiri@resnulli.us, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com,
 horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 16 Aug 2026 09:50:12 +0300 you wrote:
> Hi,
> 
> The firmware vport modify command bundles both admin state and max tx
> speed in a single operation, which requires each side to preserve the
> other field when it only intends to change one.
> 
> When modifying max tx speed, the driver already queries the current
> admin state and passes it back to avoid overwriting it. However, this
> query and the subsequent modify were not atomic, a state change
> between the two could cause the modify to overwrite the new state with
> a stale value. The fix holds esw->state_lock across the query-modify
> sequence.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net/mlx5: E-Switch, use state lock for vport state changes
    https://git.kernel.org/netdev/net/c/ff0f9b7aa1c7
  - [net,2/3] net/mlx5: Move vport DOWN state check out of mlx5_query_vport_max_tx_speed()
    https://git.kernel.org/netdev/net/c/20f11b5cfa42
  - [net,3/3] net/mlx5: E-Switch, preserve max tx speed on vport state modification
    https://git.kernel.org/netdev/net/c/ad0ae7aefa7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


