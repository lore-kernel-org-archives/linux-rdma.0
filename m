Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8130F81A;
	Sun,  4 Oct 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132081; cv=none; b=QH/aw3YZgIDADI/6v4snaDQLyTrAdT0H8B66dlG4s3Dz8rZSlaOHFoq9jFsKORQhJFRGb+tA0TCB2RhSp9B5TjjvDWTIcREw1hxhWyLT+cIjzFATZPgf3HSRvziTP2tbdK56DDLlTR8WO/afrPoDvtbiSGVep0VhLA1K+FkuUjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132081; c=relaxed/simple;
	bh=A+RLcd2EYo4aZlrZXEFns5GufK6+zGDKQUG43L+7+yU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ULxJ4yShyEAf0OKp5zhcFkZDWewuNuJd40WN2D1YVLoRZtqwxQv11mlpxgIXlAe9KO7VwJyrlsG8RiNJ+djSooQBX20Ewcy2nTHJdtta6m+1SSzlSYpsk2F881gtZfkzuaYLwePY+YG+3fUvwxO7+/Eq39AqmEorFdJIHU01nBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrB6QMP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrB6QMP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BEE1F00893;
	Sun,  4 Oct 2026 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791132079;
	bh=Z7xZoeysM9J9Z/k1WQciyR7kOIhi2cfw9s4xQwi7BUs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SrB6QMP48uthfjxy0FLXWIk/O9nLYj3u9WcSrZd/yeuubZDC4WNM3mF5BbcuMTh9H
	 eDY8aw0Pl25D4Jh50NKDujQEN+7F9gdqXL946+iiYGir3tzaFxx4CCHlTUjr5NcbCX
	 CamII//WG7G1Ngf61weYZ9lWiAOIOnKIgrwfvm4xfyRxcUNXNtwXqF1AQWpOt8pRey
	 QIl8mbsTqKDiCqtaJNgoQkPjAHN0ca0NYReoK+fX5w3vMl3rQUXIB394gMDPUP252j
	 MnHLW4t6kQCdDUzMJDqmOQstE0v64X3/Upte2IFATAOq+JDHuqkbShBB9AAbmnSYc3
	 9YuFfLTFOjuSg==
Subject: Re: [PATCH net v3 2/2] net/rds: include the scope id in the sendmsg
 connection cache check
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:41:18 +0000
Message-ID: <179113207873.434549.8956852997025096360@kernel.org>
In-Reply-To: <20261003163526.250805-3-achender@kernel.org>
References: <20261003163526.250805-3-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In rds_sendmsg() (net/rds/send.c), send() and sendto() to the
  same peer now build different connection keys.
- [Medium] In rds_sendmsg() (net/rds/send.c:1344-1347), the cache test
  reads rs->rs_conn with plain loads and no lock: the NULL check, the…

--

net/rds: include the scope id in the sendmsg connection cache check

This patch adds a comparison of rs->rs_conn->c_dev_if against the
request's scope_id to the connection cache test in rds_sendmsg(). The aim
is that sends to the same link-local address through different interfaces
go through the lookup path and use the matching connection, not the cached
one.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 9380b67675bdc..26a937a9df6af 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  	/* rds_conn_create has a spinlock that runs with IRQ off.
>  	 * Caching the conn in the socket helps a lot. */
>  	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> -	    rs->rs_tos == rs->rs_conn->c_tos) {
> +	    rs->rs_tos == rs->rs_conn->c_tos &&
> +	    rs->rs_conn->c_dev_if == scope_id) {

[Severity: High]
On a socket bound to a link-local address and connected to a
non-link-local peer, can send() and sendto() to the same peer now end up
with different connection keys?

Take bind(fe80::a%X) followed by connect(G), where G is a global address.
rds_bind() stores rs_bound_scope_id = X, and rds_connect() takes the
non-link-local branch:

net/rds/af_rds.c:rds_connect() {
    ...
		} else {
			rs->rs_conn_scope_id = 0;
		}
    ...
}

A sendto(G) starts with scope_id 0. The namelen != 0 block in
rds_sendmsg() then falls back to the bound scope:

		if (scope_id != rs->rs_bound_scope_id) {
			if (!scope_id) {
				scope_id = rs->rs_bound_scope_id;

So sendto(G) creates and caches a connection with c_dev_if = X.

A send() with no destination takes scope_id = rs->rs_conn_scope_id, which
is 0. It never gets that fallback, because the fallback sits inside the
else if (namelen != 0) branch.

With the new c_dev_if == scope_id test, X != 0, so the cache misses.
rds_conn_create_outgoing(..., 0) then returns a connection with a
link-local c_laddr and c_dev_if = 0, and c_bound_if = 0 from
__rds_conn_create(). rs->rs_conn is overwritten with that connection.

For TCP, rds_tcp_conn_path_connect() binds the kernel socket with:

		sin6.sin6_addr = conn->c_laddr;
		...
		sin6.sin6_scope_id = conn->c_dev_if;

That socket has no sk_bound_dev_if, so __inet6_bind() rejects the
link-local bind:

			/* Binding to link-local address requires an interface */
			if (!sk->sk_bound_dev_if) {
				err = -EINVAL;

Wouldn't that connection never come up, so that data queued by send()
stalls? An application that mixes sendto(G) and send() would also switch
rs_conn between the two connections on every call.

Before this series, send() used rs_bound_scope_id, which matches what
sendto() computes. The earlier patch "net/rds: keep the connected peer's
scope id apart from the bound one" switched send() to rs_conn_scope_id.
This patch then removes the faddr/tos-only cache hit that was hiding the
mismatch.

The commit message says:

  With the previous patch a send without a destination carries the
  connected peer's scope, so the comparison is exact for it too.

Does that hold when the bound address is link-local and the peer is not?

Would it help to apply the rs_bound_scope_id fallback to the namelen == 0
path too, or to store the effective scope in rds_connect(), so both paths
use the same key?

>  		conn = rs->rs_conn;

[Severity: Medium]
Can rs->rs_conn change between the checks above and this assignment?

By this point lock_sock() has been released, and every access to
rs->rs_conn in this test is a plain load. Other senders on the same
socket store to it without a lock in the else branch:

		rs->rs_conn = conn;

That seems to allow a sequence like this:

T1: sendto(fe80::x%ifB) passes the checks against the cached connB
T2: sendto(fe80::x%ifA) misses the cache and stores rs->rs_conn = connA
T1: reloads rs->rs_conn and queues the ifB message on connA

The result would be the same wrong-interface send this patch is trying to
close, reached through a race. It requires the compiler to reload
rs->rs_conn, which C allows for plain accesses.

The unsnapshotted read was already there before this patch. With this
change, though, a socket that alternates interfaces rewrites rs_conn on
every send.

Would reading rs->rs_conn once with READ_ONCE(), running all the
comparisons on that snapshot, and publishing with WRITE_ONCE() close this?

>  	} else {
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163526.250805-1-achender%40kernel.org
