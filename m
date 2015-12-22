From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Clean up SDMA engine code
Date: Mon, 21 Dec 2015 16:13:49 -0800
Message-ID: <20151222001349.GA27154@kroah.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
 <20151221234803.GL3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151221234803.GL3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 06:48:03PM -0500, ira.weiny wrote:
> On Tue, Dec 08, 2015 at 05:10:08PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Various improvements to the SDMA engine code.
> 
> Greg,
> 
> Thanks for reviewing and accepting our patches to staging-testing.  I apologize
> for the conflicts we had between the 3 of us submitting.  However, in
> attempting to rework an internal branch to ensure this does not happen again I
> believe there were more conflicts than their should have been due to patches
> being accepted out of order.
> 
> For example, I found the following error in your staging tree below.
> 
> This series you applied in the following order which causes a build failure on
> the middle commit -- a0d4069.
> 
> 483119a staging/rdma/hfi1: Unconditionally clean-up SDMA queues
> def8228 staging/rdma/hfi1: Convert to use get_user_pages_fast
> a0d4069 staging/rdma/hfi1: Add page lock limit check for SDMA requests
> faa98b8 staging/rdma/hfi1: Clean-up unnecessary goto statements
> 6a5464f staging/rdma/hfi1: Detect SDMA transmission error early
> 
> The order as submitted was:
> 
> staging/rdma/hfi1: Convert to use get_user_pages_fast
> staging/rdma/hfi1: Unconditionally clean-up SDMA queues
> staging/rdma/hfi1: Clean-up unnecessary goto statements
> staging/rdma/hfi1: Detect SDMA transmission error early
> staging/rdma/hfi1: Add page lock limit check for SDMA requests
> 
> 
> 
> Do I need to resolve this somehow?  Or is this something you resolve while the
> patches are in staging-testing?
> 
> Is there something we need to do in the cover letter of a patch series to
> ensure order?  Perhaps my cover letter implied these were not ordered?  If so,
> I again apologize.

Did you number your patches?  That's the only way to ensure that they
are applied in the correct order, that's what I sort on to apply them.
If you don't order them, I randomly guess, or just reject them...

All seems to build now, right?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
