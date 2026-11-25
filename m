Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615680;
	b=DZ0HUUSgVfEZqWXer91R96qTYDA2C1fecJZqC4bTgjuMcLoI09aH9ewSyxMN+9d7dYDD
	 x4Ut0JtxWoVK89wixXP+OclX8WOsc4gX3rEEsdoUhic5Ruvfnzgkwjgqs/YwTcEtpPp7S
	 5Za7Nubf601VYhu/toL/2ntK7yjiq/wPpXBqjO3vx5+0oIl58MLZMgpdDLoNTL3u7EI+6
	 e65NfXOCw0hgY491FY5/irF/ntqunOdpngq0mN479Ay+wKrq23KTmjAZF4hfPQMfNyAaO
	 BXCuZRBeKVr1Cbnj5CK1O5/ZaEck3HLM09PPvioIDY7V7CczkUjbWougv5RTNnE5yLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615680;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lt3M9q6QH7d3gwKFJZQMGdaxr94HtD9vcwEvmgzS5j8=;
	b=XQNDYTbiPSH2gZXFcXONVZowlfuBym+IAlCkA3FnrPiHMYFTNX5Yba2lRj1kjApSc0pK
	 6pisKQqjesOVwsYVC1IN+sbSmSxW6qxupOcoZaLY3y4Y7Jx8Gs9LDccIymdin92vLriwa
	 8IrPndXhEyqxMS7ryEHMQeybTAx1goXibGNj1YccF1y/j4vylgQAuUDNowbVyNIlXaPda
	 R+wWRpMS/ZPuh1yRp+MhH7H2eC5VEMCBH8k6pg/MEskjR/UBWywJyXJKrO3vDhjVXQI4b
	 C00oFESYQFfBARqxvd0jX+eB9RrIPfY/NJENNDr8RfQptZGwEAgta/VkL2Cxz//1FkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nVKuYtge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EF5606A31E;
	Wed, 25 Nov 2026 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nVKuYtge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295311F000C4;
	Wed, 25 Nov 2026 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615679;
	bh=lt3M9q6QH7d3gwKFJZQMGdaxr94HtD9vcwEvmgzS5j8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nVKuYtgemSkgX+F1T6puX0Ipyo8MocED3orvBDiHqRTgSK31O40izP7xFgCGfJiDQ
	 Gl79ReS/ptf1p4kskD31r/pwtOlnR49ngJZh8JQqaRxRyqFXXFwqTjuAhSpwKiQpsl
	 fxl2LyOX4xI54Sedg2FCwe8c1QhUJLAuQG8SU+4K6mJxu96CqcQ3c23SJtL1Yx4l0w
	 TgjWStA/w1HVkQ3Vckl0jTXkioi2caULivairhe7/kzJIMLJ2VtQ0vfgXArRtPBaMD
	 GKb24QKf3kJf1AIGIe5tDCuoj5r1AYLl4FM/AAp6X/t7I3ijoKToav7woH8RYL9a1W
	 wNo+2uyUW6o2A==
Subject: Re: [PATCH net-next 01/15] xdp: Let memory providers offer XDP a view
 of their net_iovs
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:07:55 +0000
Message-ID: <179561567567.3135.2081478467669976102@kernel.org>
In-Reply-To: <20261124125654.183091-1-bjorn@kernel.org>
References: <20261124125654.183091-1-bjorn@kernel.org>
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

- [Low] Two comments in include/net/xdp.h now contradict each other.

--

xdp: Let memory providers offer XDP a view of their net_iovs

This commit lets a net_iov area expose an XDP view: an address and size
for its net_iovs, plus a shift that gives the per-net_iov stride. It adds
xdp_netmem_address() and xdp_frag_address(). The XDP buffer helpers in
net/core/filter.c now use them, so they can read and write frags backed by
net_iovs that have a view.

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 07231adfb5f82..1629e347b71fb 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -164,6 +164,40 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>  #endif
>  }
>  
> +/* XDP view of net_iovs: a memory provider may give XDP an address for its
> + * net_iovs, see &net_iov_area.xdp_vaddr. XDP code may read and write a
> + * net_iov only through these helpers, and only if its provider offers a
> + * view; such buffers must not become skb frags or xdp_frames. For the core
> + * and the stack every net_iov stays unreadable: netmem_address() and
> + * skb_frag_address() give NULL for it. A net_iov without a view gives NULL
> + * here too, so a reader that does not use these helpers fails closed.
> + */

[Severity: Low]
This isn't a bug, but does this comment now contradict the older one on
XDP_FLAGS_FRAGS_UNREADABLE in the same header?

include/net/xdp.h:
	/* frags have unreadable mem, this can't be true for real XDP packets,
	 * but drivers may use XDP helpers to construct Rx pkt state even when
	 * XDP program is not attached.
	 */
	XDP_FLAGS_FRAGS_UNREADABLE	= BIT(2),

The new block says XDP code may read and write net_iov frags when the
provider offers a view. That means XDP programs are expected to run on
buffers with net_iov frags.

xdp_buff_add_frag() still sets the flag for every net_iov frag, whether or
not it has a view. After the later patch "xdp: Run programs on buffers
that must not hold kernel structures", it sets both
XDP_FLAGS_FRAGS_UNREADABLE and XDP_FLAGS_SINK on NET_IOV_XSK frags:

	if (unlikely(netmem_is_net_iov(netmem))) {
		xdp_buff_set_frag_unreadable(xdp);
		/* AF_XDP sink memory may only go to the socket of its queue */
		if (netmem_to_net_iov(netmem)->type == NET_IOV_XSK)
			xdp->flags |= XDP_FLAGS_SINK;
	}

Native XDP programs then run on those buffers, so real XDP packets carry
the flag. At the end of the series, the old comment is unchanged.

Could the XDP_FLAGS_FRAGS_UNREADABLE comment be updated to match?

> +static __always_inline void *xdp_net_iov_address(const struct net_iov *niov)
> +{

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
