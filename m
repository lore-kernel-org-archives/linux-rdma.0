From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Mon, 24 Jan 2011 14:36:59 -0500
Message-ID: <1295897819.29946.17.camel@lap75545.ornl.gov>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
 <4D342510.80701@voltaire.com>
 <1295318783.3051.81.camel@obelisk.thedillows.org>
 <4D353E5E.2020500@voltaire.com>
 <1295353524.3051.121.camel@obelisk.thedillows.org>
 <4D380AF2.4010905@voltaire.com>
 <1295525737.22825.24.camel@obelisk.thedillows.org>
 <4D3D9845.4050803@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4D3D9845.4050803-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-01-24 at 10:18 -0500, Or Gerlitz wrote:
> David Dillow wrote:
> > Perhaps, except for the need for different devices to call different map
> > commands, such as ib_dma_*() and sbus_dma_*() etc. There may be other
> > reasons as well.

> BTW - ib_dma_map_xxx and friends are considered by me as bug and not a
> feature,

I'm not a fan of them either, but I've not gone looking to see if I
could find a better solution either.

> >> I'm still trying to understand the bigger picture with your patch set and what
> >> role the mlx4/mthca patch has in it
> 
> > This patch is orthogonal to the SRP mapping changes and was not used for
> > the performance numbers listed -- the 50% improvement was achieved with
> > _no_ coalescing in the SG lists. Each 4 KB page was its own SG entry.
> 
> I see, thanks for clarifying this out load and clear, so maybe you'll
> first get the seven srp patches reviewed and merged, and only then see
> if/what benefit this patch brings, I'm a little bit worried of
> changing something below everyone's (srp, iser, rds, p9, nfs-rdma,
> lustre, etc) legs which doesn't have any notable benefit, I would be
> happy to hear others/opinions

Well, I believe it only affects the block merging -- I have to catch a
flight, so I cannot recheck right this moment -- that limits the effects
to SRP and iSER. The others don't use it at all.

We know SRP is fine, and a quick glance suggests that iSER is as well --
you limit the maximum IO size, so you don't get too large of request
lists anyways. If you were to expand that, the SCSI midlayer provides
hooks that could be used to clamp down the DMA size for devices hanging
off iSER. SRP cannot do that, as while it is safe to go to a smaller
value than the hardware supports, it is not safe to try and increase it
from the default.

I'll try to recheck once I get a few moments someplace quiet.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
