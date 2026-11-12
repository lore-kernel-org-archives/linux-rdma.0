Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476410;
	b=xwAUD3lEN0von1NbTO5OsNoY2NEFJ8KhBlzxzOpxaQ+LyFpqYG8qwPpO33OcRCjHVe6j
	 zYT7C+nWJAiOkLuPx9EMd2upqISk0njhVcdkMaV2fNPvREFYcPW3iHhp06MawSxE/QDSh
	 OgG07oOuebDGudvbFTNZaqwjzTQuGbNyAljwZSVCzsL2bIxqAdMGZJ1sKXZAgcCf7mczK
	 V8I1mc4HlERKUC2h0nkGzd0H+cK8TzONWUIunpE4TqqOVr5k5pPVofyfGyXEeshVseZFh
	 CNyfIzVPAvVu2QyQD53Ewkqt3KFvPc8cdHi2KfCovPYaA51vVaN9kibCY5ED/re9EBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476410;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=AdcPgdUCX5fSaySPrdWMpwkUGc9cjfG0AEC73tSRupw=;
	b=FhKviu2tzQCvyhL8GB7iMN8aMRuXAbf03PwUZNAYBYcA17kDnOc5XL+HJLrIZ1KWUlTk
	 OfqOGQ02FdAxJqPif6vF01YxIJngWhyHrVCM9sF914BwnKR5fdrzlUSd4F4/C/pipKVsl
	 9tQRuXSrRCMF+kdmvpcxVSwUqxtTrIU/pRnroHXm0oHHPO6Jc5L0rkEOJJkj7uOmwt25S
	 9N2iGPrq89R4yfJ3aTI3Pd2zoPeMZ4O6NeB7kQdoHT9nH+nr8geM/TVbMBdgKv8je+1Ny
	 jG7cbAJJ9r7DOGzncD9tKt2TpvHi/bf2ZR7F2bp/4Vhlk3mKgDCTMb/Qr1jEqqNXr4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvUn6CH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DF60A2629;
	Thu, 12 Nov 2026 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvUn6CH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603BD1F00AD8;
	Thu, 12 Nov 2026 09:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476410;
	bh=AdcPgdUCX5fSaySPrdWMpwkUGc9cjfG0AEC73tSRupw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZvUn6CH3DHzkDjxn5lm7LrDVoxik/Pv+ut0lWEqGG8f0rcYFYeMuX19NGsu6TIyR4
	 GHEeRG2nwdBIButTc5JRZD1aaJwmbaQGpDJ9ZrFcSgdKOtB7CM8JzKwZ75zpjgZIhM
	 f115JXOnqIvx4YCSmaqW0pV01osU4PnDCxmeBeN1QtxGYklzzKzTCMowMqG0XmalFB
	 5yKLLjxorN7cARrf4nI6WQ+1fXaAdUOUTaSQbLnY8KIfLTTkq7vDInIgT/n7K1QhXP
	 LSxmc9O50XWYObXLGNtOQaiT622nMi1m+FyLB6Qh3rBAJHoNbwl1Nl9t130aRXFgF+
	 Oj3Wu/3v7/5aQ==
Subject: Re: [PATCH net-next V2 07/13] net/mlx5e: SHAMPO, Use page_pool DMA
 sync helper for SKB frags
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, dtatulea@nvidia.com, erfansh@meta.com,
 gal@nvidia.com, Jacob.e.keller@intel.com, kaifengw@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, mfleming@cloudflare.com, almasrymina@google.com,
 razor@blackwall.org, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com
Date: Thu, 12 Nov 2026 09:40:07 +0000
Message-ID: <179447640791.2199510.16646668257000691425@kernel.org>
In-Reply-To: <20261110183826.2927274-8-tariqt@nvidia.com>
References: <20261110183826.2927274-8-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message describes this patch as preparation for data
  direct only.

--

net/mlx5e: SHAMPO, Use page_pool DMA sync helper for SKB frags

This patch changes mlx5e_add_skb_frag() to call
page_pool_dma_sync_netmem_for_cpu() instead of calling
dma_sync_single_for_cpu() on rq->pdev directly. The stated reason is the
upcoming data direct support, where SHAMPO payload netmem is mapped
against the data direct device rather than rq->pdev.

> Switch to the page_pool DMA API which takes care of not calling
> dma_sync_* for unreadable netmem. Do it only for the place where it
> makes sense: SHAMPO payloads, the only RX buffers that can be
> unreadable.
>
> Until now it was ok to call the dma_sync_* API directly. But with the
> introduction of data direct it will no longer be correct: the payload
> netmem of a data direct RQ is mapped against the data direct device,
> not rq->pdev.

[Severity: Low]
Is "Until now it was ok to call the dma_sync_* API directly" accurate?

Since commit db3010bb5a01 ("net/mlx5e: Add support for UNREADABLE netmem
page pools"), mlx5e_alloc_rq() allows unreadable netmem for SHAMPO RQs:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_alloc_rq() {
    ...
		/* Shampo header data split allow for unreadable netmem */
		if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state))
			pp_params.flags |= PP_FLAG_ALLOW_UNREADABLE_NETMEM;
    ...
}

This means these RQs can be backed by the dma-buf devmem memory provider,
which does this:

net/core/devmem.c:mp_dmabuf_devmem_init() {
    ...
	/* dma-buf dma addresses do not need and should not be used with
	 * dma_sync_for_cpu/device. Force disable dma_sync.
	 */
	pool->dma_sync = false;
	pool->dma_sync_for_cpu = false;
    ...
}

That rule was added by commit 7dba339faae9 ("page_pool: disable sync for
cpu for dmabuf memory provider"), before mlx5 supported unreadable
netmem. Its commit message asks drivers to switch to this helper when
they add netmem support.

Before this patch, mlx5e_add_skb_frag() always called
dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, ...) on these
dma-buf addresses.

At this commit, pp_params.dev is rq->pdev and pp_params.dma_dir is
rq->buff.map_dir. For regular page pools the new helper therefore does
the same thing as the old code. The only functional change is that the
sync is now skipped for dma-buf devmem pools, and that fixes the
existing behaviour.

Should the commit message say that this also fixes the devmem case? It
could also carry a Fixes: db3010bb5a01 tag, so backporters don't treat it
as prep work for data direct only.

A smaller point: page_pool_dma_sync_netmem_for_cpu() does not check for
unreadable netmem in general. It checks a per-pool flag:

	if (!pool->dma_sync_for_cpu)
		return;

Only the dma-buf provider clears that flag. io_uring zcrx pools are also
unreadable, but they leave it set and are still synced through
pool->p.dev.

Could the wording "takes care of not calling dma_sync_* for unreadable
netmem" be made more precise?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
