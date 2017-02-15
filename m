From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 08:33:35 -0500 (EST)
Message-ID: <90797260.31671071.1487165615598.JavaMail.zimbra@redhat.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com> <20170214185636.29250-2-bart.vanassche@sandisk.com> <20170215071449.GM6989@mtr-leonro.local> <20170215081945.GP6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215081945.GP6989-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "# 4 . 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Mark
> Bloch" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Artemy Kovalyov" <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "# 4
> . 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Sent: Wednesday, February 15, 2017 3:19:45 AM
> Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> 
> On Wed, Feb 15, 2017 at 09:14:49AM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 14, 2017 at 10:56:29AM -0800, Bart Van Assche wrote:
> > > Tests have shown that the following error message is reported when
> > > using SG-GAPS registration with an mlx5 adapter:
> > >
> > > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE
> > > ffff880bd4270eb0
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 0f007806 2500002a ad9fafd1
> > > scsi host1: ib_srp: reconnect succeeded
> > > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 0f007806 25000032 00105dd0
> > > scsi host1: ib_srp: failed FAST REG status memory management operation
> > > error (6) for CQE ffff880b92860138
> > >
> > > Hence avoid using SG-GAPS memory registrations. Additionally,
> > > always configure the blk_queue_virt_boundary() to avoid to trigger
> > > a mapping failure when using adapters that support SG-GAPS (e.g.
> > > mlx5).
> >
> > According to the error dump, we have an issue with max_page_list_len
> > supplied and/or
> > internal calculations from that value to the UMR byte count.
> 
> Hi Bart,
> 
> Do you mind to try your test on my branch rdma-next [1] with the following
> fixup?
> 
> diff --git a/drivers/infiniband/hw/mlx5/mr.c
> b/drivers/infiniband/hw/mlx5/mr.c
> index 3c1f483d003f..3e59dce10d5e 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1045,8 +1045,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx,
> int npages,
>  	for (pages_mapped = 0;
>  	     pages_mapped < pages_to_map && !err;
>  	     pages_mapped += pages_iter, idx += pages_iter) {
> +		npages = min_t(int, pages_iter, pages_to_map - pages_mapped);
>  		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
> -		npages = populate_xlt(mr, idx, pages_iter, xlt,
> +		npages = populate_xlt(mr, idx, npages, xlt,
>  				      page_shift, size, flags);
> 
>  		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next
> 
> Thanks
> 

Hello Leon
Replied earlier but I dont know if my reply made it.
I will have to test this.

is this repo https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next already patched with the change you want.
If not can I just take the patch and apply to my earlier tree based just on Linus's tree where I reverted the patch.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
