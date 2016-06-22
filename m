From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Wed, 22 Jun 2016 14:31:10 -0600
Message-ID: <20160622203110.GA20838@obsidianresearch.com>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
 <20160622161559.GA18361@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160622161559.GA18361-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 22, 2016 at 09:15:59AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 22, 2016 at 03:05:59PM +0300, Sagi Grimberg wrote:
> > This parameter was added in order to support a proper timeout for
> > error recovery before the spec defined a periodic keep-alive.
> > 
> > Now that we have periodic keep-alive, we don't need a user configurable
> > transport layer retry count, the keep-alive timeout is sufficient,
> > transports can retry for as long as they see fit.
> 
> Isn't there some IB protocol level rationale for a low retry count
> in various fabric setups?

IIRC the retry count is part of what drives the APM switch over, so
APM configuration should use a lower value.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
