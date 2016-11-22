From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 22 Nov 2016 12:24:32 -0800
Message-ID: <CAPcyv4gT8QojYe0__EsR5o59+tAoLAqBWbj=rj-HnqHJo3tYOA@mail.gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com> <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Serguei Sagalovitch <serguei.sagalovitch@amd.com>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2016 at 12:10 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
>> <serguei.sagalovitch@amd.com> wrote:
>>> I personally like "device-DAX" idea but my concerns are:
>>>
>>> -  How well it will co-exists with the  DRM infrastructure / implementations
>>>    in part dealing with CPU pointers?
>>
>> Inside the kernel a device-DAX range is "just memory" in the sense
>> that you can perform pfn_to_page() on it and issue I/O, but the vma is
>> not migratable. To be honest I do not know how well that co-exists
>> with drm infrastructure.
>>
>>> -  How well we will be able to handle case when we need to "move"/"evict"
>>>    memory/data to the new location so CPU pointer should point to the new
>>> physical location/address
>>>     (and may be not in PCI device memory at all)?
>>
>> So, device-DAX deliberately avoids support for in-kernel migration or
>> overcommit. Those cases are left to the core mm or drm. The device-dax
>> interface is for cases where all that is needed is a direct-mapping to
>> a statically-allocated physical-address range be it persistent memory
>> or some other special reserved memory range.
>
> For some of the fancy use-cases (e.g. to be comparable to what HMM can
> pull off) I think we want all the magic in core mm, i.e. migration and
> overcommit. At least that seems to be the very strong drive in all
> general-purpose gpu abstractions and implementations, where memory is
> allocated with malloc, and then mapped/moved into vram/gpu address
> space through some magic, but still visible on both the cpu and gpu
> side in some form. Special device to allocate memory, and not being
> able to migrate stuff around sound like misfeatures from that pov.

Agreed. For general purpose P2P use cases where all you want is
direct-I/O to a memory range that happens to be on a PCIe device then
I think a special device fits the bill. For gpu P2P use cases that
already have migration/overcommit expectations then it is not a good
fit.
