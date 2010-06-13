From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH/RFC] mlx4_core: module param to limit msix vec
	allocation
Date: Sun, 13 Jun 2010 09:53:24 +0300
Message-ID: <20100613065324.GA2408@eli-vm>
References: <20100610165921.GF22247@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100610165921.GF22247-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 10, 2010 at 09:59:21AM -0700, Arthur Kepner wrote:
> 
> The mlx4_core driver allocates 'nreq' msix vectors (and irqs), 
> where:
> 
>   nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
>                num_possible_cpus() + 1);
> 
> ConnectX HCAs support 512 event queues (4 reserved). On a system 
> with enough processors, we get:
> 
>   mlx4_core 0006:01:00.0: Requested 508 vectors, but only 256 MSI-X vectors available, trying again
> 
> Further attempts (by other drivers) to allocate interrupts fail, 
> because mlx4_core got 'em all.
> 
> How about this?
> 

Hi Arthur,

how many CPU cores are in your system? What kernel version did you
use?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
