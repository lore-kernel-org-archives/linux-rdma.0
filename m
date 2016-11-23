From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 23 Nov 2016 12:32:28 -0700
Message-ID: <20161123193228.GC12146@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7bc38037-b6ab-943f-59db-6280e16901ab-5C7GfCeVMHo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>
Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig, Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2016 at 02:14:40PM -0500, Serguei Sagalovitch wrote:
> 
> On 2016-11-23 02:05 PM, Jason Gunthorpe wrote:

> >As Bart says, it would be best to be combined with something like
> >Mellanox's ODP MRs, which allows a page to be evicted and then trigger
> >a CPU interrupt if a DMA is attempted so it can be brought back.

> Please note that in the general case (including  MR one) we could have
> "page fault" from the different PCIe device. So all  PCIe device must
> be synchronized.

Standard RDMA MRs require pinned pages, the DMA address cannot change
while the MR exists (there is no hardware support for this at all), so
page faulting from any other device is out of the question while they
exist. This is the same requirement as typical simple driver DMA which
requires pages pinned until the simple device completes DMA.

ODP RDMA MRs do not require that, they just page fault like the CPU or
really anything and the kernel has to make sense of concurrant page
faults from multiple sources.

The upshot is that GPU scenarios that rely on highly dynamic
virtual->physical translation cannot sanely be combined with standard
long-life RDMA MRs.

Certainly, any solution for GPUs must follow the typical page pinning
semantics, changing the DMA address of a page must be blocked while
any DMA is in progress.

> >Does HMM solve the peer-peer problem? Does it do it generically or
> >only for drivers that are mirroring translation tables?

> In current form HMM doesn't solve peer-peer problem. Currently it allow
> "mirroring" of  "malloc" memory on GPU which is not always what needed.
> Additionally  there is need to have opportunity to share VRAM allocations
> between  different processes.

Humm, so it can be removed from Alexander's list then :\

As Dan suggested, maybe we need to do both. Some kind of fix for
get_user_pages() for smaller mappings (eg ZONE_DEVICE) and a mandatory
API conversion to get_user_dma_sg() for other cases?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
