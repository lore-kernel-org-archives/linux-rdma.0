From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: capturing the error log from rdma-core
Date: Mon, 10 Oct 2016 10:12:46 -0600
Message-ID: <20161010161246.GB26805@obsidianresearch.com>
References: <20161010153013.GA22997@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010153013.GA22997-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2016 at 08:30:13AM -0700, Christoph Hellwig wrote:

> what's the best way to generate a log of the compiler errors with the
> shiny new rdma-core build system?  With make I'd do make 2>err.log
> but with the new build system the verbose build output and the errors
> are mixed in the same stream, so this isn't possible anymore.

If I understand you, you want to split STDOUT and STDERR because
sparse puts differentiated output on each FD?

There is a thread on the ninja list about fixing this, and here is a
proposed patch

https://github.com/dendy/ninja/commit/62564251afdafd9926fde363035807fb482ab0b9

But looks like it is not in main line.

I think the simplest approach for you will be to use make when doing
this kind of work:

$ mkdir build-make
$ cd build-make
$ CC=cgcc cmake
$ make 1> a 2> b

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
