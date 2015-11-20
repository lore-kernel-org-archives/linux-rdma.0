From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 08:39:35 -0800
Message-ID: <20151120163935.GA10091@kroah.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com>
 <564F3F1C.4020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564F3F1C.4020508-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
> To that end, I've opened my 4.4-rc branch and deleted the three
> deprecated drivers from staging and moved hfi1 to the rdma tree.  I've
> sent an email to Linus to see if he's ok taking those changes, and if
> so, I'll get them submitted and then open up my for-4.5 branch early to
> be able to start taking for-next patches.

I think it's too late for that, especially given that I have 34+ patches
for the staging rdma drivers already in my tree in linux-next.  And the
hfil1 code really doesn't look like its ready to merge into the "real"
portion of the kernel tree, given the horrid nature of the patches
submitted recently for it :(

I had expected the drivers to be deleted for -rc1, removing them now
seems a bit late in the merge window.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
