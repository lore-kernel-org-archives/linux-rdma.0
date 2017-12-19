From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
 free_irq()
Date: Tue, 19 Dec 2017 13:57:54 -0700
Message-ID: <20171219205754.GE14814@ziepe.ca>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035612.2126.10447.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219035612.2126.10447.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 18, 2017 at 07:56:16PM -0800, Dennis Dalessandro wrote:
 
> When kernel is built with CONFIG_DEBUG_SHIRQ config flag, an extra call
> to IRQ handler is made from _free_irq() function. The driver should be
> prepared for this fake call.

It is not a 'fake call' it is call designed to test what happens
during an IRQ handler racing with free.

> Adding a mechanism which detects whether handler is invoked after
> disabling interrupts. hfi_intr_mask field is added to hfi1_devdata
> structure which is replica of interrupt mask register of hfi device.
> The field is updated while writing a value to register.

And this is not the typical solution.

Explain why adding a non-atomic variable to a concurrancy doesn't just
create races and a mess??

free_irq() is a synchronous fence, It returns once all the running IRQ
handlers have exited and guarantees they will not be called again.

You are supposed to call it before destroying anything that the IRQ
handler could be using.

re-ordering desstruction order is the typical solution.

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
