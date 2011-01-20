From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Thu, 20 Jan 2011 11:52:04 +0200
Message-ID: <4D3805C4.6010203@voltaire.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov> <aday66hxxwe.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday66hxxwe.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>> [...] support for the SRP indirect memory descriptor tables, we can safely expand
>> the sg_tablesize, and realize some performance gains, in many cases quite large.
>> [..] the rareness of FMR mapping failures allows the mapping code to function,
>> at a risk, with existing targets.

> Have you considered using memory registration through a send queue (from
> the base memory management extensions)?  mlx4 at least has support for
> this operation, which would let you pre-allocate everything and avoid
> the possibility of failure (I think). When do we get FMR mapping failures now?

Dave, with myself being a little behind on srp... would it be correct to 
say that in the initiator side indirect mapping <--> using FMR? 

> Device	Size	Baseline	Patched
> SAS	1M	524 MB/s	1004 MB/s

Starting with the features (perf improvements) that this patch series brings, 
if we look on the 50% for SAS/1M IOs that you're presenting, can you tell 
what made the difference, srp went from sg_tablesize of 255 to 256 so the 
upper layers where able to provide 1M as one IO, where you fmr-ing here or 
not? if not, is this as of the mlx4 patch for the dma_max_seg_size and your 
special environment that allows you to get 1M as single SG entry? 
anything else in that patch set?

Now moving to the bugs (fmr mapping failures) this series addresses, can
you report/shed any light on the failures? and/or how to produce them?

Roland, I wasn't sure to follow if the usage of the FMRs ala the IB spec, 
which are supported by mlx4 you were suggesting came to address the bugs
or the features... 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
