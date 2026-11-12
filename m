Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450006;
	b=WXZTvOq6Xp9SDhBSv7KKbkcbbtz0b94zsHNnveWHH3XscLlwW0IVIzD7FwTXtSGklYzW
	 ljpEIpVW46E2JYfRxOjCiIVLk/hpaMi1I4m/HQ7bBg1GvYVZvUeLg25lSMABd2HoeA90/
	 1kBvCA+9ErGq5dQC5Zjtbzd+6hq/K6HwHwepH0RtOViZ2Xo6DZsnrA68/hQOl7sr8GRIK
	 2NGDxNtIBZdpIIprjTR1oX7GTuBc48o7PnNOkTaSV9XsnPKHUPwmsKAUU9A6g/px4YEF6
	 fZ3Ijgdk7UQDvK++1BOyx3sPQIcBiuln8LpRgxdG5Sn4styjFzxGGzrMihhGbd81Jgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450006;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=BhBdvtva/PS+g95PBhs3u2exK13+VzhAhO9rc9cL2qI=;
	b=jqYlnjaVEYmTmDDHW1y4nsNLmQszyxINRcryhDIVa3bvqkO11YXra54KYb6FbHs1BSay
	 dNaSiX9FrQQoGMpNPB4hqpKsS+TwKA0mo1SG19VIPoeNYcxgyITsXsOJ3JBGpa+qndYhO
	 5y5L4C0txdl8TGraTTpDB4/zbx8GTtidx+lB6/Q5TGRBwtog3B3rCs70xh7wnJOUUUmmL
	 LWHKioeDzEOVf8LBJXuFv3E73WD5FR4LdgnfQmuoXgjSzkWx2OLkpvOfjjW+ICEtCDbP/
	 nlHVriwGPMPSjlwmkEeIklf8rW4lHFOJ1uOU/poYcOcghnZQFr5oSX3AKJ4cQRuZgZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMgw4oKl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38C606A31C;
	Thu, 12 Nov 2026 02:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMgw4oKl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FAB1F00A05;
	Thu, 12 Nov 2026 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794450006;
	bh=BhBdvtva/PS+g95PBhs3u2exK13+VzhAhO9rc9cL2qI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=eMgw4oKlAZrxSyObARgVNYmnKtnXBqDrQpOrybvdO1Bn3pfuISj7hMrMLMK9GTTjK
	 xZQvkeye1s+DDNrOvvqIwOmYJ2CQtTuc0j17ncDN696IANG2V7pFWYNfPDCVydW98D
	 TGT1zoUGzSpeXVht2zKhYxJIgZHgsz1mVxlJDWpSzNanviSw2Cqe8NkIA7PfsjNrry
	 eEFy/eq4mCC6UU0joFUiQfffiKsU+o1ZPhS8sMds2qIMygLB1zahuVDsw20ar/IxE6
	 WiYDBnSF+g/Uejep9atSBrNjNetIG+pMKmq3Uckwk1kzL8xHfC2uXbXt4FfnVYBOt6
	 WcB9gkPt++WXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5E1C6391AFD7;
	Thu, 12 Nov 2026 02:20:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: HWS, fix flow meter release on FTE update
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179445000518.1776220.6038675210157382603.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 02:20:05 +0000
References: <20261110173437.2471233-1-acassen@corp.free.fr>
In-Reply-To: <20261110173437.2471233-1-acassen@corp.free.fr>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, moshe@nvidia.com,
 kliteyn@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
 enelsonmoore@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Nov 2026 18:34:35 +0100 you wrote:
> HWS has no duplicate match. When a flower filter is replaced in place,
> its new rule waits as the pending duplicate of the old FTE. Once the
> old rule goes, switch_to_pending_act_dests() copies the pending actions
> over the FTE before update_fte() releases the actions of the old rule.
> An HWS rule reads the base id of its meter action through a pointer to
> the exe_aso of the FTE. That release takes the meter action of the new
> rule instead.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: HWS, fix flow meter release on FTE update
    https://git.kernel.org/netdev/net/c/145480b28ca8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


