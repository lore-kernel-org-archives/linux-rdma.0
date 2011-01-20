From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Thu, 20 Jan 2011 07:54:04 -0500
Message-ID: <1295528044.22825.64.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <aday66hxxwe.fsf@cisco.com>  <4D3805C4.6010203@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D3805C4.6010203-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-20 at 11:52 +0200, Or Gerlitz wrote:
> Roland Dreier wrote:
> >> [...] support for the SRP indirect memory descriptor tables, we can safely expand
> >> the sg_tablesize, and realize some performance gains, in many cases quite large.
> >> [..] the rareness of FMR mapping failures allows the mapping code to function,
> >> at a risk, with existing targets.
> 
> > Have you considered using memory registration through a send queue (from
> > the base memory management extensions)?  mlx4 at least has support for
> > this operation, which would let you pre-allocate everything and avoid
> > the possibility of failure (I think). When do we get FMR mapping failures now?
> 
> Dave, with myself being a little behind on srp... would it be correct to 
> say that in the initiator side indirect mapping <--> using FMR?

In general, yes. But there are cases where we use FMR and a direct
memory descriptor. And we can use indirect memory descriptors without
FMR.

> > Device	Size	Baseline	Patched
> > SAS	1M	524 MB/s	1004 MB/s
> 
> Starting with the features (perf improvements) that this patch series brings, 
> if we look on the 50% for SAS/1M IOs that you're presenting, can you tell 
> what made the difference, srp went from sg_tablesize of 255 to 256 so the 
> upper layers where able to provide 1M as one IO, where you fmr-ing here or 
> not?

This win is from sg_tablesize going from 255 to 256 in this case; the HW
really likes that better than getting two requests -- one for 1020 KB
and one for 4 KB. FMR was used for the mapping, so it dropped to doing a
direct memory descriptor. The larger IO sizes also used FMR, but used
indirect memory descriptors, as I was using SRP_FMR_SIZE == 256 for the
testing.

> if not, is this as of the mlx4 patch for the dma_max_seg_size and your 
> special environment that allows you to get 1M as single SG entry? 
> anything else in that patch set?

The mlx4 patch was not used for this testing. I set dma_boundary on the
SCSI host so that I got each 4 KB page in its own SG entry to simulate
maximum memory fragmentation on the host.

> Now moving to the bugs (fmr mapping failures) this series addresses, can
> you report/shed any light on the failures? and/or how to produce them?

I don't believe that they happen in practice, but are corner cases in
the code. However, I'm not willing to risk silent corruption in those
cases, so I think having the target support is important -- even if it
is only used as a fallback on error. I also give a way to allow users to
take advantage of the performance improvement even if the target doesn't
implement the full SRP spec -- it is more noisy and will retry the
command, hoping for a transient failure.

> Roland, I wasn't sure to follow if the usage of the FMRs ala the IB spec, 
> which are supported by mlx4 you were suggesting came to address the bugs
> or the features... 

I'm sure Roland will answer for himself, but I took his suggestion as a
way to guarantee no failures, so that vendor support wouldn't be needed.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
