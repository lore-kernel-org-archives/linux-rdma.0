From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] zero-copy extensions for rsockets
Date: Tue, 31 Jul 2012 20:33:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6E926@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
 <20120731183243.GA4755@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731183243.GA4755-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This looks very similar to the libaio interface..

I did look at aio.  It may be possible to use aio context in place of ioq, and I'm open to that.  I was actually modeling ioq more after epoll than aio.  It just seemed simpler to treat an ioq as a standard fd.
 
For the get/put calls, there's no requirement to use asynchronous or nonblocking I/O.  When asynchronous operations are used, restricting each socket to a single, persistent ioq thingy simplifies the implementation by making the mapping between an ioq and HW CQs easier to manage.

My concern is that supporting a more flexible API, like aoi, would effectively result in losing some desirable feature handling completions, such as kernel bypass or reducing interrupts.  With aio, I'm unsure about the impact of supporting callback notifications and the selection of each aio context on a per request basis.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
