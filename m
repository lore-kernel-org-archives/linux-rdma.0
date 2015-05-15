From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH for-4.1 06/11] RDMA/ocrdma: Prevent allocation of DPP PDs
 if FW doesnt support it
Date: Fri, 15 May 2015 22:23:57 +0530
Message-ID: <05aed249972ea2914a6a22b9db5ada55@mail.gmail.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
	 <1431762709-20740-7-git-send-email-selvin.xavier@avagotech.com> <1431704582.29187.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431704582.29187.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Doug for the review.  We will fix this memory leak in V2.

Thanks,
Selvin Xavier

> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, May 15, 2015 9:13 PM
> To: Selvin Xavier
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH for-4.1 06/11] RDMA/ocrdma: Prevent allocation of DPP
> PDs if FW doesnt support it
>
> On Sat, 2015-05-16 at 13:21 +0530, Selvin Xavier wrote:
>
> > @@ -1468,10 +1471,8 @@ static int ocrdma_mbx_alloc_pd_range(struct
> > ocrdma_dev *dev)
> >
> >  	cmd->pd_count = dev->attr.max_pd - dev->attr.max_dpp_pds;
> >  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> > -	if (status)
> > -		goto mbx_err;
> >  	rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
> > -	if (rsp->pd_count) {
> > +	if (!status && rsp->pd_count) {
> >  		dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
> >
> 	OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
> >  		dev->pd_mgr->max_normal_pd = rsp->pd_count; @@ -
> 1486,7 +1487,6 @@
> > static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
> >  	} else {
> >  		return -ENOMEM;
> >  	}
> > -mbx_err:
> >  	kfree(cmd);
> >  	return status;
> >  }
>
> I didn't go into the file to make sure, but this looks like a memory leak
> (in fact,
> it looks like a leak that always existed, specifically if
> rsp->pd_count == 0 then the else causes you to leave before the
> kfree(cmd) and therefore you leak).  It's now been made worse because it
> would now happen both when status != 0 and when pd_count == 0.
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
