Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611610;
	b=R5O3wef9WO4zuo2ACK+Uhe81Hm41FD7XoefmKujf6ZjRdahvJjQYBKsxdDyvvk6lq+TP
	 bHNzB432tGxbERI3fgx+qVuMflrIdLR3g66v2j1TqjstaOH31ellFL7lwORJnoQNjrOQt
	 lvoFde8YbM33Xzj6vA3L5oujqK/NTzwj8EvV2x3GYJQNSHoV81kD9jcm4nIIdZgJUTpXg
	 K/OzG2vqMLFO7843iCpME4ExHoMIMcnuTcx35Oj7g9kwe1psxJSvLvYYxjmqh/AMUMN61
	 Qj2NmvMpVtaUbopHkTmmK4H356P+qxyhkM8fRAqZTesN00ClUSwfOIFxf9HW7e5ociQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611610;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Tmfio9WikqIFyA5w25ZA6vSkJ2HuBHEoZrRBuC5c0as=;
	b=D0mCbImRwNZTTVcBfvKP9j26EMdBV/jI1DhSW2BEGr5t6qVZZopExMuKnq8EjGZ+pZI9
	 wVMdHDpQa3V0KLkf1jgtJCEMEkQ7CmdT2XOCk9+lc9VCxAtYTehnat57ZDFsAlZBC+5O7
	 zYnAGWw+YdTEEfhBHIqbNuP4DAKWHNIUq+Sw3SIiY2WZ5gI73ckCvylItOD0qoughgMUF
	 bBObJHVhkjmHMxsSPP5qfpcDJ/M/rgvuMa7bbNeKaJHLm0atfryfB0zMv9MnDrmwjzusf
	 Ay3Za68wt/RePXfDmm++a79nAYOyUc2WYBea0iERQlBoc64UDoe+6ojC0hXWtBm2MoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0MBz0KQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78330606A6A6;
	Wed, 25 Nov 2026 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0MBz0KQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B45C1F000D0;
	Wed, 25 Nov 2026 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611610;
	bh=Tmfio9WikqIFyA5w25ZA6vSkJ2HuBHEoZrRBuC5c0as=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b0MBz0KQmCZbF84Ufarz8Yi31Vy3h+c2T9j93ANFAuBY/ghAurZzym1dmIf7jQ5kg
	 Zk7HmS/9kbX5gdPNn4KaoKK0lsUMp6wB1m/NIiRPEC4Ri7lX4Ss4QNIEnXPw99oCIl
	 bnNaDY+cBvbibr8nI6eYaVqmXIIv10DMHdccosK1zP/YCwDroueEx0tM8qI1CpUwAJ
	 vd0R9HEwhO3x8bvEYWZ7OincqG0RN9rmdNrM155UgrCpAKYWzNF5XNDNFC0FTTUJS5
	 Dk+X1bk+aU64HiGvo3ltmjw7xlh3GidRLLc287bpuwr7ZSa0wdDR5QBRikH+sMu+Ru
	 DH17lBrbwlxKg==
Message-ID: <sashiko-outbox-233411@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/15] xdp: Let memory providers offer XDP a
 view of their net_iovs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-1-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] bpf: missing IS_ERR() check on bpf_xdp_pointer() in
  bpf_dynptr_slice() [1]
--

commit c810409b8d143cccffd67910e9b5cc0e3963ba70
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

xdp: Let memory providers offer XDP a view of their net_iovs

This commit adds an optional XDP virtual address view to net_iov_area and
introduces xdp_netmem_address() and xdp_frag_address() so XDP helpers can
read and write provider-backed net_iovs when a view is present.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index f42ecfb5841f9..d5774b2577e72 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4310,7 +4310,7 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigne=
d long off,
>  			break;
> =20
>  		ptr_off +=3D ptr_len;
> -		ptr_buf =3D skb_frag_address(next_frag);
> +		ptr_buf =3D xdp_frag_address(next_frag);
>  		ptr_len =3D skb_frag_size(next_frag);
>  		next_frag++;
>  	}

[Severity: High]
This problem wasn't introduced by this patch, but can bpf_xdp_copy_buf()
walk uninitialized sinfo->frags and dereference wild pointers in
xdp_frag_address() when bpf_dynptr_slice() ignores an ERR_PTR() return from
bpf_xdp_pointer() [1]?

kernel/bpf/helpers.c:bpf_dynptr_slice() {
    ...
	case BPF_DYNPTR_TYPE_XDP:
	{
		void *xdp_ptr =3D bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
		if (!IS_ERR_OR_NULL(xdp_ptr))
			return xdp_ptr;

		if (!buffer__nullable)
			return NULL;
		bpf_xdp_copy_buf(ptr->data, ptr->offset + offset, buffer__nullable, len, =
false);
		return buffer__nullable;
	}
    ...
}

bpf_dynptr_from_xdp() caches the initial packet length in ptr->size, which
becomes stale if the packet is shrunk with bpf_xdp_adjust_tail().  A slice
request within the old size but past the new length passes
bpf_dynptr_check_off_len() and causes bpf_xdp_pointer() to return
ERR_PTR(-EINVAL).  When buffer__nullable is non-NULL, bpf_dynptr_slice()
Still calls bpf_xdp_copy_buf(), which assumes fragments exist whenever
off + len exceeds the linear area and reads uninitialized
skb_shared_info->frags on a single-buffer xdp_buff.

[1] https://sashiko.dev/#/bug/linux-aa57c490-a988-47e9-b527-87c8137088ea

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D1
