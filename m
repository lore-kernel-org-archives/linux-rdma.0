Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47FC29C35A;
	Thu, 23 Jul 2026 04:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784780462; cv=none; b=PTlvB3dzyDbGYPJ/OtmzPn5aGDZOzteDLWjAlUe578V4NV78w9FmNpvqQKJ2lPgXRaspx4gDKQpt1K5lrwPoUouVmV2NAMgXBdMTH95ozIV1sfVIDagphlNXub9PNow4ee+A9cz5+tXrRxRcjJ6Rix6ckfPONm1mUssvH2cLBYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784780462; c=relaxed/simple;
	bh=NP/innA5oAXxnFzAIjF2IThRR4Dy8bwnW9G/qvluI8E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IWKm1MIDzcx/kXrJkSxHAZ120iJAH6LbgB7XF3Wn8hEnlw7Bzp9GgzMps/J0mJWdAUtlXWU1tVKih6aLq+ErwHrcKihCZ+2Tl0etayUbm/WWSFPaS0b2QJNRtbd0X4AiUnl+hY3qKruhNYnoerOu597Xbg/kaL1gx32oVOLi/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLevzrGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLevzrGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D141F000E9;
	Thu, 23 Jul 2026 04:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784780438;
	bh=86qxifGWe8W3EtGF643RPcAQY8IN7yq26qUJrWbDgLk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nLevzrGOl6bE0YzUJbUbhxfKIvZfpUabJrMr+YfQbbllVo6listVWh6qLc5IuSVjM
	 f01zwjTYVE2/i4DAtEsTuO0+NC2cj2tZvrgtqADJ1Kyko7Q/Mm4rxcoI+p8DIyTii3
	 HFZV1rm/sQXt3GxrlJOZvuMmIb7kjqVxKuo/Djx/vr3KnunI/a2Ii6GKGsVG8OnuHs
	 LUCwMwmfWUdXHF8yslowKcIn07LLtP88w2m1/T2kPzAEmWvnUsGJenk3RNda3x5MiA
	 QwjvyBNTV96VHyu/dgDN+5x43SB729CyGYWu43BhOqwMb48WhBiOo0ZR9cK52K406P
	 jRMGf1WxQLBeg==
Message-ID: <7768862e22c58c970e91010bbec21e9e2e3159ff.camel@kernel.org>
Subject: Re: [PATCH] rds: synchronize info callbacks with connection teardown
From: Allison Henderson <achender@kernel.org>
To: Chengfeng Ye <nicoyip.dev@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, 
 Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Dan Carpenter
 <error27@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Wed, 22 Jul 2026 21:20:37 -0700
In-Reply-To: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-21 at 02:49 +0800, Chengfeng Ye wrote:
> rds_info_getsockopt() reads an info callback without holding
> rds_info_lock across its invocation.  At the same time, rds_exit()
> destroys all connections before unregistering the socket info callbacks.
>=20
> This permits the following interleaving:
>=20
>   CPU0                              CPU1
>   rds_info_getsockopt()
>     func =3D rds6_sock_inc_info
>                                     rds_exit()
>                                       rds_conn_exit()
>                                         rds_conn_destroy()
>                                           kmem_cache_free(conn)
>     func()
>       rds6_inc_info_copy()
>         inc->i_conn->c_tos
>=20
> The receive queue lock keeps the incoming message on its socket queue,
> but it does not keep inc->i_conn alive.  KASAN reports:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
>   Read of size 1 at addr ffff888106031c50 by task poc/101
>   Call Trace:
>    rds6_inc_info_copy+0x459/0x530 [rds]
>    rds6_sock_inc_info+0x2b9/0x3c0 [rds]
>    rds_info_getsockopt+0x19d/0x380 [rds]
>    do_sock_getsockopt+0x2ac/0x480
>    __sys_getsockopt+0x128/0x210
>   Allocated by task 99:
>    kmem_cache_alloc_noprof+0x11a/0x360
>    __rds_conn_create+0x7e/0xd60 [rds]
>    rds_conn_create_outgoing+0x61/0x80 [rds]
>    rds_sendmsg+0xb83/0x1d00 [rds]
>   Freed by task 102:
>    kmem_cache_free+0x1b5/0x3d0
>    rds_conn_destroy+0x484/0x600 [rds]
>    rds_loop_exit_net+0x32/0x50 [rds]
>    unregister_pernet_device+0x2c/0x50
>    rds_conn_exit+0x13/0xa0 [rds]
>    rds_exit+0x1a/0xc40 [rds]
>    __do_sys_delete_module+0x30a/0x4d0
>=20
> Publish and clear callback pointers with SRCU, and keep the SRCU read-sid=
e
> critical section across callback execution. SRCU permits callbacks such a=
s
> RDS_INFO_COUNTERS to sleep, unlike classic RCU. After clearing a slot,
> synchronize_srcu() waits for every in-flight callback.
> Move socket callback deregistration ahead of protocol and connection
> teardown. This prevents callbacks from reaching a connection after it is
> freed.

