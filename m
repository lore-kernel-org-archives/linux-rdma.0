Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795133701;
	b=aHDvFzTK7M8p53qNqkdaF0cRHubRKy2/MIFLrwBNBf0hAOtTkmwUZ4qSd5i6/HLjyK5d
	 sreFs4qnE1tW8ZdTvO+0Rb10buO9piffOKv5UbD3VD482+8lLMEaAZbvsvvksRz/ccv5c
	 2LwOyijEozbwq+Wsz2WfkZGB0yeXhoyZCePFaEI5veXIqk6KZLXS0MEYRdmGcCKJ3xBi6
	 1nU46bNcWsoOOmB+ST0paxBBaFO1taKSoE318FuFzwn3BH+/3TxzR/BmrdS7d13GBQ5+J
	 u2Ll0WVEt8gOYyxTpwLD6x4BaCsXJUvZc1q4QMG3DLhtQ4am7lzXgxZmENAY65F1iVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795133701;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8y/gyTTcX7qcmg0sjlm00Cr55vyWW6VRqyEPN6Mwc4Y=;
	b=ldTxFrwn+Qt/6CaLBwlcQdE5PWo/hgdjO79rbguQSqpnels3MKUFKSuIZPUCtZ7m+f0T
	 WnFdzS4UJ2KhnjNkPpq6Oas1smjIVEFLHXLhoSrd50sBvVDBpVobXqSjyX3YffXF1EOQz
	 MegsLNOO5LD4Q0ilV1y6k96Jijsd8cN5CGtczrXR1tmv8FvyiJXDXIhj7rbVVMZ4kklSX
	 RauxoRpZNotSrK7atqufuEG9/gK3Q+aczsi7vruEKcEZxK+UkfbIDGB8SlhDVT+M5cDVo
	 oVTZQdZ0sCIVrg1vHUU+PO19l9siVrh1+Qu7IvuVvTuv/QlZTyhNMAV9cb75ksX6O2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gbz3NCsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23BB606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 00:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gbz3NCsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A0D1F000C6;
	Fri, 20 Nov 2026 00:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795133701;
	bh=8y/gyTTcX7qcmg0sjlm00Cr55vyWW6VRqyEPN6Mwc4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gbz3NCsV2gVAxvukvLW3W0ABoBgWAkKxUbpVaSFnPWrP47CFaTfdGLUoMleWWKuRN
	 c/wis5oOOHVdMIFusN/g3LWJ+OTw1LdMiTgehhHuujhyzrchWTQpq09RwvvgWu34HL
	 zr6rJ1TNBqli6GkS8WTrj/luUAWjxSEyDX8qhyJPt5somuSk1QsysE9S3Y+9BU1KN5
	 RVI0Q2OfHK5l7VgEDZ2FSEOATfrrOx5fiR309YEmmOGNOj4Ye28s7YHKe+9R/iWdoG
	 Rn0QpXQRWL5Pqe/HBpTAMX7oLarJmtGubjqG1vCks2hVBjCBJE9r525V0mLtSHH4eo
	 Gb/ncpC1mYFkA==
Message-ID: <sashiko-outbox-224260@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Reject a zero length WRITE segment
 that announces more segments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120000829.64597-1-astellman@stellman-greene.com>
References: <20261120000829.64597-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 00:15:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_proc_write() returns early for a zero length tagged segment, before
> it looks up the sink STag. If that first segment has the L bit clear,
> the next segment is handled as a continuation of the same message and
> siw reads mem->stag through rx_mem, which was never set. A remote peer
> on an established siw connection can trigger this, and it panics the
> host:
>=20
>   Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000004: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
>   RIP: 0010:siw_proc_write+0x175/0x9c0
>   Call Trace:
>    <IRQ>
>    siw_tcp_rx_data+0x20e/0x2040
>    __tcp_read_sock+0x1ab/0x810
>    siw_qp_llp_data_ready+0x185/0x2e0
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120000829.6459=
7-1-astellman@stellman-greene.com?part=3D1

