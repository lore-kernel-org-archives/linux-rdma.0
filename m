Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345D58B6D7;
	Thu, 15 Oct 2026 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096672; cv=none; b=uqswaTsj0xKvf1ESkq3dE7z2w+cl6QkVNBbw7muifbAtNxJNMjquvS4PBUnShkxG6twJxEVepNIEKlWtyeqf7wFf2P/g/PvfiRrg/pCnbgEh8mv/7krVEoG6BWAQw4MKKl5tRabbzWsIgiIGz2oFJ0uVnJMMeevjgAV2LXsaWY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096672; c=relaxed/simple;
	bh=g8tiiAW5MHg4PJW6ZTdkPSj3y7sW7tn9a/3HGjXUjhI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UID0hpImBoCxbtxdAvmY7mVG8KbY2MkNRAaJCO9QN6jy9TyYrxBxCCc654dZ5nQXGTzYKn/jqrg11O+Mxc9BBczOedc6v4tc86nUzt+tF6Z/qjzv89tFiVgWKTrgS7hk+EfCdHdC/MyiRqj5Kw2iOBED2jcGn1bCVTlq1i71qE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U00eo/dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U00eo/dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0338B1F000C7;
	Thu, 15 Oct 2026 20:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096664;
	bh=IPcKGbXXpZt96HRSZUitEgyU01sKJ5kUO6vq6O/gjKY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=U00eo/drPeLtQSkFhXxvwj5+RVFaYPRfFc3gp9HqYjd5806izmcG5bWI6a/Pm7que
	 Edfc/+7lwe6wEtY4it6T5y5rhzRZemQUAfnBrPWHQTLGRGGLelZRdPzp8AxsoOW/pT
	 UO60ITIv6cvqrRT8UTii2pnqoFK+0jxLibB5eFEdh7jIpojNhh4LuqU1u7N/+roSOv
	 sE/oshJLlMWMubBd9zGlzn5EpNns/ZUXvky4Zi/Tu5maOLo9MQzjDqX0sVQP5xZTo5
	 Z9YcQ22L8tyHIaNYvl/WVOMB8pMzWMPMvLJSt+VfiMiyx5eI0O7kPM9KsG+FjJwr5I
	 +mCZoC3TiLN8w==
Subject: Re: [PATCH net-next v3 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
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
Date: Thu, 15 Oct 2026 20:37:42 +0000
Message-ID: <179209666252.434549.1850964039919625643@kernel.org>
In-Reply-To: <20261014173945.373295-5-almasrymina@google.com>
References: <20261014173945.373295-5-almasrymina@google.com>
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

- [Medium] The commit fixes reachable page_pool refcount imbalances but
  has no Fixes: tag, so the fix will not be picked up for stable.
- [Low] In the new skb_segment() linearize branch, the bytes being
  linearized are counted twice in nskb->truesize: 1) The code does…

--

net: skbuff: replace __skb_frag_ref() with symmetric skb_netmem_ref()

This patch replaces __skb_frag_ref() with skb_netmem_ref(netmem, recycle).
The new helper takes a pp_ref_count reference when recycle is set and the
netmem is page_pool backed, so it mirrors skb_netmem_unref(). The patch
also stops clearing skb->pp_recycle in skb_release_data() and propagates
pp_recycle to the destination skb in the copy, split, shift and segment
paths. It also linearizes skb_segment() output segments when frag_list
skbs have different pp_recycle bits.

Link: https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-912fa72106f0@secunet.com/

> Previously, __skb_frag_ref() and skb_frag_ref() unconditionally
> incremented the non-pp backing refcount via get_netmem(), while
> skb_frag_unref() decremented pp_ref_count whenever skb->pp_recycle was
> set. Ref-ing a page_pool fragment into a pp_recycle=1 SKB (or clearing
> pp_recycle=0 on an uncloned SKB while clones still held pp_recycle=1)
> leaked the backing non-pp refcount and underflowed pp_ref_count across
> IP-TFS, skb_split(), skb_shift(), and cloned unclone paths.

[Severity: Medium]
Should this patch have a Fixes: tag so stable picks it up?

In the base tree, iptfs_skb_add_frags() takes a raw page reference on
each frag it adds. The destination skb only needs to have the same
pp_recycle as the walk, so it can be a pp_recycle=1 skb:

    __skb_frag_ref(tofrag);  ->  get_netmem()  ->  get_page()

Those references are later dropped through napi_pp_put_page(), which
underflows pp_ref_count. The page can then go back to the pool while the
source skb still points at it. That code came from:

Fixes: 5f2b6a909574 ("xfrm: iptfs: add skb-fragment sharing code")

The commit message also covers only one direction of the imbalance.
The reverse case is reachable through skb_split() from batman-adv:

batadv_frag_create()
    skb_fragment allocated with dev_alloc_skb()   /* pp_recycle = 0 */
    skb_split(skb, skb_fragment, skb->len - fragment_size)
        skb_split_inside_header()    /* moves frags, takes no refs */

If the forwarded RX skb has pp_recycle=1, its page_pool frags end up in a
pp_recycle=0 skb. When skb_fragment is freed, put_page() runs on them and
drops a page reference that page_pool owns.

Both directions look like they can cause a use-after-free of the page,
not just a refcount leak. Could the commit message describe the
skb_split() case and its consequence more precisely?

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 980bbe9166393..96088289c234d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c

[ ... ]

> @@ -5057,6 +5049,16 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  
>  		while (pos < offset + len) {
>  			if (i >= nfrags) {
> +				if (skb_shinfo(nskb)->nr_frags &&
> +				    nskb->pp_recycle != list_skb->pp_recycle) {
> +					nskb->data_len = pos - offset - hsize;
> +					nskb->len += nskb->data_len;
> +					nskb->truesize += nskb->data_len;
                                        ^^^^

[Severity: Low]
Are the linearized bytes counted twice in nskb->truesize here?

nskb was allocated with only hsize + doffset + headroom, so
__skb_linearize() will usually need to grow the head:

__skb_linearize()
    __pskb_pull_tail()
        pskb_expand_head(skb, 0, eat + 128, ...)

nskb->sk is NULL during segmentation, so pskb_expand_head() also adds the
head growth to truesize:

	if (!skb->sk || skb->destructor == sock_edemux)
		skb->truesize += size - osize;

If tailroom was already enough, the head was accounted at allocation time,
so the explicit add over-counts in that case too.

hsize is reset after linearizing, so skip_fraglist only adds the remaining
frag bytes. The final truesize then looks inflated by about the
linearized byte count for each straddling segment.

Is the truesize update needed here? Would adjusting data_len and len be
enough to keep the skb consistent for __pskb_pull_tail()?

> +					if (__skb_linearize(nskb))
> +						goto err;
> +					hsize = pos - offset;
> +					nskb_frag = skb_shinfo(nskb)->frags;
> +				}
>  				if (skb_orphan_frags(list_skb, GFP_ATOMIC) ||
>  				    skb_zerocopy_clone(nskb, list_skb,
>  						       GFP_ATOMIC))

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261014173945.373295-1-almasrymina%40google.com
