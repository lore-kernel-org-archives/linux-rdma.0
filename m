From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] IB/hfi1: Prevent a NULL dereference
Date: Tue, 9 Jan 2018 17:23:38 +0300
Message-ID: <20180109142338.f7242rjtqffogwop@mwanda>
References: <20180109092714.valolokywtmbprw7@mwanda>
 <14063C7AD467DE4B82DEDB5C278E8663A9F7F391@fmsmsx107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663A9F7F391@fmsmsx107.amr.corp.intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 02:16:59PM +0000, Ruhl, Michael J wrote:
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Tuesday, January 9, 2018 4:27 AM
> > To: Marciniszyn, Mike <mike.marciniszyn@intel.com>; Ruhl, Michael J
> > <michael.j.ruhl@intel.com>
> > Cc: Dalessandro, Dennis <dennis.dalessandro@intel.com>; Doug Ledford
> > <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>; linux-
> > rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
> > Subject: [PATCH] IB/hfi1: Prevent a NULL dereference
> > 
> > In the original code, we set "fd->uctxt" to NULL and then dereference it
> > which will cause an Oops.
> > 
> > Fixes: f2a3bc00a03c ("IB/hfi1: Protect context array set/clear with spinlock")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/infiniband/hw/hfi1/file_ops.c
> > b/drivers/infiniband/hw/hfi1/file_ops.c
> > index 82086241aac3..3de1ac94bb85 100644
> > --- a/drivers/infiniband/hw/hfi1/file_ops.c
> > +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> > @@ -763,10 +763,10 @@ static int complete_subctxt(struct hfi1_filedata *fd)
> >  	}
> > 
> >  	if (ret) {
> > +		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
> >  		hfi1_rcd_put(fd->uctxt);
> >  		fd->uctxt = NULL;
> >  		spin_lock_irqsave(&fd->dd->uctxt_lock, flags);
> > -		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
> >  		spin_unlock_irqrestore(&fd->dd->uctxt_lock, flags);
> >  	}
> > 
> 
> Hi Dan,
> 
> Thanks for catching this.
> 
> However, the patch is not quite correct.
> 
> The __clear_bit() spin_lock_irqsave/restore need stay together.  The patch should be:
>

Oh.  Yeah.  I should have noticed that now the spin_lock is pointless.
Let me resend.  Thanks.

regards,
dan carpenter


