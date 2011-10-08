From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: how to debug (mlx4) CQ overrun
Date: Sat, 8 Oct 2011 04:21:06 -0700
Message-ID: <CABgxfbGQqJmUgVPCWBKFfv7s02yjMOuNSAQV4v+XuCk4GAxfzg@mail.gmail.com>
References: <CABgxfbHAMu9Lvd1j8nJF8DdTk0UYQOuxN70Z73XJv3VuLSk7-w@mail.gmail.com>
	<20110923213010.GA2807@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923213010.GA2807-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2011 at 2:30 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> There are not really any tools, but this is usually straightforward to
> look at from your app.
>

Great thanks for the response. It helped (to ensure our cq handling
logic was ok). The issue turns out to be build related. After doing a
clean rebuild of OFED IB modules with the modified header files, the
problem went away. The (header file) change was a result of exporting
kernel FMR (fast memory registration) to user space for an
experimental project.

Again, thank you for the write-up. It is very appreciated.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
