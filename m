Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEA3D6497;
	Fri, 14 Aug 2026 19:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786737108; cv=none; b=kXIzcQAXuEmPA2jPKsRm6aWvCwx92Aq3/3LVOMZeXAhDIQp1IT5qJJWqnRieYRfidhe2hHE8lcamJt/wZKevLvwqQsZZXkNJualO3VwtCbpMO35x27ecn7nBvQaDaSzG+Vp23XCI5y7WSCg/yrccg1ItlcBmbCCt7wCyENd2/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786737108; c=relaxed/simple;
	bh=ucz3xcI7CN3gWwYeFKoJfCXBpuEUOGHap4+57fpSpE0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RRHe1shvZgG+OBMgodb68x6p7PubR/H1M2e5WsiKUyfII5rEldpYDay0DYLr5vRizDAK1TWRJ4xxV5iSbfXqFjsVI/A7+h8B1Gd9XohK2AttNkYvkFgUVGHAMrgLXP3dfXEvDZqgxzZ+5iJ90AdDveZzsdPW3//9Ud8aEpaFF3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK8sp9ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK8sp9ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFA21F000E9;
	Fri, 14 Aug 2026 19:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786737107;
	bh=+anBlQKHwLQ/a2iQCppghPiMvff7zUTrKYrfWIi5EN4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iK8sp9apQEi8Y038r7UF2VtavDNRqtiQm7ciC8JN/Ieo0L5NBOrX8S5CtZIIBNw4e
	 HgrHpno+ACRH8WQYuUzA3ErvaT4UJSVO39+c9KBrpm2x2CPYCGg98G8Hx1VlujZMjp
	 8kSNyoYqcgcNZTBXvVNOiyk0+RB0YpNXuc7u/cwAZE189/Rei+QttZNlPKnfXw/sDe
	 JFWFrQwMAIzvI/sGbYaHhA10ni96YpTGfvNo7LyMMX5qbiN8eyvSSvkcYivxGldVww
	 13KJPJi5SYo2I10fNBFmBzqksN8Q2F4SYaIVvnmLKA0IkNPXcPKeMYGloG5QoXMFbS
	 arhBT4Yrgsaig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568F1392445C;
	Fri, 14 Aug 2026 19:51:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: SD,
 prefer sd_group_size from vport context
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178673706087.3935546.2900041521932070149.git-patchwork-notify@kernel.org>
Date: Fri, 14 Aug 2026 19:51:00 +0000
References: <20260810093037.3138197-1-tariqt@nvidia.com>
In-Reply-To: <20260810093037.3138197-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com,
 horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Aug 2026 12:30:37 +0300 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Newer FW reports the SD group size directly in the NIC vport context
> via the sd_group_size field, gated by the sd_group_size capability.
> Switch sd_init() to source the group size from there and fall back to
> the MPIR-based host_buses query only when the cap is absent.
> sd_group_size might return 1 in some FW configuration. Add explicit
> check to disable SD creation in this case.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: SD, prefer sd_group_size from vport context
    https://git.kernel.org/netdev/net-next/c/486e5419b7ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


