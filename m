From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Wed, 5 Oct 2016 10:32:50 -0600
Message-ID: <20161005163250.GB18636@obsidianresearch.com>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005115132.GE9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 02:51:32PM +0300, Leon Romanovsky wrote:

> I'm using 16.04 and it has gcc 5.4.0 as a default. Don't you think that
> 6.2 is too "new" for us and other distributions?

I don't understand how a compiler can be too new? The next round of
rolling release distros are likely to use this compiler, and those are
the distros that will first pick to up rdma-core.

> gcc (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609

This is exactly why the automatic builds should run the latest
compiler, because people are not going to install it on their desktop.

People will test with older compilers on their own. If we want to run
automatic tests from travis with old compilers we can, but my results
basically show that older compilers are just buggy and produce
incorrect warnings.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
