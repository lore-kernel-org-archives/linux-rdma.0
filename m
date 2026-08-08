Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3A1D61BC;
	Sat,  8 Aug 2026 01:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786153256; cv=none; b=iXMGBWZMEVYkrOMPVdTyorjKr7oF2WMQDJo7jGfSo/LpABAbJQJqGmcjcEm3gE5vaSRoTF2qk3zIV9KhtOODxgPPfiNDOr50+I+8VyH7H5NSx6f7Rei8V4MnhJNRc6tg1z8WSWDKmpHmFODyWUh8Xqr3vSyluFSttHYP81k4ID8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786153256; c=relaxed/simple;
	bh=4A94kzJ2MRWi1gSe76j6gFHh3DmsFJsVRSxq78BfUQw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pmEULNA3W0AofktO34EcDK7bVhyFV/4kBgEAI1zaVkpGSU49FRlQzQeghX9u0WTPbHk1SqsfVr4yRMLdOmaqJu9aLmsyR2eTipAnOxvwH9Hzy7irJmQIRchHTSNLjS9C6pF+Irj/aGWPgoqOd0MxVeY31gzxUObZoBs8FSGj2q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2YfOh1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2YfOh1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36301F000E9;
	Sat,  8 Aug 2026 01:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786153254;
	bh=IHIXuXRdIPTKhEay8m4BmOZHs4ncZ7z4Du8deIqZBPY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=J2YfOh1cnJ3t4el4LPxlspRvz9ZWe0Cjx9YIjsN4BSSg7Z0mcYFyvy8drqU3vXT2g
	 Qq8gLLB+7CKYpcXwX18S11a2lw5xCA4yDnJ1HDON5hHTQ3XAWVJIGLwCCJ2IIEBkop
	 Kkw239gUhMSFYXiguFTr5e7PfAdm11eDu2tENUUQqs/NCXoq7UEnjaw1rfJgnmwxB1
	 5AAhyhBbd2xSOUzKDoosf4p+GkBLkUvfzWIMHw7+Y5PVR0EDbjm1IRO7GitTg6Im1H
	 x9mIFoMRAtBCx2aWnFWSkx1aqGKNJsbJIwtW3Ao3K4+wK8mobDi1KjgF+UPY3XJTZ2
	 cMoDI4yRwiNPg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5694F380CEE4;
	Sat,  8 Aug 2026 01:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: mana: Extend RX CQE coalescing up to 8
 packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178615321289.2493713.8444046585409083595.git-patchwork-notify@kernel.org>
Date: Sat, 08 Aug 2026 01:40:12 +0000
References: <20260805185404.1052177-1-haiyangz@linux.microsoft.com>
In-Reply-To: <20260805185404.1052177-1-haiyangz@linux.microsoft.com>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, gargaditya@linux.microsoft.com,
 jacob.e.keller@intel.com, leitao@debian.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, paulros@microsoft.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Aug 2026 11:53:51 -0700 you wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> To support up to 8 packets per CQE, update related CQE processing
> code and structures.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: mana: Extend RX CQE coalescing up to 8 packets
    https://git.kernel.org/netdev/net-next/c/55d20f50a221

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


