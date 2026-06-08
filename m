Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8843B3B42C4;
	Mon,  8 Jun 2026 22:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958430; cv=none; b=Y5LVktoGOqlxJbWv3eRtnmZ1W3gX8eHsI5JJYi1zXxuZWKDuod6MBn3Uup1qfD2RMeJH5+8ES2yP1RmkNklJhyyBB56COZ2nh6M/Aw59yDt1ED9yH+Cv+C4fpNkfdshUG+fCiqRnwLX/jTlZpcLLs3/KXQVLf97uxottQtf2O3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958430; c=relaxed/simple;
	bh=WfnZGuuHbXyO1yTdOPaF6vPnp4GT9f4eEr3nub+n/Eg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BdV5PI+l1P6BgM3fCSpCt5Fy+albXFfODpgZWsL4UmgpKRHmi34zg5SJPQ9UkeAuKRf4h5uS/oxbAfoF8KQGzZvMSy87AewIujRpN+e05xKqhAwgRpKyBv+d5jCV2wF5yi3XNKEL4zVrm110Wn0dWqebwsJMSRSw8v5ByxX99R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDR4CQ3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDR4CQ3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255BC1F00898;
	Mon,  8 Jun 2026 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780958429;
	bh=fQfQFv6/WzGMUKOzEK25pov0DPtrTdODou4at+fFukk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZDR4CQ3DINMCN8OaRQCt1dnwMA6I8KxAS4mThx6V+iEW+kxs878SGpBh8IeB2D1Lr
	 ewPb4KMmAgkYgrNPZoOuHzqXKEfLiDmpqXbtzZjHfeTaAhUO9DrU4TB1hggdytPiUG
	 28AYWML6cttKkrZFFDGxknTI9T2+WKr4OzOATxoudda0CKCsrkhUUdAqGXuaXA/NJl
	 R+5Wmleo1h+Py9cN+l/MCTYX5/Fr8xqhP1Z9VmyXCrKXN6/1XdcbJCFmjGhJ3X2Npt
	 dFjelqd5QvwIS74Iursx6znZDjzDKz/WGtRYc36LDIbHN9pIWSA6faN0fGNAOwOv1P
	 KIMdub5WRUTvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198B53812FD9;
	Mon,  8 Jun 2026 22:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5-next updates 2026-06-07
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178095842764.1698449.11301804131440980167.git-patchwork-notify@kernel.org>
Date: Mon, 08 Jun 2026 22:40:27 +0000
References: <20260607111157.470978-1-tariqt@nvidia.com>
In-Reply-To: <20260607111157.470978-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 dtatulea@nvidia.com, moshe@nvidia.com, shayd@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 7 Jun 2026 14:11:57 +0300 you wrote:
> Hi,
> 
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [pull-request] mlx5-next updates 2026-06-07
    https://git.kernel.org/netdev/net-next/c/199f6b9a1603

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


