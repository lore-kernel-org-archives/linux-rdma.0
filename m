From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 23 Nov 2016 14:11:29 -0700
Message-ID: <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161123203332.GA15062@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "Bridgman, John" <John.Bridgman@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 23/11/16 01:33 PM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 02:58:38PM -0500, Serguei Sagalovitch wrote:
> 
>>    We do not want to have "highly" dynamic translation due to
>>    performance cost.  We need to support "overcommit" but would
>>    like to minimize impact.  To support RDMA MRs for GPU/VRAM/PCIe
>>    device memory (which is must) we need either globally force
>>    pinning for the scope of "get_user_pages() / "put_pages" or have
>>    special handling for RDMA MRs and similar cases.
> 
> As I said, there is no possible special handling. Standard IB hardware
> does not support changing the DMA address once a MR is created. Forget
> about doing that.

Yeah, that's essentially the point I was trying to make. Not to mention
all the other unrelated hardware that can't DMA to an address that might
disappear mid-transfer.

> Only ODP hardware allows changing the DMA address on the fly, and it
> works at the page table level. We do not need special handling for
> RDMA.

I am aware of ODP but, noted by others, it doesn't provide a general
solution to the points above.

> Like I said, this is the direction the industry seems to be moving in,
> so any solution here should focus on VMAs/page tables as the way to link
> the peer-peer devices.

Yes, this was the appeal to us of using ZONE_DEVICE.

> To me this means at least items #1 and #3 should be removed from
> Alexander's list.

It's also worth noting that #4 makes use of ZONE_DEVICE (#2) so they are
really the same option. iopmem is really just one way to get BAR
addresses to user-space while inside the kernel it's ZONE_DEVICE.

Logan
