From: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Tue, 28 Dec 2010 16:30:48 +0100
Message-ID: <4D1A02A8.1060104@shiftmail.org>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
 <00d701cb9533$71c5f2e0$5551d8a0$@com>
 <20101206124023.025c2f88@frecb012350.frec.bull.fr>
 <00f201cb953e$53f66a00$fbe33e00$@com>
 <20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
 <alpine.DEB.2.00.1012091745070.29367@router.home>
 <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>
 <018d01cba4eb$aa507320$fef15960$@com>
 <AANLkTi=ausgOuEMRe622dNRzVyhN3pxPWeTAJiJihssW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTi=ausgOuEMRe622dNRzVyhN3pxPWeTAJiJihssW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/28/2010 01:06 AM, Ali Ayoub wrote:
> EoIB primary use is not virtualization, although it can support it in
> better ways than other ULPs.
> FYI, today running full/para virtualized driver in the Guest OS is
> needed also for IPoIB.
> Only when platform-virtualization solution is available, the GOS will
> run IB stack (for any ULP).
>    

You and Richard seem to have good experience of infiniband in 
virtualized environments. May I ask one thing?
We were thinking about buying some Mellanox Connectx-2 for use with 
SR-IOV (hardware virtualization for PCI bypass, supposedly supported by 
connectx-2) in KVM (also supposedly supports SR-IOV and PCI bypass).
Do you have info if this will work, in KVM or other hypervisors?
I asked in KVM mailing list but they have not tried this card (which is 
the only SR-IOV card among Infiniband ones, so they have not tried 
infiniband).
We can be interested in both true infiniband and IPoIB support.
Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
