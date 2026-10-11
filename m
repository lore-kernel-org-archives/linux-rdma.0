Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2AB421245;
	Sun, 11 Oct 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791708380; cv=none; b=CQnU4WPCNYEbSuI2wnvRpyBHJs4ZOGBAV9kHmxW5k4EvQLjEgk24PAfX6zD0fOprTyr1qj42xIxQO+Ui5o+439hp6QD39HXJocNyNsMZ3WxnC65tBGd0vhRvygIhXZwgRcX7XfjhJQbthYcsulHQRkWvtqrSEUQNIvyRAF0pFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791708380; c=relaxed/simple;
	bh=JXK4oSCpErPklpc7lLoKnemVgdcwS7et3wPxvHo68bk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EU52+xfeBL0GKeqJzXu1blern/1pE3OC/fNL2TWUbDoYq6shD/ov3uhIwEToEDDz88qhh2+1h1nkjbBlB97BN+zOA613cpcrRH+4OQsxEV+FVvPiLtljI3NQpdfqYw9+LmPhdoezMf9Z2I2plCN+aNqhs27VnSED04nqvbw0nts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XObUx/gw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XObUx/gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40E61F0089B;
	Sun, 11 Oct 2026 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791708378;
	bh=FYthYDxYDoOAgUYRAWkQ0GCdhoXr4bMX021KWI/g0l4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XObUx/gwFpLfOl4g6Ss5t9I77a8SxllPvTsONJgeUCLUJJU+ZXuTYa6UpZR8oT7+c
	 /sqXKyjlVCnowuCWp2wvklgrQXFZ3kIAHL4wcWFzfYzVosFao1eDyyXFDXbyOnxb+4
	 Vxy8kkIG2fwkdwcvyTEJKjItVufght8LrBGX710ZZuUdYm4xxnjQn7aOWcSJYvhfvL
	 xjZ8+QZavRE2m0sYrqST+vwJ6UqRH64S3Q+a+m0QIcQfXA3KhcRffAutPI33RY6Af6
	 JxnzqrXkwdECscqE+0BUrG1Z6aQ7xE4lOZrzKrz97OFyRXdg7I+TsiUHsnUvO/SFCI
	 /ly5AQbE9FQqQ==
Subject:
 Re: [PATCH net] rds: fix transport reference leak on rds_add_bound() failure
From: netdev-bot+sashiko@kernel.org
To: bsdhenrymartin@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 11 Oct 2026 08:46:17 +0000
Message-ID: <179170837722.434549.13971101110405723728@kernel.org>
In-Reply-To: <20261010081446.3112217-1-bsdhenrymartin@gmail.com>
References: <20261010081446.3112217-1-bsdhenrymartin@gmail.com>
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

Critical: 0 · High: 1 · Medium: 0 (3) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In rds_bind() (net/rds/bind.c:267-270), the new failure branch
  calls rds_trans_put(rs->rs_transport) while the socket is still live.

Pre-existing issues:
- [Medium] The SO_RDS_TRANSPORT once-only contract breaks after a failed
  bind.
- [Medium] rds_ioctl(SIOCRDSSETTOS) (af_rds.c:264-266) and
  rds_getsockopt(SO_RDS_TRANSPORT) (af_rds.c:525-526) read…
- [Medium] When rhashtable_insert_fast() fails, rds_add_bound() briefly
  sets rs->rs_bound_addr = *addr (bind.c:123) and then resets it…

--

rds: fix transport reference leak on rds_add_bound() failure

When rds_add_bound() fails, rds_bind() now drops the transport module
reference before it clears rs->rs_transport. Before this change, every
failed bind leaked one reference on the transport module (for example
rds_tcp), and the module could no longer be unloaded.

