From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: mlx4_core unable to use MSI-x on our nodes
Date: Sun, 25 Jul 2010 10:02:43 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B38F53F5A@MTLMAIL.mtl.com>
References: <AANLkTinco6znrHkoE9vL1n7KrrZ68zPExPUPQeDHD64i@mail.gmail.com>
	<Pine.GSO.4.40.1007221320200.17-300000@kappa.cse.ohio-state.edu>
	<6203933669E90E4AB42B5BC4EDE38D350CF01EF379@orsmsx510.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6203933669E90E4AB42B5BC4EDE38D350CF01EF379-qERRe+bbXDTTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This was already fixed.

Even in case when the kernel is not able to provide us with required number of MSI-X vectores,
The driver then requests the number that the kernel is ready to give (12 in the given case).

--Yevgeny

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Meyer, Donald J
> Sent: Thursday, July 22, 2010 8:57 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: mlx4_core unable to use MSI-x on our nodes
> 
> In our dmesg log I see "mlx4_core 0000:02:00.0: Only 12 MSI-X 
> vectors available, need 25. Not using MSI-X" which if I read 
> it correctly says our mlx4_core is unable to use MSI-X which 
> if I also understand correctly means the mlx4_core can't use 
> the sharing of interrupts among all processors.
> 
> If this is correct, do we want to try to fix this so the 
> mlx4_core can use MSI-X and share the interrupts?
> 
> And if we do want to fix this, do you have any suggestions 
> for how to fix it?
> 
> Thanks,
> Don Meyer
> Senior Network/System Engineer/Programmer
> US+ (253) 371-9532 iNet 8-371-9532
> *Other names and brands may be claimed as the property of others
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-rdma" in the body of a message to 
> majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> --
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
