Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635293;
	b=l4ScD/vGhYAWVfxUVUAUiqzKOWUEx60VX9j9Rs6PTQUbYzjkCqE8jKia5fGoImNVvJWX
	 CBZZsvzNHo7wlNTykzLDRgvu5rnRROnlZp0sDI5YP2Kghu0KKGejbyk4Tvtz1obXbhpQ6
	 28UvXJyg//ZX6XhlEtQuEB2hxNv/Ux/I0UAmE/c2n2e7iL2C5n63zBBQjMipMm2T+5b9D
	 JuCZeNAMWW4p1M5WShvD/hQ1BbmIkeM1ZeDxxaJrm+9Rf6rYJQfDmIy+uCa/5AlUgsSIl
	 Ib8zgyLq0ty68O1KIZtVGRZ6uuhhtFCJ+pt9xAjNuMhoEBfwnO8QQznqkGhQ4RruR1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type;
	bh=dYZOemA/qTJTEoh2g11GwnoMyEY6Vi5ttKSGXwzq7LY=;
	b=xZtVKMkYUPlFg0FRYM0HdKx1w8m4osRxP2CuBxvd1K/A58baDMTHHh8CkZn+ZcpsKGIK
	 arRZb7IkwV2Dm5zCaFTw/3tzMMXN9wqyA5UJg+goSzpBADyL86zEBAevVucz01iEAgUG6
	 fCYlo+FpAR04Z7VAdpOxuFRin4ppg0vWAkSY96H6WhCse2OC6Vny/M7c4lVhLyPJHTw4P
	 tXnuBe+aGtquCJIjmiAePq76C7ZQwfz+UHEEWfaLGSxV5Cxae/9Vbx8g2Vg4mAeM7oi6U
	 Rw5cY71EOnxtAoztdopTKl0SeabB0XDiydEcge4WjwIhr9iNdH5ByPPaArIwpKbuF/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cKi3ccR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31B6606A31E;
	Wed, 25 Nov 2026 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cKi3ccR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A21F000C4;
	Wed, 25 Nov 2026 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635293;
	bh=dYZOemA/qTJTEoh2g11GwnoMyEY6Vi5ttKSGXwzq7LY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=cKi3ccR2YGoo7Tc8miltHOfUD8mmvx6/MHxsMi0eT3eS6LDkCqxwMCkwEW6puFpIS
	 xppn7v12LpUDEfpfCx6LtMW9vdZUHRVOWstgH+/RFzUFuz1+a/kbo/qQyeUV2KAmAT
	 /iq2nVXN4vLgHIpAvud5FKM2AeDGFbTD+svS6gb9346St9wi+yalpd7RtIluHBLdE6
	 219PQmUySdaQChKecr+DPTnNnq2IiWJTUOwUrdjnUJ8GlITA2YWu+IbZoPjG7PDyM5
	 J5Vzd4Vzayyf/MRo77TesrYiHMVus61hL0QbSvrciZHUbcQZCuYXWOG9QQ+qWkIb5V
	 DGK/xnFnTvfGg==
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
Subject: Re: [PATCH net-next 01/15] xdp: Let memory providers offer XDP a
 view of their net_iovs
In-Reply-To: <179561567567.3135.2081478467669976102@kernel.org>
References: <20261124125654.183091-1-bjorn@kernel.org>
 <179561567567.3135.2081478467669976102@kernel.org>
Date: Wed, 25 Nov 2026 20:34:49 +0100
Message-ID: <87v75kogbq.fsf@all.your.base.are.belong.to.us>
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
> - [Low] Two comments in include/net/xdp.h now contradict each other.
>
> --
>
> xdp: Let memory providers offer XDP a view of their net_iovs
>
> This commit lets a net_iov area expose an XDP view: an address and size
> for its net_iovs, plus a shift that gives the per-net_iov stride. It adds
> xdp_netmem_address() and xdp_frag_address(). The XDP buffer helpers in
> net/core/filter.c now use them, so they can read and write frags backed by
> net_iovs that have a view.
>
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 07231adfb5f82..1629e347b71fb 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -164,6 +164,40 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>>  #endif
>>  }
>>  
>> +/* XDP view of net_iovs: a memory provider may give XDP an address for its
>> + * net_iovs, see &net_iov_area.xdp_vaddr. XDP code may read and write a
>> + * net_iov only through these helpers, and only if its provider offers a
>> + * view; such buffers must not become skb frags or xdp_frames. For the core
>> + * and the stack every net_iov stays unreadable: netmem_address() and
>> + * skb_frag_address() give NULL for it. A net_iov without a view gives NULL
>> + * here too, so a reader that does not use these helpers fails closed.
>> + */
>
> [Severity: Low]
> This isn't a bug, but does this comment now contradict the older one on
> XDP_FLAGS_FRAGS_UNREADABLE in the same header?
>
> include/net/xdp.h:
> 	/* frags have unreadable mem, this can't be true for real XDP packets,
> 	 * but drivers may use XDP helpers to construct Rx pkt state even when
> 	 * XDP program is not attached.
> 	 */
> 	XDP_FLAGS_FRAGS_UNREADABLE	= BIT(2),
>
> The new block says XDP code may read and write net_iov frags when the
> provider offers a view. That means XDP programs are expected to run on
> buffers with net_iov frags.
>
> xdp_buff_add_frag() still sets the flag for every net_iov frag, whether or
> not it has a view. After the later patch "xdp: Run programs on buffers
> that must not hold kernel structures", it sets both
> XDP_FLAGS_FRAGS_UNREADABLE and XDP_FLAGS_SINK on NET_IOV_XSK frags:
>
> 	if (unlikely(netmem_is_net_iov(netmem))) {
> 		xdp_buff_set_frag_unreadable(xdp);
> 		/* AF_XDP sink memory may only go to the socket of its queue */
> 		if (netmem_to_net_iov(netmem)->type == NET_IOV_XSK)
> 			xdp->flags |= XDP_FLAGS_SINK;
> 	}
>
> Native XDP programs then run on those buffers, so real XDP packets carry
> the flag. At the end of the series, the old comment is unchanged.
>
> Could the XDP_FLAGS_FRAGS_UNREADABLE comment be updated to match?

Yes, I'll fix this in the next version.
