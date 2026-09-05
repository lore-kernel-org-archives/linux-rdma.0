Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344623112AB;
	Sat,  5 Sep 2026 20:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639676; cv=none; b=B57i4z9xbBoUXg0ePPn7oY//QsDkvOJPL+FUrcsvF6Lx4PRx4GVUGhue+ndisZuzGpB/YjWEqABb1spnDbCYGzZ50NQWNN1IL1ItIN07EVj77vED8fB4Kc2AIdDEm4NS7AgCG0aG3GmXEOjLu6FOdVlfTk6tUMXwPUvcERjA23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639676; c=relaxed/simple;
	bh=cx3JZ7J0KivUl8yPD0v50WQPuwWpL9XFw2gAOb2b9q4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TkBXSceze/ia6DiIEIVvckp25fswFeEUNOTmUv3K8Zw0H3YA8U9ab+ucbgLOOi1FJCMKuOCiiRPw9Abw79Xix4t/TTXAsGTnafdO3LdKOWfDEcelzf2qcm2NlKZSuydK08ydAbt5wZPtUEdKWj+XGfH0DAt4HTwhVoePdajgo1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8DTlltM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8DTlltM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735941F00A3A;
	Sat,  5 Sep 2026 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639674;
	bh=Of8b7ZhEyqfWVnldTeapGziJ8LMYV4yMQG+J5ELqKgs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=K8DTlltM3p7NBGXZOPttSh2XonvoWV2r0DKNUgR4c/73WdUulwtQs/B7gzAKgDfZV
	 u4hLjUnEi4gCha42ixVjHnZ4Fbt+bZOSJW5OTtVQk/EOy2gXyVjIhKOzoCRSEjjBAf
	 qlPY0VXs8+t+Dm04SRZd2S41RTCX3bIRAT8IqoPHH/HQEXH06no1myLqyT8Cps2xbP
	 jkRp9qEXfmo6GVyUEXTDpZWslLSqXcRJmRXO5acl5T30Cl7/uLU04yPDm2y20uJ+me
	 155w8a14zAqjRutweoNYcjmDIpFxbtHiivlXTHTkAU3///TiobNyeLmzEn+DvrvIg9
	 DwtrW0VYg72wQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B613924FED;
	Sat,  5 Sep 2026 20:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: LAG,
 use local tracker to update active ports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178863961440.1343052.17618088641515894072.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:20:14 +0000
References: <20260902192740.3665435-1-tariqt@nvidia.com>
In-Reply-To: <20260902192740.3665435-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, edwards@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, jerrliu@nvidia.com,
 msanalla@nvidia.com, mbloch@nvidia.com, ohartoov@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:27:40 +0300 you wrote:
> From: Akiva Goldberger <agoldberger@nvidia.com>
> 
> The CREATE_LAG command is handled asynchronously by queuing a work,
> which stores a local copy of ldev->tracker. When the work is processed,
> it is possible that the values of the local copy and ldev->tracker have
> diverged.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: LAG, use local tracker to update active ports
    https://git.kernel.org/netdev/net/c/b3c79dee5038

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


