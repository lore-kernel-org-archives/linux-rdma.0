From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Sun, 29 May 2016 17:30:09 -0600
Message-ID: <20160529233009.GA12420@obsidianresearch.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <574B6F71.9060808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 29, 2016 at 06:38:41PM -0400, Doug Ledford wrote:
 
> So I've been busy with kernel stuff, but I don't really like this patch.
>  I'm not really enamored with the entire poll_ex API.

You should really read the whole prior discussion

> First, I don't like the start_poll/poll/end_poll setup.  I would rather
> we do something like using refcounting on the WCs.  Maybe something like
> returning an array of pointers to WCs where each WC already has a
> ref

Refs? Yuk. That doesn't fit the typical use model, and refs
involve more expensive locking per wc.

> When a cq is created by the driver, it is responsible for filling out
> the offsets array (can be static if your driver only has one CQE
> format,

*shrug* Careful benchmarking would have to prove if this is better or
not. Based on Yishai's comments I expect it is not better, since I
expect an offsets array to perform worse than the original bitmask
thing.

Yishai's said this benchmarked better than the bitmask and equal to
or better than today's versions..

This is a whole picture optimization and the user side is only one
part of the equation - the function pointer scheme is also optimizing
the driver path quite heavily, which is why it is showing positively
in benchmarks.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
