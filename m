Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2221773D;
	Fri,  1 May 2026 02:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777601455; cv=none; b=UYjE0QuPCT2nJErIIIuCabEPKuspbTZV6GLH3l9v82DzLlyeOUKJo9tf4d0i98+DK5xKYgI3tdbg3OeThi3RjElX2H1+yeGhkhDyx0LINN1yVns0Bgt5ddVcyKwg0mUabmn8BtcCehSS2W+d2DBMhjdwb8M3bSIGLiEIZYSwVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777601455; c=relaxed/simple;
	bh=+eAg/hHOcREg+fqugeQ/LdJIonLrSsy8nh3GSomuT7E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RAwyLx/mHsvd5xmTt2l4zVTKuevJmYv8zfjnIpLc/wXNcE7XPbhSsXphl3SwxFhtruBpO/0PPKppRlz4qQIgaTgQAyMPLi4BPgB7jnIQDSBLAV8ORKdRndA5pRKStZBDpvcItChfzOtH8Hs5R5haxoFiaB8ywyIxM/e+9fE9O+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBV5MShY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBV5MShY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEECC2BCB3;
	Fri,  1 May 2026 02:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777601455;
	bh=+eAg/hHOcREg+fqugeQ/LdJIonLrSsy8nh3GSomuT7E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KBV5MShYfMYzuwfozPtQAEzxgR65yE3eMUxXEtIeb4azZmX5vntPsMwireYJVN897
	 xlCfvoYa9NwlQMPzgOHjMV2mnevQPyjEmW7xC7G9tVPP99na1WYdWHs31r6oDtu1IG
	 YRZHQr1e7TbXspONKQMlZH+07M5kJIlcsUgGtri8NsKplzJwWKIU38gx31PQFpttC0
	 66mBbrFyWGQ11Mesi1yB+NtFanJF+GO+QejVFb1hz1g/kGkYzDSJx2pgdu/DZeMEWo
	 ERjBKnrjNVAnYTAyDgCj6/8g4MpswK+s5Fp2D/09nyNxPhEExbxUWkzdPEUl1tiNLt
	 uKXnezrIZe9nA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CCFA380AA63;
	Fri,  1 May 2026 02:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5-next updates 2026-04-29
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177760140930.3292095.11249811193125646123.git-patchwork-notify@kernel.org>
Date: Fri, 01 May 2026 02:10:09 +0000
References: <20260429212747.224411-1-tariqt@nvidia.com>
In-Reply-To: <20260429212747.224411-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, leon@kernel.org, jgg@ziepe.ca,
 saeedm@nvidia.com, mbloch@nvidia.com, moshe@nvidia.com, shayd@nvidia.com,
 parav@nvidia.com, danielj@nvidia.com, kees@kernel.org,
 ajayachandra@nvidia.com, jiri@resnulli.us, ohartoov@nvidia.com,
 horms@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Apr 2026 00:27:47 +0300 you wrote:
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
  - [pull-request] mlx5-next updates 2026-04-29
    https://git.kernel.org/netdev/net-next/c/4e37987362bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


