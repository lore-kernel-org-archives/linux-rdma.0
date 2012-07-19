From: Betty Dall <betty.dall-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH] [Trivial] qib: fix an incorrect message
Date: Thu, 19 Jul 2012 12:56:10 -0600
Message-ID: <1342724170.28019.23.camel@ejdallLaptop>
References: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
	 <1342720992.1988.24.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342720992.1988.24.camel@joe2Laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Joe,

Thanks for the comment Joe. It looks like Roland already accepted the
trivial change.

On Thu, 2012-07-19 at 11:03 -0700, Joe Perches wrote:
> On Thu, 2012-07-19 at 13:34 -0600, Betty Dall wrote:
> > There is a cut and paste typo in the function qib_pci_slot_reset() where
> > it prints that the "link_reset" function is called rather than the
> > "slot_reset" function. This makes the message misleading.
> 
> Hi Betty.
> 
> > diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
> []
> > @@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
> >  static pci_ers_result_t
> >  qib_pci_slot_reset(struct pci_dev *pdev)
> >  {
> > -	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
> > +	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");
> 
> These sorts of typos can be avoided by using "%s: ", __func__
> 
> 	qib_devinfo(pdev, "QIB %s: called, ignored\n", __func__);


You are right about using __func__. That is what I use typically too. In
this file, none of the qib_devinfo() messages use __func__, so I stuck
with the trivial change for consistency. I could write another patch
that makes use of __func__ for all the appropriate qib_devinfo() calls
(there are 4 of them.) Do you think that is a worthwhile change? BTW, I
did review all the other qib_devinfo() calls to make sure they are using
the correct function names, and they look good.

-Betty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
