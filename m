From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/18] staging/rdma/hfi1: Extend quiet timeout
Date: Sat, 21 Nov 2015 01:04:15 +0300
Message-ID: <20151120220415.GA7289@mwanda>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-7-git-send-email-jubin.john@intel.com>
 <20151120011052.GG11695@kroah.com>
 <32E1700B9017364D9B60AED9960492BC259BD7AF@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259BD7AF-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 03:21:14PM +0000, Marciniszyn, Mike wrote:
> > > The longest quiet timeout is now 6s.  Extend the driver wait.
> > 
> > To what?  And why?  What does this fix?
> > 
> 
> The driver wasn't following the our internal specification: 6 seconds.
> 
> The patch corrects that issue.

Does that mean the patch fixes something which is visible to the user?
A better description would be:

We added XXX long timeout so now the longest timeout is 6 seconds in our
spec.  It shouldn't affect most users but something something prevents
a hang.

I had all the same issues that Greg did with these patch descriptions so
it was predictable that he was going to complain.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
