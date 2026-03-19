Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0060840DFCA;
	Thu, 19 Mar 2026 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773889822; cv=none; b=pzR59ED4NCrPys9+bH3QFZyYzFDCSs6wxm5fA4606NmJ2ivOz3kL8MUeNb9zklxNUA8DU30B9IUmD32iffe8hrqFVPeTkvWmT8D2v10/Mu34+pEwtopBneQb1MNVZw8yJ1kx7fO1LgEhYxjnXZktPkpVVoWxpf2fMhXhSnZIw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773889822; c=relaxed/simple;
	bh=pbM2WXvmOAdhLGbFMYG5y2e9R+cxexczvKiZWhcVPNg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pHJ9SysnZ4QHL7dT0ipfdAs+Ta5oK6Vwl2wMRjTEOhl1YPga4AouAJqdEd25GP9x0rW+xNAJKadCa1u0K3+REbtuVZLAlkZSItkdUmZhXTmepXQGN9k37jDFkN2KJ/ygtyv+QPkG4mlAkqKTEsQq0SkwwAmr8ahoq4tQPa1DRzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKEH/AbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKEH/AbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE73C19421;
	Thu, 19 Mar 2026 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773889821;
	bh=pbM2WXvmOAdhLGbFMYG5y2e9R+cxexczvKiZWhcVPNg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oKEH/AbNl2h4OnelcKZUr+PEr9tI69lZCcn8IwZran9g/MhS93aCbVYOz4MmHMAWn
	 Y8LB9Moue/E1/WmY5KGjhLB3taD0Aedp2xsCyek8rX1Bs6X0adO+MIl7hw8i3G7tsj
	 1o6ooxD8ngeuWaDmwjgqh4JTk8VccO9ABrJkSeqbOA0oBAgxY9IB9iO6VQ6ZLob13q
	 CVQHDEIsVwkw31wslY5hHhZAetvqYUHXnQfdLJXdAnaZQxpzmqYA3MasGHBQQgNaYL
	 fN5GX6xCmuNxgx4I3V+N5s1QzAbFtZI19qTWJSsCYY6HouBqDYfnlEZao4U+BZ3o+s
	 amptlaVABt3Yg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE573808200;
	Thu, 19 Mar 2026 03:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Remove unused field in
 mlx5e_flow_steering struct
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177388981279.1008325.4356129882650210437.git-patchwork-notify@kernel.org>
Date: Thu, 19 Mar 2026 03:10:12 +0000
References: <20260317104548.15697-1-tariqt@nvidia.com>
In-Reply-To: <20260317104548.15697-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 moshe@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Mar 2026 12:45:48 +0200 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Not used in mlx5e, clean it up.
> 
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Remove unused field in mlx5e_flow_steering struct
    https://git.kernel.org/netdev/net-next/c/04cd075557e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


