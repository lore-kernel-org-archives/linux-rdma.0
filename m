From: Stephen Bates <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
Subject: RE: [RFC 0/7] Peer-direct memory
Date: Thu, 18 Feb 2016 14:44:28 +0000
Message-ID: <36F6EBABA23FEF4391AF72944D228901EB70C102@BBYEXM01.pmc-sierra.internal>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <20160212201328.GA14122@infradead.org>
 <20160212203649.GA10540@obsidianresearch.com>
 <56C09C7E.4060808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C09C7E.4060808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "'Logan Gunthorpe' (logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org)" <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-Dj0/KMMU01E@public.gmane.org" <leon-Dj0/KMMU01E@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sagi

> CC'ing sbates who played with this stuff at some point...

Thanks for inviting me to this party Sagi ;-). Here are some comments and responses based on our experiences. Apologies in advance for the list format:

1. As it stands in 4.5-rc4 devm_memremap_pages will not work with iomem. Myself and  (mostly) Logan (cc'ed here) developed the ability to do that in an out of tree patch for memremap.c. We also developed a simple example driver for a PCIe device that exposes DRAM on the card via a BAR. We used this code to provide some feedback to Dan (e.g.  [1]-[3]). At this time we are preparing an RFC to extend devm_memremap_pages for IO memory and we hope to have that ready soon but there is no guarantee our approach is acceptable to the community. My hope is that it will be a good starting point for moving forward...

2. The two good things about Peer-Direct are that is works and it is here today. That said, I do think an approach based on ZONE_DEVICE is more general and a preferred way to allow IO devices to communicate with each other. The question is can we find such an approach that is acceptable to the community? As noted in point 1 I hope the coming RFC will initiate a discussion. I have also requested attendance at LSF/MM to discuss this topic (among others). 

3. As of now the section alignment requirement is somewhat relaxed. I quote from [4]. 

"I could loosen the restriction a bit to allow one unaligned mapping
per section.  However, if another mapping request came along that
tried to map a free part of the section it would fail because the code
depends on a  "1 dev_pagemap per section" relationship.  Seems an ok
compromise to me..."

This is implemented in 4.5-rc4 (see memremap.c line 315).

4. The out of tree patch we did allows one to register the device memory as IO memory. However, we were only concerned with DRAM exposed on the BAR and so were not affected by the "i/o side effects" issues. Someone would need to think about how this applies to IOMEM that does have side-effects when accessed.

5. I concur with Sagi's comment below that one approach we can use to inform 3rd party device drives about vanishing memory regions is via mmu_notifiers. However this needs to be fleshed out and tied into the relevant driver(s).

6. In full disclosure, my main interest in this ties in to NVM Express devices which can act as DMA masters and expose regions of IOMEM at the same time (via CMBs). I want to be able to tie these devices together with other IO devices (like RDMA NICs, FPGA and GPGPU based offload engines, other NVMe devices and storage adaptors) in a peer-2-peer fashion and may not always have a RDMA device in the mix...

Cheers

Stephen

[1] https://lists.01.org/pipermail/linux-nvdimm/2015-October/002357.html
[2] https://lwn.net/Articles/667148/
[3] https://lists.01.org/pipermail/linux-nvdimm/2015-December/003104.html
[4] https://lists.01.org/pipermail/linux-nvdimm/2015-December/003141.html


> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Sunday, February 14, 2016 8:26 AM
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Christoph
> Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-Dj0/KMMU01E@public.gmane.org;
> haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Stephen Bates
> <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
> Subject: Re: [RFC 0/7] Peer-direct memory
> 
> 
> >> Agreed on all points.  Nevermind that seems to be missing a user of
> >> all the newly added infrastructure, which should come with the series.
> >
> > Yep!
> >
> > I've heard from the people working on NVMe cards that this approach
> > isn't needed, desired, or correct. I'm deeply skeptical that there
> > would be an in-kernel user.
> 
> Hey Jason,
> 
> So regarding NVMe, a possible user for this would be a user-space NVMe
> target implementation which wants to use a CMB (controller memory buffer
> on the device bar) as an intermediate memory for RDMA. In case the NVMe
> unplugs we can't rely on user-space to handle it, and need a way to tell the
> HCA to tear down the CMB mappings.
> 
> I do think that this problem is solvable if we create a mmu_notitifier client for
> this mapping (assuming that device unplug will trigger mmu invalidate
> callouts on the relevant pages). But I'm still not exactly sure how
> ZONE_DEVICE works with I/O device bar though (I'll appreciate if someone
> can educate me here).
> 
> CC'ing sbates who played with this stuff at some point...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
