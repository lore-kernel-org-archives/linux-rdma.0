Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69671E9B1A;
	Thu, 25 Jun 2026 02:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354627; cv=none; b=XOChQRk77ACSojsEOgKmhJ9RxD/ZXKeAEeid+kDPePK4tPkomzEUcsXku0CEWmHpYS2umfTOUzIIScSAdTCWUJVTKrRQSTyDvZvrHak2ssR5RqBBi/mM4WkxY/ad1YLPyTt2SLnR+3r0+QtXiMVwVuJinG+0pl9rgfVrAP+4/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354627; c=relaxed/simple;
	bh=7iYkk8y6Fl+w8ovQoLHaKhe5T5ygMg587cWSuWWQJyc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=i6VBmU9MDdyD/Eo8gxXl0owqJR5vM4rzx0YVAA4dyZeYGc7KEdxbdC+GKVJ5kn8PAPc9wAF1iXBNsNe7eOCZscowSiIzHVSuvKnxowb96+DuEcLR8Ohb7Pyn/oYlztcp+jnVM5H//fmHbC9UZ03WWXzt3I0mQNJHLALchaMcAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ampBiOQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ampBiOQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634B11F000E9;
	Thu, 25 Jun 2026 02:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782354626;
	bh=mx6lDxibRBKnV9McTUCEfClyqAAJhAcv43UNZJYFLow=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ampBiOQui+23Z4FRDLeuyf57DopNepY7E6xrfWAubAyqeBjlfhGPzJChlW+Japn3I
	 XypWOrHM0RI/b1qaDLMM00aaoNL05C/HiAvYBOVtOFm7RIOSnZKiYC+rBhJo9TNi6K
	 5i6/civOyx9t5fz3R03muVsuXmAnLwHR7tySKpIROFkJ33m9UfqQySZXGHkE+oOiXH
	 NTbRnHBrCgzfcAt/kTvEROrLJpfgqCnRGytMG7cpTCA7JizsCuQFJlZSTL8i6ECEqi
	 wFKmeBdn87LqtlnbmMWkBN5g3X7S4m7zi72Ih5aED+jSLWYMAc6T3mvMUPcmQXcKgv
	 WloSdTCS5146w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BFB3AAA6DE;
	Thu, 25 Jun 2026 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net] eth: mlx5: fix macsec dependency
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178235461433.3088510.128149227233180114.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jun 2026 02:30:14 +0000
References: <20260622124229.2444502-1-arnd@kernel.org>
In-Reply-To: <20260622124229.2444502-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net, arnd@arndb.de,
 daniel.zahka@gmail.com, rrameshbabu@nvidia.com, raeds@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Jun 2026 14:41:07 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Configurations with mlx5 built-in but macsec=m fail to link:
> 
> x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_add_gid_macsec_operations':
> macsec.c:(.text+0x77d): undefined reference to `macsec_netdev_is_offloaded'
> x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_del_gid_macsec_operations':
> macsec.c:(.text+0xe81): undefined reference to `macsec_netdev_is_offloaded'
> 
> [...]

Here is the summary with links:
  - [net] eth: mlx5: fix macsec dependency
    https://git.kernel.org/netdev/net/c/87ab8276ed24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


