From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: FMR Support in multi-function environment
Date: Tue, 11 Nov 2014 12:54:15 +0200
Message-ID: <20141111125415.5ce4886f@jpm-OptiPlex-GX620>
References: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 10 Nov 2014 19:58:46 +0530
Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> Is FMR (Fast Memory Regions) supported in a multi-function mode?

In SRIOV, FMR is supported only for the PF, not for VFs (since this
feature requires writing directly to mapped ICM memory).

You can see this in file drivers/infiniband/hw/mlx4/main.c, function
mlx4_ib_add() :


        if (!mlx4_is_slave(ibdev->dev)) {
                ibdev->ib_dev.alloc_fmr         = mlx4_ib_fmr_alloc;
                ibdev->ib_dev.map_phys_fmr      = mlx4_ib_map_phys_fmr;
                ibdev->ib_dev.unmap_fmr         = mlx4_ib_unmap_fmr;
                ibdev->ib_dev.dealloc_fmr       = mlx4_ib_fmr_dealloc;
        }

i.e., the fmr functions are not put into the device virtual function
table for slave (= VF) devices.

-Jack

> 
> If yes, I couldn't find the source code for the same in the mlx4
> codebase. Can anyone please point me to the right location...
> 
> What I was trying to understand is this:
> 
> Suppose a VF driver wants to register large amount of memory using
> FMR, will it be able to do so using the mlx4 code.
> 
> Or FMR is supported only in dedicated mode?
> 
> 
> Thanks
> 
> Best Regards,
> Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
