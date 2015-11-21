From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: HFI1 code duplication todo
Date: Sat, 21 Nov 2015 10:53:47 -0500
Message-ID: <20151121155346.GA3304@phlsvsds.ph.intel.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com> <20151119222319.GA17605@phlsvsds.ph.intel.com> <564F3F1C.4020508@redhat.com> <20151120222523.GX18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151120222523.GX18797@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 21, 2015 at 01:25:23AM +0300, Dan Carpenter wrote:
> On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
> > So, as to the hfi1/qib/rxe transport library.  The qib driver is in the
> > rdma tree, and we aren't going to move it to staging just because it
> > depends on something in staging, so we need to start adding the library
> > in the core tree to avoid dependency issues.  As for the hfi1 driver,
> > I'm of the opinion that putting it in staging because of the code
> > duplication issue was probably not the right thing to do.  It's
> > benefited from the extra eyes on it to help make it a better driver, but
> > I think I'm ready to move it to the main RDMA tree and start working on
> > it from there where there won't be any cross tree dependency issues.
> 
> You could leave it staging but manage it from the same git tree.  It
> avoids the cross tree dependencies.  This is what we do for
> drivers/staging/media/, all that stuff goes through the linux-media
> tree.

My concern is that we tried this before and it did not work.

https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg27842.html
https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg27858.html

Shall we try it again?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
