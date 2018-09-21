From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for
 rds_ib_stats
Date: Fri, 21 Sep 2018 11:17:29 -0700
Message-ID: <b7e183c1-294e-a98d-8d96-b7c7fcc358c2@oracle.com>
References: <20180921180451.18711-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180921180451.18711-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org

On 9/21/2018 11:04 AM, Nathan Chancellor wrote:
> Clang warns when two declarations' section attributes don't match.
> 
> net/rds/ib_stats.c:40:1: warning: section does not match previous
> declaration [-Wsection]
> DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
> ^
> ./include/linux/percpu-defs.h:142:2: note: expanded from macro
> 'DEFINE_PER_CPU_SHARED_ALIGNED'
>          DEFINE_PER_CPU_SECTION(type, name,
> PER_CPU_SHARED_ALIGNED_SECTION) \
>          ^
> ./include/linux/percpu-defs.h:93:9: note: expanded from macro
> 'DEFINE_PER_CPU_SECTION'
>          extern __PCPU_ATTRS(sec) __typeof__(type) name;
> \
>                 ^
> ./include/linux/percpu-defs.h:49:26: note: expanded from macro
> '__PCPU_ATTRS'
>          __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))
> \
>                                  ^
> net/rds/ib.h:446:1: note: previous attribute is here
> DECLARE_PER_CPU(struct rds_ib_statistics, rds_ib_stats);
> ^
> ./include/linux/percpu-defs.h:111:2: note: expanded from macro
> 'DECLARE_PER_CPU'
>          DECLARE_PER_CPU_SECTION(type, name, "")
>          ^
> ./include/linux/percpu-defs.h:87:9: note: expanded from macro
> 'DECLARE_PER_CPU_SECTION'
>          extern __PCPU_ATTRS(sec) __typeof__(type) name
>                 ^
> ./include/linux/percpu-defs.h:49:26: note: expanded from macro
> '__PCPU_ATTRS'
>          __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))
> \
>                                  ^
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
Looks fine. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
