Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771952;
	b=wJTxLThv6j+bwL3AlVsnopBW6hCIbQo2C7utjW2ixGCrDFp7eItRZ4PYKtDPMhKvxTUu
	 mS1+uvoE+uznB81IZzuYGy6iXZD8CqFwsp4w8HSbcOKJN1bSVOujJMINCPoOybbNdnUbc
	 1SieJPf0uweqcVoZNTXt8l4nATGblcWeGBj8eKGUA+WiuI9xohVE9qk4h+5QmTyNJyh0T
	 3exgprZGqhbRyT9uk92GX/X4A31c+hr2ZmF2yJW5ybyPVQV3X5ZQpuGhYgdBDNklVYpfc
	 Qdg3FwmIUfg9C1IgzzsJjU2DTLZsYKiTTGJYw+o2H8bmCgGwb/5AQ/leI4LrD/KZDbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771952;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=T/G6pzsoK+F+CtQtlkUh76y8RiTxogxKJtiNf+BMjRI=;
	b=lvtjQX31zdVghN72NZqxhsOE3UB7eHuspekS6+bUiJY3eOCMJuT+OcWhR8eg86vHdG0e
	 pRpTMKp5zQ0bjiZVA2HbaT7o4pbFWbQpqh4ZgjeiGpTnJ9JenkhXrKluy+uerCIj5AZu7
	 MTu4OMN3RWkN0H+kFkDODIJTrQW5Rxbce4vpGqAPYpUZtyrUgpmZYr37AOuWc3Wv8vw2H
	 kV5eHm6bTRjZu/Eeu9q59KucjNyBo9Z9eFINKEI9VQZMuI+srpSiEhkEK+yTcqE9IgfQu
	 7h9RmIwutMPWKQTrGOd11L/PYXdr0ynT40gTZXEzmYY1VzEN1nnHDWfB2BUFvAucIZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QvJCpWXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44B606A31C;
	Fri, 27 Nov 2026 09:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QvJCpWXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337011F00893;
	Fri, 27 Nov 2026 09:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795771952;
	bh=T/G6pzsoK+F+CtQtlkUh76y8RiTxogxKJtiNf+BMjRI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QvJCpWXPw6s5NS/yIfAbR/bc1NaJHvCmrgqzM5+JNXJ2YyZOdn2jd1DS+1bzwBzJj
	 wchBe6UP0YSKap74ysZWlDgPtGKwoay3LBDb+vi8gQTqkJK3nL0DTGG9/muSaw7C4c
	 /erCL/9vccjs6yCqjilRKZl6TUa/cB/R9aQ5mGwB4H9OuDivZojt/2VnCvIVha0FFe
	 +urj8TUqjgm+vmopkxTrg3pwwZvjDB8nk+ladZ0vZ6qvo2bQJ8EQzbmC05N5qoCzla
	 oblc46v2mw9XPv54XOG+ropQ36+J7mnTMX95KmqmLfVK4CP/UrhzObCGSMoeaPz9nn
	 50hKEHQdCq0Dw==
Subject:
 Re: [PATCH net v2] net/mlx5e: Fix deadlock when parsing flow actions fails
From: netdev-bot+sashiko@kernel.org
To: ziyuzhang201@gmail.com
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, roid@nvidia.com,
 baijiaju1990@gmail.com
Date: Fri, 27 Nov 2026 09:32:30 +0000
Message-ID: <179577195076.3135.5834107513573731411@kernel.org>
In-Reply-To: <20261126084216.26436-1-ziyuzhang201@gmail.com>
References: <20261126084216.26436-1-ziyuzhang201@gmail.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch fixes the init_done/encap_tbl_lock deadlock only when
  action parsing fails.
- [Medium] The new PARSE_FAILED early return in mlx5e_take_tmp_flow() can
  leave mlx5e_update_route_encaps() with an empty per-entry list for an…

Pre-existing issues:
- [High] The patch skips PARSE_FAILED flows in mlx5e_take_tmp_flow()
  because a route update can reach the same flow through more than one…

--

net/mlx5e: Fix deadlock when parsing flow actions fails

