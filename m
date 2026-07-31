Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304633BBFA1
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 23:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785539381; cv=none; b=jEE8a0zs0qVs3TZJROeAxOyARU2UmzHDSIobgImjqvCqoZ4ECUCK9whHK8oghdw3fTmhIMa2sTdXSLf4Q/qRX4tWj+TkC1CRtLkxO+B47HJ7pWGz3IytW1c2yuRCmnZvXmkbzlU/Msvaa+nCfvGECjp7+gwPfaBb39pg20cSQsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785539381; c=relaxed/simple;
	bh=3/Y7DTe/blm0ls3HJgTgqBWahpKf4hGOsDhRJ4rLJ+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Je8hxHkV5HlpgISHk0CTjDLROMzuZSw0njrTxwhIJF8rrpHl7kZyXIoc2/5BcPMdUFv7f0RGutNIe+QfaoStkVH2Sa7wuAtvUXP17FcuDBxmgOXJUlJ+NjzkgW7121pF0MP0KQv68SzzeW9HmfvmjWUTcSLHdvxfVNL/JNUi3GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d/S7TDTc; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d/S7TDTc"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c89704da8c7so2080496a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 16:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785539377; x=1786144177; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2Atkz5KaRe9+m0/qO7+29NEyBrGyd/EfwQ1Im0dujw=;
        b=d/S7TDTc/BcwFn5B1NznofWbAepRahNMo8I1R+XzHr+jMssD2YRJlM+4nuDmugl7/u
         +j57Xog9ShEUYgsH/gCzeOnM12BtdaDtlrUES0YAwPnp6/APHL1ehP1vcqb35RP4kkB6
         KE9Q3o4ukYDh7a1NY0EnrxFWFfgoMfPpvMUgZ/vCOjZvColrXo31l0WR5eHOEODqp/37
         GZDV2zXZ2YJ4ALewIPnqzfcAmdUoP7Cyd46FrMvfFssN91r5w6trMDIYNPtwJ6KLk8SO
         scWB9St1YOrYivN1VFuaGFgi07GiAaf1lHLRaGmhc8ofIh1ttnnpzHpSOJz6FfyO6UkQ
         XbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785539377; x=1786144177;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L2Atkz5KaRe9+m0/qO7+29NEyBrGyd/EfwQ1Im0dujw=;
        b=obLXxEk0efY7pCWHOz31J36m2yVx+NU2rXBHoQkLi61tTR8m/5+Wp7jfsYNzi6o9IS
         853sV1F06++ocPDLEQ9r8ZVh7h9+fiWlE76DOtjRjeGmyUU0kqTBxo+Xhwd4kow1FI4F
         a4KcjHNV9951s7QIDfAYCwCTwYm3icuGopX+2XyQM0YTqGLe5wv9eUcjy+6R5N3dqZmo
         Gf54S294LLsFFknkAayiUndW5wONdbRPQ9CLfWZ5gcASymo/lEBF+IBjJVNGK6U3FtoC
         mSITItmuoLk28w7WuJRa2YEJFyxkeaMPADDqZZPYv2KLAHkOIyjZQ4W9e1rsGyr4K+vj
         RVlQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWPKVaJ7X9ILrUJVJDQmbYet5o+nd8wWogSf5mhVhx5sj6Ym9ZTY4Nr5/ORonRI6cPCvfgjRE+1+8y@vger.kernel.org
X-Gm-Message-State: AOJu0Yxeaea/HCBG5gR2ODUc+8I4l1emRkvFgXytPUmXRsRLWc21rkfS
	zQw+8ZHi5CxBoIvefLhJ1C7dUuejnzqd4XHRBzjQ13wjPDxi0PsjclkkKN9jgTGHqH0lfrciC3F
	uFx6n4w==
X-Received: from pjblx7.prod.google.com ([2002:a17:90b:4b07:b0:387:9b6c:b940])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58c7:b0:381:a766:efcb
 with SMTP id 98e67ed59e1d1-38fbc409439mr1394795a91.4.1785539377218; Fri, 31
 Jul 2026 16:09:37 -0700 (PDT)
Date: Fri, 31 Jul 2026 23:05:51 +0000
In-Reply-To: <20260731160942.3245965-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260731160942.3245965-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260731230936.2463714-1-kuniyu@google.com>
Subject: Re: [PATCH net-next v3] rds: synchronize info callbacks with module unload
From: Kuniyuki Iwashima <kuniyu@google.com>
To: nicoyip.dev@gmail.com
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com, 
	error27@gmail.com, horms@kernel.org, ka-cheong.poon@oracle.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com
Content-Type: text/plain; charset="UTF-8"

