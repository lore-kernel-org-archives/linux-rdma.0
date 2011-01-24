From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Mon, 24 Jan 2011 17:18:29 +0200
Message-ID: <4D3D9845.4050803@voltaire.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>	<4D342510.80701@voltaire.com>	<1295318783.3051.81.camel@obelisk.thedillows.org>	<4D353E5E.2020500@voltaire.com>	<1295353524.3051.121.camel@obelisk.thedillows.org>	<4D380AF2.4010905@voltaire.com> <1295525737.22825.24.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295525737.22825.24.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
>> funny, if I understand this correct, assuming each scsi_host has a dma device
>> associated with it, sg_dma_map/unmap can be taken out from the SCSI LLD code
>> and be done in higher levels, just have someone scan everyone queuecommand and
>> command response code flows to clean that out, anyway
> 
> Perhaps, except for the need for different devices to call different map
> commands, such as ib_dma_*() and sbus_dma_*() etc. There may be other
> reasons as well.

yes, I tend to think that there could be other reasons, else, if this (calling dma mapping from the SCSI LLD queuecommand code) is just something which was needed on the 2.4 days but not any more, day will come and someone will pick the glove and make this cleanup. 

BTW - ib_dma_map_xxx and friends are considered by me as bug and not a feature, it was push by the ipath/qib guys and I was holding a minority opinion that we need to stick to dma_map_xxx and have these drivers implement their own software IOMMU emulation. The reason my opinion wasn't accepted is that they're supported only on 64 bit platforms over which (that was the claim back then) each page has a kernel virtual address associated with it, oh well

>> I'm still trying to understand the bigger picture with your patch set and what
>> role the mlx4/mthca patch has in it

> This patch is orthogonal to the SRP mapping changes and was not used for
> the performance numbers listed -- the 50% improvement was achieved with
> _no_ coalescing in the SG lists. Each 4 KB page was its own SG entry.

I see, thanks for clarifying this out load and clear, so maybe you'll first get the seven srp patches reviewed and merged, and only then see if/what benefit this patch brings, I'm a little bit worried of changing something below everyone's (srp, iser, rds, p9, nfs-rdma, lustre, etc) legs which doesn't have any notable benefit, I would be happy to hear others/opinions

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
