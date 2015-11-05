From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
Date: Thu, 5 Nov 2015 12:06:53 -0500
Message-ID: <20151105170652.GC14837@phlsvsds.ph.intel.com>
References: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
To: Sunny Kumar <sunny.kumar.roy@gmail.com>
Cc: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Sunny Kumar <sunnyk@cdac.in>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 05:28:03PM +0530, Sunny Kumar wrote:
> This patch replaces bit shifting on 1 with the BIT(x) macro
> 
> Signed-off-by: Sunny Kumar <sunnyk@cdac.in>

Also, NAK as has been covered in other responses.

However, I wanted to add, similar to the hfi1_ioctl fix, we have follow on
checkpatch patches which address this.

Ira

> ---
>  drivers/staging/rdma/hfi1/user_sdma.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
> index 36c838d..95a6d99 100644
> --- a/drivers/staging/rdma/hfi1/user_sdma.c
> +++ b/drivers/staging/rdma/hfi1/user_sdma.c
> @@ -146,8 +146,8 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
>  #define KDETH_OM_MAX_SIZE  (1 << ((KDETH_OM_LARGE / KDETH_OM_SMALL) + 1))
>  
>  /* Last packet in the request */
> -#define TXREQ_FLAGS_REQ_LAST_PKT   (1 << 0)
> -#define TXREQ_FLAGS_IOVEC_LAST_PKT (1 << 0)
> +#define TXREQ_FLAGS_REQ_LAST_PKT   BIT(1 << 0)
> +#define TXREQ_FLAGS_IOVEC_LAST_PKT BIT(1 << 0)
>  
>  #define SDMA_REQ_IN_USE     0
>  #define SDMA_REQ_FOR_THREAD 1
> @@ -156,9 +156,9 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
>  #define SDMA_REQ_HAS_ERROR  4
>  #define SDMA_REQ_DONE_ERROR 5
>  
> -#define SDMA_PKT_Q_INACTIVE (1 << 0)
> -#define SDMA_PKT_Q_ACTIVE   (1 << 1)
> -#define SDMA_PKT_Q_DEFERRED (1 << 2)
> +#define SDMA_PKT_Q_INACTIVE BIT(1 << 0)
> +#define SDMA_PKT_Q_ACTIVE   BIT(1 << 1)
> +#define SDMA_PKT_Q_DEFERRED BIT(1 << 2)
>  
>  /*
>   * Maximum retry attempts to submit a TX request
> -- 
> 2.1.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
