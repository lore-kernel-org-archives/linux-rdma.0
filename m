From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Tue, 11 Oct 2016 14:06:12 -0600
Message-ID: <20161011200612.GA21656@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161009054601.GB9282@leon.nu>
 <20161009230150.GB12551@obsidianresearch.com>
 <20161010040930.GF9282@leon.nu>
 <20161011180517.GA17866@obsidianresearch.com>
 <20161011194633.GP9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161011194633.GP9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 11, 2016 at 10:46:33PM +0300, Leon Romanovsky wrote:

> But I'm still left under impression of this article [1] that using such
> macro is a bad thing and we are "punishing" all users of modern compilers.

I agree with the article, it is a bad idea. This is why my version is
disabling the macro entirely if gcc 6 or clang is used - aka the
compilers that run in Travis.

So, new code must not introduce control flow that is more complex than
gcc 6 can understand, and the macro is used only for gcc 4.x and 5.x
compatability to provide warning free compile on popular distros
without a performance hit.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
