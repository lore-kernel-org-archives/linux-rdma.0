Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407770;
	b=mdGRVrfeLjJI2LcJ39wVgL1nJVW8JTwkkumFBzn6FuTnMqGULY06eOWFzS/oXOVwnwWP
	 0Z1ufc3KDzSjiGvuwJHUhEb0n72/UkD8RiBQDqb0STly5vyTAFD2aXc1surE5q0Ml1vpP
	 M1TfoEJJeBriobkDs8t5IGsx4Bonqui3D1a39f8kYcvJzM8ui4Oe9DrdQOe8luNZWCmlO
	 OSaqtQ4GemTmLSy1aUzjeV7vS3B5kA+2sCwTkXHNFbg20VMs1rs1lC71vMhA2FyxVCiTe
	 cec6MGSjBuPe+KVcV19AYvcK+KwMQQzFfOfu5lRoQOgg6kh7lMkcRMEmOKhewji7U0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407770;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=iUaYkVElwHXmOSgYzkznsrZDmTk+0hZ8WoKAJqfKpZw=;
	b=s6cv0IevklkhKL2dEC7RZgRyUB7xjxz2npVh/mzK6gfk08HVepsl11C1kQ085wluI+/g
	 Drrqn4HwJlxfiLIgUq8AQtQePkXwIt8cTBYHfnirOdYozCq7gHKaLHma4JCi/4pxxBmTj
	 ekoH+VZnXpZHF2pq2cSwg46du78JBcHR+nl8PpQtMoKH2p6RlbWfObtOJzsL20stWLpZS
	 NS4Z0o2X4pU03q6/SDPHN9+5Jr091k1U2LKSQqawqakne/rY+7snu1O8zKTXR7TY9BRKI
	 ZwKMClJmNp0doAKM/DZM+aYswGLsJDyVOShZLNQ3SdAkAYuojaiowYoTvXotU3EzlCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oY7e1YEi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271B1606A31A;
	Mon, 23 Nov 2026 04:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oY7e1YEi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD371F000C6;
	Mon, 23 Nov 2026 04:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795407769;
	bh=iUaYkVElwHXmOSgYzkznsrZDmTk+0hZ8WoKAJqfKpZw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oY7e1YEihc8egQNKXPT3/Igp5Siys9HKKhLv2PGAi5SdqdkkhJ/XM59sfO5ETNoBB
	 UjrntvtSorg+k6TzuKWkuk3a9IPfdR88EcJ8tVWsyK6O86xaKmbtmxeZry/u8tD39R
	 mrR+OsKgdrNG2aBiCP0ABZhlV17pX2JPMZfp8LEyDBj8QshaFv0JilCAlMxppj6RAl
	 10rYQLKKbzDYxr4Gyn0bzTf2f2G/HTcdXMx/5fYHeuTlPfnLstyLPLw/EeCSRAQNgb
	 RG6IMoky67K/qWCX/v9CQMlDQA2/OgVedooifPRTNa5OSwEbeCneriSRE2XIOnnCqw
	 412xiWrB/cmmw==
Subject: Re: [PATCH net v2] net/smc: validate the peer's CDC cursors against
 our own buffers
From: netdev-bot+sashiko@kernel.org
To: piyus@iiitd.ac.in
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kapil@presceralabs.ai, kuba@kernel.org
Date: Mon, 23 Nov 2026 04:22:48 +0000
Message-ID: <179540776852.3135.18298742575411764997@kernel.org>
In-Reply-To: <20261122042120.2430434-1-piyus@iiitd.ac.in>
References: <20261122042120.2430434-1-piyus@iiitd.ac.in>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 5

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] The new validators use `>` and accept count == buffer length.
- [Low] The commit fixes remotely triggerable KASAN-confirmed faults: an
  out-of-bounds RMB read whose bytes reach userspace via recvmsg(), plus…
- [Low] The From: author is Piyus Kedia, but the first Signed-off-by is
  Kapil Vaswani, with no matching Co-developed-by: tag.
- [Low] smcd_cdc_cursors_invalid() starts with `if (!conn->rmb_desc)
  return true;`.
- [Low] The new comment in smcd_cdc_rx_tsklet() says the check guards the
  consumer-cursor credit to sndbuf_space under DMB-nocopy.

