Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33798243968;
	Thu, 19 Feb 2026 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771463423; cv=none; b=qMfrrXNTh6E8I16BIxQAdzJjLTd32LdcEZ6joDWV0HoVSl+/ca79QhXY3Zyt+LsbcOapl2Q+GJ3BOMVxUOUEXvaAPDe6TROvYucl4yNiH8hFRW7to6YlAOYiFng1FtJ3LIzdN7fy5eaznwh4CI6uXINZScZ9WHrYG/sXse3NQgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771463423; c=relaxed/simple;
	bh=ICf/6ddY3DQ1xjNTEqjK16rDz4G0aX10NNthOscZx6c=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pmkyiDfltaSVoQAPgkpThWYdqn9yi6em30C0pxmKJI3GRRBQC2bXdabccDL4kp6xMfSEU9ZVIk+dexZjtIbJEBAB37zd+4x3jENq8AjcclfFn2gpCH82D+bw4WldRqmex7X35fL2X5pz5xHAeWes+3Hx5TUEdIQceqVi4tEpHCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdy5uAH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdy5uAH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12970C116D0;
	Thu, 19 Feb 2026 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771463423;
	bh=ICf/6ddY3DQ1xjNTEqjK16rDz4G0aX10NNthOscZx6c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gdy5uAH9RUQcHYiJMmDlPRf8fhW9MZWdo+7WTENgJmR6xoMZj70Cv7Hhs0yDOytol
	 60cNViBHj059KF0lK7wPCnCgiMnoabweVjbg05JHIRtpgfWNa8di2dHz7f2VRgVz/U
	 JWNL3OquTh7C3Mj/6mcw7e90tYewrgb2ffkm+yp3qn8KmXsyEPauDxFK3rtxtaVLY2
	 /WHySz4RVSxVtgT1VpA9jr0ZcPnBWPbj7ln+xMAr5LiEeWpmXZxZkjw7l21/a7KUan
	 NdiaatmsnSIcjrSFNocGb5buVan9pnCmlxi85rnFXDpMaWPgZH/GZCdBkTsmLWc3sI
	 MNxnDedkPFbQw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85189380CEE0;
	Thu, 19 Feb 2026 01:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: XSK, Fix unintended ICOSQ change
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177146341407.1623576.6989061795597832585.git-patchwork-notify@kernel.org>
Date: Thu, 19 Feb 2026 01:10:14 +0000
References: <20260217074525.1761454-1-tariqt@nvidia.com>
In-Reply-To: <20260217074525.1761454-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, gal@nvidia.com, moshe@nvidia.com,
 alice.kernel@fastmail.im, witu@nvidia.com, dw@davidwei.uk,
 dtatulea@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Feb 2026 09:45:25 +0200 you wrote:
> XSK wakeup must use the async ICOSQ (with proper locking), as it is not
> guaranteed to run on the same CPU as the channel.
> 
> The commit that converted the NAPI trigger path to use the sync ICOSQ
> incorrectly applied the same change to XSK, causing XSK wakeups to use
> the sync ICOSQ as well. Revert XSK flows to use the async ICOSQ.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: XSK, Fix unintended ICOSQ change
    https://git.kernel.org/netdev/net/c/0da1dba72616

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


