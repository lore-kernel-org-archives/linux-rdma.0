Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E275B4CC631;
	Fri,  9 Oct 2026 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546757; cv=none; b=cZvw+dMYhK+aSs+tetB50PT9pxqNyjtDUXCs8Yjs72wXkIldPGZRPaLzk9/y21O0ztQf+TS8K2agPuCbQutyVzkGpKupcNxwCleNvLe0TwVV+7875SnZUVU+sJYY8V8rjzduGqxAsl+BErikbsDCWU1gTK16hu45oFBTVa8fEdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546757; c=relaxed/simple;
	bh=PPCZdcfKYwdDdilZWLfJBoE2GoRdIaFesAzFZb/zENo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ghrnx48c/EQQQwwuNd1aZvgeEi/jMiFJl3vvJ+24NHKNMkKGNZ4YA2TQ8H1SpXRKOc+ajpp/sUYprASdG7X5PhhFyCgL1PNrpUZuqB+CBmEIUpKAD1o1m8hT42Qw9Q0HYD4KGIyqIQh9hjesHFZmnbsx7WhhCbIds1+BSGj7v74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhCOQaoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhCOQaoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EF01F00893;
	Fri,  9 Oct 2026 11:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791546745;
	bh=uYGMKbVg+f6Lb1NBO9+91jGmwPF7QqLqXol7N3FJW4Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GhCOQaoQgiNY6ebHFaHu2FI//Gelg1H53MczrkgEKHOJNmtdO7G++9xdlX1RbEYKB
	 C4OI6sJirqInDQyuZLHjtlxmCCXEbpueFyAaz8UVozn/Kfy5SoUCrk6FCxOGCDqK18
	 B0NbPtKgh23YqIBUc+LCTTDuK55J78mVxYPpIyBh6vIA9kMwdTaS7p9sPaxcDDUqxd
	 lyAxCY7Hwa1+BtQeQH9GQGre2MMHrG8cBojl/PxhAyjzXRznL1KHde8mXCwYHo3nKx
	 3aESgL/wc6czsmkHLsb0TqJwuNDOdvhYJh2rEjKypamAHET1mIuklirynRzMjmb8QF
	 rRjR0c40ilxQg==
Subject: Re: [PATCH net] RDS/IB: validate receive completion payload length
From: netdev-bot+sashiko@kernel.org
To: tjdqudcks0424@naver.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andy.grover@oracle.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Fri, 09 Oct 2026 11:52:24 +0000
Message-ID: <179154674424.434549.17010564396814688195@kernel.org>
In-Reply-To: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new length check can be bypassed, so the stale/uninitialized
  receive-fragment disclosure that this commit claims to close can still…
- [Medium] When the new length check in rds_ib_process_recv()
  (net/rds/ib_recv.c:952-959) rejects a fragment, it jumps to `done` and…
- [Low] The commit message understates the impact.

--

RDS/IB: validate receive completion payload length

This patch adds a check to rds_ib_process_recv(). The payload length
reported by the receive completion must match the expected length of the
current fragment, min(i_recv_data_rem, RDS_FRAG_SIZE). On mismatch the
connection is dropped and reconnected, and the receive fragment is not
attached to the incoming message.

> An RDS/RDMA peer can declare a fragment length larger than the payload
> reported by the receive completion. The receive path attaches the recycled
> receive fragment without validating those lengths, allowing recvmsg() to
> return stale bytes beyond the actual payload.

[Severity: Low]
Is "recycled receive fragment" the full picture here? When
ic->i_cache_frags is empty, rds_ib_refill_one_frag() allocates a new
page:

net/rds/ib_recv.c:rds_ib_refill_one_frag() {
    ...
		ret = rds_page_remainder_alloc(&frag->f_sg,
					       RDS_FRAG_SIZE, page_mask);
    ...
}

page_mask is either GFP_HIGHUSER or the caller's gfp.
rds_page_remainder_alloc() then calls alloc_page() without __GFP_ZERO:

