Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D41479864;
	Sun, 20 Sep 2026 23:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789946398; cv=none; b=TtGYKL6V1MzdmbktJ9TqQlA4hZAO92TLPDZnk30x5U4v0ATltwDF8iFlr4oyg1sNryokE+wMtmiA+0hMPXtyhcI+kcxOY9RIlShB3dBsjmcfQIZy55z9EDSwEb95nMhy7XFo4qCt15rwH3wkl17LiR1WhOe58rgsL4FC0SOrCZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789946398; c=relaxed/simple;
	bh=IKZIvra1ZfMPltaAIpyiud9Es9nA89TH0Il8eShjymU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EDkYfuA26FyRdiNVVfjoZ97RluhQZn7lBZFodp7aytRVDnmhhGuiXdQbFDngH6+PZQ6ArYbuvZ0ZwwrlrrpFUQehV4JjVFrOthAjGTPCC/cEk0xttzCpxw140g9zL0ehldmj9MapxPLoWir+Og5nrh54E3zA8dcpaK8ygghukmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFKQBIp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFKQBIp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2C01F00893;
	Sun, 20 Sep 2026 23:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789946396;
	bh=q7F2Lg6LeZJySxabI16pZaBhDYVqRkKyhNpE1ljSy7I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bFKQBIp35lwSsOOIbTcPz1sIdTxsfVnQSAVjM9gpwIggkqs99dIeQlQxEcU9RNfpV
	 w81QyrmvM4cdGH2/8p83hC+DFQ5j3hm1z/rgadfTcBRo7IdOIZMYxFX6PSkVkABg7O
	 XA7P68wljJlGfuZUe6DAqx8Tc0IG0xJSHQa9hCpXepG8zHiLKbZ0OiLygE05zaRieX
	 f/EHsoUQaQHs75/9Jd6XjIm0QK212MEB+6DLevtYlnwlLXwCGVy+M1qacr4aF6Fm9z
	 IAVFDE1/ZrNZUUwPDOg8E14Wzo1f8ktUCTtPN32RQZhqc0qEumKSHtTPwhcLPtXQYa
	 yY7lWfjULslqw==
Subject: Re: [PATCH] net/rds: fix incoming message refcount leak and header
 bounds check in rds_recv.c
From: netdev-bot+sashiko@kernel.org
To: benquike@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Sun, 20 Sep 2026 23:19:55 +0000
Message-ID: <178994639589.2160803.17376356293542307547@kernel.org>
In-Reply-To: <20260919223429.3882046-1-benquike@gmail.com>
References: <20260919223429.3882046-1-benquike@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 2 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Commit message describes a change that the patch does not make.
- [Medium] Undocumented user-visible change to the
  RDS_CMSG_RXPATH_LATENCY ancillary-data semantics: after this patch…
- [Medium] Incomplete guard: the new condition in rds_cmsg_recv()
  (net/rds/recv.c:640-643) only rejects the case where one of the two…
- [Low] Incorrect Fixes: tag.
- [Low] Non-atomic check-then-use on concurrently written timestamps: the
  new guard performs two separate plain loads of each u64 slot of…

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but the latency-
  trace block the patch touches reads rs->rs_rx_traces and…

--

net/rds: fix incoming message refcount leak and header bounds check in rds_recv.c

The change adds a guard in rds_cmsg_recv() so that the receive-path latency
delta is only computed when both of the two timestamps involved are
non-zero. The commit message describes the change as a refcount and bounds
fix. No Link: tags are present in the commit header.

> net/rds: fix incoming message refcount leak and header bounds check in rds_recv.c
>
> In net/rds/recv.c, ensure incoming RDS message references (rds_inc_put)
> and socket receive queue bounds are properly balanced when handling
> error or truncated incoming frames.

[Severity: High]
Does the changelog match the diff?  The subject and body promise a
refcount leak fix (rds_inc_put), a header bounds check, and balanced
socket receive queue accounting on error or truncated frames, but the only
hunk changes the latency subtraction inside the rs_rx_traces block of
rds_cmsg_recv().

No rds_inc_addref()/rds_inc_put() call site is touched, no
rds_recv_rcvbuf_delta()/rs_rcv_bytes accounting is touched, and no header
length validation is added.

The described bug classes also look absent on the named paths.
rds_recvmsg() ends with a single unconditional put that every break from
the receive loop reaches, including the copy error, MSG_TRUNC and
rds_cmsg_recv() -EFAULT cases:

