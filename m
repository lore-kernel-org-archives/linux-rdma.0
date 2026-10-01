Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E6835950;
	Thu,  1 Oct 2026 19:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884002; cv=none; b=QMbeJO8htJOQCn1dyN5GPfqbKpRKPQyv8O+xtosWz6F6+9ghE/oBbvnZD89aiDBCp1jDb2GiPneN/NdPzcnmCIC1nCEZz3upzl4cI6vCBf0nSrzFmhEH4gwRCIge9v/k6NEstRv1CWzil+qxEIOlPZhh0uJJ3LC6iFHXhgLomMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884002; c=relaxed/simple;
	bh=EM+YI08YONldh+VwKkVYSEiJuGxa/EKkzSQ/29smG5k=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f8AE77CKjhWMsp6e7/1V1Y1mm2QXxzEftLBhFYVqyqRAKrteypoBV1qjf22WbAAFoIQskowEL9CB1X7kpjkKFE+wU8a4w1u99G7DhevKe0CqoMx2fnRPGJKOY/nQAuwShvbcu/bviYvI36wr2xQ9v4mfpb2Za6bsVqFiu72YT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoBi8zVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoBi8zVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707561F000FF;
	Thu,  1 Oct 2026 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790884000;
	bh=elBcijJlMby3MFSG5Sal39aHLTt7LbcvX6xBM8gw/f8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aoBi8zVmdw0Pco9mFpGjeocjy+t96JNgTxsnQV3PqYycQIQuuGTurcVjr+2sfYQf8
	 DW0e8agxFiA+64+BnoVFWQ2dOVubYdrTx5RuBjXt1tH3TZGgxnP6HDQBczrNYKYB5E
	 1NKI7yd7JoGdEVXV1HX/GMCi1QIpwZZJLBXMwXxgTFpysF7EzVubzOiaquBzYJqswG
	 4HMfrQdBEYcg/lT+qr//eV/u5A4CjNEuOgDzFv00p5HDMR+x9yKOMjF0PKlv7l3NQa
	 yb6P+UjeOzrFr8FEWB9fI/e8DsrWroVKpFOhaBDSrFYoKJtg4CctepShHURU3PDLwX
	 y47ueMPBMusTg==
Subject: Re: [PATCH net v3] net: rds: fix uninitialized trans dereference in
 CM event handler
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org,
 ljp1205831794@gmail.com, henrymei@tencent.com
Date: Thu, 01 Oct 2026 19:46:40 +0000
Message-ID: <179088400000.434549.12700549700443616732@kernel.org>
In-Reply-To: <20260928044507.335883-1-achender@kernel.org>
References: <20260928044507.335883-1-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix only checks the device type on the passive side, and
  only for RDMA_CM_EVENT_CONNECT_REQUEST.

--

net: rds: fix uninitialized trans dereference in CM event handler

This commit initializes trans to &rds_ib_transport in
rds_rdma_cm_event_handler_cmn() and drops the conditional assignment on
the node type. It also rejects RDMA_CM_EVENT_CONNECT_REQUEST when the
request arrives on a non-IB device, so an RDS listener no longer crashes
when an iWARP device gets a connect request.

Link: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/
Link: https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..164bd7cbe2083 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c

[ ... ]

> @@ -82,6 +79,15 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  
>  	switch (event->event) {
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
> +		/* Only the IB transport is supported, but RDS listens on
> +		 * every RDMA device: reject a request that arrived on any
> +		 * other kind.  A non-zero return has rdma_cm destroy the
> +		 * request's id, which is what we want here and only here.
> +		 */
> +		if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
> +			ret = 1;
> +			break;
> +		}

[Severity: High]
This check only covers the passive side, and only for
RDMA_CM_EVENT_CONNECT_REQUEST. Can an outgoing RDS/IB connection still
end up on an iWARP RNIC? If so, would it oops in the
RDMA_CM_EVENT_ROUTE_RESOLVED case of this same handler?

rds_ib_conn_path_connect() creates the id without restricting its node
type:

net/rds/ib_cm.c:rds_ib_conn_path_connect() {
    ...
	ic->i_cm_id = rdma_create_id(&init_net, handler, conn,
				     RDMA_PS_TCP, IB_QPT_RC);
    ...
	ret = rdma_resolve_addr(ic->i_cm_id, (struct sockaddr *)&src,
				(struct sockaddr *)&dest,
				RDS_RDMA_RESOLVE_TIMEOUT_MS);
    ...
}

restricted_node_type stays RDMA_NODE_UNSPECIFIED. That means
cma_acquire_dev_by_src_ip() can pick any device that matches
conn->c_laddr, including an RNIC:

drivers/infiniband/core/cma.c:cma_acquire_dev_by_src_ip() {
    ...
		if (id_priv->restricted_node_type != RDMA_NODE_UNSPECIFIED &&
		    id_priv->restricted_node_type != cma_dev->device->node_type)
			continue;
    ...
}

After ADDR_RESOLVED, rdma_resolve_route() on an iWARP port goes to
cma_resolve_iw_route(). That function queues ROUTE_RESOLVED but never
allocates cm_id->route.path_rec. The handler then runs:

	case RDMA_CM_EVENT_ROUTE_RESOLVED:
		...
			if (ibic && ibic->i_cm_id == cm_id) {
				cm_id->route.path_rec[0].sl =
					TOS_TO_SL(conn->c_tos);
				ret = trans->cm_initiate_connect(cm_id, isv6);

Isn't that a write through a NULL path_rec in the cma_wq worker? It
would happen with id_priv->handler_mutex and conn->c_cm_lock held. The
write comes before trans is used, so initializing trans doesn't prevent
it.

There seem to be two ways to reach this.

The first is remote. On a host with both an IB_CA device and an iWARP
device, a peer sends an RDS REQ over the IB device, so the new check
passes. In the private data, dp_daddr is the local iWARP interface
address and dp_saddr is a neighbour on that subnet.

rds_ib_cm_handle_connect() hands these addresses to rds_conn_create()
without checking that laddr belongs to the device the request arrived
on. The connection is hashed.

After a disconnect or setup failure, the reconnect then uses the
addresses the peer chose:

rds_conn_shutdown()
  rds_queue_reconnect()
    rds_connect_worker()
      rds_ib_conn_path_connect()

The lowest-address rule in rds_queue_reconnect() only applies to TCP,
so it doesn't stop this.

The second is local. A socket bound to an address on an IB device
passes rds_ib_laddr_check_cm() at bind time. If that address later
moves to an iWARP netdev, rds_sendmsg() reuses rs->rs_transport and
doesn't check the device again.

The same crash was possible before this patch. However, the commit
message lists ROUTE_RESOLVED among the cases that crash on non-IB
devices, and says:

  "IB is the only transport left, so make that explicit"

while only incoming requests are rejected.

Would it work to call rdma_restrict_node_type(id, RDMA_NODE_IB_CA) on
the ids RDS creates, meaning the active id in
rds_ib_conn_path_connect() and the listen ids? smbdirect already uses
this helper. cma_acquire_dev_by_src_ip() and cma_listen_on_dev() both
honour it, and it could replace the per-event check here.

Another option is to check the device type on ADDR_RESOLVED or
ROUTE_RESOLVED, then call rds_conn_drop() and return 0, so RDS keeps
ownership of the id.

>  		ret = trans->cm_handle_connect(cm_id, event, isv6);
>  		break;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260928044507.335883-1-achender%40kernel.org
