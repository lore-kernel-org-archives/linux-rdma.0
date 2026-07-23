Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD547607B;
	Thu, 23 Jul 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820659; cv=none; b=diHwH+241k+muEQ6H8Aui9/rTgMWqC151CkH6VmONC8Q4UwZlgXTJbIf6k0bV123Fi0nddxfeS03AlX5CwdHuijRUEAm6meI5XCeZnotlTRRzWi8Fp63sRUXsBcuZY9eHr09ClONqnifJ7u2nS+O67V+be+2LGIksQ+jlhIrBG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820659; c=relaxed/simple;
	bh=xhVhqlEcnVCeao6kmkVkUbw4h2vpRnDn52QXV+H9KtM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lBQRphFnS+BZuBPX8S1FvWxI8oLW8XGo5skGcX8G0btVx+LZSymqLB3LM9/AJxA0DTHEGT8ZS7HeU3XaKTdId7qRl+8RdlAMHDUMg5Z2ZDHYUh+8EZhy1l4xCbIDXmWDFXWMQx3oVe+NBzEkPTwWF2KZuwUOh+U7tsYkddCehAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57701F00A3A;
	Thu, 23 Jul 2026 15:30:56 +0000 (UTC)
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939B93924453;
	Thu, 23 Jul 2026 15:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: E-Switch,
 fix zero num_dest in prio_tag egress vlan rule
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482061816.2321119.15008750481814720639.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 15:30:18 +0000
References: <20260717073306.1242399-1-tariqt@nvidia.com>
In-Reply-To: <20260717073306.1242399-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, ychemla@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Jul 2026 10:33:06 +0300 you wrote:
> From: Yael Chemla <ychemla@nvidia.com>
> 
> esw_egress_acl_vlan_create() hardcodes num_dest=0 in its
> mlx5_add_flow_rules() call. When invoked from the non-bond path
> fwd_dest is NULL and num_dest=0 is correct. When invoked from
> esw_acl_egress_ofld_rules_create() during a bond event, fwd_dest is
> non-NULL and flow_act.action carries MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
> but _mlx5_add_flow_rules() rejects a non-NULL dest pointer paired with
> dest_num<=0 and returns -EINVAL. The error propagates as
> "configure slave vport egress fwd, err(-22)". The passive vport's egress
> ACL table ends up with its flow groups allocated but no FTEs, so
> prio-tagged packets are not popped and bond failover is broken on
> prio_tag_required devices.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule
    https://git.kernel.org/netdev/net/c/d12956d083eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


