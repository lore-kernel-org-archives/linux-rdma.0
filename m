Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635548;
	b=HQUrgx+/Zb9svwvJWcgFIvMb4efxUUGG3YmtyUl0le99NPuRvMTyhUmRgj0SYF2GV0Sp
	 e6M2lAHUJEArJDKwMT4kOANwUWuBqpMsNshCMcsJfWl0tNwRzz/ajnEQSRYEyfP/eGjdw
	 T0vx+rgvtKnaCMyn47QI32IY/KBhZpCF/B8MbcDF+u1NA9J6vIxJiMS/JCLbDlcjiN9Qe
	 uqUWxbi7D0ODbWIuWwriFUDKYsxabdp5AiWWs4gJquwYCauy7PW/nzj3Knas4Fh17gqxc
	 e1E/52BAFcwrj20X6iuVuvHf4QybihRccx83UtV3kc6jZSDPXWc5kTfbML+1hn710yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type;
	bh=4JIpkbzf9JBuRi7wi/hXUTx/9PeRcB5EF6i+tZhvo4s=;
	b=eWrIgM3lZBYS/dNOvlDNrDGoX3hMjdPR1osVnf320EBsk862pk+xzQIW8gZ2CDBFXhA/
	 QTaxlBzEEm/x+i/IN28C7x+G45dWKbH26ZdrFplqJ/x3XY5VrgYXYumuk5EVO7njyOXox
	 1stbnTuljktvuZfXj+MqXpQNAAG4HZwKrR4d+lCMze+f/ZDkuSQ1Oe/JYFps8zzTeU7r5
	 CleLMaIudqtukPVzI6AcdwP9pAyHZGyfGxS9SQHntjz1GM6y+4tA8x3gXN2UImEUgUJVl
	 /zh19lZ8w5Ij86IZWXOizF1t0/nq3HxFjnsmmn2aQ7E8loUpLgk+hsTg/Qq44L+0X1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QbuEShLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2113606A321;
	Wed, 25 Nov 2026 19:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QbuEShLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE21F000C4;
	Wed, 25 Nov 2026 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635547;
	bh=4JIpkbzf9JBuRi7wi/hXUTx/9PeRcB5EF6i+tZhvo4s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QbuEShLi544NaqUt1tLMA3EEz4cc//Z80hoJf2oz3FNzqzd1oMQc6bu7mZPjIM3L4
	 aPysv0MrQF5mpM3fjFSc3MzO1wpRIQP98KRBYcuP6Y8MfZd1zitnhm7W8gIj9K5XZR
	 AxCa+Ytjhw7GZsJEpUSHLenk7kb7Uiv6eOTwsekLT01X1ipiUViZmzpQgE+cSMK2Tg
	 wWfzRS+gFM8Y5CCIus+57t1dQZM1giVuQkMOezHnsargX42ERMy2dp+kQp4dTKLuAs
	 ZbUerKPMxG37Rl81ezxfLltmCIUycyfjK1ziTtnQqeQPCLPw2MCu34fOxsQhmYZVKz
	 gALHJ2T8i6w7w==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/15] xdp: Keep the shared info of a buffer in
 kernel memory
In-Reply-To: <179561567996.3135.9952128421877275714@kernel.org>
References: <20261124125654.183091-2-bjorn@kernel.org>
 <179561567996.3135.9952128421877275714@kernel.org>
