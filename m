Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3235DD1C
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822451; cv=pass; b=nSTSimsvH873MPZMwm6qKKU3K4UDu5GjCXLPo82bFpnAGy7WEoWO9NYIT7Y3EzktRNuZiZRaBV1FGaUvnRkrkiuwQPAeVWhCvTMk3iY9NnUUdeu30BINeCwV9wmfoATwVzCJJDPavXHt51hH4srK6AvGEGoyDJEvKBHdYoJMuTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822451; c=relaxed/simple;
	bh=mIOcMnGznkpO+pE9gOqEYAx4YJiEu4JTwR9t6IvJgV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=On8oy5ipCCAajnOYzIM1Ot5sPW2l/xWrwqf2f5sbHbkQ7S0ZzojkdxwUnJf7zBwEGq0HQc/ysPq3jpa660cednxnxJ2HlBNgGlp91V0kYQdhXQTPDBi5uOj3USt4XdwSv9uGTh67bxbg3QLWXiKpKGnDSAkev6D0OciBwpqTUFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhHCnkij; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhHCnkij"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698bf274b3fso198503a12.0
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 09:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784822445; cv=none;
        d=google.com; s=arc-20260327;
        b=UEoC72Of7WujGHKBJGDnjD47Lte+LILUE/TXr5Hsd27iu5TI+Q00LXQNhT7g/4HpSA
         p+lTiQZmnYJa7YEx8s71h/aLLEJ38o1/zZcKUvV6JijGVnGCOUWY7fz6H/YDVHoUJsgV
         HA3skUvvsJeVGtV5uM4bx5pEMmQ/fSkJOgnKVTBiV0FUZxINZ7dlo+PI2yr6Vpqm7uG7
         /x+mX7XpHA4Cusscop5Z7D9dimDcOkh/pbCoKrN3H01fgkIxtvmjA++39by4QUN3A/VI
         dvQBhpY/TT1szb/31xZokH1iBiRbchheynzdY1i+Iw7B3hqfrdThFfpDbURnZM0pJhZX
         X0CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j0HaNjjaDZuGEqReUR04EN3HbORPAqBe347i5g2FRzw=;
        fh=HUwc080aAB1D5TNawUEjdk072vFiAgLFMW7Ns24/n7A=;
        b=T6q5ZVDuFhjsem+dA6eQkAvNnrSwEhtISPjKL3pmntf3t7AY3vjTyfR5kWRimEW/au
         HBeKVjipJA15ZwRjURRW2gdpJqFTx2PXKFuk8pwRgVSke/J23F8VrxFMwyPFu+LbFliL
         kz8F15kERgvsHsbfDKg5pZC0NslMLUIzOZnrN09y50bg8RwQHXxSBLrj2vqJ/86Z6R5W
         mB80FBY80tnYwvzZ5tPH5ElIq8i7ozbV/ZfVrKprlPasHotX42ED5NVEeA6DgMPz7ClF
         ZVKT3XYlTPOj7/w3US8xdP4CmBrrF+ELg8PUENDafz/fu4KZbd/f48e63dkf2iEoddDS
         fdqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784822445; x=1785427245; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j0HaNjjaDZuGEqReUR04EN3HbORPAqBe347i5g2FRzw=;
        b=NhHCnkijesLh9GzDO3sSS/jvzc+ZGwcU/LG241p36pRx3Ad0m+N/kqrXZaAiQInuYv
         a2KvGEwJysHoWhAmwUGjUW+D3DB9UzO9a5Frl5XKlzeyUfM3k6ZGr+HgJmv+1xME1uLS
         /WW2vuiRKJIqBHrEqqQ9+T2Z39gzWdxMsQd+A8qhJ9/B7C83YBZT2ekA+czZvRTm+Yo7
         galfgGIkq0EMYwgv8SJPa0libJJKs1GS1qXnP3/dhARNmK7p8r3LT/EPHNjVzwxoX4HK
         5TqQFuNzeKu4XKYMqQOEZO90vtPL7Mu95MAw79xvFY4o3EXeg2BUNLG3wkF0psHwURKg
         lt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784822445; x=1785427245;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j0HaNjjaDZuGEqReUR04EN3HbORPAqBe347i5g2FRzw=;
        b=Dz/ftrn2N8vp9tgzOMaemxmDi/pOzUDTnpQ9dvYEv3rNBLqQmFDTrE5pzPiNBCbbF+
         ZDSwgaBILzN1peDf2EX20VJDDpmkWvT8A061pfGR5PswXovPUojn0ebmfWp6RkMtTOwB
         nQXLzcZuR1OPZWii25IBASJwULPbiLJCiJMV+C5TCglqDiIzZayldry3c3S4502WDRWP
         5RYSy8JteYfwIduBmI5tUZN/djqxdTlugpnwRM/tNJ7OpbpH0pC8jU/ZYc2q3ku3VcUY
         +GSWhcydFvMxkpcAHvNOqeRm03ICgIPRroXEbHVxWj79fuVbMssUP2F8o7GdCv2kjQa5
         mw9A==
