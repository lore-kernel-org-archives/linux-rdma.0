From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH] RDMA/ocrdma: remove unneeded tests
Date: Tue, 26 May 2015 21:30:03 +0530
Message-ID: <fc65b86cff5dc0ca24bc90c3dab7c205@mail.gmail.com>
References: <1432238824-16953-1-git-send-email-laurent.navet@gmail.com> <1432644310.28905.95.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432644310.28905.95.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laurent Navet <laurent.navet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Although already applied, Thanks Laurent and Doug.

Acked-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, May 26, 2015 6:15 PM
> To: Laurent Navet
> Cc: selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org; devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org;
> mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/ocrdma: remove unneeded tests
>
> On Thu, 2015-05-21 at 22:07 +0200, Laurent Navet wrote:
> > The same code is executed regardless status value, so these tests can
> > be removed.
> > Fix Coverity CID 1271151 and 1268788
>
> Thanks, applied for 4.2.
>
> > Signed-off-by: Laurent Navet <laurent.navet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > index 0c9e959..e748090 100644
> > --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > @@ -1960,9 +1960,6 @@ static int ocrdma_mbx_reg_mr_cont(struct
> ocrdma_dev *dev,
> >  		    upper_32_bits(hwmr->pbl_table[i + pbl_offset].pa);
> >  	}
> >  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> > -	if (status)
> > -		goto mbx_err;
> > -mbx_err:
> >  	kfree(cmd);
> >  	return status;
> >  }
> > @@ -3044,9 +3041,6 @@ static int ocrdma_mbx_modify_eqd(struct
> ocrdma_dev *dev, struct ocrdma_eq *eq,
> >  				(eq[i].aic_obj.prev_eqd * 65)/100;
> >  	}
> >  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> > -	if (status)
> > -		goto mbx_err;
> > -mbx_err:
> >  	kfree(cmd);
> >  	return status;
> >  }
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
