From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 16:00:29 -0600
Message-ID: <20150911220029.GA20262@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <20150911183931.GB546@obsidianresearch.com>
 <55F3350D.6090002@redhat.com>
 <20150911203820.GA19161@obsidianresearch.com>
 <55F34A59.50401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F34A59.50401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 11, 2015 at 05:40:41PM -0400, Doug Ledford wrote:
> Then a simple mcast_expire_task that runs every 10 minutes or so and
> leaves any send-only groups that haven't had a packet timestamp update
> in more than some arbitrary amount of time would be a very simple
> addition to make.

That all makes sense to me and addresses the backlog issue Christoph
mentioned.

It would also be fairly simple to do send-only join properly with the
above, as we simply switch to polling the SA to detect if the join is
good or not on the same timer that would expire it.

> > If it isn't subscribed to the broadcast MLID, it is violating MUST
> > statements in the RFC...
> 
> Yeah, my comment was in reference to whether or not it would receive a
> multicast on broadcast packet and forward it properly.

It would be hugely broken to be sensitive to the MLID when working
with multicast routing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
