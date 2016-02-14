From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Sun, 14 Feb 2016 11:02:12 +0200
Message-ID: <56C04294.3090701@dev.mellanox.co.il>
References: <20160214074119.GA24558@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214074119.GA24558-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> iSER on 4.5-rc3 seems to fall over pretty quickly for me.  The
> test is a a single LUN, against a Linux iSER target, also running
> 4.5-rc.  Both are usinx mlx4 hardware.  These messages appear
> immediately when running xfstests on xfs (but not during mkfs.xfs),
> and after a few dozend tests with ext4, and ultimiately lock up the
> system:
>
> Feb 13 13:33:57 redstar37 kernel: [  566.871038] iser: iser_fast_reg_fmr: ib_fmr_pool_map_phys failed: -22
> Feb 13 13:33:57 redstar37 kernel: [  566.878278] iser: iser_prepare_read_cmd: Failed to set up Data-IN RDMA
> Feb 13 13:33:57 redstar37 kernel: [  566.885604] iser: iser_send_command: conn ffff8809261bbb28 failed task->itt 5 err -22
> Feb 13 13:33:57 redstar37 kernel: [  566.899804] iser: iser_fast_reg_fmr: ib_fmr_pool_map_phys failed: -22
> Feb 13 13:33:57 redstar37 kernel: [  566.907037] iser: iser_prepare_read_cmd: Failed to set up Data-IN RDMA
> Feb 13 13:33:57 redstar37 kernel: [  566.914355] iser: iser_send_command: conn ffff8809261bbb28 failed task->itt 6 err -22
>
> When hacking the initiator to use FRs instead of FMRs I get something
> fairly similar:
>
> Feb 13 22:49:18 redstar37 kernel: [  277.500477] iser: iser_fast_reg_mr: failed to map sg (5/6)
> Feb 13 22:49:18 redstar37 kernel: [  277.506679] iser: iser_prepare_write_cmd: Failed to register write cmd RDMA mem
> Feb 13 22:49:18 redstar37 kernel: [  277.514906] iser: iser_send_command: conn ffff88091ac8cb28 failed task->itt 59 err -22
> Feb 13 22:49:18 redstar37 kernel: [  277.529614] iser: iser_fast_reg_mr: failed to map sg (5/6)
> Feb 13 22:49:18 redstar37 kernel: [  277.535785] iser: iser_prepare_write_cmd: Failed to register write cmd RDMA mem
> Feb 13 22:49:18 redstar37 kernel: [  277.544006] iser: iser_send_command: conn ffff88091ac8cb28 failed task->itt 29 err -22
> Feb 13 22:49:18 redstar37 kernel: [  277.558669] iser: iser_fast_reg_mr: failed to map sg (5/6)
> Feb 13 22:49:18 redstar37 kernel: [  277.564844] iser: iser_prepare_write_cmd: Failed to register write cmd RDMA mem
> Feb 13 22:49:18 redstar37 kernel: [  277.573069] iser: iser_send_command: conn ffff88091ac8cb28 failed task->itt 78 err -22
> Feb 13 22:49:18 redstar37 kernel: [  277.587677] iser: iser_fast_reg_mr: failed to map sg (5/6)
>
> The only other kernel version I had available quickly is 3.16 from Debian
> Jessie, and that works fine.

Thanks for reporting, I'll have a look.

I suspect this is coming from Keith+Ming changes in
blk_bio_segment_split()...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
