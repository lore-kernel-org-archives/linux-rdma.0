Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447118;
	b=vHibIXxaXITKRybpOn0r3tz3T2T05ejQaLAvhucWSMl7P5oRe75AP9IACufkJu32oZax
	 AdDuAV3LNByf+Gtq9Yl7EUv6CZqvP70vjXurkJAsyP+DgmqXrAxQE5yRheDE/oppm5kGV
	 4z40pUnzQeDw6D+6xKNY83E1Wyk8OeTwGmdNIWMG0Hw90rT8/WCssAKpiLphpLLLVPbfa
	 zsQi/CVir79R1clpwhY2TuMasmVTkaz4zZLioDeZSG/MQie21xA9Qn6b2AHotu6y9C99N
	 OVoHqUeQWrytx9iVYUaMS0rwyfrDs5kTd37pGZ/ztYYPzJjhNvB21PhUr6wlmNzYyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447118;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ho9Ya05Yxv9ks4i3cFO1nLqipR63Ysn/hvmfNWZJXu0=;
	b=kwuP/3EH6cNSz0yQQ3lwyk3skWBHQivIWGkZVJVgndKMP9Epuz9KpQn1vFzHzOpz+XK5
	 hKky2kS3E09HNjVw+jaA69gevdwzmpZAKxzCS/uJKKVtQahPaUndX4lDDYsM5INDDyjf3
	 sHxbBP2Lp34VqMSwHXfZDLYi5iFiCGaCC+4tUzoTkTWYNSeL2cCpz8XEGKembpoPqVuP7
	 XVE2pc8bv1Pnu8B/7mySiV4eP/GkbuuLlFDybF/UsQuycF49cAm0sah74gh2GPj8d5Erc
	 pZBpI/kGcUumVSiq46onkrUXYOQZ98/gRifn0MrSNS+Xn7DmKy5oVVvbOZeOuSBMmhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=HIVpieVa;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D596606A326;
	Thu, 12 Nov 2026 01:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D596606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=HIVpieVa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=HIVpieVauUWFaW6pVPFC7iw5veocBsAazJU1DodbIMXsZsDZGqnychlVkIdsBjQ13BHR6cj2COVlO
	 tCZclnzQ0NSEFosnd2Teh+sQo0m7IstwjO4dFEBfSjaaox8B4t8IXatGbis9/AB20uV39PDeytkcDt
	 ybd62LeJZrHyttXg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46af5170a7d3-7b768;
	Thu, 12 Nov 2026 09:31:56 +0800 (CST)
