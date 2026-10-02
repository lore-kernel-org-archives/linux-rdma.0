Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392568632B;
	Fri,  2 Oct 2026 00:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790900411; cv=none; b=cs/NOdYQIjtAJDCxhUghUMQ7ch3Fxv4JYEMrmL/cGp/muToxFBlSNVhiH4kN6F2VcnaxIKdiTpQCXgNR9FH4aEA71OYkQ2j4H4Ppeyn7Vo8w/rF1PJNEzBG/5TZSkq9TmkNx68WEYg6XmiZyQM8qA5SF4DI9WRXXXayBzqatz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790900411; c=relaxed/simple;
	bh=q/Y7bsOAyiZ5iTLS3p0NB8eFnp0RSW/9B1jMWgpGRfU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YRkysfniC0ZYvZ0eBEIRe7wMT8GQweLKHvnw5uEDuBG+YQOcOMF8LxVQAiG2I4wrO4z3I9VA22JUisbkTa26u0yX8W1Ms1j1Jke0p7IY7WSjToRRBA6pD0kIqx9jxfOfi4sAzY9ejoRLQB9BH3ZXuyGYEn6Z45tZY38k3eujH1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSxK2H+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSxK2H+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828011F000FF;
	Fri,  2 Oct 2026 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790900409;
	bh=uB56XxneOWmJ5Yj57p8lWjnR5tlD06ZBMPCtC4mp7Mo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TSxK2H+6ov33TVNg+bEtSoKL2gx503M5IRLrHsnAjUaSzBw5iype1JRhFf+CGV80U
	 BKtzEYRz6JlJiqwdaCJMm1xPMz9eYgmKtSng53MBycXJAHRspbEMM3X9I+Zp9hQqja
	 XCBOVHegjWBSW+Uix8Scg2mgm1FrI3Uh8wWlFBmNG+FOdwnkF5M+yaeaQydzNkqlLK
	 Y0emI1c2AcVM1kz5Dj361TAqY+umZN4/N2FndYz7L2x9ns8n/g41iUjp6OZLzFZOnF
	 /cIS7kCaMbIBg4GrTMMpTYpZAKC6atUH5D7TxklXHlOCS86G8cK5e5okamc/btzvIL
	 bfum165s9XBKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 774F6381197C;
	Fri,  2 Oct 2026 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net/rds: restrict the rdma_cm ids to IB
 devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179090040828.3154315.2324104902480212536.git-patchwork-notify@kernel.org>
Date: Fri, 02 Oct 2026 00:20:08 +0000
References: <20260927063058.170273-1-achender@kernel.org>
In-Reply-To: <20260927063058.170273-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 26 Sep 2026 23:30:56 -0700 you wrote:
> Hi all,
> 
> This is v4 of the rdma_cm id restriction (v1 at [1], v2 at [2], v3 at
> [3]).  Patch 1 is the restriction itself; patch 2 is a small follow-on
> the v3 review turned up in the function patch 1 touches.
> 
>   Patch 1 restricts the listener, the per-connection id and the probe
>   id to RDMA_NODE_IB_CA with rdma_restrict_node_type(), so the rdma_cm
>   never installs the RDS listener on, or binds an RDS id to, a device
>   RDS has no transport for.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net/rds: restrict the rdma_cm ids to IB devices
    https://git.kernel.org/netdev/net-next/c/c7fca8aae6fe
  - [net-next,v4,2/2] net/rds: log the port a listener actually bound
    https://git.kernel.org/netdev/net-next/c/00d77b181866

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


