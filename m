Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615684;
	b=IZEGKloAg3PVc5YUvRI2fPewZziMIkpG0gXP87jBynArB8yFy5w1Pebarn5wgzN89MNW
	 9zYo1lE+xnfuULeDexVIWSh0MMxpu9n+msmbRPpNt9hkTu+YlkpGqXYlIB8UlyEsOCcqB
	 4k8XnbG+a+A19lV0/FsJb8rnm/sUGtCIyY7t2iu8nmJ/5npjpgQtU8dfcvkbLAvpu+f6g
	 FvgM26WFWy6E4IzT4OcS4Ew8mjlgjdGVw3UVOc1N7drQ0TF8qCig8APGpURW6OhaIDfcz
	 DJIvaJ3RimmO0CrEWz5vYnLrF0QYDgw1gHjja9q3//QG94548LlmvbhfG0CIWZ8ZAjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615684;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=cipA+kILZiIJQlmhgfoyflHJGAWoJdqgBfED6D2DA3Y=;
	b=kUFHrG59auuO7OGpjCcjenxALezBpCuZRKK8zHNRn+bs7Cc1WABV2IrGMzbmu7NBbBQz
	 zdxBsdAcxHYKbr3bIIbT4UINW5aR1S7iBpyYw1vVj0LfHiR4uzGBlgoRO7d00fLwVc/9B
	 obAgJNbiWZv0EvIh+kNmgezHfWBXzilh1YrFb2HO35OdadS+JiFHXABjcUYUdbiRJqvxu
	 Qy1m7v6ihdkQ55n+GMPsJBDi1CVTrOoqYQOQjUXyrnCU/+UzV2RrlCo5lvCyjnTleH83A
	 NRWdcmP0OO/pdTXjRdcmM+HOJLOsthiQo6yhs+WdCkadp8pj6mtD5hWEM1ZBCyagooQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EyFU3W/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C24606A330;
	Wed, 25 Nov 2026 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyFU3W/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668D71F000C4;
	Wed, 25 Nov 2026 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615683;
	bh=cipA+kILZiIJQlmhgfoyflHJGAWoJdqgBfED6D2DA3Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EyFU3W/Dl8NqcV26L+1cmrna14csDw/8L2rjmj4K1LssG6qsllNJedujYGTumm6FT
	 za8ONu7mGlUm3XMvOZ0gnYuK+PicgkjKAT5wtKMp/Yu4MiyId/6A3EynKuGlBQRQgt
	 7d7MXixZYfA1EyELKWAwXI/Qh+GRI208912ci1Dwyiw8dW6N6928WGL4jpyWnUEyki
	 udyIsfAMyEKFchLdaTBwgwyHv/Z7Uj2mYxKbQhRkCDu4IXLYZND4ULl/czCW0nrG/V
	 3515Uio0EklXVTbNaZh3WX8jkqbDTs9jDOHNUWDnZagpJZPAGgXOdYLesXowFntrnp
	 OnRe2onIGZ/2A==
Subject: Re: [PATCH net-next 02/15] xdp: Keep the shared info of a buffer in
 kernel memory
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
Date: Wed, 25 Nov 2026 14:07:59 +0000
Message-ID: <179561567996.3135.9952128421877275714@kernel.org>
In-Reply-To: <20261124125654.183091-2-bjorn@kernel.org>
References: <20261124125654.183091-2-bjorn@kernel.org>
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

- [Low] A comment is now stale.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch's
  commit message names it and the series leaves it open.

--

xdp: Keep the shared info of a buffer in kernel memory

This patch lets an RX queue keep the skb_shared_info of its XDP buffers
in kernel memory, allocated by xdp_rxq_info_reg_ext_sinfo(). Buffers
with the new XDP_FLAGS_SINFO_EXT flag look up their shared info there.
For such buffers xdp_data_hard_end() reserves no tailroom, and frame
and skb conversion refuse them.

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 1629e347b71fb..944418111a86e 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h

