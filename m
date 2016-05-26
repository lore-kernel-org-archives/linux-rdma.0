From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Thu, 26 May 2016 13:57:32 -0400
Message-ID: <50E66E8F-2578-47FD-AE71-8C1F2EAAC2C2@oracle.com>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com> <57238F8C.70505@sandisk.com> <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com> <57277B63.8030506@sandisk.com> <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com> <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com> <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il> <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com> <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com> <574728EC.9040802@grimberg.me> <57473025.5020801@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57473025.5020801-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 26, 2016, at 1:19 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
>>>>>> 
>>>>>> When debugging is disabled, kzalloc returns page-aligned
>>>>>> addresses:
>>>>> 
>>>>> Is it defined some where that regular kzalloc/kmalloc guaranties to
>>>>> return a page-aligned address as you see in your testing ? if so the
>>>>> debug mode should behave the same. Otherwise we can consider using any
>>>>> flag allocation that can force that if such exists.
>>>>> Let's get other people's input here.
>>>> 
>>>> My understanding is that the fact that k[mz]alloc() returns a
>>>> page-aligned buffer if the allocation size is > PAGE_SIZE / 2 is a
>>>> side effect of the implementation and not something callers of that
>>>> function should rely on. I think the only assumption k[mz]alloc()
>>>> callers should rely on is that the allocated memory respects
>>>> ARCH_KMALLOC_MINALIGN.
>>> 
>>> I agree. mlx4_alloc_priv_pages() is carefully designed to
>>> correct the alignment of the buffer, so it already assumes
>>> that it is not getting a page-aligned buffer.
>>> 
>>> The alignment isn't the problem here, though. It's that
>>> the buffer contains a page-boundary. That is guaranteed
>>> to be the case for HCAs that support more than 512
>>> sges, so that will have to be addressed (at least in
>>> mlx5).
>> 
>> rrr...
>> 
>> I think we should make the pages allocations dma coherent
>> in order to fix that...
>> 
>> Nice catch Chunk.
> 
> Does this untested patch help (if so, mlx5 will need an identical patch)?

Thanks, Sagi.

Is it safe?

Yes, IPoIB and NFS/RDMA work after the patch is applied.

Is it effective?

I booted with slub_debug=zfpu, and I am not able to reproduce
the Local Protection Error WC flushes.


However, it's not clear whether that's because DMA-coherent
memory is not allocated out of a slab cache, and thus it is
not subject to SLUB debugging. <shrug>

To test it more thoroughly, mlx4_alloc_priv_pages() could
allocate a two-page buffer and push the address of the
array up far enough that it would cross the page boundary.
I didn't try that.

(Also, your patch can delete the definition of
MLX4_MR_PAGES_ALIGN)

Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


> --
> diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index ba328177eae9..78e9b3addfea 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -139,7 +139,6 @@ struct mlx4_ib_mr {
>        u32                     max_pages;
>        struct mlx4_mr          mmr;
>        struct ib_umem         *umem;
> -       void                    *pages_alloc;
> };
> 
> struct mlx4_ib_mw {
> diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> index b04f6238e7e2..becb4a65c755 100644
> --- a/drivers/infiniband/hw/mlx4/mr.c
> +++ b/drivers/infiniband/hw/mlx4/mr.c
> @@ -278,30 +278,13 @@ mlx4_alloc_priv_pages(struct ib_device *device,
>                      int max_pages)
> {
>        int size = max_pages * sizeof(u64);
> -       int add_size;
> -       int ret;
> -
> -       add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
> 
> -       mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
> -       if (!mr->pages_alloc)
> +       mr->pages = dma_alloc_coherent(device->dma_device, size,
> +                               &mr->page_map, GFP_KERNEL);
> +       if (!mr->pages)
>                return -ENOMEM;
> 
> -       mr->pages = PTR_ALIGN(mr->pages_alloc, MLX4_MR_PAGES_ALIGN);
> -
> -       mr->page_map = dma_map_single(device->dma_device, mr->pages,
> -                                     size, DMA_TO_DEVICE);
> -
> -       if (dma_mapping_error(device->dma_device, mr->page_map)) {
> -               ret = -ENOMEM;
> -               goto err;
> -       }
> -
>        return 0;
> -err:
> -       kfree(mr->pages_alloc);
> -
> -       return ret;
> }
> 
> static void
> @@ -311,9 +294,8 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
>                struct ib_device *device = mr->ibmr.device;
>                int size = mr->max_pages * sizeof(u64);
> 
> -               dma_unmap_single(device->dma_device, mr->page_map,
> -                                size, DMA_TO_DEVICE);
> -               kfree(mr->pages_alloc);
> +               dma_free_coherent(device->dma_device, size,
> +                               mr->pages, mr->page_map);
>                mr->pages = NULL;
>        }
> }
> @@ -532,19 +514,8 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
>                unsigned int sg_offset)
> {
>        struct mlx4_ib_mr *mr = to_mmr(ibmr);
> -       int rc;
> 
>        mr->npages = 0;
> 
> -       ib_dma_sync_single_for_cpu(ibmr->device, mr->page_map,
> -                                  sizeof(u64) * mr->max_pages,
> -                                  DMA_TO_DEVICE);
> -
> -       rc = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
> -
> -       ib_dma_sync_single_for_device(ibmr->device, mr->page_map,
> -                                     sizeof(u64) * mr->max_pages,
> -                                     DMA_TO_DEVICE);
> -
> -       return rc;
> +       return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
> }
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
