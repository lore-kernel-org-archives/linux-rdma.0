Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573D39EF01;
	Wed,  7 Oct 2026 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791385763; cv=none; b=FqGcw53WQncDsqa7v+Tgw1igZZ0w4XP3qDPz0WqTxVmEypIgOXAL4SJZeey+T/p7qNbKrW2XiT054mbYPy8j8/+exFQ8uifecZIum+2LwHgbVR73hGFK3jrpp//Qr5Buq1jimg+AKK16pYtcHG/Qy2Bam69ZdVya25vRO7qxPYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791385763; c=relaxed/simple;
	bh=n1PlzXgKPPWXn4xBrMXursX6M7s4AJx/3w1A7rIncZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kq7/NBIFUDDrw5wyaGEZzYnrYldJcdrk+YkqGzjh59kXsXqrYTAAwVHYMK3gEEPSDvCEuDGhNeO2jxT9LhBzQecHHsp0P3265zh86LgeK1EEl1S6miiXTjClMXSGt4Gqv9CW/+WqBtJBGMqnvvI6VtNu23G2vtXd4tBDiPSXmcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzRhiDBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzRhiDBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3451F000FF;
	Wed,  7 Oct 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791385759;
	bh=WnK/pW8OTBOt0Pd2o1F+d7eEU1h//o2tR25a99I73TE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dzRhiDBv72YcUM1r11uYi3PAQO/Ueytd0lm0ymmfJdcVsUeI3DxWOwxpGRU5t1jAG
	 qU5PWSqWLhbSQeJ6s9PzwABy7evJ8KIipPs7+2aTsylKglnpr1hWD7QFSjkFqRYmZ7
	 OnfskU211WH0B/4iyaCE/9JM4pVprgKQjzGEKkJqN3wtUD45151KH0RMHYbn9x0dc6
	 z8IuEALhK4/sa+MPtC1xBC9O2WwKVy7EnSmfcAbRhDos3SH1Z650oEgZjV9bfhMXov
	 182ys4RrmdMyDyb6YQKbXRHPcm7XzxfmEvs3fBYyL1PBCCaqcEJhkuzyD8YgepOZfk
	 frOqgkL1hdMig==
Date: Wed, 7 Oct 2026 16:09:11 +0100
From: Simon Horman <horms@kernel.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netdev@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Breno Leitao <leitao@debian.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: mana: reserve RX buffer headroom to fix
 forwarding performance
Message-ID: <20261007150911.GT83879@horms.kernel.org>
References: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com>

On Fri, Oct 02, 2026 at 09:36:47PM -0400, Hamza Mahfooz wrote:
> Commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
> instead of full pages to improve memory efficiency.") started handing
> out RX buffers with zero headroom so that two buffers fit into one page
> at the default MTU.
> 
> The MANA TX path, however, stores the per scatter-gather entry DMA
> mappings in `struct mana_skb_head` at skb->head, and mana_start_xmit()
> therefore calls skb_cow_head(skb, MANA_HEADROOM). The port advertises
> this requirement as ndev->needed_headroom = MANA_HEADROOM.
> 
> As a result every packet that is received and then forwarded out of a
> MANA port fails the skb_cow() in ip_forward() and gets reallocated and
> copied by pskb_expand_head(). This is invisible to a plain RX or TX
> workload, but it puts a full skb reallocation plus memcpy on the hot
> path of every single forwarded packet, which is exactly what a
> router/NVA workload does.
> 
> Restore the headroom. Note that reserving MANA_HEADROOM (232) is not
> enough: ip_forward() asks for LL_RESERVED_SPACE(dev), which rounds
> hard_header_len + needed_headroom up to HH_DATA_MOD and is 256 bytes on
> ethernet. Use LL_RESERVED_SPACE() directly so the value keeps tracking
> both constants. Also, since LL_RESERVED_SPACE() tracks MANA_HEADROOM,
> it grows with MAX_SKB_FRAGS and for MAX_SKB_FRAGS >= 19 it is greater
> than 256, so we have to account for that by using the headroom the RX
> queue actually uses (instead of assuming XDP_PACKET_HEADROOM) and
> turning MANA_XDP_MTU_MAX into MANA_XDP_MTU_MAX(ndev) (note that at the
> default CONFIG_MAX_SKB_FRAGS=17 they are equivalent).
> 
> At the default MTU on a 4K page this means a buffer no longer fits twice
> into a page (SKB_DATA_ALIGN(1500 + MANA_RXBUF_PAD + 256) = 2112), so the
> frag-vs-single decision is now made by computing the real buffer size
> instead of comparing the MTU against PAGE_SIZE / 2. The page_pool
> fragment path is still used wherever at least two buffers genuinely fit,
> e.g. on 16K and 64K page sizes.
> 
> Measured on an Azure VM with a MANA NIC acting as a forwarding NVA (UDP,
> 1400 byte payload, 4 streams, 8 Gbps offered, only the forwarding
> node's kernel differs), 8 runs each, median:
> 
>                   forwarded pps    throughput
>   before              272,830       3.06 Gbps
>   after               390,560       4.37 Gbps   (+43%)
> 
> perf on the forwarding node, same workload:
> 
>                   memset_orig   __pi_memcpy   pskb_expand_head
>   before             10.07%         3.96%         present
>   after               0.94%         0.64%         gone
> 
> Cc: stable@vger.kernel.org
> Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
> v2:
> - Fix the XDP headroom mismatch with CONFIG_MAX_SKB_FRAGS >= 19,
>   by passing rxq->headroom to xdp_prepare_buff().
>   mana_build_skb() then picks up the correct offset via
>   xdp->data - xdp->data_hard_start. Also, turn MANA_XDP_MTU_MAX
>   into MANA_XDP_MTU_MAX(ndev) to account for the headroom,
>   since it is no longer a constant. (Narcisa, Sashiko)
> - Use the new mana_single_rxbuf_per_page_forced() helper in
>   mana_set_priv_flags(). (Sashiko)
> - Trim the comment above mana_get_rxbuf_headroom() and drop the stale
>   "XDP headroom" wording from the comment above mana_get_rxbuf_cfg().
>   (Narcisa, Sashiko)

Reviewed-by: Simon Horman <horms@kernel.org>

