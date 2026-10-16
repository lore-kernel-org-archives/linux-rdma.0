Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642BC33F5AA;
	Fri, 16 Oct 2026 01:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113015; cv=none; b=dam5IDKGRBuCz52rXA+ayDCsoYWjrlci+vVIZit0LTDys+1lm1s9fM0DKp4EFmQdROO6oGq1TwS49V2Lv6zFZTarKMmTFGyzo/2QSRD2g2GdUr8DXoC+tWdlo0JekggRzSru39AHRiSmFaXPxArAGLFqp1ADWXP631vCjm1x/3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113015; c=relaxed/simple;
	bh=uKWmPriZqqzypHB6jm0jeSACUly6+POxaUEWZHb1XOE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PcYmszhcWOiF8CvTzCP2mO5elugRZLJHMCHC/tW5XK/NU6LebXlmfDfLNvlboZzkJPDqWgNsgMjiXRLIdZ0ZDbpB1PfNIKxNgSc/z8pj3LYnvtECUpWjc46btM+ATfQT6ihScAlEmN0J+dVAqvEq9NUDE0etSQqNu7gJ5elVyw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlY1pQn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlY1pQn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F4E1F000C4;
	Fri, 16 Oct 2026 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792113014;
	bh=ZsmDfOR4MqlTvsluJlYS5l8ry4+iNBk487udyPZhM7M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mlY1pQn7BRTtQkxMAWtgS1RAm7/UI/IZsOz+9qfnGQy2C2x5ueEsvCySQM0pLMMPe
	 YpKgeh1VrGmLcRLUjkdn8onAuMc7TsLfuz7/j9/T7pEpcbWLPdgojxeilQCklO1GJn
	 qEIMys5hXC23JM88GLyifnCBS8weM+NCuYNcNMhQG0xpIYsliPq5Cz07md9NP7viLP
	 StRhq+82LHMWn/SuXjcrqUtzIJsPLN2mAUtl//mIru85w3bABpYRIe5Izhcrh6diTn
	 Q/eNv7iRCdXBdSsvzEuf8zrUIbpUrIK3Np1K7aDaQDyL+j2nDfWSvpPfPmGNjWEowp
	 5zkJqXGQ5RcKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14D33808209;
	Fri, 16 Oct 2026 01:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Rename state_destroy to
 rx_mode_active in
 flow steering
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211301252.4187796.3489924200999581576.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 01:10:12 +0000
References: <20261011093100.769149-1-tariqt@nvidia.com>
In-Reply-To: <20261011093100.769149-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 aleksandr.loktionov@intel.com, alazar@nvidia.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, shshitrit@nvidia.com, sdf@fomichev.me,
 sdf.kernel@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Oct 2026 12:31:00 +0300 you wrote:
> From: Alexei Lazar <alazar@nvidia.com>
> 
> This flag controls the enablement of RX mode handling (promisc,
> allmulti, broadcast, netdev addr sync). It acts as a safeguard
> that prevents new FS (flow steering) operations during device
> teardown. When the device is in destroying state it is set to
> false to indicate RX mode operations are not allowed.
> Its name is misleading, as it suggests a destroy-state flag
> rather than RX mode activity. Rename it for clarity.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Rename state_destroy to rx_mode_active in flow steering
    https://git.kernel.org/netdev/net-next/c/cdcb648a97eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


