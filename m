Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBCC282F12;
	Mon, 24 Aug 2026 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568500; cv=none; b=hjiL5F/8BJQfDdFfFTRm/8YW/NP+hkP+EHBioZjGGFs7k6Y3oNictqwsQpu2EfCAlsSguIHGlUQiYQi2xrXsy8pNZuKIz/qkD7xb5tV9tsWBzEXssbdoIHbNduUh+G6uALTKLiQbtGn378k9tTqTKpfPVrEBV2ehiU0s1/w5WC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568500; c=relaxed/simple;
	bh=3pKZFIZxyHU3J2HBiqbS+ZyNEU0HBe1zGRt4594yt/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE8Xl6pKsu4OHWP1g8LM7KWQOP7r1pLZ358bWMyuKjqkKD+K7sLbRLhjmxuirFNMtwm4au7bxyR/EnWh0coW3r6J1Stbo6014xfV3/KrMerYboqnOJ3l2PshYQhDpK66qEdyy5Y+Axw2Uha3PpxFZv6jQG+/e7avu3NC5btjR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReKdi9bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReKdi9bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6871F000E9;
	Mon, 24 Aug 2026 10:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787568498;
	bh=Un2ivzOvq2zhROxjhe67/b4g3gW2MziKJw+Dc4KeLN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReKdi9bJXuq0h49PbAdCSfn0gk02tVvq5Fito3GCMAiQF1TZ1VOenyVHOIrY1Fo4W
	 PT4AONuYDyxb340ohDyITd1eSbjwdDmyJ3tUX+mNzKQN4fzNifTCfk1G67QjMY8xAZ
	 oEVjap7xbznBtoQPu4NP6DQAIgxXtR7b7/wF7jfspCkUb7pD4Af9irSUv1miMN/5tB
	 AfBupKIrVCWINho7JhBa1Nge985rPzaUgWVCUb9D22uCePklJwh1/qGRIY5nf9o7Lc
	 N2O5riPkX6x0zkjV3RP9EM+wjReOP7dq7FoURf5BT1SqS2uIJ3o7+6o0A1i22WOXDW
	 GziwhonA6qQ1g==
From: Simon Horman <horms@kernel.org>
To: hidayath@linux.ibm.com
Cc: Simon Horman <horms@kernel.org>,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	andrew+netdev@lunn.ch,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	pasic@linux.ibm.com,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: do not credit bytes that splice() did not take
Date: Mon, 24 Aug 2026 11:47:58 +0100
Message-ID: <20260824104758.996259-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820085543.967490-1-hidayath@linux.ibm.com>
References: <20260820085543.967490-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260820085543.967490-1-hidayath@linux.ibm.com?part=1
---
net/smc: do not credit bytes that splice() did not take

The patch adds a short-count path to the chunk loop in smc_rx_recvmsg()
so that only the number of bytes splice_to_pipe() actually accepted is
credited to copylen, read_remaining and read_done.  It also adds a
zero-count path that returns -EAGAIN when nothing was taken.

>     A pipe that is not empty is enough to hit this; SPLICE_F_NONBLOCK on a
>     full pipe produces the zero case.

[Severity: Low]
Is "A pipe that is not empty is enough to hit this" accurate?  A non-zero
short return from splice_to_pipe() requires smc_rx_splice() to submit more
than one page:

net/smc/smc_rx.c:smc_rx_splice() {
	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;

For SMC-D and for SMC-R with physically contiguous RMBs nr_pages is 1 and
the single pipe_buffer carries partial[0].len == len, so the transfer is
all-or-nothing.  Together with wait_for_space() in splice_file_to_pipe()
guaranteeing at least one free slot on entry, doesn't the short-count case
only occur for SMC-R with is_vm RMBs?

Would it help to name that configuration in the changelog so backporters
know what to test?

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 5c9e4d8b57de4..d951dbe8eec3c 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -488,6 +488,24 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  						read_done = -EFAULT;
>  					goto out;
>  				}

[Severity: High]
This isn't a bug introduced by this patch, but since the patch reworks
exactly this accounting: does this pre-existing exit leak bytes_to_rcv on
a wrapped read?

For a read that wraps the ring, chunk 0 can succeed and chunk 1 fail.
smc_rx_splice() has already committed chunk 0:

