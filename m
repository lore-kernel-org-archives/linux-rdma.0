Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E81A6839;
	Wed, 10 Jun 2026 00:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052024; cv=none; b=PkRC/MlCCz3eH1LgpUYAIFNZHoWE4HDQKoVltCvrCW8C5Uw5NAt3AsnxPu1UAmI08fr/NZscost9/ajnOnSvDtHKTyR3GEn3tqOeqJ/AwJ/0+CtBujnmi5aqnqZ6NIxP9b8UKGTb2C3BldQF7fkNnOTp3YFIHZvADKdSeyJTmEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052024; c=relaxed/simple;
	bh=GNtruyY3bNPBssViOYW5EzehELt7YIr9EPaQxYU1H/U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=u0990l0NeGCXM2BjcaOimcMHP2NByfn/EZDDUc/cmnrnAvbM8xTZgude2504OeCo6opeYhXiSsirvShEhs66VXKWJwdqOteTZGH55j6jnsPrwpIuaEcYxSERedbth/8oMaYEhHgs373FD/Z0R1IXBTczyNKXFdcxXfBD9WYXOzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeHvRbo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeHvRbo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF51F00893;
	Wed, 10 Jun 2026 00:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781052023;
	bh=r2C275by+jKlR1Fdq7UgN01NONI8D6WcfVWSM4gOhTA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XeHvRbo1+h+ud2RjcKhkrzummeJVjUbbsIo+LJ5ZGj0PedaH6WR/UZ7V/v+po2cWx
	 zhH+aE33hkNkd0sCOwuLmxRsW4qOJTDT2YpeOlOqH4DlmHPZOKDq01o9mBjv31Z8oW
	 SX6UfRazMlx9MXr4MeEet3v+FvT3WrC6SVFZ5/aJH/fhzZf0QmqRaRYf4tS/gUgaYm
	 f4Xpuua85wQJnk4HQGBdi8D4txPnssb1hHgT1277vfWIPuLNvTUmLL2SIcjwE8q5Ny
	 4EZctWv8UvQGvALdIzGILw6aWxt3KbGqylZ9foOhSXiPg3mKSI87LT1BrazpZK3u4Z
	 9lJcNo/cdFtfQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A7F3930A0F;
	Wed, 10 Jun 2026 00:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v12 1/6] net: mana: Create separate EQs for each
 vPort
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105202111.2767403.16646247458376850244.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 00:40:21 +0000
References: <20260605005717.2059954-2-longli@microsoft.com>
In-Reply-To: <20260605005717.2059954-2-longli@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Jun 2026 17:57:10 -0700 you wrote:
> To prepare for assigning vPorts to dedicated MSI-X vectors, remove EQ
> sharing among the vPorts and create dedicated EQs for each vPort.
> 
> Move the EQ definition from struct mana_context to struct mana_port_context
> and update related support functions. Export mana_create_eq() and
> mana_destroy_eq() for use by the MANA RDMA driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v12,1/6] net: mana: Create separate EQs for each vPort
    https://git.kernel.org/netdev/net-next/c/fa1a3b7bcd16
  - [net-next,v12,2/6] net: mana: Query device capabilities and configure MSI-X sharing for EQs
    https://git.kernel.org/netdev/net-next/c/d7c253d61488
  - [net-next,v12,3/6] net: mana: Introduce GIC context with refcounting for interrupt management
    https://git.kernel.org/netdev/net-next/c/d478457fc1b7
  - [net-next,v12,4/6] net: mana: Use GIC functions to allocate global EQs
    https://git.kernel.org/netdev/net-next/c/346c277d1db8
  - [net-next,v12,5/6] net: mana: Allocate interrupt context for each EQ when creating vPort
    https://git.kernel.org/netdev/net-next/c/487af6f5391e
  - [net-next,v12,6/6] RDMA/mana_ib: Allocate interrupt contexts on EQs
    https://git.kernel.org/netdev/net-next/c/062b2b051f14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