--

net/smc: validate the peer's CDC cursors against our own buffers

This commit checks the producer and consumer cursors in incoming CDC
messages, in smc_cdc_rx_handler() for SMC-R and smcd_cdc_rx_tsklet() for
SMC-D. A message is dropped if a cursor count is larger than
rmb_desc->len (producer) or peer_rmbe_size (consumer). The goal is to
stop out-of-bounds reads in the urgent data, recvmsg() and splice()
paths.

> Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
> Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>

[Severity: Low]
This patch fixes out-of-bounds reads that a remote peer can trigger on
both SMC-R and SMC-D. There is no Fixes: tag and no Cc: stable.

Could Fixes: tags be added? The SMC-R path probably goes back to the
original CDC receive code. The SMC-D path probably goes back to the
commit that added SMC-D CDC receive. So two tags may be needed.

[Severity: Low]
The author is Piyus Kedia, but the first Signed-off-by is Kapil Vaswani,
and there is no Co-developed-by: tag.

Documentation/process/submitting-patches.rst lists a co-author with
Co-developed-by: immediately followed by their Signed-off-by. Otherwise
the Signed-off-by order should follow how the patch was handled.

Should this be Co-developed-by: plus Signed-off-by? If Kapil reported or
analysed the issue, Reported-by: or Suggested-by: may fit better.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..8d24e0c839260 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -433,6 +433,18 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
>  	sock_put(&smc->sk); /* no free sk in softirq-context */
>  }
>  
> +static bool smcd_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smcd_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;
> +	if (cdc->prod.count > (u32)conn->rmb_desc->len)
> +		return true;

[Severity: High]
Is checking only the count field enough to keep bytes_to_rcv within
rmb_desc->len? Neither this check nor the one in
smcr_cdc_cursors_invalid() looks at wrap. Neither looks at how far the
cursor moved since the previous message.

When the wraps differ, smc_curs_diff() can return up to twice the
buffer size:

net/smc/smc_cdc.h:smc_curs_diff() {
	if (old->wrap != new->wrap)
		return max_t(int, 0,
			     ((size - old->count) + new->count));
	...
}

On SMC-R, smc_cdc_cursor_to_host() rejects only backward wrap moves, and
the peer controls seqno. On SMC-D, smcd_cdc_msg_to_host() has no
ordering check at all.

Take an RMB of length L, with prod starting at {wrap 0, count 0}. A peer
could send:

  prod {wrap 1, count L}  -> passes, diff_prod = 2L
  prod {wrap 2, count L}  -> passes, diff_prod = L

smc_cdc_msg_recv_action() then adds both with no cap:

	atomic_add(diff_prod, &conn->bytes_to_rcv);
	/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */

That leaves bytes_to_rcv at 3L. In smc_rx_recvmsg(), only the first
chunk is clamped to rmb_desc->len - cons.count. The remainder is used
as-is:

	chunk_len = copylen - chunk_len; /* remainder */
	chunk_len_sum += chunk_len;
	chunk_off = 0; /* modulo offset in recv ring buffer */

The second chunk would then be 2L bytes from offset 0. memcpy_to_msg()
would copy L bytes past the RMB to userspace.

splice() gets the same oversized chunk in smc_rx_splice(). Past the end
of the RMB, vmalloc_to_page() can return NULL, and get_page()
dereferences it.

Using >= instead of > does not change this. {1, L-1} followed by
{2, L-1} still gives 3L-1.

The consumer side looks similar. diff_cons is added to peer_rmbe_space
with no cap. Under DMB-nocopy, diff_tx is added to sndbuf_space with no
cap either.

smc_tx_sendmsg() uses the same unclamped second-chunk pattern. An
inflated sndbuf_space could therefore become a write past
sndbuf_desc->len. smc_tx_rdma_writes() can also size dst_len from an
inflated peer_rmbe_space. DMB-nocopy is only used by loopback-ism today,
which narrows this part.

Given this, does this statement in the commit message hold?

  "Validate both cursors where each transport accepts the message, so
  that one test per transport covers every consumer."

