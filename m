Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1D311973
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 05:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785562164; cv=pass; b=qIC8vb7Z/d5X6BLOw7R+kpQtxo//f4h5j9rdQHIZ7CKO+1sjB87Wbugs3dfGhTQ8GmTvlLCjlVIwDD/BvOSA4NT87E16o0XRiaTDJ52Xn1oojsp+m4u1AM3Qtu4G4Q+7Iuns+rmgkuselIuu8sYtRxhyEnE3/peT3OAc5YKeXko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785562164; c=relaxed/simple;
	bh=sJLElkW2K4X3L+gst6Gzqv35dJDSqgToNYf3BLWi20I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GETHohhxlDqQ14uOaSi2ghoMDRuUQClfEYDuP/NVVdCHfsV24sgKlsm7fOL0/Q6Lwr0Qllrphoz9jwP+YMsfHkT/8yCLR3OCgkX2DuSP+3o9jLgzhj8rIk3Gd1jjV4QRTZsZ/SArom4fpqnDT+iYTJ69ZzstCgpi6bJkdIMiRak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlML+U+r; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlML+U+r"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69fdfd98eb8so276474a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 22:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785562160; cv=none;
        d=google.com; s=arc-20260327;
        b=AyvB0kGwtsqwFIjMFi3rtYCZS/jJE/WMjmi0N7xWLmrA/ayMFoMjheOB0Hin/yJQoa
         k1vl6Q6MniIQZ8LtSWqYz14Tdd2L4C9pp8zJgM+Fs+hiF6jnYRbxHbq20w9ihyJ6aFPP
         5F4YDVccP/6D8Skd4D4JKzsYzTQwqyekC7uE7BGPVpT1tmf/vLEXcJNgCUSQzplleyHr
         o1bgvNT+xJKP2TQHgFvBUCL/iT/CznkoxIrfMMAIj8fTsA9SOR8RbQnhZkytjAlhU82s
         Rm+HeDceoIY6E9BOwGdNIE0YWTIRfzb8FHcjp9/6oZ9XmxoXqlbFxMG18lyE/yaIpB+K
         W7Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EOxS/Ec9vGmOnudxhfaP8njOtJ9a5eFev7M613YvlIs=;
        fh=UTpur4TVQtRiLcshkQVZ4kNv3MoSsU+BK4NCvnab/Hc=;
        b=pI2NLA4P4RG6v0Uk+hyneyjMZlym4UE26OPXAQsoeFs4VrE0ROPrcIrT/Gw6jl0lN5
         aKKhhqENZN8shPEa8xN0qnW6NcVsq8inNKT+WYJoUXhNOttzWpV6UWeHY7nFZ8Z99lld
         aByFq4wlM/tZrN5zXdPA+xeG09j6u1MklL4TdCj/QLu7B286xk8Si8G77yGcGewjmYth
         n0tE7JUNSXUPe1EEVCDoxOJPGDP+LQemlbjC7iU8M2BMFnwytdjtN2dYI9ku0gN4yW1O
         ZleY78bdB2VWVnlDx73ccOEvyuNrKgB/PYbFL3/jfyFEVqGLXUK4GCLear95V26LAG9V
         Q4WQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785562160; x=1786166960; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EOxS/Ec9vGmOnudxhfaP8njOtJ9a5eFev7M613YvlIs=;
        b=BlML+U+r4XAuWAZMMi9CO65mrJKcO1n13ei/80RDnBfFFbmS+xY3tyCIhjtboafeqx
         rIPJBpWjJNFYFMxaoJkWI0WMH5TOc3WtHuoJWqfyyU6K3hen0WDIW5gDnR23b/ZYL/+H
         cHTPM7fXtmMczNMkdS5Eiz//6jWiwMmTRndyPS47cR3v0cdpzjspItDLW2tKo0R1G1PT
         onhRHvd/bLaGche97tzJzJJrUNH5qwusgrxohBVsXsxa4x3coJJbuEV9aMWDVFVNMt89
         TDEEJ/5rXCsAZ3wRGh6pHzxCjapXsIlLefnV/tUybTb3NnxbZ7AGq2PiBs5WRElLD/XG
         jsWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785562160; x=1786166960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EOxS/Ec9vGmOnudxhfaP8njOtJ9a5eFev7M613YvlIs=;
        b=C+yEgQbAVZm72vAow9wwG1L9Oe3WBLvSXkbpU8kDh7YNFbsq1oQ7eCmM0JWUeEwCev
         DSYEWD3AdHtxs52EXMcHyypTbXw3oiFW2H3d9oQgp3bNXzjz/rS0buJ7nbvxClVGiyaR
         ZQ3PtB+a3qF5ilZG56O2Z1cZ9MXtjOXC2yHMhnSHMMZmjVnP+DQM5l0QS8/+gvpzv+6l
         8Z14qwAgBt+z5WdLLzj8Lkn438yh/u1jnQtkmzK7eodT10QlhWI1UvxAGhdEjWTv+bWl
         Ja5QNZ4+38Y12rX8gWsdhipcThYge71XEV5J5oKGscK442V38gLv4Lep3e5jKWX+4NzN
         lo3A==
