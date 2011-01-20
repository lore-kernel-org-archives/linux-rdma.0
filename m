From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Thu, 20 Jan 2011 12:14:10 +0200
Message-ID: <4D380AF2.4010905@voltaire.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>	<4D342510.80701@voltaire.com>	<1295318783.3051.81.camel@obelisk.thedillows.org>	<4D353E5E.2020500@voltaire.com> <1295353524.3051.121.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295353524.3051.121.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> On Tue, 2011-01-18 at 09:16 +0200, Or Gerlitz wrote:
>> David Dillow wrote:

> For SCSI commands, it is called in scsi_init_sgtable(), which is called
> by scsi_init_io(), called in turn by scsi_setup_blk_pc_cmnd() and
> scsi_setup_fs_cmnd(). Those are called by various function in the sd
> driver, notably sd_prep_fn() which is the block queue prep function
> called for each request

funny, if I understand this correct, assuming each scsi_host has a dma device
associated with it, sg_dma_map/unmap can be taken out from the SCSI LLD code
and be done in higher levels, just have someone scan everyone queuecommand and
command response code flows to clean that out, anyway

> Most likely, but there's no point in using an FMR for a individual S/G
> entry larger than the FMR size -- it's just extra work and consumes
> unneeded resources. That's not an issue in the current code, but is a
> small optimization in my new mapping code, which I hope to post later today.

I'm still trying to understand the bigger picture with your patch set and what
role the mlx4/mthca patch has in it, here you mention "small optimization" but
the srp patchset has up to 50% improvement in some flows, so what's the actual
part of this patch? e.g what patch/es in the srp patch series take advantage of
this fix?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
