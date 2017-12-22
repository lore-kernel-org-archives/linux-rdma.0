From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
 free_irq()
Date: Fri, 22 Dec 2017 13:13:49 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E86639F0E3F94@FMSMSX108.amr.corp.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035612.2126.10447.stgit@scvm10.sc.intel.com>
 <20171219205754.GE14814@ziepe.ca>
 <14063C7AD467DE4B82DEDB5C278E86639F0E3917@FMSMSX108.amr.corp.intel.com>
 <20171220211112.GG22908@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220211112.GG22908-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Patel, Jay P" <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Wednesday, December 20, 2017 4:11 PM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Dalessandro, Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Patel, Jay P
> <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Sanchez, Sebastian <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
> free_irq()
> 
> On Wed, Dec 20, 2017 at 09:01:17PM +0000, Ruhl, Michael J wrote:
> 
> > Note: reverting the PCI API patch will not make the crash addressed in:
> >
> > IB/hfi1: Destroy link_wq workqueue after free_irq()
> >
> > issue go away, but will make it more difficult for the issue to occur.
> 
> It is up to you.
> 
> Device removal races should be fixed, but it is often unlikely they
> would impact any user.
> 
> So, abstractly, reverting a racy situation to another racy situation
> doesn't seem like a worthwhile win to me.
> 
> But I do not want to merge this patch which is just making the race
> harder to detect with our debug tools for finding racing..

Ok.  Will work toward getting the race condition addressed more completely.

Mike

 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
