Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E962361DD2;
	Fri, 10 Jul 2026 04:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783658533; cv=none; b=KAn8Fifv+nZBsMcWUreQfe4asaCNrsGnC1qP9JCC+2CeAa2opSc+pPh81FVZgq1Z2FFp6MmireBF+BxxpyydGFPgvtmUw+Cx/nYprs4rQ9HXmbYVtnztE67M6SsLi2inqufkLLNxKyUkM4FStpzVLxQL4XZwXK6gtLCFvOsHRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783658533; c=relaxed/simple;
	bh=ysCIE+7OTDFivq+eC9/dneubsAEEQD8AJYtTVNUhGUk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XBuJCXLmoKjCMj8xWC3KKJ7s5cQbmYkXI5W6tEjUkJJwgyv1Zi5qN/RR+32wogm+P9qRHtmrdx/4FJo5C3MiRC6yZT0P/K7VIAlAbnGbCduWLG517T80/hMTCTuQYhR93XG6OI9r+dgGh29aSSQeLJXSlm9BMmCMVkGuuY7KB9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxItPC0n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxItPC0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7A91F000E9;
	Fri, 10 Jul 2026 04:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783658532;
	bh=+qz1u5zE5BcYslc68Rm+lzq2yD1cheQXAEtCOD5tZDo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MxItPC0nBx1h2Nmztwu40K5kaGtNgIH/SrgcJsqRXQJCJkGtTgCl0ySZ/TY3lAIFt
	 Gh1vfYOGv8D0ActcVZoqh/pdraJxNRgXGVJKYgDdL4RcP4mqk4rZakzzypi40DDI+U
	 5WUSTgMPDJW/QqA9CK+3dMTPCxOZ4F6TF7Rd4yTORuM+/FQcU42ZWknqGO2ehg/w5o
	 A8qUmrC93n500T9+VkXhnrM1ZMFI2iSTQAG7diZKWuszg4Ku8tTa7VqOBx8C3FnZzO
	 UYayUPotGa+RUy0GzirOjUC0aKH5Od/CzrDl9VXEZe1F1/uthfbFFkZbv/YVqe8iZr
	 FAAPnyXCyDFKA==
Message-ID: <e7c19015d10439cea2ff78e57a93a610c12e52b0.camel@kernel.org>
Subject: Re: [PATCH net] rds: tcp: hold the net_device across
 ipv6_chk_addr() in rds_tcp_laddr_check()
From: Allison Henderson <achender@kernel.org>
To: Xiang Mei <xmei5@asu.edu>, "David S . Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Santosh Shilimkar
 <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
  bestswngs@gmail.com
Date: Thu, 09 Jul 2026 21:42:10 -0700
In-Reply-To: <20260709074459.326345-1-xmei5@asu.edu>
References: <20260709074459.326345-1-xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-09 at 00:44 -0700, Xiang Mei wrote:
> rds_tcp_laddr_check() looks up a scoped IPv6 interface with
> dev_get_by_index_rcu(), drops the RCU read-side lock, and only then
> passes the bare struct net_device * into ipv6_chk_addr().
>=20
> dev_get_by_index_rcu() only keeps the device alive within the same RCU
> read-side section. After rcu_read_unlock(), a concurrent RTM_DELLINK can
> free the net_device; ipv6_chk_addr() then dereferences the stale pointer
> in __ipv6_chk_addr_and_flags() (e.g. l3mdev_master_dev_rcu(dev)), reading
> freed memory.
>=20
> Take a reference with dev_hold() before dropping the RCU lock and release
> it with dev_put() after ipv6_chk_addr(), so the device cannot be freed
> while in use. dev_put(NULL) is a no-op, so the scope_id =3D=3D 0 path is
> unaffected.
>=20
>   BUG: KASAN: slab-use-after-free in __ipv6_chk_addr_and_flags (... net/i=
pv6/addrconf.c:1998)
>   Read of size 8 at addr ffff8880106ec000 by task exploit/153
>   Call Trace:
>    ...
>    kasan_report (mm/kasan/report.c:595)
>    __ipv6_chk_addr_and_flags (... net/ipv6/addrconf.c:1998)
>    ipv6_chk_addr (net/ipv6/addrconf.c:2031 net/ipv6/addrconf.c:1972)
>    rds_tcp_laddr_check (net/rds/tcp.c:370)
>    rds_bind (net/rds/bind.c:248)
>    __sys_bind (net/socket.c:1920)
>    __x64_sys_bind (net/socket.c:1956)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:63)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>=20
> Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to=
 struct in6_addr")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/rds/tcp.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index a1de114d5e2e..204dcdc33c27 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -363,12 +363,16 @@ int rds_tcp_laddr_check(struct net *net, const stru=
ct in6_addr *addr,
>  			rcu_read_unlock();
>  			return -EADDRNOTAVAIL;
>  		}
> +		dev_hold(dev);
>  		rcu_read_unlock();
>  	}
>  #if IS_ENABLED(CONFIG_IPV6)
>  	ret =3D ipv6_chk_addr(net, addr, dev, 0);
> +	dev_put(dev);
Hi Xiang,

Thanks for working on this.  It looks like this patch generated
some CI warnings for dev_hold/put that should be addressed:
https://patchwork.kernel.org/project/netdevbpf/patch/20260709074459.326345-=
1-xmei5@asu.edu/

Per the comments from include/linux/netdevice.h:4546, netdev_hold/put
replaced dev_hold/put, which takes a netdevice_tracker pointer. =C2=A0But I
think the easier way to do this may be just to widen the rcu locks already
in this function.  Just move rcu_read_lock(); above the scope_id check,
and make sure it's released before any returns.  That should get away from=
=C2=A0
having to use the hold/puts all together.

	rcu_read_lock();
	if (scope_id !=3D 0) {
		dev =3D dev_get_by_index_rcu(net, scope_id);
		if (!dev) {
			rcu_read_unlock();
			return -EADDRNOTAVAIL;
		}
	}
#if IS_ENABLED(CONFIG_IPV6)
	ret =3D ipv6_chk_addr(net, addr, dev, 0);
	if (ret) {
		rcu_read_unlock();
		return 0;
	}
#endif
	rcu_read_unlock();
	return -EADDRNOTAVAIL;

Also, this patch conflicts with another submitted patch:=C2=A0
[net,v2] rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled:
https://patchwork.kernel.org/project/netdevbpf/patch/20260709162723.367523-=
1-Ilia.Gavrilov@infotecs.ru/

So, please rebase on Ilia's v2, and mention the dependency in your change=
=C2=A0
log so the stable folks pick them up in the right order.  Both fixes carry=
=C2=A0
the same Fixes: tag so they should travel together.

Thank you!
Allison

>  	if (ret)
>  		return 0;
> +#else
> +	dev_put(dev);
>  #endif
>  	return -EADDRNOTAVAIL;
>  }

