From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iw_cxgb4: use wildcard mapping for getting remote addr info
Date: Thu, 7 May 2015 14:45:08 -0600
Message-ID: <20150507204508.GA1195@obsidianresearch.com>
References: <20150507145224.28735.97977.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150507145224.28735.97977.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 07, 2015 at 09:52:24AM -0500, Steve Wise wrote:
> For listening endpoints bound to the wildcard address, we need to pass
> the wildcard address mapping to iwpm_get_remote_info() instead of the
> mapped address of the new child connection.

It would be nice to see a discussion about what bug this fixes in the
commit message...

So we can answer the question: Does this need to go to -stable?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
