Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346807;
	b=KomiUOI2Of/FlcCTivuzMmInBMwjFYkWbGRNqBR2seuU5teVssrqaezJYmLzDc/SdWkV
	 stTsMOtkyrsjzg3cihyAxURn/yEelHiz7mRHZqNe1Lsh1wR2DfLtUppaVdoyOl0WXC5yD
	 f3OwV9Z4fimbwJF/h0SDT1F+5y1ZUKkCv2QWCeloJ/yTsC3LhuaqshhI5u7Z8tXYOFNie
	 NVts1oqI0KgdHDllk5fsYhaqsBAiRbeE257DazKyweACVVKbrzOHwVHmf/yVGy17ipiHQ
	 BHZhlnpz2fLM1vVpXE2MbgtPugaHYbxKhpcUBE9s5N9EFnU85qwB+Eiv03i+v36jyAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346807;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=lSL4MFB6bw4CVme3VOrLqejrCKOFv1AQMa1yqiN4Hvk=;
	b=hJ51dHeG5xKvhDb46gooU6QBajyej/KyevJwJi76GqmWDxP0VFRBIdssFrVhu44s1WQf
	 51wiZy3bwZi75vnNyvBMBsw+J9MDcByim7zWJfZbUIXqXzZNYPKllXqEXm9MyUhLiKeE8
	 lOxZXGTq22KFizgE5Y+X1rznUfHwT6x5id2hPVya1wkrTjemPYj1Xp9uLZ8EOa54YQf3/
	 bMvfQZY6tUEJRbya1jEdq7Mywk3GQduegwBcnZQWy+l/s7evn665mHkeK6snB6fX4KziM
	 02373naMwF/QHa0UYh8+a24qE1KxyADtBBHMKkoDonMrDL/kZY2sFZQBciYFcwpj92g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kKMkm9Tw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67C8606A32E;
	Tue, 10 Nov 2026 21:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kKMkm9Tw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEE11F0089F;
	Tue, 10 Nov 2026 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346806;
	bh=lSL4MFB6bw4CVme3VOrLqejrCKOFv1AQMa1yqiN4Hvk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kKMkm9Tw/G93fphFFXpmPP0i8JIqETNFzdnddLwNF0clo0ifW9Rta/RvIb1bcNJpX
	 ZBvI69esXPK+Ttm39S7RPE4fgIaiLCQxaRMUAooylKlPz2chQamv4fodb+ESWqLQQ0
	 x+Zzglck7XBNtyKB7bmDLNB/vm26NX09vXuT0pTrFxBuNLrsfuHqdPfDRkTd2/ZXdT
	 0OZZDRnsu5ZcOA6lulyM7SWyE3JYPr3MGx1U67gtNXzdZEaxR+E6hABmHoB4eQpvjH
	 ShJVnpdQ338hV+ysM+9FEYSrAvXR/FE0lJghDrYzWfbOpvuQ/SxSZ7ikTzJIAGbt88
	 MqxAdbTlGIHfg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 2118439E8A40;
	Tue, 10 Nov 2026 21:40:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: macsec: Don't remove fs_id when adding a
 rule
 fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179434680493.71955.13043518489882065579.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 21:40:04 +0000
References: <20261105003419.4016283-1-lcy8047@gmail.com>
In-Reply-To: <20261105003419.4016283-1-lcy8047@gmail.com>
To: Changyul Lee <lcy8047@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net, horms@kernel.org,
 joasantonio108@gmail.com, phaddad@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Nov 2026 19:34:19 -0500 you wrote:
> macsec_fs_tx_add_rule() and macsec_fs_rx_add_rule() clean up a failed
> rule with macsec_fs_{tx,rx}_del_rule(), which also calls
> macsec_fs_id_del(). The fs_id is never in the xarray at that point:
> macsec_fs_id_add() is the last step of adding a rule and removes its
> own entry when it fails.
> 
> macsec_fs_id_del() then dereferences NULL, through macsec_device for
> the first SA of a MACsec netdev and through fs_id_found otherwise. On
> RX, the SAs of one SC share an fs_id, so a failure while adding another
> SA drops the reference that an existing SA holds.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: macsec: Don't remove fs_id when adding a rule fails
    https://git.kernel.org/netdev/net/c/5175da73dd12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


