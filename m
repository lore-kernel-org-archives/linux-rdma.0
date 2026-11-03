Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695806;
	b=XzPZMvWzooUadZjaGcGCWa23zLzTAXbdNlHcSRFnVfu9sf7lZgEr/xJJ5kiVbk54cnj8
	 72Ja+GGm1N3dVPMNXj4V301ZpoHa3ph3/P2EZpnmFjM0FadHNNCB2mQS3mvDy9kT16shC
	 pI/vsVjHGLg5VXOdJBOb7x3M8FajbWb5Jn5/Xl3W7wKyrXdI1oVqAK4oQWKsdRbMLE3Ef
	 8+cuCPktfjZYjMEJhdw7pyBQidDtO8nBZRKY0RqaKavlfH3smceZ/DTkPgJiiV4oNdd/W
	 4SV9zDE0nNPtr4Q5zkdxMFLYf/i3r0ptQkf5XMx1XWf2s0Br5ycxLaiPJGU5i8hBLrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695806;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=GyQHYJt0q/Kn7YL2+GIJ0OLYBR8UxcA/Z+QiexveRco=;
	b=O2NqfdxFORbqDlzg4WOVUi2APlHcIvYlAFV8y5hAh3t06g1HD21buNoXqtWpfwX3GSFJ
	 OCNYmkKGZPbNldjdAacyPDRxZe/fgD41NVqvpLc+zSgGWqJnNu++Kz/Dybx0qm5Hv+FJO
	 O0IuBrk0M33UadMn5aW64KLjS/Fcfg/3Udyit9iOokPO7RxGQD64EEfiFgCpi0S6IE2ej
	 wLRSkuSY+bRtsFjiBzMPsyDCST0067sgqg/mgrGnwRJmiHm1kgpuBjvyR+uNRaV4G9GEC
	 RzBYCv1Z8WCHJXf5VCVHwCljRHpE5apowcG6C0+qY3e44kkk10aU8G1pLw6tu870e5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVKtc025;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54434606A33B;
	Tue,  3 Nov 2026 08:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVKtc025
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6501F000C1;
	Tue,  3 Nov 2026 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695805;
	bh=GyQHYJt0q/Kn7YL2+GIJ0OLYBR8UxcA/Z+QiexveRco=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mVKtc025k0rxhpVk5WpC8vQbLe8lMH83f2/LqFBAM7xQxIBUFfTiVfAPqiE059Z82
	 n8k+i1P1ghT6eVoGB47NXhrvUFN8dyWOYmCyHHYm7of5cy/mA739Gk7prRSWpq+Nej
	 atAiozgY8Vl/kXau/Tc4JT1fJf/QpZMkpD7P/7Zednc66mdQ4Ew3BBTlcPM37wD1Nr
	 b6M5daRMeE4ZflFox3Vx8WeaiB77q8AlMwHIcgio81kJiIbXAm4Xp7kjxRmvnQdKxK
	 z0AIBWpql09XFTKIjgCrcvP9E47OWhm6Uy4yHzH2IX1jd97U8vQw3VyBe8tnA/fS7W
	 IvQWONdIN3TCw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D20338068DA;
	Tue,  3 Nov 2026 08:50:05 +0000 (UTC)
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
Subject: Re: [PATCH net v4] net: mana: Add support to process throttled EQEs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179369580430.954311.1075997352976469360.git-patchwork-notify@kernel.org>
Date: Tue, 03 Nov 2026 08:50:04 +0000
References: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
In-Reply-To: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 28 Oct 2026 03:40:17 -0500 you wrote:
> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
> 
> [...]

Here is the summary with links:
  - [net,v4] net: mana: Add support to process throttled EQEs
    https://git.kernel.org/netdev/net/c/684603842b78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


