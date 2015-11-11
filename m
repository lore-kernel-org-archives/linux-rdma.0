From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 5/9] staging/rdma/hfi1: Add function stubs for TID
 caching
Date: Wed, 11 Nov 2015 12:31:43 +0300
Message-ID: <20151111093143.GE18797@mwanda>
References: <1446245928-12675-1-git-send-email-ira.weiny@intel.com>
 <1446245928-12675-6-git-send-email-ira.weiny@intel.com>
 <20151107010235.GA24586@kroah.com>
 <20151110001102.GA11150@phlsvsds.ph.intel.com>
 <20151110001827.GA29500@kroah.com>
 <20151111061039.GB9594@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151111061039.GB9594-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 01:10:40AM -0500, ira.weiny wrote:
> The original author and I have been going through the code to see what we can
> do.  We have identified a couple of other pieces which can be split.
> 
> One question.  Is it ok to have functionality which is added which is unused in
> a preliminary patch?  I believe this is ok as long as the code compiles but I
> just wanted to make sure.  While there are different operations added in this
> patch it is broken to not use them as a set.  So we need to have a series which
> implement the pieces with a final patch which exposes the set of operations.
> 
> Is this acceptable?

Yeah.  It's fine.  Don't add warnings about unused static functions
though.  Also we like to see a user in the same patchset so don't add
infrastructure first and the user code the next year or whatever.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
