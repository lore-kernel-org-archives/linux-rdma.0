From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Mon, 15 Jun 2015 12:13:48 -0600
Message-ID: <20150615181348.GC1089@obsidianresearch.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
 <20150615173423.GA528@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF5828@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF5828-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 15, 2015 at 06:11:02PM +0000, Hefty, Sean wrote:
> > Was Al Viro's comment on qib addressed here? That would be a
> > showstopper for me..
> 
> Do you have a link to this comment?  I'm missing a bunch of messages from this thread and can't find anything from Al in the logs.

Author: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Date:   Sat Apr 4 00:11:32 2015 -0400

    infinibad: weird APIs switched to ->write_iter()
    
        Things Not To Do When Writing A Driver, part 1001st:
    have writev() and write() on the same file doing completely
    different things.  As in, "interpret very different sets of
    commands".
    
        We _can_ handle that, but it's a bloody bad idea.
    Don't do that in new drivers.  Ever.
    
    Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

Jasn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
