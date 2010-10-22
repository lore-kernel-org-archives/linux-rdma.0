From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA version of select for multiplexing rdma connections?
Date: Fri, 22 Oct 2010 16:06:44 -0600
Message-ID: <20101022220644.GC15514@obsidianresearch.com>
References: <AANLkTikPStczJpRo9va7Q=rj0C+gwwq0X0kOUKDBKN34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikPStczJpRo9va7Q=rj0C+gwwq0X0kOUKDBKN34-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <adit.262-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 22, 2010 at 05:07:23PM -0400, Adit Ranadive wrote:

> I have been building a server client type of application based on top
> of RDMA/Verbs user libraries.

You can use select/poll/etc on CQ's after the connection has been
accepted, see ibv_create_comp_channel.

If you want to do non-blocking accept .. I'm not sure that is possible
with RDMA CM. Create a thread to block in rmda_accept and pass
the accepted connection back to your main thread using an eventfd/pipe
construct to wake your select loop?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
