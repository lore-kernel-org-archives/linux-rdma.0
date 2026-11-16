Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834037;
	b=cI0ZJcHYfxt2d9sOkU34Gs5e+z8gyzgEPCuEf0R3D5hubBbnnJLQT0+Wd8j0PLUMG2IQ
	 0gLRB2U8/MeQBSUNi/TD9cJcuuuLXoQs1JjUrCkhci3PJt74HlnJSQjdTbrYprtj0qhid
	 vsWqyuGmJnZhIX9uzY+dVg0m1MGjWz3xfpb6helymVpgOTvv8ACkazuwLRJCfa09KMx6z
	 a9g11fhygmRJbzefsLXngCZjS3iCfr62QiO8YS3Hj6N1ugEeAKg35huIHzN1rP+EPPDyQ
	 jRoWraqjoeF2BUuS23gZwRkyloCvY735GMWVxpXe/59KBHk654jHSJ3EjTgElLtkGKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834037;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=pj2mr3tObuF7fHr7V/ABzBeBxD+jnnNn+z7xWtgN8+Q=;
	b=Arcyhd+6DH8vi51I/WSJZz06uZRPKOHHTeBhwB9ThZh+ivgg987A1LgP/vSSBDd/VQg3
	 p1mKvTzOI+a/+u72VardzxmiUJ6+woqUKGxKs3ewyEt8qycx9ROAC692xlciIEAtER1yt
	 Tlb4WmRSiS5VxTofbaICIqQ8X1+Sd2INboCmwoHYUtNAaKXrDob/SLttnjdbJdPcGyuZj
	 cepQNb6MlmsOB3v2ByD3yAFFSRjxBPcr4NnquxJivcgiJpsUGT3Ae68EBbyTG9uJ4aXDR
	 b+xzeofW1CjABqR2DA1Z1qldSO4s3Qwq8voN42s8eH2CPTeTiFIfnvqePMMnj7p9RfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCc4M58t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727DC606A31C;
	Mon, 16 Nov 2026 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCc4M58t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCA61F000C4;
	Mon, 16 Nov 2026 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834037;
	bh=pj2mr3tObuF7fHr7V/ABzBeBxD+jnnNn+z7xWtgN8+Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fCc4M58tHcD4Oe8zgYl8DTAW5sHRLlHGKiyx4iVbzYdISWqBTo50MkggBry0nvLOn
	 IK12XTEjJcpIur1ggcvmwm9xJBHHVtqgCI6g+YIpx7Nyx5HSkAqesC8zi88Apio3uK
	 BFXOJNwmrH3mTlS6LsHQKTVtaR/FS9Q8+JJasgvxuGjY6Bs7gU38ycEoqiOkkPmQlP
	 LNH0rt7cbTMJCtTs9+/tOfFAH7x5mJpMVUiDjiOk1UQhLWniQKRDW/leaByM1eNWA2
	 0yF4ppyJ0GM0fjs5rb4j11YhNcK4vsPDv8fOiHwUDGhL6tpomd3CxlAKZniERdlyld
	 ZiIIme8z1lWsw==
Subject: Re: [PATCH net v9 2/6] net/smc: bound the receive length to the RMB
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, edumazet@kernel.org,
 pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
 alibuda@linux.alibaba.com, sidraya@linux.ibm.com, ubraun@linux.ibm.com,
 wenjia@linux.ibm.com, raspl@linux.ibm.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, guwen@linux.alibaba.com,
 tonylu@linux.alibaba.com, horms@kernel.org, guangguan.wang@linux.alibaba.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, hidayath@linux.ibm.com
Date: Mon, 16 Nov 2026 13:00:35 +0000
Message-ID: <179483403531.3136.8089060655556532664@kernel.org>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-2-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-2-e5e8fa688177@proton.me>
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

- [High] The patch relies on spliced bytes being counted exactly once: in
  bytes_to_rcv until they are handed to the pipe, then in splice_pending…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but spliced pipe
  buffers keep pointing into an RMB that has already been handed back…

--

net/smc: bound the receive length to the RMB

This patch makes smc_rx_data_available() cap the receive count at what
fits in the RMB behind the peeked and spliced bytes, and never return a
negative count. poll(), SIOCINQ and the deferred accept now use it too.
It caches the RMB length in conn->rmb_len for the unlocked wait, and
moves the splice_pending decrement in smc_rx_pipe_buf_release() under
the socket lock, next to the consumer cursor update.

Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me?part=2
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=2
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=1

