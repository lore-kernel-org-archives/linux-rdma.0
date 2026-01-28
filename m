Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCF2248896;
	Wed, 28 Jan 2026 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564432; cv=none; b=nFEFnex/vAIjK/8S0mX1Tqposagf04EFyZ8u3J3U1CJ3QXitOTNC+PtkgkHOG+3hEyRN3nQiALsVH5hl87qFZuApcTkTy7kzW8qTwE9VZQd6ysCEBpeENYrhk6aVvGeEvdxtWtTj7npZUz/9mkjtjTDWmz4EL1u4Tgs//A4FO7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564432; c=relaxed/simple;
	bh=0MzrBwfqwd2535szBhoY5Lpo3l1m+ZEscu++8BOriJY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QNhGfV3GFMH6ajdA7QE2Yomgs5Ml44D2hEUYbbC7wTquSYLogkf39xHEPZPnl1DGXPf/IyedGbZP94g1PJfiaekr2O0a33iSuMR8zx12PKMrzlWW7CZXB0QgqTaPxUoMCi9yz69vZMtaGbGwP8xB4sKp7IqrSbawL+H0TPCUfl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eC04OvQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eC04OvQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F5AC116C6;
	Wed, 28 Jan 2026 01:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564432;
	bh=0MzrBwfqwd2535szBhoY5Lpo3l1m+ZEscu++8BOriJY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eC04OvQofWffpLZa/RJwnNhwfX01OwqqX7yhl9ZbizIImls45Zm8Mc2AYVd6V51kU
	 WQsLLhDEVhqVkNoNDshvjQrP8xYRrz8X+TSr2vYRKwnFD0HWh55wRX67Xv917NMgdM
	 83XjhSD6zZT9jltlPxBiiIp5HvLakbtxS3vupcCP1nDXIugVei2Pc2Gsykw87bb+bJ
	 vy2lEiR+UUFtjN0JuUfGdzGbT7nXYHZuucMpYAPDzaCR+zxKEh1N5TdNiIJ9IHM/2V
	 5M1m83TGGX6dE5fkVbgHLCQh1BgG+TNau2HBqyMPLaZltWqoV12TnNAMDo4ogeLAzE
	 mgpSJtzwfVxgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11BC8380AA76;
	Wed, 28 Jan 2026 01:40:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Single MSS length in UDP GSO_PARTIAL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176956442559.1470424.18099813661797092324.git-patchwork-notify@kernel.org>
Date: Wed, 28 Jan 2026 01:40:25 +0000
References: <20260125121649.778086-1-gal@nvidia.com>
In-Reply-To: <20260125121649.778086-1-gal@nvidia.com>
To: Gal Pressman <gal@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
 irusskikh@marvell.com, borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, dsahern@kernel.org, horms@kernel.org,
 alexanderduyck@fb.com, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 25 Jan 2026 14:16:46 +0200 you wrote:
> This series addresses an inconsistency in how UDP GSO_PARTIAL handles
> the UDP header length field.
> 
> Currently, when GSO_PARTIAL segmentation is used, the UDP header length
> contains the large MSS size, requiring drivers to manually adjust it
> before transmitting. This is inconsistent with how tunnel GSO_PARTIAL
> handles outer headers in UDP tunnels, where the length is set to the
> single segment size.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] udp: gso: Use single MSS length in UDP header for GSO_PARTIAL
    https://git.kernel.org/netdev/net-next/c/b10b446ce7ad
  - [net-next,2/3] net/mlx5e: Remove redundant UDP length adjustment with GSO_PARTIAL
    https://git.kernel.org/netdev/net-next/c/8d2eda97f464
  - [net-next,3/3] net: aquantia: Remove redundant UDP length adjustment with GSO_PARTIAL
    https://git.kernel.org/netdev/net-next/c/5b4015ad833c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


