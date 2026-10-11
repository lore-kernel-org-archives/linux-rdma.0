Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9363546C2;
	Sun, 11 Oct 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745443; cv=none; b=Mqe5FMQTu+KG2MsV7f6VI3uS66GzB1dQH9tnNwKLiOgnMT5f9hG4kqGRavJI9i7eWngGVk+5zcIB2VKUpCwZrN3Z9tm5YsxdLFlIeCW98EuPA7Yz4kAt+1Qb7A2tyiBo59W7cMOymLIgMxPtfNAiQMtNSG6fkMejj3Ia/kK57fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745443; c=relaxed/simple;
	bh=kiT7M8JMauVIJJT9P/O+jLNWWZsKoTsCAhQQgDmnRx8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pAPhWnAh4nVXsZ1lmcKjTmFJKOQ+el+sCSY1mVpIHI5Uzm9rrbdtiH6XutfXSeeR3hoaluCzjbphdXZykYZZ1KAGxgMUSW7awDdYmaM7QqoN9D4LjmPs0BIzM+j/YfKIYrfAzRVtIkLNj+b/dJ941H8agj4/2VYdVbIa6krSE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzzUYkcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzzUYkcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A731F0089B;
	Sun, 11 Oct 2026 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745441;
	bh=LdxMvCC8JxkBtq+BNVpskgNv+Iemqb0CitObZkcZf3A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UzzUYkcxQOL0XlmelgcWjoUE8uZ5mu43l+m4m3WaR9oNIw62zCnUniB7tzEWo2BrB
	 m/LtSCL5ygDk1oFfZBldkSOb9zcjhLNCiL0ryQ8J7LHAIrimuDA02HRyFG7gcNaeDp
	 hJlAHlApw9NQgtB6uGiS1SdyWdNJPYYCIcokj6uBek3AWSfrNQrfwQN9yFCi/AjY1r
	 L/H7nT8TTDqifm4cjorAwd2/DDPlx6Ti2F5nrdw4ff/R7AD535cW+u7s/elWHg0P39
	 JDkxuf933VY9tJJkaAlHfRXEPptQgd6XeC196sPAtXgJjdRykcwDhXBIS4gDvJqmwz
	 RH2OwqBWE9Ddw==
Subject: Re: [PATCH net-next 2/9] net/mlx5e: check for failure when pulling
 the Ethernet header after XDP
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
Date: Sun, 11 Oct 2026 19:03:59 +0000
Message-ID: <179174543945.434549.12308757559903944189@kernel.org>
In-Reply-To:
 <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
References:
 <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
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

- [Low] In mlx5e_skb_from_cqe_mpwrq_nonlinear()
  (drivers/net/ethernet/mellanox/mlx5/core/en_rx.c), the new drop path…

--

net/mlx5e: check for failure when pulling the Ethernet header after XDP

This patch replaces the unchecked __pskb_pull_tail() call in
mlx5e_skb_from_cqe_mpwrq_nonlinear() with pskb_may_pull(). If the pull
fails, the packet is dropped. The goal is to stop eth_type_trans() from
hitting BUG() in __skb_pull() when the linear part holds less than
ETH_HLEN.

> When an XDP program leaves less than ETH_HLEN in the linear part of a
> multi-buffer packet, mlx5e_skb_from_cqe_mpwrq_nonlinear() pulls the rest
> of the Ethernet header in from the frags with __pskb_pull_tail() and
> ignores the return value.  If that pull fails, eth_type_trans() later
> finds less than ETH_HLEN in the head and BUG()s in __skb_pull().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index e3f915beebe1b..b1e1e30a77e22 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2060,9 +2060,12 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
>  				pagep->frags++;
>  			while (++pagep < frag_page);
>  
> -			if (len < ETH_HLEN)
> -				__pskb_pull_tail(skb, min(ETH_HLEN - len,
> -							  skb->data_len));
> +			if (len < ETH_HLEN &&
> +			    !pskb_may_pull(skb, min(ETH_HLEN, skb->len))) {
> +				rq->stats->buff_alloc_err++;
> +				dev_kfree_skb_any(skb);
> +				return NULL;
> +			}

[Severity: Low]
Can this new drop path actually be reached? Given how the skb is built
on the XDP path, it doesn't look like the pull can fail.

For an skb with frags and no frag_list, these are the only failure
returns in __pskb_pull_tail():

net/core/skbuff.c:__pskb_pull_tail() {
    ...
	if (!skb_frags_readable(skb))
		return NULL;

	if (eat > 0 || skb_cloned(skb)) {
		if (pskb_expand_head(skb, 0, eat > 0 ? eat + 128 : 0,
				     GFP_ATOMIC))
			return NULL;
	}
    ...
}

The frags are always readable here because XDP and memory providers
can't be used together:

- dev_xdp_attach() returns -EBUSY when dev_get_min_mp_channel_count()
  is non-zero.
- The memory provider binding code in netdev_rx_queue.c refuses when
  dev_xdp_prog_count() is non-zero.

The skb isn't cloned either, since mlx5e_build_linear_skb() has just
built it with napi_build_skb().

There is also always enough tailroom, so eat stays negative. The XDP
setup earlier in this function is:

	linear_hr = XDP_PACKET_HEADROOM;
	linear_data_len = 0;
	linear_frame_sz = MLX5_SKB_FRAG_SZ(linear_hr + MLX5E_RX_MAX_HEAD);

That leaves about 256 bytes past the linear tail, and the pull is never
more than ETH_HLEN bytes.

On the commit message's claim that this happens "When an XDP program
leaves less than ETH_HLEN in the linear part of a multi-buffer packet",
is that accurate?

The driver always gives XDP an empty linear area. So the pull runs for
every multi-buffer XDP_PASS packet whose program doesn't adjust the
head.

An XDP program also can't leave 1 to 13 bytes in the linear part,
because bpf_xdp_adjust_head() rejects it:

	if (unlikely(data < data_start ||
		     data > xdp->data_end - ETH_HLEN))
		return -EINVAL;

When frags are present, bpf_xdp_adjust_tail() only changes the frags,
so the linear data_end stays where it is. That means len is either 0 or
at least ETH_HLEN at this point.

If this change is meant as hardening, for example against later changes
to linear_frame_sz, could the commit message say so?

If there is a real way to make the pull fail, could the message describe
it and add a Fixes: tag for the commit that added the unchecked
__pskb_pull_tail()?

>  		}
>  	} else {
>  		if (xdp_buff_has_frags(&mxbuf->xdp)) {

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b%40toxicpanda.com
