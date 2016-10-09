From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Sun, 9 Oct 2016 17:01:51 -0600
Message-ID: <20161009230150.GB12551@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161009054601.GB9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161009054601.GB9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 09, 2016 at 08:46:01AM +0300, Leon Romanovsky wrote:

> 1. Can we remove this uninitialized_var at all and simply replace by
> default values?

I think people would complain about the extra stores. gcc 6 will
eliminate them, but older compilers will not.

But yes, we could do this.

> 2. Do we really want additional folder to ccan with such common headers?
> What about rename ccan to be util and put this new file there (in case
> you proceed with it)?

I see the ccan directory as stuf from ccan that we are not going to
change, while util is for new stuff specific to this tree.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
