From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: how to debug (mlx4) CQ overrun
Date: Fri, 23 Sep 2011 15:30:10 -0600
Message-ID: <20110923213010.GA2807@obsidianresearch.com>
References: <CABgxfbHAMu9Lvd1j8nJF8DdTk0UYQOuxN70Z73XJv3VuLSk7-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABgxfbHAMu9Lvd1j8nJF8DdTk0UYQOuxN70Z73XJv3VuLSk7-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2011 at 02:15:30PM -0700, Wendy Cheng wrote:

> I have my own counters that restrict the read (and write) to 512 max.
> Both write and read are blocking (i.e. cq is polled after each
> read/write). I suspect I do not have the cq poll logic correct. The
> question here is .. is there any diag tool available to check on the
> internal counters (and /or states) of ibverbs library and/or kernel
> drivers (to help RDMA applications debug) ? In my case, it hangs
> around 14546 block (i.e. after 14546*8192 byes).

There are not really any tools, but this is usually straightforward to
look at from your app.

Every time you post to the send Q increment a counter. Everytime you
get something back from ibv_poll_cq increment another counter.

The (A - B) must never exceed the number of entries in the CQ, and it
must not exceed the number of entries in the send Q (very important).

This assumes you are posting everything with IBV_SEND_SIGNALED. Doing
otherwise is basically the same but there is a bit more complexity to
manage the CQ counter as each completion represents multiple sendQ
entries.

Make sure you check for error codes from ibv_post_send.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
