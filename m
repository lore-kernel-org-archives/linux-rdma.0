Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FEE33B97B
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 16:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131740; cv=none; b=u/vvsZQGMC3ZttjlodoHpOG9NdYP69vXwQYCTJo4BZIPl12h0YOGEfWrx92WxsPY2swVyQkE8GSAqimBuWFeMN7B/s6C/uh+uXHiEKh2mA7mbLaq3BfgxlIRygElmaTJoQJqJYMAbMD6DFVKONgop8k51UcrFnCmyzFEAKBV/uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131740; c=relaxed/simple;
	bh=ATo0HMxkBPq5Qnz1KQQhyyL43trHwElfuupWQWpqsc8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LNvuZl5BDbQcpmRdK4KMMi060mDMvmZB1DlFVTTvXUshKK1b6IvF+ee8MSERtAUGBMJofWFNclKP2S+aDf07I8Bxw9H1oU3YFNKZkyo+La5bSfTGTQi/mP+px0z6I+U279NOb+yjrRXD9QMiVfVSKjl5/ff5iOTt1N32Hqt0TUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcN628/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcN628/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D571F000FF;
	Sun,  4 Oct 2026 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131739;
	bh=ZMk+gbn+ZFw9b4rHGeQQgPGSwhITdkQ3RbefG/4VtcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dcN628/I44ezHNkXNhqqHj39+qzKXj28MUgYzhZ4IZAartZB6JC+YihXnK8UK7r0k
	 4STGqgMFfm5cD6AWg4bNBlXD89I89HAoBg2e8WRbOxHhcRyq/Ddn9zdqojPXSeA0NX
	 C3ZX2pbvU1/1bQVgpmXGqAobrSVAOIRhcM5V/wM/3fJ9kK/ibupnLZhP5ImTsZHAie
	 Jh6Kv0KiQRlyPG4gOghjI4MLl9c/un9ixY7E8f7b40PUXNkzeXKrHwq/oEbeaF/Y46
	 2UnwfdVmyT+MN7IDSYdus4j8PvYVPrMkQd1gro+ywtX/nQ+bJYfpjnEI1a9vaVG7a/
	 CBS6ykM5ltDJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 1/2] net/rds: keep the connected peer's scope id
 apart from the bound one
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163526.250805-2-achender@kernel.org>
References: <20261003163526.250805-1-achender@kernel.org>
 <20261003163526.250805-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 16:35:38 +0000
Message-Id: <20261004163539.67D571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rds: getname() and recvmsg() break IPv6 link-local scope ID
- [High] rds: destination-less sendmsg() fails for global dests if bound li=
nk-local
--

commit 898dc27ebfe8db635a3eb7a78c44763fbfcf0c43
Author: Allison Henderson <achender@kernel.org>

net/rds: keep the connected peer's scope id apart from the bound one

This commit isolates the connected peer's scope ID into a new
rs_conn_scope_id field, leaving the bound scope ID in
rs_bound_scope_id alone. It updates rds_connect(), rds_bind(), and
rds_sendmsg() to use the new field to ensure destination-less sends
and link-local binds operate with the correct interface scopes.

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..ba726782addf7 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c
[ ... ]
> @@ -616,11 +617,14 @@ static int rds_connect(struct socket *sock, struct =
sockaddr_unsized *uaddr,
>  				ret =3D -EINVAL;
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
> -			rs->rs_bound_scope_id =3D sin6->sin6_scope_id;
> +			rs->rs_conn_scope_id =3D sin6->sin6_scope_id;

[Severity: High]
Does this change miss updating rds_getname() and rds_recvmsg()?

By no longer storing the peer's scope ID in rs->rs_bound_scope_id,
userspace programs calling getpeername() or receiving messages via recvmsg()
may receive a scope ID of 0 for connected link-local peers when the
local socket is unbound or globally bound.

For example, rds_getname() appears to still populate the address using
the bound scope:

net/rds/af_rds.c:rds_getname() {
    ...
    sin6->sin6_scope_id =3D rs->rs_bound_scope_id;
    ...
}

Similarly in rds_recvmsg():

net/rds/recv.c:rds_recvmsg() {
    ...
    sin6->sin6_scope_id =3D rs->rs_bound_scope_id;
    ...
}

Could this prevent userspace from properly parsing the address or
sending replies to the correct interface?

> +		} else {
> +			rs->rs_conn_scope_id =3D 0;
>  		}
>  		rs->rs_conn_addr =3D sin6->sin6_addr;
>  		rs->rs_conn_port =3D sin6->sin6_port;
[ ... ]
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..9380b67675bdc 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1256,7 +1256,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr =
*msg, size_t payload_len)
>  		lock_sock(sk);
>  		daddr =3D rs->rs_conn_addr;
>  		dport =3D rs->rs_conn_port;
> -		scope_id =3D rs->rs_bound_scope_id;
> +		scope_id =3D rs->rs_conn_scope_id;
>  		release_sock(sk);
>  	}
> =20

[Severity: High]
Does this cause destination-less sendmsg() calls to bypass the bound
scope fallback for global connections?

If an RDS socket is bound to an IPv6 link-local address (with a valid
scope) and connected to a global IPv6 address, a destination-less
sendmsg() will have namelen =3D=3D 0.

It looks like it will assign scope_id from rs_conn_scope_id (which is
0 for global peers), but then skip the fallback logic entirely:

net/rds/send.c:rds_sendmsg() {
    ...
    } else {
        /* We only care about consistency with ->connect() */
        ...
        scope_id =3D rs->rs_conn_scope_id;
    }

    lock_sock(sk);
    if (ipv6_addr_any(&rs->rs_bound_addr) || ipv6_addr_any(&daddr)) {
        ...
    } else if (namelen !=3D 0) {
        ...
        if (scope_id !=3D rs->rs_bound_scope_id) {
            if (!scope_id) {
                scope_id =3D rs->rs_bound_scope_id;
    ...
}

Because the fallback logic is inside the else if (namelen !=3D 0) block,
scope_id remains 0. The connection could then be created with a dev_if
of 0, causing the TCP transport to attempt a kernel_bind() to a
link-local source address with no scope ID, which the IPv6 stack will
reject.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163526.2508=
05-1-achender@kernel.org?part=3D1
