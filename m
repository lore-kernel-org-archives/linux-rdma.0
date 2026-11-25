Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615696;
	b=YqmIj1Uy8VI1PvQHf/BUarBL7IvnRpvVICOT6w4GUXdkRJPhCYVGoR9hvdwSBkrIQR06
	 eSAXHqNjJYnhJWnAsfIiwYBnTM/Ll1RzEQczM/n1i/TGMSKzgD4NGF/+A/HVxkFyebcJT
	 ts0O6iWz55WfL206eZFluE+gPtOwGRoJcjhzhdXJ6MBlgA5NIONMXAoAnY7HDJTaZyCcn
	 5c62oX4Ie+BwQIaNSLUZ1ZjX4GOOYmmbZ126R/vayZ56auJ8bfuYBE3IQphhJIzWc6bEB
	 3kvj1y0OG611vdL95pDXryKQb9Jffi2MpswIXxU2OmCOpRuA2ijKwREHFjIEWosRpMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615696;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=uUVLwnKayt6g2P+NkpEhvsPO9KV0gc6su6pn44rfNmw=;
	b=Hqe8nli7hEVUd1N+XGESO9JA3Fb93u9CtyXYCNWMnGaeonXiEDIF8V9/8XRgHOj0FYFW
	 IbbF/G2zOhYkcplrA8/pDkLMqNHyvBLW2LH/HXttMJU2vl1FbIWgD2F94Hvw45g+MLZRO
	 x/VZI0ONJCSZg9esDusBjbElB6X8jOAaf4Or4wNtOXC/ds9Q2JBSRCMFS6kNHgCKMTxlY
	 5Uy8KZ7ZFc6VlLDQYnkP0oxoU0EwEDeLkk7SnRaE3LqoIGr/Qf1RvxBWexFNrNsQ8UkjK
	 89yxfrSlJtJxTf0NolYspJ7BE9SBwdBTR+VLhT7tq5yvBVgRQXyLJ4LmVITETwK2TVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="alt/h17j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67323606A681;
	Wed, 25 Nov 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=alt/h17j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0A41F0157D;
	Wed, 25 Nov 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615696;
	bh=uUVLwnKayt6g2P+NkpEhvsPO9KV0gc6su6pn44rfNmw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=alt/h17jzfl+c+EI4Fx//NL8vNX9t0T38Q9Oh2PqfCsaHyDbjZgxeyvlIGlBVdKMc
	 cr+ldWTEA/yXws0IgxZxeQjkF0riLQYKPEhPkB0tohK0RWOR2Qhm34jTsbx9CaC+c9
	 eJU9zOYnRiR9+vQngCqnkyGoq9I87AGTg4GDmIzZqGRhqfi1tX5yc5pBKEFJi5qGoz
	 Fb8H2ejBfvh6Dklc08Q/r13cQOsKr7DpbRlMpFaTOZ4p6UecXQkB0cyTyLv3T47itN
	 vHIy4lp5K4Z+jtDuY6/saTGCdEddhd22C9wmWywAHccSll45ubcKwZbtvaJO8YXJxE
	 csYHqzSloxwIw==
Subject: Re: [PATCH net-next 05/15] xdp: Run programs on buffers that must not
 hold kernel structures
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
Date: Wed, 25 Nov 2026 14:08:12 +0000
Message-ID: <179561569289.3135.1423395269344157578@kernel.org>
In-Reply-To: <20261124125654.183091-5-bjorn@kernel.org>
References: <20261124125654.183091-5-bjorn@kernel.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new XDP_FLAGS_SINK contract in include/net/xdp.h says a
  helper that checks bytes and reads them again later must check a copy,…
- [Low] The commit message opens with "Currently, the core refuses native
  XDP programs next to a memory provider." That was no longer true when…

--

xdp: Run programs on buffers that must not hold kernel structures

This lets native XDP programs run on AF_XDP sink buffers (UMEM chunks
that userspace may write at any time). Such buffers are marked with
XDP_FLAGS_SINK and XDP_FLAGS_SINFO_EXT, and their shared info moves into
the rxq. XDP_TX and XDP_PASS become XDP_DROP, and frame and skb
construction refuse sink buffers.

> Currently, the core refuses native XDP programs next to a memory
> provider. An AF_XDP sink needs XDP to steer its packets and to use the

[Severity: Low]
Is this opening sentence still accurate at this point in the series?

The previous commit, "net: Add memory providers that only feed XDP",
already exempts MP_XDP_ONLY providers in dev_mp_blocks_xdp():

net/core/dev.c:dev_mp_blocks_xdp() {
    ...
		if (ops && !(ops->flags & MP_XDP_ONLY))
			return true;
    ...
}

That commit also relaxed the dev_xdp_prog_count() check in
__netif_mp_open_rxq() for XDP-only providers.

This patch touches neither net/core/dev.c nor netdev_rx_queue.c. Could
the message be reworded so it doesn't suggest that this patch lifts the
refusal?

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 944418111a86e..c7cb0ba4e16f4 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h

[ ... ]

> @@ -95,6 +99,15 @@ enum xdp_buff_flags {
>  	 * frame, see xdp_data_hard_end(): the frame must hold nothing else.
>  	 */
>  	XDP_FLAGS_SINFO_EXT		= BIT(3),
> +	/* AF_XDP sink memory, see %MP_XDP_ONLY: the buffer may only go to the
> +	 * AF_XDP socket of its queue. Userspace may write it at any time,
> +	 * also while the kernel reads it. So the kernel takes bounds only
> +	 * from its own fields, and only the XDP program and its helpers read
> +	 * the bytes. A helper that checks bytes and reads them again later
> +	 * must check a copy, see bpf_syncookie_th(). Nothing builds a frame
> +	 * or an skb in the buffer.
> +	 */
> +	XDP_FLAGS_SINK			= BIT(4),

[Severity: High]
Where is bpf_syncookie_th() defined? I can't find it in this commit or
later in the series. This comment is the only place the name appears.

The syncookie helpers that XDP programs can call still read th->doff
twice from packet memory:

net/core/filter.c:bpf_tcp_raw_gen_syncookie_ipv4() {
    ...
	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
		return -EINVAL;

	mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
    ...
}

tcp_parse_mss_option() then reads doff again to decide how many option
bytes to walk:

	int length = (th->doff * 4) - sizeof(struct tcphdr);

bpf_tcp_raw_gen_syncookie_ipv6() does the same thing. So does
bpf_tcp_gen_syncookie(), which checks doff and then re-parses the
options through tcp_v4/v6_get_syncookie().

The verifier only checks th_len bytes, because arg2 is ARG_PTR_TO_MEM and
arg3 is ARG_MEM_SIZE_OR_ZERO. With a sink buffer, a userspace thread can
change doff from 5 to 15 between the check and tcp_parse_mss_option().
Could the parse then read up to 40 bytes beyond the region the verifier
checked?

xdp_sink_mark() also sets XDP_FLAGS_SINFO_EXT on sink buffers, so
xdp_data_hard_end() reserves no shared-info tailroom. A program can grow
the tail to the end of the frame. If the TCP header sits at the end of
the last UMEM chunk, can the extra read go past xdp_vaddr + xdp_vsize
and fault in NAPI context?

Classic AF_XDP zero copy has the same double fetch, but there the
shared-info tailroom keeps the extra read inside the chunk.

Should this patch add the copy-and-check that the comment describes for
these helpers? Or, if it is meant to come later, should the comment
point to something that already exists?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