[ ... ]

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 63c178c10bf1a..78ab3df1689c5 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -118,15 +118,20 @@ static void smc_rx_pipe_buf_release(struct pipe_inode_info *pipe,
>  	struct smc_connection *conn = &priv->smc->conn;
>  	struct smc_sock *smc = priv->smc;
>  	struct sock *sk = &smc->sk;
> +	bool drained;
>  
>  	lock_sock(sk);
>  	if (conn->freed) {
>  		release_sock(sk);
>  		goto out;
>  	}

[Severity: High]

This isn't a bug introduced by this patch, but the conn->freed check
here means pipe buffers are expected to outlive the connection. Can
they still point into an RMB that has already been handed back for
reuse?

smc_rx_splice() puts the RMB's own pages into the pipe, not a copy:

		pages[0] = smc->conn.rmb_desc->pages;
	...
	for (i = 0; i < nr_pages; i++) {
		get_page(pages[i]);
		sock_hold(&smc->sk);
	}

That pins the pages and the smc_sock, but not the RMB slot.

On close, smc_conn_free() calls smc_buf_unuse() without waiting for
splice_pending to drain. For SMC-R, smcr_buf_unuse() then does:

		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
		WRITE_ONCE(buf_desc->used, 0);

A new connection in the same link group, with the same RMB size class,
can then claim the slot in smc_buf_get_slot():

	if (cmpxchg(&buf_slot->used, 0, 1) == 0) {

For example:

process A: splice() from an SMC socket into a pipe -> smc_rx_splice()
process A: close() the socket, keep the pipe
  smc_release()->__smc_release()->smc_conn_free()->smc_buf_unuse()
process B: new SMC connection to the same peer
  __smc_buf_create()->smc_buf_get_slot() reuses the RMB
peer writes B's data into the RMB
process A: reads the pipe

Reading the pipe copies from the pages at read time. Would process A
then get the data process B received?

smc_rx_pipe_buf_release() only uses conn->freed to skip the cursor
update. Nothing here stops the read. This goes back to the splice()
support listed in the Fixes: tags.

[ ... ]

> @@ -543,7 +548,7 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  			/* increased in recv tasklet smc_cdc_msg_rcv() */
>  			smp_mb__before_atomic();
>  			atomic_sub(copylen, &conn->bytes_to_rcv);
> -			/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */
> +			/* can be out of range, see smc_rx_data_available() */
>  			smp_mb__after_atomic();
>  			if (msg && smc_rx_update_consumer(smc, cons, copylen))
>  				goto out;

[Severity: High]

The commit message says a reader can no longer count released bytes
twice. The new rmb_len - splice_pending bound in
smc_rx_data_available() also assumes each spliced byte is counted in
bytes_to_rcv or in splice_pending, never both.

Can smc_rx_recvmsg() still break that when smc_rx_splice() delivers
less than it was asked to?

Case 1: a splice() whose copy wraps the RMB end, into a pipe with
exactly one free slot. do_splice_read() limits len by free pages, not
by slots:

fs/splice.c:do_splice_read() {
    ...
	p_space = pipe->max_usage - pipe_buf_usage(pipe);
	len = min_t(size_t, len, p_space << PAGE_SHIFT);
    ...
}

On a physically contiguous RMB (SMC-D, or non-vm SMC-R), chunk 0 takes
the last slot and smc_rx_splice() adds it to splice_pending:

	bytes = splice_to_pipe(pipe, &spd);
	if (bytes > 0)
		atomic_add(bytes, &smc->conn.splice_pending);

The second smc_rx_splice() call finds the pipe full, and
splice_to_pipe() returns -EAGAIN. read_done is already non-zero, so
smc_rx_recvmsg() takes this path:

				if (rc < 0) {
					if (!read_done)
						read_done = -EFAULT;
					goto out;
				}

This skips the atomic_sub(copylen, &conn->bytes_to_rcv) above. Isn't
chunk 0 then counted in both bytes_to_rcv and splice_pending?

The next splice() starts at cons + splbytes, and
smc_rx_data_available() still reports chunk 0 as available. The same
happens for a recv() after the pipe release has advanced cons. The
reader would then get stale or zeroed RMB bytes from beyond the
producer cursor, which is the symptom the patch notes describe.

When those bytes are released, local_tx_ctrl.cons moves past the
peer's producer cursor. Could the over-credited peer_rmbe_space on the
peer then let its later writes overwrite unread data?

Case 2: a vm RMB (rmb_desc->is_vm) with an offset that is not
page-aligned:

	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;

nr_pages can come out at p_space + 1. splice_to_pipe() then inserts
p_space pages and returns a short positive count.

smc_rx_recvmsg() ignores that count. It adds the full chunk_len to
read_done and subtracts the full copylen from bytes_to_rcv.
splice_pending, and later the consumer cursor, only advance by the
short count.

Doesn't that make splice() report bytes the pipe never received? It
would also take the difference out of the receive window the peer sees
for good, each time it happens. After enough of these, the connection
could stall with the end of the stream unreadable.

The clamp still keeps reads inside the RMB, so this doesn't look like
an out-of-bounds read. But the double count the commit message says is
gone still seems reachable through these paths. No later patch in the
series touches smc_rx.c or smc_rx.h.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177%40proton.me
