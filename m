Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643874;
	b=EjL9U80HpqfVblC46S3vUIcBH5inmUUQUIwiPwf6llvf4eUEstsw3c/eizhE46rkmCWt
	 qa0ragFzcAT0jlfslO0n18kvybDdnFp2j6aRjFVm82IpBOdUFf8PNzFFgkOJHZAn93mZb
	 qB+JVzlk54AQsMXiIfRT3NbTW10IkkuXs1xYbZsoc9ztsqULnWYRb19MV6Xc0Vp6hBn5x
	 9FqXwExQovxyyL/9JuBOGtaVhMiDNUG8ysSHyUNxRs6eIXPrjhwl/D/QODqBT8y9mxdFJ
	 Rdzkn7b44crSN0HI66EiP/Bxjd9me7n/uoaIEKBkZaJbyHFxs5vFE4AyGm9Zn6DG5JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643874;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JBiOmAoK1Eu0Hdo9Wc6R3KmS5P5zsH+XAnYYHBzFrKg=;
	b=q3FzCF4+VJFT0IebfV7/9uktJr6BvwMOwOUcyCEyA09ksh+nIh1u/RADhM2DWOAn1T6j
	 u884bV1vN00eNtyeu7qzgiEa4kGjPijhAvOHwXclKsErQIyZHgmbVI6pBeN7G9JFjBiSM
	 owGQY708FCalV/+2TosR6zeGIoaEBzm12qtmnJYtDPGHOL76tVrUdl150+m9OievrdOGz
	 TSD7Fzem2Z3w4YHdYzgmRapR5wWKCTyO0FeYrgfwCR/S0rlsr54nKNpOvmzxr/U8VywD6
	 aCjdhCHLa90hYuZ96SAHIXaDhAVIINRg0vWfd5zKLlogNhX07hCPwVIpBUdNTXfc4cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej5GoNKG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34C0606D80A;
	Mon,  2 Nov 2026 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej5GoNKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8861F00A16;
	Mon,  2 Nov 2026 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793643873;
	bh=JBiOmAoK1Eu0Hdo9Wc6R3KmS5P5zsH+XAnYYHBzFrKg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ej5GoNKGbYhkZWFX0e4PX1MdCrdDtWOnCZG2GNNgQzv+E9W2CZw+6e56VBL995qfq
	 16epNVB+ELmtn85LGtHACL17xtCm+zHaOK0MMxHc7UhoCRoPbjSU9CDjswOcE0I0rL
	 cNP4HbhsESDH/bSzREj2z36rIr9Ws55OE/8gtySWA0ZoOIb0hubXGokTt7W6fH+a9i
	 WKDoRP/gAUTS0fdlKlX1rjCNEYtxN38yXMjd37xgZGnuRYSotqicYsEoHA60WYqw9s
	 Wn0egjfdeLMR/H37th/uUiXmpcNRXlb67TpBSYpwRCJGcl/sk6m3JiYITIN55SIBZE
	 7BUp2zrcdBACA==
