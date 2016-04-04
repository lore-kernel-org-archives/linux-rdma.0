From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 08/10] IB/qib: Remove qp and mr functionality from qib
Date: Mon, 4 Apr 2016 00:47:03 -0700
Message-ID: <20160404074703.GA28637@infradead.org>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
 <20160122204525.2022.20568.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160122204525.2022.20568.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 22, 2016 at 12:45:59PM -0800, Dennis Dalessandro wrote:
> Remove qp and mr support from qib and use rdmavt. These two changes
> cannot be reasonably be split apart into separate patches because they
> depend on each other in mulitple places. This paves the way to remove
> even more functions in subsequent patches.

This seems to have removed support for mapping MRs in the QIB drivers,
as there doesn't seem to be any map_mr_sg method in either rdmavt
or qib in the current tree.

Whilke we're at it: the mess in check_driver_override and check_support
will break the first time someone changes any method calls.  Type safety
exists for a dricking reason - fix this mess to write a little more
code but be type savfe and don't rely on the ordering of fields or you
can keep the pieces as soon as this junk breaks.  And it will break
soon!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
