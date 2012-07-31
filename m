From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] zero-copy extensions for rsockets
Date: Tue, 31 Jul 2012 15:34:50 -0600
Message-ID: <20120731213450.GA5787@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
 <20120731183243.GA4755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E926@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A6E926-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 31, 2012 at 08:33:49PM +0000, Hefty, Sean wrote:
> > This looks very similar to the libaio interface..
> 
> I did look at aio.  It may be possible to use aio context in place
> of ioq, and I'm open to that.  I was actually modeling ioq more
> after epoll than aio.  It just seemed simpler to treat an ioq as a
> standard fd.

libaio is designed to be used along with an eventfd that provides the
epoll like semantics you are talking about. Each time you call
io_submit you can call io_set_eventfd() on the iocb and the aio engine
will trigger that eventfd when the IO completes. poll or epoll on the
eventfd fd.

> My concern is that supporting a more flexible API, like aoi, would
> effectively result in losing some desirable feature handling
> completions, such as kernel bypass or reducing interrupts.  With
> aio, I'm unsure about the impact of supporting callback
> notifications and the selection of each aio context on a per request
> basis.

I'm not sure what you are refering to here? Are you mixing up POSIX
aio with libaio? They are totally different. libaio has no callback
notification mechanism, just io_getevents.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
