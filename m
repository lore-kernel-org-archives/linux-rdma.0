From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 5/9] staging/rdma/hfi1: Add function stubs for TID
 caching
Date: Mon, 9 Nov 2015 16:18:27 -0800
Message-ID: <20151110001827.GA29500@kroah.com>
References: <1446245928-12675-1-git-send-email-ira.weiny@intel.com>
 <1446245928-12675-6-git-send-email-ira.weiny@intel.com>
 <20151107010235.GA24586@kroah.com>
 <20151110001102.GA11150@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110001102.GA11150-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 07:11:03PM -0500, ira.weiny wrote:
> On Fri, Nov 06, 2015 at 05:02:35PM -0800, Greg KH wrote:
> > On Fri, Oct 30, 2015 at 06:58:44PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > 
> > > Add mmu notify helper functions and TID caching function stubs in preparation
> > > for the TID caching implementation.
> > > 
> > > TID caching makes use of the MMU notifier to allow the driver to respond to the
> > > user freeing memory which is allocated to the HFI.
> > > 
> > > This patch implements the basic MMU notifier functions to insert, find and
> > > remove buffer pages from memory based on the mmu_notifier being invoked.
> > > 
> > > In addition it places stubs in place for the main entry points by follow on
> > > code.
> > > 
> > > Follow up patches will complete the implementation of the interaction with user
> > > space and makes use of these functions.
> > 
> > This patch adds warnings to the build, which isn't ok, so I've stopped
> > here in this series and just applied the first 4.  Please fix up and
> > resend the remaining ones.
> 
> Ok, patch 7-9 of this series do not depend on this patch nor number 6.  I will
> resend those 3 while I figure out what to do about these 2:
> 
> staging/rdma/hfi1: Add function stubs for TID caching
> staging/rdma/hfi1: Implement Expected Receive TID caching
> 
> Frankly this was an attempt to reduce the size of "Implement Expected Receive
> TID caching".  I obviously did something wrong.
> 
> I really don't know that I can split these up any more without causing issues
> with bisecting the code.

I strongly doubt that you created this new feature all "at once", it
took a set of steps to get to your final destination.  So show that
work, like your math professor told you...

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
