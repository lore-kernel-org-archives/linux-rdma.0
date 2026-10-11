Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C61390600;
	Sun, 11 Oct 2026 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745452; cv=none; b=dh4jy596RLQHbWDk+Fa4LVmoaBJfshSq+pkPsaXQvI+AGCGgueCxawO6384tCch8aXVjZNnK6+D75m3wn7bfycsuIFYQYqdakzwHpxBEE3lLldO3TWmfxe8rPapSfNtJV9nAjYN2MVQ4tNec5oDnjh/WDobwh8324nKHVQlVcpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745452; c=relaxed/simple;
	bh=ojW2wZHFs1pYnwxtnz7zlF9xA37Na/utj4X4WrJWPcc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qO0A5UbC7z3wkG53rBpwz/Czuv1wKS8f2+tQbkuwmjmmfkZ2VtXf4u9WKSpJxEKFXfL6eXGJEk/Zk2AnyfmKN1APMDUUmKCzhz/upocpR3c4o2AHWSlhFBupqqeu7vRq+1oHYWttuuQJNePKJF/BNmynRfAK+gsW5Gk6WKRZoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CjY4UeAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjY4UeAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4261F0089B;
	Sun, 11 Oct 2026 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745449;
	bh=4vxOlSiy9OgWc0Y0eZ4LnuQ00GAjNw7bsz9uahntp8s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CjY4UeAJxeRG+6zxZ2JMQ37NUAAJU7B0QFD0x9u4mXCWNj3x6vTki4Ex4jmP5nmTr
	 nEldysQH5Y/i+i6Ds1cl7TMCoF4zbdO7g9CiGRvRY0SLb70r/ihN0mDoEIRqtoYn3w
	 2uzBXoO+p4seJUiCIHK2K9XYeWjuiQQAxemBKvKRSUv+qTLZogLvdD8pFDes31UBO/
	 qqqUxMv4TP2EuoPSEBNUPyElJS9DYJKkxV4am0zKNhEx33NSG7p9azBdb6wpDNxnk6
	 PRlz/r8bMcy04afRZ+RkwV6mpYk6jovQOrSnOeAcoCdhP2F5rRABrdly4WqTQ13wd+
	 m9WvDT+KPx5QA==
Subject: Re: [PATCH net-next 8/9] qlcnic: use pskb_may_pull() to pull excess
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
Date: Sun, 11 Oct 2026 19:04:07 +0000
Message-ID: <179174544742.434549.15432453849443944349@kernel.org>
In-Reply-To:
 <20261007-b4-pskb-pull-tail-drivers-v1-8-9512b0fb977b@toxicpanda.com>
References:
 <20261007-b4-pskb-pull-tail-drivers-v1-8-9512b0fb977b@toxicpanda.com>
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

- [Low] In qlcnic_xmit_frame()
  (drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:681-688), changing…

--

qlcnic: use pskb_may_pull() to pull excess TX frags into the head

This patch changes qlcnic_xmit_frame() so that it no longer calls
__pskb_pull_tail(skb, delta) directly when a non-GSO skb has more frags
than QLCNIC_MAX_FRAGS_PER_TX. It calls pskb_may_pull(skb,
skb_headlen(skb) + delta) instead. The commit message presents this as
an equivalent API swap.

> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> index 761ef3bc8193a..4a81d499e51c0 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> @@ -682,7 +682,7 @@ netdev_tx_t qlcnic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  		for (i = 0; i < (frag_count - QLCNIC_MAX_FRAGS_PER_TX); i++)
>  			delta += skb_frag_size(&skb_shinfo(skb)->frags[i]);
>  
> -		if (!__pskb_pull_tail(skb, delta))
> +		if (!pskb_may_pull(skb, skb_headlen(skb) + delta))
>  			goto drop_packet;
>  
>  		frag_count = 1 + skb_shinfo(skb)->nr_frags;

[Severity: Low]
Is this exactly equivalent when delta is 0?

delta is a byte count. It is 0 if all of the leading excess frags of a
non-GSO skb with more than 14 frags are zero-length.

In that case pskb_may_pull_reason() returns early and never calls
__pskb_pull_tail():

include/linux/skbuff.h:pskb_may_pull_reason() {
    ...
	if (likely(len <= skb_headlen(skb)))
		return SKB_NOT_DROPPED_YET;
    ...
}

The old direct call to __pskb_pull_tail(skb, 0) always reached the
pull_pages loop. With eat == 0, every zero-size frag matches
size <= eat, so it is unreferenced and dropped from frags[]:

net/core/skbuff.c:__pskb_pull_tail() {
    ...
pull_pages:
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

With the new call, nr_frags does not change. The recomputed frag_count
stays above QLCNIC_MAX_FRAGS_PER_TX, and nothing checks it again.

After that, qlcnic_map_tx_skb() maps every frag, including the
zero-length ones. qlcnic_set_tx_frags_len() then writes this frag_count
into the first descriptor. The descriptor loop programs more than 14
buffers for a non-TSO packet, which the comment above this block says
the hardware does not support:

	/* 14 frags supported for normal packet and
	 * 32 frags supported for TSO packet
	 */

This needs an unusual skb layout, and no in-tree producer of it is
known. Even so, could the frag_count be rechecked after the pull, or the
commit message mention this difference?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b%40toxicpanda.com
