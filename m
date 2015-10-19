From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 00/23] Update driver to 0.9-294
Date: Mon, 19 Oct 2015 11:25:31 -0700
Message-ID: <20151019182531.GA1084@kroah.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
 <20151019165408.GA30921@kroah.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1CBCA641@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CBCA641-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2015 at 06:16:55PM +0000, Weiny, Ira wrote:
> > 
> > On Mon, Oct 19, 2015 at 12:43:24PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > The following series has bug fixes and updates to the staging hfi1 driver.
> > 
> > Why are you adding new functionality to this driver before it is moved out of
> > drivers/staging/ ?  I _REALLY_ don't like to see that, because it implies that you
> > are spending time and energy on new stuff, not fixing up the known issues
> > instead.
> 
> Perhaps I did not chose my words carefully enough.
> 
> The largest issue on the TODO list is the refactoring of the code to
> be shared between the hfi1 and qib driver.  While the hardware between
> hfi1 and qib is similar and thus the initial code looked similar, our
> performance tuning on hfi1 has revealed that some changes will be
> required to the hfi1 code to fully utilize the hardware.  We would
> like to get these updates in to make sure that the refactoring work is
> done properly for the 2 hardware types.

Then you need to say that very carefully :)

> > Please redo this patch series and don't add new stuff.
> > 
> 
> I can do this but it will cause us to do our refactoring work 2 times in order for it to be done correctly (properly support both hardware types).  Of the 23 patches I sent only one has significant updates which don't conflict with this refactoring work.

Please wrap your email lines...

If you are just "refactoring to make things better for X" then great,
that's fine, but that's not what you said here.

> [PATCH 15/23] staging/rdma/hfi1: Implement Expected Receive TID caching
> 
> However, without this patch users performance will be impacted.

You mean it would be just as bad as it is today, which is fine :)

See my comments on that patch for what I object to it specifically.

> In the interest of full disclosure we still have at least 2 more series, possibly 3 which are similar to this series, bug fixes and performance improvements.

Why are you keeping these patch series from being submitted?  The longer
you wait, the more work it will take on your part.  If you have
performance fixes, those are just that, 'fixes', but please don't go
adding new functionality, take the time to do the work to get this out
of the staging tree and then you can optimize it as much as you want.

> Given the above explanation, would you find it acceptable to take these "updates"?  I can certainly rework patch 15 to separate out the code clean up as per your other email.

Please rework the series.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
