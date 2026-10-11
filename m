Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2D44519AE;
	Sun, 11 Oct 2026 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745452; cv=none; b=PExQ5BhxWZ/I4Hkolh6JwkxYDAvBTuqA8K6ZMuxWqYOH9xToXY8ghG4Ce72yf13IqgkjovVuntBA6EsOfolbtnQxY15bFsrh/FccHSHTa5b/ylKbtpRs7pO7odwD1aa2XZNiJOLnC+qwxYzUblqwAb+SmK0WL4FpKOJtjm3d7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745452; c=relaxed/simple;
	bh=SJlCXQYRmNfgVBXbcrpiSlDZf/upxaVz9D0231dxsMk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rMbPa2bj97jj6Dv5fR1u0l8CeRVtXbZ+culoJdYkTvqxWbT+pBi+9Y4bG/HILWBjSwTPrjP8ZXYMgI4MtorIRQartvXOzJ+T4rNtsbfsqOwCGZrbIyHKfbmpzgGmDdyencvKJh42/8sAiD+W5BaWswTJfJXxJTQuQINm5BX2lUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjO6s4Kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjO6s4Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDB91F0089C;
	Sun, 11 Oct 2026 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745447;
	bh=WuowvedJwpfz9l4BSl0jWJ9ure/QdY1u7QLk9R2KaLE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RjO6s4KjJvi7xkGcHN5EHGT6aPnhgDHeKBQR4KlNGg7G3veS5ERT6aUTK0AaS+4Au
	 QseF9/l1US2IoNpmNX9S4or7ctEpEDBqd4luzSXcwVwLvWC/ob4sSqW50KbQFv8VP+
	 cSKMW70BgZb4peazc+WL0283hDfOSOndopEX2uDci/VjZ3T9uvQjL7oxNMNy4J6w4a
	 ZwHUFm0MglbCCDknOMuQEuBbGKN1yCMBhv60uStpzDWgSMLVy2rZ/sdk7S2gq+AV/p
	 +L+qnEjLswbYR/fpUhp92yCUmV+pDpVv08AfapC+huhSJ0OAdvt+J8K2Qskq7fTlCj
	 rEvn6Jy/KogHg==
Subject: Re: [PATCH net-next 7/9] netxen: use pskb_may_pull() to pull excess
 TX frags into the head
From: netdev-bot+sashiko@kernel.org
To: josef@toxicpanda.com
Cc: kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, jgross@suse.com,
 sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
 anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com, manishc@marvell.com,
 rahulv@marvell.com, GR-Linux-NIC-Dev@marvell.com, shshaikh@marvell.com,
 horms@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, xen-devel@lists.xenproject.org,
 intel-wired-lan@lists.osuosl.org
Date: Sun, 11 Oct 2026 19:04:05 +0000
Message-ID: <179174544563.434549.2218178416870785309@kernel.org>
In-Reply-To:
 <20261007-b4-pskb-pull-tail-drivers-v1-7-9512b0fb977b@toxicpanda.com>
References:
 <20261007-b4-pskb-pull-tail-drivers-v1-7-9512b0fb977b@toxicpanda.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In netxen_nic_xmit_frame()
  (drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c), the new…

--

netxen: use pskb_may_pull() to pull excess TX frags into the head

This patch changes how netxen_nic_xmit_frame() pulls the TX frags that
don't fit in a descriptor into the head. It used to call
__pskb_pull_tail(skb, delta) directly. It now calls
pskb_may_pull(skb, skb_headlen(skb) + delta).

> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> index 67d9bf69f8f29..202deb64ddefb 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
> @@ -2045,7 +2045,7 @@ netxen_nic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  			delta += skb_frag_size(frag);
>  		}
>  
> -		if (!__pskb_pull_tail(skb, delta))
> +		if (!pskb_may_pull(skb, skb_headlen(skb) + delta))
>  			goto drop_packet;
>  
>  		frag_count = 1 + skb_shinfo(skb)->nr_frags;

[Severity: Medium]
Does this behave the same as the old call when delta is 0?

delta is the sum of the sizes of the leading excess frags. It is 0 when
every frag in frags[0 .. frag_count - NETXEN_MAX_FRAGS_PER_TX - 1] has
size 0.

The old __pskb_pull_tail(skb, 0) still ran the pull_pages loop. With
eat == 0, every zero-size frag matched the size <= eat test:

net/core/skbuff.c:__pskb_pull_tail() {
    ...
	eat = delta;
	k = 0;
	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
		int size = skb_frag_size(&skb_shinfo(skb)->frags[i]);

		if (size <= eat) {
			skb_frag_unref(skb, i);
			eat -= size;
		} else {
		...
	}
	skb_shinfo(skb)->nr_frags = k;
    ...
}

So those frags were dropped, and the recomputed frag_count was back
within the limit.

With this patch the length passed is exactly skb_headlen(skb). That makes
pskb_may_pull_reason() return early without calling __pskb_pull_tail():

include/linux/skbuff.h:pskb_may_pull_reason() {
    ...
	if (likely(len <= skb_headlen(skb)))
		return SKB_NOT_DROPPED_YET;
    ...
}

The skb is left unchanged, so frag_count stays above
NETXEN_MAX_FRAGS_PER_TX (14), and nothing checks it again. After that:

netxen_nic_xmit_frame()
    netxen_map_tx_skb()        maps every frag, zero-length ones included
    netxen_set_tx_frags_len()  writes the oversized frag count
    descriptor loop            posts buffer_length[k] = 0 entries across
                               extra cmd_desc_type0 descriptors

The comment above this block says only 14 frags are supported for normal
(non-TSO) packets. Could this post a descriptor chain the hardware
doesn't support?

When delta > 0 the two calls are equivalent, so only the delta == 0 case
changes. It isn't clear whether zero-length leading frags can reach a TX
driver today. Nothing on the TX path appears to rule them out, though.

The commit message describes this as a direct swap:

  "It already checks the result.  Switch to pskb_may_pull(), which takes
  the length the head should end up with and checks it against the skb"

Would it make sense to re-check frag_count against
NETXEN_MAX_FRAGS_PER_TX after the pull, and drop or linearize the skb if
it is still too large?

The later patch "qlcnic: use pskb_may_pull() to pull excess TX frags into
the head" makes the same change in qlcnic_xmit_frame(). It looks like it
has the same delta == 0 gap.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b%40toxicpanda.com
