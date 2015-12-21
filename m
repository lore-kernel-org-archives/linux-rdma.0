From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add
 rdmavt support in HFI1
Date: Mon, 21 Dec 2015 14:02:35 -0800
Message-ID: <20151221220235.GA14142@kroah.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
 <20151221061214.GD3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151221061214.GD3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 01:12:14AM -0500, ira.weiny wrote:
> Greg, Doug,
> 
> As mentioned below, these patches depend on the new rdmavt library submitted to
> Doug on linux-rdma.
> 
> We continue to identify (and rework) patches by our other developers which can
> be submitted without conflicts with this series.  Furthermore, We have, as much
> as possible, placed fixes directly into rdmavt such that those changes can be
> dropped from hfi1.  But at this point, we need to know if and where these are
> going to land so that we can start reworking as appropriate.
> 
> Therefore, I would like to discuss plans to get hfi1 under the same maintainer
> to work through this transitional period.
> 
> Basically, At what point should we stop submitting patches to Greg and start
> submitting to Doug?
> 
> Should we consider the merge window itself as the swap over point and submit
> changes to Doug at that point?  If so, should we continue to submit what we can
> to Greg until then (and continue rebase'ing the series below on that work)?  Or
> given Gregs backlog, should we stop submitting to Greg sometime prior to the
> merge window?
> 
> That brings up my final question, at the point of swap over I assume anything
> not accepted by Greg should be considered rejected and we need to resubmit to
> Doug?

If Doug accepts the library changes, let me know that public git commit
and I can pull it into the staging-next branch and you can continue to
send me staging patches that way.

That's the easiest thing to do usually.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