net/rds/recv.c:rds_recvmsg() {
	...
	if (inc)
		rds_inc_put(inc);
	...
}

rds_still_queued() already performs the rcvbuf delta, the list_del_init()
and the queue reference drop together under rs_recv_lock:

net/rds/recv.c:rds_still_queued() {
	...
		if (drop) {
			rds_recv_rcvbuf_delta(rs, sk, inc->i_conn->c_lcong,
					      -be32_to_cpu(inc->i_hdr.h_len),
					      inc->i_hdr.h_dport);
			list_del_init(&inc->i_item);
			to_drop = inc;
		}
	...
}

And j is already bounded at store time in rds_recv_track_latency():

net/rds/af_rds.c:rds_recv_track_latency() {
	if (trace.rx_traces > RDS_MSG_RX_DGRAM_TRACE_MAX)
		return -EFAULT;
	...
		if (trace.rx_trace_pos[i] >= RDS_MSG_RX_DGRAM_TRACE_MAX) {
			rs->rs_rx_traces = 0;
			return -EFAULT;
		}
	...
}

with i_rx_lat_trace[] sized RDS_RX_MAX_TRACES (RDS_MSG_RX_DGRAM_TRACE_MAX
+ 1 == 4), so j <= 2 and j + 1 <= 3 are always in range.

Could the changelog be rewritten to describe the latency change that is
actually made, or could the advertised fixes be implemented?  As written a
stable backporter would pick this up as a memory-safety fix.

> Fixes: bdbe6fbc6a2f ("RDS: recv.c")

