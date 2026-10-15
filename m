Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CA4509EE2;
	Thu, 15 Oct 2026 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096669; cv=none; b=iSIhIABJYasCbVJopJ2J9hixLgMDawTLO842HJnz3D/uOhtVllDEiaUUMCeeu8E/Tme/237x37Emk/atzRSv5+9AKvfsCRyokkpVInN/nq9RBqPeOkkzaOThzmddnxcYO5eMO8o6nC2YYgPHsCrcOxJwjuIqEDUGNN6HxTwO198=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096669; c=relaxed/simple;
	bh=snf00trmk/+MUbUIaM/Vpcdlyba70rqBobTDQLmhMgA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R5YMVdEe/bVmCBsb1NceEBVhMzM4ICXIuSA3xzCYvtTASM2TqH6PN4fBp9VgpMCkdEVzJld2Y0E5qP8LjCsOxgFNQ07Gb/6+3rLk1dPed2fVchqBsNBBW+4jjbofHZ9lugNBwAQbModTJekofZnRsCQg3Rvu8y96hn7fVkkDFXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzVSB/1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzVSB/1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C61F000C6;
	Thu, 15 Oct 2026 20:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096662;
	bh=56BHpTKsHCG0wp5liSlmI1wXJyqDWh5vG/INsuaNzZ0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OzVSB/1RAd0AmKQxHjbpD52pY6Hvqwdp/yNKq2Mb13noY1rGNQGyjevgG77vTxUmB
	 qNYOpyFnMF6FsjE2NRgNSA0x0eEKYP2xkcnPbk+YrRBxd1hwKS5misdDxACvlvkv/5
	 evq/Ovkg77Uf4dZlZ6YN/oOEeeHxtaBQdwZ8ommxyAeCW7H39/vrtt6s+sHerYJyAa
	 4L4mbSqa+/M1Lpb/AlU3T4fTFKE8rU9i4EXtATSBYdv30mQdtg3KUep5aSSJU3IK3R
	 SM+o6zcCnH9m8acq/lb+9H8zd/JRkTteppm01LQN06UKcfsiGCtnA4J+a83ZpgF6Tg
	 z7rnTVOo97YGQ==
Subject: Re: [PATCH net-next v3 3/6] net: skbuff: replace skb_page_unref() and
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
 aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com,
 j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Date: Thu, 15 Oct 2026 20:37:40 +0000
Message-ID: <179209666051.434549.2929683677785392178@kernel.org>
In-Reply-To: <20261014173945.373295-4-almasrymina@google.com>
References: <20261014173945.373295-4-almasrymina@google.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This commit fixes a real refcount imbalance in
  mlx4_en_complete_rx_desc()…
- [Low] The commit message describes the mlx4 RX error-path bug as
  "underflowing the page refcount".
- [Low] At this commit, the new kernel-doc in include/linux/skbuff_ref.h
  names ref-side counterparts that do not match the code.

--

net: skbuff: replace skb_page_unref() and __skb_frag_unref() with skb_netmem_unref()

This patch replaces skb_page_unref() and __skb_frag_unref() with a single
skb_netmem_unref(netmem, recycle) helper. SKB-owned fragment unrefs in
mlx4, sky2, tls_strp and skb_shift() now go through skb_frag_unref(), so
they follow skb->pp_recycle. destroy_record() in tls_device now calls
put_netmem() directly.

> Unreferencing a page_pool fragment with recycle=false decrements the
> non-pp backing refcount instead of pp_ref_count, underflowing the page
> refcount when the fragment was owned via page_pool (as on mlx4's RX
> error path).

[Severity: Low]
Is "underflowing the page refcount" the right description of the mlx4
case?

Each mlx4 frag page holds one page reference owned by the pool
(page_count == 1). Per-frag ownership is tracked in pp_ref_count via
page_pool_fragment_page(page, 1) and page_pool_ref_page().

The old rollback in mlx4_en_complete_rx_desc() called put_page(). That
takes page_count from 1 to 0 and frees the page while page_pool still
counts it as in flight.

Without page checks enabled, free_pages_prepare() returns the page to
the buddy allocator. With checks enabled, free_page_is_bad() reports a
page_pool leak and the page is leaked.

When release is false, the page also stays posted in the RX ring:

		if (release) {
			frags->page = NULL;
		} else {
			page_pool_ref_page(page);
		}

In that case the NIC can DMA into the freed page, and the underflow or
double free only comes later, when page_pool releases the page.

When release is true, the page is freed while pp_ref_count and the
inflight accounting still include it. Page_pool shutdown would then
stall, and no underflow happens at all.

Could the commit message describe this as a premature free of a page
that page_pool still considers in flight, rather than a refcount
underflow?

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

[Severity: Low]
This fixes a real refcount imbalance in mlx4_en_complete_rx_desc().
Should it carry a Fixes: tag?

The fail path looks like it was missed by commit 82b023c97f60 ("eth:
mlx4: use the page pool for Rx buffers"). That commit:

- replaced page_ref_inc() with page_pool_ref_page()
- started each page with page_pool_fragment_page(page, 1)
- added skb_mark_for_recycle() in mlx4_en_process_rx_cq(), which runs
  before mlx4_en_complete_rx_desc() is called

The skb_mark_for_recycle() call is here:

	skb = napi_get_frags(&cq->napi);
	if (unlikely(!skb))
		goto next;
	skb_mark_for_recycle(skb);

The rollback loop was left calling __skb_frag_unref(frag, false). So it
dropped what are now pp_ref_count references through put_netmem(). With
skb->pp_recycle set, the new skb_frag_unref() correctly goes through
napi_pp_put_page().

Right now the fix is folded into a tree-wide helper rename that touches
esp4, esp6, tls_device, tls_strp, sky2 and skbuff.c, and the subject only
mentions the helper replacement. Stable trees that contain 82b023c97f60
need only this one-line change.

Would it make sense to send the mlx4 change on its own with
"Fixes: 82b023c97f60" for net, and the rename as a separate net-next
patch?

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
Do these two counterpart references match the code at this commit?

The skb_netmem_unref() kernel-doc points to skb_netmem_ref(), which does
not exist yet at this revision.

The skb_frag_unref() kernel-doc calls skb_frag_ref() its counterpart.
Here, though, skb_frag_ref() still goes through __skb_frag_ref():

static __always_inline void __skb_frag_ref(skb_frag_t *frag)
{
	get_netmem(skb_frag_netmem(frag));
}

That ignores skb->pp_recycle, while skb_frag_unref() now honours it.

The next patch in the series, "net: skbuff: replace __skb_frag_ref()
with symmetric skb_netmem_ref()", fixes both. It adds
skb_netmem_ref(netmem, recycle) and makes skb_frag_ref() pass
skb->pp_recycle.

After that patch, the only remaining difference is that skb_frag_ref()
has no skb_zcopy_managed() check. That difference predates this series,
and the skb_frag_unref() doc already mentions the skip.

Could the counterpart wording move into that later patch, so the
kernel-doc matches the code at every commit?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261014173945.373295-1-almasrymina%40google.com
