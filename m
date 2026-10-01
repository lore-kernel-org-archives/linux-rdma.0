Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800734F24E;
	Thu,  1 Oct 2026 01:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790817015; cv=none; b=b020v2YxjCYEiDuQVlC3CqET5WtLhG4IWeKWVNzbWh+kCPNZbJyp7j5Z+kyJV2JcF3WD0MSiO/Z3uZx2ZqMfMwrOI2npaPGFJmRkL61IXqoqZ4sVAaYVnZv4pE7ZaFvBlH6JzAXczjuTuDC1oLWP6ZsC2cPTziF7GyP1ndCQrh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790817015; c=relaxed/simple;
	bh=g+8LN7aRVEwIB/kJEhZmt4SF+4i3wUn30jchAukfEko=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SE1o8YMihQVYIUyDT7XKvyf95IwbsrqVY+cwqL8Q1HPqlXWzFptY/K+RehPJVCj1gfZplBUCCpCz4HDT7Vv554OZWpivE+YOPL562y3gKu/+ZSgLWIeLEKPUm0QAWIUsi5VGdfFFLsD8X0lC8N+h4OGqGCvqD5lxAggiZPA7Sa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW32Rwpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW32Rwpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8D1F000FF;
	Thu,  1 Oct 2026 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790817011;
	bh=5ZzwpWnJAA51L6P5ZLDGxna7Zxy3b1JYMInm0UP1QOg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mW32RwpxPoDvUcKskTofevvtzVj1EuQYtkZhHB7fGmtZ+Pvky9TQmvgVh3NznO9V1
	 Ybk8w6XWbVIGhC8tpCZHkkaqV2rS+btG9t13NLHTln5C329Fcyxi86DFkUk/4ou0uF
	 BFA8vHTSrYkuZzrLTaENU8eGrrPWeMkBJaikzO+Eo+zVitfU7gWQzrNd/rIRl723eJ
	 fDwHZe2NGqoD9XSf6W6SeqVW1+87AHv58YyRvM5+ujJQoz88fj09gmCtykJRdnwldB
	 IEYCzLbkLlIqzWo8BgdPBAr56Bf88SkEVkMqI/8Zz8CrR8iJ96xWiW69sZQSQwfLvR
	 A/jFV50MuOkbQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A2BD3AA6A61;
	Thu,  1 Oct 2026 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: mana: Add support for the CDX bus
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179081700977.2200095.10074995671789811332.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 01:10:09 +0000
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
In-Reply-To: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
To: Manish Awasthi <mawasthi@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, nipun.gupta@amd.com,
 nikhil.agarwal@amd.com, gargaditya@linux.microsoft.com,
 ernis@linux.microsoft.com, kees@kernel.org, paulros@microsoft.com,
 mawasthi@microsoft.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Sep 2026 17:30:50 +0000 you wrote:
> This series adds CDX bus support to the MANA driver.
> 
> The shared GDMA and Ethernet code currently builds together with the PCI
> transport. To add another bus without duplicating the driver or adding
> configuration checks throughout the shared code, this series separates the
> bus-specific operations and builds each transport independently.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mana: Introduce gdma_bus_ops for bus-specific operations
    https://git.kernel.org/netdev/net-next/c/c03e69c95a18
  - [net-next,2/4] net: mana: Move PCI transport code into gdma_pci.c
    https://git.kernel.org/netdev/net-next/c/34520ae5dd57
  - [net-next,3/4] net: mana: Build the PCI transport as a separate module
    https://git.kernel.org/netdev/net-next/c/445927de07cd
  - [net-next,4/4] net: mana: Add support for CDX device ID 0x00C2
    https://git.kernel.org/netdev/net-next/c/3d6792ea4605

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