Hi Chengfeng,

Thanks for the report and the patch, this is a great start. The UAF
analysis is correct, but there are a few bumps to smooth out before
this can go in.  First, the build bots caught some sparse errors that
need to be addressed:

https://netdev-ctrl.bots.linux.dev/logs/build/1131097/14698942/build_allmod=
config_warn/stderr

Sparse can't apply the __rcu notation through a function-pointer typedef,
so all of the rcu_*() macros trip over it.  The simplest fix is to drop
the __rcu annotation and just use smp_load_acquire/smp_store_release on
a plain array in register/deregister. Also, checkpatch warns about the
two BUG_ON()s you touched. We can clean those up by converting them to
a WARN_ON_ONCE().

On to the fix itself: this patch has two separate changes going on that
I think would be better done as two separate patches.  Comments below:


>=20
> Fixes: 7d0a06586b26 ("net/rds: Fix info leak in rds6_inc_info_copy()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> ---
>  net/rds/af_rds.c | 12 ++++++------
>  net/rds/info.c   | 20 ++++++++++++++------
>  2 files changed, 20 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e3..b3fe2bd6ea35 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c

First, the changes in af_rds.c changes don't quite work the way you might t=
hink.
net/rds builds as three separate modules: rds.ko, rds_tcp.ko and rds_rdma.k=
o.=20
rds_exit() only runs for "rmmod rds". rds_tcp_exit() only runs for "rmmod
rds_tcp".=C2=A0

"rmmod rds_tcp" deregisters RDS_INFO_TCP_SOCKETS, and then destroys and
frees all the TCP connections.  The rds module stays loaded with=20
RDS_INFO_RECV_MESSAGES still registered, so "rmmod rds_tcp" still reproduce=
s
the splat since rds_exit() never runs in that case. =20

Ideally what we want here is a ref counting infrastructure that isn't upstr=
eam
yet.  The good news is, I've been working on one, so I can push a tag for y=
ou to
base a revised fix on.=20

  https://github.com/allisonhenderson/rds_work/releases/tag/rds-conn-kref-b=
ase-v1

The branch may still see some review churn, but I'll leave this tag here fo=
r
you to base your fix on.  On top of it, the fix is just to make every holde=
r
of inc->i_conn own a reference.  Really what we're doing here is porting a
small UEK patch:

  https://github.com/oracle/linux-uek/commit/99b9a3715419

Upstream's assignment sites differ a little from UEK's, but basically the
idea is to use rds_conn_get() everywhere i_conn is assigned.=20

This can target net-next since every remaining trigger needs CAP_SYS_MODULE
or physical device removal.  So it isn't reachable by an unprivileged attac=
ker.

Once you've worked out the patch, I'll carry it with yourself as the author
as part of that series so it lands in the right order.  Alternately if you'=
d
rather not take on a port, that's fine too, just let me know and I would ta=
g
you for the Reported-by.


> @@ -925,6 +925,12 @@ static void rds6_sock_info(struct socket *sock, unsi=
gned int len,
>  static void rds_exit(void)
>  {
>  	sock_unregister(rds_family_ops.family);
> +	rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
> +	rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
> +	rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
> +#endif
>  	proto_unregister(&rds_proto);
>  	rds_conn_exit();
>  	rds_cong_exit();
> @@ -933,12 +939,6 @@ static void rds_exit(void)
>  	rds_stats_exit();
>  	rds_page_exit();
>  	rds_bind_lock_destroy();
> -	rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
> -	rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
> -	rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
> -#endif
>  }
>  module_exit(rds_exit);
> =20
> diff --git a/net/rds/info.c b/net/rds/info.c
> index 21b32eb16559..7d6f3552d65b 100644
> --- a/net/rds/info.c
> +++ b/net/rds/info.c

These SRCU conversions in info.c are actually fixing a completely separate =
bug=20
independent of the connections.   A getsockopt(RDS_INFO_TCP_SOCKETS)
racing against a "rmmod rds_tcp" could call the callback pointer of a freed
module. Which this patch fixes. So please resend the info.c changes
against net-next, with the build fixes, and a commit message describing
that race. =20

I think that about covers it.  Let me know if you get stuck or have questio=
ns

Thanks again, this was a good find.

Allison

> @@ -32,6 +32,7 @@
>   */
>  #include <linux/percpu.h>
>  #include <linux/seq_file.h>
> +#include <linux/srcu.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
>  #include <linux/export.h>
> @@ -68,8 +69,9 @@ struct rds_info_iterator {
>  	unsigned long offset;
>  };
> =20
> +DEFINE_STATIC_SRCU(rds_info_srcu);
>  static DEFINE_SPINLOCK(rds_info_lock);
> -static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
> +static rds_info_func __rcu rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST=
 + 1];
> =20
>  void rds_info_register_func(int optname, rds_info_func func)
>  {
> @@ -78,8 +80,8 @@ void rds_info_register_func(int optname, rds_info_func =
func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> =20
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset]);
> -	rds_info_funcs[offset] =3D func;
> +	BUG_ON(rcu_access_pointer(rds_info_funcs[offset]));
> +	rcu_assign_pointer(rds_info_funcs[offset], func);
>  	spin_unlock(&rds_info_lock);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_register_func);
> @@ -91,9 +93,10 @@ void rds_info_deregister_func(int optname, rds_info_fu=
nc func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> =20
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset] !=3D func);
> -	rds_info_funcs[offset] =3D NULL;
> +	BUG_ON(rcu_access_pointer(rds_info_funcs[offset]) !=3D func);
> +	RCU_INIT_POINTER(rds_info_funcs[offset], NULL);
>  	spin_unlock(&rds_info_lock);
> +	synchronize_srcu(&rds_info_srcu);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_deregister_func);
> =20
> @@ -165,6 +168,7 @@ int rds_info_getsockopt(struct socket *sock, int optn=
ame, sockopt_t *opt)
>  	int npages =3D 0;
>  	int ret;
>  	int len;
> +	int srcu_idx;
>  	int total;
> =20
>  	len =3D opt->optlen;
> @@ -214,8 +218,11 @@ int rds_info_getsockopt(struct socket *sock, int opt=
name, sockopt_t *opt)
>  	rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
> =20
>  call_func:
> -	func =3D rds_info_funcs[optname - RDS_INFO_FIRST];
> +	srcu_idx =3D srcu_read_lock(&rds_info_srcu);
> +	func =3D srcu_dereference(rds_info_funcs[optname - RDS_INFO_FIRST],
> +				&rds_info_srcu);
>  	if (!func) {
> +		srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  		ret =3D -ENOPROTOOPT;
>  		goto out;
>  	}
> @@ -225,6 +232,7 @@ int rds_info_getsockopt(struct socket *sock, int optn=
ame, sockopt_t *opt)
>  	iter.offset =3D offset0;
> =20
>  	func(sock, len, &iter, &lens);
> +	srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  	BUG_ON(lens.each =3D=3D 0);
> =20
>  	total =3D lens.nr * lens.each;

