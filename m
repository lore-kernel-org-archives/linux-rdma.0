From: "Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Subject: RE: [ewg] IPoIB to Ethernet routing performance
Date: Thu, 30 Dec 2010 17:37:51 -0000
Message-ID: <004301cba848$50253b00$f06fb100$@com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr> <00d701cb9533$71c5f2e0$5551d8a0$@com> <20101206124023.025c2f88@frecb012350.frec.bull.fr> <00f201cb953e$53f66a00$fbe33e00$@com> <20101206140505.20cfc9e2@frecb012350.frec.bull.fr> <alpine.DEB.2.00.1012091745070.29367@router.home> <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com> <018d01cba4eb$aa507320$fef15960$@com> <4D187DB1.5020005@shiftmail.org>
Reply-To: <richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D187DB1.5020005-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Content-Language: en-gb
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jabe' <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org
Cc: 'Ali Ayoub' <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'sebastien dugue' <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, 'OF EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB is far easier to use and does not carry out the additional management
burden of vNICS.

With vNICs you have to manage the MAC address mapping to Ethernet g/w port.
In some situations, such as when multiple G/w's are used for resiliency this
can amount to a lot of separate vNICs on each server to manage.  In a small
configuration I had, we ended up with 6 vNICS per server to manage.  On a
large configuration this additional management would be a big burden.

My experience with IPoIB has always been very positive. All my existing
socket programs have worked, even some esoteric ioctls I use for multicast
and buffer  management.
Performance could always be better, but in my experience it's not great for
the vNICS either.   Latency in particular was very disappointing when I
tested.  
If you want high performance you have to avoid TCP/IP.

-----Original Message-----
From: Jabe [mailto:jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org] 
Sent: 27 December 2010 11:51
To: richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org
Cc: Richard Croucher; 'Ali Ayoub'; 'Christoph Lameter'; 'linux-rdma';
'sebastien dugue'; 'OF EWG'
Subject: Re: [ewg] IPoIB to Ethernet routing performance

On 12/26/2010 11:57 AM, Richard Croucher wrote:
> The vNIC driver only works when you have Ethernet/InfiniBand hardware
> gateways in your environment.   It is useful when you have external hosts
to
> communicate with which do not have direct InfiniBand connectivity.
> IPoIB is still heavily used in these environments to provide TCP/IP
> connectivity within the InfiniBand fabric.
> The primary Use Case for vNICs is probably for virtualization servers, so
> that individual Guests can be presented with a virtual Ethernet NIC and do
> not lead to load any InfiniBand drivers.  Only the hypervisor needs to
have
> the InfiniBand software stack loaded.
> I've also applied vNICs in the Financial Services arena, for connectivity
to
> external TCP/IP services but there the IPoIB gateway function is arguably
> more useful.
>
> The whole vNIC arena is complicated by different, incompatible
> implementations from each of Qlogic and Mellanox.
>
> Richard
>    


Richard, with your explanation I understand why vNIC / EoIB is used in 
the case you cite, but I don't understand why it is NOT used in the 
other cases (like Ali says).

I can *guess* it's probably because with a virtual ethernet fabric you 
have to do all IP stack in software, probably without even having the 
stateless offloads (so it would be a performance reason). Is that the 
reason?

Thank you

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
