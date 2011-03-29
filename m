From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IBV Test Program
Date: Tue, 29 Mar 2011 11:14:50 -0600
Message-ID: <20110329171450.GF6205@obsidianresearch.com>
References: <201103291248.42710.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201103291248.42710.kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 29, 2011 at 12:48:42PM -0400, Greg Kerr wrote:

> I've tried asking this question in a few different places with no
> luck, so I'm hoping you folks can help me. I'm an undergraduate
> research assistant learning how to use verbs and I had a question.
 
> I want to modify rc_pingpong.c to loop and basically send data
> between the two nodes multiple times, instead of just once. The
> first time through, it successfuly completes the transmission. On
> the next iteration the call to ibv_post_recv fails.

This will post into a RC QP without a recv buffer on the far side
because the way you have the loop around ibv_poll_cq is not right.

You need to loop around ibv_poll_cq until you get both completions,
then repost your recv buffer and then sleep. Otherwise you will end up
posting a send into a QP with no recv buffer and send the QP to the
err state which mucks everything up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
