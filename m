Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636601;
	b=E1I1t7vlLAwyyFcRdTKG+NLlCZwfBShxilhPsYXgLAsa4fqcvh3/Sq8M0EOFWw3de+No
	 lL3i+IrSXf0ZKygKAS/Twii9PxmAZXRCxl/QW9INyLpIQxj4Zp3Ko44lSvKowjXo/hWxH
	 pTjavhv5YLhUA6sDqaOGWpbW/69tONknFMcxoSwcOV/gm1PpEG8MlQBDkH4fApP7RWC3Y
	 rHwIsl9TI3I/sg7RA9g40MQzbN5MxTUHfnUrw3rwVUFEJ+8dVzCrv26z08VK+ar79AoSo
	 3swrtL3uT9cgp5suXr3N6hlcvFhoI7b3vOW27Ucqj99Kcoy8Ai+VksUS5fTIO7z9HDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636601;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XOYGr6mGTO5dHIksaFqfCwRcnXV79g+A4iGwHsLu4gE=;
	b=GSL30cm9LX1p9tNipoHnz8f/fBFNvYJDMGg14JeHwTaJhKSmrTpp3YPKRGoflphEdVnT
	 cZaHvHTZ1I/BBwhDEwZSrhWVBqrPjcxZZrJxIzmfD8xZlK6Nx3luws/QxWc8emlEc6PUu
	 MJKF1WyML5l0Y5GFPdIISm25dkeJ9pi7sg9lNrOHlW81cJ9zjM+iXULaXPf/UkVjUrpRj
	 F7FAov5gFoDW8Pwfld/fgypDWZgUHuxC0ygkkP8bF4lV7+BjIFyx7gs04v5FZqe4ICaAb
	 YwU3HBK+wbf4pt+0nFTUocyt/ILK1QqBzKPo6gUfirWHB/8I1w15nE56SvXX7sYWlLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoDFsHJ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC76606A31E;
	Wed, 25 Nov 2026 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoDFsHJ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6141F000C4;
	Wed, 25 Nov 2026 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636601;
	bh=XOYGr6mGTO5dHIksaFqfCwRcnXV79g+A4iGwHsLu4gE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hoDFsHJ1wM9WuGVG69rLaZWdgmdUdh9OO3HkgamR+qjnJO+P6EtONzVmtAP3Kcz6T
	 +JIyxWRXz/9zEYhhcYxEs50RUuc+Pt2Ehrpve8PmNE639Kj0hnWuXowiecKZemI2ST
	 at+tOSK1+P5KIHO6AIgKZfbLzJwGOW0s39Y6b1rLJTUWRbshHRQEeHLSzKA0vQSSRT
	 XbmkW8yBYmL1nXV5gkf5TCVzM6sKBNobUhiZCkVC6silHV03B2eQvxXlzYxbvvo+W1
	 0Nwzu5rHFR4YecV+1z0RVL0czW6IW1V44V0cwuWj6Po54R7FBCQWDyN8f4MoTsodjA
	 qcJKIgTtPgZ2w==
Subject: Re: [PATCH net] net/smc: validate the peer's CDC cursors against our
 own buffers
From: netdev-bot+sashiko@kernel.org
To: piyus@iiitd.ac.in
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kapil@presceralabs.ai, kuba@kernel.org
Date: Wed, 25 Nov 2026 19:56:40 +0000
Message-ID: <179563660031.3135.15892342003977704361@kernel.org>
In-Reply-To: <20261121193345.2148966-2-piyus@iiitd.ac.in>
References: <20261121193345.2148966-2-piyus@iiitd.ac.in>
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

Critical: 0 · High: 2 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: it checks only the `count` half of each
  peer cursor and never looks at `wrap`.
- [High] The new validation runs only on the SMC-R receive path,
  `smc_cdc_rx_handler()`.
- [Medium] This finding is speculative.
- [Low] `smcr_cdc_cursors_invalid()` uses `>` and so accepts `prod.count
  == rmb_desc->len` and `cons.count == peer_rmbe_size`.
