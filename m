Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411961;
	b=TDWLlFYs4G23fSdMUX8lqNNqpx9AwFQARPEpqxBI8Rwz7jR5oSJPGwWUAvkiWoxyDn/u
	 S1/KJs69P+hgLODP5d7kZSYNIHkPP/as60yQJLXVj5GcUpxiGWOUQu4Uui3IJa8Nr7GNc
	 M8vePGrT38ueBx9Q3q7+Y9eBy8b9O0CCAdPRNFsNDnJeQnbRQPvQ7993PHz9oWMdC7+Ni
	 NaJKkmf9tOIEwdYjuH9+lTQW1KFswF+HilGLzTCoY8sgK/BKOBTYyTzhsPjNuJmjARo2l
	 1RM3F3m73uAnQpyms5IZ5NzPgn3WAMmFhk8KIlNyMpFdsCtSYiSzXw39S9hOSm6vsTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411961;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sVO247Wbqhux4+qjtanaFp3nYtxC3F/XY+znIzZQThE=;
	b=LsU6aa3dIs7M/GL+SKWlxMqaGvGqPXsBASFfI7q8YmqjXr72/IC9JqMeUXz80hDWdEY4
	 /e1AKzyI9VyJPaTJcgaV2BpTRAtKj2mquJhROVAoyTo4/QfwEkg8JaWNWqkwkbYWJj9pr
	 d21aW9PPkV8J6OHJ4ivuwqZ0Eybv+ojKtbcDuTxhYSbcITgYbEQdZG/bY6OCECBgNBkia
	 OZwJn2VUO35XJ4JgK+mwxBVx9CtNmcEjkeg0r6AVO8KlGPERz+LYfMSN1WT/A+Wd9W9r6
	 jXS2DJTz+wgglydEmy8LDVpkPCXajcqa9Hxsm2Bl3JoJ3iVM9oX/z9XzXsAHpFS9bJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Msl/3UIv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F783606A31A;
	Mon, 23 Nov 2026 05:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Msl/3UIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395601F000D1;
	Mon, 23 Nov 2026 05:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795411960;
	bh=sVO247Wbqhux4+qjtanaFp3nYtxC3F/XY+znIzZQThE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Msl/3UIvjdnueU4SPBiavA4KGUn9qRSZ/QBezSvVHb99RbY02Cctz3ZmDWZflb+hG
	 by0y+nxhLfKpO/EtqVZ4NjTKHgq5PpECWmtv7umoTTDh6xgnFpnS3OkeZquXFxgswL
	 TDNMPCJbeOkkOCGTQuMXdYpo4DcRGo2QPApaWXMtFeAbFPd0D9uvYqk9Htv1JEaeN8
	 Gqp4/t7UbkyRiXwOIwYk7h/kD3FNK+4qIqv9GFeMGnJ/dxeNVd/ocsNm2lpSOoqh8G
	 1rASnclh1v8+UM6HxNAIPDK5mfbRLXnhvFCrnVsY0tini0cf93j1U7GQfHNEJRB82z
	 eYOb21N+Zf0lA==
Message-ID: <sashiko-outbox-228720@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: bound a send by the send buffer, not by
 the peer's credit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Piyus Kedia" <piyus@iiitd.ac.in>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261122053223.2497832-2-piyus@iiitd.ac.in>
References: <20261122053223.2497832-1-piyus@iiitd.ac.in>
 <20261122053223.2497832-2-piyus@iiitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 05:32:39 +0000
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
- [High] net/smc: incomplete sndbuf_space bounds in smc_tx_sendmsg() on
  peer credit
--

commit f945a5f042b06d7f73ad24c4711b9b326889bb84
Author: Piyus Kedia <piyus@iiitd.ac.in>

net/smc: bound a send by the send buffer, not by the peer's credit

This commit clamps copylen in smc_tx_sendmsg() to conn->sndbuf_desc->len so
that an inflated conn->sndbuf_space credited from a peer's consumer cursor
cannot cause a single ring-buffer write to copy past the end of the send
buffer.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 0f0c6df3bf2ce..5dc489bf624ed 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -235,6 +235,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msgh=
dr *msg, size_t len)
>  		writespace =3D atomic_read(&conn->sndbuf_space);
>  		/* not more than what user space asked for */
>  		copylen =3D min_t(size_t, send_remaining, writespace);
> +		/* and never more than the send buffer holds.  sndbuf_space is
> +		 * credited in smc_cdc_msg_recv_action() from the peer's
> +		 * consumer cursor on the SMC-D DMB-nocopy path, so it is not a
> +		 * value this side computed, and the second chunk below is not
> +		 * clamped against the buffer the way the first one is.
> +		 */
> +		copylen =3D min_t(size_t, copylen, conn->sndbuf_desc->len);

[Severity: High]
Does clamping copylen per loop iteration suffice when conn->sndbuf_space is
inflated by the peer?

Because smc_tx_sendmsg() loops while msg_data_left(msg) is non-zero, a sing=
le
sendmsg() call with len > conn->sndbuf_desc->len will subtract
conn->sndbuf_desc->len from the inflated conn->sndbuf_space and immediately
run another iteration whenever transmission is deferred or corked (for
example under MSG_MORE or TCP_CORK, where smc_tx_should_cork() stays true
because atomic_read(&conn->sndbuf_space) is still non-zero).  Subsequent
iterations overwrite unsent data in sndbuf and advance conn->tx_curs_prep
more than conn->sndbuf_desc->len ahead of conn->tx_curs_sent, which causes
smc_curs_diff() in smc_tx_rdma_writes() to compute to_send >
conn->sndbuf_desc->len or permanently desynchronize the cursor wrap counter=
s.

In addition, if diff_tx in smc_cdc_msg_recv_action() overflows the signed
32-bit conn->sndbuf_space negative, !atomic_read(&conn->sndbuf_space) does
not block and min_t(size_t, send_remaining, writespace) sign-extends the
negative writespace to a large unsigned value that this clamp turns into a
full-buffer write.  Validating that conn->local_rx_ctrl.cons does not pass
conn->tx_curs_sent (and capping conn->sndbuf_space to conn->sndbuf_desc->le=
n)
in smc_cdc_msg_recv_action() would preserve the 0 <=3D sndbuf_space <=3D
sndbuf_desc->len invariant across all iterations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122053223.2497=
832-2-piyus@iiitd.ac.in?part=3D1
