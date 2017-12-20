From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
 free_irq()
Date: Wed, 20 Dec 2017 14:11:12 -0700
Message-ID: <20171220211112.GG22908@ziepe.ca>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035612.2126.10447.stgit@scvm10.sc.intel.com>
 <20171219205754.GE14814@ziepe.ca>
 <14063C7AD467DE4B82DEDB5C278E86639F0E3917@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E86639F0E3917-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Patel, Jay P" <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 20, 2017 at 09:01:17PM +0000, Ruhl, Michael J wrote:

> Note: reverting the PCI API patch will not make the crash addressed in:
> 
> IB/hfi1: Destroy link_wq workqueue after free_irq()
> 
> issue go away, but will make it more difficult for the issue to occur.

It is up to you.

Device removal races should be fixed, but it is often unlikely they
would impact any user.

So, abstractly, reverting a racy situation to another racy situation
doesn't seem like a worthwhile win to me.

But I do not want to merge this patch which is just making the race
harder to detect with our debug tools for finding racing..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
