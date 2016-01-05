From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add rdmavt support in HFI1
Date: Tue, 5 Jan 2016 17:50:52 -0500
Message-ID: <20160105225052.GA2122@phlsvsds.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com> <20151221061214.GD3860@phlsvsds.ph.intel.com> <20151221220235.GA14142@kroah.com> <20151222001943.GM3860@phlsvsds.ph.intel.com> <20151222010148.GB2145@kroah.com> <20151222191508.GO3860@phlsvsds.ph.intel.com> <20151223022757.GA5562@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151223022757.GA5562-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > > > 
> > > > > If Doug accepts the library changes, let me know that public git commit
> > > > > and I can pull it into the staging-next branch and you can continue to
> > > > > send me staging patches that way.
> > > > 
> > > > Won't this cause a conflict during the merge window?
> > > 
> > > No, git is good :)
> > > 
> > > > How do we handle changes which affect both qib and hfi1?
> > > 
> > > I don't know, now this gets messy...
> > > 
> > 
> > Agreed and this is what we are worried about.
> > 
> > Can we do what Dan and Doug have proposed in the past and have Doug take over
> > the staging/rdma sub-tree?
> > 
> > http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-November/081922.html
> > 
> > I think the upcoming merge window is a reasonable time for him to do that.
> 
> Ok, but keeping on top of all of the generic staging patches that come
> in is a tough thing to do, that's up to Doug, if he is ready for it...
> 

Greg,

Forgive me for not knowing how multiple maintainers deal with hand offs like
this.  I'm hoping you, and/or Doug, can answer some questions for me.

Am I correct in assuming the merge window will be open on Monday?  If so, when
will Linus pull the staging tree?  Then at what point will Doug get the hfi1
changes which have already been accepted?

Are you going to be able to review the outstanding patches for
staging/rdma/hfi1 before the merge window?  Or should we consider them dropped
and resubmit to Doug to apply after he has merged the latest hfi1 code from
Linus?


Doug,

At what point should we start submitting additional patches to you which we
have queued up but are not yet submitted to Greg?

So far we have been cross posting to linux-rdma for feedback and I see that the
patches have been dropped from patchworks.  I assume you dropped them from
patchworks because you knew that Greg was handling them?

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
