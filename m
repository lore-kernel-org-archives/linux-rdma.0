Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118CC3E9F61;
	Mon, 30 Mar 2026 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774910878; cv=none; b=Edu3xUYGo7JUBK4nbSq4PmAOhp3tVibSk7aS7KTchJZ+ZmBGHMw1c4HK2ZNd0GWPRApnPW6k/cZyb66oB8DVTpBxFWV9Utmj14MqHKvo8YUOX85u2gruEOwLReKe8DAM9Il/eFHo2TeKp5qaYZT9CnwAObo+oMra7dJJwj14a8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774910878; c=relaxed/simple;
	bh=YG3N5d72t+VrDNXGRo6sxZ+fWBF6oEI+R5nVyaDJbmM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJkRhxSC8fn33O7w/7uX3yAHECXHAAQ5KSVKYN7Ye9M8ZoAD6UdHdVEW1nMr/2Nj/JzRQBZsEqZ7G1gSp1bfgQ9FDPqrdZ/AlN1rPINxgRLbArgeApKflWZeWPAIZv6HickdqBovWvK2uUV9GPlHlovGOHOj5X7fQVp9durE+lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQIRMClQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQIRMClQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595ABC2BCB0;
	Mon, 30 Mar 2026 22:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774910877;
	bh=YG3N5d72t+VrDNXGRo6sxZ+fWBF6oEI+R5nVyaDJbmM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NQIRMClQY3utKmTwxhPmuwP1y9wZXpKAGWTdrR+7QXFM68BaTSVtmKjev6yXwPoSM
	 W0yv9vO+070XjgPeZ7UCZd10F/GVc5cxxcQjmJX+jR9jiwqx/Ar1ZEDIyA30hKNwJm
	 xqgJfif7Bqkq2Nk4T3Tlr1G6GfrVzZsgt5yajvhR2RGe4GxpAO6pyzyE6NcYERvTWV
	 LGpQHIuPeLXXxkdeCDNb7jFu6PRMSEKyHAhJRbf815cZa4vICrd1dCu+VWE86zB0U2
	 GSRQXjTESa5E9Z+SV97b2dJ8y4/JW4/cTeWL7ApCd90AXK3m9Ojl2CZi2N5s2j17Fo
	 lwAhG3AQLLHZg==
Date: Mon, 30 Mar 2026 15:47:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com, leitao@debian.org,
 kees@kernel.org, dipayanroy@microsoft.com
Subject: Re: [PATCH net-next,v4] net: mana: Force full-page RX buffers via
 ethtool private flag
Message-ID: <20260330154755.6a8c73a6@kernel.org>
In-Reply-To: <acrkwuIFyBXhwICF@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <acrkwuIFyBXhwICF@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Mar 2026 14:01:54 -0700 Dipayaan Roy wrote:
> On some ARM64 platforms with 4K PAGE_SIZE, page_pool fragment
> allocation in the RX refill path can cause 15-20% throughput
> regression under high connection counts (>16 TCP streams).

Did you investigate what makes such a difference exactly?
As I said I suspect there are some improvements we could
make in the page pool fragmentation logic that could yield
similar wins without bothering the user.

> Add an ethtool private flag "full-page-rx" that allows the user to
> force one RX buffer per page, bypassing the page_pool fragment path.
> This restores line-rate(180+ Gbps) performance on affected platforms.
> 
> Usage:
>   ethtool --set-priv-flags eth0 full-page-rx on
> 
> There is no behavioral change by default. The flag must be explicitly
> enabled by the user or udev rule.
> 
> The existing single-buffer-per-page logic for XDP and jumbo frames is
> consolidated into a new helper mana_use_single_rxbuf_per_page().

ethtool -g rx-buf-len could also fit the bill but I guess this is more
of a hack / workaround than legit config so no strong preference.

> -static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
> +static void mana_get_strings_stats(struct mana_port_context *apc, u8 **data)
>  {
> -	struct mana_port_context *apc = netdev_priv(ndev);
>  	unsigned int num_queues = apc->num_queues;
>  	int i, j;
>  
> -	if (stringset != ETH_SS_STATS)
> -		return;
>  	for (i = 0; i < ARRAY_SIZE(mana_eth_stats); i++)
> -		ethtool_puts(&data, mana_eth_stats[i].name);
> +		ethtool_puts(data, mana_eth_stats[i].name);
>  
>  	for (i = 0; i < ARRAY_SIZE(mana_hc_stats); i++)
> -		ethtool_puts(&data, mana_hc_stats[i].name);
> +		ethtool_puts(data, mana_hc_stats[i].name);
>  
>  	for (i = 0; i < ARRAY_SIZE(mana_phy_stats); i++)
> -		ethtool_puts(&data, mana_phy_stats[i].name);
> +		ethtool_puts(data, mana_phy_stats[i].name);
>  
>  	for (i = 0; i < num_queues; i++) {
> -		ethtool_sprintf(&data, "rx_%d_packets", i);
> -		ethtool_sprintf(&data, "rx_%d_bytes", i);
> -		ethtool_sprintf(&data, "rx_%d_xdp_drop", i);
> -		ethtool_sprintf(&data, "rx_%d_xdp_tx", i);
> -		ethtool_sprintf(&data, "rx_%d_xdp_redirect", i);
> -		ethtool_sprintf(&data, "rx_%d_pkt_len0_err", i);
> +		ethtool_sprintf(data, "rx_%d_packets", i);

Please factor out the noisy, no-op prep work into a separate patch for
ease of review
-- 
pw-bot: cr
