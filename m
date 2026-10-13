Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7763B71CC;
	Tue, 13 Oct 2026 08:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880497; cv=none; b=enKeRLOu1KPNmX9/HM2na8xVA88dlBRNVbNrkQFJ20o0D5BX9n/PqIKTNZTL1JB3fMSv7ki3NVeAIhiyQSD882ayQ3lc+/CReZpuAwFu1Y4KyIkzRM5Gphx+2O0X80OWl6nJyU3sFoCS9BjsR6GVpAYWls7BGMueU+gWRp7VSvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880497; c=relaxed/simple;
	bh=Admyg5fR7dVF+n9oPt+cmfLOwlgyqEmEu8v+ikKlXxM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G6l6egEEIAeMmBpwEhfBz+1+d47qa+gSH/Ww3S8Gl7OiZspw8ATlmHAELAAmlNd8DFoZ0f08JmtG3h0BUQdtKL0LOYI6gCOahCs5iTjYR4n0IdK+CGk3be1F+Zi9iVUBajd+ReGFziDwTubRLe2ZHvT5nL+Uk08uzGurp+S3SEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwIT6tn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwIT6tn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA501F00893;
	Tue, 13 Oct 2026 08:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880495;
	bh=jBOUGn2GItOsxXaXa5plVpRE7+5IHOCRVQkIqPNRAxA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kwIT6tn+8Eygb/7eEPbWAnuOAUoqqoem9mWoiT7FXcMvpkopUgMQnBncJNFuPVguv
	 WmgPIXfvV001SimjaE8/SrovP1MueB3ueMpE5myEfppCOWzWlSMxBzQT+9ZaRjcmtK
	 2mOKP7/GlZ4uF4cQN0ZM0Nha6WUg47h8ChKK6FzbKrsmV3oZQweEss+Njc+YtQdFQg
	 im8h8Z5LHH5Y6//nwFwqBmfvBzTZgfEN1UvaG3vrpMuZoD/HGrbyQXqvzyBmoGQ2Ro
	 mFixgA2Nm/L7UqOSV7KRpbQrwgLU4uw9GfQC3nJ8Vm97oS4mdTbfpwTENp6mMkqQIb
	 5grSouan8X+ew==
Subject: Re: [PATCH net-next v2 3/6] net: skbuff: replace skb_page_unref() and
 __skb_frag_unref() with skb_netmem_unref()
From: netdev-bot+sashiko@kernel.org
To: almasrymina@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org,
 steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com,
 sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org,
 aleksandr.loktionov@intel.com, u.kleine-koenig@baylibre.com,
 shaojijie@huawei.com, mgr@kernel.org, j.raczynski@samsung.com
Date: Tue, 13 Oct 2026 08:34:54 +0000
Message-ID: <179188049412.434549.8105329401807782174@kernel.org>
In-Reply-To: <20261012082148.1698596-4-almasrymina@google.com>
References: <20261012082148.1698596-4-almasrymina@google.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch fixes a real page refcount bug on mlx4's RX error
  path but has no Fixes: tag, and the fix is folded into a tree-wide API…
- [Low] At this commit, the new kernel-doc for skb_netmem_unref() in
  include/linux/skbuff_ref.h says it is the "Counterpart to…

--

net: skbuff: replace skb_page_unref() and __skb_frag_unref() with skb_netmem_unref()

This patch replaces skb_page_unref() and __skb_frag_unref() with a single
helper, skb_netmem_unref(netmem, recycle). The SKB-owned fragment unrefs
in mlx4, sky2, tls_strp and skb_shift() now use skb_frag_unref(), so they
follow skb->pp_recycle. tls_device's destroy_record() now calls
put_netmem() directly.

> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 96f97fa0f5489..fe18606c2ab55 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -497,7 +497,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
>  fail:
>  	while (nr > 0) {
>  		nr--;
> -		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
> +		skb_frag_unref(skb, nr);
>  	}
>  	return 0;
>  }

