From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Fri, 24 Jun 2016 00:13:36 -0700
Message-ID: <20160624071336.GE4252@infradead.org>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
 <20160622161559.GA18361@infradead.org>
 <20160622203110.GA20838@obsidianresearch.com>
 <576B8B30.8080402@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <576B8B30.8080402-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 10:09:36AM +0300, Sagi Grimberg wrote:
> Completely agree Jason. Lowering the retry_count is very useful
> for APM (Automatic Path Migration).

Does this mean you're retracting the patches?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
