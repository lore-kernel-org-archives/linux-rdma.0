Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844AD1C3BFC;
	Thu, 10 Sep 2026 03:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789009867; cv=none; b=ezLj+eg6QhgqCshWiOiKbITBshnpP9a2GNx54EPrEHgZJ5aAQJ5p8CgwNNm8L17MIBrGFQaUwY/GLUU4fr3p6Z+v3fBLQsed/+aaf8LrhYvUUI3DkYLdHIfspRPJ8JC9IphEYosnVb9jqvuRUmQKEBoF2kyOKqh5yGa2w4ouMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789009867; c=relaxed/simple;
	bh=15hXHIEA+G+GFzukycQPOAOo2ITHoNnxowjxcxAaEtA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=INX2pwviztGx7p3NFQKtVXmg5SENmipFTFvzHMSeRDBrx8SdvSaLXImC0OCdANemnWLyDffrsr0T11y+z3Gq7d7kh2L/bPn4mCBnmRPCcX3TA1fYHhG/vWxImNBBpfBPs6DmBSt9DCflnNhUAm+5A8TNBhTYxE/Ib6t1s/MDnJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3LnHlUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3LnHlUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235F71F000FF;
	Thu, 10 Sep 2026 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789009866;
	bh=Dfmp/qJolIcZdYfOuuuuSCHVvZ02bDHMoGGhyetY/Tg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=V3LnHlUnew58JI1wTo/jsrxlLrCkfEWfnpsNQx0kD2Zj1Dtej6e7Ir59FlSCZzGaL
	 TSr39XLT8Ubk4ZvLZj26QVFnEg5iZ3CMksVJxlIwN59yGKTRAAsFpeo7TLwYE5tSfY
	 N2tS+wwXtgPHeN9Kg0/i3SzlGlPY4GfDdDY9cgVnk6scWC+FvpwoIGkE8IkRZZ7kjm
	 6hNYRuHxubvjjy9tLlEVX3reiffBjjKM3EKyiYKKDism2clf1PbzKDsle2BmOLlTCf
	 yo/2o5EVP2kijkxwgi7AbzUBzBEBIBkqiPYTs8KEuXqmIU7OEA1n6wo9jCgUo23rS/
	 4S/7ncY1lTZzw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199E6380CEC7;
	Thu, 10 Sep 2026 03:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/mlx5e: Move representor vnic reporter to
 eswitch
 devlink port
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178900980389.1168652.5408559475805106477.git-patchwork-notify@kernel.org>
Date: Thu, 10 Sep 2026 03:10:03 +0000
References: <20260906090700.3761260-1-tariqt@nvidia.com>
In-Reply-To: <20260906090700.3761260-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 msanalla@nvidia.com, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 6 Sep 2026 12:07:00 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The representor vnic devlink health reporter is created and destroyed
> along the representor netdev (un)load path, which is not serialized by
> the devlink instance lock. Destroying the reporter from there triggers
> a devl_assert_locked() splat on driver unbind:
>   WARNING: net/devlink/core.c:259 at devl_assert_locked+0x54/0x70, CPU#2: bash/3758
>   Modules linked in: mlx5_vdpa vringh vdpa mlx5_ib mlx5_fwctl mlx5_core ...
>   CPU: 2 UID: 0 PID: 3758 Comm: bash Tainted: G        W           6.19.0+ #1 PREEMPT
>   Tainted: [W]=WARN
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), ...
>   RIP: 0010:devl_assert_locked+0x54/0x70
>   Call Trace:
>    <TASK>
>    devl_health_reporter_destroy+0x3a/0x1b0
>    mlx5e_vport_rep_unload+0x12d/0x2b0 [mlx5_core]
>    mlx5_eswitch_unregister_vport_reps+0x1b8/0x220 [mlx5_core]
>    ? __esw_offloads_unload_rep+0x190/0x190 [mlx5_core]
>    ? kernfs_remove_by_name_ns+0xc3/0xf0
>    device_release_driver_internal+0x3b2/0x560
>    unbind_store+0xce/0xf0
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: Move representor vnic reporter to eswitch devlink port
    https://git.kernel.org/netdev/net/c/7f26a5e8040b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


