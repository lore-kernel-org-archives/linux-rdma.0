From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Wed, 16 Feb 2011 20:06:50 -0500
Message-ID: <1297904810.8833.44.camel@lap75545.ornl.gov>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
 <4D342510.80701@voltaire.com>
 <1295318783.3051.81.camel@obelisk.thedillows.org>
 <4D353E5E.2020500@voltaire.com>
 <1295353524.3051.121.camel@obelisk.thedillows.org>
 <4D380AF2.4010905@voltaire.com>
 <1295525737.22825.24.camel@obelisk.thedillows.org>
 <4D3D9845.4050803@voltaire.com> <1295897819.29946.17.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295897819.29946.17.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-01-24 at 14:36 -0500, David Dillow wrote:
> On Mon, 2011-01-24 at 10:18 -0500, Or Gerlitz wrote:
> > I see, thanks for clarifying this out load and clear, so maybe you'll
> > first get the seven srp patches reviewed and merged, and only then see
> > if/what benefit this patch brings, I'm a little bit worried of
> > changing something below everyone's (srp, iser, rds, p9, nfs-rdma,
> > lustre, etc) legs which doesn't have any notable benefit, I would be
> > happy to hear others/opinions
> 
> Well, I believe it only affects the block merging -- I have to catch a
> flight, so I cannot recheck right this moment -- that limits the effects
> to SRP and iSER. The others don't use it at all.

Ok, finally got a chance to look into this a bit further. The block
layer is the only direct user of it, though a few IOMMU drivers
reference it as well for their *_map_sg coalescing code. pci-gart_64 on
x86, and a smattering on on sparc, powerpc, and ia64.

Since other IB protocols could potentially see larger segments with
this, let's check those:

iSER is fine, because you limit your maximum request size to 512 KB, so
we'll never overrun the page vector in struct iser_page_vec (128 entries
currently). It is independent of the DMA segment size, and handles
multi-page segments already.

IPoIB is fine, as it maps each page individually, and doesn't use
ib_dma_map_sg().

RDS appears to do the right thing and has no dependencies on DMA segment
size, but I don't claim to have done a complete audit.

NFSoRDMA and 9p are OK -- they do not use ib_dma_map_sg(), so they
doesn't care about the coalescing.

Lustre's ko2iblnd does not care about coalescing -- it properly walks
the returned sg list.


I don't see anything that would have a problem with larger DMA segment
sizes; some of them would see small efficiency gains similar to SRP if
more small segments could be coalesced into fewer larger ones.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