X-Forwarded-Encrypted: i=1; AHgh+RqZHoPVJKv/oS9Y6MGBCcBgu9JqtA4I51AgCGZCwOA75rKUcRPXPAWYQAtfuNlUCO/ik56FGVHV+voI@vger.kernel.org
X-Gm-Message-State: AOJu0YxmcltQo+LaYBRIiVIvVV6vgjPD7vQZQcdHVtmNvkBOvZt0BJ6/
	gsuZgD4zj9es3qK14OtiRYFUAr38wLtprLCqQ3rl/Uk91FEPiyCcAVOGd4YrdBYjJ2l/4xTiLk2
	31E8k+EVbeMCeM2zhROqZLNMcIszGm9ssBHdBq7kpVQ==
X-Gm-Gg: AR+sD11RmhoHSxpGYKqQ2FhDXJikjjoZ2aU5b2/d5pePlYMC1gFte2U8l3luSdlIDns
	BX1ytKfz60AKWmOpRnIvF/imER/VT7F1Cy2muTplQUp1Ioy+f+LNTKu25JfTXYOq0CHMHAD+cIb
	KGHbM6da6fVj2km9Cw5KTNih8TpcLFXnm6NMaZ/JgSzkSCDdtJxOW4uZ74Q9XLeN/EVu+S1eKb/
	hzrFWbIlszPp8IXhMcQEjqZ93OPfejSvAJ3ZcrTGg8jnISRLHq2z1ROfZU8en3WyXGOWR32BWNI
	yQPswWv9/LL7vTw13wn80/o97C/+xFi8N6d0lKEsh1+/ZSXL3SqUrXwjRh9OF2AgeQ5ViPW63g=
	=
X-Received: by 2002:a05:6402:400e:b0:6a0:10c8:8f2 with SMTP id
 4fb4d7f45d1cf-6a0a7d2d573mr1154843a12.3.1785562160216; Fri, 31 Jul 2026
 22:29:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731160942.3245965-1-nicoyip.dev@gmail.com> <20260731230936.2463714-1-kuniyu@google.com>
In-Reply-To: <20260731230936.2463714-1-kuniyu@google.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Sat, 1 Aug 2026 13:29:07 +0800
X-Gm-Features: AUfX_mxobEDZdRgV0OGo6qH5KjK-9Fq_wMeLDquuN_NhnlLzw2dGqzhkcxkWmEE
Message-ID: <CAAo+4rWq5JTCOD36A9VEDEX0hLak8+MEXTUn7CxZrFb7YxMsMA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] rds: synchronize info callbacks with module unload
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com, 
	error27@gmail.com, horms@kernel.org, ka-cheong.poon@oracle.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 7:09=E2=80=AFAM Kuniyuki Iwashima <kuniyu@google.com=
