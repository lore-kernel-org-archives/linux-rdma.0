From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about CPU-HCA interaction
Date: Fri, 24 Jan 2014 01:05:13 -0500
Message-ID: <CADPSxAjx6tRMWP==oDsG3ydViT0_hQMM-y3tRNJTFMXtbw=r3w@mail.gmail.com>
References: <CADPSxAht4-xBBn0UtNV5PzZxH1qHF0f7VN6TK9vWbEMB8mpa5w@mail.gmail.com>
	<8687DAA2193C594F89AAA8D4EFFF767F1E253D33@BBYEXM01.pmc-sierra.internal>
	<CADPSxAhQSHd81q3PsN=d1hAmxSp9kGZb1UwgciKTWWsYHvwwDQ@mail.gmail.com>
	<8687DAA2193C594F89AAA8D4EFFF767F1E255D09@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8687DAA2193C594F89AAA8D4EFFF767F1E255D09-DSFXGzmeEH52L3XCsXW7nW2JBhF/6DRPtVSa9H69ks0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dong Zhang <Dong.Zhang-PwyqCcigF0Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ok. Thanks for the information.

Looking at cq.c in the mlx4 driver, it seems to be using a doorbell
for the CQE. I think the CPU does some kind of uncacheable read from
the PCI device to detect completions. Can someone please confirm this?
There is so little information available online :(.

--Anuj

On Fri, Jan 24, 2014 at 12:53 AM, Dong Zhang <Dong.Zhang-PwyqCcigF0Q@public.gmane.org> wrot=
e:
> One thing I am sure is PCIE device can write to host RAM without noti=
fying the CPU(of course bus arbitration against CPU is necessary ), onl=
y if this device support bus mastering DMA or another named third party=
 DMA. Device use PCIE address space to kick off the transport, the addr=
ess will be translated by PCIE RC to host RAM, or if there is a IOMMU, =
the IOMMU will do a second translate after RC's translation, into host =
RAM physical address.
>
> Dong
>
> -----Original Message-----
> From: Anuj Kalia [mailto:anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: 2014=E5=B9=B41=E6=9C=8824=E6=97=A5 13:35
> To: Dong Zhang
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Question about CPU-HCA interaction
>
> This is pretty late, but I'm pretty sure that the entire WQE is writt=
en via PIO to the HCA. Here are some references.
>
> 1. Performance analysis of ConnectX
> (http://nowlab.cse.ohio-state.edu/publications/conf-presentations/200=
7/surs-hoti07.pdf).
> It says that in ConnectX, PIO is used to writing the WQE (along with =
the inlined payload) to the HCA.
>
> 2. http://comments.gmane.org/gmane.linux.drivers.openib/61682
> discusses doing PIO to BlueFlame pages.
>
> I had a related question. How is the CQE pushed from the HCA to the C=
PU? Is it a DMA write? Or can PCI devices write to system memory too (j=
ust as CPUs can write to the PCIe device's memory).
>
> Anuj
>
>
>
> On Mon, Jan 13, 2014 at 9:08 PM, Dong Zhang <Dong.Zhang-PwyqCcigF0Q@public.gmane.org> wro=
te:
>> Actually the first one is widely used by many PCIE IO card. The simi=
lar way is used by SAS/FC HBA, where, there is also a similar queue pai=
r existing in both driver memory space and PCIE address space, one cons=
umer queue and one producer queue, in the PCIE BAR space, there is a re=
gister named "producer index", which is updated by host driver when the=
 upper layer generate a new IO request and put into the producer queue =
in the driver memory space. This register update action will cause a in=
terrupt to the PCIE card's IO controller and then DMA form host driver =
memory's producer queue to fetch the IO request and handle it, then DMA=
 write to the driver's consumer queue a new item to inform the driver t=
hat this IO is done.
>>
>> Hope that help.
>>
>> Dong
>>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Anuj Kalia
>> Sent: 2014=E5=B9=B41=E6=9C=8813=E6=97=A5 17:04
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Question about CPU-HCA interaction
>>
>> Hi.
>>
>> I wanted to understand the PCIe usage while issuing Infiniband verbs=
=2E
>> When posting a verb to a queue pair, how is the request descriptor w=
ritten to the HCA? IMO, there are two options for this:
>>
>> 1. CPU prepares the descriptor in local memory. After preparing the =
descriptor, it writes the location of the descriptor to a hardwired reg=
ister on the HCA (this process is called "ringing the doorbell"?).
>> The HCA then reads the descriptor via DMA.
>>
>> 2. The CPU writes the entire descriptor to the HCA's memory via PCIe=
 MMIO. Then, it rings the doorbell to alert the HCA.
>>
>> To me, the first one makes more sense, but I'm not sure. It would be=
 great if someone could tell more about this.
>>
>> Thanks for your help.
>>
>> --Anuj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
