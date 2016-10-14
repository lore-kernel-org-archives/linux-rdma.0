From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Fri, 14 Oct 2016 10:40:17 -0600
Message-ID: <20161014164017.GA6258@obsidianresearch.com>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
 <20161013190326.GA19904@obsidianresearch.com>
 <20161014043705.GF9282@leon.nu>
 <20161014051843.GB8073@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014051843.GB8073-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 07:18:43AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 14, 2016 at 07:37:05AM +0300, Leon Romanovsky wrote:
> > I didn't look on it yet, but maybe someone already knows the answer.
> > Can we run static analyzer tools as part of our TravisCI runs?
> 
> Just run CC=cgcc cmake for sparse..

We need to run sparse in a pass/fail way for Travis, I use -Werror to
do this for gcc.

The sparse version easially installable in travis is 0.4.5~rc1, if we
need newer then we have to find an APT repository with it built for
trusty.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