> wrote:
>
> From: Chengfeng Ye <nicoyip.dev@gmail.com>
> Date: Sat,  1 Aug 2026 00:09:42 +0800
> > rds_info_getsockopt() reads a callback from rds_info_funcs and invokes =
it
> > without protecting the callback's lifetime.  Transport modules register
> > functions stored in this array.  For example, rds_tcp.ko registers
> > rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
> >
> > This permits the following interleaving:
> >
> >   CPU0                             CPU1
> >   rds_info_getsockopt()
> >     func =3D rds_tcp_tc_info
> >                                    rmmod rds_tcp
> >                                      rds_tcp_exit()
> >                                        rds_info_deregister_func()
> >                                          rds_info_funcs[offset] =3D NUL=
L
> >                                      free rds_tcp module text
> >     func()
> >
> > The reader can therefore branch to an address in unloaded module text.
> >
> > Protect callback invocation with SRCU.  Enter the SRCU read-side critic=
al
> > section before loading the callback and leave it only after the callbac=
k
> > returns.  Clear the callback with release semantics and call
> > synchronize_srcu() before deregistration returns, preventing module unl=
oad
> > from freeing its text while an old reader is still executing it.  SRCU =
is
> > required because callbacks such as RDS_INFO_COUNTERS can sleep.
> >
> > Keep the callback array unannotated and use acquire and release operati=
ons
> > for publication so sparse does not have to apply __rcu through the
> > function-pointer typedef.  Replace the two callback-slot BUG_ON() check=
s
> > with WARN_ON_ONCE() and return without changing the slot on mismatch.
> >
> > Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.d=
ev@gmail.com/
> > Suggested-by: Allison Henderson <achender@kernel.org>
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> > Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> > ---
> >
> > Changes in v3:
> > - Use ordinary loads for callback-slot validation under rds_info_lock;
> >   retain acquire semantics only for the lockless reader.
> > - Drop the Fixes tag because this patch targets net-next.
> > - Add Allison Henderson's Reviewed-by tag.
> >
> > Link: https://lore.kernel.org/netdev/20260727174826.135662-1-nicoyip.de=
v@gmail.com/ [v2]
> >
> > Changes in v2:
> > - Split the info callback/module-unload race from the independent
> >   inc->i_conn lifetime bug.
> > - Keep the callback array unannotated and use smp_load_acquire() and
> >   smp_store_release() to resolve the sparse errors.
> > - Replace the two touched callback-slot BUG_ON() checks with
> >   WARN_ON_ONCE() error paths.
> > - Rewrite the commit message for the callback race and omit the unrelat=
ed
> >   inc->i_conn KASAN report.
> >
> > Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.d=
ev@gmail.com/ [v1]
> >
> >  net/rds/info.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/rds/info.c b/net/rds/info.c
> > index 21b32eb16559..385fefbfa07f 100644
> > --- a/net/rds/info.c
> > +++ b/net/rds/info.c
> > @@ -32,6 +32,7 @@
> >   */
> >  #include <linux/percpu.h>
> >  #include <linux/seq_file.h>
> > +#include <linux/srcu.h>
> >  #include <linux/slab.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/export.h>
> > @@ -68,6 +69,7 @@ struct rds_info_iterator {
> >       unsigned long offset;
> >  };
> >
> > +DEFINE_STATIC_SRCU(rds_info_srcu);
> >  static DEFINE_SPINLOCK(rds_info_lock);
> >  static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1=
];
> >
> > @@ -78,8 +80,12 @@ void rds_info_register_func(int optname, rds_info_fu=
nc func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset]);
> > -     rds_info_funcs[offset] =3D func;
> > +     if (WARN_ON_ONCE(rds_info_funcs[offset])) {
> > +             spin_unlock(&rds_info_lock);
> > +             return;
> > +     }
> > +     /* Pair with lockless callback lookup. */
> > +     smp_store_release(&rds_info_funcs[offset], func);
>
> Why is smp_store_release() necessary here ? and same for
> smp_load_acquire() on the reader.
>
> I think just WRITE_ONCE() / READ_ONCE() should be enough.
>
> It's just a function pointer, not struct, and the reader
> does not require any partial ordering, no ?
>
>
> >       spin_unlock(&rds_info_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(rds_info_register_func);
> > @@ -91,9 +97,14 @@ void rds_info_deregister_func(int optname, rds_info_=
func func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset] !=3D func);
> > -     rds_info_funcs[offset] =3D NULL;
> > +     if (WARN_ON_ONCE(rds_info_funcs[offset] !=3D func)) {
> > +             spin_unlock(&rds_info_lock);
> > +             return;
> > +     }
> > +     /* Hide the callback before waiting for old readers. */
> > +     smp_store_release(&rds_info_funcs[offset], NULL);
> >       spin_unlock(&rds_info_lock);
> > +     synchronize_srcu(&rds_info_srcu);
> >  }
> >  EXPORT_SYMBOL_GPL(rds_info_deregister_func);
> >
> > @@ -165,6 +176,7 @@ int rds_info_getsockopt(struct socket *sock, int op=
tname, sockopt_t *opt)
> >       int npages =3D 0;
> >       int ret;
> >       int len;
> > +     int srcu_idx;
>
> nit: please keep the reverse xmas tree order.

Hi,

Indeed WRITE/READ_ONCE should suffice for this code, maybe we don't
need that smp store/load despite it looks more secure. I will make a
v4 patch to address it as well as the reverse xmas tree order problem.

Best Regards,
Chengfeng
