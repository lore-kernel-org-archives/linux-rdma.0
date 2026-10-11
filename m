Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9D33FE09
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791706528; cv=none; b=DnlUiaHxHdj/l0qDoLQKNY33aCzGQuG+RlJQ0a65H3NkZjM5KJyZkIWcR+VXPG5z3ZgZ9NEoRQj9piAseGhQzK/vtipBo0vGpjYWck6TK+WszvECECBWzWkaosmAcO+mqw0/Byri2oUei/L9bTawaEXIhGU/Bj41K0C6OXKOnY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791706528; c=relaxed/simple;
	bh=zORDfiI7JrsBdbGivHYsTcceEewi6fe0esXjimpicaE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DZc1XEtm16gUO3yez8ryco/m048cg3eq4lFCLvoNfy/dzPG16xOnyvswFBg6dDBFiuqwZiaXqSBY6FBrmXNOSeq46S6i8u6RMkHB5Hdm/ptmjkVvGrFcwn+bXk1orYfUvqcEEts2fpYjJsvzccnaivrNezwaXAByG8PaybRUEj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmweMocc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmweMocc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC8B1F0089B;
	Sun, 11 Oct 2026 08:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791706527;
	bh=VY8RAk/ih9/SyslTAxDC6ct0dkce/iJ+CAvG1wbDizc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmweMoccaD3769ucPnr1modBbUIljSHssxfQftaKRqSjA9EVbki5lB+ekhAfbY7vl
	 r7NRYFxE0P92mD3a1K1BqPecxY8HuxcNJVYELe75VSPrFbCFwt7Ivnr7YPOOler+m8
	 sKmCntIIJFBM/Z36EUj0wj0kUk6/fL9gKLU34ZeTyQ4aXvRL3pgTYkRniH/T7uvv11
	 KAtMnSN/9mDy/cSzpKUJzYSkB5mc5z1sLCGQPChjTWCFeUMK8RyCQKOjZRA+QVsi+e
	 crpK9Gw7aml/WXmYhcj1HnanSL5GPcRwPiWCyylgE128iju2rQ31MOB0ljSOYcAF2Z
	 ZWC3FihcNaH+w==
Message-ID: <sashiko-outbox-167121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] rds: fix transport reference leak on
 rds_add_bound() failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010081446.3112217-1-bsdhenrymartin@gmail.com>
References: <20261010081446.3112217-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:15:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/rds: explicit SO_RDS_TRANSPORT socket option is unpinned on =
transient bind failure
--

commit e657dc28c34c2b6450919388879a26bad7d1e8e5
Author: Henry Martin <bsdhenrymartin@gmail.com>

rds: fix transport reference leak on rds_add_bound() failure

This commit fixes a transport reference leak in rds_bind() when rds_add_bou=
nd()
fails. It drops the reference via rds_trans_put() and sets rs->rs_transport
to NULL in the failure branch.

> diff --git a/net/rds/bind.c b/net/rds/bind.c
> index f800d920d9690..e4667b3128940 100644
> --- a/net/rds/bind.c
> +++ b/net/rds/bind.c
> @@ -264,8 +264,10 @@ int rds_bind(struct socket *sock, struct sockaddr_un=
sized *uaddr, int addr_len)
> =20
>  	sock_set_flag(sk, SOCK_RCU_FREE);
>  	ret =3D rds_add_bound(rs, binding_addr, &port, scope_id);
> -	if (ret)
> +	if (ret) {
> +		rds_trans_put(rs->rs_transport);
>  		rs->rs_transport =3D NULL;
> +	}

[Severity: Medium]
When an explicit transport is configured via setsockopt(SO_RDS_TRANSPORT),
rs->rs_transport is pinned.

If a subsequent bind() fails due to an incompatible address, laddr_check()
fails and returns -ENOPROTOOPT early, which skips the teardown block and
correctly preserves rs->rs_transport.

However, if bind() fails transiently because the port is already in use
(-EADDRINUSE from rds_add_bound()), the modified error path unconditionally
calls rds_trans_put() and clears rs->rs_transport.

Does this destroy the user's explicitly configured socket state on a
transient error, requiring them to silently re-apply the sockopt?

Could we avoid putting and clearing the transport here if it was explicitly
configured prior to calling rds_bind()?

> =20
>  out:
>  	release_sock(sk);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010081446.3112=
217-1-bsdhenrymartin@gmail.com?part=3D1
