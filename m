Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF643C73EC;
	Sun,  4 Oct 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131705; cv=none; b=mxlTqr2xOxEX2RvnbftBmGFBHWBDupowFuw2qETL1bodX4bhzDzEL1gcK5WaFS9pwxp2X29chr5L6KGqP+Ya27HBYRuIP7d/mX5syJLI4RcVNt4mWO25pGsygmT93lITUkq0+jqdF0SOWdpewdhZqCBV3c75fLIjPY52tzAKfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131705; c=relaxed/simple;
	bh=YvVQFb8ntZ1uYruZvTEpMRZumuGkvU4Yznh0HABMjQE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m8HZL0suO74+w+ol7sUwEAK5tpIHwTfUNMOoIKX1mltGz5Q4ZBSh1IOrZww3PJqc2cy3ctyk11XVVjTbS2JHhdY9rVkV2MjqMI6dEzHMJbk/lfz/xFYWYIQM1F9wNPztquOZydu2hSd1/O9o2joLDwdOs+G8Yr2bVb53SsVu5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1pWfGCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1pWfGCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA21F000FF;
	Sun,  4 Oct 2026 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131704;
	bh=wVg3p4nG6+ugwUczeKXrVxwDXc/NVtTLfIMRNAYL0SY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=K1pWfGCdVNJBJjMQvtYD2kVpNtymVbqy5ASyuCzacbuRwMLL2BuJl/2s7H/CPn7Y0
	 pHSJKOO4e6ifR3KPJvXx9OGePDlYaT12gdvWKMVcp9P41XmxlEquLtrK9jS7xO0WwP
	 BBZc2JCM3aZZblFYeau91NeLD9W7ARSdkbXfBy8JyyEOo+uG+l39bRVADI8RAcEzqM
	 0QANRrYXTm8ozFxKjcKtD6lxe3fKoXH4aNWD/M4NIfjZ2Dar4NXyc2j4iI+xa9KhVO
	 lhfcE73PliiixsZmO4Od8mUAUcX+D9RGnJoo6QmQT0B/6er2mfOZgTx7cfLACuDuMd
	 I8V6b15etgEmg==
Subject: Re: [PATCH net-next v8 11/13] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:35:03 +0000
Message-ID: <179113170371.434549.16420212247196359314@kernel.org>
In-Reply-To: <20261003163215.250253-12-achender@kernel.org>
References: <20261003163215.250253-12-achender@kernel.org>
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

- [Low] Two new comments in this patch don't match what the rs_conn cache
  code does.

Pre-existing issues:
- [Medium] The rs_conn cache-hit check in rds_sendmsg() (net/rds/send.c)
  compares only the destination address and ToS…

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes rds_conn_lookup(), __rds_conn_create(), the rs->rs_conn
sendmsg cache and parent->c_passive hold real connection references.
rs_lock now serializes the rs_conn cache, which also resolves a syzbot
KCSAN data race between concurrent rds_sendmsg() calls.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 7235974343dda..bedcd8b836f66 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c

[ ... ]

> @@ -1343,21 +1344,68 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  	rm->m_daddr = daddr;
>  
>  	/* rds_conn_create has a spinlock that runs with IRQ off.
> -	 * Caching the conn in the socket helps a lot. */
> -	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> -	    rs->rs_tos == rs->rs_conn->c_tos) {
> -		conn = rs->rs_conn;
> +	 * Caching the conn in the socket helps a lot.
> +	 *
> +	 * The cached rs_conn holds a connection reference; take one of
> +	 * our own for the duration of this call (dropped on both exit
> +	 * paths), so that neither a concurrent sender replacing the
> +	 * cache nor rds_conn_destroy() can free the connection under
> +	 * us.  A cached connection whose destruction has begun is not
> +	 * reused: dropping it here lets the next sendmsg look up or
> +	 * create a live one instead of returning -EAGAIN forever.
> +	 */
> +	spin_lock_irqsave(&rs->rs_lock, flags);
> +	conn = rs->rs_conn;
> +	if (conn && rds_destroy_pending(conn)) {
> +		/* drop the cache's reference right here, or the socket
> +		 * would pin the quiesced connection until it is closed
> +		 */
> +		rs->rs_conn = NULL;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +		rds_conn_put(conn);
> +		conn = NULL;

[Severity: Low]
This isn't a bug, but do the new comments match what this path does?

The comment above says that dropping the cached connection "lets the next
sendmsg look up or create a live one". After conn = NULL here, though,
execution goes straight into the if (!conn) block below and calls
rds_conn_create_outgoing() in this same call. A later sendmsg only has to
do the work if that create fails.

The new rs_conn comment in net/rds/rds.h also says:

    The cache owns a connection
    reference, dropped when it is replaced or the socket is
    released, ...

That misses this eviction case, where rds_sendmsg() sets rs_conn to NULL
whenever rds_destroy_pending(conn) is true. If the create that follows
fails, rs_conn stays NULL and nothing replaces it.

Could both comments be updated to cover the eviction path?

>  	} else {
> +		if (conn && ipv6_addr_equal(&conn->c_faddr, &daddr) &&
> +		    rs->rs_tos == conn->c_tos)
> +			rds_conn_get(conn);

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch, but
should the cache-hit check also compare scope_id against conn->c_dev_if?

rds_conn_lookup() tells connections apart with conn->c_dev_if == dev_if.
The TCP connect path in net/rds/tcp_connect.c uses
sin6.sin6_scope_id = conn->c_dev_if. So a cached connection is tied to
one interface.

If the socket is bound to a global IPv6 address, rs_bound_scope_id is 0.
This earlier check in rds_sendmsg() then accepts any nonzero scope_id:

	if (scope_id != rs->rs_bound_scope_id) {
		if (!scope_id) {
			scope_id = rs->rs_bound_scope_id;
		} else if (rs->rs_bound_scope_id) {

A send to fe80::X with sin6_scope_id = A creates and caches a conn with
c_dev_if = A. A later send to fe80::X with sin6_scope_id = B hits the
cache here and reuses the interface A connection.

Would that message go to fe80::X on link A instead of link B? The
baseline predicate used the same key, and this rewrite keeps it. Adding
conn->c_dev_if == scope_id to the check looks like it would fix this.

> +		else
> +			conn = NULL;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
