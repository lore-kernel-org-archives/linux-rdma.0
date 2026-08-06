Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFAC3A3E76;
	Thu,  6 Aug 2026 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785978049; cv=none; b=akK325GK9wMoVVG4oZXDr+HZdY4EoNJO0el+uMVo3COzju7Up7AMT+zDKATwKY3If6mGDJhYZCIHbqjIrLOzb5FzBu39xXOCSAmrDreBUR7/8Z1mXXx3d5+M02Wv+ZXrW8yHDQkx6Mdd+rQIQLiCox2sL1vYZM2QekmcQ6BuO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785978049; c=relaxed/simple;
	bh=JPSe4gtzrnNKCtsVpBlFpB78qbxuJl4LwYtidlJXc4M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pNR/IXJMerQnmSgBILKRJfjJKVNQtLa/D6dUMqMaGCEwePiIL/nV/biycJkcwYZffx7k38DV0hezMt7ZRodYuwSzCQBBc58WHzX5IPKiArhOYPrzPqWjKQDiayIk4nYiqiGlIUvwNuZUuakZXOA9N4MmK7dRZmdMNl2SgesLcIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaPitzFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaPitzFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACC61F000E9;
	Thu,  6 Aug 2026 01:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785978046;
	bh=deXZf2iP0pJLp8jHsfbRp9M1K6VBz3PRAbbG55ymYvU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kaPitzFWLjmidZPE3QGPeyvcEl7enWD9nI6Hd7ao/5ZaTD4AV45bzBcxCXEM/K3I+
	 /UscES5v2xo4YFoWWpuJBQw1K+GxbHbSWrsjBWVrB3X3A/Pk4F4A4+xVZAODvf5iP1
	 7lCqdRTbNLDaPB3G2psptJ/CiUlVDEmnF0wIKbK4Rk+66x1N9DqRPtj4pyYuGHEqvA
	 Ek2jkl0eKkI/vI1ks/V6TEfjJHsjLZo3LBnLtSvUdtm7Vxw8q7zLDHX7158kUmwPah
	 S1NHOyKxMZk/bvQtr/XnoCeCmu+r/JM3xYu6sK4NvkeLnWbFXLyXG4YvmglzbjthSU
	 7foRL93xtt/aQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 938E8392FFED;
	Thu,  6 Aug 2026 01:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178597800612.587098.15592056106593550050.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 01:00:06 +0000
References: <20260730124227.167829-1-hidayath@linux.ibm.com>
In-Reply-To: <20260730124227.167829-1-hidayath@linux.ibm.com>
To: Hidayathulla Khan I <hidayath@linux.ibm.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 horms@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
 netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jul 2026 14:42:27 +0200 you wrote:
> dibs->lock is initialised by dibs_dev_add(), but a dibs device can
> already take interrupts before that call: ism_probe() runs
> ism_dev_init(), and hence request_irq(), before it calls
> dibs_dev_add(). No client can have registered a dmb at that point, so
> no dmb interrupt can occur, but a GID event interrupt can, and
> ism_handle_irq() takes dibs->lock unconditionally on entry, before it
> inspects anything else.
> 
> [...]

Here is the summary with links:
  - [net] dibs: initialise dibs->lock in dibs_dev_alloc()
    https://git.kernel.org/netdev/net/c/c27e36054537

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


