From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH V2 net-next 0/3] net: hns3: Refactors "reset" handling
 code in HCLGE layer of HNS3 driver
Date: Tue, 05 Dec 2017 11:48:33 -0500 (EST)
Message-ID: <20171205.114833.2112478522356368321.davem@davemloft.net>
References: <20171204012955.17560-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171204012955.17560-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Mon, 4 Dec 2017 01:29:52 +0000

> This patch refactors the code of the reset feature in HCLGE layer
> of HNS3 PF driver. Prime motivation to do this change is: 
> 1. To reduce the time for which common miscellaneous Vector 0
>    interrupt is disabled because of the reset. Simplification
>    of the common miscellaneous interrupt handler routine(for
>    Vector 0) used to handle reset and other sources of Vector
>    0 interrupt.
> 2. Separate the task for handling the reset
> 3. Simplification of reset request submission and pending reset
>    logic.
> 
> 
> To achieve above below few things have been done:
> 1. Interrupt is disabled while common miscellaneous interrupt
>    handler is entered and re-enabled before it is exit. This
>    reduces the interrupt handling latency as compared to older
>    interrupt handling scheme where interrupt was being disabled
>    in interrupt handler context and re-enabled in task context
>    some time later. Made Miscellaneous interrupt handler more
>    generic to handle all sources including reset interrupt source.
> 2. New reset service task has been introduced to service the 
>    reset handling.
> 3. Introduces new reset service task for honoring software reset
>    requests like from network stack related to timeout and serving
>    the pending reset request(to reset the driver and associated
>    clients).
> 
> 
> Change Log:
> Patch V2: Addressed comment by Andrew Lunn
>    Link: https://lkml.org/lkml/2017/12/1/366
> Patch V1: Initial Submit

Series applied, thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
