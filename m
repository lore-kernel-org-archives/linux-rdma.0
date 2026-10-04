Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B22D23A6;
	Sun,  4 Oct 2026 16:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132080; cv=none; b=Z1xJQ4CEqVHi7ex8w65zYE6FRDDoLvL5zuNaALf6rJ/XmzJTqValyaNZbfYq/ukRAfF93ujVgb0Umx3kGR9AmaltUgye3jjjkn7WNbT6etaJC06SLlgQ/NDs35cePRIsc6OIkPyo63LD1FWSIH0MjmLyuXyvnEi94KmsT4elK08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132080; c=relaxed/simple;
	bh=QBgN2T0IvkvCHuoU2xoCwxC3VPsknbFNwdtlX4eKQhA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OxMqqdm6td/jeXbUdzK7hw4/t8oYc9S0wS2ajvD5ZIvJZjsktvuWZhCePioS4H/C4NK5P8V7r/BVh5tSMpojNxB4ZPKcaMtsimLGsGWm8+UUkCX3kzZfoGHRaIx1N2H8rXXHZyjA9+JL8g9nbDPQyWLEpTduJEYKL6JuL2Q00X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b57zcicc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b57zcicc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7371F000FF;
	Sun,  4 Oct 2026 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791132078;
	bh=WrhsI8Xlhy/BZB624GzsXLY6E63J6ykAFI7KwH3gqCw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=b57zciccar+jpNj95jPrzhh32IyeR6asOJL2kexcAmlFVBpxDkUHRbZ9arEUCO1as
	 1Y5+LrGozy+sCmYMfXtBSuDOjrIoobSYj6ppXAOSVXJ7hd3aGXUbaFHdnz/HUc6BfY
	 wia6k/fKVhaQnr0CaLOPms0IHNqymJuwLJ2BKP3CGv5077Q8wvLmRIcbdz+9/qNG5e
	 MtfapbP/MLTDmV2wFFo+RLTEQx764PMA7iY47DQOSPUQQDH3vGV9HTp5VpKltcqqXK
	 wvifOmmUG5eHkvWxnMawNjG2HcZ24hpXOtehXEoHA/QHqIg6OYBu3m5VVaiG8Lil8P
	 PPCXfyFaHBS2w==
Subject: Re: [PATCH net v3 1/2] net/rds: keep the connected peer's scope id
 apart from the bound one
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:41:17 +0000
Message-ID: <179113207763.434549.2587721796122808515@kernel.org>
In-Reply-To: <20261003163526.250805-2-achender@kernel.org>
References: <20261003163526.250805-2-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Regression in rds_sendmsg() (net/rds/send.c:1259) for
  destination-less sends.
- [Medium] The patch moves the connected peer's scope into the new
  rs_conn_scope_id but does not update rds_getname()'s peer branch…
- [Medium] rds_recvmsg() (net/rds/recv.c:788-793) builds the IPv6 sender
  name from inc->i_saddr and rs->rs_bound_scope_id, i.e. the socket's…

--

net/rds: keep the connected peer's scope id apart from the bound one

This patch adds a separate rs_conn_scope_id field to struct rds_sock.
With it, rds_connect() no longer stores a link-local peer's scope in
rs_bound_scope_id. The connected-socket check in rds_bind() and the
destination-less path in rds_sendmsg() now use the new field.

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..ba726782addf7 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c

[ ... ]

> @@ -616,11 +617,14 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
>  				ret = -EINVAL;
>  				break;
>  			}
> -			/* Remember the connected address scope ID.  It will
> -			 * be checked against the binding local address when
> -			 * the socket is bound.
> +			/* Remember the connected address scope ID.  It is
> +			 * checked against the binding local address when
> +			 * the socket is bound, and gives a send without a
> +			 * destination its scope.
>  			 */
> -			rs->rs_bound_scope_id = sin6->sin6_scope_id;
> +			rs->rs_conn_scope_id = sin6->sin6_scope_id;

[Severity: Medium]
The peer scope now lives only in rs_conn_scope_id. Does rds_getname()
still give getpeername() the right scope? Its peer branch still pairs
the connected address with the bound scope:

