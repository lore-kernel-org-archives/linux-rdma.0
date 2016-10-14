From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Fri, 14 Oct 2016 07:18:43 +0200
Message-ID: <20161014051843.GB8073@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de> <20161013190326.GA19904@obsidianresearch.com> <20161014043705.GF9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014043705.GF9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 07:37:05AM +0300, Leon Romanovsky wrote:
> I didn't look on it yet, but maybe someone already knows the answer.
> Can we run static analyzer tools as part of our TravisCI runs?

Just run CC=cgcc cmake for sparse..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
