Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9832F3D4103;
	Fri,  5 Jun 2026 23:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701198; cv=none; b=HVeAefl/PB5HWzLUi6HVVKeYVkwrGpBwHMfjzc0KNZJ6IArCxyd8jsyDvoCzST09Rqq+btWt/CD8ldY1qF/EhYON3aLLRLNQy1W2Z3CjuCRC8w/VsaswNiziTSkpYqtmBxmStgf4oHIXYINfvHlSZkOCkee7Botgvb/O4ZcrOrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701198; c=relaxed/simple;
	bh=HVohKQd1pTvqn6Qh+3Y9RzCE0kuc0HwT8xPN8j79ya4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iAMjzfPnH4XiUhGWQ8vgtMUNFCHjSQyak07Q6qeCQsypLXKMvHjT3NPp3+gOulV9EKHer36jNuzi26srbNvZ0xU0YvvQM9p1LCWw4d6LBprOLEkIqgFhH/a6c0pZuy+4i88P4xX/1CGbcLM+3NJkq3OyFeuN+l5FmOUHGYm3Mwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrD2CULs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrD2CULs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED981F00893;
	Fri,  5 Jun 2026 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780701197;
	bh=MWVBiiFpEQ0/EmGFoo8huzeAXw0aY1xHLVjCxXfg3fA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JrD2CULsR3Z5ODT7I7ePEHkBwtjOr436CUokEgXc2bRs3eRrlCFoVhkrkd/C6cnUs
	 V0UZgHYXeIQdMV/LWuWsl+xIuFrNgKrlFoTQ0FwpDQHOWrtUp4HdNxc4wPvFtGu4cY
	 KIct6ETV1OAS5EfQzBqRDl9nYAmH0LyfILs1BoIScWsp2nrhnauZsdphWmbGlGlFh1
	 TZvKaMhVO6ER//uDAjIVC0K4AHT/cLXYiJ0xOVaWTNYnoTJb+3RJqpSdm9rHVs2HuF
	 0Gos4gRHhv+3ZhQro5Lc0RJYy0eA4wpkAqNXaLumfvF5xkuzElhFQ7RltFnmRI59eN
	 IfnPcdGTv6HPQ==
Date: Fri, 5 Jun 2026 16:13:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, dipayanroy@linux.microsoft.com,
 kees@kernel.org, linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Cache MANA_QUERY_LINK_CONFIG result
 to avoid repeated HWC queries
Message-ID: <20260605161315.26784677@kernel.org>
In-Reply-To: <aiJeuU3DLKL7JcPN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260528180757.1536640-1-ernis@linux.microsoft.com>
	<20260602132127.25fc27ee@kernel.org>
	<aiJeuU3DLKL7JcPN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 22:29:29 -0700 Erni Sri Satya Vennela wrote:
> I tried two netdev_lock-based variants. 
> 
> mana_query_link_cfg() has four callers:
> 
> 1 ethtool ioctl/netlink			- has RTNL	- has netdev->lock
> 2 sysfs speed_show/duplex_show		- has RTNL	- no netdev->lock
> 3 netvsc_get_link_ksettings VF forward	- has RTNL	- no netdev->lock
> 4 mana_shaper_set			- no RTNL	- has netdev->lock
> 
> No existing lock covers all four.

How fresh is your tree? The just-minted commit 9f275c2e9020 should
address the gap, I believe?
