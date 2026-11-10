Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794319076;
	b=P1jaIxpxY+Pf3QOq7qMS2f5JAVKXYeCcoPQVVjlpKNP/nml2kfoKjGuL4eLpYJucBgy5
	 7PwfmLmOaotBoA79nLRPFH+4sviwE0t/09dUVPS243BUWm7UBkkaal/0N/wjDhaopZxzl
	 RQj3soU5mcIgDmqJLHa44VnRCOgr2WTHpUyXlhWRrO0fmvb1Acj/YyoEZeYJa2CLaVJK4
	 Lpe3yR5m4W1Zd1Pgp10xBzLXgIfAkOsAKlljHG5ejBW/KleANExTtAafU20+cqA9h6Kma
	 QwYwf5bUNP6YL2UcatPSZuCxpIfOxVM4BgP17dvNI/uJRLeUsgncv5yG0VVVoFQCedg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319076;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=KZYzlwx+Tp8HX3h6UwJ31WqXAJ42qCy9VRYbHAt07pU=;
	b=48x7gxtKDacH2/0WrfJCBBKn0zY0cTpPlcMZIzs/SG6KAyLshumeGlKaHh1pwgb2i0mC
	 w1Dwb+m8N44c9mJX3XV7yP1f5G1DqHZjoJEJKwEXfiy/9t6aUT6WoUZI7sdFndoO0Lnv1
	 rWFb0vDy2rdO0AkfOQH7qS1o5DmA5eG+0jDDe8O4LsfkfzvCbRJGW3pE8NwjgQMjxo/yG
	 EG6H0JLxRLjucQlULVK/MbeS+LdWudak6xARJveogelC7UJzkC0GOqTf8VF3ihmHr5/Pb
	 LX3El0hIJjvZnLM5vwaXuUZvg7xGB3DITLRsguWWAfXYm837AjvNWWj08huW+vSBDiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1QwX7WY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC600606A333;
	Tue, 10 Nov 2026 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1QwX7WY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF5A1F0089F;
	Tue, 10 Nov 2026 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319075;
	bh=KZYzlwx+Tp8HX3h6UwJ31WqXAJ42qCy9VRYbHAt07pU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=k1QwX7WYwTixcNVgTaJJ5PEmIaPIu9MZ0r1nQqdtLpyTzozx2fSxNzt80TynkiJi9
	 PYJYD1Efms1Cw5gwNiwJ5b7x4nUV0k1PEIhkGRiaizHGj4oK4Fb8NsrCb70lv4TyjO
	 bdjziHpJZIkCyTzAtq+/YgY9rKxNVx56EI3nDfjVoKUopxvLrJI1U31B9bwAQb6eeo
	 T2neEjRGgIwhfnJT87EK031wV3Dexm/bPGuz7Ki2t2UTU+LshveS31UZH1Did9gndg
	 yrBxQ8WStcnILOmMCxiHWsxoFGQHkvOmkjzOu5IzyyvmtQYkmlwSuAkHgGfE9OXbp/
	 1+VoRCu/Pre4g==
Subject: Re: [PATCH net-next v11 11/12] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Tue, 10 Nov 2026 13:57:54 +0000
Message-ID: <179431907448.994134.16446113833625218243@kernel.org>
In-Reply-To: <20261106031615.1047052-12-achender@kernel.org>
References: <20261106031615.1047052-12-achender@kernel.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch adds a pin in rds_rdma_cm_event_handler_cmn()
  (net/rds/rdma_transport.c): `if (conn &&…

--

net/rds: pin the connection across RDMA-CM event handling

This patch has rds_rdma_cm_event_handler_cmn() take a reference on the
connection found in cm_id->context for each event it handles. If the
reference count is already zero, the event is ignored. It also adds
rds_destroy_pending() checks to rds_ib_cm_initiate_connect() and
rds_ib_cm_handle_connect(), so neither of them sets up a QP or a new
cm_id on a connection whose destroy has begun.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index 75532734c054b..03c21ce2324c9 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -60,6 +60,21 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
>  		 event->event, rdma_event_msg(event->event));
>  
> +	/* cm_id->context carries no reference of its own.  Pin the
> +	 * connection for the duration of the handler, since the mutex
> +	 * released at out: lives in the connection's path array.  None
> +	 * of the callbacks below drops a reference on this connection,
> +	 * and the shutdown destroys the cm_id - waiting for a running
> +	 * handler - before the last reference can go, so this is
> +	 * defensive.  A connection already at zero references gets no
> +	 * events handled.
> +	 */
> +	if (conn && !rds_conn_get_unless_zero(conn)) {
> +		rdsdebug("conn %p id %p is being freed, ignoring event\n",
> +			 conn, cm_id);
> +		return 0;
> +	}

[Severity: Medium]

Can this zero-reference check actually catch a connection that is going
away?

The conn pointer comes from cm_id->context, which owns no reference.
rds_ib_conn_path_connect() passes conn to rdma_create_id() without taking
a reference. rds_ib_cm_handle_connect() drops its own reference after it
sets cm_id->context.

The final put frees the memory straight away, with no grace period:

net/rds/connection.c:rds_conn_destroy_fini() {
    ...
	kfree(conn->c_path);
	kmem_cache_free(rds_conn_slab, conn);
    ...
}

The slab is also not SLAB_TYPESAFE_BY_RCU:

net/rds/connection.c:rds_conn_init() {
    ...
	rds_conn_slab = KMEM_CACHE(rds_connection, 0);
    ...
}

That means a zero count can only be seen inside rds_conn_destroy_fini(),
between the count reaching zero and the kmem_cache_free() call. After
that point, kref_get_unless_zero() reads conn->c_refcount from freed
memory.

If another rds_connection has already reused the slot, the get succeeds.
The handler would then take that connection's c_cm_lock and apply the
peer's ESTABLISHED, REJECTED, DISCONNECTED or error events to the wrong
connection.

I could not find a current path that frees the connection while its
cm_id can still deliver events. The shutdown pass calls rdma_destroy_id(),
which waits for a running handler, before the initial reference is
dropped. That matches what the commit message says. Still, memory safety
here depends entirely on that ordering. The later patches in the series
don't appear to change this: the handler and the synchronous
kmem_cache_free() are left as they are.

Given that, are the new comment ("A connection already at zero references
gets no events handled") and this part of the commit message accurate?

  "the pin is defensive, keeping the handler correct without leaning on
  that ordering."

If the goal is to stop depending on the destroy-before-free ordering,
would cm_id->context need to own a real reference, released when the
cm_id is destroyed? Another option would be RCU-deferred freeing, or
SLAB_TYPESAFE_BY_RCU with an identity re-check after the get, such as
ic->i_cm_id == cm_id.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106031615.1047052-1-achender%40kernel.org
