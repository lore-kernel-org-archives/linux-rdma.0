From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Wed, 22 Jun 2016 09:15:59 -0700
Message-ID: <20160622161559.GA18361@infradead.org>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466597161-5242-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 22, 2016 at 03:05:59PM +0300, Sagi Grimberg wrote:
> This parameter was added in order to support a proper timeout for
> error recovery before the spec defined a periodic keep-alive.
> 
> Now that we have periodic keep-alive, we don't need a user configurable
> transport layer retry count, the keep-alive timeout is sufficient,
> transports can retry for as long as they see fit.

Isn't there some IB protocol level rationale for a low retry count
in various fabric setups?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
