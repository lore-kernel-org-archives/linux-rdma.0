Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660893C1413;
	Tue, 21 Jul 2026 09:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625043; cv=none; b=lTPZ3IDt2HPZFANSoz+UT1u6V9v3J+ATupKX2BHdWPoRGEuJHBsm7YCar3dO48fWBCXx9UjIP9CQ0ZQ079W6srAHJmZQnP6Y8mzKuy9Lyeb23vj0JF5jdl1reXpCzcFrcODWqoNPQvebS+sU6yWSGSpfws70W8rLvCtklcOnsNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625043; c=relaxed/simple;
	bh=KHKIKATEyak83j5SIRabn/2UjrCX8kWTQ4irjkZh7wA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RN3p/xE4uqIlEJZX1V/lH38qrV69ZUjVjjMsxQ2lertMdS8SVzDQ+Rr4xNP4PPysIMOj/RwXGfg5JbdG+GOGjjeYdbs96DkvczO3BChcz9TZDAij8M1KaytGs8JqBBCi8EjhqB81Xb+MruCNgO7QL0WwRQdxEHXJy+qFPJbrfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8S2YEmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8S2YEmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139B21F000E9;
	Tue, 21 Jul 2026 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625042;
	bh=hnhYA46ozRSFpvMkIAc06SAayAAL5T7KALnvk4A8eSA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=H8S2YEmJ+QiAcb+6VOU0CpW6/fJI81YXGGcitrt3eEUZ+XR9Ts1vcVA9JBhu0+JA/
	 o/QrAs1H7oar1Un/FaSeuxum82k5wLgpaXHrveeJmaEoa2khFYT461ZgizENIFlb3h
	 /T5f03oC6bBNDyv6/jx50q0HPzw2sl1Jr25qkPvLmcz7LGF/syAem6FLirYUSnCLNm
	 CN21vaXGkZQs6c0R2sE9KQGl2EEDdKcz2nu8ozZ+vMA172PGo7lxZjC3VN06gcYc+r
	 gQbQ22d+RvmVfnu07aK0P1fMFXlTVjXBV+1e2vKmLU7xWCrZShWbj+fRaWQa2nWXTv
	 JkmyZPutugIFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199693924A44;
	Tue, 21 Jul 2026 09:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/mlx5e: Use sender devcom for MPV master-up
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178462501164.174171.13160914545976929275.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 09:10:11 +0000
References: <20260707233911.3651139-1-manjunath.b.patil@oracle.com>
In-Reply-To: <20260707233911.3651139-1-manjunath.b.patil@oracle.com>
To: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, phaddad@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  7 Jul 2026 16:39:11 -0700 you wrote:
> After PCIe DPC recovery, mlx5 reloads the affected functions and
> replays multiport affiliation events. In the reported failure, the
> first relevant device error was:
> 
>   pcieport 0000:10:01.1: DPC: containment event
>   pcieport 0000:10:01.1: PCIe Bus Error: severity=Uncorrected (Fatal)
>   pcieport 0000:10:01.1:    [ 5] SDES                   (First)
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: Use sender devcom for MPV master-up
    https://git.kernel.org/netdev/net/c/e32649b4bad9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


