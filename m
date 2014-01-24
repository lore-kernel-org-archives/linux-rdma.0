From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about CPU-HCA interaction
Date: Fri, 24 Jan 2014 00:34:58 -0500
Message-ID: <CADPSxAhQSHd81q3PsN=d1hAmxSp9kGZb1UwgciKTWWsYHvwwDQ@mail.gmail.com>
References: <CADPSxAht4-xBBn0UtNV5PzZxH1qHF0f7VN6TK9vWbEMB8mpa5w@mail.gmail.com>
	<8687DAA2193C594F89AAA8D4EFFF767F1E253D33@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8687DAA2193C594F89AAA8D4EFFF767F1E253D33-DSFXGzmeEH52L3XCsXW7nW2JBhF/6DRPtVSa9H69ks0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dong Zhang <Dong.Zhang-PwyqCcigF0Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is pretty late, but I'm pretty sure that the entire WQE is
written via PIO to the HCA. Here are some references.

1. Performance analysis of ConnectX
(http://nowlab.cse.ohio-state.edu/publications/conf-presentations/2007/=
surs-hoti07.pdf).
It says that in ConnectX, PIO is used to writing the WQE (along with
the inlined payload) to the HCA.

2. http://comments.gmane.org/gmane.linux.drivers.openib/61682
discusses doing PIO to BlueFlame pages.

I had a related question. How is the CQE pushed from the HCA to the
CPU? Is it a DMA write? Or can PCI devices write to system memory too
(just as CPUs can write to the PCIe device's memory).

Anuj



On Mon, Jan 13, 2014 at 9:08 PM, Dong Zhang <Dong.Zhang-PwyqCcigF0Q@public.gmane.org> wrote=
:
> Actually the first one is widely used by many PCIE IO card. The simil=
ar way is used by SAS/FC HBA, where, there is also a similar queue pair=
 existing in both driver memory space and PCIE address space, one consu=
mer queue and one producer queue, in the PCIE BAR space, there is a reg=
ister named "producer index", which is updated by host driver when the =
upper layer generate a new IO request and put into the producer queue i=
n the driver memory space. This register update action will cause a int=
errupt to the PCIE card's IO controller and then DMA form host driver m=
emory's producer queue to fetch the IO request and handle it, then DMA =
write to the driver's consumer queue a new item to inform the driver th=
at this IO is done.
>
> Hope that help.
>
> Dong
>
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of Anuj Kalia
> Sent: 2014=E5=B9=B41=E6=9C=8813=E6=97=A5 17:04
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Question about CPU-HCA interaction
>
> Hi.
>
> I wanted to understand the PCIe usage while issuing Infiniband verbs.
> When posting a verb to a queue pair, how is the request descriptor wr=
itten to the HCA? IMO, there are two options for this:
>
> 1. CPU prepares the descriptor in local memory. After preparing the d=
escriptor, it writes the location of the descriptor to a hardwired regi=
ster on the HCA (this process is called "ringing the doorbell"?).
> The HCA then reads the descriptor via DMA.
>
> 2. The CPU writes the entire descriptor to the HCA's memory via PCIe =
MMIO. Then, it rings the doorbell to alert the HCA.
>
> To me, the first one makes more sense, but I'm not sure. It would be =
great if someone could tell more about this.
>
> Thanks for your help.
>
> --Anuj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo i=
nfo at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
