Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D8472F73;
	Thu, 13 Aug 2026 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786622247; cv=none; b=qTBEa6XR6lT8267Q7szD26znAXeX2R5I8y4muFXv2U3029n71zSp9YVsGUEb+yfpklmnLHZ4sFQ41gvrX1ZE0S48i4UzPWq1UARadXF4CE/9NfDt9EwH6S5DaRM+BJOG9iT77gcsTqIGb/2yXg1h5t+opPo1mmSi7hZdL44Z82s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786622247; c=relaxed/simple;
	bh=VDKywRdqhHVksuVKLjJup5wycuCukSWksHIx0w4oVEo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rGkZPFkwSXAPHkOXt1i5brzLtsI8pqvz5cfMUWMJw0hCwLxFCrFcxSidNt8FOOTdyhV/mlRdlWMJss9nkevafG96CtyeJpAOFxDnf09rhTs6Q8ONcYoSTcyqt9Zne7B0ejH/Jc4WZ8g81s1hJYcCDZSqVqOcmC/DXA/BT3UILo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDd/BRlC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDd/BRlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34291F000E9;
	Thu, 13 Aug 2026 11:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786622239;
	bh=9/yz552XjP8xMCy0Y3X5Bn3nCTjPTJlo5ueOe9WaCKM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DDd/BRlC/nb33rMOYKDg2gAmD1elvrcxcHk37HwQ6A1B7fgPXz5FzPKE/jPwpOvUu
	 3SlwZRjiQGYz8Y859INPfXpPjhV4TnMIElZM/O6oMz2YZZAc8k+x6JCkJ8C3TP7kD+
	 BxEOnOD05cxyS+7Od2bF3/74OE4G++J17NCwaPvGRHwD+Fib/MW2KRCMim0NPvaHEC
	 CfNfbhSoh3zS/1JgIOtIil2TIr0xgMBc0eYOISSckC+1JcCiFKcMyQS5fxgGRfVriv
	 RlvqTmuWYCNc0S0WcGjHi8BU2tatGe+BcNMLJDFPjnVAac2EnMbafcFGx6MCbF/9SU
	 h3xVo1Tqq5ZqQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 197F0380CFD7;
	Thu, 13 Aug 2026 11:56:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: mana: Avoid DMA queue allocation
 failure
 under memory fragmentation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178662219370.2393133.1968964194642913945.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 11:56:33 +0000
References: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
In-Reply-To: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
To: Aditya Garg <gargaditya@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, shradhagupta@linux.microsoft.com,
 kees@kernel.org, sgeorgejohn@microsoft.com, ssengar@linux.microsoft.com,
 gargaditya@microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  7 Aug 2026 13:56:34 -0700 you wrote:
> The MANA driver can fail to bring up its queues on systems with high
> memory utilization because every GDMA queue ring is allocated as a
> single dma_alloc_coherent() of the whole power-of-2 ring size. Under
> memory fragmentation these high-order allocations may fail, preventing
> the driver from creating queues when opening the interface, after a VF
> reset, or when reconfiguring channels, ring parameters or MTU.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: mana: Route ring-buffer access through offset-based helpers
    https://git.kernel.org/netdev/net-next/c/1da1a037bc60
  - [net-next,2/2] net: mana: Fall back to scattered pages for GDMA queues
    https://git.kernel.org/netdev/net-next/c/23adfc77c22c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


