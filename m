Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795413613;
	b=u2ceiW90vlcMcznXfXjpjhPfm+fNDM55tna2HGOB5N6DlB5qL65TqDHNtBRitl8PjJZr
	 f4dqdNL8mM+k8v+z3vjYhSIt+6kaisuILJxXHdZJvckCN1HyJc9sQaY9f3k6Kp7mG2c55
	 foguoF2hW+jol+eGLLw1at5KSy5/zJjHCg4pSXDILKnbuaeQ5Yw7x/5LzT8kQwUAOnd8B
	 bkXXZrP+0q4weQhEwbhSxzjQcrtGGpLi3cMkBfPNjdgAWNiKo2XTiauiFFD6Iz4rWoTnj
	 9NMgGPCONb4azACISQCfKMoJbADjFUzi8SFdjnkemOvnIuEaVF5/BJi9VoxAEqPMioQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795413613;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4o/3B7pUXuwDFpxtRlH6qNIzuDtBf5+FEuoviec2aUs=;
	b=JoTDzEzi+Z3VwU+JRJ6A8lmiaSrxsd+qv3F8PRPAZJbtlzLfHejJ3Vr1S7fjWhnIF49I
	 mzR4rB0ashtc1ABGXSN8f0e2+UbIlBFDVU6bgED9ivpegs5x7KCxMzc6rjqxt27sUAZjr
	 Qmvgl8ZN+FKx3unOWNZCAlFzYEwqIo5wsUZ/izdKpw7GOuWRye3I7VNHUdiAN2iwhkMDo
	 SrHkSbkYBf6D2Ct47FJ7By8wBCpTtoJI306F1wxRqpZ5ienIKendyAlMOgnh844Qhm21s
	 1Ig0tgNGyLJilIyvx3Ji8R9563JoD9Q8rYXN8An1h7c6SN5aPLFWsvpCwuuw0W+M5+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgVzhCe6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486AC606A327;
	Mon, 23 Nov 2026 06:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgVzhCe6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D1E1F000C4;
	Mon, 23 Nov 2026 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795413612;
	bh=4o/3B7pUXuwDFpxtRlH6qNIzuDtBf5+FEuoviec2aUs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BgVzhCe626Rh5/823hjW8sNahVD0sDTAWzkqxtzvDdNnxrjb5D/nzCZ2OtfWGY62h
	 oOYWNj8FowFMS/EhmqZo2AUGJU8to3iYHHCmvWlUAfUVDMEYe92TLtqUJHKkfWcmDt
	 uShYht4BQ9yMiPLQj6VKmXYxqPLVOrz5akHgk/foer5uUf2byic6BP/KGQV9LZ/Y1l
	 o0YwgfF+P2Ejf/Jfv+Om64YocjCo1tkQ0rUQbdPskgDM+DUBvxFJ4xc6YIZrz5gumi
	 8pjjiRSSO/LLrY09HogQ7uCwCkkK5PPl7KYOYzt1zIbCUwbb55P6sCPmP7qGCfyYSF
	 n3hGFok0hBi0g==
Subject: Re: [PATCH net] net/smc: bound a send by the send buffer, not by the
 peer's credit
From: netdev-bot+sashiko@kernel.org
To: piyus@iiitd.ac.in
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kapil@presceralabs.ai, kuba@kernel.org
Date: Mon, 23 Nov 2026 06:00:11 +0000
Message-ID: <179541361172.3135.1077986856171763823@kernel.org>
In-Reply-To: <20261122053223.2497832-2-piyus@iiitd.ac.in>
References: <20261122053223.2497832-2-piyus@iiitd.ac.in>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 (1) · High: 0 · Medium: 4 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message's threat model is wrong for the path it
  names.
- [Medium] The new comment in smc_tx_sendmsg() (net/smc/smc_tx.c:238-243)
  and the commit message name only the SMC-D DMB-nocopy credit in…
- [Medium] The patch fixes a write past the end of the send buffer and
  includes a KASAN splat, but it carries no Fixes: tag and no Cc:…
- [Medium] The clamp keeps each memcpy_from_msg() in smc_tx_sendmsg()
  inside the buffer, but the peer-derived credit stays uncapped.
- [Low] After this patch the tree contradicts itself about sndbuf_space.

Pre-existing issues:
- [Critical] This patch did not introduce this problem, but the receive
  path has the same flaw and it is still present.

