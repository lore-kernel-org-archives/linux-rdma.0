Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA08834EEFD;
	Fri, 18 Sep 2026 01:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789693276; cv=none; b=q074eW56TDoYenpS8pri1+wRfFAZLtUevA3ZOTfKpO2yzmEw+TyaU2CRIxL9WeeGFrIhrYfAdIUobaoAuLjQjR5rbbfkqx8tXOuF/RG0BbixI0EoCkaETmefT1k9jw90kMGVEtyAWwJ7nKjrFPQ3CUSnrjtkqzjqGNG3JC3D4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789693276; c=relaxed/simple;
	bh=ggZwsaShIQ5aZQSXLneO7hkAC3zYT3R6vCxCN7e4cRE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=f5VGsa3I3+8s0So3YW7P2CWPIC54RU//aD2WW/U1eDx3t+DwnNX3dQ/8FT+rBLG69pTt8A5R4E4PpPrciQNNFVh+GldyyS3x2FuQtNyzdv9PrWN3DkyBoFJ8M7CCv+A7A/27/Sld6CQ8NYy7WZMinBMkhtqb2ZJUujsl6N4Y820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNF2tMTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNF2tMTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD51F000FF;
	Fri, 18 Sep 2026 01:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789693274;
	bh=6rTB3UCndzcR89Te2bYPvVcL7EVx+BCvmOmuYHa91Js=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XNF2tMTtg3MdAdtKkT323as61CXh3F43xreHiaqhwuxBG1rhG1oL9ATahg1+B8Xmw
	 W3xVL8mlC1tsrQs2US2K0oR9ZCAF1SQgYh0cyPb5H9J9CdO8qse9Dn0EZ9XgVuk8Df
	 aIobJ5QT1afisuiQlNZ4ibyJvZT49OiM1Ggn3whzXjLKpTs2DzKTMgOCWZYSumfF3w
	 vfBhoVE1dieqLg/EZgFF0raMyjKA+KxyeI5wXxhR9EjVtz/eAl7jv7AWBIbq8Yj5/x
	 eBBIARiG5fsRCQarhj0x9/z+TaXNFcpOYWb/FJa/a8gxNGUsLBvhgxYPcthgaGRELY
	 eooOnN56d+WwA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19984380820D;
	Fri, 18 Sep 2026 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3 0/3] net/mlx5: SD LAG and devcom stability fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178969320763.204321.19372011582450217.git-patchwork-notify@kernel.org>
Date: Fri, 18 Sep 2026 01:00:07 +0000
References: <20260915113459.3934760-1-tariqt@nvidia.com>
In-Reply-To: <20260915113459.3934760-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Sep 2026 14:34:56 +0300 you wrote:
> Hi,
> 
> This series by Shay fixes four bugs in the Socket Direct LAG and devcom
> subsystems, all related to initialization/teardown ordering and
> concurrent access to the LAG device.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net,V3,1/3] net/mlx5: devcom, Base component size on linked devices
    https://git.kernel.org/netdev/net/c/d09e8f64653c
  - [net,V3,2/3] net/mlx5: SD, unload reps on shared FDB create error path
    https://git.kernel.org/netdev/net/c/e1e29ada2b93
  - [net,V3,3/3] net/mlx5: LAG, reload IB reps of LAG master before the rest
    https://git.kernel.org/netdev/net/c/bae23d1ae620

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


