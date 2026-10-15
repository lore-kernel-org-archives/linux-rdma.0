Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44294A387A;
	Thu, 15 Oct 2026 20:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095325; cv=none; b=MKMX5FrnEKdYFA+1z8eohlB+9gETPcrr4NLhA8udVSxVaHpFn3a2yac73fKGXFkPtJOoL2M420EPlA0ah1oEoJJ4NzTwIyDt7+fJjgcYaqt3EJW8P8cBdBjxkDBCzK2OgWUed2A0BEP+5DY3Ida9WpWs3XNehDMR3Ehs4CkE0z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095325; c=relaxed/simple;
	bh=rHjPkIPAtY3XaeCnRek/B7MwcjGB+MeXXaoKR7W0b5I=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dZtlkacn5iBwFhVwCJH3x0pEgq80JnJxfb5LBZLnzDB6n02Tc/pZr/az/Xo7XI5GrzRV1h9a2Ii6iY6qwuNYiOKuEZCpm1lFPgM6hyA3x2M4+4Jh/EonI2YrwurgykDYFTWAO25QvfRh/dnnFFilkBPe4hTMM1VtHCf/9J2Dm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkdUaxBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkdUaxBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B39F1F000C4;
	Thu, 15 Oct 2026 20:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095322;
	bh=JqpfpJXV+u3tNVQ4H9Boi79rJo14439PeffMTqN1d84=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lkdUaxBlBl8kcQFotisAChzXPzvWMLwJEJDE7M1WjD/PuuZei1+dW6w9PzmufJ42w
	 7muugMQMUMaP4oSYizr27xZTnrkRrMwPJGoAFSSW4fhOO5YkNEZfbExWVeXFiAT/v1
	 w0h6jF6wzFn1umaPkr/ul1iJSsA7phaAkybYS72W5Ert4omzvqPHwIvNaDUKgsGNF8
	 X/bUcT6f7r1a1cr9kEEtdbgJOiQBD2UC/W2n9a9gWQENTfgk2wUVx/8HH7LHUOpM7c
	 2B5VKgXd+G6Xg3Csyh5F479zbEcpjwEsi5Q43b8VOvdyYUZumkok56Jmf4/haxhOFV
	 ft3sYOKfh247Q==
Subject: Re: [PATCH net v7 2/4] net/smc: bound the receive length to the RMB
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: alibuda@linux.alibaba.com, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, dust.li@linux.alibaba.com, mjambigi@linux.ibm.com,
 sidraya@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
 horms@kernel.org, linux-kernel@vger.kernel.org, wenjia@linux.ibm.com,
 tonylu@linux.alibaba.com, linux-s390@vger.kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com,
 linux-rdma@vger.kernel.org, raspl@linux.ibm.com, hidayath@linux.ibm.com,
 guwen@linux.alibaba.com
Date: Thu, 15 Oct 2026 20:15:20 +0000
Message-ID: <179209532096.434549.4189685148052558990@kernel.org>
In-Reply-To: <20261013-b4-disp-f345196c-v7-2-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-2-ef3dddfbfa68@proton.me>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 1 (1) · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In smc_rx_recvmsg() (net/smc/smc_rx.c), a wrapped read copies in
  two chunks.
- [Medium] The patch makes smc_rx_data_available() the bounded readiness
  measure: at most rmb_len - splice_pending - peeked, never negative.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  smc_rx_recvmsg() ignores a short positive return from smc_rx_splice().
- [High] This problem wasn't introduced by this patch, but recv() on an
  SMC socket can loop in the kernel indefinitely, ignoring MSG_DONTWAIT,…
- [Medium] This problem wasn't introduced by this patch, but a
  MSG_PEEK|MSG_WAITALL reader keeps peeked_bytes in a local variable…
- [Low] Two existing comments state '/* guarantee 0 <= bytes_to_rcv <=
  rmb_desc->len */': one at net/smc/smc_rx.c:514 in smc_rx_recvmsg(),…

--

net/smc: bound the receive length to the RMB

