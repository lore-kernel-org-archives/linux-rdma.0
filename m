From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: update rdma-plumbing Documentation
Date: Mon, 19 Sep 2016 13:25:50 -0600
Message-ID: <20160919192550.GA7486@obsidianresearch.com>
References: <1474300593-31922-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474300593-31922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2016 at 08:56:24AM -0700, Christoph Hellwig wrote:
> Get rid of the per-subproject README files and instead improve the top-level
> README.md as well as adding a few new files for more details to Documentation/

Thanks Christoph, this all looks great to me.

Thanks for taking the time to switch to markdown, since we are decided
to use github that will work well.

If you don't mind I'll squish patch 2 'remove empty documentation
files' into 'Remove the auto* based build systems'

For now I'll pop these onto my tree so they don't get lost.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
