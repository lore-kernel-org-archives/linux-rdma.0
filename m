Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC148F01B;
	Mon, 12 Oct 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816134; cv=none; b=EO+fYtwbFJqQR+DqWd3O24m7bp2n2WJwiMxfHOXRhjcCFRfG2cT/dmXcdGC5ol+2ovuFe2ZESbkHRElHL5nUiuxRm93M7Jhhcmo8jjva7DBxIekaqM5yB0VVBBqrk3mB7SBXV05QIjfVIewyE2hnb+5KJpbl42CzzQepWcheb8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816134; c=relaxed/simple;
	bh=upKqYJoH//qtZKySCH9zo2w1e3WdUIP716pEilva9+E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XV1+hv3QX7vGYlYfaHiFtImK9B19bci4HKuOxDDFkd0OKp3hTRaSUDCFk7f/7xB8qUvnyEt5iEUPzuK/+U9NYzD5b0RCokvmtwMGlgHmqIpdWZSG2YwfGv5Kg+8SlV+uqC2bVzQSg5f1rHDkxTWuBXBE51WUogfCULHNGpDb/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/CGQmpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/CGQmpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98781F0089C;
	Mon, 12 Oct 2026 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816133;
	bh=unMTY4wp+VE+sOT9KYhjFFCYeAOkDjL8LxhGFybUMfU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V/CGQmpHhwzNkxXdyochz/7iOAoqWUh9K/bMc719GkK9NrAocuYpinIT6EiTYI20D
	 y6I2ijWa9wKNzXvFLFp+ZOpzCNeVDshoq97FsTRBZDdPjnKwW8YDp1xG/8YoG7fQWk
	 XXaIR1Neg6i64E4SliuUhZRNyfkL8IiZPHQVQ6zJcq3AXlETt3s7adbbLSVGq2XoQy
	 Gyb6JvKZX3qwWTwN8NCWWGYK1rTwR8zGGEodZQwhT/UjDkvOVrDYIdQzXfsJ/tuFqh
	 epgjPvScXGgmMXZZvo13ai4C+DRsr0Yc8uOHqmUex8bh8km/YAXcC3+ruRcO3srsYh
	 PZ6NCj+84e7BA==
Subject:
 Re: [PATCH net-next 06/10] net/mlx5e: Add data direct TX infrastructure
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, byungchul@sk.com, cjubran@nvidia.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, shivajikant@google.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com, yuehaibing@huawei.com,
 bobbyeshleman@gmail.com
Date: Mon, 12 Oct 2026 14:42:11 +0000
Message-ID: <179181613153.434549.5589230692687372457@kernel.org>
In-Reply-To: <20261008132815.654147-7-tariqt@nvidia.com>
References: <20261008132815.654147-7-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/mlx5e: GPU unbind causes DMA corruption for active devmem TX

--

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -211,7 +212,8 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>  			goto dma_unmap_wqe_err;
>  
>  		dseg->addr       = cpu_to_be64(dma_addr);
> -		dseg->lkey       = sq->mkey_be;
> +		dseg->lkey       = dd && skb_frag_is_net_iov(frag) ?
> +				   sq->crossing_mkey_be : sq->mkey_be;
>  		dseg->byte_count = cpu_to_be32(fsz);
>  
>  		mlx5e_dma_push_netmem(sq, skb_frag_netmem(frag), dma_addr, fsz);

[Severity: High]
When MLX5E_SQ_STATE_DATA_DIRECT is clear, this silently falls back to
sq->mkey_be for net_iov frags too. That only works if a net_iov can
never reach an SQ whose data direct state differs from the device the
net_iov was DMA mapped against. Nothing on the TX side enforces that.

The follow-up "net/mlx5e: Recreate netdev channels on data direct
device unbind" makes this reachable. On unbind,
mlx5e_data_direct_event() clears MLX5E_PFLAG_DATA_DIRECT and recreates
the channels. It does not do the netdev_has_dmabuf_binding() check
that the ethtool path does, so a devmem TX binding made while data
direct was on stays alive.

That binding was mapped against the device returned by
netdev_queue_get_dma_dev(), so its net_iov DMA addresses are IOVAs in
that device's domain. After the channels are recreated, dd is false in
mlx5e_txwqe_build_dsegs(). The same IOVAs then get posted with the
local mkey, and the NIC reads whatever they happen to resolve to in
its own domain. The result is silent corruption of transmitted data or
IOMMU faults, rather than a clean error to the sender.

How is a still-bound TX dmabuf supposed to survive the unbind? Should
the binding be invalidated before the queues are restarted? Or should
net_iov frags be dropped here when dd is false, instead of being sent
with sq->mkey_be?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
