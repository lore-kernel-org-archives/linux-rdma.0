Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794354010;
	b=dlhd4Z8nTyUnbjv8t9ioDudpC5+h3kI609KpfqKr2nOBtIPY2Vq3th2bfhrFolMHFQF0
	 c9Iebs492T3qRJUS6wyhMe0prcBcharTatM6sFPYHwoIOg+Fc8yBO4jGTv4tBvMZIp7+d
	 b1ZNl74rssPkxLydWctwamWwhXZV0I67F95ZXYZKBr6lU0TU8dfcIhA9Vc8u5NdIZhvnA
	 g1SSqd2Sxx/0AROwIc1gl3+saSMxT6fPW9aXj0WyaHwqx5L4zl01YrRs07SsV1bUP3HVE
	 AqulInmgQSpTPVjbuWfVA+6WMx2T2UNRpX2dqPgv947DtOlNDmMnUnvH1Xaj7dpkpiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794354010;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=pYmj9P82h3mH0toZaIrqOD30rRfqgoFATEdZmKo+ic8=;
	b=uSLrYjR3PgyGKCDlzOsrfOajqsq7tSTADLCURF9RH5rLA1cFYvcTfowmqqxC/QYogLzI
	 n2E3xBlmMGWRJEHlS4EEV97pZG0D1GrcDFH6wfFiDQVWfrbeJEJFb5HV0Xe8uOImz9xNB
	 nk2i3rACAWoectmi9ly0nreMFUz1tZVG1q8gdKwtCAWed46ejZHL6dg76fwZjTY+2Mg+8
	 T4xr7rUQCqcLcjQcNH7zVMqU8L6UaNdDHexNXR2FCBpoylUJy8B/XIVgUrzRQkaDbwefn
	 ee/V0tlOeP5Z9sd+lqbBl9pghPb61FHBhJioPvFkroBw9k0C+qyN4635gconQxEvANA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZQ/DXxgq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD0B606A31C;
	Tue, 10 Nov 2026 23:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQ/DXxgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63421F0093C;
	Tue, 10 Nov 2026 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794354009;
	bh=pYmj9P82h3mH0toZaIrqOD30rRfqgoFATEdZmKo+ic8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZQ/DXxgq/1nzzLRmf+wBdN0ecg8VeeRkWVoRvNuS3N5MDUf+Ynt4bRoztKQPIeEkv
	 rPZBA54ZLiGVmmp5WWmsuJol/+AqwJevjDocNBn4gOZCz3fvWjgwB+KKrWLKP83C4/
	 shieXjNsdbDzyIjHjeIVYkI1MmB1WeEZ6PpG3vt/Uc8vXfncc4YLBuV7FQ0lyApILy
	 V0sKeMLfMhPCPyVV2RJCTWvZcNbED79rem5P5ypt9l2QMW+keVL9yAlSCK+1JDVpkm
	 p7l+IVWJGf8PeVmeyClE6jqNm5y/BULooVF+FQX9UxFEPkHMeG7jRMjVyLIULgVieT
	 5BrUa9hpdbU7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D830C39E8A41;
	Tue, 10 Nov 2026 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3 0/8] net/mlx5e: Fix offload lifetime and exclusion
 bugs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179435400767.117523.810055396061956358.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 23:40:07 +0000
References: <20261105211637.1083978-1-tariqt@nvidia.com>
In-Reply-To: <20261105211637.1083978-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 parri.andrea@gmail.com, borisp@nvidia.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, gal@nvidia.com, jmassar@nvidia.com, jianbol@nvidia.com,
 kuniyu@google.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 prathameshdeshpande7@gmail.com, raeds@nvidia.com, roid@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org,
 steffen.klassert@secunet.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 Nov 2026 23:16:28 +0200 you wrote:
> Hi,
> 
> This series by Cosmin fixes several mlx5e offload issues.
> 
> 1.   Fix fs root table cleanup bug.
> 2.   Fix IPsec encap serialization bugs.
> 3.   Fix a deadlock between HCA devcom lock and mode_lock.
> 4.   Fix uplink unbind deadlocks by not holding mode_lock across
>      removal. All eswitch operation initiators wait for ongoing ones to
>      finish first. Unblocked by 3.
> 5.   Fix races between profile cleanup/init and IPsec policy/state add.
>      Unblocked by 4.
> 6+7. Block eswitch mode changes before accessing the IPsec context
>      during policy and SA creation. Unblocked by 5.
> 8.   Serialize TC/IPsec exclusion counters with a per-device spinlock.
>      Unblocked by 6+7.
> 
> [...]

Here is the summary with links:
  - [net,V3,1/8] net/mlx5e: Release IPsec root table reference on RX setup failure
    https://git.kernel.org/netdev/net/c/e8303b581085
  - [net,V3,2/8] net/mlx5e: Serialize ipsec encap reservations with eswitch operations
    https://git.kernel.org/netdev/net/c/b102f927c69e
  - [net,V3,3/8] net/mlx5e: Take HCA devcom lock before esw->mode_lock
    https://git.kernel.org/netdev/net/c/b7e98883eeb7
  - [net,V3,4/8] net/mlx5e: Fix E-Switch races in uplink unbind
    https://git.kernel.org/netdev/net/c/5eaf9931c8af
  - [net,V3,5/8] net/mlx5e: Fix ipsec core device access during profile changes
    https://git.kernel.org/netdev/net/c/5b310ae1eff7
  - [net,V3,6/8] net/mlx5e: Block E-Switch mode changes during IPsec policy creation
    https://git.kernel.org/netdev/net/c/d9e4ac08ea89
  - [net,V3,7/8] net/mlx5e: Block E-Switch mode changes during IPsec state creation
    https://git.kernel.org/netdev/net/c/0d09de8e4f11
  - [net,V3,8/8] net/mlx5e: Serialize TC and IPsec offload exclusion counters
    https://git.kernel.org/netdev/net/c/717dec565a5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