net/rds/af_rds.c:rds_getname() {
    ...
			sin6->sin6_addr = rs->rs_conn_addr;
			sin6->sin6_flowinfo = 0;
			/* scope_id is the same as in the bound address. */
			sin6->sin6_scope_id = rs->rs_bound_scope_id;
    ...
}

Before this patch, connect(fe80::x%ifA) on an unbound socket reported
fe80::x%ifA. With this patch it reports scope 0. bind(global) followed
by connect(fe80::x%ifB) also goes from ifB to 0. bind(fe80::a%ifA)
followed by connect(2001::1) reports ifA for a global peer.

rds_connect() and rds_sendmsg() both reject a link-local sockaddr_in6
with sin6_scope_id == 0. So the address getpeername() returns for a
link-local peer can't be passed back to connect() or sendto().

Should this read rs->rs_conn_scope_id instead? That would match the new
field's comment in rds.h ("scope of rs_conn_addr when it is link-local,
0 otherwise"). The later patch in this series doesn't change
rds_getname() either.

[Severity: Medium]
There is a similar question for rds_recvmsg(). It takes the sender's
scope from the socket's bound scope:

net/rds/recv.c:rds_recvmsg() {
    ...
				sin6->sin6_addr = inc->i_saddr;
				sin6->sin6_flowinfo = 0;
				sin6->sin6_scope_id = rs->rs_bound_scope_id;
    ...
}

Take bind(global) followed by connect(fe80::x%ifB). Before this patch,
rds_connect() left ifB in rs_bound_scope_id, so recvmsg() from the
connected peer reported fe80::x%ifB. Now rs_bound_scope_id stays 0.

The connection's laddr is global, so c_bound_if is 0. The message is
still delivered to the socket via:

rds_recv_incoming()->rds_find_bound(daddr, dport, conn->c_bound_if)

Does recvmsg() now report fe80::x with scope 0? rds_sendmsg() would
reject that address if it is used to reply. The same applies to the
connections that connect(fe80::x%ifA) followed by bind(global) can now
set up.

Using the bound scope as the sender's scope is older behavior. It also
affects unconnected global-bound sockets. The change in the connected
case comes from this patch, and the commit message doesn't mention it.

[ ... ]

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..9380b67675bdc 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1256,7 +1256,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  		lock_sock(sk);
>  		daddr = rs->rs_conn_addr;
>  		dport = rs->rs_conn_port;
> -		scope_id = rs->rs_bound_scope_id;
> +		scope_id = rs->rs_conn_scope_id;

[Severity: High]
Can this break destination-less sends on a socket that is bound to a
link-local address and connected to a global peer? For example,
bind(fe80::y%ifA) and connect(2001:db8::1), in either order.

rds_connect() now sets rs_conn_scope_id to 0 for the global peer. So a
send() with msg_namelen == 0 gets scope_id 0, where it used to get ifA
from rs_bound_scope_id.

Later in rds_sendmsg(), the fallback to the bound scope only runs when
namelen != 0:

	} else if (namelen != 0) {
		...
		if (scope_id != rs->rs_bound_scope_id) {
			if (!scope_id) {
				scope_id = rs->rs_bound_scope_id;
		...

So rds_conn_create_outgoing() is called with laddr fe80::y and dev_if
0, which sets both c_dev_if and c_bound_if to 0.
rds_tcp_conn_path_connect() then binds with:

		sin6.sin6_addr = conn->c_laddr;
		...
		sin6.sin6_scope_id = conn->c_dev_if;

__inet6_bind() rejects a link-local bind without an interface with
-EINVAL.

Wouldn't every reconnect attempt fail, leaving the connected socket's
data queued on a connection that never comes up?

sendto(2001:db8::1) on the same socket still works because it inherits
rs_bound_scope_id. That means the two send paths now pick different
connections for the same peer.

The later patch "net/rds: include the scope id in the sendmsg
connection cache check" only changes the rs_conn cache check. It
doesn't seem to address this.

Would something like this work instead?

		scope_id = rs->rs_conn_scope_id ?: rs->rs_bound_scope_id;

>  		release_sock(sk);
>  	}
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163526.250805-1-achender%40kernel.org
