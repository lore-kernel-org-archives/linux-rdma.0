From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: capturing the error log from rdma-core
Date: Mon, 10 Oct 2016 10:44:52 -0600
Message-ID: <20161010164452.GA1796@obsidianresearch.com>
References: <20161010153013.GA22997@infradead.org>
 <20161010161246.GB26805@obsidianresearch.com>
 <20161010161659.GA2219@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010161659.GA2219-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2016 at 09:16:59AM -0700, Christoph Hellwig wrote:
> > If I understand you, you want to split STDOUT and STDERR because
> > sparse puts differentiated output on each FD?
> 
> No, sparse only outputs to SDTERR.  But for some reason the rdma-core
> build system multiplexes this back into STDOUT.

Right, ninja puts everything onto STDOUT as part of 'output-sync'
operation. That is usually not a problem..

If you are asking for the 'quietest' build then this hack will do it:

$ ninja | grep -v "^\["

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