- [Low] The commit fixes a remotely triggerable out-of-bounds read that
  leaks kernel memory to userspace (KASAN-confirmed per the commit…
- [Low] The trailer chain is inconsistent with submitting-patches.rst.

--

net/smc: validate the peer's CDC cursors against our own buffers

This patch adds smcr_cdc_cursors_invalid(). It drops an SMC-R CDC message
in smc_cdc_rx_handler() when the peer's producer cursor count is larger
than rmb_desc->len, or when the consumer cursor count is larger than
peer_rmbe_size. The goal is to stop the out-of-bounds reads that a forged
cursor causes in the urgent-data and recvmsg() paths.

> Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
> Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>

[Severity: Low]
The From: line is Piyus Kedia, but the first Signed-off-by is Kapil
Vaswani, and there is no Co-developed-by tag.

Should a Co-developed-by: Kapil Vaswani tag go with that sign-off, as
submitting-patches.rst describes? Or should Kapil Vaswani be the author?

[Severity: Low]
This fixes an out-of-bounds read that a remote peer can trigger and that
reaches userspace. Would a Fixes: tag and Cc: stable be appropriate?

According to git blame, the diff_prod to bytes_to_rcv accounting in
smc_cdc_msg_recv_action() came from:

5f08318f617b ("smc: connection data control (CDC)")

It was later switched to rmb_desc->len by:

69cb7dc0218b ("net/smc: add common buffer size in send and receive buffer descriptors")

The urgent byte index in smc_cdc_handle_urg_data_arrival() came from:

de8474eb9d50 ("net/smc: urgent data support")

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..03ff10fef7da6 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -466,6 +466,26 @@ void smcd_cdc_rx_init(struct smc_connection *conn)

[ ... ]

> +static bool smcr_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smc_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;

[Severity: Medium]
This one may be speculative. Can conn->rmb_desc change between this check
and the places that use it?

The check runs in smc_cdc_rx_handler() after conns_lock has been dropped
and before smc_cdc_msg_recv() takes bh_lock_sock().
smc_cdc_msg_recv_action(), smc_cdc_handle_urg_data_arrival() and
smc_rx_recvmsg() each read conn->rmb_desc again, so the check and the use
do not work on the same snapshot:

	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);

The handshake can retry with another device or SMC version on the same
connection. smc_listen_find_device() falls through from ISM to
smc_find_rdma_v2_device_serv() and then to
smc_find_rdma_v1_device_serv(). Each one calls smc_conn_create() and
smc_buf_create(), and calls smc_conn_abort() on failure.

On that path, smc_conn_free() unregisters the connection but never clears
conn->rmb_desc:

	if (!list_empty(&lgr->list))
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
	smc_lgr_unregister_conn(conn);

smc_conn_create() then registers the connection again, and
__smc_buf_create() installs the new buffer with a plain store:

	conn->rmb_desc = buf_desc;

Suppose an RX handler on the old SMC-R link has already found the
connection. Could it pass this check against the old, larger
rmb_desc->len, and then run smc_cdc_msg_recv_action() against the new,
smaller buffer?

Between smc_conn_create() and smc_buf_create(), the connection can be
found while rmb_desc still holds the old pointer, which is not NULL. That
buffer may already have been freed by the is_reg_err branch of
smcr_buf_unuse(). The !conn->rmb_desc test would not catch this. Would the
check itself then read freed memory?

bh_lock_sock() does not exclude the process-context writer, which holds
lock_sock(). The stale rmb_desc lifetime predates this patch; only the
split between check and use is new.

Would it be safer to do the check inside smc_cdc_msg_recv_action(), using
the same READ_ONCE() snapshot of rmb_desc as the arithmetic?

> +	if (ntohl(cdc->prod.count) > (u32)conn->rmb_desc->len)
> +		return true;

[Severity: High]
This only checks the count field. Can a peer still push
conn->bytes_to_rcv past rmb_desc->len by using the wrap field?

smc_cdc_cursor_to_host() only rejects a cursor that moves backwards, so it
accepts any increase in wrap:

net/smc/smc_cdc.h:smc_cdc_cursor_to_host() {
    ...
	if ((old.wrap > temp.wrap) && temp.wrap)
		return;
	if ((old.wrap == temp.wrap) &&
	    (old.count > temp.count))
		return;
	smc_curs_copy(local, &temp, conn);
}

smc_curs_diff() does not clamp the result when the wraps differ:

net/smc/smc_cdc.h:smc_curs_diff() {
	if (old->wrap != new->wrap)
		return max_t(int, 0,
			     ((size - old->count) + new->count));
    ...
}

Its header comment says the "difference cannot exceed size". Nothing on
this path makes sure of that.

For example, start from prod {wrap=0, count=0}. Three CDC messages with
increasing seqno carry prod {1,0}, {2,0} and {3,0}. All three pass
smcr_cdc_cursors_invalid(), and each one adds rmb_desc->len in
smc_cdc_msg_recv_action():

	atomic_add(diff_prod, &conn->bytes_to_rcv);
	/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */

