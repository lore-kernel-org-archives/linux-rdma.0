Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2CA331EB9;
	Wed,  9 Sep 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970033; cv=none; b=KU3xtqJW5rDeHjhGqMl8t85maiaXu1HYaY2ToH4xuwJV+yS1F27QU8G85ie0D6U1s3vCZV6CQ3zZH2+E6Nas/FF3IITrnYeH/QpgXwM1BYJ264+HHecFAHkKswBt4GCzvH2dOFBVzDeeBzm80+M8m9Dg6sTNTtqB33n/oqP0K2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970033; c=relaxed/simple;
	bh=chkZXiKbmRUxmJLFCqdgiCv0uwoikp1MINdnSfGtSLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3DViH9z/9thyaZyU3g7U0Kix4WeE/olNQYVGi3QWu28MKzRRDFhHcHW2lfBUva1YkDj6b9MF+VW7OLVAZGwBINKsXPQ0+q1Ho+l3LuzV4Zxp+pG6OaB817/QewJ92X3TAwb5ctK1H5DtiWJqWbOLkdvNSNFjobks5ktdxQ4mU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QHkWkn3V; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QHkWkn3V"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788970023; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=tEiGMgkz1gfUIAip5YKwtlSoH3nUyI3YdbxlmBU5qEE=;
	b=QHkWkn3VOdceJznPpf/Fq5GscbFeMQwBW/4F+smJZuqJV2AvaWjQo88O7Y9uQB44qDRKMmBax/iXdScxfOL1J6CKNPuQHviDHYyVE/A7yhpXIGIMSYR3Wq5uqPaaaFdkmr9oHnJQR1rJAC+eobCzjcMw68tTx0+O9Z3/i5aQ77Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAfGm61_1788970021;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XAfGm61_1788970021 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 00:07:02 +0800
Date: Thu, 10 Sep 2026 00:07:01 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, stable@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
Message-ID: <aqGEJRP_hZotdoNu@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
 <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
 <apbMyLc0IhLMKwwA@linux.alibaba.com>
 <85fa9f02-7516-4595-b5a8-4ae4ca845121@linux.ibm.com>
 <apgTu9dRGIQE6tm3@linux.alibaba.com>
 <899816c9-c908-4d64-8f5c-ba35619f78f2@linux.ibm.com>
 <apriDec7yHBkQgNv@linux.alibaba.com>
 <3803428a-2edc-4a5c-88e8-025f2f3322f4@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3803428a-2edc-4a5c-88e8-025f2f3322f4@linux.ibm.com>