This patch clamps smc_rx_data_available() so it never reports more than
fits in the RMB behind the spliced and peeked bytes, and never a negative
count. It caches the RMB length in conn->rmb_len for the unlocked wait
predicates, and reorders smc_rx_pipe_buf_release() so released bytes leave
splice_pending before the consumer cursor moves.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..c968ac874d8b9 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -118,15 +118,20 @@ static void smc_rx_pipe_buf_release(struct pipe_inode_info *pipe,

[ ... ]

>  	lock_sock(sk);
>  	if (conn->freed) {
>  		release_sock(sk);
>  		goto out;
>  	}
> +	/* drop the released bytes from splice_pending before cons moves
> +	 * past them, so no reader counts them twice
> +	 */
> +	drained = atomic_sub_and_test(priv->len, &conn->splice_pending);
>  	smc_rx_update_cons(smc, priv->len);

[Severity: High]
Can spliced bytes still be counted twice through the error path in
smc_rx_recvmsg()? A read that wraps the RMB end is copied in two chunks.
If chunk 0 succeeds and chunk 1 fails, the accounting for chunk 0 is
skipped:

net/smc/smc_rx.c:smc_rx_recvmsg() {
    ...
				if (rc < 0) {
					if (!read_done)
						read_done = -EFAULT;
					goto out;
				}
    ...
			atomic_sub(copylen, &conn->bytes_to_rcv);
    ...
}

By that point smc_rx_splice() has already done atomic_add(bytes,
&smc->conn.splice_pending) for chunk 0.

This looks easy to reach. do_splice_read() limits len to
p_space << PAGE_SHIFT. On SMC-D or physically contiguous SMC-R, each chunk
is a single pipe buffer. With one free pipe slot and data that straddles
the RMB end, chunk 0 takes the slot. splice_to_pipe() then returns -EAGAIN
for chunk 1 because the pipe is full.

When the pipe drains, smc_rx_pipe_buf_release() removes chunk 0 from
splice_pending and advances cons. bytes_to_rcv still includes chunk 0. The
next read sizes readable from a bytes_to_rcv that is too large by chunk 0's
length. It returns stale RMB bytes beyond prod and leaves the consumer
cursor sent to the peer ahead of the producer. Every later read is shifted
by the same amount.

The recvmsg path has a similar problem. If memcpy_to_msg() succeeds for
chunk 0 and faults on chunk 1, read_done is returned but the bytes are
never consumed, so the next recv() returns them again.

The commit message says this ordering ensures "no reader counts them
twice". The notes say the old order made "the next splice() returned stale
bytes in place of unread data". Is that still possible through this goto
out path?

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. Does
smc_rx_recvmsg() handle a short positive return from smc_rx_splice()?

For SMC-R with virtually contiguous RMBs (rmb_desc->is_vm),
smc_rx_splice() builds one buffer per page spanned:

	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;

do_splice_read() caps len at p_space << PAGE_SHIFT. That cap counts bytes,
not pages spanned. When the RMB offset is not page-aligned, a full-length
chunk spans p_space + 1 pages, so splice_to_pipe() inserts only p_space
buffers. For example, len 4096 at offset 100 with one free slot inserts
3996 bytes.

smc_rx_splice() adds only that short count to splice_pending. The caller
only checks rc < 0 and then accounts the full chunk:

			read_remaining -= chunk_len;
			read_done += chunk_len;
    ...
			atomic_sub(copylen, &conn->bytes_to_rcv);

Wouldn't splice() then report more bytes than actually reached the pipe?
And wouldn't bytes_to_rcv stay low by (copylen - rc) for good?

Repeated short splices make the deficit grow. The stranded bytes are never
delivered: at EOF, recvmsg sees bytes_to_rcv == 0 with RCV_SHUTDOWN and
returns 0 while data is still in the RMB.

[ ... ]

> diff --git a/net/smc/smc_rx.h b/net/smc/smc_rx.h
> index 994f5e42d1ba2..6bf44e3cc33a0 100644
> --- a/net/smc/smc_rx.h
> +++ b/net/smc/smc_rx.h
> @@ -25,7 +25,16 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
>  		int (*fcrit)(struct smc_connection *conn, size_t baseline));
>  static inline int smc_rx_data_available(struct smc_connection *conn, size_t peeked)
>  {
> -	return atomic_read(&conn->bytes_to_rcv) - peeked;
> +	int avail = atomic_read(&conn->bytes_to_rcv);
> +
> +	/* bytes_to_rcv follows the peer's producer cursor and can be past
> +	 * the RMB or negative. Report no more than fits in the RMB behind the

[Severity: Low]
This is a pre-existing issue, not one introduced by this patch. The new
comment contradicts two existing comments on the same field:

net/smc/smc_rx.c:smc_rx_recvmsg() {
    ...
			atomic_sub(copylen, &conn->bytes_to_rcv);
			/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */
    ...
}

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
		atomic_add(diff_prod, &conn->bytes_to_rcv);
		/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */
    ...
}

