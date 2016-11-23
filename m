From: Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 23 Nov 2016 14:14:40 -0500
Message-ID: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161123190515.GA12146-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bridgman,
 John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander,
 Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 2016-11-23 02:05 PM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 10:13:03AM -0700, Logan Gunthorpe wrote:
>
>> an MR would be very tricky. The MR may be relied upon by another host
>> and the kernel would have to inform user-space the MR was invalid then
>> user-space would have to tell the remote application.
> As Bart says, it would be best to be combined with something like
> Mellanox's ODP MRs, which allows a page to be evicted and then trigger
> a CPU interrupt if a DMA is attempted so it can be brought back.
Please note that in the general case (including  MR one) we could have
"page fault" from the different PCIe device. So all  PCIe device must
be synchronized.
> includes the usual fencing mechanism so the CPU can block, flush, and
> then evict a page coherently.
>
> This is the general direction the industry is going in: Link PCI DMA
> directly to dynamic user page tabels, including support for demand
> faulting and synchronicity.
>
> Mellanox ODP is a rough implementation of mirroring a process's page
> table via the kernel, while IBM's CAPI (and CCIX, PCI ATS?) is
> probably a good example of where this is ultimately headed.
>
> CAPI allows a PCI DMA to directly target an ASID associated with a
> user process and then use the usual CPU machinery to do the page
> translation for the DMA. This includes page faults for evicted pages,
> and obviously allows eviction and migration..
>
> So, of all the solutions in the original list, I would discard
> anything that isn't VMA focused. Emulating what CAPI does in hardware
> with software is probably the best choice, or we have to do it all
> again when CAPI style hardware broadly rolls out :(
>
> DAX and GPU allocators should create VMAs and manipulate them in the
> usual way to achieve migration, windowing, cache&mirror, movement or
> swap of the potentially peer-peer memory pages. They would have to
> respect the usual rules for a VMA, including pinning.
>
> DMA drivers would use the usual approaches for dealing with DMA from
> a VMA: short term pin or long term coherent translation mirror.
>
> So, to my view (looking from RDMA), the main problem with peer-peer is
> how do you DMA translate VMA's that point at non struct page memory?
>
> Does HMM solve the peer-peer problem? Does it do it generically or
> only for drivers that are mirroring translation tables?
In current form HMM doesn't solve peer-peer problem. Currently it allow
"mirroring" of  "malloc" memory on GPU which is not always what needed.
Additionally  there is need to have opportunity to share VRAM allocations
between  different processes.
>  From a RDMA perspective we could use something other than
> get_user_pages() to pin and DMA translate a VMA if the core community
> could decide on an API. eg get_user_dma_sg() would probably be quite
> usable.
>
> Jason
