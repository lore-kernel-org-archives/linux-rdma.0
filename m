Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611611;
	b=RtBSO1oWV1lTovqYIsilTNouOzQPvQtxw2Ni+EiloP3K+7RlFmokcVSUhmgyRxbyu/L7
	 qo8YRIFosfiFlxNZQwF33X7Wdtn3YaR59t9nBwePdOy9PADTb4WEN+fvsRl9SU36Sltx7
	 jQX8RkBBE+Q4zTs8tyNn8/B4ssidJ92UW6+Vds5IfQc5/OooF09lNerSnZbo9fY8fQpd5
	 PqesH+QeOy7LCG+RDOzgJRD/QuShyAh5e8GCepel+jqt/HvuLv/2Ok6lP2LzYelwU7lZZ
	 fEVrc0/4WSML0YjFi9xq0EQlaAG9U7CwnEMgTHpPeiQeCPleYrOmkOuEkyDLATezXzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611611;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+W+b0STbBr969GKmcWEIlBAOoLgCqhJOhr9Qb84R3pE=;
	b=byqd4Ke+VnoKmj9IDecOsyQ87s0IK8RJ1Jx5K7vsMo5Y1iDnJRSqRrQlCTQdJtPqGvfr
	 C5ckegQr6rSh+HXhFdrywQbCPjoIifEEbLExxf6c6sGex5AchfXz8MVWAvZz0LskHv7Pl
	 Lmcvguf0sV8L/YX3K3GpsrFZBS5Sx/abCRb/f2xLVApvnUl66n9lhM72ImfEYQeoG4g1C
	 OG5QY4EgKg7/u8NZfj21ujgib4vqR+u+GrBbhp1PP0j2+jSjPWZ2pMEQOgb9Y4QLKHIXi
	 Ra18Jb4GyHZrLcUTi1IV+P8S3MEEfzffT5PdKUoPMqguwmGHlWrRURU1HLAqZNi6mWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9qb0Kme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D45606A33A;
	Wed, 25 Nov 2026 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9qb0Kme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091861F000D0;
	Wed, 25 Nov 2026 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611611;
	bh=+W+b0STbBr969GKmcWEIlBAOoLgCqhJOhr9Qb84R3pE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9qb0Kme9J5ZVXT051A+EWtpob0QOykPrOOrZqkrQh4Twi/4jGsB1HMR078/eb1kT
	 XPHBxw/b26f3JEdXM+6ZNn5Gppsasny+lZex9Tj9QJEmKuuEf/QKDdv/HNGLhC2pkf
	 sBWfmuNRx+MTlaKCdM2E+Amz8dNZAEsK+3Gt/Px0OYzwUXhs24aXn0g6JLyBFBF7fS
	 0nlFTkvjYAy50rjsX3G7xFtOJrFitMJa8sMwfZD+S8J195HZI5GJlixnFd0nz/zOe1
	 JjLmle4fu0Rf1OFZ7j4Wyq/kvaXSUQKS76YbZvugbEpWgKzPlcnIcOCQ9SLBeC7x41
	 wVgJ8QOR753VA==
Message-ID: <sashiko-outbox-233415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/15] xdp: Run programs on buffers that must
 not hold kernel structures
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-5-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-5-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] xdp: missing bpf_syncookie_th() allows double-fetch OOB read on
  sink buffers
--

commit b4ad66c3d86af2bd4e09e9ce63f3109fcc6d6fe8
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

xdp: Run programs on buffers that must not hold kernel structures

This commit allows native XDP programs to run on AF_XDP sink buffers by
marking them with XDP_FLAGS_SINK and XDP_FLAGS_SINFO_EXT, keeping shared
info in the queue and preventing frame or skb construction in the buffer.

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 944418111a86e..c7cb0ba4e16f4 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
[ ... ]
> @@ -95,6 +99,15 @@ enum xdp_buff_flags {
>  	 * frame, see xdp_data_hard_end(): the frame must hold nothing else.
>  	 */
>  	XDP_FLAGS_SINFO_EXT		=3D BIT(3),
> +	/* AF_XDP sink memory, see %MP_XDP_ONLY: the buffer may only go to the
> +	 * AF_XDP socket of its queue. Userspace may write it at any time,
> +	 * also while the kernel reads it. So the kernel takes bounds only
> +	 * from its own fields, and only the XDP program and its helpers read
> +	 * the bytes. A helper that checks bytes and reads them again later
> +	 * must check a copy, see bpf_syncookie_th(). Nothing builds a frame
> +	 * or an skb in the buffer.
> +	 */
> +	XDP_FLAGS_SINK			=3D BIT(4),
>  };

[Severity: High]
Is bpf_syncookie_th() missing from this commit?

bpf_tcp_gen_syncookie(), bpf_tcp_raw_gen_syncookie_ipv4() and
bpf_tcp_raw_gen_syncookie_ipv6() still validate th->doff in place on the
live packet buffer and pass th to tcp_parse_mss_option(), which re-reads
th->doff to bound its option loop:

net/core/filter.c:bpf_tcp_raw_gen_syncookie_ipv4() {
	if (unlikely(th_len < sizeof(*th) || th_len !=3D th->doff * 4))
		return -EINVAL;

	mss =3D tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
}

net/ipv4/tcp_input.c:tcp_parse_mss_option() {
	const unsigned char *ptr =3D (const unsigned char *)(th + 1);
	int length =3D (th->doff * 4) - sizeof(struct tcphdr);

	while (length > 0) {
}

If userspace increases th->doff in the UMEM buffer between the two reads,
tcp_parse_mss_option() reads up to 40 bytes past th + th_len, which can
fault past the end of the UMEM kernel mapping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D5
