Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065D9339397;
	Tue, 22 Sep 2026 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790037676; cv=none; b=McDy9KtV2h3d6ETp75fAaTWrgT5xio6As49A7FibFgvH5VdojDtaHJypmBqKPLEyIhkW2YgUi8E4ybRdrZ7S3OJMuaRSyILYnF4zUBhaJGts9oyIp6D6Lb2WLsNnblCmkhZdWZ5bZE1yUX1H5BMCW3FziobxYzp0lyI+k0StDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790037676; c=relaxed/simple;
	bh=0Bo0/+S0gJNb1SBL8Y40e6Z9Z1hJdGn3XWsUUxoUTFM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=r9KAZquDvPCPGP5GE5YLUh08cVKyPFQ7qabK/cWg3fR0G7/t/ASHzlKdCEIgyriMxQ6Rxqm1GwqLUKS8IX34SQV1WCl6tigMMWxbyc5CcktJcl/uwBVoObiuizBZ8Dl5oiODabJeGRUykEuK3zXN0x8b8oT8Wpg7ox9V9DnC6EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdZaARh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdZaARh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76111F00893;
	Tue, 22 Sep 2026 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790037674;
	bh=vFoOdLWpeouXAKTXC29Lcgz895gDX2VnGVk2ypEUnnA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=QdZaARh+mMe7WeLdoVfViVHVbV/8QG26HGt9Dzy6CEMWaOlyz+fS1TBV1z1vfx5Vm
	 5F9ICjOSGTRoVjAmLo7glebr8qIO0Qv8FUUBVc/nGy2BAMv30pVRgqJg8RqgBanyKh
	 F5TBjCHO2pr5zQrDF8lKtLaYhi8EpAleF0ABH+Ai+nbJ8WV9KZcIsUA1J0BF9GZElr
	 FXsJlCUn0FuE4GAZLk/k54AUuXfcQ8fcSAyGJgGSyKKOQTChsAnooIdcj3tVpLAnZm
	 677GnuWBZzBDmSxPpzfNl2hvO8fx2OguTQTG2nrR+owcw4DUIvMkVUKuU3t23d3nci
	 +HgVgZMoqjBBA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5690F3930203;
	Tue, 22 Sep 2026 00:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: fix swapped IPv6 IPsec policy masks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179003760589.3308999.11419915267212348533.git-patchwork-notify@kernel.org>
Date: Tue, 22 Sep 2026 00:40:05 +0000
References: <20260917115542.177675-1-parri.andrea@gmail.com>
In-Reply-To: <20260917115542.177675-1-parri.andrea@gmail.com>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 michal.swiatkowski@linux.intel.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Sep 2026 13:55:42 +0200 you wrote:
> IPv6 XFRM policies may use different source and destination prefix
> lengths. mlx5e_ipsec_policy_mask() builds the corresponding masks
> independently, but setup_fte_addr6() installs each mask in the opposite
> address field.
> 
> When the prefix lengths differ, this makes the source match use the
> destination prefix and the destination match use the source prefix. The
> resulting hardware rule can both miss traffic covered by the policy and
> match traffic outside it.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: fix swapped IPv6 IPsec policy masks
    https://git.kernel.org/netdev/net/c/10de7ed8ef48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


