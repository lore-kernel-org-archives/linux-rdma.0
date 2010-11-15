From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH][trivial] infiniband: Only include linux/mutex.h once in
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h .
Date: Mon, 15 Nov 2010 14:30:14 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011151429480.7420@pobox.suse.cz>
References: <alpine.LNX.2.00.1011072321150.26247@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1011072321150.26247@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Steve Wise <swise@chelsio.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, 7 Nov 2010, Jesper Juhl wrote:

> Only include the header linux/mutex.h once inside 
> drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  iw_cxgb4.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 16032cd..42bb575 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -46,7 +46,6 @@
>  #include <linux/timer.h>
>  #include <linux/io.h>
>  #include <linux/kfifo.h>
> -#include <linux/mutex.h>

The double include seems to be present in linux-next as of today. So I 
have picked the patch up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
