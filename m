Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C5A439F77;
	Mon, 21 Sep 2026 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979830; cv=none; b=YT8Q2tF4N/PXFFHml56t93isJszpoZr4s9YZa+dcPSfgLDuv4vY4MerbvXyRv1OV126sqHj4+EKlwJXQlastmhfARQ9INcZFxIEgtXcOIdGx4kcrJlFrBk6+kzVPpAo7ys6ZzEug7U9YSNYrvFhH9kF0VWZMPPu/DhxwkZvZgFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979830; c=relaxed/simple;
	bh=TcQzOZNfLDzV2zhe9f7FPc4PwujpqnLn4gLODXQtmqM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FfyHZa6B1Ta6v9WfN59wjJAmMyTpYEMI8tc2OOKKElveGR7WNCJBeVESAjHND6pgGa9x8Q9wwIrOZ5PtDKoTNv9B6eER+j+WsbVTeSlxyFGH9eIbUTVyEuD/GtKTFsAx2WyEX/v+7VykJ/ZOEFawe7jq3vP/kFupHMzRu49OPSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJCiDh6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJCiDh6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466C21F00893;
	Mon, 21 Sep 2026 08:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789979828;
	bh=94Mdz/CeYX3Wx0TJZ6lj43M5svcwKZtbvYAsbOTl5f4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JJCiDh6jWanW+wI0AzT+tgnTSRo0AvwpEiaKO7P3yuaNsi6vkSAVa2V6IRItFfziC
	 tK1wWmjnSCfgz3mWijDuHNfPxvkU06XaLY1++aUAXNszxCUmbNtlGleTH5qStVnwiz
	 7/jkgcbz1DRQMtTRMUvn4kgv+CmRjqVx+9d7GDYrwgIlPBpkgGxQyodFbP5aIjurAo
	 XWH1wPCYrc9OrPizARTzbzNdK6KVarVBpvAI+BhTS29VdddCZ/cg6iz2zIELNDCiOl
	 +FpO49mKN65puvQ2OCtGnkzwPYjhbMzatQTa6ooLMkZPu6CZvOyoKqSm0+AfFAN0tS
	 TNMfdhxfgdR1g==
Subject: Re: [PATCH net-next] net/rds: restrict the rdma_cm ids to IB devices
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 21 Sep 2026 08:37:07 +0000
Message-ID: <178997982782.2160803.16084252052230368942@kernel.org>
In-Reply-To: <20260917074108.174262-1-achender@kernel.org>
References: <20260917074108.174262-1-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message's closing paragraph — "With that, the
  connect-request rejection for non-IB devices in the event handler…
- [Low] The patch fixes a real, remotely reachable defect (RDS installing
  its rdma_cm listener on every RDMA device — including RDMA_NODE_RNIC…
- [Low] rds: memory leak of rdma_cm_id in rds_ib_conn_path_connect error
  path

--

net/rds: restrict the rdma_cm ids to IB devices

This restricts the three rdma_cm ids RDS creates (the listener, the
per-connection id, and the probe id in rds_ib_laddr_check_cm()) to
RDMA_NODE_IB_CA via rdma_restrict_node_type(), so the listener is only
installed on IB devices and address resolution can only pick one.

A couple of questions about the commit message and about what the handler
actually does today.

The message says:

    With that, the connect-request rejection for non-IB devices in the
    event handler becomes unreachable; it stays as the last line of
    defence and is what stable kernels without the new API rely on.

[Severity: High]
Is there actually a rejection in the event handler?  Looking at
rds_rdma_cm_event_handler_cmn() in net/rds/rdma_transport.c, trans is
declared without an initializer and only ever assigned on the IB path:

	struct rds_connection *conn = cm_id->context;
	struct rds_transport *trans;
	...
	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
		trans = &rds_ib_transport;

There is no else arm, and no error return.  The switch then dereferences
trans unconditionally:

	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);

with the same pattern for trans->cm_initiate_connect() under
RDMA_CM_EVENT_ROUTE_RESOLVED and trans->cm_connect_complete() under
RDMA_CM_EVENT_ESTABLISHED.

So on a device whose node_type is not RDMA_NODE_IB_CA, does the handler
reject anything, or does it make an indirect call through an uninitialized
stack slot?  git blame points at dcdede0406d30e ("RDS: Drop stale iWARP
RDMA transport"), which removed the

	else
		trans = &rds_iw_transport;

arm without adding a bail-out.

If that is right, then the sentence quoted above describes the opposite of
what the code does, and the trees the message says are covered have no
mitigation at all.  siw_device_create() in
drivers/infiniband/sw/siw/siw_main.c sets

	base_dev->node_type = RDMA_NODE_RNIC;

and before this patch cma_listen_on_dev() installed the RDS listener on
that device, so a remote peer connecting to the RDS port reaches the
CONNECT_REQUEST case above.

Would it make sense to also add the handler-side bail-out, something like

	if (!trans)
		return -EINVAL;

so that the "last line of defence" the message refers to exists, and so
there is something minimal to backport to trees without
rdma_restrict_node_type()?  The cm_id->device->node_type load itself is
also unguarded, while net/rds/ib.c still tests !cm_id->device.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 786f39169bc14..6d367518aafba 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -414,13 +414,14 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
>  	bool isv4;
>  
>  	isv4 = ipv6_addr_v4mapped(addr);
> -	/* Create a CMA ID and try to bind it. This catches both
> -	 * IB and iWARP capable NICs.
> -	 */
> +	/* Create a CMA ID restricted to IB devices and try to bind it. */
>  	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
>  			       NULL, RDMA_PS_TCP, IB_QPT_RC);
>  	if (IS_ERR(cm_id))
>  		return PTR_ERR(cm_id);
> +	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
> +	if (ret)
> +		goto out;
>  
>  	if (isv4) {
>  		memset(&sin, 0, sizeof(sin));

[ ... ]

> @@ -473,10 +474,8 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
>  #endif
>  	}
>  
> -	/* rdma_bind_addr will only succeed for IB & iWARP devices */
> +	/* the restriction above means this only succeeds for IB devices */
>  	ret = rdma_bind_addr(cm_id, sa);
> -	/* due to this, we will claim to support iWARP devices unless we
> -	   check node_type. */
>  	if (ret || !cm_id->device ||
>  	    cm_id->device->node_type != RDMA_NODE_IB_CA)
>  		ret = -EADDRNOTAVAIL;

