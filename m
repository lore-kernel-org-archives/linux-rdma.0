From: Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 22 Nov 2016 13:59:24 -0500
Message-ID: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Blinzer,
 Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dan,

I personally like "device-DAX" idea but my concerns are:

-  How well it will co-exists with the  DRM infrastructure / 
implementations
    in part dealing with CPU pointers?

-  How well we will be able to handle case when we need to "move"/"evict"
    memory/data to the new location so CPU pointer should point to the 
new physical location/address
     (and may be not in PCI device memory at all)?


Sincerely yours,
Serguei Sagalovitch

On 2016-11-22 01:11 PM, Dan Williams wrote:
> On Mon, Nov 21, 2016 at 12:36 PM, Deucher, Alexander
> <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org> wrote:
>> This is certainly not the first time this has been brought up, but I'd like to try and get some consensus on the best way to move this forward.  Allowing devices to talk directly improves performance and reduces latency by avoiding the use of staging buffers in system memory.  Also in cases where both devices are behind a switch, it avoids the CPU entirely.  Most current APIs (DirectGMA, PeerDirect, CUDA, HSA) that deal with this are pointer based.  Ideally we'd be able to take a CPU virtual address and be able to get to a physical address taking into account IOMMUs, etc.  Having struct pages for the memory would allow it to work more generally and wouldn't require as much explicit support in drivers that wanted to use it.
>>
>> Some use cases:
>> 1. Storage devices streaming directly to GPU device memory
>> 2. GPU device memory to GPU device memory streaming
>> 3. DVB/V4L/SDI devices streaming directly to GPU device memory
>> 4. DVB/V4L/SDI devices streaming directly to storage devices
>>
>> Here is a relatively simple example of how this could work for testing.  This is obviously not a complete solution.
>> - Device memory will be registered with Linux memory sub-system by created corresponding struct page structures for device memory
>> - get_user_pages_fast() will  return corresponding struct pages when CPU address points to the device memory
>> - put_page() will deal with struct pages for device memory
>>
> [..]
>> 4. iopmem
>> iopmem : A block device for PCIe memory (https://lwn.net/Articles/703895/)
> The change I suggest for this particular approach is to switch to
> "device-DAX" [1]. I.e. a character device for establishing DAX
> mappings rather than a block device plus a DAX filesystem. The pro of
> this approach is standard user pointers and struct pages rather than a
> new construct. The con is that this is done via an interface separate
> from the existing gpu and storage device. For example it would require
> a /dev/dax instance alongside a /dev/nvme interface, but I don't see
> that as a significant blocking concern.
>
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2016-October/007496.html
