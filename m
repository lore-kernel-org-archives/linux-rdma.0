From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 24 Nov 2016 09:42:49 -0700
Message-ID: <20161124164249.GD20818@obsidianresearch.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <91d28749-bc64-622f-56a1-26c00e6b462a-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bridgman,
 John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Blinzer,
 Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander,
 Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2016 at 06:25:21PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 23/11/16 02:55 PM, Jason Gunthorpe wrote:
> >>> Only ODP hardware allows changing the DMA address on the fly, and it
> >>> works at the page table level. We do not need special handling for
> >>> RDMA.
> >>
> >> I am aware of ODP but, noted by others, it doesn't provide a general
> >> solution to the points above.
> > 
> > How do you mean?
> 
> I was only saying it wasn't general in that it wouldn't work for IB
> hardware that doesn't support ODP or other hardware  that doesn't do
> similar things (like an NVMe drive).

There are three cases to worry about:
 - Coherent long lived page table mirroring (RDMA ODP MR)
 - Non-coherent long lived page table mirroring (RDMA MR)
 - Short lived DMA mapping (everything else)

Like you say below we have to handle short lived in the usual way, and
that covers basically every device except IB MRs, including the
command queue on a NVMe drive.

> any complex allocators (GPU or otherwise) should respect that. And that
> seems like it should be the default way most of this works -- and I
> think it wouldn't actually take too much effort to make it all work now
> as is. (Our iopmem work is actually quite small and simple.)

Yes, absolutely, some kind of page pinning like locking is a hard
requirement.

> Yeah, we've had RDMA and O_DIRECT transfers to PCIe backed ZONE_DEVICE
> memory working for some time. I'd say it's a good fit. The main question
> we've had is how to expose PCIe bars to userspace to be used as MRs and
> such.

Is there any progress on that?

I still don't quite get what iopmem was about.. I thought the
objection to uncachable ZONE_DEVICE & DAX made sense, so running DAX
over iopmem and still ending up with uncacheable mmaps still seems
like a non-starter to me...

Serguei, what is your plan in GPU land for migration? Ie if I have a
CPU mapped page and the GPU moves it to VRAM, it becomes non-cachable
- do you still allow the CPU to access it? Or do you swap it back to
cachable memory if the CPU touches it?

One approach might be to mmap the uncachable ZONE_DEVICE memory and
mark it inaccessible to the CPU - DMA could still translate. If the
CPU needs it then the kernel migrates it to system memory so it
becomes cachable. ??

Jason
