From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
 free_irq()
Date: Wed, 20 Dec 2017 21:01:17 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E86639F0E3917@FMSMSX108.amr.corp.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035612.2126.10447.stgit@scvm10.sc.intel.com>
 <20171219205754.GE14814@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219205754.GE14814-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Patel, Jay P" <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Tuesday, December 19, 2017 3:58 PM
> To: Dalessandro, Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ruhl, Michael J
> <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Patel, Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Sanchez,
> Sebastian <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
> free_irq()
> 
> On Mon, Dec 18, 2017 at 07:56:16PM -0800, Dennis Dalessandro wrote:
> 
> > When kernel is built with CONFIG_DEBUG_SHIRQ config flag, an extra call
> > to IRQ handler is made from _free_irq() function. The driver should be
> > prepared for this fake call.
> 
> It is not a 'fake call' it is call designed to test what happens
> during an IRQ handler racing with free.

Hi Jason,

After further review it appears that our patch:

commit 05cb18fda926ddce299280bd86cbc9d491306f28
IB/hfi1: Update HFI to use the latest PCI API

has exposed an architecture issue in how we do our driver
remove.

Our current path does not adequately deal with the race condition
of getting an IRQ during the removal.

To address, we could submit a patch to revert the above commit.

After re-architecting the driver remove path, we would re-submit
the PCI API patch.

Note: reverting the PCI API patch will not make the crash addressed in:

IB/hfi1: Destroy link_wq workqueue after free_irq()

issue go away, but will make it more difficult for the issue to occur.

Thanks,

Mike
> 
> > Adding a mechanism which detects whether handler is invoked after
> > disabling interrupts. hfi_intr_mask field is added to hfi1_devdata
> > structure which is replica of interrupt mask register of hfi device.
> > The field is updated while writing a value to register.
> 
> And this is not the typical solution.
> 
> Explain why adding a non-atomic variable to a concurrancy doesn't just
> create races and a mess??
> 
> free_irq() is a synchronous fence, It returns once all the running IRQ
> handlers have exited and guarantees they will not be called again.
> 
> You are supposed to call it before destroying anything that the IRQ
> handler could be using.
> 
> re-ordering desstruction order is the typical solution.
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
