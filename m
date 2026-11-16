Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834041;
	b=cmvYbdOCRebUcKN0RA2dWJqoMpBxQZZYmglX3/jSszAnGqH6Fq4avMb21e5U4lXgmEXY
	 tZ2CIl5zuhbIIhMU0BdsamM4dRjZ5qFA2Fr3UVPy6L3zsfIFhSEmv7By6qK8+h4GWGvXO
	 T6he6JkKXQgjW5Yu8AfRDx0aMVnCqbhe/UebDVWEw+xa6ZJT8/SaxZCVezsDSr0X7amtW
	 /qso7aFA5oca2fDxdrwBlScCojogjJ2btjcoggyRUnMQZCGqMttK635yNZ+Eu6QLAyiX8
	 8jNIkv33V4nwvZIMXr5LbwJuja3xBwQBWthH4F8nvYj2O2cmkhb+px4yXsFc4KRtkcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834041;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=A0lt15dazrP0Od4z4K+3GBfoG3CeCvgP6JEaVdUD96c=;
	b=pvksA8RBo0XMBgF59R1i01/zzehqpLlp3GrfBTfw/FU6lQ5T3xTmm8Gs9Zg9vYRZEJ2k
	 GDSeuoT1xZU8Sj875aO6qo8yw4QvS4fsX6uslYqzEgnBp4jxkB7iuv9cksGBYitxUBuwX
	 ahwEdEuGz3iMhfuBmdW5+WYiJN6DPYB0xHiB0a4SUFbZWEjarQPd57IEAS8xghxgDzOZG
	 6GDf2HkI3+4sOGWHpsHb3VxL0p7FXev9jhTYxcAxrfMztFFhn5B89LWZf/KwlTdNbn+LB
	 RUOSfRjPNGhnxRHymbArG1JncGQ8tHyUjoeeo6NHms7hyF8d7I7AP+rkbalEISSuMBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifXL+SA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11639606A334;
	Mon, 16 Nov 2026 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifXL+SA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B7F1F000C7;
	Mon, 16 Nov 2026 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834040;
	bh=A0lt15dazrP0Od4z4K+3GBfoG3CeCvgP6JEaVdUD96c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ifXL+SA7euCTAeExPVRhPilwjDtKh//45zDFhIso3VkvF+pzIpGtGnTaveDMFe4jl
	 7LlKZwjoroZ51+K8aRjTl9z1ptAu8cbKuCcumiweHN1DraqTJK/W7ABDHVTWK5OctF
	 P99BkNl4xKC7MVVHcKSaLWbS8HXJbt27kHMLboT6n3SBt9cUE3+/1Rk+zM8PXObtQG
	 lgp/UFkeOlSswp2YCioItfL5DIjd592lWBGQrufrv/qkm3fqSxD8M2t+YA7QAantWv
	 NdNmhUlpPpbIzcxAZm9zQtlRVHEg7mpO6hy/jBhWHY+BleQkUssHHod/3DBkAFA1Ls
	 8onU+BDtMLPGw==
Subject:
 Re: [PATCH net v9 5/6] net/smc: keep an RDMA write inside the peer's RMBE
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, edumazet@kernel.org,
 pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
 alibuda@linux.alibaba.com, sidraya@linux.ibm.com, ubraun@linux.ibm.com,
 wenjia@linux.ibm.com, raspl@linux.ibm.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, guwen@linux.alibaba.com,
 tonylu@linux.alibaba.com, horms@kernel.org, guangguan.wang@linux.alibaba.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, hidayath@linux.ibm.com
Date: Mon, 16 Nov 2026 13:00:38 +0000
Message-ID: <179483403898.3136.8882184057960679731@kernel.org>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-5-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-5-e5e8fa688177@proton.me>
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

- [Low] The commit message gives the impact of the bug as "With one RMBE
  per RMB, as Linux allocates them, the peer's HCA refuses the write and…
