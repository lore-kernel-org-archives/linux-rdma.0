From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 23/23] staging/rdma/hfi1: Update driver version string to 0.9-294
Date: Tue, 27 Oct 2015 17:00:22 -0400
Message-ID: <20151027210021.GC32118@phlsvsds.ph.intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com> <1445869729-7507-24-git-send-email-ira.weiny@intel.com> <20151027084641.GA16795@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151027084641.GA16795-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 05:46:41PM +0900, Greg KH wrote:
> On Mon, Oct 26, 2015 at 10:28:49AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/staging/rdma/hfi1/common.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
> > index 7809093eb55e..5dd92720faae 100644
> > --- a/drivers/staging/rdma/hfi1/common.h
> > +++ b/drivers/staging/rdma/hfi1/common.h
> > @@ -205,7 +205,7 @@
> >   * to the driver itself, not the software interfaces it supports.
> >   */
> >  #ifndef HFI1_DRIVER_VERSION_BASE
> > -#define HFI1_DRIVER_VERSION_BASE "0.9-248"
> > +#define HFI1_DRIVER_VERSION_BASE "0.9-294"
> 
> Patches like this make no sense at all, please drop it and only use the
> kernel version.

What do you mean by "only use the kernel version"?  Do you mean

#define HFI1_DRIVER_VERSION_BASE UTS_RELEASE
     
Or just remove the macro entirely?

>
> Trust me, it's going to get messy really fast (hint, it
> already did...)

Did I base this on the wrong tree?  Not sure how this could have messed you up.

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
