Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32CE19995E;
	Thu,  9 Jul 2026 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783611723; cv=none; b=NdgVrVEwmS/Szzu8Cd3MaC1Ow81abyPF06HqSJTWOKhcdOZA0v/59j+51gRsNN1fMreFfXvMD5x8rPmFJSZZmdsYjS9nusNhjMoA6kFw+s7yb3JyiK7IVqo7VmSYLs/WacHuP/1Qd9DZ5ctvHx3b+kRt3aZbLpia657J+j01pRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783611723; c=relaxed/simple;
	bh=ufCl8aMrAz1jL1B91IWldSlGiwDY2Gd3/+SS6EBFTho=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GZ31rNsSN2gCqtZB9u0l5e6SBUkz3b7+TV3ScsU9xyqQCH/VaRLvcB9I1z63+gweRpopVfxv6ruuhbcfsJ2TSXj/eQO5wHUUuKkDvYt6m3NaK6x3xmfMwXm8b6SLogUiHWzqWzeMXsk/hvPSk+wj0E3QXqfF6S+gFkA6MJKZDQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7PFOk++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7PFOk++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC601F000E9;
	Thu,  9 Jul 2026 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783611721;
	bh=rxQ6s6uIC1Xh4EK6Bix3qZbEKUNNeKF9f+msivycHww=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=R7PFOk++OXY0Hmgy4CIQn+jp2dY8n+Ca3VrhE1OOMsRicR2Fmtf5ckWlfDWBrBgAZ
	 w3cxOob/AJqA1wE/2qBFyVJKneP1GWncZaPivTDkkeI68Qec1Q2otGxtjXzPOn5iM3
	 A09qtIhcLvplOmSKPOLO9yc7qjGAu4ZtqV442+ZMZUInCjs1zf+Y9NKTn1jx8AjS/J
	 VEepHxH9BIvKuuLILgGJ73luCZxz7TvW9jlMhKlfoVQosu0D789h7/ChIIdpvr8+sw
	 9VJxqFDbEk/trsztJO3W7lF1xh1k0a4aYRO0BRBdOUJ1ksVh6E0FqtQfzFq8+uZ6qT
	 DOkptDCFxjHUw==
Message-ID: <a724cf77f2338776f44b465a25009c22a0ee7c43.camel@kernel.org>
Subject: Re: [PATCH net] rds: Fix inet6_addr_lst NULL dereference when IPv6
 is disabled
From: Allison Henderson <achender@kernel.org>
To: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Ka-Cheong Poon
 <ka-cheong.poon@oracle.com>, Santosh Shilimkar
 <santosh.shilimkar@oracle.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>,  "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "rds-devel@oss.oracle.com"
 <rds-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
 <lvc-project@linuxtesting.org>
Date: Thu, 09 Jul 2026 08:41:59 -0700
In-Reply-To: <20260708115922.2226279-1-Ilia.Gavrilov@infotecs.ru>
References: <20260708115922.2226279-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-08 at 11:59 +0000, Ilia Gavrilov wrote:
> When booting with the 'ipv6.disable=3D1' parameter, inet6_addr_lst
> is never initialized because inet6_init() exits before addrconf_init()
> is called to initialize it. An attempt to bind an RDS socket to
> an ipv6 address results in a crash in __ipv6_chk_addr_and_flags()

Hello Ilia,

Thanks for the catch.  Some comments below:

>=20
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:__ipv6_chk_addr_and_flags+0x1df/0x7e0
> Call Trace:
>  <TASK>
>  ipv6_chk_addr+0x3b/0x50
>  rds_tcp_laddr_check+0x155/0x3b0 [rds_tcp]
>  rds_trans_get_preferred+0x15d/0x2d0 [rds]
>  ? trace_hardirqs_on+0x2d/0x110
>  rds_bind+0x1433/0x1d60 [rds]
>  ? rds_remove_bound+0xd50/0xd50 [rds]
>  ? aa_af_perm+0x250/0x250
>  ? __might_fault+0xde/0x190
>  ? __sys_bind+0x1dc/0x210
>  __sys_bind+0x1dc/0x210
>  ? __ia32_sys_socketpair+0x100/0x100
>  ? restore_fpregs_from_fpstate+0x53/0x100
>  __x64_sys_bind+0x73/0xb0
>  ? syscall_enter_from_user_mode+0x1c/0x50
>  do_syscall_64+0x34/0x80
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> RIP: 0033:0x7f47f8269ea9
>  </TASK>
>=20
> The following code reproduces the issue:
>=20
> struct sockaddr_in6 addr;
> s =3D socket(PF_RDS, SOCK_SEQPACKET, 0);
>=20
> memset(&addr, 0, sizeof(addr));
> inet_pton(AF_INET6, ADDRESS, &addr.sin6_addr);
> addr.sin6_family =3D AF_INET6;
> addr.sin6_port =3D htons(PORT);
>=20
> bind(s, &addr, sizeof(addr);
nit: missing paren here

>=20
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with Syzkaller.
>=20
> Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to=
 struct in6_addr")
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
>  net/rds/ib.c  | 4 ++++
>  net/rds/tcp.c | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 39f87272e071..8f9cf491984f 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -429,6 +429,10 @@ static int rds_ib_laddr_check_cm(struct net *net, co=
nst struct in6_addr *addr,
>  		sa =3D (struct sockaddr *)&sin;
>  	} else {
>  #if IS_ENABLED(CONFIG_IPV6)
> +		if (!ipv6_mod_enabled()) {
> +			ret =3D -EADDRNOTAVAIL;
> +			goto out;
> +		}
>  		memset(&sin6, 0, sizeof(sin6));
>  		sin6.sin6_family =3D AF_INET6;
>  		sin6.sin6_addr =3D *addr;
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index a1de114d5e2e..955d92277d5a 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -366,9 +366,11 @@ int rds_tcp_laddr_check(struct net *net, const struc=
t in6_addr *addr,
>  		rcu_read_unlock();
>  	}
>  #if IS_ENABLED(CONFIG_IPV6)
> -	ret =3D ipv6_chk_addr(net, addr, dev, 0);
> -	if (ret)
> -		return 0;
> +	if (ipv6_mod_enabled()) {
> +		ret =3D ipv6_chk_addr(net, addr, dev, 0);
> +		if (ret)
> +			return 0;
> +	}

There's another ipv6_chk_addr() in __rds_find_ifindex() with the same issue=
 that affects inbound link-local IPv6
connects.  Can you add a similar guard there too?  Then I think that should=
 cover all the points of exposure.  Thanks
for working on this.

Allison

>  #endif
>  	return -EADDRNOTAVAIL;
>  }

