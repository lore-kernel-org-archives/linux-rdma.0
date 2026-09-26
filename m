Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3083DCD95;
	Sat, 26 Sep 2026 09:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416124; cv=none; b=RNHvqNvgYdUYCsLPOjp8qEIrPV48/NddsXCwW5ajoEw4B6tqLtdk8LTcKXx3HNS+b0aKnQpJl+dTMtVaRzPM0LYdj9qCD/NUhlGObOKznDNEWav/69Z4R5OxMnMxJ/BuDXHjXAF2h8+1tU9yG5fZskri30mx+GTT+N0sprDA3IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416124; c=relaxed/simple;
	bh=HweD/CT7s/as05jMfjeZPzTpwucWVzYI2blMLyiaw5k=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GSd7CrL7RDgpBDr13CTT3UeGgqxq6aQKpXs8KpyLJiE1Kw/Byvs1nWTz/t6vDrwTJ1bj50kqOpUrs7tVIx2bW1iZFbMiHI1P3v7oVIrNe+7rYKrTfAnQlXE87oUkc0HJ9ehEeqjbC9n/pj9rrmCjunnT0sP61YFjm1R/33LjKZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsMvta0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsMvta0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113431F000FF;
	Sat, 26 Sep 2026 09:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416121;
	bh=5KgCThszD/rdWj3/PZl/YxosJPQfy0jV1GjYqv/JxAI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bsMvta0J9hBZtwTihLUXmVWcf5C9pNOHv56ITayj5pqo7K8x6V7qXQubrLPZ9dzHU
	 2XrgpCs+xSP2jB5aTqpNUBy8fTBLFWKJCnFZq9nUERLqHRGzAg5DjAckgl35zgRvYo
	 dJ21CHMM4Omxpv7nJxzLTVcOTUqDyb3kq66jANih4sen0l16HCWKou381rRSUjEw78
	 /4KoeRutkcwrSFgLzPZqm8WKUfeub+D2KMWmlwvy1D3i2Z3q0kD1LpR7k/Lffu2/lQ
	 bDe+WUiXhYHB1tGmGgJ5YzV/WwtBrhi+zQw5d6ntzv5Zr+KDI1jYg9WQ4TRyI1GRNz
	 4eGSNI8I0W8Sg==
Subject: Re: [PATCH net-next v6 07/12] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:40 +0000
Message-ID: <179041612062.2160803.18299462555335020383@kernel.org>
In-Reply-To: <20260922085410.391323-8-achender@kernel.org>
References: <20260922085410.391323-8-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Stale/unreachable justification for the new per-connection
  reference in rds_ib_destroy_nodev_conns(): both the commit message ("A…

--

net/rds: unlink transport nodes before a possibly deferred connection free

The RDS transport teardown helpers now unlink each per-connection
transport node under the transport lock right before calling
rds_conn_destroy(), so a conn_free() that runs after the helper has
returned does not touch a list head on a dead stack frame.  IB gets an
explicit i_ib_node_detached flag, and the gather loops take a reference
on each connection they move onto the stack list.

> The walk itself must not lose the entries either.  A connection that
> was destroyed earlier - dropped for a protocol version mismatch, then
> found again at module unload - is kept alive only by whatever
> reference is still pending, and that can be dropped at any point
> during the walk, freeing the transport node the iterator is about to
> read.

[Severity: Low]
Is this scenario reachable in this tree?  A grep for rds_conn_destroy()
callers at this commit finds only the five teardown helpers:

  net/rds/ib_rdma.c:  rds_ib_destroy_nodev_conns()
  net/rds/loop.c:     rds_loop_destroy_gathered_conns()
  net/rds/tcp.c:      rds_tcp_destroy_gathered_conns()

There is no protocol-version-mismatch caller of rds_conn_destroy() any
more - net/rds/ib_cm.c has none, that path was converted to
rds_conn_drop() upstream by f97d8c7bab78 - so a connection cannot have
been "destroyed earlier ... for a protocol version mismatch".

The same commit message also says two paragraphs earlier:

> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.

and the sibling patch "net/rds: make rds_destroy_pending() report a
connection's own destroy" states that "Today every rds_conn_destroy()
does happen on one of those two global paths".

Could this paragraph be reworded to say that the reference is
preparation for the later patches that hand out references, rather than
describing a use-after-free that exists today?  As written, and with no
Fixes: tag, it reads like a fix for a live bug.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index a9b27f06cbfcf..1548e5be0e559 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c

[ ... ]

> @@ -163,13 +173,40 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
>  
> -	/* avoid calling conn_destroy with irqs off */
> +	struct rds_connection *conn;
> +
> +	/* Gather the connections and take a reference on each, so that
> +	 * none is freed under the walk below (a connection destroyed
> +	 * earlier, for a protocol version mismatch, can be on this list
> +	 * with only a socket's reference still pending).  One whose free

[Severity: Low]
The same claim is repeated here in the comment on
rds_ib_destroy_nodev_conns(), so the stale justification ends up in the
source tree and stays there through the rest of the series.  Since
nothing calls rds_conn_destroy() for a protocol version mismatch, and
rds_ib_destroy_nodev_conns() is only reached from rds_ib_exit() and its
resweep, is there a caller that can drop a pending reference under this
walk today?

Would it be clearer to describe the rds_conn_get_unless_zero() here as
guarding against the deferred frees introduced later in the series?

> +	 * is already running gets no reference: its free unlinks the
> +	 * node itself, under this lock, once we drop it.  Marking the
> +	 * node detached claims it for this sweep: rds_ib_add_conn(),
> +	 * rds_ib_remove_conn() and rds_ib_conn_free() leave a claimed
> +	 * node alone, so the walk over tmp_list below needs no lock.
> +	 * Avoid calling conn_destroy with irqs off.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice_init(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn)) {
> +			ic->i_ib_node_detached = true;
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +		}
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> -		rds_conn_destroy(ic->conn);
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that would unlink
> +	 * ib_node.  tmp_list lives on this stack frame, so take each node
> +	 * off it before its destroy; the free then leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		conn = ic->conn;
> +		list_del_init(&ic->ib_node);
> +
> +		rds_conn_destroy(conn);
> +		rds_conn_put(conn);
> +	}
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