Date: Wed, 25 Nov 2026 20:39:04 +0100
Message-ID: <87ld6gog4n.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] A comment is now stale.
>
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the patch's
>   commit message names it and the series leaves it open.
>
> --
>
> xdp: Keep the shared info of a buffer in kernel memory
>
> This patch lets an RX queue keep the skb_shared_info of its XDP buffers
> in kernel memory, allocated by xdp_rxq_info_reg_ext_sinfo(). Buffers
> with the new XDP_FLAGS_SINFO_EXT flag look up their shared info there.
> For such buffers xdp_data_hard_end() reserves no tailroom, and frame
> and skb conversion refuse them.
>
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 1629e347b71fb..944418111a86e 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>
> [ ... ]
>
>> @@ -212,17 +226,27 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>>  
>>  /* Reserve memory area at end-of data area.
>>   *
>> - * This macro reserves tailroom in the XDP buffer by limiting the
>> - * XDP/BPF data access to data_hard_end.  Notice same area (and size)
>> - * is used for XDP_PASS, when constructing the SKB via build_skb().
>> + * This reserves tailroom in the XDP buffer by limiting the XDP/BPF data
>> + * access to data_hard_end.  Notice same area (and size) is used for
>> + * XDP_PASS, when constructing the SKB via build_skb(). Buffers with
>> + * %XDP_FLAGS_SINFO_EXT keep the shared info elsewhere and reserve none.
>>   */
>> -#define xdp_data_hard_end(xdp)				\
>> -	((xdp)->data_hard_start + (xdp)->frame_sz -	\
>> -	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
>> +static __always_inline void *xdp_data_hard_end(const struct xdp_buff *xdp)
>> +{
>> +	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>> +
>> +	if (xdp->flags & XDP_FLAGS_SINFO_EXT)
>> +		tailroom = 0;
>> +	return xdp->data_hard_start + xdp->frame_sz - tailroom;
>> +}
>
> [Severity: Low]
> This isn't a bug, but should the comment in bpf_xdp_adjust_tail() be
> updated along with this change?
>
> net/core/filter.c:bpf_xdp_adjust_tail() {
>     ...
> 	/* Notice that xdp_data_hard_end have reserved some tailroom */
> 	if (unlikely(data_end > data_hard_end))
> 		return -EINVAL;
>     ...
> }
>
> xdp_data_hard_end() no longer reserves tailroom for XDP_FLAGS_SINFO_EXT
> buffers. For those buffers this bound reaches the end of the frame, and
> frame_sz is the only limit.

Yes, will fix.

>>  
>>  static inline struct skb_shared_info *
>>  xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
>>  {
>> +	/* Kernel structures stay out of memory that userspace may write */
>> +	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
>> +		return xdp->rxq->ext_sinfo;
>> +
>>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>>  }
>
> [Severity: High]
> This is a pre-existing issue, not one introduced by this patch. The
> commit message gives it as the motivation:
>
>     Classic AF_XDP zero copy keeps it in the tail of a UMEM chunk, where
>     userspace can rewrite it.
>
> Is classic AF_XDP zero copy meant to stay exposed? XSK pool buffers
> never get XDP_FLAGS_SINFO_EXT, either here or later in the series. Later
> in the series only xdp_sink_mark() sets the flag, and only for
> MP_XDP_ONLY page pools.
>
> So xsk_buff_add_frag() still writes the fragment list into the UMEM
> tail:
>
> xsk_buff_add_frag()
>   __xdp_buff_add_frag(head, ...)
>     xdp_get_shared_info_from_buff(head)
>       xdp_data_hard_end(head)
>
> That is the tailroom that xsk_pool_get_rx_frame_size() reserves when
> XDP_UMEM_SG_FLAG is set.
>
> Userspace can rewrite nr_frags and frags[] of chunks it has handed over
> through the fill ring while NAPI builds a multi-buffer packet. Can a
> forged nr_frags then overflow sinfo->frags[]? __xdp_buff_add_frag()
> only checks:
>
> 	} else if (unlikely(nr_frags == MAX_SKB_FRAGS)) {
> 		return false;
>
> With a value above MAX_SKB_FRAGS, it writes frags[nr_frags] past the
> end of the chunk.
>
> On XDP_PASS, xdp_copy_frags_from_zc() in net/core/xdp.c has the same
> problem:
>
> 	xinfo = xdp_get_shared_info_from_buff(xdp);
> 	nr_frags = xinfo->nr_frags;
>
> 	for (u32 i = 0; i < nr_frags; i++) {
>
> There is no bound on nr_frags here. It indexes skb_shinfo()->frags[] of
> the new skb and copies from skb_frag_address() of the forged frag
> netmems. xsk_rcv_zc() also sizes its RX ring reservation from nr_frags.
>
> Triggering this needs a zero-copy AF_XDP socket with XDP_UMEM_SG_FLAG
> and an attached XDP program.
>
> Could the commit message say that classic zero copy stays out of scope?
> Or could MEM_TYPE_XSK_BUFF_POOL buffers use ext_sinfo as well?

This is older than this series, and the series does not change it.
Classic is out of scope here.

I'll work with Magnus and Maciej to get a fix out for classic.