Subject: Re: [PATCH net v8 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, kuba@kernel.org, mjambigi@linux.ibm.com,
 pabeni@redhat.com, alibuda@linux.alibaba.com, davem@davemloft.net,
 dust.li@linux.alibaba.com, edumazet@kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com, raspl@linux.ibm.com,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, hidayath@linux.ibm.com, horms@kernel.org,
 wenjia@linux.ibm.com, tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
Date: Mon, 02 Nov 2026 18:24:32 +0000
Message-ID: <179364387223.3131.12837391370219531719@kernel.org>
In-Reply-To: <20261029-b4-disp-33001ace-v8-3-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-3-f9bb96e17827@proton.me>
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

- [Low] The commit message of "net/smc: bound the send length to the send
  buffer in smc_tx_sendmsg()" only says the clamp keeps the copy inside…
- [Low] The patch changes the comment after atomic_sub() in
  smc_tx_sendmsg() from 'guarantee 0 <= sndbuf_space <=…

Pre-existing issues:
- [High] smc_tx_sendmsg() now clamps writespace to sndbuf_desc->len, not
  to the free ring space actually left (len minus the bytes between…

--

net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

This patch clamps writespace in smc_tx_sendmsg() to sndbuf_desc->len, and
negative values get the same clamp. The copy into the send buffer can then
no longer run past the end of the ring when conn->sndbuf_space has been
over-credited, either after an SMC-R link failover or by SMC-D DMB merge.
It also changes the comment after atomic_sub() so it no longer claims that
the counter stays in range.

> Clamp writespace, which sizes the copy, to sndbuf_desc->len, negative
> values included, so the copy stays in the send buffer.

[Severity: Low]
Should the changelog also say what this patch leaves unfixed?

The notes below the --- line say two things. The over-credit is not undone,
and send() can still overwrite data in the buffer that the peer has not
received yet. Those notes are dropped when the patch is applied.

The patch has Cc: stable and the two Fixes: tags. Without the notes, the
permanent log suggests the failover and DMB merge accounting problem is
fixed. Only its out-of-bounds symptom in smc_tx_sendmsg() is.

Later in the series, "net/smc: bound the link failover cursor advance to the
send buffer" bounds the smc_switch_cursor() catch-up credit. Nothing in the
series changes the late-completion credit in smc_cdc_tx_handler():

net/smc/smc_cdc.c:smc_cdc_tx_handler() {
    ...
		atomic_add(diff, &cdcpend->conn->sndbuf_space);
		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
		smp_mb__after_atomic();
		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);
    ...
}

The diff_tx credit in smc_cdc_msg_recv_action() is also left alone.

Could the --- note be moved into the commit message, so stable backporters
can see the remaining risk?

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 0f0c6df3bf2ce..3913ef103b356 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace = atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space can be out of range: late completions of an
> +		 * old SMC-R link credit it again after a failover, and with
> +		 * SMC-D DMB merge it follows the peer's consumer cursor.
> +		 * Bound writespace, which sizes the copy; a negative value
> +		 * would become huge in the size_t min_t() below.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace = conn->sndbuf_desc->len;

[Severity: High]
This is a pre-existing issue, but this clamp limits the copy to the size of
the ring, not to the free space left in it. The free space is len minus the
bytes between tx_curs_fin and tx_curs_prep.

Can stream data still be overwritten in smc_tx_sendmsg() once sndbuf_space
has been over-credited?

The only decrement is the atomic_sub(copylen, &conn->sndbuf_space) further
down. It removes exactly what was copied, so any excess X carries over to
the next loop iteration and to the next sendmsg().

For example, with prep == fin and sndbuf_space == len + X:

  iteration 1: copylen = len, sndbuf_space becomes X
               nothing is posted if the peer RMB is full or the
               socket is corked
  iteration 2: !atomic_read(&conn->sndbuf_space) is false, so no wait
               memcpy_from_msg() writes X bytes at
               tx_cnt_prep == fin.count

The second copy lands on data that has not been sent or confirmed yet.
sendmsg() still reports every byte as sent.

For SMC-R, the old link stays alive during failover:

  smcr_link_down()
    smc_switch_conns()
      smc_switch_cursor()  <- under conn->send_lock
    ...
    smcr_link_clear()      <- old QP destroyed only here

Until smcr_link_clear() runs, successful CQEs from the old link still reach
smc_cdc_tx_handler(). That handler runs under bh_lock_sock only. It copies
cdcpend->cursor into tx_curs_fin without checking that the cursor is newer.

The range [tx_curs_fin, tx_curs_sent) can still be the source of RDMA WRITE
WRs posted on the old link. Does that mean the CPU write races with the HCA
read?

With SMC-D DMB merge the sndbuf is the peer DMB. The same copy would then
overwrite peer data that has not been consumed yet.

A negative sndbuf_space is mapped to len here. smc_tx_wait() also treats
any non-zero value as writable:

net/smc/smc_tx.c:smc_tx_wait() {
    ...
		if (atomic_read(&conn->sndbuf_space) && !conn->urg_tx_pend)
			break; /* at least 1 byte of free & no urgent data */
    ...
}

So a negative counter never blocks the sender either.

Once prep has lapped sent, smc_curs_diff() in smc_tx_rdma_writes() also
gets the wrong to_send:

  to_send = smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);

Bytes could then be skipped or sent twice.

The --- note says this is known. "net/smc: bound the link failover cursor
advance to the send buffer" only bounds the smc_switch_cursor() catch-up.
Nothing in the series changes the credit in smc_cdc_tx_handler().

Would it make sense to also bound the copy by the real free ring space? The
other option is a tx_curs_fin update that only moves forward and survives
the u16 wrap. Either one would extend this clamp, not replace it.

[ ... ]

> @@ -278,7 +286,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* increased in send tasklet smc_cdc_tx_handler() */
>  		smp_mb__before_atomic();
>  		atomic_sub(copylen, &conn->sndbuf_space);
> -		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
> +		/* can be out of range, see writespace above */

[Severity: Low]
This comment now says sndbuf_space can be out of range. Three credit sites
in net/smc/smc_cdc.c still carry the old text: smc_cdc_tx_handler(),
smcd_cdc_msg_send() and smc_cdc_msg_recv_action(). For example:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
			atomic_add(diff_tx, &conn->sndbuf_space);
			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
    ...
}

Should these be updated too? smc_cdc_tx_handler() and
smc_cdc_msg_recv_action() are the two sites that the new comment in
smc_tx_sendmsg() blames for the over-credit.

Earlier in this series, "net/smc: bound the receive length to the RMB"
changed the matching bytes_to_rcv comment in smc_cdc_msg_recv_action() to
"can be out of range, see smc_rx_data_available()".

With both versions in the tree, someone reading only smc_cdc.c could take
the clamp for dead code and remove it.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me
