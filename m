From: Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 23 Nov 2016 14:27:06 -0500
Message-ID: <6ed2c861-7493-902b-bfbd-9c937a3efba3@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
 <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
 <CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
 <20161123074902.ph7a5cmlw3pclugx@phenom.ffwll.local>
 <2a8a6582-f3de-5cda-0c6e-1c93774147e0@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <2a8a6582-f3de-5cda-0c6e-1c93774147e0-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 2016-11-23 03:51 AM, Christian K=F6nig wrote:
> Am 23.11.2016 um 08:49 schrieb Daniel Vetter:
>> On Tue, Nov 22, 2016 at 01:21:03PM -0800, Dan Williams wrote:
>>> On Tue, Nov 22, 2016 at 1:03 PM, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>>>> On Tue, Nov 22, 2016 at 9:35 PM, Serguei Sagalovitch
>>>> <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org> wrote:
>>>>> On 2016-11-22 03:10 PM, Daniel Vetter wrote:
>>>>>> On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams =

>>>>>> <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> wrote:
>>>>>>> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
>>>>>>> <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org> wrote:
>>>>>>>> I personally like "device-DAX" idea but my concerns are:
>>>>>>>>
>>>>>>>> -  How well it will co-exists with the  DRM infrastructure /
>>>>>>>> implementations
>>>>>>>>      in part dealing with CPU pointers?
>>>>>>> Inside the kernel a device-DAX range is "just memory" in the sense
>>>>>>> that you can perform pfn_to_page() on it and issue I/O, but the =

>>>>>>> vma is
>>>>>>> not migratable. To be honest I do not know how well that co-exists
>>>>>>> with drm infrastructure.
>>>>>>>
>>>>>>>> -  How well we will be able to handle case when we need to
>>>>>>>> "move"/"evict"
>>>>>>>>      memory/data to the new location so CPU pointer should =

>>>>>>>> point to the
>>>>>>>> new
>>>>>>>> physical location/address
>>>>>>>>       (and may be not in PCI device memory at all)?
>>>>>>> So, device-DAX deliberately avoids support for in-kernel =

>>>>>>> migration or
>>>>>>> overcommit. Those cases are left to the core mm or drm. The =

>>>>>>> device-dax
>>>>>>> interface is for cases where all that is needed is a =

>>>>>>> direct-mapping to
>>>>>>> a statically-allocated physical-address range be it persistent =

>>>>>>> memory
>>>>>>> or some other special reserved memory range.
>>>>>> For some of the fancy use-cases (e.g. to be comparable to what =

>>>>>> HMM can
>>>>>> pull off) I think we want all the magic in core mm, i.e. =

>>>>>> migration and
>>>>>> overcommit. At least that seems to be the very strong drive in all
>>>>>> general-purpose gpu abstractions and implementations, where =

>>>>>> memory is
>>>>>> allocated with malloc, and then mapped/moved into vram/gpu address
>>>>>> space through some magic,
>>>>> It is possible that there is other way around: memory is requested =

>>>>> to be
>>>>> allocated and should be kept in vram for  performance reason but due
>>>>> to possible overcommit case we need at least temporally to "move" =

>>>>> such
>>>>> allocation to system memory.
>>>> With migration I meant migrating both ways of course. And with stuff
>>>> like numactl we can also influence where exactly the malloc'ed memory
>>>> is allocated originally, at least if we'd expose the vram range as a
>>>> very special numa node that happens to be far away and not hold any
>>>> cpu cores.
>>> I don't think we should be using numa distance to reverse engineer a
>>> certain allocation behavior.  The latency data should be truthful, but
>>> you're right we'll need a mechanism to keep general purpose
>>> allocations out of that range by default. Btw, strict isolation is
>>> another design point of device-dax, but I think in this case we're
>>> describing something between the two extremes of full isolation and
>>> full compatibility with existing numactl apis.
>> Yes, agreed. My idea with exposing vram sections using numa nodes wasn't
>> to reuse all the existing allocation policies directly, those won't =

>> work.
>> So at boot-up your default numa policy would exclude any vram nodes.
>>
>> But I think (as an -mm layman) that numa gives us a lot of the tools and
>> policy interface that we need to implement what we want for gpus.
>
> Agree completely. From a ten mile high view our GPUs are just command =

> processors with local memory as well .
>
> Basically this is also the whole idea of what AMD is pushing with HSA =

> for a while.
>
> It's just that a lot of problems start to pop up when you look at all =

> the nasty details. For example only part of the GPU memory is usually =

> accessible by the CPU.
>
> So even when numa nodes expose a good foundation for this I think =

> there is still a lot of code to write.
>
> BTW: I should probably start to read into the numa code of the kernel. =

> Any good pointers for that?
I would assume that "page" allocation logic itself should be inside of =

graphics driver due to possible different requirements especially from =

graphics: alignment, etc.

>
> Regards,
> Christian.
>
>> Wrt isolation: There's a sliding scale of what different users expect,
>> from full auto everything, including migrating pages around if needed to
>> full isolation all seems to be on the table. As long as we keep vram =

>> nodes
>> out of any default allocation numasets, full isolation should be =

>> possible.
>> -Daniel
>
>

Sincerely yours,
Serguei Sagalovitch
