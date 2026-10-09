Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162BD45516B;
	Fri,  9 Oct 2026 06:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528081; cv=none; b=cuN3ouzLEaLdSLOPaxL9EmktFzPNDUoNZ/M32D9aT8Lue4MZtqzIZfzORnIKjvX8NiojnwXhh9lqjv9h9reMkeSZ9Rgj5FTJFlMsA9awj1lO7bohyeIVpK150R3qAxbCkX8oIJ9ioGqjGcPFIpNvsd79MH215zSw//zPApPLvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528081; c=relaxed/simple;
	bh=tD6ZV4tyEF7A8xjQiay8Q4YdSgO3/VPcwL0vFNNYAM4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RyeT8byffucwHbDUEsRLFmB+ngNN8J58I5tNFu2P7TnEuTyxLMYPthghbwl1pbcXFbqMjLD/pSmOhRsLg1JB87lZqabySxSUG5NC6AuzLoG9SPSO5qXz2vj3cgs5rAAo3hn3f/Lm69sibLdPvM00kdtnsSvZrcWGqIAIj34hlLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Piv229HD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Piv229HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B851F00893;
	Fri,  9 Oct 2026 06:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791528079;
	bh=krCHDOHKst58y/pKVrRr0yvZuaPny35S9bksVB6HOGA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Piv229HDEJHQ41jLEUEQsa3uzBLTBVYlVvDWs9vKjC/eL7oaO7jKDV9BTgllNWHB+
	 uPNeNKEw2klThGJ1xPlQ5qj1aZAEpsTo6/tvBsUbJMv7LOtAkl9O/3S/3g5Gtbl6gP
	 XetYbT++evN2n8MYBpRqOTvJqLpJq/y1i7vgjN+LzcXzp6ZoSuhVgOjeOp5hXq55mw
	 2KnqT/H2Zp7Hwn0rcw/TaIhOHhyQmMp10nj7Ck+yB+c/p1dBTRs9IZhsiMks4MIKFb
	 bayTBnvny6iKmEybvfqLnoYfQE4KaSDqnOIx/2t8piGFfao0uiGQluZFn033NeTgXD
	 /cvA6X5Wb+Hsg==
Subject: Re: [PATCH net v6 2/3] net/smc: bound the receive length to the RMB
 in smc_rx_recvmsg()
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, alibuda@linux.alibaba.com, edumazet@kernel.org,
 mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, davem@davemloft.net,
 pabeni@redhat.com, kuba@kernel.org, raspl@linux.ibm.com,
 tonylu@linux.alibaba.com, hidayath@linux.ibm.com, ubraun@linux.ibm.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, horms@kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 guwen@linux.alibaba.com, wenjia@linux.ibm.com
Date: Fri, 09 Oct 2026 06:41:18 +0000
Message-ID: <179152807838.434549.2207466107170796457@kernel.org>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-2-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-2-fba616c0920c@proton.me>
X-sashiko-severity: Critical
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 1 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] The fix is incomplete: smc_rx_recvmsg() (net/smc/smc_rx.c)
  can still read past the RMB and copy that kernel memory to userspace.
- [High] smc_rx_recvmsg() (net/smc/smc_rx.c:444-456) can see a negative
  `readable` from a purely local race, with no forged peer.
- [Low] net/smc: invariant violation by subtracting from negative
  bytes_to_rcv

--

net/smc: bound the receive length to the RMB in smc_rx_recvmsg()

This patch limits the readable length in smc_rx_recvmsg() to
rmb_desc->len. It also maps negative values to rmb_desc->len. The goal is
to stop a forged peer producer cursor from pushing the wrap-around copy
past the end of the RMB.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..f781d7229185c 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -442,6 +442,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after waiting on data above */
>  		readable = smc_rx_data_available(conn, peeked_bytes);
> +		/* bytes_to_rcv is accumulated from the peer's wire-controlled
> +		 * producer cursor; a forged cursor can drive it past the RMB,
> +		 * or overflow the signed accumulator to a negative value across
> +		 * many CDC messages (which a plain "> len" check would miss
> +		 * before the size_t cast below turns it huge).  Bound it to the
> +		 * RMB in either case so the wrap-around copy cannot run past
> +		 * rmb_desc->len.  This enforces the documented
> +		 * 0 <= bytes_to_rcv <= rmb_desc->len invariant at the consumer,
> +		 * race-free against the producer update in the receive tasklet.
> +		 */
> +		if (readable < 0 || readable > conn->rmb_desc->len)
> +			readable = conn->rmb_desc->len;

[Severity: Low]
The new comment says this check "enforces the documented
0 <= bytes_to_rcv <= rmb_desc->len invariant at the consumer". Does it?

The clamp only changes the local readable copy. conn->bytes_to_rcv
itself is left as it was. Further down, the non-peek path still does:

	atomic_sub(copylen, &conn->bytes_to_rcv);
	/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */

Suppose a forged producer cursor has already pushed bytes_to_rcv
negative. readable is then mapped to rmb_desc->len, so copylen can be
up to a full ring. That copylen is then subtracted from a counter that
is already below zero. On every pass the counter moves further from
the invariant, not back toward it.

smc_rx_data_available() keeps returning a non-zero negative value.
So every later recvmsg() call goes straight to the copy label and is
clamped to a full ring again. It hands that ring to user space and
advances the consumer cursor through smc_rx_update_consumer().

The connection never recovers from the bad state. The patch just keeps
re-clamping it, and the comment next to the atomic_sub() becomes
false.