[Severity: High]
The message describes this test as follows:

    the address check's bind fails outright on anything else (its
    explicit node_type test now only guards against a device with no
    node type at all)

Is that accurate?  Once restricted_node_type is set on the id,
cma_acquire_dev_by_src_ip() in drivers/infiniband/core/cma.c skips every
candidate device by node type:

		if (id_priv->restricted_node_type != RDMA_NODE_UNSPECIFIED &&
		    id_priv->restricted_node_type != cma_dev->device->node_type)
			continue;

Since RDMA_NODE_UNSPECIFIED is also filtered there, the
cm_id->device->node_type != RDMA_NODE_IB_CA half of the test in
rds_ib_laddr_check_cm() looks dead rather than a guard for "no node type
at all"; only the !cm_id->device half can still fire.  Could the
parenthetical be reworded?

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 4feb0edc360c8..a859c252fd9a7 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -999,6 +999,16 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
>  		goto out;
>  	}
>  
> +	/* rds_ib_laddr_check() only vouched for the local address being
> +	 * on an IB device; the address resolution below picks the device
> +	 * on its own, so restrict it to the same kind.
> +	 */
> +	ret = rdma_restrict_node_type(ic->i_cm_id, RDMA_NODE_IB_CA);
> +	if (ret) {
> +		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
> +		goto out;
> +	}
> +
>  	rdsdebug("created cm id %p for conn %p\n", ic->i_cm_id, conn);
>  
>  	if (ipv6_addr_v4mapped(&conn->c_faddr)) {
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..91ff1dde26af0 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -210,6 +210,14 @@ static int rds_rdma_listen_init_common(rdma_cm_event_handler handler,
>  		return ret;
>  	}
>  
> +	/* Only the IB transport is left, so only listen on IB devices */
> +	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
> +	if (ret) {
> +		pr_err("RDS/RDMA: failed to setup listener, rdma_restrict_node_type() returned %d\n",
> +		       ret);
> +		goto out;
> +	}
> +

[Severity: Low]
This new error path jumps to out and returns ret with ic->i_cm_id
still pointing at the id rdma_create_id() just handed back, and nothing
between here and the return destroys it.  Compare the
rdma_resolve_addr() failure a few lines further down, which does

	rdma_destroy_id(ic->i_cm_id);
	ic->i_cm_id = NULL;

before falling into the same out label, and the other two sites this
patch touches: in rds_ib_laddr_check_cm() the new goto out lands on a
label that calls rdma_destroy_id(cm_id), and in
rds_rdma_listen_init_common() cm_id is still non-NULL at out so it is
destroyed there too.  So this is the one of the three new calls whose
failure leaks the id, i.e. a struct rdma_id_private and its restrack
entry.

In practice it cannot be reached: rdma_restrict_node_type() only
returns -EINVAL for a node type it does not recognise and -EALREADY if
the id is not in RDMA_CM_IDLE, and a freshly created kernel id being
restricted to RDMA_NODE_IB_CA is neither, so this is a structural
defect rather than something a peer or a local user can trigger.

Still, the surrounding code is careful about this, so which way did you
intend it?  Is the connection teardown path (rds_ib_conn_shutdown(),
which destroys ic->i_cm_id when it is set) meant to clean up after a
failed rds_ib_conn_path_connect(), or should this arm mirror the
resolve failure and do the rdma_destroy_id()/NULL itself?  If the
former, the asymmetry with the rdma_resolve_addr() arm immediately
below is confusing enough that it is worth saying so in a comment.

[Severity: Low]
Should this change carry a Fixes: tag, and a note for stable?  The defect
being closed is remotely reachable (the listener was previously installed
on RDMA_NODE_RNIC devices such as siw, and the handler then runs with
trans unassigned), but there is no Fixes: line among the trailers.

The three new calls here, in rds_ib_conn_path_connect() and in
rds_ib_laddr_check_cm() all depend on a760e80e90f5 ("RDMA/core: introduce
rdma_restrict_node_type()"), so an automated backport to a tree without
that commit will not build.  Could the message state either that
a760e80e90f5 is a prerequisite, or that stable should take a minimal
handler-side fix instead?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917074108.174262-1-achender%40kernel.org
