From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
Date: Tue, 20 Dec 2016 19:30:45 +0200
Message-ID: <20161220173044.GA3677@yuval-lap>
References: <20161219203227.86392-1-henry.orosco@intel.com>
 <20161220104720.GD7351@yuval-lap.uk.oracle.com>
 <20161220164118.GA91636@horosco-MOBL2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161220164118.GA91636-ZmvEvTIhtuUfyugFOqMDN/ooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 20, 2016 at 10:41:18AM -0600, Henry Orosco wrote:
> > > 
> > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > > index 392f783..98923a8 100644
> > > --- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > > +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> > > @@ -358,13 +358,16 @@ void i40iw_qp_add_qos(struct i40iw_sc_qp *qp)
> > >   * @dev: sc device struct
> > >   * @pd: sc pd ptr
> > >   * @pd_id: pd_id for allocated pd
> > > + * @abi_ver: ABI version from user context, -1 if not valid
> > >   */
> > >  static void i40iw_sc_pd_init(struct i40iw_sc_dev *dev,
> > >  			     struct i40iw_sc_pd *pd,
> > > -			     u16 pd_id)
> > > +			     u16 pd_id,
> > > +			     int abi_ver)
> > 
> > No need for new line here
> > 
> 
> Not sure what you mean here.

>From code-style perspective "u16 pd_id," and "int abi_ver" can be on one line.

> 
> > >  {
> > >  	pd->size = sizeof(*pd);
> > >  	pd->pd_id = pd_id;
> > > +	pd->abi_ver = abi_ver;
> > >  	pd->dev = dev;
> > >  }
> > >  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
