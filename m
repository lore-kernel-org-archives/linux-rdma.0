From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for
 rds_ib_stats
Date: Sat, 22 Sep 2018 23:44:45 -0700
Message-ID: <20180923064445.GC12338@flashbox>
References: <20180921180451.18711-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180921180451.18711-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 21, 2018 at 11:04:51AM -0700, Nathan Chancellor wrote:
> Clang warns when two declarations' section attributes don't match.
> 
> net/rds/ib_stats.c:40:1: warning: section does not match previous
> declaration [-Wsection]
> DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
> ^
> ./include/linux/percpu-defs.h:142:2: note: expanded from macro
> 'DEFINE_PER_CPU_SHARED_ALIGNED'
>         DEFINE_PER_CPU_SECTION(type, name,
> PER_CPU_SHARED_ALIGNED_SECTION) \
>         ^
> ./include/linux/percpu-defs.h:93:9: note: expanded from macro
> 'DEFINE_PER_CPU_SECTION'
>         extern __PCPU_ATTRS(sec) __typeof__(type) name;
> \
>                ^
> ./include/linux/percpu-defs.h:49:26: note: expanded from macro
> '__PCPU_ATTRS'
>         __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))
> \
>                                 ^
> net/rds/ib.h:446:1: note: previous attribute is here
> DECLARE_PER_CPU(struct rds_ib_statistics, rds_ib_stats);
> ^
> ./include/linux/percpu-defs.h:111:2: note: expanded from macro
> 'DECLARE_PER_CPU'
>         DECLARE_PER_CPU_SECTION(type, name, "")
>         ^
> ./include/linux/percpu-defs.h:87:9: note: expanded from macro
> 'DECLARE_PER_CPU_SECTION'
>         extern __PCPU_ATTRS(sec) __typeof__(type) name
>                ^
> ./include/linux/percpu-defs.h:49:26: note: expanded from macro
> '__PCPU_ATTRS'
>         __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))
> \
>                                 ^
> 1 warning generated.
> 
> The initial definition was added in commit ec16227e1414 ("RDS/IB:
> Infiniband transport") and the cache aligned definition was added in
> commit e6babe4cc4ce ("RDS/IB: Stats and sysctls") right after. The
> definition probably should have been updated in net/rds/ib.h, which is
> what this patch does.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/114
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/rds/ib.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 73427ff439f9..fd483760c910 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -443,7 +443,7 @@ int rds_ib_send_grab_credits(struct rds_ib_connection *ic, u32 wanted,
>  int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op);
>  
>  /* ib_stats.c */
> -DECLARE_PER_CPU(struct rds_ib_statistics, rds_ib_stats);
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);

I have sent a v2 because this should be DECLARE_PER_CPU_SHARED_ALIGNED,
not DEFINE (thanks to 0day for catching it).

I will make sure the '--in-reply-to' option in the future.

Nathan

>  #define rds_ib_stats_inc(member) rds_stats_inc_which(rds_ib_stats, member)
>  #define rds_ib_stats_add(member, count) \
>  		rds_stats_add_which(rds_ib_stats, member, count)
> -- 
> 2.19.0
> 
