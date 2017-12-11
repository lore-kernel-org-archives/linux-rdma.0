From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: i40w: Remove garbage at end of INFINIBAND_I40IW Kconfig section
Date: Mon, 11 Dec 2017 16:37:53 -0700
Message-ID: <20171211233753.GC32020@ziepe.ca>
References: <1511117961-25096-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511117961-25096-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 07:59:21PM +0100, Geert Uytterhoeven wrote:
> Remove leftover garbage (containing Kconfig dependencies for another
> symbol?)
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  drivers/infiniband/hw/i40iw/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
> index f6d20ba88c03df3c..2962979c06e9ef51 100644
> +++ b/drivers/infiniband/hw/i40iw/Kconfig
> @@ -5,4 +5,3 @@ config INFINIBAND_I40IW
>  	select GENERIC_ALLOCATOR
>  	Intel(R) Ethernet X722 iWARP Driver
> -	INET && I40IW && INFINIBAND && I40E

Applied to for-next, thanks

Jason
