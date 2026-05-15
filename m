Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2171112FF69;
	Fri, 15 May 2026 00:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778804462; cv=none; b=cGVqgKivOAwbfEPQlNpBIe2KyGQA/0mc1BXjS8gyGRUTBh9MSydZSb1oBUhmNK4wJpJP2q7E2ZVaw7vk2llJWnXKTtGqHqCCCLfFOoJwso2apa9AXfqqkehnR8p8MNMQ8sla6FQu25kOo2Dfk7E3X245Poom/QtV0rCwQMotDdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778804462; c=relaxed/simple;
	bh=Le9I/WvzyLQsiyG7uRhH59gRf2ClbkRh2PQCq/IW+F4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uH/H81eAbFS0bD7NyXy/508Cgf4ij2EI58F6tzutqbwRIY8IU/KLVV3fa1u5deluybh43FocwQ/XidekLJaQbbCLaYu2RmfhxAxtaQJ0rwDCbQIX2y+Fw6eJAaqdI7aItCLdsdhVQIzgdhvfbSfnAWRvjhL2tR0dR2NOuKypd6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFn8JlQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFn8JlQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B972CC2BCB3;
	Fri, 15 May 2026 00:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778804461;
	bh=Le9I/WvzyLQsiyG7uRhH59gRf2ClbkRh2PQCq/IW+F4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SFn8JlQDeO5EJbgcCAFh/X7pz5133+FsmJN6CwkTR5zid3V+oulyraF6wEdqf+l49
	 dPmRw9/cjPvtBVmrsylsZgCdNPLhK7D/TJzS5X2mLW4fj3LSfQXQe8yWwp7SVETkMN
	 9kEa2KAYd8Qzui7Kiy3akG1trpRkN1v1ZNXHj/a8R+Xyh/mT+btPQWguGqNVecVOI+
	 uvi0gb5eEmlYVTxLCoaaOV6rutwMBDALpmZo58TZNWven+lEOHvnIVtxVbADDrsea6
	 T60zoCUGskNb54YaHKyF5FeDtxRRIKVTDPihJZtbFTVfrK/n4iaPZYfStzH+qKe+S1
	 vx10A3+x5sh5Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CEAF39E4DB3;
	Fri, 15 May 2026 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/mlx5e: Fix use-after-free in
 mlx5e_tx_reporter_timeout_recover
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177880440630.134878.86553254507437250.git-patchwork-notify@kernel.org>
Date: Fri, 15 May 2026 00:20:06 +0000
References: <20260513112226.140512-1-matt@readmodwrite.com>
In-Reply-To: <20260513112226.140512-1-matt@readmodwrite.com>
To: Matt Fleming <matt@readmodwrite.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, dtatulea@nvidia.com, cjubran@nvidia.com,
 cratiu@nvidia.com, shshitrit@nvidia.com, gal@nvidia.com, feliu@nvidia.com,
 jacob.e.keller@intel.com, moshe@nvidia.com, ruanjinjie@huawei.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@cloudflare.com, mfleming@cloudflare.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 May 2026 12:22:26 +0100 you wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> mlx5e_tx_reporter_timeout_recover() accesses sq->netdev after
> mlx5e_safe_reopen_channels() has torn down and freed the channel (and
> its embedded SQs). Replace the three sq->netdev references with
> priv->netdev which is safe because priv outlives channel teardown.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: Fix use-after-free in mlx5e_tx_reporter_timeout_recover
    https://git.kernel.org/netdev/net/c/7d260c5d2d89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