--

net/smc: bound a send by the send buffer, not by the peer's credit

This patch clamps copylen in smc_tx_sendmsg() to sndbuf_desc->len. With
the clamp, the second (wrapped) chunk can no longer be written past the
end of the send buffer when sndbuf_space has been inflated. The commit
message attributes the inflated credit to the SMC-D DMB-nocopy path in
smc_cdc_msg_recv_action().

> That counter is not always a value this side computed.  On the SMC-D
> DMB-nocopy path smc_cdc_msg_recv_action() credits it from the peer's
> consumer cursor:

[ ... ]

> Reproduced.  A hostile peer needs an ISM device we do not have, so the peer
> was stood in for by a debug patch that overrides the consumer cursor after
> validation, on an SMC-D connection over the loopback-ISM device.  The

[Severity: Medium]
Is this threat model accurate for the path named here?

In smc_cdc_msg_recv_action(), the diff_tx credit only runs under this
check:

	if (conn->lgr->is_smcd &&
	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {

smc_ism_support_dmb_nocopy() only returns true when the device provides
support_mmapped_rdmb:

	/* for now only loopback-ism supports
	 * merging sndbuf with peer DMB to avoid
	 * data copies between them.
	 */
	return (smcd->dibs->ops->support_mmapped_rdmb &&
		smcd->dibs->ops->support_mmapped_rdmb(smcd->dibs));

The only provider of that op appears to be drivers/dibs/dibs_loopback.c:

	.support_mmapped_rdmb = dibs_lo_support_dmb_nocopy,

With real ISM hardware this credit branch never runs. With loopback-ism,
both ends are the same kernel, so in-kernel SMC code writes the consumer
cursor, not a remote party.

Would it be more accurate to describe the nocopy part as hardening?

The text also says the cursor was overridden "after validation". It then
refers to "net/smc: validate the peer's CDC cursors against our own
buffers". That validation doesn't appear to be in this tree, because
smcd_cdc_msg_to_host() still copies the peer's prod/cons cursors as they
arrive. Should the message state that dependency?

The path a remote peer can actually reach seems to be smc_switch_cursor()
during SMC-R link failover (see the comment on the diff below). Could
the message name that path?

[ ... ]

> Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
> Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>

[Severity: Medium]
Should this carry Fixes: tags and Cc: stable?

Before this patch, the second chunk in smc_tx_sendmsg() overflowed the
sndbuf whenever sndbuf_space exceeded sndbuf_desc->len. The commit
message includes a KASAN splat for that write.

There appear to be two sources of that credit:

cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB
are merged") added the nocopy diff_tx credit in
smc_cdc_msg_recv_action().

c6f02ebeea3a ("net/smc: switch connections to alternate link") added
atomic_add(diff, &conn->sndbuf_space) in smc_switch_cursor(), which a
remote SMC-R peer can reach.

Without the tags, stable trees won't pick up the fix for the SMC-R case.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 0f0c6df3bf2ce..5dc489bf624ed 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -235,6 +235,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		writespace = atomic_read(&conn->sndbuf_space);
>  		/* not more than what user space asked for */
>  		copylen = min_t(size_t, send_remaining, writespace);
> +		/* and never more than the send buffer holds.  sndbuf_space is
> +		 * credited in smc_cdc_msg_recv_action() from the peer's
> +		 * consumer cursor on the SMC-D DMB-nocopy path, so it is not a
> +		 * value this side computed, and the second chunk below is not
> +		 * clamped against the buffer the way the first one is.
> +		 */

[Severity: Medium]
Is the nocopy path the only place that credits sndbuf_space from a peer
cursor? smc_switch_cursor() in net/smc/smc_core.c runs on SMC-R link
failover and does:

	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);

	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
		...
		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
		smc_curs_add(conn->sndbuf_desc->len,
			     &conn->tx_curs_sent, diff);
		smc_curs_add(conn->sndbuf_desc->len,
			     &conn->tx_curs_fin, diff);

		smp_mb__before_atomic();
		atomic_add(diff, &conn->sndbuf_space);

Nothing bounds diff from above.

On SMC-R, smc_cdc_cursor_to_host() only rejects cursors that move
backward:

	if ((old.wrap == temp.wrap) &&
	    (old.count > temp.count))
		return;
	smc_curs_copy(local, &temp, conn);

A remote peer can therefore advance cons.count by a large amount. In a
multi-link group it can then force failover by sending an LLC
DELETE_LINK:

smc_llc_process_cli_delete_link()
  smc_switch_conns()
    smc_switch_cursor()
      atomic_add(diff, &conn->sndbuf_space)

That looks like the remotely reachable trigger for the overflow this
patch fixes. Should the comment and the commit message mention it?

The commit message also offers to cap the credit at the atomic_add()
instead. That cap would need to cover this site too.

smc_curs_add() subtracts the size only once. For a large enough diff,
could tx_curs_sent.count therefore stay at or above sndbuf_desc->len?
smc_tx_rdma_writes() later uses sent.count as the source offset:

	to_send = smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);