[Severity: Low]
Is this the right Fixes: tag?  git blame of the lines being modified at the
baseline attributes the whole rs_rx_traces block, including the
subtraction, to commit 3289025aedc01 ("RDS: add receive message trace used
by application"), not to the original file addition:

3289025aedc01 (Santosh Shilimkar 2016-07-04 640) 	t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
3289025aedc01 (Santosh Shilimkar 2016-07-04 641) 			  inc->i_rx_lat_trace[j];

Pointing the tag at bdbe6fbc6a2f would send this to kernels that predate
the latency trace feature.

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90a..0743706af8ca 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -637,8 +637,10 @@ static int rds_cmsg_recv(struct rds_incoming *inc, struct msghdr *msg,
>  		for (i = 0; i < rs->rs_rx_traces; i++) {
>  			j = rs->rs_rx_trace[i];
>  			t.rx_trace_pos[i] = j;
> -			t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
> -					  inc->i_rx_lat_trace[j];
> +			if (inc->i_rx_lat_trace[j + 1] &&
> +			    inc->i_rx_lat_trace[j])
> +				t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
> +						inc->i_rx_lat_trace[j];
>  		}

[Severity: Medium]
Is this a user-visible change to the RDS_CMSG_RXPATH_LATENCY semantics?
When the guard fails, t.rx_trace[i] stays 0 from the earlier memset, but
t.rx_traces and t.rx_trace_pos[i] still advertise the position as measured.

The uAPI has no per-entry validity encoding:

include/uapi/linux/rds.h:
struct rds_cmsg_rx_trace {
	__u8 rx_traces;
	__u8 rx_trace_pos[RDS_MSG_RX_DGRAM_TRACE_MAX];
	__u64 rx_trace[RDS_MSG_RX_DGRAM_TRACE_MAX];
};

so how does userspace tell "not measured" from a genuine 0 ns delta?

The unstamped slots are real.  Only net/rds/ib_recv.c and
net/rds/tcp_recv.c stamp the early positions, for example:

net/rds/tcp_recv.c:rds_tcp_data_recv() {
	...
			tinc->ti_inc.i_rx_lat_trace[RDS_MSG_RX_HDR] =
					local_clock();
	...
}

while the loopback transport calls rds_inc_path_init(), which zeroes the
array, and then rds_recv_incoming() without stamping anything:

net/rds/loop.c:rds_loop_xmit() {
	rds_inc_path_init(&rm->m_inc, &conn->c_path[0], &conn->c_laddr);
	rds_message_addref(rm);

	rds_recv_incoming(conn, &conn->c_laddr, &conn->c_faddr, &rm->m_inc,
			  GFP_KERNEL);
	...
}

Would it be better to stamp the missing trace points in the producers, or
to omit the unavailable entries (shrinking rx_traces and rx_trace_pos) and
document that in the uAPI header?  Either way, this behaviour change is not
mentioned in the changelog.

[Severity: Medium]
Does this guard cover the reversed-timestamp case?  Both values can be
non-zero with inc->i_rx_lat_trace[j + 1] < inc->i_rx_lat_trace[j], and the
u64 subtraction then wraps and reports roughly 1.8e19 ns to userspace.

For j == RDS_MSG_RX_DGRAM_DELIVERED the two samples are taken in different
contexts on possibly different CPUs.  One is taken in transport receive
context:

net/rds/recv.c:rds_recv_incoming() {
	...
	inc->i_rx_lat_trace[RDS_MSG_RX_END] = local_clock();
	...
}

and the other in recvmsg() context, in this same function:

	inc->i_rx_lat_trace[RDS_MSG_RX_CMSG] = local_clock();

local_clock() is sched_clock_cpu() of the current CPU and is only
monotonic per-CPU, so with an unstable sched_clock the later sample can be
smaller.

Would comparing the two values instead, and computing the delta only when
inc->i_rx_lat_trace[j + 1] > inc->i_rx_lat_trace[j], cover this case and
also subsume the zero check being added here?

[Severity: Low]
Can the value tested by the guard differ from the value subtracted?  Each
slot is loaded twice with plain accesses, once for the non-zero test and
once for the subtraction, while this same function stores into
inc->i_rx_lat_trace[RDS_MSG_RX_CMSG] with no lock held.

Two concurrent recvmsg(MSG_PEEK) callers can hold a reference to the same
rds_incoming.  rds_next_incoming() takes a reference without dequeuing:

net/rds/recv.c:rds_next_incoming() {
	...
		if (!list_empty(&rs->rs_recv_queue)) {
			*inc = list_entry(rs->rs_recv_queue.next,
					  struct rds_incoming,
					  i_item);
			rds_inc_addref(*inc);
		}
	...
}

and rds_still_queued() with drop == 0 returns 1 for both callers without
list_del_init(), releasing rs_recv_lock before rds_cmsg_recv() runs.

Since a user-selected j == RDS_MSG_RX_END makes j + 1 == RDS_MSG_RX_CMSG,
the slot being tested is exactly the slot the other thread stores into.  On
32-bit builds can the u64 store be observed torn between the two loads,
giving a value below inc->i_rx_lat_trace[j] and the same unsigned
underflow this check is meant to suppress?

Would reading each timestamp once into a local with READ_ONCE() and
validating and subtracting the locals, or keeping the CMSG timestamp in a
local rather than storing it into the still-queued inc, avoid this?

[Severity: Low]
This isn't a bug introduced by this patch, but the block being touched
reads rs->rs_rx_traces and rs->rs_rx_trace[] with no lock, no READ_ONCE()
and no barrier, while the writer publishes the count before filling and
validating the entries:

net/rds/af_rds.c:rds_recv_track_latency() {
	rs->rs_rx_traces = trace.rx_traces;
	for (i = 0; i < rs->rs_rx_traces; i++) {
		if (trace.rx_trace_pos[i] >= RDS_MSG_RX_DGRAM_TRACE_MAX) {
			rs->rs_rx_traces = 0;
			return -EFAULT;
		}
		rs->rs_rx_trace[i] = trace.rx_trace_pos[i];
	}
	...
}

SO_RDS_MSG_RXPATH_LATENCY is the only case in rds_setsockopt() that is not
wrapped in lock_sock()/release_sock(), and rds_recvmsg() does not take
lock_sock() either, so the two paths share no lock.

Can a concurrent recvmsg() then see rs_rx_traces == 3 together with stale
rs_rx_trace[] entries, a (count, entries) pair that never existed?  The
loop bound rs->rs_rx_traces is also re-read on each iteration after
t.rx_traces was latched, so the reported count and the number of filled
entries can disagree.

No out-of-bounds index results, since every stored rs_rx_trace[i] was
validated against RDS_MSG_RX_DGRAM_TRACE_MAX before being stored.  This
dates back to commit 3289025aedc01 ("RDS: add receive message trace used by
application").  Publishing the entries before the count, with the count
written last using WRITE_ONCE(), or serializing both paths under
lock_sock(), would address it.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919223429.3882046-1-benquike%40gmail.com
