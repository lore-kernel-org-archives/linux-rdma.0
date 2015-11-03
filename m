From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 21:38:15 -0700
Message-ID: <20151103043815.GA4877@obsidianresearch.com>
References: <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com>
 <56380535.5040101@redhat.com>
 <20151103012821.GA24650@obsidianresearch.com>
 <563815F7.2090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563815F7.2090003-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 09:03:35PM -0500, Doug Ledford wrote:

> No, one kernel consumer that never worked on iWARP before now works on a
> different iWARP controller but doesn't work on the old iWARP controller.
>  Hardly the end of the world.

NFS is gone/going as well, and that used to work. No iWarp enabled ULP
(now or in future) will work without at least FMRs..

I just disagree we should continue to hang on to unused hardware that
isn't even capable of running the whole stack we are maintaining. That
makes no sense to me. If it doesn't run our full stack then ditch it.

> > *WHY* spend an ounce of time fixing up code that *NO-ONE* will ever
> > even run? Wasted effort. Just delete them now.
> 
> You don't just "delete them now" because it denies anyone advanced
> warning of the change and denies them the chance to speak up in
> opposition to the driver's removal.

We've already gone through a cycle, 'now' is a fine time to do it.

You are talking like deletion is irreversible. It isn't. If someone
comes forward with a need and a desire to test that it still works
then reverting a delete shouldn't be that difficult.

On the other hand, the developer time wasted keeping it working while
we wait is not recoverable.

> distros proactively queried their customer's hardware usage.  But
> without either a query activity or a push back cycle, your assertion
> that "*NO-ONE* will ever even run?" is mere assumption not a statement
> of fact.

No, it is a statement based on my knowledge of the history of these
cards and our user base, combined with the responses from the vendors
who do have a better sense.

Ammasso went out of buisness before the driver was even in mainline.
Tom got it in mainline after the fact as a early way to work on
generic iWarp support. There were few users (<<100) and similarly few
cards. As far as I'm concerned all users got the 'obsolete, do not
use' message 10 years ago.

ipath only supports the HTX cards, which where a short run engineering
experiment that were not market successful (10 years ago), few were
made. Those cards are unsuable in modern hardware. The vendor
announced they were no longer supported when the qib driver was made,
as far as I'm concerned all users got the 'obsolete, do no use'
message 5 years ago.

ehca was part of IBM's high end systems. A >= 4.4 kernel isn't going
to be qualified or tested on that hardware. Nobody would run
production like that. I actually bet some are still running
somewhere..

Seriously, there are zero production users, it isn't even a question.

If a hobby user appears, then they can restore the driver and fix it
up, and explain why we should carry it when it doesn't run the full
stack.

> I suspect you are right and we *could* delete them now without a
> problem.  But without that push back cycle or a query to find out for
> sure, you're asking me to take it on faith instead of doing due
> diligence, and I don't have any intention of being called out later for
> failing to do due diligence.

Nobody is going to call you out for removing a driver, especially when
the *vendor* said it was OK.

On the other hand, people have been sending unhappy messages with
the current arrangement...

kernel.org isn't a distro - we can flip flop ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
