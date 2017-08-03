From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/uverbs: Fix the check for port number
Date: Thu, 3 Aug 2017 15:41:49 -0700
Message-ID: <20170803224149.GF2396@kroah.com>
References: <1501085686-12916-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501085686-12916-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "# v4 . 2-v4 . 9" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 26, 2017 at 11:14:46AM -0500, Mustafa Ismail wrote:
> The port number is only valid if IB_QP_PORT is set in the mask.
> So only check port number if it is valid to prevent modify_qp
> from failing due to an invalid port number.
> 
> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2-v4.9
> Cc: <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Upstream commit 5a7a88f1b488("Fix the check for port number")
> Modified from upstream commit: helper function rdma_is_port_valid does not
> exist in these kernel versions.

Note, you sent this 3 times for some reason, why?

Also, it was hard to figure out what to do with it, I think it was ment
for me to apply to the 4.4 and 4.9-stable trees, right?  If so, I've
done that, if not, please let me know.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
