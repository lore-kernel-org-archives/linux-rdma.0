From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
Date: Thu, 5 Nov 2015 15:27:33 +0200
Message-ID: <20151105132733.GD4023@leon.nu>
References: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Reply-To: leon@leon.nu
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
> ---
>  drivers/staging/rdma/hfi1/user_sdma.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
>  /* Last packet in the request */
> -#define TXREQ_FLAGS_REQ_LAST_PKT   (1 << 0)
> -#define TXREQ_FLAGS_IOVEC_LAST_PKT (1 << 0)
> +#define TXREQ_FLAGS_REQ_LAST_PKT   BIT(1 << 0)
> +#define TXREQ_FLAGS_IOVEC_LAST_PKT BIT(1 << 0)
>  
It is wrong. It actually creates 0x2 instead of 0x1.

> -#define SDMA_PKT_Q_INACTIVE (1 << 0)
> -#define SDMA_PKT_Q_ACTIVE   (1 << 1)
> -#define SDMA_PKT_Q_DEFERRED (1 << 2)
> +#define SDMA_PKT_Q_INACTIVE BIT(1 << 0)
> +#define SDMA_PKT_Q_ACTIVE   BIT(1 << 1)
> +#define SDMA_PKT_Q_DEFERRED BIT(1 << 2)
The same comment as above. It is wrong.