net/smc/smc_rx.c:smc_rx_splice() {
	bytes = splice_to_pipe(pipe, &spd);
	if (bytes > 0)
		atomic_add(bytes, &smc->conn.splice_pending);

and the queued buffers advance the consumer cursor when the reader drains
them:

net/smc/smc_rx.c:smc_rx_pipe_buf_release() {
	lock_sock(sk);
	smc_rx_update_cons(smc, priv->len);
	release_sock(sk);

Chunk 1 then finds the pipe full.  fs/splice.c:splice_to_pipe() converts
no progress to an error rather than 0:

	if (!ret)
		ret = -EAGAIN;

so control takes the quoted "if (rc < 0) ... goto out" with read_done ==
chunk 0 length, jumping past the only debit site in smc_rx_recvmsg():

	atomic_sub(copylen, &conn->bytes_to_rcv);

Doesn't that leave cons advanced by the delivered bytes while
bytes_to_rcv still counts them?  smc_rx_data_available() reads
atomic_read(&conn->bytes_to_rcv) - peeked, so would a subsequent
recvmsg()/splice() start at the advanced cursor and copy that many bytes
of stale RMB content from past the producer position?

Also, can the documented invariant "0 <= bytes_to_rcv <= rmb_desc->len"
be violated if this repeats?

> +				/* splice_to_pipe() takes only what the pipe
> +				 * has room for, which may be less than was
> +				 * offered, or nothing. Account what it took
> +				 * and stop: crediting the whole chunk would
> +				 * advance the consumer past data the reader
> +				 * never received.
> +				 */
> +				if (!msg && rc < chunk_len) {
> +					if (!rc) {
> +						if (!read_done)
> +							read_done = -EAGAIN;
> +						goto out;
> +					}

[Severity: Medium]
Can rc ever be 0 here?  splice_to_pipe() returns 0 only for
spd->nr_pages == 0, and otherwise ends with:

fs/splice.c:splice_to_pipe() {
	if (!ret)
		ret = -EAGAIN;

smc_rx_splice() always builds nr_pages >= 1 and returns the
splice_to_pipe() value unchanged, so the "took nothing" case arrives as
-EAGAIN and is consumed by the pre-existing block above, which reports
-EFAULT to userspace.  Does that make this "if (!rc)" arm unreachable,
and the changelog claim

     When it took nothing, return -EAGAIN instead of reporting a length
     that was not delivered.

not take effect?

On the same note, does "SPLICE_F_NONBLOCK on a full pipe produces the
zero case" hold?  splice_file_to_pipe() calls wait_for_space() before
do_splice_read():

fs/splice.c:wait_for_space() {
		if (!pipe_is_full(pipe))
			return 0;
		if (flags & SPLICE_F_NONBLOCK)
			return -EAGAIN;

so a completely full pipe fails before smc_splice_read() is entered.
Should the comment block above also be reworded, since it describes a
callee returning zero that splice_to_pipe() does not do?

> +					copylen = chunk_len_sum - chunk_len + rc;
> +					read_remaining -= rc;
> +					read_done += rc;
> +					break;
> +				}
>  			}
>  			read_remaining -= chunk_len;
>  			read_done += chunk_len;

[Severity: High]
This is a pre-existing issue outside the diff, but this patch depends on
the invariant it breaks, so it may be worth mentioning: in
smc_rx_pipe_buf_release() the cursor advance happens under the socket
lock while the splice_pending decrement happens after it is dropped:

net/smc/smc_rx.c:smc_rx_pipe_buf_release() {
	lock_sock(sk);
	smc_rx_update_cons(smc, priv->len);
	release_sock(sk);
	if (atomic_sub_and_test(priv->len, &conn->splice_pending))
		smc_rx_wake_up(sk);

smc_rx_recvmsg() assumes cons plus splice_pending marks the start of
unread data:

	splbytes = atomic_read(&conn->splice_pending);
	...
	smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
	...
	if (splbytes)
		smc_curs_add(conn->rmb_desc->len, &cons, splbytes);

In the window between release_sock() and atomic_sub_and_test(), cons
already includes priv->len and splice_pending still counts the same
bytes.  Can a concurrent splice on the same socket then start priv->len
bytes too far, skipping unread data and handing stale ring content to the
pipe?

The recvmsg() path looks protected because it waits while splice_pending
is non-zero:

		if (!readable || (msg && splbytes)) {

but the splice path (msg == NULL) is not gated on splice_pending.  The
pipe mutex doesn't serialize this either, since splice_file_to_pipe()
holds only the destination pipe's lock, so draining pipe A can race with
splicing the same socket into pipe B.

Would moving the atomic_sub_and_test() before release_sock() make cons
and splice_pending change together with respect to the socket lock?