[ ... ]

> @@ -212,17 +226,27 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>  
>  /* Reserve memory area at end-of data area.
>   *
> - * This macro reserves tailroom in the XDP buffer by limiting the
> - * XDP/BPF data access to data_hard_end.  Notice same area (and size)
> - * is used for XDP_PASS, when constructing the SKB via build_skb().
> + * This reserves tailroom in the XDP buffer by limiting the XDP/BPF data
> + * access to data_hard_end.  Notice same area (and size) is used for
> + * XDP_PASS, when constructing the SKB via build_skb(). Buffers with
> + * %XDP_FLAGS_SINFO_EXT keep the shared info elsewhere and reserve none.
>   */
> -#define xdp_data_hard_end(xdp)				\
> -	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> -	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +static __always_inline void *xdp_data_hard_end(const struct xdp_buff *xdp)
> +{
> +	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +	if (xdp->flags & XDP_FLAGS_SINFO_EXT)
> +		tailroom = 0;
> +	return xdp->data_hard_start + xdp->frame_sz - tailroom;
> +}

[Severity: Low]
This isn't a bug, but should the comment in bpf_xdp_adjust_tail() be
updated along with this change?

net/core/filter.c:bpf_xdp_adjust_tail() {
    ...
	/* Notice that xdp_data_hard_end have reserved some tailroom */
	if (unlikely(data_end > data_hard_end))
		return -EINVAL;
    ...
}

xdp_data_hard_end() no longer reserves tailroom for XDP_FLAGS_SINFO_EXT
buffers. For those buffers this bound reaches the end of the frame, and
frame_sz is the only limit.

>  
>  static inline struct skb_shared_info *
>  xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
>  {
> +	/* Kernel structures stay out of memory that userspace may write */
> +	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
> +		return xdp->rxq->ext_sinfo;
> +
>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>  }

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. The
commit message gives it as the motivation:

    Classic AF_XDP zero copy keeps it in the tail of a UMEM chunk, where
    userspace can rewrite it.

Is classic AF_XDP zero copy meant to stay exposed? XSK pool buffers
never get XDP_FLAGS_SINFO_EXT, either here or later in the series. Later
in the series only xdp_sink_mark() sets the flag, and only for
MP_XDP_ONLY page pools.

So xsk_buff_add_frag() still writes the fragment list into the UMEM
tail:

xsk_buff_add_frag()
  __xdp_buff_add_frag(head, ...)
    xdp_get_shared_info_from_buff(head)
      xdp_data_hard_end(head)

That is the tailroom that xsk_pool_get_rx_frame_size() reserves when
XDP_UMEM_SG_FLAG is set.

Userspace can rewrite nr_frags and frags[] of chunks it has handed over
through the fill ring while NAPI builds a multi-buffer packet. Can a
forged nr_frags then overflow sinfo->frags[]? __xdp_buff_add_frag()
only checks:

	} else if (unlikely(nr_frags == MAX_SKB_FRAGS)) {
		return false;

With a value above MAX_SKB_FRAGS, it writes frags[nr_frags] past the
end of the chunk.

On XDP_PASS, xdp_copy_frags_from_zc() in net/core/xdp.c has the same
problem:

	xinfo = xdp_get_shared_info_from_buff(xdp);
	nr_frags = xinfo->nr_frags;

	for (u32 i = 0; i < nr_frags; i++) {

There is no bound on nr_frags here. It indexes skb_shinfo()->frags[] of
the new skb and copies from skb_frag_address() of the forged frag
netmems. xsk_rcv_zc() also sizes its RX ring reservation from nr_frags.

Triggering this needs a zero-copy AF_XDP socket with XDP_UMEM_SG_FLAG
and an attached XDP program.

Could the commit message say that classic zero copy stays out of scope?
Or could MEM_TYPE_XSK_BUFF_POOL buffers use ext_sinfo as well?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
