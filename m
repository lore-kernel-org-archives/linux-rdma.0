From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2195/2195] Staging: rdma: amso1100: Fix multiple
 assignments on single line.
Date: Mon, 26 Oct 2015 01:31:27 +0900
Message-ID: <20151025163127.GA8425@kroah.com>
References: <1445770206-9645-1-git-send-email-weston.silbaugh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445770206-9645-1-git-send-email-weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Weston Silbaugh <weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 25, 2015 at 04:50:06AM -0600, Weston Silbaugh wrote:
> Multiple assignments should be avoided.
> 
> For example:
> 
> cm_event.ird = cm_event.ord = 128;
> 
> Should be:
> 
> cm_event.ird = 128;
> cm_event.ord = 128;
> 
> Signed-off-by: Weston Silbaugh <weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Where are the 2194 other patches in this series?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