X-Forwarded-Encrypted: i=1; AHgh+Rqnz5tAUw6WrqXIAMWmm9S0pYW9xZERhC7vQ1Budd1dCEFrwGxkoRz7o+uo9V5LWXI5yKJpGCGv5AYJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyXi+v1IhQasl2nOq4OojuVCSoFRHKcIRvsSfyYmKm6dZdRLjmg
	2kEqUkObk45So2gC4uNsN0/ikpNj200OL3SN1Q28UQcdeT8+gLEwuDGdiZThZMjFupvr7WV/2Lx
	5mxrcesBB6oR0blzop9eublNiALjzT7s=
X-Gm-Gg: AR+sD11FoxXU0HrlytkxIpOeQI7sq1/bRhL4QQRgLdQXHDBXq9tvFBDWgk/sKD+AIEn
	vVB0wiwtHq9YgsvE1ucJEwqLeJeGizbsYbVjoSWK6H/et9uqwGPAEWl0GE4TUHoXL1RE1SeIyJ+
	B4ACHaU9iSgTGESA0xGvlKIcBnUfsSWC6YHiqfQu1GTCSihsjHwHjIoid06fVtmYyzYouR0FP8S
	LkXae+TfTXj+tt5Z1ig07lTM/ljYlYvWBIyDm8x10EaQQUQ1qhNK4cTdvMGx5mxPV3xOEWhZVpC
	d0sFJ2cgxIseDv0=
X-Received: by 2002:a05:6402:24a4:b0:69e:990f:5cb7 with SMTP id
 4fb4d7f45d1cf-69f8ddbc2ccmr47193a12.6.1784822444460; Thu, 23 Jul 2026
 09:00:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com> <7768862e22c58c970e91010bbec21e9e2e3159ff.camel@kernel.org>
In-Reply-To: <7768862e22c58c970e91010bbec21e9e2e3159ff.camel@kernel.org>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Fri, 24 Jul 2026 00:00:32 +0800
X-Gm-Features: AUfX_mx9x_VSsTI5YGFbZxngUlzZTWfQdpdUq_aauOljCi50sgNtunnA8pBPZhw
Message-ID: <CAAo+4rWJFMLQXmzmf-Ons9TjEGzit_ChmKsCrEMhJ1Zn2rgsOA@mail.gmail.com>
Subject: Re: [PATCH] rds: synchronize info callbacks with connection teardown
To: Allison Henderson <achender@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Santosh Shilimkar <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, 
	Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 12:20=E2=80=AFPM Allison Henderson <achender@kernel=
.org> wrote:
>
> On Tue, 2026-07-21 at 02:49 +0800, Chengfeng Ye wrote:
> > rds_info_getsockopt() reads an info callback without holding
> > rds_info_lock across its invocation.  At the same time, rds_exit()
> > destroys all connections before unregistering the socket info callbacks=
.
> >
> > This permits the following interleaving:
> >
> >   CPU0                              CPU1
> >   rds_info_getsockopt()
> >     func =3D rds6_sock_inc_info
> >                                     rds_exit()
> >                                       rds_conn_exit()
> >                                         rds_conn_destroy()
> >                                           kmem_cache_free(conn)
> >     func()
> >       rds6_inc_info_copy()
> >         inc->i_conn->c_tos
> >
> > The receive queue lock keeps the incoming message on its socket queue,
> > but it does not keep inc->i_conn alive.  KASAN reports:
> >
> >   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rd=
s]
> >   Read of size 1 at addr ffff888106031c50 by task poc/101
> >   Call Trace:
> >    rds6_inc_info_copy+0x459/0x530 [rds]
> >    rds6_sock_inc_info+0x2b9/0x3c0 [rds]
> >    rds_info_getsockopt+0x19d/0x380 [rds]
> >    do_sock_getsockopt+0x2ac/0x480
> >    __sys_getsockopt+0x128/0x210
> >   Allocated by task 99:
> >    kmem_cache_alloc_noprof+0x11a/0x360
> >    __rds_conn_create+0x7e/0xd60 [rds]
> >    rds_conn_create_outgoing+0x61/0x80 [rds]
> >    rds_sendmsg+0xb83/0x1d00 [rds]
> >   Freed by task 102:
> >    kmem_cache_free+0x1b5/0x3d0
> >    rds_conn_destroy+0x484/0x600 [rds]
> >    rds_loop_exit_net+0x32/0x50 [rds]
> >    unregister_pernet_device+0x2c/0x50
> >    rds_conn_exit+0x13/0xa0 [rds]
> >    rds_exit+0x1a/0xc40 [rds]
> >    __do_sys_delete_module+0x30a/0x4d0
> >
> > Publish and clear callback pointers with SRCU, and keep the SRCU read-s=
ide
> > critical section across callback execution. SRCU permits callbacks such=
 as
