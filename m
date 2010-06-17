From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [PATCH/RFC] mlx4_core: module param to limit msix vec
	allocation
Date: Thu, 17 Jun 2010 17:53:58 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB4439A77CCD66@MTLMAIL.mtl.com>
References: <20100610165921.GF22247@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100610165921.GF22247-sJ/iWh9BUns@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 

> The mlx4_core driver allocates 'nreq' msix vectors (and irqs),
> where:
> 
> nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
>               num_possible_cpus() + 1);
>
> ConnectX HCAs support 512 event queues (4 reserved). On a system with enough processors, we get:
>
>  mlx4_core 0006:01:00.0: Requested 508 vectors, but only 256 MSI-X vectors available, trying again
>
> Further attempts (by other drivers) to allocate interrupts fail, because mlx4_core got 'em all.
>
> How about this?

Hi,
I think that this patch would do the job,
Anyway we are thinking of ways to change our interrupt allocation scheme.

--Yevgeny--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
