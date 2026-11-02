Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643871;
	b=X7yHRkdaXtHDUUXaORA9NKTqD/I4MJk5Vfh7loWohdspKXIZIQTrPQiTkU6ADnstV2/S
	 IegezQhU6mYq4Zvd1stYBWiwSJx/TVSeAgVjO6WilKCSEJuwifNH/Ivvg7F3a/B7BP3Et
	 M0sCDPN475qZ3v2g4CMq8lrByxn1cdDKDr6uyEr/fBb8xwH+l4x9HxlFogm0gC9brI8O7
	 4AQR8YsGmjz91TReaxXXjWteyg9NOkQJzu4c78N2T0fUjhvqXip7tho3DuRuMoXqq2y+D
	 bN2XjZpZHt5HBQDi5v6qtOCTsS8gHbv5irVYTEdU1HFyeDCWOt1hU9iv7ssltiSLVTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643871;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zaXW5UkSeQoT+3Pn6tJ3rqXdfFrAF5yRKPAiSoRGz3E=;
	b=Pt/Hpv0CRCRkbIS4BzIKJw1mLhdG72fjmoql1q2YfEjw5Muln+Ah6TwI7IBP5jJUGLF2
	 rJHXfQqhw9FqavBLLops+tEqTMabAztPaHDoig2pC5UO2roDpmCjOYSm/Plj08up6SoVi
	 AA3uENXc/E0txcIyaVoyVpfVIIMZMhf8lmsbTxUb4IKvrKjgHUpjSOtmljh5fqafmllIm
	 5g1a8F340tscqwMq0CksjQIBbjQpXsnkjMV+yyix6w8j5sAsG3nS5uHMYoR5LKe4dNdoh
	 7NjpN89IV/MXNJPC7ipV1qeeqSiVoH+kl/5r5FBkvuPgRAmNlsqlLu+T/NXAKd4MQkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EDxxetwm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638A606A326;
	Mon,  2 Nov 2026 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EDxxetwm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A1C1F00A16;
	Mon,  2 Nov 2026 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793643870;
	bh=zaXW5UkSeQoT+3Pn6tJ3rqXdfFrAF5yRKPAiSoRGz3E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EDxxetwmR0ouEvk8NkvWCfRWXXpz5vDK2MmTrF0+n73GHLy8WdYG/V/xmnsUsWxkL
	 7AazR1RQuQKI3Em3eJC2wnjMQGTA0Fl8WK2QSukGfSt40l/6379uQkSxf6iNxQh6UP
	 fNeGcECfU931gGYzeL+EYLYo61Xom95YUjo4j1dvdNod+8OtSn5ObTwCdmNB90aRLZ
	 4NGZlqL1319IfgJoF8T1gG4GvXPjC91Pzs2AUK275N00virrVv4NkJ1PpIrwg8bEWI
	 Glmca0mpTIjwv0XVOsI/Jjba4T3lYQS6vPf8VV3Lui8x4Iog8HNKx1CfTw7H4cw6iW
	 iSEju5L0xvvmA==
