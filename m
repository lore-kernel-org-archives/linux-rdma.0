From: Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Wed, 29 Dec 2010 17:18:43 +0200
Message-ID: <4D1B5153.4010708@mellanox.co.il>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>	<00d701cb9533$71c5f2e0$5551d8a0$@com>	<20101206124023.025c2f88@frecb012350.frec.bull.fr>	<00f201cb953e$53f66a00$fbe33e00$@com>	<20101206140505.20cfc9e2@frecb012350.frec.bull.fr>	<alpine.DEB.2.00.1012091745070.29367@router.home>	<AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>	<018d01cba4eb$aa507320$fef15960$@com>	<AANLkTi=ausgOuEMRe622dNRzVyhN3pxPWeTAJiJihssW@mail.gmail.com> <4D1A02A8.1060104@shiftmail.org>
Reply-To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D1A02A8.1060104-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 12/28/2010 5:30 PM, Reeted wrote:
>
> You and Richard seem to have good experience of infiniband in 
> virtualized environments. May I ask one thing?
> We were thinking about buying some Mellanox Connectx-2 for use with 
> SR-IOV (hardware virtualization for PCI bypass, supposedly supported 
> by connectx-2) in KVM (also supposedly supports SR-IOV and PCI bypass).
> Do you have info if this will work, in KVM or other hypervisors?
> I asked in KVM mailing list but they have not tried this card (which 
> is the only SR-IOV card among Infiniband ones, so they have not tried 
> infiniband).
>
We are working on enabling SRIOV on ConnectX2 cards
Once we will have it working with KVM we will submit the patches to the 
linux-rdma list
Should be in few months - but don't ask how much is few :-)

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
