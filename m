From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 15:20:16 -0600
Message-ID: <20130621212016.GA10637@obsidianresearch.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com>
 <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com>
 <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com>
 <20130621063648.GA27963@obsidianresearch.com>
 <51C48F01.5030103@redhat.com>
 <20130621182617.GA17700@obsidianresearch.com>
 <51C4BE25.9000501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C4BE25.9000501-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 21, 2013 at 04:57:09PM -0400, Doug Ledford wrote:

> > I disagree, *verbs* needs to expose the HW capabilities, efficiently.
> 
> What we need is an efficient RDMA API (of which verbs is a candidate for
> the underlying implementation).  It need not expose HW capabilities in
> its base form.

Well, there is uDAPL, but lots of people don't like it...

> > K.. So, nobody seems to be paid to work on these verbs libraries, what
> > you are talking about is a tonne of typing - who is going to do
> > this?
> 
> <raises hand>  I'm ready for a new project.  I already had one in mind,
> but it required some changes to libibverbs that are pretty deep changes.
>  Instead of doing that deep work in libibverbs, I can start here and
> move on to my next project when this is up and running.

That would be amazing, I will try to help you as best my limited time
permits.

> Realistically I'm talking about starting off by cannibalizing
> libibverbs, librdmacm, and libibcm into a single library.  That's a lot
> of cut and paste work, with ensuing fixups.  After the initial bring
> together, then we can start re-architecting and moving forward.

The core umad and the issm buisness should be included as well, eg
single core library API that wraps the entire API the kernel exports
from drivers/infiniband.

I've done some elements of this in my python-rdma project.

> If they wish to keep getting their infrastructure for free, then they
> kinda get what they get.  I mean, you don't want to just change things
> and piss them off for no good reason, but when good reason exists, they
> can suck it up and deal with it.  No one in the open source community is
> obligated to preserve an outdated API forever just to make them happy.
> The other alternative is that they can pick up long term maintenance of
> libibverbs, librdmacm, and libibcm themselves (in fairness I can't
> say

A fact of things right now is that the ISVs are contributing a
majority of the manpower for changes to the API.

> As I mentioned, this patch is just another in a line of kludges.  That
> doesn't make it wrong, it makes it ugly.  I'm for breaking the cycle.
> But even if we do go ahead and break the cycle, that will take more time
> than I imagine Jeff is willing to wait.  So in the meantime, I guess we
> just gotta do what we just gotta do...

K..

Jeff: If you are still reading - one concrete suggestion, I think, is
to ensure compile-time failure when the new-format MTU variable is
touched.

This is trivially done by wrapping it in a struct:

struct ibv_mtu_t {int __mtu;};

At least this will cause compile failure at all sites that need
revision.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
