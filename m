From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/sa: Put netlink request into the request list
 before sending
Date: Wed, 28 Oct 2015 10:46:36 -0600
Message-ID: <20151028164636.GB14310@obsidianresearch.com>
References: <1446039867-27883-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446039867-27883-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2015 at 09:44:27AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

>  	ret = ib_nl_send_msg(query);
> +	spin_lock_irqsave(&ib_nl_request_lock, flags);

Looks like query could be kfree'd before ib_nl_send_msg returns, eg by
send_handler?


>  	if (ret <= 0) {
>  		ret = -EIO;
> -		goto request_out;
> +		/* Remove the request */
> +		list_del(&query->list);

This one is probably OK iff nl_send_msg cannot call send_handler if it
returns error, which looks true.

>  	} else {
>  		ret = 0;
> +		/* Start the timeout if this is the only request */
> +		if (ib_nl_request_list.next == &query->list)

This one looks sketchy. Maybe move this to the first locking block? A
extra timer on send error is not important enough to worry about..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
