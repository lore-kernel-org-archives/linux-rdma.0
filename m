From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 12/23] staging/rdma/hfi1: Macro code clean up
Date: Wed, 28 Oct 2015 11:47:21 -0400
Message-ID: <20151028154720.GB10890@phlsvsds.ph.intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com> <1445869729-7507-13-git-send-email-ira.weiny@intel.com> <20151027081910.GA25171@kroah.com> <20151027205115.GB32118@phlsvsds.ph.intel.com> <20151027211404.GA18879@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151027211404.GA18879-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Can I add the removal of these macros to the TODO list and get this patch
> > accepted in the interm?
> 
> Nope, sorry, why would I accept a known-problem patch?  Would you do
> such a thing?
> 
> > Many of the patches I am queueing up to submit as well as one in this series do
> > not apply cleanly without this change.  It will be much easier if I can get
> > everything applied and then do a global clean up of these macros after the
> > fact.
> 
> But you would have no incentive to do that if I take this patch now :)
> 

Understood.
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
