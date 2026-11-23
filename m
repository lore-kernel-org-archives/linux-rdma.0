Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448107;
	b=lMOShtaDA2tF3KUQOWWCm1RFf8GuQR+cp994km1N+cA87SpOj7xIVCP5CynSTlqvmmHM
	 yge/eCKhUsUtvU2ehiwsyyep+Pc+dl3V6Wt595HzGBXpuNmW+k1WIK4Q+Whe1EZWXiHCX
	 zHPh6faY2vHkmGvGii91wKxUNq6+77x5GWWYQ9GIolYQKIbYgv8AYb8/fUVtPvpinnuUZ
	 4Q15D8RXOuUnBEUU8RNQULQ+oCEFEHZ4qPKPCci8PLYl1qa8SEQRoa9DeJDoBE4vMofgh
	 KlBf3o1ilSTCgzyXGYWolY6YswN2Lr3dbO+KWVKS3lg3qTuuYnzmwGmJVzDoiGj1yeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448107;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=2WTUAIe9/FWuJxjNSbePYXA4Ybis92IvBPtCl2Olzak=;
	b=xSYikZPoWcLs6/3Eyo3nEpmTWf/x2Ok6tP+6lQ8w9VhtdFRn/Z+or7IWJky5yiDiebtR
	 fxpot1T31kfu7xcCAhOAN5YedArVVQ6bsohXRwHhEFLrJzLL83eYf5j7f6yQSm8HI86se
	 +q23pSyoogPVIygJvtoT3iRemEo2Xq9V+VF3Aj9L6rD2D9mO1Yx7r1WbBulyEya5oQVma
	 XRTMs91PDOc0TLlv4jpJ72XFJp0r1Z5W+ER4qURAax+YGQ1FM1+uJw9uen+1zs9Isb+nL
	 0102Dzr6X05qMWn13sUvgzXl3HZKiPxxwoiDV8DtSxGgc9W1cyClf6upXj22HkiXv3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PaLXvN1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF74D606A31A;
	Mon, 23 Nov 2026 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PaLXvN1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC21B1F000D0;
	Mon, 23 Nov 2026 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448107;
	bh=2WTUAIe9/FWuJxjNSbePYXA4Ybis92IvBPtCl2Olzak=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PaLXvN1baVDqlSR/1pfAUv7HDrVbjk1nEg7WL+oRUMqypGPkPIzMiIomok+P717GB
	 GUb4J4J6A1A1mYbl6usEItkLJBPzEapq4chPn/gNpVt0wjD07E1Y9DOeb1IcK1fQaB
	 I8La+AkQICMQ/eMamfK3uRqrVmnDBKjfWiYmnbHcOM3nlFEJIcUjExjBvJsc4+2tUS
	 Eg4dPowa0tTaiu4hSD6N3cuO28WxvaHFsgPK34wQbeGRZWcSBoxOTjgsiMFtK8Thtc
	 13Zko3QrqYIDHCH2Wihh6TJ6539jzMwfi/1mvgYjilTlb+Bi/+/12aYJIWYEvrrQrt
	 5zzcttsqY3xCw==
Subject: Re: [PATCH net v4] net/rds: defer CM id destruction to a workqueue
From: netdev-bot+sashiko@kernel.org
To: chenaibing@cmss.chinamobile.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 15:35:06 +0000
Message-ID: <179544810638.3135.8411229490217638790@kernel.org>
In-Reply-To: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
References: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] RDS_IB_MAX_PENDING_PROBES (net/rds/ib.c:399-401) is one global
  budget of 64 for the whole system, with no per-user or per-socket…
- [Medium] The new temporary errors in rds_ib_laddr_check_cm()
  (net/rds/ib.c) never reach userspace; callers read them as "this…
