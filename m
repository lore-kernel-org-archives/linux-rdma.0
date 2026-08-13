Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D9435EFE;
	Thu, 13 Aug 2026 11:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621266; cv=none; b=TEgJgx7tTgng9gRiyPvz0wI2OEzpMdmHS1IS4pvs+wrkv1t6lxVUoFzeGnjlTduebnSE+et/+a6SQRJEKghyMZKi2Ky9nqrDaKeKNpnjFE7hsdiBuP2FTM4bISRlzNnbJZbqlcdJFJp9fhCLVlAz96SMRjpc8ZVcm7w8/OD9SN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621266; c=relaxed/simple;
	bh=G2B+FC42ibDpxYGn/GxlANUj5XPhdJ/7ecl22HcJ+Sk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=t57izPJGz6bwvBZ5l5ytkczAUYT1T8ssVCeOZrK2IoMYQHlZZImHNShk645hXXPZJNsTAc9sDOFcpIKlFpJ3C4A4B1h/Lj1lu23avQq6IlS444vD3S5tjEhwGpuYAgf4yRpIRlQeR9nlw4nnN3JR67p+MNZZKTAQqLTWZ66bVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U58uxtAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U58uxtAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D651F000E9;
	Thu, 13 Aug 2026 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621265;
	bh=EAEbMoJS6tEToOe24nC9GpgPlBb4klcTKIRV6OjO97k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=U58uxtAqo0jTRRRm35Tb70Ny0PlmyLdN/53uwrlNxseMxwNgNsNeZD4SOOtAW4ygB
	 1jCU55fQvmtMZcPH10coPvXa59Ro9097efXthOnn3tIORKZsmR+8I+z81Y0KUsO1xh
	 ykhGBIxA9S1y5PX9apYbW9tYtrSykDRhNiOSJTcdXd7PmO9iXJiRYrmcTVnqSisO34
	 P3rTjgqBXVb074Y428SyIEU3A+wAH1ycwv+DWoc1Gg1pS14YStF1j2a2V6EfcTwYpQ
	 vdjNiMBAta2Ju+b/Bn2Uhrz/oltY1STp7hObVEWpz2VTqz+en0E1z4GeCcY3ELpGMd
	 S6f1G7vjcKmnw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93991380CFD7;
	Thu, 13 Aug 2026 11:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: rsc_dump and hv_vhca return NULL on
 create
 error
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178662122019.2389593.11401946063214702739.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 11:40:20 +0000
References: <20260811061637.3195320-1-tariqt@nvidia.com>
In-Reply-To: <20260811061637.3195320-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 eranbe@nvidia.com, feliu@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, michaelgur@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 11 Aug 2026 09:16:37 +0300 you wrote:
> From: Michael Guralnik <michaelgur@nvidia.com>
> 
> All callers of these create functions treat NULL and ERR_PTR as
> equivalent error cases. Align the return convention to NULL-on-failure
> to simplify the checks at usage sites.
> 
> Since its return value is never checked and failure is non-fatal, change
> hv_vhca init function to return void.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: rsc_dump and hv_vhca return NULL on create error
    https://git.kernel.org/netdev/net-next/c/03a105c83243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


