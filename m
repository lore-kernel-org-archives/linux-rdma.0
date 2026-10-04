Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB13C3F64;
	Sun,  4 Oct 2026 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131704; cv=none; b=tWCsrjVF9q71209f1C7IwCbqMOCjNJUeQ9nYqtn+DUGKDCzFTzO7H2LM9ADERi7EN91fYsPNON1Jwu+V2VH8e7FWZ84jXJKYiUY0Q5+IlsyW/tzQr3YzSJT+WDIjFgzXbBmjMT2TaESWfXkFCJoDfE/+KdS6tZjVbAItopGjiCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131704; c=relaxed/simple;
	bh=skFmr7EynxOzRSh22a4jRpDNXwPNmUQUqfA1Jh8IxoU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WvYiLrh4ew33MzsAW7pGwo3ErKXIICuOaLMtaWCUJZQ8bpv6zniJTcGKMkzeUU9C3C0eCkj5POdTlypAe6mKdTtnBDWHbTeOvsJLPD21WtMLe+z7sNnmTAG325lRlR8+ZpfCbO7k0rBhmd/zk061JLHb5Y2e0RBaLFierbDHxko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luE4wHsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luE4wHsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A2F1F00893;
	Sun,  4 Oct 2026 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131703;
	bh=b6Co69KpyxamZ810DrWt9NFGQ2dWIkPHj6OgqGAXK+A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=luE4wHsDbRWPnAhDsqj9dnG3zcMMqQ+mekR5hF0SyFu/8YHFToOmxFhlFYqFFHBck
	 /7aXSGDQhBvZn37gGA2JOwXy+BoleOpLvbf0QtBNEBkHuX/0Z9ETMQJguulSQzVkD6
	 2y9Kcd9CuiJR796HMaVpLSRoaiC0As1FY13fP/Yo9SK+KlZKC6meCUedbGNQiN4WPo
	 GZ//PXY2FRWHNozdDrzCK9peEVAy6FEZV9/t4dwXQatES3lNsUdU62nK29+tOa+dRA
	 drhIfwrVHkKbWdMPiDYgoIpMTMJMiCYd/hZfzsTj+cFdbOpcldi37Wi3aE8eKEp7Ix
	 Ostu4dcfwxCaA==
Subject: Re: [PATCH net-next v8 09/13] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:35:02 +0000
Message-ID: <179113170256.434549.13509160996868821054@kernel.org>
In-Reply-To: <20261003163215.250253-10-achender@kernel.org>
References: <20261003163215.250253-10-achender@kernel.org>
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

- [Low] The commit message gives the wrong triggers for the use-after-
  free.
- [Low] The commit fixes a documented use-after-free and panic (KASAN
  slab-use-after-free in rds6_inc_info_copy, and the…
- [Low] In rds_inc_on_sock_queue() (net/rds/recv.c:505), the comment "/*
  XXX make sure this i_conn is reliable */" still sits right before…

--

net/rds: hold a connection reference from struct rds_incoming

This patch makes every assignment of rds_incoming->i_conn take a
connection reference. Received incs drop it in rds_inc_put(), and
messages drop it through a new rds_message_free() helper. The goal is to
keep a connection allocated for as long as incs or messages that point
at it remain queued on sockets.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by netns
> teardown or module unload - and every dereference of i_conn after that
> point touches freed memory.

[Severity: Low]
Are netns teardown and core module unload the right triggers here?

rds_create() allocates user RDS sockets with kern == 0:

    sk = sk_alloc(net, AF_RDS, GFP_KERNEL, &rds_proto, kern);

So each socket holds a reference on its netns. rds_recv_incoming() also
already drops incs whose socket lives in a different netns from the
connection:

    if (!net_eq(sock_net(rds_rs_to_sk(rs)), rds_conn_net(conn))) {

Taken together, it doesn't look like rds_loop_exit_net() or
rds_tcp_exit_net() can destroy a connection that an inc on a live
socket's receive queue still points at.

For the first KASAN trace, rds_proto.owner and rds_proto_ops.owner are
both THIS_MODULE in af_rds.c. Every open RDS socket therefore pins
rds.ko, and delete_module() can't reach rds_exit() while task 101 is in
getsockopt() on one. Does that trace need a forced unload
(CONFIG_MODULE_FORCE_UNLOAD)?

The path that does look reachable without a forced unload is a
cross-transport one. rds_find_bound() looks up sockets by address, port
and scope_id only, and doesn't check rs_transport. A socket bound with
one transport (for example TCP chosen via SO_RDS_TRANSPORT on an IPoIB
address) can then have incs queued that arrived on an IB connection.

That socket pins only rds.ko and its own rs_transport module, so
rmmod rds_rdma succeeds:

    rds_ib_exit()
      rds_ib_destroy_nodev_conns()
        rds_conn_destroy()

A later close then reaches the freed connection:

    rds_release()->rds_clear_recv_queue()->rds_inc_put()->rds_ib_inc_free()

This matches the second trace.

Could the commit message describe this cross-transport unload case
instead of netns teardown or unloading rds.ko? The conclusion about
CAP_SYS_MODULE and stable still holds either way.

> Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[Severity: Low]
This isn't a bug, but the trailers have no Fixes: tag. The underlying
defect is that rds_incoming->i_conn never held a connection reference,
and that goes back to the original RDS code.

The message explains why this isn't a stable candidate, so leaving out
Fixes: may be deliberate, to keep AUTOSEL from picking it up. If so,
could the commit message say that explicitly?

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..1fcd4483d3be4 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c

[ ... ]

> @@ -406,8 +425,9 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
>  	 * rds_find_bound() uses a global (netns-agnostic) hash table.
>  	 * An RDS connection created in netns A can match a socket bound
>  	 * in the init netns, delivering inc cross-netns with inc->i_conn
> -	 * pointing into netns A.  When cleanup_net() then frees that conn,
> -	 * any subsequent dereference of inc->i_conn is a use-after-free.
> +	 * pointing into netns A.  Cross-netns delivery is wrong on its
> +	 * own, and the inc's connection reference would keep a
> +	 * connection of a dead netns around, with a stale c_net.
>  	 * Drop the inc if the receiving socket lives in a different netns.
>  	 */
>  	if (!net_eq(sock_net(rds_rs_to_sk(rs)), rds_conn_net(conn))) {

[Severity: Low]
This isn't a bug, but this comment was updated for the new reference
rules while a nearby one in the same file was left as is.
rds_inc_on_sock_queue() still has:

net/rds/recv.c:rds_inc_on_sock_queue() {
    ...
		if (drop) {
			/* XXX make sure this i_conn is reliable */
			rds_recv_rcvbuf_delta(rs, sk, inc->i_conn->c_lcong,
					      -be32_to_cpu(inc->i_hdr.h_len),
					      inc->i_hdr.h_dport);
    ...
}

With this patch, an inc linked on rs_recv_queue holds its own reference
on i_conn. That reference is taken in rds_inc_init(), rds_inc_path_init()
or rds_recv_incoming(), and dropped only in rds_inc_put() after
inc_free(). The kernel-doc for rds_conn_wait_conns_freed() also says
that incs now pin their connection.

Should this XXX comment be removed or reworded, since it now contradicts
that contract? It is still there at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