This patch leaves that cursor state as it is.

> +		copylen = min_t(size_t, copylen, conn->sndbuf_desc->len);

[Severity: Medium]
Does this clamp bound the send by the send buffer, as the subject says?
Each memcpy_from_msg() now stays inside the buffer, but sndbuf_space
itself is still uncapped.

With the numbers from the commit message, one iteration ends with:

	atomic_sub(copylen, &conn->sndbuf_space);

That leaves 1065504 - 65504 = 1000000, so this check never sends the
producer into smc_tx_wait():

	if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {

Each later loop iteration, and each later sendmsg(), can then write up
to a full ring at tx_curs_prep. Can that overwrite data the consumer
hasn't sent yet? Can it let prep get more than one wrap ahead of
tx_curs_sent and tx_curs_fin?

smc_curs_diff() only compares wraps with !=. In that state,
smc_tx_prepared_sends() and to_send in smc_tx_rdma_writes() would
misreport pending data. Meanwhile sendmsg() returns success for data
that was overwritten.

SIOCOUTQ in smc_ioctl() also still relies on the invariant:

	answ = smc->conn.sndbuf_desc->len -
			atomic_read(&smc->conn.sndbuf_space);

In that state SIOCOUTQ would return a negative queue length to
userspace.

Would the credit need to be capped where it is added, in
smc_cdc_msg_recv_action() and smc_switch_cursor(), as the commit message
offers? Without that, the invariant isn't restored.

[Severity: Low]
This isn't a functional bug, but the new comment says sndbuf_space can't
be trusted. The existing comments still claim the invariant holds. In
smc_cdc_msg_recv_action():

	atomic_add(diff_tx, &conn->sndbuf_space);
	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

and later in smc_tx_sendmsg():

	atomic_sub(copylen, &conn->sndbuf_space);
	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

copylen is now capped at len, so an inflated sndbuf_space stays above
len after the subtraction. In that case both comments are false.

The nocopy caller of smc_curs_diff() also passes an unchecked peer
cursor as new. That goes against the helper's documented contract:

	/* calculate cursor difference between old and new, where old <= new and
	 * difference cannot exceed size
	 */

Should these comments be updated along with this change?

>  		/* determine start of sndbuf */
>  		sndbuf_base = conn->sndbuf_desc->cpu_addr;
>  		smc_curs_copy(&prep, &conn->tx_curs_prep, conn);

[Severity: Critical]
This isn't a bug introduced by this patch, but the receive side appears
to have the same unclamped second chunk. In smc_rx_recvmsg():

		copylen = min_t(size_t, read_remaining, readable);
		...
			chunk_len = copylen - chunk_len; /* remainder */
			chunk_len_sum += chunk_len;
			chunk_off = 0; /* modulo offset in recv ring buffer */

The only bound on copylen is bytes_to_rcv. smc_cdc_msg_recv_action()
credits bytes_to_rcv from the peer's producer cursor with no cap:

	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);
	...
		atomic_add(diff_prod, &conn->bytes_to_rcv);
		/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */

On SMC-R, smc_cdc_cursor_to_host() only rejects backward cursors. On
SMC-D, smcd_cdc_msg_to_host() copies prod as it arrives.

Suppose a remote peer sends the same wrap with a large count. Could
memcpy_to_msg() or smc_rx_splice() then read far past the end of the
RMB and copy kernel memory to user space?

The commit message points to "net/smc: validate the peer's CDC cursors
against our own buffers" for the receive side. That validation isn't in
this tree.

Would a similar clamp against conn->rmb_desc->len in smc_rx_recvmsg(),
or validating the cursors on receive, close this?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122053223.2497832-2-piyus%40iiitd.ac.in