Either the commit message and the new comment should stop claiming the
invariant is enforced, or the bad state should be handled. Would it be
better to detect the out-of-range counter and abort the connection, or
mark it out_of_sync, rather than keep reading from it? The detection
could go in smc_cdc_msg_recv_action() when diff_prod is added, or
here.

[Severity: Critical]
The commit message says that with this check "the copy can never exceed
the ring". Is that the case?

The check limits the length copied in this pass. The copy start offset,
though, comes separately from the running peeked_bytes and
splice_pending values:

net/smc/smc_rx.c:smc_rx_recvmsg() {
    ...
	smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
	if ((flags & MSG_PEEK) && peeked_bytes)
		smc_curs_add(conn->rmb_desc->len, &cons, peeked_bytes);
	/* subsequent splice() calls pick up where previous left */
	if (splbytes)
		smc_curs_add(conn->rmb_desc->len, &cons, splbytes);
    ...
}

smc_curs_add() subtracts size only once:

net/smc/smc_cdc.h:smc_curs_add() {
	curs->count += value;
	if (curs->count >= size) {
		curs->wrap++;
		curs->count -= size;
	}
}

So once peeked_bytes reaches 2 * len - cons.count, cons.count stays at or
above rmb_desc->len.

The chunk calculation then subtracts a u32 from an int:

	chunk_len = min_t(size_t, copylen, conn->rmb_desc->len -
			  cons.count);
	chunk_len_sum = chunk_len;
	chunk_off = cons.count;

The result wraps as unsigned. That gives chunk_len = copylen (up to
rmb_desc->len) and chunk_off >= rmb_desc->len. The call
memcpy_to_msg(msg, rcvbuf_base + chunk_off, chunk_len) would then copy
memory beyond the RMB into the user buffer.

On the splice path, smc_rx_splice() would set partial[0].offset past the
buffer. For is_vm RMBs it would call vmalloc_to_page() on an address
outside the vmalloc area.

For example, take RMB length L, a starting consumer count c with
0 < c < L, bytes_to_rcv >= 3L, and recv(MSG_PEEK | MSG_WAITALL) with a
buffer larger than about 2L:

  pass 1: copies L bytes, peeked_bytes = L
  pass 2: cons = c + L wraps to c, peeked_bytes = 2L
  pass 3: cons = c + 2L, single subtraction leaves c + L >= L,
          chunk_len = min(L, (u32)(L - (c + L))) = L,
          chunk_off = c + L, so [c + L, c + 2L) is read, entirely
          past the RMB

Can a peer push bytes_to_rcv to 3L or more? smc_cdc_msg_recv_action()
still adds diff_prod with no limit:

	atomic_add(diff_prod, &conn->bytes_to_rcv);

The differing-wrap branch of smc_curs_diff() returns
(size - old->count) + new->count. That is close to 2 * len per CDC
message.

The earlier patch in this series, "net/smc: bound the wire-controlled
producer cursor to the RMB", limits count but not wrap. A peer that bumps
wrap on every message can keep growing the counter.

The bad offset also looks reachable without a malicious peer, through the
local MSG_PEEK race described in the next comment.

The later patch in the series, "net/smc: bound the send length to the
send buffer in smc_tx_sendmsg()", only touches net/smc/smc_tx.c, so this
does not seem to be handled anywhere else in the series.

Could bytes_to_rcv be limited at the producer in the tasklet instead?
Another option is to compute the available length as
min(bytes_to_rcv, len) minus peeked_bytes / splbytes, and treat a
negative result as 0.

[Severity: High]
Can readable go negative here from a purely local race, with no forged
peer? smc_rx_data_available() returns:

	return atomic_read(&conn->bytes_to_rcv) - peeked;

Consider two threads on the same AF_SMC socket:

Thread A
recv(MSG_PEEK | MSG_WAITALL, large buffer)
  peeks all N bytes, peeked_bytes = N, read_done < target
  smc_rx_wait()
    sk_wait_event()
      release_sock()

Thread B
recv()
  lock_sock()
  consumes the N bytes
    atomic_sub(copylen, &conn->bytes_to_rcv)  -> 0
    smc_rx_update_consumer()  -> local_tx_ctrl.cons advanced by N

Thread A then wakes on SO_RCVTIMEO, a signal, or new data M < N. The
fcrit() check sees bytes_to_rcv - N < 0, which is non-zero. So
smc_rx_wait() returns and thread A jumps to copy with
readable = M - N < 0.

With this patch, that negative value becomes rmb_desc->len (a full ring)
instead of "no data".

Thread A rebuilds cons from the shared local_tx_ctrl.cons, which thread B
has already advanced, plus the stale peeked_bytes. It then copies a full
ring of bytes that are not valid stream data: either data already
consumed, or space the peer has not written yet. RMB contents are not
cleared when buffers are reused, so these bytes can be left over from
earlier traffic.

Each later pass computes a more negative readable, which is again mapped
to rmb_desc->len, so peeked_bytes grows by a full ring per pass. Within
two or three passes, smc_curs_add() leaves cons.count >= len, and
memcpy_to_msg() reads past the RMB as described in the previous comment.

The new comment says the check is "race-free against the producer update
in the receive tasklet", but this race is between two consumers. TCP
handles the same situation by resetting peek_seq to copied_seq.

Should a negative readable be treated as 0 (no data), or should the peek
state be reset, rather than mapping it to rmb_desc->len?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c%40proton.me
