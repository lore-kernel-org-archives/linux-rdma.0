From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Tue, 11 Oct 2016 12:05:17 -0600
Message-ID: <20161011180517.GA17866@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161009054601.GB9282@leon.nu>
 <20161009230150.GB12551@obsidianresearch.com>
 <20161010040930.GF9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010040930.GF9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2016 at 07:09:30AM +0300, Leon Romanovsky wrote:

> > I think people would complain about the extra stores. gcc 6 will
> > eliminate them, but older compilers will not.
> 
> This unintialized_var(x) adds extra store too (... x = x ...).

I have confirmed that the unintialized_var macro does not impact code
generation on the old gccs while the =0 approach does.

So no extra store.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