X-RM-TRANSID:2ee46af5170a7d3-7b768
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from cmss.chinamobile.com (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86af5170ae3c-ed13d;
	Thu, 12 Nov 2026 09:31:55 +0800 (CST)
X-RM-TRANSID:2ee86af5170ae3c-ed13d
From: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with its new context
Date: Thu, 12 Nov 2026 09:31:00 +0800
Message-ID: <20261112-ucma-conn-req-ctx-reply-1-yuehongwu@cmss.chinamobile.com>
In-Reply-To: <20261111133810.GS8635@unreal>
References: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com> <20261111133810.GS8635@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit

Leon,

sorry for the unclear comment. The context is created and queued in the
same function, unconditionally, that part is not in dispute. What the
comment was trying to say is that the uevent and the new context have
independent lifetimes: the event is queued on the listener's file and
stays there until user space asks for it, while the new context is live
in ctx_table from one statement earlier and can be destroyed in between.

Here is the chain for the queueing side, ucma_connect_event_handler()
(inlined into ucma_event_handler()):

  cma_ib_req_handler()
    cma_cm_event_handler()
      ucma_event_handler()
        ucma_connect_event_handler()
          atomic_add_unless(&listen_ctx->backlog, -1, 0)
          ctx = ucma_alloc_ctx(listen_ctx->file)
                  xa_alloc(&ctx_table, &ctx->id, NULL, ...)   id reserved, value NULL
          uevent = ucma_create_uevent(listen_ctx, event)
                  uevent->ctx = listen_ctx
          uevent->conn_req_ctx = ctx
          uevent->resp.id = ctx->id
          mutex_lock(&ctx->file->mut)
          ucma_finish_ctx(ctx)
                  xa_store(&ctx_table, ctx->id, ctx, ...)     id becomes live
          list_add_tail(&uevent->list, &ctx->file->event_list)
          mutex_unlock(&ctx->file->mut)
          wake_up_interruptible(&ctx->file->poll_wait)

So two separate things happen here. The new context is live in
ctx_table before the event is queued, and delivery to user space is a
separate step that only happens when user space calls get_event; poll()
just reports a non-empty queue and returns no id. The event does not take
a reference on the new context, so nothing ties the context's lifetime to
the event's.

Note that both statements are under file->mut, but that only serialises
the event list, not the id table: DESTROY_ID takes the id out of
ctx_table under xa_lock and only then needs file->mut, in
ucma_cleanup_ctx_events(). So it either blocks until the event has been
queued or finds it already queued; either way the event is on the list
when the cleanup runs, and gets skipped.

The destroy side is ucma_destroy_id():

  ucma_destroy_id()
    _ucma_find_context(cmd.id, file)            xa_load, ctx->file == file
    __xa_cmpxchg(&ctx_table, ctx->id, ctx, XA_ZERO_ENTRY)
    ucma_destroy_private_ctx(ctx)
      ucma_close_id() -> rdma_destroy_id(ctx->cm_id)
      ucma_cleanup_ctx_events(ctx)
        mutex_lock(&ctx->file->mut)             the same file as the listener
        uevent->ctx != ctx -> continue          the event is skipped here
      kfree(ctx)

And later, when the listener goes away (DESTROY_ID on the listening id,
or close() of its file, which walks ctx_list):

  ucma_cleanup_ctx_events(listen_ctx)
    uevent->ctx == listen_ctx, event == RDMA_CM_EVENT_CONNECT_REQUEST
    xa_cmpxchg(&ctx_table, uevent->conn_req_ctx->id, ...)
                            ^^^^^^^^^^^^^^^^^^^^^^^^^ read of freed memory

That is the slab-use-after-free. The id is not handed to user space
before get_event, but it is predictable: xa_alloc() hands out the lowest
free id, the table is global, and DESTROY_ID only requires the id to
belong to the same ucma file, so a process can destroy the context while
the event is still queued. My reproducer does exactly that: it uses an
rxe device, queues a CONNECT_REQUEST, sees the queue is readable without
fetching it, tries the small ids of its own file, destroys the new one
and then the listener.

The window is not a race, it is a stable state, and get_event cannot race
with it either: ucma_get_event() copies the response and does list_del()
under file->mut before dropping it, so once the event has been fetched
the destroy path can no longer see it. The reason it has to be handled at
all is that the id is gone; the event can then never be acted upon, and
leaving it queued makes the listener's cleanup dereference freed memory.

Commit 8ae291cc95e4 replaced

        if (uevent->ctx == ctx || uevent->conn_req_ctx == ctx)

with a plain "uevent->ctx != ctx", which lost the case where the context
being destroyed is the new one; before that commit the event was moved
out and freed. The patch restores that behaviour without restoring the condition itself
(that would destroy the context a second time): a new branch under the
"uevent->ctx != ctx" test drops the event, so the xa_cmpxchg() path added
by 8ae291cc95e4 is unchanged.  It also returns the backlog slot consumed
in ucma_connect_event_handler(), which the old code leaked.

One note on scope: this only covers the same-file case. ucma_migrate_id()
moves queued events only when uevent->ctx == ctx, so moving the new
context away leaves the event on the listener's file, and moving the
listener takes the event along but leaves the connection context behind.
Both cross-file cases predate 8ae291cc95e4 and are left for a separate
fix.

(For the KASAN report in the changelog: ucma_connect_event_handler() is
inlined into ucma_event_handler() and ucma_cleanup_ctx_events() into
ucma_destroy_private_ctx(), which is why the stacks show those names.)

I will follow up with a v2 that rewrites that comment; the code is
unchanged.

Thanks,
Yuehong