- [Low] The patch rewrites the `peer_rmbe_space` invariant comment in
  `smc_tx_advance_cursors()` (net/smc/smc_tx.c:365) to "can be out of…

--

net/smc: keep an RDMA write inside the peer's RMBE

This commit limits a single RDMA write in smc_tx_rdma_writes() to one
peer RMBE. It also always ends the first destination chunk at the end of
the peer's RMBE, rather than choosing the chunking from the producer and
consumer cursor wraps. The goal is to stop writes past the peer's RMBE,
caused either by a forged consumer cursor or by a conforming peer reading
across the RMBE end before a resend after link failover.

Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me?part=4

> net/smc: keep an RDMA write inside the peer's RMBE
>
> smc_tx_rdma_writes() takes the length of a write from peer_rmbe_space
> and decides from the cursor wraps whether the destination is one chunk
> or two. Both follow the peer's consumer cursor, which nothing bounds: a
> forged one takes a one-chunk write past the peer's RMBE, and so does a
> conforming peer that keeps reading across the end of its RMBE before
> the resend after an SMC-R link failover. With one RMBE per RMB, as
> Linux allocates them, the peer's HCA refuses the write and the link
> goes down.

[Severity: Low]
Does this impact statement cover every peer? It describes peers with one
RMBE per RMB, but the Linux sender also accepts an RMBE index chosen by
the peer:

net/smc/af_smc.c:smcr_conn_save_peer_info() {
    ...
	smc->conn.peer_rmbe_idx = clc->r0.rmbe_idx;
    ...
	smc->conn.tx_off = bufsize * (smc->conn.peer_rmbe_idx - 1);
}

Only the local side hard-codes it, in smc_clc_send_confirm_accept():

	clc->r0.rmbe_idx = 1; /* for now: 1 RMB = 1 RMBE */

smc_tx_rdma_write() then targets the peer's RMB base plus tx_off plus
offset, under the rkey that covers the whole RMB.

Take a peer that puts several RMBEs in one RMB. Wouldn't the overlong
write from before this patch stay inside the registered RMB? Then the HCA
would not refuse it, and the write would overwrite the next connection's
RMBE on that peer.

A conforming peer in the failover case described above looks like it can
hit this too. Could the commit message mention this outcome? Stable
maintainers will use the message to judge urgency.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index d37c747544618..c90bdc77f82de 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -362,7 +362,7 @@ static inline void smc_tx_advance_cursors(struct smc_connection *conn,
>  	smp_mb__before_atomic();
>  	/* data in flight reduces usable snd_wnd */
>  	atomic_sub(len, &conn->peer_rmbe_space);
> -	/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
> +	/* can be out of range, see smc_tx_rdma_writes() */
>  	smp_mb__after_atomic();
>  	smc_curs_add(conn->sndbuf_desc->len, sent, len);
>  }

[Severity: Low]
This comment now says peer_rmbe_space can be out of range. Should the
matching comment in smc_cdc_msg_recv_action() change as well? It still
states the old guarantee, right after the credit that can push the value
above peer_rmbe_size:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
		atomic_add(diff_cons, &conn->peer_rmbe_space);
		/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
    ...
}

For example, in the conforming failover case from the notes, a peer that
reads after the switch is credited peer_rmbe_size + 9000.

Nearby code still relies on the old invariant. The same function clears
urg_tx_pend only when the two values are exactly equal:

	if (diff_cons && conn->urg_tx_pend &&
	    atomic_read(&conn->peer_rmbe_space) == conn->peer_rmbe_size) {

The header comment of smc_curs_diff() in net/smc/smc_cdc.h says
"difference cannot exceed size". That is not true when the consumer
cursor comes off the wire unbounded.

The notes say the smc_cdc.c hunk was left out because it would not apply
to 6.6.y. Could a comment-only fix go in as a separate change that is not
tagged for stable?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177%40proton.me
