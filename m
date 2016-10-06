From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 6 Oct 2016 10:10:09 -0600
Message-ID: <20161006161009.GE1224@obsidianresearch.com>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
 <20161005163250.GB18636@obsidianresearch.com>
 <20161006045337.GK9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006045337.GK9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 06, 2016 at 07:53:37AM +0300, Leon Romanovsky wrote:

> > I don't understand how a compiler can be too new? The next round of
> > rolling release distros are likely to use this compiler, and those are
> > the distros that will first pick to up rdma-core.
> 
> I have an issue in front of my eyes where kernel fails to build with old
> gcc version, while new gcc version works.

Heh, last week I had the opposite..

> My experience shows the same, however I want to minimize the test burden
> on the users.

IMHO, it is more valuable to run a build on the full distro stack than
to try and inject old compiler variations into travis. Old system
libraries are just as likely to fail a build as the compiler.

I don't have any way to do that automatically. IMHO Travis is not able to
handle that sort of workload.

Perhaps a pre-release pass through OBS or something like it is the answer here?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