> diff --git a/net/rds/bind.c b/net/rds/bind.c
> index f800d920d9690..e4667b3128940 100644
> --- a/net/rds/bind.c
> +++ b/net/rds/bind.c
> @@ -264,8 +264,10 @@ int rds_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int addr_len)
>  
>  	sock_set_flag(sk, SOCK_RCU_FREE);
>  	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
> -	if (ret)
> +	if (ret) {
> +		rds_trans_put(rs->rs_transport);

[Severity: High]
Can this module_put() race with code on the same socket that reads
rs->rs_transport without a lock?

Before this patch, rds_release() was the only place that dropped the
transport module reference. No other syscall can be running on the
socket at that point.

With this change, the socket's only reference can be dropped while
rs->rs_transport is still set and other threads may already hold the
pointer. The pointer gets set either by setsockopt(SO_RDS_TRANSPORT) or
by rds_bind() itself, which assigns rs->rs_transport = trans before it
calls rds_add_bound().

Several readers use rs->rs_transport without lock_sock() and without
taking their own module reference:

net/rds/af_rds.c:rds_ioctl() {
    ...
		if (rs->rs_transport &&
		    rs->rs_transport->get_tos_map)
			tos = rs->rs_transport->get_tos_map(utos);
    ...
}

net/rds/af_rds.c:rds_getsockopt() {
    ...
		trans = (rs->rs_transport ? rs->rs_transport->t_type :
			 RDS_TRANS_NONE); /* unbound */
    ...
}

There is also __rds_rdma_map() in net/rds/rdma.c. It is reached through
RDS_GET_MR, which does not take lock_sock(). It stores rs->rs_transport
in mr->r_trans and calls ->get_mr().

A possible sequence:

CPU1                                  CPU0
rds_ioctl(SIOCRDSSETTOS)
  reads rs->rs_transport
                                      rds_bind()
                                        rds_add_bound() fails (port 1)
                                        rds_trans_put(rs->rs_transport)
                                          module_put(rds_tcp)
                                      rmmod rds_tcp frees the module
  rs->rs_transport->get_tos_map(utos)

At that point CPU1 reads the freed rds_tcp_transport and calls into
freed module text. This needs a concurrent rmmod, but making
"rmmod rds_tcp" possible again is the stated goal of the patch.

Would it work to keep the result of rds_trans_get_preferred() in a
local variable and assign rs->rs_transport only after rds_add_bound()
succeeds? On failure, only the local reference would be put. A
transport chosen with SO_RDS_TRANSPORT would stay attached and be
released in rds_release().

>  		rs->rs_transport = NULL;

[Severity: Medium]
This isn't a bug introduced by this patch, but should rs->rs_transport
be cleared here when the user picked the transport with
SO_RDS_TRANSPORT?

Documentation/networking/rds.rst says of SO_RDS_TRANSPORT:

    This socket option may only be set exactly once on the socket,
    prior to binding it via the bind(2) system call.

rds_set_transport() enforces this only with:

	if (rs->rs_transport)
		return -EOPNOTSUPP; /* previously attached to transport */

After a failed bind(), getsockopt(SO_RDS_TRANSPORT) returns
RDS_TRANS_NONE and a second setsockopt(SO_RDS_TRANSPORT) succeeds. If
the user simply retries bind(), it quietly uses
rds_trans_get_preferred() instead of the transport the user chose.

The NULL-out was added by commit 05733434ee9a ("net/rds: Check
laddr_check before calling it"). This patch keeps it as is.

[Severity: Medium]
This is a pre-existing issue, but can the unlocked readers see this
NULL store between their NULL check and their dereference?

rds_ioctl(SIOCRDSSETTOS) and rds_getsockopt(SO_RDS_TRANSPORT), quoted
above, read rs->rs_transport with plain loads and no lock_sock(). They
load it once for the NULL check and again for the dereference. This
store runs under lock_sock(), which those readers don't hold.

If the compiler emits two separate loads, a reader can pass the
non-NULL check, then see NULL and dereference NULL->get_tos_map or
NULL->t_type. The NULL-out also comes from commit 05733434ee9a.

[Severity: Medium]
This is also a pre-existing issue, but is there a similar window in
__rds_rdma_map()?

If rhashtable_insert_fast() fails, rds_add_bound() sets the bound
address for a moment and then resets it:

net/rds/bind.c:rds_add_bound() {
    ...
		rs->rs_bound_addr = *addr;
    ...
		} else {
			rs->rs_bound_addr = in6addr_any;
			rds_sock_put(rs);
			ret = -ENOMEM;
			break;
		}
    ...
}

rds_bind() then puts and clears rs->rs_transport. RDS_GET_MR and
RDS_GET_MR_FOR_DEST run without lock_sock(), so __rds_rdma_map() can
pass this check while the address is briefly set:

	if (ipv6_addr_any(&rs->rs_bound_addr) || !rs->rs_transport) {

Later, after calls that force the pointer to be loaded again, it does:

	trans_private = rs->rs_transport->get_mr(

That load can see NULL. __rds_rdma_map() can also store mr->r_trans for
a transport whose socket reference the failing bind then drops.

The window opens only when rhashtable_insert_fast() fails (-ENOMEM,
-EBUSY or -E2BIG), which an attacker cannot control. The NULL
dereference also needs a transport that has get_mr. The dropped module
reference part is the same race described in the first comment above.

> +	}
>  
>  out:
>  	release_sock(sk);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010081446.3112217-1-bsdhenrymartin%40gmail.com
