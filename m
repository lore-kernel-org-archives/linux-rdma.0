From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Mon, 17 Jan 2011 21:46:23 -0500
Message-ID: <1295318783.3051.81.camel@obelisk.thedillows.org>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
	 <4D342510.80701@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D342510.80701-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or!

On Mon, 2011-01-17 at 13:16 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > By default, each device is assumed to be able only handle 64 KB chunks during DMA.
> > By giving the segment size a larger value, the block layer
> > will coalesce more S/G entries together for SRP, allowing larger
> > requests with the same sg_tablesize setting.
> 
> Hi Dave,
> 
> I'd be happy if you can elaborate more or point me to some article which 
> explains how this setting effects the kernel sg coalescing code, specifically -
> when the block layer considers both the scsi sg_tablesize advertised by the SCSI
> LLD for a scsi host H and the max_set_size set for the dma device used by H, does
> it use a minimum function? 
> 
> Looking on the code of block/blk-merge.c :: blk_rq_map_sg , which I was thinking to be 
> relevant here, I don't see any reference to sg_table_size / max_sectors, since its 
> block layer, non scsi specific code, so I guess that for scsi devices, there's 
> some over-ruling done before/after that code runs?

We're talking about different things --
max_segments(sg_tablesize)/max_sectors are the limits as we're adding
pages to the bio via bio_add_page(). blk_rq_map_sg() uses
max_segment_size as a bound on the largest S/G entry into which it can
coalesce multiple entries from the BIO.

It is considered in the line
	if (sg->length + nbytes > queue_max_segment_size(q))
		goto new_segment;

max_segment_size for SCSI devices gets by the DMA values from
shost->shost_gendev.parent in __scsi_alloc_queue().
shost->shost_gendev.parent is set to ib_device->dma_device by SRP when
it calls scsi_add_host(). ib_device->dma_device is set to &pdev->dev by
the underlying hardware drivers.

> In iser we want to support up to 512KB IOs, so sg_tablesize is 128 (=512>>12)
> which on systems with 4K page size accounts to 512K totally (we also set max_sectors 
> to 1024, so on systems with 16K or whatever page size, we'll not get > 512K IOs).

Yes, but without this change, you will get your 512 KB request in 8 S/G
entries minimum, when it could be in one if contiguous. For our systems
where we're trying to get 1 MB or larger IOs over SRP, we get 16 S/G
entries when we could get one, potentially forcing us into using FMRs
and doing additional work when we could just map the single entry
directly.

> > This ups the value on Mellanox hardware to 2 GB, though there is no HW limit.
> > It could be 3 GB or even (4 GB - 1), since it's an unsigned int, but we
> > should rarely see a 2 GB request anyways.
> 
> I think that typically systems will not issue IOs larger then 1/2/4 MBs for
> bunch of reasons, so unless I miss somebigthing here, 1/2/(4-1)GB is thousand
> times these quantities...

The size could be 1, 2, 4, 8 MB or whatever. But if there isn't a HW
limit, then why limit yourself at all? Let the block code merge the
contiguous entries as much as it likes. Not merging entries causes us to
do more work unnecessarily -- either by taking a more heavy-weight path
or by walking more S/G entries, possibly doing your own coalescing of
contiguous S/G entries, etc.

I noticed this when working on SRP, as I didn't want to have to iterate
over contiguous S/G entries to notice when they were larger than an FMR
could map, and should be put in the indirect table directly. I thought
that was something the block layer should be doing for me, and looked
into why it wasn't happening. I also found a lack of coalescing in an
IOMMU driver, but that's a different email. :)

To be sure, this is not going to be a huge efficiency gain, but it does
reduce CPU usage and raises the largest possible IO size with the
default srp_sg_tablesize of 12 from 768 KB to some 24 GB. Not that we'd
likely need that large of a request or be able to allocate 12 2GB
contiguous memory areas, of course.

> > This patch also reduces the iterations in SRP's mapping code for some
> > upcoming patches I have.
> 
> These patches aren't targeted for the 2.6.38 merge window, correct? in that
> case, I'd like to let us some time to discuss / better understand the low level
> drivers patch and not merge it for this window, agree?

Sorry, I wasn't clear -- this wasn't aimed at this merge window.

I hope I've explained things a bit better -- please let me know if not.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
