Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34A18FDBD;
	Tue, 28 Jul 2026 01:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202246; cv=none; b=FSOYOKyg/6ww3W/H588S/gUOeoyaM5pk+IQl7mxUQQ1gp8yQ//kSoxeFPnJBc3XjM+slhlWSxdS9j0qBPFhxrlBq+TvV3NO9RKMHxM6LFkFYlEGH5uV2uyR61DDrs47WA4bjLZ7KGcrVw0HcarXTtdTEkIQ/STkqWAGmJh8jVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202246; c=relaxed/simple;
	bh=+rE6Cz0RJan8xCNCDwALmxWRACmUoo889HFMvKcwPGg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=J3Q43O15zWAuYdDK8pS4TOQTB5T7mqTYCo8PlVbLMGuPw2NQDscsZhJrpVSjcX60DdaZ3jBtl4SGYiMsw45Zx0OXgCeOdFsl+vSZ6A9asXLZxn3u0Ir+EJJGvQ55wAcsP7uwZeV2gBYfnrU2jNwpTNCFqv1eutO+Fui68QKj1YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pefcyppi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pefcyppi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE74E1F000E9;
	Tue, 28 Jul 2026 01:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785202244;
	bh=aOJKNgxaC7nnWIsKlfhGCMU4/oXejh5GqSD6x/T7PtI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Pefcyppi1GDuSLToVIhz8lkNlTZhQ0G+1Tk6lwHXXLG0gqQ/5hMrfT2TfWJ50wbWH
	 5lWPoY5NjC/GX2oEeCXYS5md3t2pNdXmpug2oW0954BP9AJW9af8AX7pTiB8Ga430z
	 ED1b+OEbCJ/9blLZumCwp+D6GMJLg/dj414j82w3TX5YoHO35WsjhzHemfOcU6mGiQ
	 6uahQcMDJXeJGxyPnr/fA3z4ueZzZ1Yeupspu6cVakM1vw3m3BiywTW3goWKAqTHut
	 LIWCIwaa2fFCLZviUk+jNQ2wkgLVAeyJRLI71zVU2yeajZcWCxCGWteV5006nK1L3p
	 FfidrTFoXsAhQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1981E380CEDA;
	Tue, 28 Jul 2026 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: E-Switch,
 defer fwd2vport egress ACL allocation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520220964.1492617.12802323621982888266.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:30:09 +0000
References: <20260723070427.1861502-1-tariqt@nvidia.com>
In-Reply-To: <20260723070427.1861502-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, ychemla@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jul 2026 10:04:27 +0300 you wrote:
> From: Yael Chemla <ychemla@nvidia.com>
> 
> On every VF/SF vport enable, esw_acl_egress_ofld_setup() allocates an
> egress ACL flow table and a fwd_grp whenever the device supports
> egress_acl_forward_to_vport. The only consumer of that group is the
> active/passive fwd2vport rule installed when two representor netdevs
> are bonded - a path that almost never fires. As a result, hosts with
> many VFs/SFs pay a per-vport flow table and flow group cost for a
> feature most ports never use.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: E-Switch, defer fwd2vport egress ACL allocation
    https://git.kernel.org/netdev/net-next/c/0b7763e3a0ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


