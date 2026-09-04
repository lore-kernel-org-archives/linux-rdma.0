Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CC0474247;
	Fri,  4 Sep 2026 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535318; cv=none; b=MOX7wCZx9ryV3L8l4GZsdMg4aNzu0+84hFcvUZMSm16VzphMpJDIrtVJoh42sjPJ+8B3oY0RLxS8deZRwFD/ZBtlVOzv6C8zFQhrAUXXocSsIjOAJfK5X3yuezcQ1LL+/xXr5x29Mzh4nPKwVW4iHIpXX/htT1iyJiqI4v6mJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535318; c=relaxed/simple;
	bh=PJ/iaFn65SbkWEpJ+KcHytetjVJYyvroM9gBmN3nDXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3KSScUfgNgS2bL43+7OuK4xuI4M9mzW0EZRy/CZhXKbQ1KLdeSjKKVHrke8KlZbL4r5jD4LS25FIRVzpiLK1+R8m+VlCaezZdNFfnokg5zPrAnvddrOm1XqyX/kg54mgk/+DH1okSBMLxSrZU0mdhife9Y+D9rfsVUnR3FGNvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=O5fVMovz; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="O5fVMovz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788535310; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=j9m5ViHj7Wr5tcjqUghEvku+z8E9B+JmWiAOPmmoD3g=;
	b=O5fVMovzXr8OsEtQ/AC9hTWRqOaPsNNxhfM5sj0x3qs3nwrsowuuFhDjAHGlGSu17bRQDVhC4P3xg4Lyqjcl0U3mxI3XzlHCeUYsgC6IUaX5N5Nv6a0QyP2He0cLEyOSAed2J9b0lvoMDDT9b6WqWRcUbD1PHtCddGERQqHMm8w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAJ1SQ-_1788535309;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XAJ1SQ-_1788535309 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 23:21:50 +0800
Date: Fri, 4 Sep 2026 23:21:49 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, stable@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
Message-ID: <apriDec7yHBkQgNv@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
 <apbMyLc0IhLMKwwA@linux.alibaba.com>
 <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
 <apgTu9dRGIQE6tm3@linux.alibaba.com>
 <899816c9-c908-4d64-8f5c-ba35619f78f2@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <899816c9-c908-4d64-8f5c-ba35619f78f2@linux.ibm.com>

On 2026-09-03 13:26:30, Mahanta Jambigi wrote:
> On 02/09/26 5:46 pm, Dust Li wrote:
> > I think we can close this window by holding the SMC hash table lock in
> > smcr_link_clear()? [...]
>
> Hi Dust,
>
> After debugging further, I believe that __smcr_link_clear() cannot be
> called from smc_switch_link_and_count() because
> refcount_dec_and_test(&lnk->refcnt) is always false on that path — the
> initial ref (set in smcr_link_init(), released only in
> smcr_link_clear()) is always held while the switch executes. So there is
> no UAF from that path. The only consequence is that the diag reader may
> observe a stale conn->lnk pointer value — pointing to the old link which
> is still fully live — and read the old link's ibport/link_id/ibname from it.

Hi Mahanta,

Sorry for the late reply. I've done some more thinking on this topic.

That's true, but strictly I think there is still a small gap. The old link is
memset later, in smcr_link_clear() after all connections have migrated, so a
reader that loaded conn->lnk just before its own connection was switched has a
few-instruction window before it dereferences. In practice this window is
really narrow: the clear path runs the whole switch + LLC + QP teardown, orders
of magnitude longer than the reader's load+deref.

> The real UAF is via smc_conn_free(): it drops both the connection-owned
> conn->lnk reference via smcr_link_put() and the connection-owned
> conn->lgr reference via smc_lgr_put(), while the socket is still visible
> in the hash table. [...] The current patch tries to fix this using
> lgr_lnk_lock. Since you suggested we fix it with *unhash-before-free*, I
> thought about it and here is my proposal.
>
> Proposed fix (high level):
>
> Introduce a smc_conn_unhash() helper with a per-connection unhashed flag
> that ensures the socket is removed from the hash table exactly once.
> Call it at the top of smc_conn_free(), before any lgr/lnk references are
> dropped.
>
> This establishes the invariant: any socket still visible to the diag
> reader under read_lock(hash->lock) has valid conn->lgr and conn->lnk
> pointers. [...]
>
> Does this design look reasonable to you?

