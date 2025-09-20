Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C65F2D876C;
	Sat, 20 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758326418; cv=none; b=ppdPJbZsT/CFX8yb4KRe7eMrGcBRVBwK3JBztDX378GswzRwcSsVxyXNU0eFD4u6dEKshglt1Sd4qEuDiDOeKsufujPbF5I2XwtJw90bx1INW/aKW/pAlCD8/tFq6OQNLVGOqZsoeohH7Hv3Fs+UwvOfvy7hIHUhEYbglXdWi0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758326418; c=relaxed/simple;
	bh=aS7RsUnVgLtREoubmp/2Y5K8G3uWXx6GWnJhr0rvJKc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TMG/crXsa9bBWx3nx6DF9W0yMrwK0NQmMRANcMRKH8h42zrqNVm0Npb1oFnduBG/cRlI5FWCrEKxm+NqchNASyMrxlSpseJGnAmRpch4uVwaR4QAuaaBTt3jwN/Vp7f1PboddwOhNOcb5kEaNrYNO/9OasIjZ7E5IZBe1IhXVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPXvgtKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPXvgtKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77621C4CEF0;
	Sat, 20 Sep 2025 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758326414;
	bh=aS7RsUnVgLtREoubmp/2Y5K8G3uWXx6GWnJhr0rvJKc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UPXvgtKoz3XWRCO5kti/MsBmdwLQPrMTWjTw5wYA2UqQnZBPkiyuwUzgZ8KrdaoPa
	 mOHZO7gm3msuFHBIDQvBXcNNYG/4yT79lF53UFCGG8zumMfDQzzSHEAyYxtxc8sz2K
	 udn78ykwwY8boWJSsG1+7V2QJ9lyHKLJM8o40QbPz1xsZf0bg1En38xICmA/ICQ5k0
	 RAYbVkSZFTISs5Fm0OAXdIaqyzIyX3q2Uk0Qa261zNgYYqysaILB3beNRsX79p5SvZ
	 EXdpl+kRmyBRzSRqjXqCqL+2zIaz+c/yQjE4DV8e3Q+9LrFlsbaoQZOcQFx5Qd3bMY
	 V/J97SQdeza4Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB03639D0C20;
	Sat, 20 Sep 2025 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net/mlx5e: Support RSS for IPSec offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175832641375.3742180.15264561959399602925.git-patchwork-notify@kernel.org>
Date: Sat, 20 Sep 2025 00:00:13 +0000
References: <1758179963-649455-1-git-send-email-tariqt@nvidia.com>
In-Reply-To: <1758179963-649455-1-git-send-email-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jianbol@nvidia.com,
 leonro@nvidia.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 paul@paul-moore.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Sep 2025 10:19:19 +0300 you wrote:
> Hi,
> 
> The series by Jianbo uses a new firmware feature to identify the inner
> protocol of decrypted packets, adding new flow groups and steering rules
> to redirect them for proper L4-based RSS. This ensures traffic is spread
> across multiple CPU cores.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net/mlx5: Change TTC rules to match on undecrypted ESP packets
    https://git.kernel.org/netdev/net-next/c/9f24f0c4d4dd
  - [net-next,2/4] net/mlx5e: Recirculate decrypted packets into TTC table
    https://git.kernel.org/netdev/net-next/c/c69ac57199ea
  - [net-next,3/4] net/mlx5e: Add flow groups for the packets decrypted by crypto offload
    https://git.kernel.org/netdev/net-next/c/d8693cac22c7
  - [net-next,4/4] net/mlx5e: Add flow rules for the decrypted ESP packets
    https://git.kernel.org/netdev/net-next/c/72ed3ebf95a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


