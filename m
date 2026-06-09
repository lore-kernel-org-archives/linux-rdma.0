Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801A35F19A;
	Tue,  9 Jun 2026 02:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780971011; cv=none; b=XnzXzwlKQ5bVPSQLuzxE28LYDXZ1EHfEL5MD0F+qqIYhQLucnh95cX2v4IVh0rdyzMzW2ha1vuOju/5bByxlOlpWYdfSntlzwI3drPm9JMaDljeRK8Cnz6q9cI+yrWGIW2VZkjTZ+ulYN+F+J2YZ2AI1AFuP6YA0hhtkc+K4e50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780971011; c=relaxed/simple;
	bh=Ar1w9kVAbq3PHZNTNAOLwotNI2pSC25Ge7nmLYLhwUI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=aPOvNfoWWGCT5AUnecwybUIMUDmG7GHl6E0AEok13rmSTomP26/amFZgLnDV6jIzvh9G8rl2Wl+ybBcAjlPTASRT1/tuM0jnbqVcR2S11Xon+6vgHbldmj/u8n/XmtHzcMoFgbxbjv6lrhqgv6sk0ybDGIwK0vhMjncLXlFEA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkF2lViv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkF2lViv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753BD1F00893;
	Tue,  9 Jun 2026 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780971010;
	bh=Rzxy10RzrAL41zuZhgmx9mUGWkmCe8/cr7JEtfO7M08=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mkF2lVivTsmb2xt/TXAeWlpLXG5Spo+RorFQxcTyAxqDk9LI/Xg1Vmf4sqXaGxrax
	 uok0lTAwmg+y+0G07gATZ0htPd/XdZ4oHoWAvKPuZaVn2hT7IjPt+CdePvljlRaQNz
	 0RLvChTHNFwgO0gKaslqY9zqA+pzECVVSKeVScK+CqZzZbzTYJ6TOv7AlQsAzygcbb
	 VA2yuD3cfgz0XeF1i86AD8MRxow2jV0U1oqWYJs8ru7iw1d5hntGHa2+RsP/A3pMUW
	 k1l8DHIeKotHzpTbxU9osKrR79YSGZkhjyYBXhdYbVGsm3nuzpSWGmASVL2JDEL0ja
	 HHRHCRkrdfEsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5698D3822D43;
	Tue,  9 Jun 2026 02:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/mlx5: Use effective affinity mask for IRQ
 selection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178097100888.1755698.1245249271485137584.git-patchwork-notify@kernel.org>
Date: Tue, 09 Jun 2026 02:10:08 +0000
References: <20260605102112.91772-1-fushuai.wang@linux.dev>
In-Reply-To: <20260605102112.91772-1-fushuai.wang@linux.dev>
To: Fushuai Wang <fushuai.wang@linux.dev>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, shayd@nvidia.com, parav@nvidia.com,
 moshe@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangfushuai@baidu.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Jun 2026 18:21:12 +0800 you wrote:
> From: Fushuai Wang <wangfushuai@baidu.com>
> 
> When a sf is created after a CPU has been taken offline, the IRQ pool may
> contain IRQs with affinity masks that include the offline CPU. Since only
> online CPUs should be considered for IRQ placement, cpumask_subset() check
> would fail because the iter_mask contains offline CPUs that are not present
> in req_mask, causing sf creation to fail.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/mlx5: Use effective affinity mask for IRQ selection
    https://git.kernel.org/netdev/net/c/a7767290e77c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