- [Medium] The commit message calls the issue a real deadlock ("falling
  back to the synchronous destroy, which would bring the deadlock back…

--

net/rds: defer CM id destruction to a workqueue

This patch moves rdma_destroy_id() for the probe cm_id created in
rds_ib_laddr_check_cm() onto rds_wq, so it no longer runs under
rds_trans_sem. A global atomic counter caps pending probe ids at
RDS_IB_MAX_PENDING_PROBES, and the address check returns -EAGAIN above
that cap. rds_ib_exit() flushes rds_wq before the module goes away.

Closes: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..c4c10e3eabced 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -391,6 +391,30 @@ static void rds6_ib_ic_info(struct socket *sock, unsigned int len,
>  }
>  #endif
>  
> +/*
> + * Maximum number of probe cm_ids whose destruction is still pending on
> + * rds_wq.  Each of them pins a cma_dev reference and an RDMA_PS_TCP port,
> + * so the number of in-flight probes has to be bounded.
> + */
> +#define RDS_IB_MAX_PENDING_PROBES	64
> +
> +static atomic_t rds_ib_pending_probes = ATOMIC_INIT(0);

[Severity: High]
Is one system-wide budget of 64 safe here? Nothing splits it per user or
per socket. The only place that releases a slot is
rds_ib_destroy_id_work(), which runs on rds_wq. That is an ordered
single-threaded workqueue, and other RDS work shares it:

net/rds/threads.c:rds_threads_init() {
	rds_wq = create_singlethread_workqueue("krdsd");
	...
}

The commit message only considers a bind() loop. However,
rds_ib_laddr_check_cm() is also reached for every new connection:

__rds_conn_create()
  rds_trans_get_preferred(net, faddr, conn->c_dev_if)
    rds_ib_laddr_check()
      rds_ib_laddr_check_cm()

That includes incoming connect requests. There,
rds_ib_cm_handle_connect() calls rds_conn_create(&init_net, daddr6,
saddr6, ...), and saddr6 comes from the peer's CM private data.

rds_ib_laddr_check() skips the probe only for v4-mapped addresses that
rds_ib_get_device() finds. Remote peers, IPv6 addresses and uncached IPv4
addresses each hold a slot until the worker runs.

Can one unprivileged user, or a burst of connection setup, keep
rds_ib_pending_probes at 64 and make every other user's IB address check
fail? Their bind() would then be moved to RDS/TCP or fail, as described
below for the -EAGAIN return. Before this patch, one user could not
affect another user's IB bind.

There also seems to be a lasting effect on connections. Take a new
connection whose faddr is local but misses the fast path. If the probe
returns -EAGAIN and rds_tcp is not loaded, loop_trans is NULL and
c_loopback stays 0:

net/rds/connection.c:__rds_conn_create() {
	...
	loop_trans = rds_trans_get_preferred(net, faddr, conn->c_dev_if);
	if (loop_trans) {
		rds_trans_put(loop_trans);
		conn->c_loopback = 1;
	...
}

Connections are not re-evaluated later, so the looped-back IB passive
connection split is skipped:

	if (conn &&
	    conn->c_loopback &&
	    conn->c_trans != &rds_loop_transport &&
	    ipv6_addr_equal(laddr, faddr) &&
	    !is_outgoing) {

Wouldn't the incoming self-connect then find the outgoing conn itself,
and rds_ib_cm_handle_connect() reject it as a raced connect?

The commit message mentions neither the connection creation path nor the
shared budget.

[ ... ]

> @@ -411,14 +435,39 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,

[ ... ]

>  	isv4 = ipv6_addr_v4mapped(addr);
> +
> +	/*
> +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls this
> +	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
> +	 * takes handler_mutex, which the CM callback path acquires before
> +	 * taking rds_trans_sem.  Reserve a pending-probe slot first, so that a
> +	 * loop of bind() calls cannot pile up ids that pin a cma_dev reference
> +	 * and an RDMA_PS_TCP port.
> +	 */

[Severity: Medium]
The commit message, which is tagged Cc: stable, says:

    rather than falling back to the synchronous destroy, which would bring
    the deadlock back under memory pressure.

Can that deadlock actually happen? The handler_mutex that
rdma_destroy_id() takes here belongs to the private probe cm_id created a
few lines below. That id has a NULL context, is only bound, is never
listened on, and is never shared.

On the CM callback path in the commit message, the code holds the
listener's handler_mutex and the new conn_id's handler_mutex, not the
probe's:

cma_ib_req_handler()
  rds_rdma_cm_event_handler()
    rds_ib_cm_handle_connect()
      rds_conn_create()
        rds_trans_get_preferred()
          down_read(&rds_trans_sem)

Those are different instances of the same lock class.

For the probe id, the events that could hold its handler_mutex reach
rds_rdma_cm_event_handler_cmn() with conn == NULL, and nothing is done:

	case RDMA_CM_EVENT_DEVICE_REMOVAL:
	case RDMA_CM_EVENT_ADDR_CHANGE:
		if (conn)
			rds_conn_drop(conn);
		break;

That path never waits for rds_trans_sem. Both sides also take
rds_trans_sem only for read.

This looks like a class-level lockdep report rather than an
instance-level deadlock. It is still worth silencing, but could the
commit message and this comment describe it that way?

If no real deadlock exists, is the stable backport justified? This patch
also brings in the global probe cap and the transport fallback described
here.

> +	if (atomic_inc_return(&rds_ib_pending_probes) >
> +	    RDS_IB_MAX_PENDING_PROBES) {
> +		atomic_dec(&rds_ib_pending_probes);
> +		return -EAGAIN;
> +	}
> +
> +	w = kzalloc_obj(*w, GFP_KERNEL);
> +	if (!w) {
> +		atomic_dec(&rds_ib_pending_probes);
> +		return -ENOMEM;
> +	}

[Severity: Medium]
Does the -EAGAIN (or -ENOMEM) ever reach userspace?
rds_trans_get_preferred() treats any non-zero laddr_check() result as
"not this transport" and moves on to the next slot:

net/rds/transport.c:rds_trans_get_preferred() {
	...
	for (i = 0; i < RDS_TRANS_COUNT; i++) {
		trans = transports[i];

		if (trans && (trans->laddr_check(net, addr, scope_id) == 0) &&
		    (!trans->t_owner || try_module_get(trans->t_owner))) {
	...
}

RDS_TRANS_TCP comes after RDS_TRANS_IB. rds_tcp_laddr_check() returns 0
for any RTN_LOCAL IPv4 address and for any IPv6 address that passes
ipv6_chk_addr(), and IPoIB addresses pass both checks.

While the cap is hit, would the following happen?

- bind() on an IB address succeeds but selects RDS/TCP. rds_bind() then
  stores it in rs->rs_transport for the life of the socket, so RDMA cmsgs
  and MR registration fail later.

- If rds_tcp is not loaded, bind() fails with -EADDRNOTAVAIL and logs
  "load rds_tcp or rds_rdma?".

- With SO_RDS_TRANSPORT set to IB, bind() fails with -ENOPROTOOPT:

	if (rs->rs_transport) {
		trans = rs->rs_transport;
		if (!trans->laddr_check ||
		    trans->laddr_check(sock_net(sock->sk),
				       binding_addr, scope_id) != 0) {
			ret = -ENOPROTOOPT;

So the cap doesn't seem to give the retryable back-pressure that the
comment and commit message describe. rdma_create_id() could already fail
with -ENOMEM and take the same fallback, but that was rare. Any user can
now hit the cap on purpose.

Is it intended that hitting the cap silently moves the socket to RDS/TCP?
If so, could the commit message mention the transport switch and the
changed errno?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122145148.1250-1-chenaibing%40cmss.chinamobile.com
