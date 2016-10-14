From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: sparse fixes, part2
Date: Thu, 13 Oct 2016 22:06:02 -0600
Message-ID: <20161014040602.GA5726@obsidianresearch.com>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 09:55:59PM +0200, Christoph Hellwig wrote:
> This has the rest of the provider fixes that the mail server
> didn't let through last time.

I tested these and added them to the PR.

I also tacked on two more commits to enable similar gcc warnings, gcc noticed
a few more cases which I also fixed..

https://github.com/linux-rdma/rdma-core/pull/19/commits/2e20ef09914a47e5be35d3e1587697a7337aa93a
https://github.com/linux-rdma/rdma-core/pull/19/commits/2808a6142146576036ca36e7b527ff0c8f2da3ce

Though, I had to use '#pragma GCC diagnostic ignored
"-Wmissing-prototypes"' to deal with the symver stuff.. Couldn't find
a better way..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
