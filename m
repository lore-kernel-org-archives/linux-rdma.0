Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0DA37C103;
	Thu, 27 Aug 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853741; cv=none; b=DS0AafVSwSWnXZ507b5UTs3UbClorLwKP2Pp7b8uHzXz4nvI5CNcYhGqOgvPz8/KV87aKr9Rvc3hfE0oQOO0X6V440ql/XeDg9EhBKq4KVGGaYqEyQ6CISEhPefqiRdCRI91fumvqwv6wBPnt5Z910d29I+I2SUHaR6BeruNYwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853741; c=relaxed/simple;
	bh=0TCZcvcjfO5GLYplZwu5j9gGloyjQbl8W/CsUY7tS38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QltXHt2PYYpJvug6bABZg1mMk8L+98sURg0m9wFTbQ87o8E4Wy2ZZkr/9qNGRG2RLwWvZHECMpl2izkUD1ST3sKd5ZCGeKituCUL+nxJvOsXcwm381sy7vinEKkzVNf4HcU5zgUeoDBswDN55wUWjKMuNBXvt7nIp3ieSFRtYug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOwcguo5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOwcguo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0941F000E9;
	Thu, 27 Aug 2026 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853739;
	bh=K1wbypb0o9BEYWRfdYSV5+ycbu2AfP0lhqa8lvbpPSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOwcguo5ZX4W0L2D2KcCydCLYW7AHa7KOLEvIfYDEYvgbDAotmK3vfCbW36fUWf08
	 3jbeDA9UXw0TEzgj6PbWC/WoHmAfnxTdwryZHXmI7H9vnBxGEaIvsoIADo/dwH2bqn
	 bPHP2n4SZi6xVWsi+0rmPL5uy3IDOomvObg/VQ1noJP3oH92SHPW4f230G17GF2nNl
	 YGGUTGLh12Xy/Sa1pm/Ddvz2T3L0U8qmIpaB27rP2f9pmtl2VBpxTZrlGG4oh7jnzG
	 kJLzfKdwcrzxPPTGbmrUgCUnnaUKPIbaE23H8lTY3CwYVxQmxK/hq1k2021lWAf/l0
	 yXKn1nVXjlb7g==
From: Jakub Kicinski <kuba@kernel.org>
To: achender@kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: Re: [PATCH net v4 4/7] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
Date: Thu, 27 Aug 2026 11:02:18 -0700
Message-ID: <20260827180218.3950964-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824003759.127353-5-achender@kernel.org>
References: <20260824003759.127353-5-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown

This replaces the unconditional atomic_set(&cp->cp_state,
RDS_CONN_RESETTING) in rds_tcp_reset_callbacks() with two conditional
rds_conn_path_transition() attempts (CONNECTING -> RESETTING, and
RESETTING -> RESETTING), and drops the path with rds_conn_path_drop() if
neither succeeds.  The intent is to avoid stomping on a shutdown that is
already in flight.

> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index b263634ac750d..ad14217867a4d 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -150,9 +150,22 @@ void rds_tcp_reset_callbacks(struct socket *sock,
>  	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
>  	 * would not get set. As a result, we set c_state to
>  	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
> -	 * cannot mark rds_conn_path_up() in the window before lock_sock()
> +	 * cannot mark rds_conn_path_up() in the window before lock_sock().
> +	 *
> +	 * Only make that transition if the path is still connecting
> +	 * (or already resetting from an earlier duel).  A path in any
> +	 * other state - typically RDS_CONN_DISCONNECTING or
> +	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
> +	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
> +	 * and queues one more shutdown pass, but rds_conn_shutdown()
> +	 * accepts RDS_CONN_ERROR in its final transition to
> +	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
>  	 */
> -	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
> +	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
> +				      RDS_CONN_RESETTING) &&
> +	    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
> +				      RDS_CONN_RESETTING))
> +		rds_conn_path_drop(cp, 0);

[Severity: Medium]
Does this break the post-condition that the only caller of
rds_tcp_reset_callbacks() encodes?

Previously the unconditional atomic_set() guaranteed the path was left in
RDS_CONN_RESETTING.  Now, when neither transition succeeds,
rds_conn_path_drop() leaves cp_state at RDS_CONN_ERROR, and
rds_tcp_reset_callbacks() returns with the path in that state.

