Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA053263C8C;
	Fri, 27 Mar 2026 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575618; cv=none; b=cATu2+ACAUtlh9ylGrrHb6ru6s5EGnr1EgPh4axWTVykV//Cr0YSvz4oEiauyMfDuUhrOcBSSUq0YgnfRkZkqWNKM7JuIp0MrhCJUsRjaOCD+hVuT7Bor1lUxC0d2+1no2IyXl5Icil18nZrBiIiCPRKahI1VTLB0+ecJYRAHZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575618; c=relaxed/simple;
	bh=4FOTs+6l+UT/nKawd4uwnXzAXxh8/VcJzsblUpeTwNc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Wm6nj3WjSbSBthVHp4pvf8S0GNqYKF0JNpHJgCat4iorY7Svg2Zx21aDW6gW4Ri+B0LY1vzgMgn9PVSFu+joGp4qV05wy8HsDtcN49cg25AtXyM0VaLwpV9mmDL46fsnbT20u5tqGiNUWz5IGQYXAxqIy1DgmjtY72mk/9ct71k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/nVBcdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/nVBcdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B013BC116C6;
	Fri, 27 Mar 2026 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774575618;
	bh=4FOTs+6l+UT/nKawd4uwnXzAXxh8/VcJzsblUpeTwNc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b/nVBcdKaZ5Tmmalf/4K/52Zx9zmn3r5umaRB+pEIZLYflqgdlggvXJdNQhlv3tiA
	 UeCP7QgeKr6obrHILK5s3yPQkNSvLWmS/oT0856ukyCEHDma8MgK74KOiuNlPYv4tp
	 yzpeS/tjViU5ANPOkdLYf4fhCyB4h7LOVwZPAsgDaqZ+4bIQPnG++vhkgYpJAWQ4sA
	 NQnJrU0RP211pR9nxnS9vkorfbOgWixdemTn/pZcS0tSftwR2VQ9TwKGmZmL/brFdk
	 kpXmW6R6SBT/fuFGji/7hKSKaY+NhkiwBrnhQmkpnpscmwqmhXhOLp6S30XRwFebia
	 xP5eNLzIRwQSQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD013809A07;
	Fri, 27 Mar 2026 01:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] docs/mlx5: Fix typo subfuction
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177457560504.3253381.2020688164175380475.git-patchwork-notify@kernel.org>
Date: Fri, 27 Mar 2026 01:40:05 +0000
References: <20260324053416.70166-1-ryohei.kinugawa@gmail.com>
In-Reply-To: <20260324053416.70166-1-ryohei.kinugawa@gmail.com>
To: Ryohei Kinugawa <ryohei.kinugawa@gmail.com>
Cc: rrameshbabu@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 corbet@lwn.net, skhan@linuxfoundation.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, joe@dama.to

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Mar 2026 14:34:10 +0900 you wrote:
> Fix two typos:
>  - 'Subfunctons' -> 'Subfunctions'
>  - 'subfuction' -> 'subfunction'
> 
> Reviewed-by: Joe Damato <joe@dama.to>
> Signed-off-by: Ryohei Kinugawa <ryohei.kinugawa@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] docs/mlx5: Fix typo subfuction
    https://git.kernel.org/netdev/net-next/c/ed8edcd47529

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


