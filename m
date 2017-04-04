From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH RFC] hw/pvrdma: Proposal of a new pvrdma
 device
Date: Tue, 4 Apr 2017 16:38:40 +0300
Message-ID: <aa400244-426a-ea62-0ccf-ac5adb76fdd1@redhat.com>
References: <1490872341-9959-1-git-send-email-marcel@redhat.com>
 <20170330141314.GM20443@mtr-leonro.local>
 <5e952524-7c2d-b4da-4bd7-6437830a40d8@redhat.com>
 <f7f3fc0e-0a75-2fdc-b3c2-6c3d34ff2978@redhat.com>
 <20170403062314.GO20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403062314.GO20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/03/2017 09:23 AM, Leon Romanovsky wrote:
> On Fri, Mar 31, 2017 at 06:45:43PM +0300, Marcel Apfelbaum wrote:
>> On 03/30/2017 11:28 PM, Doug Ledford wrote:
>>> On 3/30/17 9:13 AM, Leon Romanovsky wrote:
>>>> On Thu, Mar 30, 2017 at 02:12:21PM +0300, Marcel Apfelbaum wrote:
>>>>> From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>>>
>>>>>  Hi,
>>>>>
>>>>>  General description
>>>>>  ===================
>>>>>  This is a very early RFC of a new RoCE emulated device
>>>>>  that enables guests to use the RDMA stack without having
>>>>>  a real hardware in the host.
>>>>>
>>>>>  The current implementation supports only VM to VM communication
>>>>>  on the same host.
>>>>>  Down the road we plan to make possible to be able to support
>>>>>  inter-machine communication by utilizing physical RoCE devices
>>>>>  or Soft RoCE.
>>>>>
>>>>>  The goals are:
>>>>>  - Reach fast and secure loos-less Inter-VM data exchange.
>>>>>  - Support remote VMs or bare metal machines.
>>>>>  - Allow VMs migration.
>>>>>  - Do not require to pin all VM memory.
>>>>>
>>>>>
>>>>>  Objective
>>>>>  =========
>>>>>  Have a QEMU implementation of the PVRDMA device. We aim to do so without
>>>>>  any change in the PVRDMA guest driver which is already merged into the
>>>>>  upstream kernel.
>>>>>
>>>>>
>>>>>  RFC status
>>>>>  ===========
>>>>>  The project is in early development stages and supports
>>>>>  only basic send/receive operations.
>>>>>
>>>>>  We present it so we can get feedbacks on design,
>>>>>  feature demands and to receive comments from the
>>>>>  community pointing us to the "right" direction.
>>>>
>>>> If to judge by the feedback which you got from RDMA community
>>>> for kernel proposal [1], this community failed to understand:
>>>> 1. Why do you need new module?
>>>
>>> In this case, this is a qemu module to allow qemu to provide a virt rdma device to guests that is compatible with the device provided by VMWare's ESX product.  Right now, the vmware_pvrdma driver
>>> works only when the guest is running on a VMWare ESX server product, this would change that.  Marcel mentioned that they are currently making it compatible because that's the easiest/quickest thing to
>>> do, but in the future they might extend beyond what VMWare's virt rdma driver provides/uses and might then need to either modify it to work with their extensions or fork and create their own virt
>>> client driver.
>>>
>>>> 2. Why existing solutions are not enough and can't be extended?
>>>
>>> This patch is against the qemu source code, not the kernel.  There is no other solution in the qemu source code, so there is no existing solution to extend.
>>>
>>>> 3. Why RXE (SoftRoCE) can't be extended to perform this inter-VM
>>>>    communication via virtual NIC?
>>>
>>> Eventually they want this to work on real hardware, and to be more or less transparent to the guest.  They will need to make it independent of the kernel hardware/driver in use.  That means their own
>>> virt driver, then the virt driver will eventually hook into whatever hardware is present on the system, or failing that, fall back to soft RoCE or soft iWARP if that ever makes it in the kernel.
>>>
>>>
>>
>> Hi Leon and Doug,
>> Your feedback is much appreciated!
>>
>> As Doug mentioned, the RFC is a QEMU implementation of a pvrdma device,
>> so SoftRoCE can't help here (we are emulating a PCI device).
>
> I just responded to the latest email, but as you understood from my question,
> it was related to your KDBR module.
>
>>
>> Regarding the new KDBR module (Kernel Data Bridge), as the name suggests is
>> a bridge between different VMs or between a VM and a hardware/software device
>> and does not replace it.
>>
>> Leon, utilizing the Soft RoCE is definitely part of our roadmap from the start,
>> we find the project a must since most of our systems don't even have real
>> RDMA hardware, and the question is how do best integrate with it.
>
> This is exactly the question, you chose as an implementation path to do
> it with new module over char device. I'm not against your approach,
> but would like to see the list with pros and cons for over possible
> solutions if any. Does it make sense to do special ULP to share the data
> between different drivers over shared memory?

Hi Leon,

Here are some thoughts regarding the Soft RoCE usage in our project.
We thought about using it as backend for QEMU pvrdma device
we didn't how it will support our requirements.

1. Does Soft RoCE support inter process (VM) fast path ? The KDBR
    removes the need for hw resources, emulated or not, concentrating
    on one copy from a VM to another.

2. We needed to support migration, meaning the PVRDMA device must preserve
    the RDMA resources between different hosts. Our solution includes a clear
    separation between the guest resources namespace and the actual hw/sw device.
    This is why the KDBR is intended to run outside the scope of the SoftRoCE
    so it can open/close hw connections independent from the VM.

3. Our intention is for KDBR to be used in other contexts as well when we need
    inter VM data exchange, e.g. backend for virtio devices. We didn't see how this
    kind of requirement can be implemented inside SoftRoce as we don't see any
    connection between them.

4. We don't want all the VM memory to be pinned since it disable memory-over-commit
    which in turn will make the pvrdma device useless.
    We weren't sure how nice would play Soft RoCE with memory pinning and we wanted
    more control on memory management. It may be a solvable issue, but combined
    with the others lead us to our decision to come up with our kernel bridge (char
    device or not, we went for it since it was the easiest to implement for a POC)


Thanks,
Marcel & Yuval

>
> Thanks
>
>>
>> Thanks,
>> Marcel & Yuval
>>
>>
>>>>
>>>> Can you please help us to fill this knowledge gap?
>>>>
>>>> [1] http://marc.info/?l=linux-rdma&m=149063626907175&w=2
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
