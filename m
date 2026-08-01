Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743B39F17F;
	Sat,  1 Aug 2026 01:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785548455; cv=none; b=TgY/g1VDg+k+sdePHi4dnpZNpkPdL/jMYf9Zz2vPC2OIdQnmPisn+OLdaBySfVR9ST95S1u0+TANXLV2puWKSE1GVSntOJ4tGDGtCSj/6w8MU/J6RiRUGz1IGKExfHSGqWhDAgQx+ArEZyel8ZoE1JZ4GSEoh+TbkUNQA0l8Y+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785548455; c=relaxed/simple;
	bh=2trGTDlprEq/8cK2f+MJlUDAZ0ykfBTW+JYdfCrB8Qo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sgOCvD0qKITFCDgvnx3ZbTgmMxWkdaZzZ89x3cD1iIWGdaw9h2fQX9scge66X4tHObYAtac8clMF6j+OYSSiSNM9aB7L9aQ6zrYXmMRrhXpL/PwYy+PrD9zdNyd61MziZGgSsRdwpkAkdIZVieMYG+w5jCq3y1HvPRbTMD4D2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2NMSKrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2NMSKrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1511F00ACA;
	Sat,  1 Aug 2026 01:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785548449;
	bh=8Zg+X8dJdM8ehBZyXsR3JybXA2xd1RDPn1z971PjA3c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=J2NMSKrzLdlgTZ94PeZvBTl0SJPtIANN6Lp+W7KqSRnEyD5xDqY+Zq4Lin/umnrSS
	 C7wY1kSDAFD5mGmlzojhaUBOX/M695WvNRKrAc/O3NOJbPlPT/568jmNoTFFC2lkA/
	 NsRxfm8EMApZgyJGRxdUhcMjC+CKHZk5RU+vz2Qpv6OGVnaYdmrzSehoOuNjS8vknC
	 WpztdGjUQSnfg5d6yH9W0oh/dm7Vf2CWwTG0iAMqxrxQpiAxCKSxjRbgXZxkLFTvqj
	 oOB/ca1JfhdhtpDQblwVCAPez2n6kQo/UT/1TooEnKiPOl8QVi2pE47L53Dq100+xU
	 lOaqVsSxJS+SA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19707392665F;
	Sat,  1 Aug 2026 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: SF, Handle function changed event
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178554841163.979996.4193524131442298594.git-patchwork-notify@kernel.org>
Date: Sat, 01 Aug 2026 01:40:11 +0000
References: <20260729071622.2423270-1-tariqt@nvidia.com>
In-Reply-To: <20260729071622.2423270-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, cratiu@nvidia.com, gal@nvidia.com,
 kees@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 parav@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, vuhuong@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jul 2026 10:16:22 +0300 you wrote:
> From: Chris Mi <cmi@nvidia.com>
> 
> When host is powered off, firmware does not send vhca_state event
> for every probed host SF on the DPU because it may have deployed
> thousands of SFs to the host. Instead it sends a function changed
> event. Currently, only VFs handle this event. This commit extends
> support to SFs.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: SF, Handle function changed event
    https://git.kernel.org/netdev/net/c/43e970d961ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