Neither site enforces that bound. Could those two comments be corrected
along with this one?

> +	 * bytes already spliced or peeked. Compare before subtracting: near
> +	 * INT_MIN, avail - peeked wraps. This also runs unlocked, possibly
> +	 * after rmb_desc was freed, hence rmb_len.
> +	 */
> +	avail = min(avail, conn->rmb_len - atomic_read(&conn->splice_pending));
> +	return avail > (int)peeked ? avail - (int)peeked : 0;

[Severity: Medium]
Now that this helper is bounded, should the other readiness checks use it
too? Several sites still read the raw counter:

net/smc/af_smc.c:smc_poll() {
    ...
			if (atomic_read(&smc->conn.bytes_to_rcv))
				mask |= EPOLLIN | EPOLLRDNORM;
    ...
}

net/smc/af_smc.c:smc_ioctl() {
    ...
			answ = atomic_read(&smc->conn.bytes_to_rcv);
    ...
}

The defer-accept precheck in smc_accept() does the same:

		} else if (!atomic_read(&smc_sk(nsk)->conn.bytes_to_rcv)) {

The notes say wrap bumps from the peer can still grow bytes_to_rcv. If it
goes negative, smc_rx_data_available() returns 0 and a MSG_DONTWAIT recv()
gets -EAGAIN from smc_rx_recvmsg(). smc_poll() keeps reporting EPOLLIN
for the same socket. Before this patch a negative result was truthy, so
poll and recvmsg agreed.

Can a level-triggered epoll loop now spin on such a socket? SIOCINQ and
FIONREAD would also return a negative or larger-than-RMB value to
userspace.

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. The clamp
keeps the MSG_PEEK|MSG_WAITALL case inside the RMB, but the peeked data can
still have a gap in it.

peeked_bytes is a local that survives smc_rx_wait(), which drops the
socket lock. Suppose another recv() consumes M bytes in that window. The
peeker then resumes from the moved cursor plus the stale count:

		smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
		if ((flags & MSG_PEEK) && peeked_bytes)
			smc_curs_add(conn->rmb_desc->len, &cons, peeked_bytes);

Doesn't the peeking reader then skip M bytes it never saw? TCP catches
this by comparing peek_seq with copied_seq and resyncing, and there is no
matching check here.

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. Can recv()
loop in the kernel indefinitely when unread data and unreleased spliced
bytes coexist?

Say part of the data is spliced into a pipe that nobody drains. Then
splice_pending > 0 and bytes_to_rcv > 0, and smc_rx_data_available() stays
positive as long as splice_pending < rmb_len. The loop in
smc_rx_recvmsg() then runs:

		if (smc_rx_recvmsg_data_available(smc, peeked_bytes))
			goto copy;
    ...
copy:
    ...
		if (!readable || (msg && splbytes)) {
			if (splbytes)
				func = smc_rx_data_available_and_no_splice_pend;
			else
				func = smc_rx_data_available;
			smc_rx_wait(smc, &timeo, peeked_bytes, func);
			continue;
		}

The goto skips the !timeo and signal_pending() checks. The return value of
smc_rx_wait() is ignored, and read_remaining does not change. So this
repeats until the pipe is drained or conn->killed is set.

With MSG_DONTWAIT, each pass sleeps about one jiffy instead of returning
-EAGAIN. With a fatal signal pending, or once sk_err or RCV_SHUTDOWN makes
the wait condition true, smc_rx_wait() returns at once. The task then
spins at full CPU and never reaches a signal check.

This patch narrows the window to 0 < splice_pending < rmb_len but does not
close it.

>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me