Would a relational bound work better? For example, reject a prod that is
more than rmb_desc->len ahead of local_tx_ctrl.cons (via
smc_curs_comp()). Or reject when bytes_to_rcv + diff_prod would exceed
rmb_desc->len.

For cons, the new value could be required to lie between the previous
cons and our sent producer cursor. Wrap jumps greater than 1 could also
be rejected. Together these would bound the credit side.

> +	if (cdc->cons.count > (u32)conn->peer_rmbe_size)
> +		return true;
> +	return false;
> +}
> +

[ ... ]

> @@ -452,6 +464,15 @@ static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
>  	data_cdc = (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
>  	smcd_curs_copy(&cdc.prod, &data_cdc->prod, conn);
>  	smcd_curs_copy(&cdc.cons, &data_cdc->cons, conn);
> +	/* This CDC was written by the peer into the DMB we published to it, so
> +	 * both cursors are peer-supplied and index buffers described on this
> +	 * side.  Nothing else checks them, and smc_cdc_msg_recv_action() uses
> +	 * the producer cursor as a receive length and the consumer cursor to
> +	 * credit sndbuf_space - which under DMB-nocopy is the memory the peer
> +	 * itself owns.  Unlike the SMC-R path these values are host order.
> +	 */

[Severity: Low]
This comment says the check protects the consumer cursor's credit to
sndbuf_space under DMB-nocopy. smc_cdc_msg_recv_action() computes that
credit against sndbuf_desc->len:

	diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
				&conn->tx_curs_fin,
				&conn->local_rx_ctrl.cons);

smcd_cdc_cursors_invalid() bounds cons.count by peer_rmbe_size instead.

The two lengths come from different places. peer_rmbe_size comes from
the DMBE size advertised in CLC. sndbuf_desc->len is set in
smcd_buf_attach() from the dmb_len that attach_dmb returns.

If those two ever differ, could a cons.count that passes this check
exceed sndbuf_desc->len and reach tx_curs_fin and the sndbuf_space
arithmetic?

Conforming in-kernel peers produce equal values, so this is mostly about
the comment. Even when the lengths match, the check does not bound the
accumulated sndbuf_space credit. The comment seems to promise more than
the check does.

> +	if (smcd_cdc_cursors_invalid(conn, &cdc))
> +		return;

[Severity: Low]
This isn't a functional problem, but the NULL test at the start of
smcd_cdc_cursors_invalid() can never fire on this path:

	if (!conn->rmb_desc)
		return true;

smcd_cdc_rx_tsklet() has already dereferenced conn->rmb_desc->cpu_addr
and read both cursors from it before it calls the helper.

Should the test be dropped? If rmb_desc really can be NULL here, should
the test move ahead of the dereference?

>  	smc = container_of(conn, struct smc_sock, conn);
>  	smc_cdc_msg_recv(smc, (struct smc_cdc_msg *)&cdc);
>  }

[ ... ]

> +static bool smcr_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smc_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;
> +	if (ntohl(cdc->prod.count) > (u32)conn->rmb_desc->len)
> +		return true;

[Severity: Low]
The commit message says:

  "A cursor equal to the buffer length is legitimate (a full ring), so
  only a larger one is rejected."

Is that how cursors are actually encoded? smc_curs_add() normalises
every cursor so that count stays below size:

net/smc/smc_cdc.h:smc_curs_add() {
	curs->count += value;
	if (curs->count >= size) {
		curs->wrap++;
		curs->count -= size;
	}
}

The senders put that host cursor on the wire unchanged. A conforming
peer therefore always sends a count in [0, size). A full ring shows up
as a wrap difference, not as count == size.

Should this check, the cons check below it, and the two checks in
smcd_cdc_cursors_invalid() use >= instead?

Accepting count == len lets in a value that only a non-conforming peer
can send. It then lands in local_rx_ctrl.prod/cons, urg_curs and, under
DMB-nocopy, tx_curs_fin. It also allows the single-message credit of
2 * size from smc_curs_diff() described above. Changing this alone would
not fix the accumulation problem, though.

> +	if (ntohl(cdc->cons.count) > conn->peer_rmbe_size)
> +		return true;
> +	return false;
> +}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122042120.2430434-1-piyus%40iiitd.ac.in
