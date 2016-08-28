From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 12:39:21 -0600
Message-ID: <20160828183921.GD12783@obsidianresearch.com>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com>
 <20160828182613.GP594@leon.nu>
 <20160828182813.GB12783@obsidianresearch.com>
 <20160828183500.GQ594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828183500.GQ594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 28, 2016 at 09:35:00PM +0300, Leon Romanovsky wrote:

> We need this revert, because the original commit is wrong and as was
> presented

Sure, but it was also wrong to return EINVAL at all, the only correct
outcome I can see is to apply your whole series. Reverting doesn't
make the big picture any better, just differently wrong.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
