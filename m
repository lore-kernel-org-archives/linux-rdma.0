From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Tue, 18 Jan 2011 07:25:24 -0500
Message-ID: <1295353524.3051.121.camel@obelisk.thedillows.org>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
	 <4D342510.80701@voltaire.com>
	 <1295318783.3051.81.camel@obelisk.thedillows.org>
	 <4D353E5E.2020500@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D353E5E.2020500-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-01-18 at 09:16 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > We're talking about different things -- max_segments(sg_tablesize)/max_sectors are 
> > the limits as we're adding pages to the bio via bio_add_page(). blk_rq_map_sg() uses
> > max_segment_size as a bound on the largest S/G entry into which it can
> > coalesce multiple entries from the BIO.
> > It is considered in the line
> > 	if (sg->length + nbytes > queue_max_segment_size(q))
> > 		goto new_segment;
> 
> Dave, thanks for the detailed explanation, I understand it much better now, just
> to make sure, blk_rq_map_sg() is called through the flow of dma_map_sg, correct?

For SCSI commands, it is called in scsi_init_sgtable(), which is called
by scsi_init_io(), called in turn by scsi_setup_blk_pc_cmnd() and
scsi_setup_fs_cmnd(). Those are called by various function in the sd
driver, notably sd_prep_fn() which is the block queue prep function
called for each request.

> If this is the case, we're talking on decision making done by the block layer
> during dma-mapping which later affect the "IB IOMMU mapping" at the IB driver 
> (e.g srp, iser, etc).

Correct, this is all done before srp_queuecommand() is called, and
before any DMA mapping is done. This is before ib_dma_map_sg() is
called, and reduces the number of entries in the S/G list passed to that
function, but the total data will be the same.

> >> In iser we want to support up to 512KB IOs, so sg_tablesize is 128 (=512>>12)
> >> which on systems with 4K page size accounts to 512K totally (we also set max_sectors 
> >> to 1024, so on systems with 16K or whatever page size, we'll not get > 512K IOs).
> 
> > Yes, but without this change, you will get your 512 KB request in 8 S/G
> > entries minimum, when it could be in one if contiguous. For our systems
> > where we're trying to get 1 MB or larger IOs over SRP, we get 16 S/G
> > entries when we could get one, potentially forcing us into using FMRs
> > and doing additional work when we could just map the single entry directly.
> 
> Since the block layer did its best to coalesce multiple entries from the BIO
> to SG(s), you would need to FMR whenever dma_map_sg returns value > 1

Most likely, but there's no point in using an FMR for a individual S/G
entry larger than the FMR size -- it's just extra work and consumes
unneeded resources. That's not an issue in the current code, but is a
small optimization in my new mapping code, which I hope to post later
today.

> As you mention later on, I wonder what would be the benefit from not using FMRs 
> as we're talking on large IOs (> 64K, by the assumption that the block it coalesces 
> today BIOs that allow that, i.e their pages are contiguous), for which I would 
> expect latency, bandwidth and IOPS not to be effected by no-FMRing them. So we're
> remained with the CPU usage saving, do you have (say) "vmstat 1" snapshots before/after
> this patch with the ~same IO tool/load that can help quantify this saving?

No, and I'm pretty sure the savings won't show up in such a coarse
measurement. I'm not even sure the CPU overhead is even above the noise
floor, but it would seem to be an obvious savings, however minor. In
addition, we are currently breaking up IOs and requiring FMR even when
the entire region is contiguous. I could piece those back together in
the initiator, but that's simply extra work that is duplicative of the
work done by the block layer, wasting further CPU cycles.

> Also when working with direct I/O from user space and/or under file-system,
> did you really see many BIOs that can be merged? I was under the impression,
> that (specifically after some time the system is active) for the most case, 
> I get totally scattered SGs, whose pages can't be coalesced at all.

I would expect that to be a common case, but there are systems out there
that this is not an issue. They typically allocate buffers early on when
they can be contiguous, and just keep reusing those.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