On 2026-09-08 21:53:14, Hidayath Khan wrote:
>
>On 04/09/26 8:51 pm, Dust Li wrote:
>> On 2026-09-03 13:26:30, Mahanta Jambigi wrote:
>> > On 02/09/26 5:46 pm, Dust Li wrote:
>> > > I think we can close this window by holding the SMC hash table lock in
>> > > smcr_link_clear()? [...]
>> > Hi Dust,
>> > 
>> > After debugging further, I believe that __smcr_link_clear() cannot be
>> > called from smc_switch_link_and_count() because
>> > refcount_dec_and_test(&lnk->refcnt) is always false on that path — the
>> > initial ref (set in smcr_link_init(), released only in
>> > smcr_link_clear()) is always held while the switch executes. So there is
>> > no UAF from that path. The only consequence is that the diag reader may
>> > observe a stale conn->lnk pointer value — pointing to the old link which
>> > is still fully live — and read the old link's ibport/link_id/ibname from it.
>> Hi Mahanta,
>> 
>> Sorry for the late reply. I've done some more thinking on this topic.
>> 
>> That's true, but strictly I think there is still a small gap. The old link is
>> memset later, in smcr_link_clear() after all connections have migrated, so a
>> reader that loaded conn->lnk just before its own connection was switched has a
>> few-instruction window before it dereferences. In practice this window is
>> really narrow: the clear path runs the whole switch + LLC + QP teardown, orders
>> of magnitude longer than the reader's load+deref.
>> 
>> > The real UAF is via smc_conn_free(): it drops both the connection-owned
>> > conn->lnk reference via smcr_link_put() and the connection-owned
>> > conn->lgr reference via smc_lgr_put(), while the socket is still visible
>> > in the hash table. [...] The current patch tries to fix this using
>> > lgr_lnk_lock. Since you suggested we fix it with *unhash-before-free*, I
>> > thought about it and here is my proposal.
>> > 
>> > Proposed fix (high level):
>> > 
>> > Introduce a smc_conn_unhash() helper with a per-connection unhashed flag
>> > that ensures the socket is removed from the hash table exactly once.
>> > Call it at the top of smc_conn_free(), before any lgr/lnk references are
>> > dropped.
>> > 
>> > This establishes the invariant: any socket still visible to the diag
>> > reader under read_lock(hash->lock) has valid conn->lgr and conn->lnk
>> > pointers. [...]
>> > 
>> > Does this design look reasonable to you?
>> Yes, I think it's the right fix and we can go ahead and fix it this way first.
>> 
>> > There is a separate minor issue — smc_switch_link_and_count() updates
>> > conn->lnk under send_lock while the diag reader loads it without any
>> > lock, which can cause stale ibport/link_id/ibname in *smcss -R* during a
>> > failover event. This is a data race but not a safety issue since the
>> > link struct is always live at that point.
>> > 
>> > This race is very rare in practice [...] Even when it occurs, the effect
>> > is transient: one dump may show the old link's ibport/link_id/ibname, and
>> > the next dump will show the correct values.
>> I think this is acceptable.
>> 
>> ---
>> 
>> I've been re-thinking this a bit more. We've been plagued by SMC's tangled
>> locks and ad-hoc lifetime handling for years — every fix adds another lock or
>> another ordering rule. I think it's time to step back and refactor this area as
>> a whole, and set up some rules for how we use locks/refcounts in SMC, instead of
>> keeping patching individual races. Below are some rough thoughts.
>> 
>> 1. Object layering
>> 
>> SMC really has three lifetime tiers, and the top one has to be split the way
>> TCP splits struct socket from struct sock:
>> 
>> - the file (struct socket) — lifetime tied to fput;
>> - the connection sock (smc_sock, with conn embedded) — lifetime tied to
>>    sk_refcnt; like a TCP sock it can be orphaned and outlive the file. On an
>>    active close, close(fd) orphans it first, but it stays alive — still bound to
>>    the transport — to finish the close handshake;
>> - the shared transport (lgr / link / device) — lifetime by refcount, multiplexed
>>    across connections.
>> 
>> It's the socket/sock split, plus one more tier because our transport is shared
>> (TCP's sock is 1:1, our lgr/link is not). Today smc_conn_free() mixes all three
>> and is called from the transport layer while the socket is still hashed —
>> that's exactly where these races come from.
>> 
>> With the tiers separated, teardown becomes two independent, idempotent steps
>> rather than one:
>> 
>> - orphan (file <-> sock): at fput, via sock_orphan();
>> - transport-detach (sock <-> transport): the connection drops its lgr/link
>>    refs. On an active close this happens later, after the handshake completes;
>>    on a transport fault it happens immediately.
>> 
>> The sock is freed only once it is orphaned, transport-detached, and the last
>> sock_put lands; the order of the two steps just depends on who initiates
>> teardown (app close vs. transport fault).
>> 
>> 2. Lifetime & boundary contract
>> 
>> Give each tier the right tool, and a clear boundary between them:
>> 
>> - ownership by kref; traversal by RCU (conn->lgr / conn->lnk become RCU
>>    pointers, the lgr is freed with kfree_rcu); fd-visible objects (clcsock)
>>    released only after the last fput; and no in-place mutation of a published
>>    object (stop memset()ing a link — mark it dead and reclaim it with the lgr
>>    after a grace period);
>> 
>> - boundary rule: on a transport fault the lower layer only signals and
>>    transport-detaches; it never orphans, unhashes, or frees the sock.
>>    - signal = wake the app with an error (sk_err + wakeup);
>>    - transport-detach = publish rcu_assign_pointer(conn->lgr/lnk, NULL), then
>>      drop the usage references (smc_lgr_put / smcr_link_put). The transport
>>      object itself is reclaimed later by its own refcount + kfree_rcu; the sock
>>      is left untouched.
>>    Handle-side teardown (orphan, unhash, clcsock release, final sock_put)
>>    belongs to the connection/file side and is driven by close — never by the
>>    transport layer.
>> 
>> With that, a diag reader under rcu_read_lock is guaranteed the link/lgr
>> outlives its critical section, so the per-connection lgr_lnk_lock is no longer
>> needed and smc_conn_unhash() can be retired too. (clcsock_release_lock goes
>> away separately, via the clcsock lifetime series.) It's a larger, mostly
>> mechanical change and would take a lot of careful rework, so I'd do it as a
>> follow-up. Your smc_conn_unhash() is the right fix to take now (and for
>> stable); the rework, if we agree on this direction, would retire it afterwards.
>Hi Dust,
>
>Thanks for writing this up and for the pointer from my abort_work patch.
>
>You describe three tiers, with lgr, link and device as the transport one.
>I was not sure where the buffer descriptor fits. It does not seem to
>follow the lgr: smc_buf_unuse() returns conn->rmb_desc to lgr->rmbs, and
>smc_buf_get_slot() can then hand it to another connection while the lgr is
>still alive.
>
>Two places look like they can outlive it:
>
>- a splice reader still holding pipe pages, since smc_buf_unuse() does not
>  consult conn->splice_pending;
>
>- smc_cdc_msg_recv_action() and smc_cdc_handle_urg_data_arrival(), which
>  read conn->rmb_desc after smc_cdc_rx_handler() has already left
>  conns_lock. On the is_reg_err path smcr_buf_unuse() frees the
>  descriptor rather than recycling it.
>
>Have you already considered the descriptor in this model? Would it need
>its own kref, or is it meant to sit inside the transport tier? I may be
>missing something here.

Hi Hidayath,

I didn't think much about the descriptor before and thanks for point this out.
In this model, it belongs to the transport tier (it lives in the lgr buffer
pool, multiplexed across connections), and the conn->rmb_desc / sndbuf_desc
binding is a usage reference just like conn->lnk.

So buf_desc should get a kref: the pool holds one reference for existence,
and every user holds one -- the bound connection, each outstanding splice
pipe buffer, and an in-flight rx reader. A descriptor may return to the
pool (->used cleared, eligible to be re-handed by smc_buf_get_slot()) only
once *all* of them are dropped, not just when the owning conn detaches --
otherwise a lingering reader sees zeroed or another connection's data,
since the same memory gets recycled.

That should cover your two cases:

- splice: get_page() pins the physical page, but nothing stops
  smc_buf_unuse() from zeroing the buffer and returning the slot to the
  pool while a pipe still references it (and it never consults
  splice_pending). With the kref, each splice pipe buffer holds a
  reference, so the slot is recycled only after the last page is
  released.

- rx after conns_lock: the receive action reads conn->rmb_desc holding
  only a sock reference, racing smc_conn_free() -> smc_buf_unuse() (and
  on the is_reg_err path smcr_buf_unuse() frees the descriptor outright).
  Making conn->rmb_desc an RCU pointer, read under rcu_read_lock in the
  receive path, closes this: a late reader either sees NULL (detached) or
  a descriptor that outlives its read-side section.

>
>One smaller question, on the boundary rule. The SMC-D side already looks
>close to what you describe: smcd_handle_irq() holds smcd->lock across both
>the lookup and the tasklet_schedule(), and smc_ism_unset_conn() clears the
>slot under the same lock. The SMC-R receive path drops conns_lock between
>the lookup and the action. Is that difference something the refactor
>would make uniform, or is there a reason the receive path cannot hold the
>lock that long?

There is a real reason they differ today: SMC-R does the receive inline in
the completion softirq, and holding conns_lock (a bh rwlock) across that
would invert against the teardown/migration paths that take it for write
under lock_sock. SMC-D only schedules a tasklet under smcd->lock, which is
cheap, and defers the work.

But I'd rather not unify them by holding a lock longer -- that is the same
"use a lock for lifetime" pattern I'd like to move away from. The refactor
unifies the mechanism instead: both sides bridge the lookup -> action gap
with a reference + RCU, not with a lock or a drain.

For SMC-D the tasklet is the subtle part. RCU does not span the tasklet
boundary: smcd_handle_irq()'s read-side section ends when the IRQ returns,
and the tasklet runs later, possibly after a grace period. So a reference,
not RCU, has to carry the connection across that gap:

- smcd_handle_irq() takes a sock reference under smcd->lock before
  tasklet_schedule(), and the tasklet drops it at the end -- exactly
  what the SMC-R rx handler already does;
- the tasklet reads conn->rmb_desc under its own rcu_read_lock();
- smcd->lock stays as the state lock for the dmbno -> conn slot table,
  and smc_ism_unset_conn() keeps clearing the slot, but its job becomes
  "stop scheduling new work" rather than "keep the tasklet off freed
  memory";

So yes, the refactor makes the two uniform -- through references + RCU,
not by extending conns_lock.

More generally, the discipline I'd like us to adopt: don't use locks (or
drains, or ad-hoc flags) to manage object lifetime -- use a kref for ownership
plus RCU for traversal. A lock only covers the paths that remember to take it,
so it always leaves one uncovered; a reference + RCU makes "can't be reclaimed
while observed" structural.


>
>If it would be useful, I can write up the lifetime assumptions I have run
>into while working through the teardown paths. Please tell me if that
>helps, or if it would only repeat what you already have.

Please do -- I'd frame it as stress-testing the model rather than just
documenting it. buf_desc is exactly the kind of gap I want to shake out
before we commit to this direction: an object my write-up missed, which
you found by walking the teardown paths. So it wouldn't be a repeat of
what I have.

Best regards,
Dust
