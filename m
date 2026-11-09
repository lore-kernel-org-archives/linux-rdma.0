Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204042;
	b=AnoGQhHVm9t1lVBA1Qy8fVa/wD2gNwDOeLbhsbn0ukdQYFA5ioUeiWcdVMnYwMSZ6prL
	 K4acbJtpduy8mmMSWDirOxIW1pi3I8lUMxPOg3WG8scpjGFyj0cY63etLRqEn0ADvqGQ0
	 nI0tWRFCcHLWeNwmiMRG+SPPPZSMGBSFNNyVPb65mla8J6j2AzLgNwcdDAMOr51NwNKdP
	 ikWpnh30stSrAFYiMiFT4XJEg1umd1nEAPmm7n0DNcyhqRNrYD50dEDiVQC5rpRKYeXvl
	 a43rHaLpCJnzc4pePhO9IAMTm94ZAlklYbZodrue3A52FJwWMSios0Mlur82/fOV0JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204042;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4mkVEltUijvWH6geonsnNhkY5vn7BRa84PNhz7ry3ZE=;
	b=Bvdvs01OTOxsQvVpnkjNCwSITuY49Du51ZtSYyKAnE9ljcsYKQ1otej0NPVX/Y/sIlz8
	 qyuRhIvnMslt6CqTMpVIWKA3JKHsYodtK1J5bCFGuTdh+dAelsg7JBKMp+kXoFES0uSA6
	 lxGv6vZ+roCQa3ryURISsBNNWNcaEkvHfFWl/Wy7E55ULulAng4G0c82WOn0jlFyyEYFy
	 gixyRYIsWM/LstlHEteQlI/LAwS7ElfVB5UWcXpVpd/PyJWi7mGhkBeFOsweW/nTWwNNt
	 kUHiW7PVJtdzfW1+S9zE1gdfBpMIow5/HUVaPLUpHEhYpyqDJ9WZ6hojGeZancJvsJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMONW472;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5225C606A31C;
	Mon,  9 Nov 2026 06:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMONW472
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC251F0089F;
	Mon,  9 Nov 2026 06:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204041;
	bh=4mkVEltUijvWH6geonsnNhkY5vn7BRa84PNhz7ry3ZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMONW472nWSgYQqTYYrISoD0DFQ5v9pvb2y/qgdAvVaOKKq8tN5rHRCx62WH67rp5
	 a0D6ySXvIJpxoqgW9mvufxE2Q9O8nYz2iIAEdgu1N0lO5lpx2UVBzWqIr/8EJg6PmK
	 p+KwLNRlI0Si7WnFNm2ZtryGFPbOm3BVi7X90xdd1PKLrcdQuIdR54/8Zz2nH8z3gQ
	 wIpyNdKMGHcPI+ovf3RyHhl5+GGnOAb4hzp9Cz4e0nyrqB0mCCdeDZqxz8mqJRF2e7
	 b+q4rZhg7wgF6LYu28ALSeTD01lsaHLV5o2mIwmJ53kzXZ4pr45DmxmMbDUahXZHlu
	 q5kSYCzItis6g==
Message-ID: <sashiko-outbox-204471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 2/5] net: skbuff: refcount spliced page_pool
 frags via skb_pipe_buf_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: virtualization@lists.linux.dev, linux-rdma@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261108060016.2131509-3-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 06:00:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Update skb_splice_bits() (spd_fill_page(), sock_spd_release(), and
> skb_pipe_buf_ops) and skb_append_pagefrags() to acquire and release
> references via netmem_inc_ref(), netmem_dec_ref(), and skb_frag_ref()
> so page_pool RX fragments spliced into a pipe remain pinned in the pool
> while in the pipe and pair with skb_append_pagefrags() and
> skb_release_data() when spliced into a TX socket once netmem_inc_ref()
> and netmem_dec_ref() handle page_pool netmems.
>=20
> In tls_push_data(), fall back to copying when MSG_SPLICE_PAGES
> encounters a page_pool page because kTLS device offload record->frags[]
> tracks pages via raw struct page references rather than pp_ref_count
> before handing them to tls_push_sg().
>=20
> Caveats:
> - Because pipe buffers created by skb_splice_bits() hold pp_ref_count
>   until released (including across tee()), user pipes holding
>   unconsumed spliced data keep those page_pool pages in-flight and
>   DMA-mapped in the pool (bounded by pipe capacity and RLIMIT_NOFILE
>   rather than sk_rcvbuf) until the pipe buffers are consumed or closed,
>   with page_pool_destroy() deferring pool release via its periodic
>   workqueue and page_pool_scrub() unmapping DMA.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D2

