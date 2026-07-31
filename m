Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5D725A645;
	Fri, 31 Jul 2026 00:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785456051; cv=none; b=d7zNSLjWLeTvtZySvfB0IN4CB6H6Qqr9qzsu/r7qULVhq2bKj9pGxdRwEUgxojmYGbaxvMPYOkYO5XYANlgQ0nJsiJL6pBy330oREq5Pw1oAdtlZZlDrFKO8knup0CVwSDWRQPEmUaHkPgkwqjNfTHoWyygdMyo4fVY1WERSoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785456051; c=relaxed/simple;
	bh=ceAKfUs7Cn/vSjzkXtuNLMnNl/o6soBfXnALmtk7ovQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=k6h102f+FGkweqOtpWGcyQEgNPcKfnDyR8l8qnZS5Mi4GUDoi3YBhljVjLDnRy+RFJsqBdv9dpTYAXZxzkd/vJG1Xkt2p3D1/+e60ntzzV2hO6idFt1+QDCsoLGGqpUG9yklw923B7JzzS1oCcOcQPcg60iZmWOjIkt7cIOId8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJqCaM7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJqCaM7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4A81F00A3A;
	Fri, 31 Jul 2026 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785456050;
	bh=6tqIk0Ydj5GvoGLtKby7LlI93vm2mjS6pCRmb12C6Sg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gJqCaM7twbjSWYRyX9p6YAw1PiQrcRXALFjd8juli9/yGKm39v5zPEUN64xBCLmO9
	 otN3TV+A1AeK8jEDXVroXrgTHj8dWdkpmAoCO6LdB9gno3jYusJ/diLcc2PcN2wbAb
	 ltIze667/dUvqLPOHjP+wN3K8njp1BaBjR/vA8tKUN57kbQa5D38hQX2dTpKEwS2Ka
	 kQWIfLkJjzI/nsWhHByIxjwiPPrPVdnetR4g3h/RjV8nz5xLg/vRDfVPGQrnlViYVO
	 FvYSk7gOjfu9Sxjn4MCNI4w9MNvU+Eq/x/9YNQoQc07JW3Mruh4yguC8IMZay0oHDz
	 7ODKGMmoJtllw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9396B3924472;
	Fri, 31 Jul 2026 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/mlx5e: TC,
 Check if flow is PEER before acquiring devcom lock
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178545601313.49120.11958619412514428271.git-patchwork-notify@kernel.org>
Date: Fri, 31 Jul 2026 00:00:13 +0000
References: <20260728044338.2271143-1-tariqt@nvidia.com>
In-Reply-To: <20260728044338.2271143-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jul 2026 07:43:38 +0300 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> In case __mlx5e_add_fdb_flow() fails in lower levels, the flow is
> deleted via mlx5e_tc_del_flow(), and mlx5e_tc_del_flow() is acquiring
> ESW devcom lock without condition. In addition, in case of peer_flow,
> __mlx5e_add_fdb_flow() is called while holding ESW devcom comp lock.
> This results in an AA deadlock.
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
    https://git.kernel.org/netdev/net/c/6ddfba2ea98d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