Yes, I think it's the right fix and we can go ahead and fix it this way first.

> There is a separate minor issue — smc_switch_link_and_count() updates
> conn->lnk under send_lock while the diag reader loads it without any
> lock, which can cause stale ibport/link_id/ibname in *smcss -R* during a
> failover event. This is a data race but not a safety issue since the
> link struct is always live at that point.
>
> This race is very rare in practice [...] Even when it occurs, the effect
> is transient: one dump may show the old link's ibport/link_id/ibname, and
> the next dump will show the correct values.

I think this is acceptable.

---

I've been re-thinking this a bit more. We've been plagued by SMC's tangled
locks and ad-hoc lifetime handling for years — every fix adds another lock or
another ordering rule. I think it's time to step back and refactor this area as
a whole, and set up some rules for how we use locks/refcounts in SMC, instead of
keeping patching individual races. Below are some rough thoughts.

1. Object layering

SMC really has three lifetime tiers, and the top one has to be split the way
TCP splits struct socket from struct sock:

- the file (struct socket) — lifetime tied to fput;
- the connection sock (smc_sock, with conn embedded) — lifetime tied to
  sk_refcnt; like a TCP sock it can be orphaned and outlive the file. On an
  active close, close(fd) orphans it first, but it stays alive — still bound to
  the transport — to finish the close handshake;
- the shared transport (lgr / link / device) — lifetime by refcount, multiplexed
  across connections.

It's the socket/sock split, plus one more tier because our transport is shared
(TCP's sock is 1:1, our lgr/link is not). Today smc_conn_free() mixes all three
and is called from the transport layer while the socket is still hashed —
that's exactly where these races come from.

With the tiers separated, teardown becomes two independent, idempotent steps
rather than one:

- orphan (file <-> sock): at fput, via sock_orphan();
- transport-detach (sock <-> transport): the connection drops its lgr/link
  refs. On an active close this happens later, after the handshake completes;
  on a transport fault it happens immediately.

The sock is freed only once it is orphaned, transport-detached, and the last
sock_put lands; the order of the two steps just depends on who initiates
teardown (app close vs. transport fault).

2. Lifetime & boundary contract

Give each tier the right tool, and a clear boundary between them:

- ownership by kref; traversal by RCU (conn->lgr / conn->lnk become RCU
  pointers, the lgr is freed with kfree_rcu); fd-visible objects (clcsock)
  released only after the last fput; and no in-place mutation of a published
  object (stop memset()ing a link — mark it dead and reclaim it with the lgr
  after a grace period);

- boundary rule: on a transport fault the lower layer only signals and
  transport-detaches; it never orphans, unhashes, or frees the sock.
  - signal = wake the app with an error (sk_err + wakeup);
  - transport-detach = publish rcu_assign_pointer(conn->lgr/lnk, NULL), then
    drop the usage references (smc_lgr_put / smcr_link_put). The transport
    object itself is reclaimed later by its own refcount + kfree_rcu; the sock
    is left untouched.
  Handle-side teardown (orphan, unhash, clcsock release, final sock_put)
  belongs to the connection/file side and is driven by close — never by the
  transport layer.

With that, a diag reader under rcu_read_lock is guaranteed the link/lgr
outlives its critical section, so the per-connection lgr_lnk_lock is no longer
needed and smc_conn_unhash() can be retired too. (clcsock_release_lock goes
away separately, via the clcsock lifetime series.) It's a larger, mostly
mechanical change and would take a lot of careful rework, so I'd do it as a
follow-up. Your smc_conn_unhash() is the right fix to take now (and for
stable); the rework, if we agree on this direction, would retire it afterwards.

Best regards,
Dust