Subject: Re: [PATCH net v8 1/4] net/smc: bound the wire-controlled producer
 cursor to the RMB
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
Date: Mon, 02 Nov 2026 18:24:28 +0000
Message-ID: <179364386889.3131.15357583565149479702@kernel.org>
In-Reply-To: <20261029-b4-disp-33001ace-v8-1-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-1-f9bb96e17827@proton.me>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] This patch (commit "net/smc: bound the wire-controlled producer
  cursor to the RMB") only clamps the count field of the peer's producer…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but: on SMC-R, the
  CDC receive path can read a freed RMB descriptor.

--

net/smc: bound the wire-controlled producer cursor to the RMB

This patch clamps the count of the producer cursor the peer sends to
rmb_desc->len. It does this in smcr_cdc_msg_to_host() and
smcd_cdc_msg_to_host(), which stops smc_cdc_handle_urg_data_arrival()
from indexing past the RMB. The consumer cursor is not clamped, because
it indexes the peer's RMB.

> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11f2303b..4d630a3051184 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h

[ ... ]

> @@ -235,6 +236,12 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  	if ((old.wrap == temp.wrap) &&
>  	    (old.count > temp.count))
>  		return;
> +	/* The urgent path uses the producer count as a raw index into our
> +	 * RMB, so bound it. max_count == 0 leaves the consumer cursor alone:
> +	 * it indexes the peer's RMB, which can be larger than ours.
> +	 */
> +	if (max_count && temp.count > max_count)
> +		temp.count = max_count;

[Severity: High]
Only temp.count is bounded here. The code still accepts a forward jump
in temp.wrap from the wire. Can a peer use that to push
conn->bytes_to_rcv past rmb_desc->len?

When the wraps differ, smc_curs_diff() returns:

	if (old->wrap != new->wrap)
		return max_t(int, 0, ((size - old->count) + new->count));

That can approach 2 * rmb_desc->len for a single CDC message.
smc_cdc_msg_recv_action() then adds it with no check against free RMB
space:

	atomic_add(diff_prod, &conn->bytes_to_rcv);

The SMC-D path in smcd_cdc_msg_to_host() also clamps only the count. It
has no ordering or wrap check on prod.

With only this patch applied, smc_rx_recvmsg() takes readable straight
from bytes_to_rcv. The second chunk of the copy starts at offset 0:

	chunk_len = copylen - chunk_len; /* remainder */
	chunk_len_sum += chunk_len;
	chunk_off = 0;

Wouldn't memcpy_to_msg() or smc_rx_splice() then copy memory past the
end of the RMB to user space?

The later commit in this series, "net/smc: bound the receive length to
the RMB", seems to close this path. It bounds smc_rx_data_available():

	avail = min(avail, conn->rmb_len - atomic_read(&conn->splice_pending));
	return avail > (int)peeked ? avail - (int)peeked : 0;

It also uses that value for readable in smc_rx_recvmsg().

This patch is marked Cc: stable. Should both patches be backported
together, or should this function also reject a wrap that advances by
more than one?

>  	smc_curs_copy(local, &temp, conn);
>  }
>  
> @@ -246,8 +253,9 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	local->len = peer->len;
>  	local->seqno = ntohs(peer->seqno);
>  	local->token = ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. Still,
this adds another read of conn->rmb_desc->len, and on SMC-R this path
looks like it can run after the descriptor has been freed.

If adding a link fails to register an in-use RMB, smcr_link_reg_buf()
marks the buffer:

	if (smc_wr_reg_send(link, buf_desc->mr[link->link_idx])) {
		buf_desc->is_reg_err = true;
		return -EFAULT;
	}

At teardown, smc_conn_free() releases the buffers before it unregisters
the connection:

	smc_buf_unuse(conn, lgr); /* allow buffer reuse */
	smc_lgr_unregister_conn(conn);

Because is_reg_err is set, the call chain
smc_buf_unuse()->smcr_buf_unuse()->smc_buf_free()->smcr_buf_free()
calls kfree() on the descriptor. conn->rmb_desc is left pointing at the
freed memory. For SMC-R, smc_conn_free() only waits for pending TX WRs.
Nothing quiesces the RX side.

On the receive side, smc_cdc_rx_handler() takes only a socket reference
before it drops conns_lock, and it never checks conn->freed:

	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
	if (!conn || conn->out_of_sync) {...}
	smc = container_of(conn, struct smc_sock, conn);
	sock_hold(&smc->sk);
	read_unlock_bh(&lgr->conns_lock);

The bh_lock_sock() in smc_cdc_msg_recv() does not serialize against a
lock_sock() owner in process context either.

Could a CDC message that arrives during teardown reach
smcr_cdc_msg_to_host() and read the freed conn->rmb_desc->len here? It
might be a close or abort from a conforming peer, or a message from a
hostile peer at any time.

smc_cdc_msg_recv_action() reads the same descriptor again:

	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);

If urg_data_present is set, smc_cdc_handle_urg_data_arrival() also reads
a byte from the freed cpu_addr.

The later smc_rx_data_available() change in this series uses
conn->rmb_len because rmb_desc may already be freed at that point. Would
conn->rmb_len also be the safer value to pass here?

> +	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
>  	local->prod_flags = peer->prod_flags;
>  	local->conn_state_flags = peer->conn_state_flags;
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me