net/rds/page.c:rds_page_remainder_alloc() {
    ...
	if (bytes >= PAGE_SIZE) {
		page = alloc_page(gfp);
    ...
}

On a fresh frag, the bytes after a short payload would be uninitialized
kernel page contents, not only tails from earlier RDS messages.

The code change covers this case too. Could the commit message also
describe it as a kernel memory disclosure?

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..0daddb108c8a7 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connection *conn,
>  		}
>  	}
>  
> +	if (data_len != min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {

[Severity: High]
Can an RDMA write with immediate get past this check?

rds_ib_recv_cqe_handler() passes every successful completion to
rds_ib_process_recv() without checking wc->opcode:

net/rds/ib_recv.c:rds_ib_recv_cqe_handler() {
    ...
	if (wc->status == IB_WC_SUCCESS) {
		rds_ib_process_recv(conn, recv, wc->byte_len, state);
    ...
}

A write with immediate uses up the next receive WQE but does not write
to its scatter list (ic->i_recv_hdrs[slot] and recv->r_frag). For
IB_WC_RECV_RDMA_WITH_IMM, byte_len is the RDMA write length. In rxe,
for example:

drivers/infiniband/sw/rxe/rxe_resp.c:do_complete() {
    ...
		wc->byte_len = (pkt->mask & RXE_IMMDT_MASK &&
				pkt->mask & RXE_WRITE_MASK) ?
					qp->resp.length : wqe->dma.length - wqe->dma.resid;
    ...
}

The header buffer for a ring slot is never cleared between uses. It
still holds the last normal header received into that slot, and that
header's checksum still verifies.

recv->r_frag is either a recycled frag from the cache or a fresh
alloc_page() page.

rds_ib_post_reg_frmr() registers RDS MRs with IB_ACCESS_REMOTE_WRITE. A
peer holding an rkey from a local RDS user could then do this:

  1. send a normal message into a slot with h_len=4096, a bound dport,
     and RDS_FLAG_RETRANSMITTED clear
  2. when that slot comes around again, issue a write with immediate of
     sizeof(struct rds_header) + 4096 bytes to a remote-writable MR

The new check sees data_len == min(i_recv_data_rem, RDS_FRAG_SIZE) and
passes, so the unwritten frag is attached.

rds_recv_incoming() only drops old sequence numbers when
RDS_FLAG_RETRANSMITTED is set:

net/rds/recv.c:rds_recv_incoming() {
    ...
	if (be64_to_cpu(inc->i_hdr.h_sequence) < cp->cp_next_rx_seq &&
	    (inc->i_hdr.h_flags & RDS_FLAG_RETRANSMITTED)) {
    ...
}

rds_ib_inc_copy_to_user() would then copy h_len bytes of stale or
uninitialized frag data to userspace.

Should completions whose opcode is not IB_WC_RECV be rejected before the
receive buffers are parsed or byte_len is trusted?

> +		rds_ib_conn_error(conn,
> +				  "incoming fragment payload length %u, expected %u; "
> +				  "disconnecting and reconnecting\n",
> +				  data_len,
> +				  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
> +		goto done;
> +	}

[Severity: Medium]
Does this goto done leave the partial message in place for later
fragments to complete?

ic->i_ibinc stays set (it was just installed if this fragment started
the message), and ic->i_recv_data_rem is not reduced.

rds_ib_conn_error() ends up in rds_conn_path_drop(). That function only
sets RDS_CONN_ERROR and queues the shutdown work:

net/rds/connection.c:rds_conn_path_drop() {
    ...
	atomic_set(&cp->cp_state, RDS_CONN_ERROR);
    ...
	queue_work(cp->cp_wq, &cp->cp_down_w);
    ...
}

In the meantime poll_rcq() keeps calling rds_ib_recv_cqe_handler() for
the rest of the batch. Later tasklet runs do the same until shutdown
sets i_cq_quiesce.

A later fragment with the same h_sequence, h_len and ports, and the
expected length, passes both the header comparison and the new check.
For example, with h_len=8192 and these completions:

  A: 4096 bytes  -> attached, rem = 4096
  B: 16 bytes    -> rejected here, rem still 4096
  C: 4096 bytes  -> attached, rem = 0

The message is delivered as A+C, with C's payload where B's belongs.

rds_recv_incoming() does not check the connection error state. The
message is queued to the socket and acked through state->ack_next, and
cp_next_rx_seq advances. A later retransmission flagged
RDS_FLAG_RETRANSMITTED would then be dropped as old.

This seems to contradict the commit message:

  "With this change, the malformed message was not delivered"

The existing fragment header mismatch path has the same weakness, and
this patch adds a second rejection path that shares it.

Could the in-progress inc be dropped here instead? That would mean
calling rds_inc_put(&ic->i_ibinc->ii_inc) and clearing ic->i_ibinc and
ic->i_recv_data_rem. Another option is to stop reassembly once the
connection is in error.

>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag = NULL;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006205204.1322102-1-tjdqudcks0424%40naver.com
