Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048E39CD1E;
	Fri,  9 Oct 2026 06:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528079; cv=none; b=SdXuuxExJoQsehWlKN3eU6Woag2Hy7OYd32m/HMVePC7kpaN7jISClgQYZ8kg2n9X1+yrpbMnxETAGRBNtM3cm6HENnnPgIr+4PGKW8pgAIEHyz+RFr1Dy5ZiabE3Mtw0tPICuzxLP4qSTk2m5Rq88kqNb+STN+EpLu6MBQnxRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528079; c=relaxed/simple;
	bh=EQznHXum/40THCJSBoq2Roa09dPi+hzZDmZNYk5qnIg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YBIPRFQJ9/L20ToFaLFYkPih5gELpDuG+pSGySbavnxG6VLsUMMqQPG+0SuTglg6mggBF2X4FQr9T+dbZ/WKQTir1bzLiRZI7XyqGuK5N53rM4eqCQGqYh2A643TOhX4LE00nu7XR8mBSjv13Z2YBjaplN6h0ure3fTBLM2be9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVuL8Tr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVuL8Tr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D11F000FF;
	Fri,  9 Oct 2026 06:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791528078;
	bh=OS2N97m4R5sNO0poQujeFKcUjmnGOD96SZzAn70sFAU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dVuL8Tr78zHPcQipnlzAIm6x9ppcSuTSL3JBn0NoFWPZ1k4eoSxxSoqyUS4YmtK70
	 +nFRQHToq2tTndzTMIoZys9lW0KVdbXTY3ppLggHRpYy6EhSJHrRFcU4NRT3k7hmIi
	 N1ynf4eptJXzLSeINywzKQ9n/ji+qSkiCoY+zNk9HsdcfBul0nlSr/s7GwoEx+2ceo
	 PCtpDEglDB1IurrBYu1SJa/CCEAh8UREYBs9gH33I+nwti27UNGPrcUok/+IJ22zGT
	 ugS9Ua3xkNfczmIkSa67DB8Vc5Desw1TEnZjhJG0lhKU4jy7krKPC/4redSrlDE04h
	 YHdYiD0Sw6dtw==
Subject: Re: [PATCH net v6 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, alibuda@linux.alibaba.com, edumazet@kernel.org,
 mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, davem@davemloft.net,
 pabeni@redhat.com, kuba@kernel.org, raspl@linux.ibm.com,
 tonylu@linux.alibaba.com, hidayath@linux.ibm.com, ubraun@linux.ibm.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, horms@kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 guwen@linux.alibaba.com, wenjia@linux.ibm.com
Date: Fri, 09 Oct 2026 06:41:16 +0000
Message-ID: <179152807674.434549.14168488606722848951@kernel.org>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-1-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-1-fba616c0920c@proton.me>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete fix: the patch caps only the count of the wire-
  controlled producer cursor at rmb_desc->len.

--

net/smc: bound the wire-controlled producer cursor to the RMB

When CDC messages are converted to host order, this patch clamps the count
of the peer's producer cursor to rmb_desc->len. It does this for both SMC-R
and SMC-D. The consumer cursor is left unbounded because it indexes the
peer's RMB.

> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11f2303b..ca76ef6303566 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h

[ ... ]

> @@ -235,6 +236,15 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  	if ((old.wrap == temp.wrap) &&
>  	    (old.count > temp.count))
>  		return;
> +	/* The peer producer cursor is wire-controlled and is later used as a
> +	 * raw index into our RMB by the urgent path; bound its count to the
> +	 * RMB.  max_count == 0 leaves the consumer cursor unbounded here: it
> +	 * indexes the peer's RMB (bounded by peer_rmbe_size, not our
> +	 * rmb_desc->len), so clamping it to rmb_desc->len would under-credit
> +	 * peer_rmbe_space and stall transmit to peers with a larger RMB.
> +	 */
> +	if (max_count && temp.count > max_count)
> +		temp.count = max_count;
>  	smc_curs_copy(local, &temp, conn);
>  }

[Severity: High]

Does clamping only the count keep the producer cursor inside the RMB? The
checks above only reject a cursor that moves backwards. A peer can still
move prod.wrap forward by any amount in one message. The only gate before
this is the seqno check in smc_cdc_rx_handler(), and the peer sets seqno.

smcd_cdc_msg_to_host() has the same count-only clamp. It also takes
peer->prod.wrap with no check at all.

The new cursor goes straight into bytes_to_rcv:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);
	if (diff_prod) {
		...
		atomic_add(diff_prod, &conn->bytes_to_rcv);
		/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */
    ...
}

When the wraps differ, smc_curs_diff() returns
(size - old->count) + new->count. Even with new->count clamped to len, one
message can still add up to 2 * len. For example:

    prod (0, 0) -> (1, len)   adds 2 * len
    then (2, len), (3, len)   each adds another len

Nothing enforces the "guarantee" in that comment.

With only this patch applied, smc_rx_recvmsg() computes copylen as
min(read_remaining, readable), where readable comes from bytes_to_rcv. The
second chunk is then read from offset 0:

	chunk_len = copylen - chunk_len; /* remainder */
	...
	chunk_off = 0; /* modulo offset in recv ring buffer */

Can that remainder be larger than rmb_desc->len? If so, memcpy_to_msg() or
smc_rx_splice() would read past rcvbuf_base + len and copy kernel memory to
userspace.

A later patch in this series, "net/smc: bound the receive length to the
RMB in smc_rx_recvmsg()", caps readable at rmb_desc->len on each pass. That
closes the direct overrun in the second chunk. However, bytes_to_rcv can
still be inflated, and smc_rx_recvmsg() builds its local cursor like this:

	smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
	if ((flags & MSG_PEEK) && peeked_bytes)
		smc_curs_add(conn->rmb_desc->len, &cons, peeked_bytes);
	/* subsequent splice() calls pick up where previous left */
	if (splbytes)
		smc_curs_add(conn->rmb_desc->len, &cons, splbytes);

smc_curs_add() subtracts size only once. With MSG_PEEK | MSG_WAITALL and a
large read length, peeked_bytes can reach 2 * len after two passes. That
leaves cons.count >= len, and then:

	chunk_len = min_t(size_t, copylen, conn->rmb_desc->len -
			  cons.count);
	chunk_off = cons.count;

The subtraction is done in u32 and wraps, so chunk_len becomes copylen.
memcpy_to_msg() then reads from rcvbuf_base + cons.count, which is
completely past the end of the RMB. Repeated splice() calls that let
splice_pending grow without draining the pipe seem to hit the same path.

Would it work better to reject any producer advance larger than the free
RMB space (for example, bytes_to_rcv + diff_prod > rmb_desc->len) and abort
the connection, instead of clamping the count here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c%40proton.me
