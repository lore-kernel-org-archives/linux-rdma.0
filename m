From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Sat, 14 Jan 2017 02:05:14 +0000
Message-ID: <F3529576D8E232409F431C309E29399336C6006C@CRSMSX102.amr.corp.intel.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
         <1484338667.2679.15.camel@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
 <1484344759.2679.26.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484344759.2679.26.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
> Sent: Friday, January 13, 2017 5:00 PM
> To: Estrin, Alex <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
> Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
> 
> On Fri, 2017-01-13 at 21:08 +0000, Estrin, Alex wrote:
> > It didn't fix the failure... Apparently there is an issue with generic
> > mapping itself.
> 
> Hello Alex,
> 
> The generic mapping code in lib/dma-virt.c works fine with at least the rxe
> driver. Additionally, as far as I can see the mapping code in lib/dma-virt.c
> is identical to the mapping in drivers/infiniband/sw/rdmavt/dma.c. What is
> not clear to me however is how my patches can have caused the SDMA engine
> error messages? As far as I can see the code in
> drivers/infiniband/hw/hfi1/sdma.c uses PCI DMA mapping operations instead of
> the generic dma_virt_ops. Is that correct?

Hi Bart,
If you refer to code like this 
from sdma.c: 
/* dma map the coalesce buffer */
                addr = dma_map_single(&dd->pcidev->dev,
..... 
please see hfi1/verbs.c @ hfi1_register_ib_device()  

'dma_device' field is initialized here
->	ibdev->dma_device = &dd->pcidev->dev;
	followed by 
	ret = rvt_register_device(&dd->verbs_dev.rdi);
	->	set_dma_ops(rdi->ibdev.dma_device, &dma_virt_ops);
 
Thanks,
Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
