From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 1/4] cxgb3: Use more common logging style
Date: Thu, 9 Feb 2017 16:34:21 -0600
Message-ID: <04c801d28324$a8459740$f8d0c5c0$@opengridcomputing.com>
References: <cover.1486678686.git.joe@perches.com> <15772862930dfd2f2e10574b86c063d781976a89.1486678686.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15772862930dfd2f2e10574b86c063d781976a89.1486678686.git.joe@perches.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Joe Perches' <joe@perches.com>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 1/4] cxgb3: Use more common logging style
> 
> Convert printks to pr_<level>
> 
> Miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c      | 27 ++++++------
>  drivers/infiniband/hw/cxgb3/cxio_hal.h      |  9 +++-
>  drivers/infiniband/hw/cxgb3/cxio_resource.c |  5 ++-
>  drivers/infiniband/hw/cxgb3/iwch.c          | 13 +++---
>  drivers/infiniband/hw/cxgb3/iwch_cm.c       | 66
++++++++++++-----------------
>  drivers/infiniband/hw/cxgb3/iwch_cq.c       |  7 ++-
>  drivers/infiniband/hw/cxgb3/iwch_ev.c       | 11 +++--
>  drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 ++---
>  drivers/infiniband/hw/cxgb3/iwch_qp.c       |  7 ++-
>  9 files changed, 70 insertions(+), 86 deletions(-)

<snip>

> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h
> b/drivers/infiniband/hw/cxgb3/cxio_hal.h
> index 78fbe9ffe7f0..115c0e3a5df5 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
> @@ -196,8 +196,13 @@ int cxio_poll_cq(struct t3_wq *wq, struct t3_cq *cq,
struct
> t3_cqe *cqe,
>  		     u8 *cqe_flushed, u64 *cookie, u32 *credit);
>  int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb);
> 
> -#define MOD "iw_cxgb3: "
> -#define PDBG(fmt, args...) pr_debug(MOD fmt, ## args)
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif

Is the ifdef/undef needed?  I see other modules just define pr_fmt() regardless.

Otherwise, looks good (and thanks).

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