bytes_to_rcv then reaches 3 * len. A single message carrying
{old.wrap + 1, count = len} adds 2 * len - old.count.

In smc_rx_recvmsg(), only the first chunk is clamped, to
rmb_desc->len - cons.count. The second chunk is read from offset 0 with no
bound:

	chunk_len = copylen - chunk_len; /* remainder */
	chunk_len_sum += chunk_len;
	chunk_off = 0; /* modulo offset in recv ring buffer */

So memcpy_to_msg() can still copy bytes from past the end of the RMB to
userspace. If cons.count > 0, a bytes_to_rcv of 2 * len is already enough.

The same trick on the consumer cursor would push peer_rmbe_space above
peer_rmbe_size through the diff_cons addition.

Given this, is this part of the commit message accurate?

  "Validate both cursors where the message is accepted, next to the
  existing length and sequence-number checks, so that one test covers
  every consumer."

Would it work better to bound the computed difference instead of the raw
count? One option is to require the new prod cursor to be no more than
rmb_desc->len ahead of the local consumer cursor. Another is to limit the
resulting bytes_to_rcv and peer_rmbe_space. smc_curs_diff_large() already
clamps in a similar way.

> +	if (ntohl(cdc->cons.count) > conn->peer_rmbe_size)
> +		return true;

[Severity: Low]
The commit message says:

  "A cursor equal to the buffer length is legitimate (a full ring), so
  only a larger one is rejected."

Is that true for Linux peers? smc_curs_add() always normalises the
cursor:

net/smc/smc_cdc.h:smc_curs_add() {
	curs->count += value;
	if (curs->count >= size) {
		curs->wrap++;
		curs->count -= size;
	}
}

So a correct Linux peer never sends count == size. A full ring appears as
the same count with a wrap one higher. Should both comparisons here use >=
instead of >?

Accepting count == len does not cause a separate out-of-bounds access,
because {w, len} behaves like {w + 1, 0} in smc_curs_diff(). Combined with
a wrap increase, though, it lets one message add the maximum of
2 * len - old.count.

It isn't clear whether any non-Linux SMC implementation sends
count == size.

> +	return false;
> +}
> +
>  static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
>  {
>  	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
> @@ -499,6 +519,9 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
>  			   conn->local_rx_ctrl.seqno))
>  		/* received seqno is old */
>  		goto out;
> +	if (smcr_cdc_cursors_invalid(conn, cdc))
> +		/* peer cursor outside the buffer it describes */
> +		goto out;

[Severity: High]
This check is only added on the SMC-R receive path. Is the SMC-D path
still open to the same out-of-bounds reads?

smcd_cdc_rx_tsklet() takes a snapshot of the cursors the peer wrote into
the DMB and goes straight into the shared receive code:

net/smc/smc_cdc.c:smcd_cdc_rx_tsklet() {
    ...
	data_cdc = (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
	smcd_curs_copy(&cdc.prod, &data_cdc->prod, conn);
	smcd_curs_copy(&cdc.cons, &data_cdc->cons, conn);
	smc = container_of(conn, struct smc_sock, conn);
	smc_cdc_msg_recv(smc, (struct smc_cdc_msg *)&cdc);
}

The call chain is then
smc_cdc_msg_recv()->smc_cdc_msg_recv_action()->smc_cdc_msg_to_host(),
which ends up in smcd_cdc_msg_to_host(). That function copies the raw wrap
and count. It has no range check, and it lacks even the backwards check
that smc_cdc_cursor_to_host() does:

	temp.wrap = peer->prod.wrap;
	temp.count = peer->prod.count;
	smc_curs_copy(&local->prod, &temp, conn);

>From there, the consumers listed in the commit message are shared with
SMC-R:

- the urgent byte read in smc_cdc_handle_urg_data_arrival():

	conn->urg_rx_byte = *(base + conn->urg_curs.count - 1);

- the bytes_to_rcv accounting that feeds the second chunk in
  smc_rx_recvmsg();

- with dmb_nocopy, the diff_tx addition to sndbuf_space.

On s390, the ISM peer is another LPAR or guest. On loopback-ism it is the
local kernel.

Could the check move into smc_cdc_msg_recv_action(), after the host
conversion, so that both paths are covered? For SMC-D it would need to
work on the tasklet's local snapshot, since the peer can rewrite the DMB
at any time.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261121193345.2148966-2-piyus%40iiitd.ac.in
