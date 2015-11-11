From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 5/9] staging/rdma/hfi1: Add function stubs for TID caching
Date: Wed, 11 Nov 2015 01:10:40 -0500
Message-ID: <20151111061039.GB9594@phlsvsds.ph.intel.com>
References: <1446245928-12675-1-git-send-email-ira.weiny@intel.com> <1446245928-12675-6-git-send-email-ira.weiny@intel.com> <20151107010235.GA24586@kroah.com> <20151110001102.GA11150@phlsvsds.ph.intel.com> <20151110001827.GA29500@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110001827.GA29500-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > 
> > Ok, patch 7-9 of this series do not depend on this patch nor number 6.  I will
> > resend those 3 while I figure out what to do about these 2:
> > 
> > staging/rdma/hfi1: Add function stubs for TID caching
> > staging/rdma/hfi1: Implement Expected Receive TID caching
> > 
> > Frankly this was an attempt to reduce the size of "Implement Expected Receive
> > TID caching".  I obviously did something wrong.
> > 
> > I really don't know that I can split these up any more without causing issues
> > with bisecting the code.
> 
> I strongly doubt that you created this new feature all "at once", it
> took a set of steps to get to your final destination.  So show that
> work, like your math professor told you...
> 

The original author and I have been going through the code to see what we can
do.  We have identified a couple of other pieces which can be split.

One question.  Is it ok to have functionality which is added which is unused in
a preliminary patch?  I believe this is ok as long as the code compiles but I
just wanted to make sure.  While there are different operations added in this
patch it is broken to not use them as a set.  So we need to have a series which
implement the pieces with a final patch which exposes the set of operations.

Is this acceptable?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
