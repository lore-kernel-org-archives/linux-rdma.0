From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Mon, 17 Jan 2011 13:16:32 +0200
Message-ID: <4D342510.80701@voltaire.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295230184.2574.26.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> By default, each device is assumed to be able only handle 64 KB chunks during DMA.
> By giving the segment size a larger value, the block layer
> will coalesce more S/G entries together for SRP, allowing larger
> requests with the same sg_tablesize setting.

Hi Dave,

I'd be happy if you can elaborate more or point me to some article which 
explains how this setting effects the kernel sg coalescing code, specifically -
when the block layer considers both the scsi sg_tablesize advertised by the SCSI
LLD for a scsi host H and the max_set_size set for the dma device used by H, does
it use a minimum function? 

Looking on the code of block/blk-merge.c :: blk_rq_map_sg , which I was thinking to be 
relevant here, I don't see any reference to sg_table_size / max_sectors, since its 
block layer, non scsi specific code, so I guess that for scsi devices, there's 
some over-ruling done before/after that code runs?

In iser we want to support up to 512KB IOs, so sg_tablesize is 128 (=512>>12)
which on systems with 4K page size accounts to 512K totally (we also set max_sectors 
to 1024, so on systems with 16K or whatever page size, we'll not get > 512K IOs).

When running actual IO tests we do see the block layer sending down up to
512K IOs, even with the current / default 64K max_seg_size, so I wasn't sure
what your patch buys, taking into account my minima assumption, thoughts?

> This ups the value on Mellanox hardware to 2 GB, though there is no HW limit.
> It could be 3 GB or even (4 GB - 1), since it's an unsigned int, but we
> should rarely see a 2 GB request anyways.

I think that typically systems will not issue IOs larger then 1/2/4 MBs for
bunch of reasons, so unless I miss somebigthing here, 1/2/(4-1)GB is thousand
times these quantities...

> This patch also reduces the iterations in SRP's mapping code for some
> upcoming patches I have.

These patches aren't targeted for the 2.6.38 merge window, correct? in that
case, I'd like to let us some time to discuss / better understand the low level
drivers patch and not merge it for this window, agree?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
