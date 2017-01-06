From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 5 Jan 2017 17:30:34 -0700
Message-ID: <20170106003034.GB4670@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170105232352.GB6426-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: david1.zhou-5C7GfCeVMHo@public.gmane.org, qiang.yu-5C7GfCeVMHo@public.gmane.org, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org'" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Sagalovitch,
 Serguei" <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 05, 2017 at 06:23:52PM -0500, Jerome Glisse wrote:

> > I still don't understand what you driving at - you've said in both
> > cases a user VMA exists.
> 
> In the former case no, there is no VMA directly but if you want one than
> a device can provide one. But such VMA is useless as CPU access is not
> expected.

I disagree it is useless, the VMA is going to be necessary to support
upcoming things like CAPI, you need it to support O_DIRECT from the
filesystem, DPDK, etc. This is why I am opposed to any model that is
not VMA based for setting up RDMA - that is shorted sighted and does
not seem to reflect where the industry is going.

So focus on having VMA backed by actual physical memory that covers
your GPU objects and ask how do we wire up the '__user *' to the DMA
API in the best way so the DMA API still has enough information to
setup IOMMUs and whatnot.

> What i was trying to get accross is that no matter what level you
> consider in the end you still need something at the DMA API level.
> And that the 2 different use case (device vma or regular vma) means
> 2 differents API for the device driver.

I agree we need new stuff at the DMA API level, but I am opposed to
the idea we need two API paths that the *driver* has to figure out.
That is fundamentally not what I want as a driver developer.

Give me a common API to convert '__user *' to a scatter list and pin
the pages. This needs to figure out your two cases. And Huge
Pages. And ZONE_DIRECT.. (a better get_user_pages)

Give me an API to take the scatter list and DMA map it, handling all
the stuff associated with peer-peer. (a better dma_map_sg)

Give me a notifier scheme to rework my scatter list when physical
pages need to change (mmu notifiers)

Use the scatter list memory to convey needed information from the
first step to the second.

Do not bother the driver with distinctions on what kind of memory is
behind that VMA. Don't ask me to use get_user_pages or
gpu_get_user_pages, do not ask me to use dma_map_sg or
dma_map_sg_peer_direct. The Driver Doesn't Need To Know.

IMHO this is why GPU direct is not mergable - it creates a crazy
parallel mini-mm subsystem inside RDMA and uses that to connect to a
GPU driver, everything is expected to have parallel paths for GPU
direct and normal MM. No good at all.

> > So, how do you identify these GPU objects? How do you expect RDMA
> > convert them to scatter lists? How will ODP work?
> 
> No ODP on those. If you want vma, the GPU device driver can provide

You said you needed invalidate, that has to be done via ODP.

Jason