This patch adds an abort_flow_post_acts() helper. When action parsing
fails, it removes the post-action rules, sets a new PARSE_FAILED flag
and completes init_done early. mlx5e_take_tmp_flow() now waits for
init_done before taking a reference and skips flows that have
PARSE_FAILED set.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 4f9f8beffbc8d..154c3dbce548e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -275,6 +275,11 @@ static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
>  				struct list_head *flow_list,
>  				int index)
>  {
> +	/* Detaching the flow also takes encap_tbl_lock. */
> +	wait_for_completion(&flow->init_done);

[Severity: High]
Can this still deadlock when flow creation succeeds?

When alloc_flow_post_acts() calls post_process_attr() for a post-action
attr with encap dests, mlx5e_tc_tun_encap_dests_set() puts the flow on
that encap entry's e->flows list. init_done is still not complete at
that point.

The add path can then take esw->offloads.encap_tbl_lock again before
__mlx5e_add_fdb_flow() reaches complete_all(&flow->init_done):

  - a later post-act attr with encap dests in the same
    alloc_flow_post_acts() loop
  - mlx5e_tc_add_fdb_flow()->mlx5e_attach_decap_route() for TUN_RX
    flows, which takes the lock unconditionally
  - mlx5e_tc_add_fdb_flow()->post_process_attr(flow->attr)->
    mlx5e_tc_tun_encap_dests_set() when the main attr also has encap
    dests

Flow add runs without RTNL because mlx5e sets f->unlocked_driver_cb, so
it can interleave with the update work:

CPU1 (flow add)                      CPU2 (neigh/FIB update)
alloc_flow_post_acts()
  post_process_attr() /* on e->flows */
                                     rtnl_lock()
                                     mutex_lock(&encap_tbl_lock)
                                     mlx5e_take_tmp_flow()
                                       wait_for_completion(&init_done)
mlx5e_tc_add_fdb_flow()
  mlx5e_attach_decap_route()
    mutex_lock(&encap_tbl_lock) /* blocks */

CPU2 can be either mlx5e_rep_update_flows() or
mlx5e_tc_fib_event_work(). Both hold RTNL and encap_tbl_lock across
this wait.

The flow is not failing here, so abort_flow_post_acts() is never called
and the PARSE_FAILED check does not help. Neither side can make
progress, and RTNL stays held.

One example trigger is a TUN_RX rule with ct, followed by tunnel_key
set and a mirred redirect to a VXLAN device, racing with a neigh update
or FIB event for that encap.

Would it be better not to wait for init_done while holding
encap_tbl_lock at all, instead of completing init_done early only on
the parse failure path?

> +	if (flow_flag_test(flow, PARSE_FAILED))
> +		return;

[Severity: Medium]
Can this early return leave an encap entry that is still in use with
stale state?

Suppose the flow that failed parsing is the only flow on e->flows. It
keeps its reference on e until mlx5e_detach_encap() can take
encap_tbl_lock. Meanwhile mlx5e_update_route_encaps() collects an empty
list for e:

mlx5e_update_route_encaps() {
    ...
		mlx5e_take_all_encap_flows(e, &encap_flows);
		if (list_empty(&encap_flows))
			continue;
    ...
}

That skips mlx5e_invalidate_encap() and mlx5e_reoffload_encap(), so
MLX5_ENCAP_ENTRY_VALID and the old e->pkt_reformat stay in place.

When the FIB worker releases encap_tbl_lock, two threads compete for
the mutex: the failed flow's mlx5e_detach_encap(), and a new flow with
the same tunnel key in mlx5e_tc_tun_encap_dests_set(). If the new flow
wins, mlx5e_attach_encap() treats the entry as valid:

	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
		attr->esw_attr->dests[out_index].pkt_reformat = e->pkt_reformat;

It also uses the stale e->route_dev_ifindex in mlx5e_set_vf_tunnel().
The route event has already been consumed. Would the new flow then stay
offloaded with encap state built for the old route?

> +
>  	if (IS_ERR(mlx5e_flow_get(flow))) {
>  		/* Flow is being deleted concurrently. Wait for it to be
>  		 * unoffloaded from hardware, otherwise deleting encap will
> @@ -283,7 +288,6 @@ static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
>  		wait_for_completion(&flow->del_hw_done);
>  		return;
>  	}
> -	wait_for_completion(&flow->init_done);
>  
>  	flow->tmp_entry_index = index;
>  	list_add(&flow->tmp_list, flow_list);

[Severity: High]
This bug was not introduced by this patch. The commit message describes
a double list_add hazard here, and it also seems reachable for flows
that fail in mlx5e_tc_add_fdb_flow(). Those flows have only FAILED set,
not PARSE_FAILED.

Take one attr with two VF-tunnel encap dests that share a tunnel source
IP. mlx5e_attach_encap_route() keys the route on the source IP, so both
encap entries end up on the same r->encap_entries list.
mlx5e_tc_tun_encap_dests_set() attaches both and then rejects the rule
while the encaps are still attached:

	if (*vf_tun && esw_attr->out_count > 1) {
		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
		err = -EOPNOTSUPP;

__mlx5e_add_fdb_flow() then calls complete_all(&flow->init_done) before
err_free detaches them.

Suppose mlx5e_tc_fib_event_work()->mlx5e_update_route_encaps() takes
the flow for e1 before the adder's mlx5e_flow_put() drops the refcount
to zero. For e2, mlx5e_flow_get() then succeeds because the worker
already holds a reference.

This list_add() then relinks a tmp_list node that is still on
flow_list. The list_splice() that follows leaves flow->tmp_list
pointing to itself.

Would mlx5e_put_flow_list() then loop forever on the same flow while
holding RTNL? It would also call mlx5e_flow_put() past zero and touch
the flow after kfree_rcu().

Should the skip check here also cover FAILED flows? Alternatively,
could mlx5e_update_route_encaps() remove duplicates when it collects
flows from several encap entries?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126084216.26436-1-ziyuzhang201%40gmail.com
