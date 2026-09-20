Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9F931ED8B;
	Sun, 20 Sep 2026 00:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789864874; cv=none; b=LPRztR0OFANlWDMKngO7su8guOXujxi+l+Q2FC2kASDUzC9ZDENulf1HgamjC8W6RLtcCKVDxyYXtS8q310Xl4OqpjnrUehLETJIPSKPDi2O48XgtjfrT2HMSkR2mL1r86+fsowraLpEGjBMmXZ6rUaCV1zVAfc1d/ZKsvTFXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789864874; c=relaxed/simple;
	bh=uoWO221+hFniLT2doNwuhOPGnyJWoIOKtN7+3fN1tGw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ICu7nM6vOQdVDykrcabMcgg8Q76yXExikVDMWxrhtENIJVWOUKLcuhRCjvXpJEEsTH5odVXBhRAIGQBoUVynahtblWL+4k01eQPygRcrxQaUMAqw04od4+g0FkVWpaQ3d9Baql93QbQU1AaO6U6ke9jVvefQUriPa9JpQIqBCPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iw/RZudZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iw/RZudZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF4C1F00893;
	Sun, 20 Sep 2026 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789864873;
	bh=pldEBeieoNLIMuf3xzY7/FQ4h1jOVkgeRGPmSStpAeg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iw/RZudZflo07UepdUsNoLomL9kP8U+VcGoZH1lq76C7Hi6ussDP5UikNkB734d86
	 l3B3MXE5Zc7X7RrjX4TpJIVdmp/B3hGBn5+ZoNnGUV16nkbz6djLrRfGZgSK9b7Enm
	 gchOvlQQEkrWuL68TjyzJkaen9d+CWC+y/TaudYfUfOsfnP6A5a8nn88+hT9HlwImb
	 if2KRi6q6JiM2P91F1pzMDq5Y+ZZUtdNoccrqEYktkMLHKKJBRRUSBAm8gVDEgH3Tz
	 kBc4bE9D5vNj04GIXeQv6WWh7sKCjulMMhiHqND2hgZk+WOQ9dGwWDXk0XNVH5JPrS
	 bScvF10iYHNnw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BAE3924A49;
	Sun, 20 Sep 2026 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: use assign_bit() where applicable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178986480565.1504357.13555480327800349461.git-patchwork-notify@kernel.org>
Date: Sun, 20 Sep 2026 00:40:05 +0000
References: <20260917-net-assign-bit-v1-1-e9c97965e080@nxp.com>
In-Reply-To: <20260917-net-assign-bit-v1-1-e9c97965e080@nxp.com>
To: Peng Fan (OSS) <peng.fan@oss.nxp.com>
Cc: dario.binacchi@amarulasolutions.com, mkl@pengutronix.de,
 mailhol@kernel.org, Raju.Rangoju@amd.com, PrashanthKumar.K.R@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sukhdeeps@marvell.com,
 skalluru@marvell.com, manishc@marvell.com, claudiu.manoil@nxp.com,
 vladimir.oltean@nxp.com, wei.fang@nxp.com, xiaoning.wang@nxp.com,
 shenjian15@huawei.com, shaojijie@huawei.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, sgoutham@marvell.com, rkannoth@marvell.com,
 gakula@marvell.com, sbhatta@marvell.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, alexanderduyck@fb.com,
 kernel-team@meta.com, brett.creeley@amd.com, GR-Linux-NIC-Dev@marvell.com,
 shshaikh@marvell.com, jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
 daniel@makrotopia.org, dqfext@gmail.com, SkyLake.Huang@mediatek.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, jjohnson@kernel.org, toke@toke.dk,
 nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com, pkshih@realtek.com,
 richardcochran@gmail.com, linux-can@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, imx@lists.linux.dev,
 intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, peng.fan@nxp.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Sep 2026 20:39:52 +0800 you wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert open-coded if/else with set_bit/clear_bit and their
> non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
> API.
> 
> Done with Coccinelle semantic patch:
>     // set_bit -> clear_bit => assign_bit
> 
> [...]

Here is the summary with links:
  - [net-next] net: use assign_bit() where applicable
    https://git.kernel.org/netdev/net-next/c/8830e65ed46d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


