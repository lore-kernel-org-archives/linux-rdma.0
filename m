From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FMR Support in multi-function environment
Date: Tue, 11 Nov 2014 19:02:22 +0530
Message-ID: <CANwwZzUyNi3=k2Bst0PjeKq0WgUmkh87YyQhY5Xp=DsqQWFXXg@mail.gmail.com>
References: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw@mail.gmail.com>
	<20141111125415.5ce4886f@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141111125415.5ce4886f@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In SRIOV, FMR is supported only for the PF, not for VFs (since this
> feature requires writing directly to mapped ICM memory).

Hi,

Thank you so much for pointing to the exact code!!

I have a related question. I was trying to figure out the use case for
FMR in this environment(where in only PF supports FMR).


As per my understanding if an application wants to register huge
amounts of memory and wants to avoid the overhead of SW2HW_MPT HCR
command, it can do so using the alloc fmr verb.
Now in the SRIOV case, the application sits on top of the VF driver
and I was curious as to how the VF communicates with the PF driver to
register memory/map using FMR.

More specifically, I was trying to understand how the following
function gets called by the VF driver:


int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64
*page_list,
     int npages, u64 iova, u32 *lkey, u32 *rkey)
{
u32 key;
int i, err;

err = mlx4_check_fmr(fmr, page_list, npages, iova);
if (err)
return err;

++fmr->maps;

key = key_to_hw_index(fmr->mr.key);
key += dev->caps.num_mpts;
*lkey = *rkey = fmr->mr.key = hw_index_to_key(key);

*(u8 *) fmr->mpt = MLX4_MPT_STATUS_SW;

/* Make sure MPT status is visible before writing MTT entries */
wmb();

dma_sync_single_for_cpu(&dev->pdev->dev, fmr->dma_handle,
npages * sizeof(u64), DMA_TO_DEVICE);

for (i = 0; i < npages; ++i)
fmr->mtts[i] = cpu_to_be64(page_list[i] | MLX4_MTT_FLAG_PRESENT);

dma_sync_single_for_device(&dev->pdev->dev, fmr->dma_handle,
  npages * sizeof(u64), DMA_TO_DEVICE);

fmr->mpt->key    = cpu_to_be32(key);
fmr->mpt->lkey   = cpu_to_be32(key);
fmr->mpt->length = cpu_to_be64(npages * (1ull << fmr->page_shift));
fmr->mpt->start  = cpu_to_be64(iova);

/* Make MTT entries are visible before setting MPT status */
wmb();

*(u8 *) fmr->mpt = MLX4_MPT_STATUS_HW;

/* Make sure MPT status is visible before consumer can use FMR */
wmb();

return 0;
}

Because the way i understood, VF can communicate with PF driver by
posting VHCR commands which cause an event to be generated on the PF
side. I can see _WRAPPER calls to handle those cases.

As there doesn't seem to be FMR related VHCR
command(virtual/para-virtual command), I was struggling to understand
how the flow happens for FMR from
application->kernel->VF-driver->PF-driver

I would be much grateful, if you can help me understand this.


Thanks so much!! Your replies really helped me improve my understanding.



Best Regards,
Bob





On Tue, Nov 11, 2014 at 4:24 PM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Mon, 10 Nov 2014 19:58:46 +0530
> Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi,
>>
>> Is FMR (Fast Memory Regions) supported in a multi-function mode?
>
> In SRIOV, FMR is supported only for the PF, not for VFs (since this
> feature requires writing directly to mapped ICM memory).
>
> You can see this in file drivers/infiniband/hw/mlx4/main.c, function
> mlx4_ib_add() :
>
>
>         if (!mlx4_is_slave(ibdev->dev)) {
>                 ibdev->ib_dev.alloc_fmr         = mlx4_ib_fmr_alloc;
>                 ibdev->ib_dev.map_phys_fmr      = mlx4_ib_map_phys_fmr;
>                 ibdev->ib_dev.unmap_fmr         = mlx4_ib_unmap_fmr;
>                 ibdev->ib_dev.dealloc_fmr       = mlx4_ib_fmr_dealloc;
>         }
>
> i.e., the fmr functions are not put into the device virtual function
> table for slave (= VF) devices.
>
> -Jack
>
>>
>> If yes, I couldn't find the source code for the same in the mlx4
>> codebase. Can anyone please point me to the right location...
>>
>> What I was trying to understand is this:
>>
>> Suppose a VF driver wants to register large amount of memory using
>> FMR, will it be able to do so using the mlx4 code.
>>
>> Or FMR is supported only in dedicated mode?
>>
>>
>> Thanks
>>
>> Best Regards,
>> Bob
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