From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Sat,  1 Aug 2026 00:09:42 +0800
> rds_info_getsockopt() reads a callback from rds_info_funcs and invokes it
> without protecting the callback's lifetime.  Transport modules register
> functions stored in this array.  For example, rds_tcp.ko registers
> rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
> 
> This permits the following interleaving:
> 
>   CPU0                             CPU1
>   rds_info_getsockopt()
>     func = rds_tcp_tc_info
>                                    rmmod rds_tcp
>                                      rds_tcp_exit()
>                                        rds_info_deregister_func()
>                                          rds_info_funcs[offset] = NULL
>                                      free rds_tcp module text
>     func()
> 
> The reader can therefore branch to an address in unloaded module text.
> 
> Protect callback invocation with SRCU.  Enter the SRCU read-side critical
> section before loading the callback and leave it only after the callback
> returns.  Clear the callback with release semantics and call
> synchronize_srcu() before deregistration returns, preventing module unload
> from freeing its text while an old reader is still executing it.  SRCU is
> required because callbacks such as RDS_INFO_COUNTERS can sleep.
> 
> Keep the callback array unannotated and use acquire and release operations
> for publication so sparse does not have to apply __rcu through the
> function-pointer typedef.  Replace the two callback-slot BUG_ON() checks
> with WARN_ON_ONCE() and return without changing the slot on mismatch.
> 
> Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
> Suggested-by: Allison Henderson <achender@kernel.org>
> Reviewed-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> ---
> 
> Changes in v3:
> - Use ordinary loads for callback-slot validation under rds_info_lock;
>   retain acquire semantics only for the lockless reader.
> - Drop the Fixes tag because this patch targets net-next.
> - Add Allison Henderson's Reviewed-by tag.
> 
> Link: https://lore.kernel.org/netdev/20260727174826.135662-1-nicoyip.dev@gmail.com/ [v2]
> 
> Changes in v2:
> - Split the info callback/module-unload race from the independent
>   inc->i_conn lifetime bug.
> - Keep the callback array unannotated and use smp_load_acquire() and
>   smp_store_release() to resolve the sparse errors.
> - Replace the two touched callback-slot BUG_ON() checks with
>   WARN_ON_ONCE() error paths.
> - Rewrite the commit message for the callback race and omit the unrelated
>   inc->i_conn KASAN report.
> 
> Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/ [v1]
> 
>  net/rds/info.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/net/rds/info.c b/net/rds/info.c
> index 21b32eb16559..385fefbfa07f 100644
> --- a/net/rds/info.c
> +++ b/net/rds/info.c
> @@ -32,6 +32,7 @@
>   */
>  #include <linux/percpu.h>
>  #include <linux/seq_file.h>
> +#include <linux/srcu.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
>  #include <linux/export.h>
> @@ -68,6 +69,7 @@ struct rds_info_iterator {
>  	unsigned long offset;
>  };
>  
> +DEFINE_STATIC_SRCU(rds_info_srcu);
>  static DEFINE_SPINLOCK(rds_info_lock);
>  static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
>  
> @@ -78,8 +80,12 @@ void rds_info_register_func(int optname, rds_info_func func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
>  
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset]);
> -	rds_info_funcs[offset] = func;
> +	if (WARN_ON_ONCE(rds_info_funcs[offset])) {
> +		spin_unlock(&rds_info_lock);
> +		return;
> +	}
> +	/* Pair with lockless callback lookup. */
> +	smp_store_release(&rds_info_funcs[offset], func);

Why is smp_store_release() necessary here ? and same for
smp_load_acquire() on the reader.

I think just WRITE_ONCE() / READ_ONCE() should be enough.

It's just a function pointer, not struct, and the reader
does not require any partial ordering, no ?


>  	spin_unlock(&rds_info_lock);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_register_func);
> @@ -91,9 +97,14 @@ void rds_info_deregister_func(int optname, rds_info_func func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
>  
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset] != func);
> -	rds_info_funcs[offset] = NULL;
> +	if (WARN_ON_ONCE(rds_info_funcs[offset] != func)) {
> +		spin_unlock(&rds_info_lock);
> +		return;
> +	}
> +	/* Hide the callback before waiting for old readers. */
> +	smp_store_release(&rds_info_funcs[offset], NULL);
>  	spin_unlock(&rds_info_lock);
> +	synchronize_srcu(&rds_info_srcu);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_deregister_func);
>  
> @@ -165,6 +176,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
>  	int npages = 0;
>  	int ret;
>  	int len;
> +	int srcu_idx;

nit: please keep the reverse xmas tree order.


>  	int total;
>  
>  	len = opt->optlen;
> @@ -214,8 +226,11 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
>  	rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
>  
>  call_func:
> -	func = rds_info_funcs[optname - RDS_INFO_FIRST];
> +	srcu_idx = srcu_read_lock(&rds_info_srcu);
> +	/* Pair with callback slot publication and removal. */
> +	func = smp_load_acquire(&rds_info_funcs[optname - RDS_INFO_FIRST]);
>  	if (!func) {
> +		srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  		ret = -ENOPROTOOPT;
>  		goto out;
>  	}
> @@ -225,6 +240,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
>  	iter.offset = offset0;
>  
>  	func(sock, len, &iter, &lens);
> +	srcu_read_unlock(&rds_info_srcu, srcu_idx);
>  	BUG_ON(lens.each == 0);
>  
>  	total = lens.nr * lens.each;
> -- 
> 2.43.0
> 
