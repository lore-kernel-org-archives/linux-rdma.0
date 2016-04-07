From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: Remove unnecessary synchronize_irq() before
 free_irq()
Date: Thu, 7 Apr 2016 13:27:43 -0500
Message-ID: <20160407182742.GA12796@flatif-MOBL1>
References: <1459157486-23257-1-git-send-email-lars@metafoo.de>
 <20160330071503.GB8511@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160330071503.GB8511-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 30, 2016 at 10:15:03AM +0300, Leon Romanovsky wrote:
> On Mon, Mar 28, 2016 at 11:31:26AM +0200, Lars-Peter Clausen wrote:
> > Calling synchronize_irq() right before free_irq() is quite useless. On one
> > hand the IRQ can easily fire again before free_irq() is entered, on the
> > other hand free_irq() itself calls synchronize_irq() internally (in a race
> > condition free way), before any state associated with the IRQ is freed.
> > 
> > Patch was generated using the following semantic patch:
> > // <smpl>
> > @@
> > expression irq;
> > @@
> > -synchronize_irq(irq);
> >  free_irq(irq, ...);
> > // </smpl>
> > 
> > Signed-off-by: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
> 
> Thanks
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 

Thanks
Acked-by: Faisal Latif <faisal.latif#intel.com>

> > ---
> >  drivers/infiniband/hw/i40iw/i40iw_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
> > index 90e5af2..006c44f 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_main.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
> > @@ -270,7 +270,6 @@ static void i40iw_disable_irq(struct i40iw_sc_dev *dev,
> >  		i40iw_wr32(dev->hw, I40E_PFINT_DYN_CTLN(msix_vec->idx - 1), 0);
> >  	else
> >  		i40iw_wr32(dev->hw, I40E_VFINT_DYN_CTLN1(msix_vec->idx - 1), 0);
> > -	synchronize_irq(msix_vec->irq);
> >  	free_irq(msix_vec->irq, dev_id);
> >  }
> >  
> > -- 
> > 2.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