[Severity: Medium]
This looks like a real fix for mlx4. Should it have a Fixes: tag and go
in separately from the API rework?

Commit 82b023c97f60 ("eth: mlx4: use the page pool for Rx buffers")
changed each attached frag to hold a page_pool pp_ref_count reference,
using page_pool_fragment_page(), page_pool_ref_page() and
skb_mark_for_recycle(). It did not update this fail path, which still
called put_page() through __skb_frag_unref(..., false).

mlx4_en_process_rx_cq() calls skb_mark_for_recycle() before it calls
mlx4_en_complete_rx_desc(). That means skb_frag_unref() here correctly
goes through napi_pp_put_page().

In the XDP layout (frag_stride == PAGE_SIZE with rx_headroom set),
release stays true and frags->page is cleared. The skb then holds the
only reference. The old put_page() could free a page that page_pool
still counts as in flight.

As posted, the patch has no Fixes: trailer and the subject reads like a
cleanup. The one-line mlx4 change also depends on removing
__skb_frag_unref() and skb_page_unref(), and on edits to sky2, tls,
esp4/esp6 and skbuff.c.

Stable trees that contain 82b023c97f60 won't pick this up, and the mlx4
change can't be backported on its own.

Could the mlx4 change be sent first as a standalone patch with
Fixes: 82b023c97f60, with the rename built on top of it?

> diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
> index 0441c220fdbdf..04114c64dad99 100644
> --- a/include/linux/skbuff_ref.h
> +++ b/include/linux/skbuff_ref.h
> @@ -36,7 +36,16 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
>  
>  bool napi_pp_put_page(netmem_ref netmem);
>  
> -static __always_inline void skb_page_unref(netmem_ref netmem, bool recycle)
> +/**
> + * skb_netmem_unref - release a fragment reference on a netmem
> + * @netmem: netmem to unreference
> + * @recycle: whether page_pool recycling is enabled (e.g. skb->pp_recycle)
> + *
> + * Drops pp_ref_count via napi_pp_put_page() if @recycle is true and @netmem
> + * belongs to a page_pool; otherwise drops a non-pp backing reference via
> + * put_netmem(). Counterpart to skb_netmem_ref().
> + */

[ ... ]

> - * skb_frag_unref - release a reference on a paged fragment of an skb.
> + * skb_frag_unref - release a reference on a paged fragment of an skb
>   * @skb: the buffer
>   * @f: the fragment offset
>   *
> - * Releases a reference on the @f'th paged fragment of @skb.
> + * Drops a reference on the @f'th fragment of @skb via skb_netmem_unref()
> + * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
> + * backing refcount), skipping managed zerocopy fragments. Counterpart to
> + * skb_frag_ref().
>   */

[Severity: Low]
This isn't a bug, but are these kernel-doc references accurate at this
point in the series?

The skb_netmem_unref() doc calls it the "Counterpart to
skb_netmem_ref()", but skb_netmem_ref() doesn't exist yet at this commit.

The skb_frag_unref() doc calls it the "Counterpart to skb_frag_ref()".
At this commit, though, skb_frag_ref() always takes a non-pp reference:

static __always_inline void __skb_frag_ref(skb_frag_t *frag)
{
	get_netmem(skb_frag_netmem(frag));
}

On a pp_recycle skb, skb_frag_unref() drops pp_ref_count instead, so the
two helpers change different counters. skb_shift() uses both, calling
__skb_frag_ref(fragfrom) and the pp-aware skb_frag_unref(skb, 0).

A later patch in the series resolves both: "net: skbuff: replace
__skb_frag_ref() with symmetric skb_netmem_ref()". It adds
skb_netmem_ref() and makes skb_frag_ref() dispatch on skb->pp_recycle.

Would it be cleaner to add the "Counterpart to" wording in that patch
instead?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012082148.1698596-1-almasrymina%40google.com