> > RDS_INFO_COUNTERS to sleep, unlike classic RCU. After clearing a slot,
> > synchronize_srcu() waits for every in-flight callback.
> > Move socket callback deregistration ahead of protocol and connection
> > teardown. This prevents callbacks from reaching a connection after it i=
s
> > freed.
>
> Hi Chengfeng,
>
> Thanks for the report and the patch, this is a great start. The UAF
> analysis is correct, but there are a few bumps to smooth out before
> this can go in.  First, the build bots caught some sparse errors that
> need to be addressed:
>
> https://netdev-ctrl.bots.linux.dev/logs/build/1131097/14698942/build_allm=
odconfig_warn/stderr
>
> Sparse can't apply the __rcu notation through a function-pointer typedef,
> so all of the rcu_*() macros trip over it.  The simplest fix is to drop
> the __rcu annotation and just use smp_load_acquire/smp_store_release on
> a plain array in register/deregister. Also, checkpatch warns about the
> two BUG_ON()s you touched. We can clean those up by converting them to
> a WARN_ON_ONCE().
>
> On to the fix itself: this patch has two separate changes going on that
> I think would be better done as two separate patches.  Comments below:
>
>
> >
> > Fixes: 7d0a06586b26 ("net/rds: Fix info leak in rds6_inc_info_copy()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> > ---
> >  net/rds/af_rds.c | 12 ++++++------
> >  net/rds/info.c   | 20 ++++++++++++++------
> >  2 files changed, 20 insertions(+), 12 deletions(-)
> >
> > diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> > index d5defe9172e3..b3fe2bd6ea35 100644
> > --- a/net/rds/af_rds.c
> > +++ b/net/rds/af_rds.c
>
> First, the changes in af_rds.c changes don't quite work the way you might=
 think.
> net/rds builds as three separate modules: rds.ko, rds_tcp.ko and rds_rdma=
.ko.
> rds_exit() only runs for "rmmod rds". rds_tcp_exit() only runs for "rmmod
> rds_tcp".
>
> "rmmod rds_tcp" deregisters RDS_INFO_TCP_SOCKETS, and then destroys and
> frees all the TCP connections.  The rds module stays loaded with
> RDS_INFO_RECV_MESSAGES still registered, so "rmmod rds_tcp" still reprodu=
ces
> the splat since rds_exit() never runs in that case.
>
> Ideally what we want here is a ref counting infrastructure that isn't ups=
tream
> yet.  The good news is, I've been working on one, so I can push a tag for=
 you to
> base a revised fix on.
>
>   https://github.com/allisonhenderson/rds_work/releases/tag/rds-conn-kref=
-base-v1
>
> The branch may still see some review churn, but I'll leave this tag here =
for
> you to base your fix on.  On top of it, the fix is just to make every hol=
der
> of inc->i_conn own a reference.  Really what we're doing here is porting =
a
> small UEK patch:
>
>   https://github.com/oracle/linux-uek/commit/99b9a3715419
>
> Upstream's assignment sites differ a little from UEK's, but basically the
> idea is to use rds_conn_get() everywhere i_conn is assigned.
>
> This can target net-next since every remaining trigger needs CAP_SYS_MODU=
LE
> or physical device removal.  So it isn't reachable by an unprivileged att=
acker.
>
> Once you've worked out the patch, I'll carry it with yourself as the auth=
or
> as part of that series so it lands in the right order.  Alternately if yo=
u'd
> rather not take on a port, that's fine too, just let me know and I would =
tag
> you for the Reported-by.
>
>
> > @@ -925,6 +925,12 @@ static void rds6_sock_info(struct socket *sock, un=
signed int len,
> >  static void rds_exit(void)
> >  {
> >       sock_unregister(rds_family_ops.family);
> > +     rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
> > +     rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_inf=
o);
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +     rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
> > +     rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_i=
nfo);
> > +#endif
> >       proto_unregister(&rds_proto);
> >       rds_conn_exit();
> >       rds_cong_exit();
> > @@ -933,12 +939,6 @@ static void rds_exit(void)
> >       rds_stats_exit();
> >       rds_page_exit();
> >       rds_bind_lock_destroy();
> > -     rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
> > -     rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_inf=
o);
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -     rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
> > -     rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_i=
nfo);
> > -#endif
> >  }
> >  module_exit(rds_exit);
> >
> > diff --git a/net/rds/info.c b/net/rds/info.c
> > index 21b32eb16559..7d6f3552d65b 100644
> > --- a/net/rds/info.c
> > +++ b/net/rds/info.c
>
> These SRCU conversions in info.c are actually fixing a completely separat=
e bug
> independent of the connections.   A getsockopt(RDS_INFO_TCP_SOCKETS)
> racing against a "rmmod rds_tcp" could call the callback pointer of a fre=
ed
> module. Which this patch fixes. So please resend the info.c changes
> against net-next, with the build fixes, and a commit message describing
> that race.
>
> I think that about covers it.  Let me know if you get stuck or have quest=
ions
>
> Thanks again, this was a good find.
>
> Allison
>
> > @@ -32,6 +32,7 @@
> >   */
> >  #include <linux/percpu.h>
> >  #include <linux/seq_file.h>
> > +#include <linux/srcu.h>
> >  #include <linux/slab.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/export.h>
> > @@ -68,8 +69,9 @@ struct rds_info_iterator {
> >       unsigned long offset;
> >  };
> >
> > +DEFINE_STATIC_SRCU(rds_info_srcu);
> >  static DEFINE_SPINLOCK(rds_info_lock);
> > -static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1=
];
> > +static rds_info_func __rcu rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIR=
ST + 1];
> >
> >  void rds_info_register_func(int optname, rds_info_func func)
> >  {
> > @@ -78,8 +80,8 @@ void rds_info_register_func(int optname, rds_info_fun=
c func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset]);
> > -     rds_info_funcs[offset] =3D func;
> > +     BUG_ON(rcu_access_pointer(rds_info_funcs[offset]));
> > +     rcu_assign_pointer(rds_info_funcs[offset], func);
> >       spin_unlock(&rds_info_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(rds_info_register_func);
> > @@ -91,9 +93,10 @@ void rds_info_deregister_func(int optname, rds_info_=
func func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset] !=3D func);
> > -     rds_info_funcs[offset] =3D NULL;
> > +     BUG_ON(rcu_access_pointer(rds_info_funcs[offset]) !=3D func);
> > +     RCU_INIT_POINTER(rds_info_funcs[offset], NULL);
> >       spin_unlock(&rds_info_lock);
> > +     synchronize_srcu(&rds_info_srcu);
> >  }
> >  EXPORT_SYMBOL_GPL(rds_info_deregister_func);
> >
> > @@ -165,6 +168,7 @@ int rds_info_getsockopt(struct socket *sock, int op=
tname, sockopt_t *opt)
> >       int npages =3D 0;
> >       int ret;
> >       int len;
> > +     int srcu_idx;
> >       int total;
> >
> >       len =3D opt->optlen;
> > @@ -214,8 +218,11 @@ int rds_info_getsockopt(struct socket *sock, int o=
ptname, sockopt_t *opt)
> >       rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
> >
> >  call_func:
> > -     func =3D rds_info_funcs[optname - RDS_INFO_FIRST];
> > +     srcu_idx =3D srcu_read_lock(&rds_info_srcu);
> > +     func =3D srcu_dereference(rds_info_funcs[optname - RDS_INFO_FIRST=
],
> > +                             &rds_info_srcu);
> >       if (!func) {
> > +             srcu_read_unlock(&rds_info_srcu, srcu_idx);
> >               ret =3D -ENOPROTOOPT;
> >               goto out;
> >       }
> > @@ -225,6 +232,7 @@ int rds_info_getsockopt(struct socket *sock, int op=
tname, sockopt_t *opt)
> >       iter.offset =3D offset0;
> >
> >       func(sock, len, &iter, &lens);
> > +     srcu_read_unlock(&rds_info_srcu, srcu_idx);
> >       BUG_ON(lens.each =3D=3D 0);
> >
> >       total =3D lens.nr * lens.each;
>

Hi Allison,

Thank you for the detailed review and for confirming the bug.

I would prefer to leave the connection-reference port to you, since it
depends on the new refcounting infrastructure. Please feel free to carry
the fix in your series with:

Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>

I will resend the info.c changes against net-next.

Best regards,
Chengfeng