In rds_tcp_accept_one() the state check under t_conn_path_lock explicitly
admits RDS_CONN_ERROR:

net/rds/tcp_listen.c:rds_tcp_accept_one() {
	conn_state = rds_conn_path_state(cp);
	WARN_ON(conn_state == RDS_CONN_UP);
	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
		rds_conn_path_drop(cp, 0);
		goto rst_nsk;
	}
	...
	if (rs_tcp->t_sock) {
		/* Duelling SYN has been handled in rds_tcp_accept_one() */
		rds_tcp_reset_callbacks(new_sock, cp);
		/* rds_connect_path_complete() marks RDS_CONN_UP */
		rds_connect_path_complete(cp, RDS_CONN_RESETTING);
	}

So for a path found in RDS_CONN_ERROR with osock != NULL, both cmpxchg
attempts fail, the drop re-stamps RDS_CONN_ERROR, and the following
rds_connect_path_complete(cp, RDS_CONN_RESETTING) can never make its
RESETTING -> UP transition.

That lands in the failure path:

net/rds/threads.c:rds_connect_path_complete() {
	if (!rds_conn_path_transition(cp, curr, RDS_CONN_UP)) {
		printk(KERN_WARNING "%s: Cannot transition to state UP, "
				"current state is %d\n", __func__,
				atomic_read(&cp->cp_state));
		rds_conn_path_drop(cp, false);
		return;
	}

which is an unconditional, non-ratelimited KERN_WARNING plus another drop,
rather than bringing the freshly installed socket up.  The same mismatch is
reachable when a peer FIN/RST turns the state into RDS_CONN_ERROR via
rds_tcp_state_change() -> rds_conn_path_drop() between the accept-side check
and these two cmpxchgs, since nothing serializes cp_state against
t_conn_path_lock.

Should the hard-coded RDS_CONN_RESETTING argument in rds_tcp_accept_one() and
the "rds_connect_path_complete() marks RDS_CONN_UP" comment be updated, or
should rds_tcp_reset_callbacks() report which branch it took so the caller
can skip the complete step?

[Severity: High]
This isn't a bug introduced by this patch, but the newly added
rds_conn_path_drop(cp, 0) here queues one more cp_down_w pass on cp->cp_wq
while the accept worker is still inside rds_tcp_reset_callbacks() and about
to release osock.  Can that widen the existing double-teardown window on the
same struct socket?

rds_tcp_reset_callbacks() samples the socket at entry:

net/rds/tcp.c:rds_tcp_reset_callbacks() {
	struct socket *osock = tc->t_sock;

	if (!osock)
		goto newsock;

and later, after the drop, unconditionally tears it down:

	rds_tcp_restore_callbacks(osock, tc);
	release_sock(osock->sk);
	sock_release(osock);

The shutdown worker latches the same pointer and does the same teardown:

net/rds/tcp_connect.c:rds_tcp_conn_path_shutdown() {
	struct socket *sock = tc->t_sock;
	...
	lock_sock()/rds_tcp_restore_callbacks()/sock_release()

with a drain loop of up to ~5 s in between.  Neither path holds a common
lock: rds_conn_path_drop() and rds_conn_shutdown() do not take
t_conn_path_lock, and the transport shutdown runs outside cp_cm_lock, so both
can sock_release() the same socket.

The pre-existing part is the unsynchronized sampling of tc->t_sock at the top
of rds_tcp_reset_callbacks().  Checking the states in which the new drop
actually fires with osock != NULL, each already had a shutdown queued, in
flight, or completed (with tc->t_sock already cleared), so I could not
identify a state where this patch alone creates a teardown race that did not
exist before.

Also worth noting for the series ordering: later commits in this series close
the window structurally, "net/rds: acquire RDS_IN_XMIT in
rds_tcp_reset_callbacks()" reads tc->t_sock only while owning RDS_IN_XMIT,
and "net/rds: acquire the fastpath locks in rds_conn_shutdown()" holds
RDS_IN_XMIT across conn_path_shutdown().  At this commit the window is still
open, so a bisect landing here still carries it.  Would it make sense to
order those two commits before this one?
-- 
pw-bot: cr
