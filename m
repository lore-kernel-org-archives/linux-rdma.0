From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Thu, 13 Oct 2016 13:03:26 -0600
Message-ID: <20161013190326.GA19904@obsidianresearch.com>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 07:51:03PM +0200, Christoph Hellwig wrote:
> This is the low hanging fruit in terms of reducing sparse noise before
> looking into endianess and iomem annotations.

Looks fine to me. Since I gave them a good compile test I also
prepared the pull request for the first 15 that made it to the list:

https://github.com/linux-rdma/rdma-core/pull/19

Here is the patch to turn on gcc -Wstrict-prototypes

https://github.com/jgunthorpe/rdma-plumbing/commit/dd80c3b362ae90d0de36a6249409c20581bae864

I'll grab the rest of the patches into this PR when they make it to
the list.

Made one tiny change, re-orderd 'iwpmd: fix the prototype for the
pthread_create start functionss' to be before 'iwpmd: use proper
ANSI-C prototypes for functions without arguments' as this ordering
keeps every patch buildable.

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
