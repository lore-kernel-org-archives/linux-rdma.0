From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Tue, 15 Mar 2016 14:31:12 -0600
Message-ID: <20160315203112.GA2786@obsidianresearch.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2016 at 02:30:43PM +0530, Devesh Sharma wrote:
> >> I am not sure, to my mind kref_put(...,ib_uverbs_release_file) should
> >> also be skipped.
> >
> > I am talking about ib_uverbs_release_event_file
> 
> And I am adding ib_uverbs_release_file() as well. the other thread is already
> cleaning it up and if ib_uverbs_close() reads it NULL then why to put krefs?

> > The other context doesn't do a balancing kref_put(..,ib_uverbs_release_event_file).
> 
> Actually it does, in the very next while loop on event_file list.

I really don't understand your comments.

Maybe you can find some code snippits to explain this.

The krefs in ib_uverbs_event_close are unconditional. If that isn't
right, then there is another bug that needs to be explained. It sure
looks right to me as is.

The patch makes them conditional without any matching change
elsewhere, so it just simply must be wrong.

> > I prefer a mutex, but perhaps there are other ways to build the
> > fence (eg uverbs_dev->refcount springs to mind)
> 
> uverbs_dev->refcount is already there, we can choose to wait for
> ref_count to become zero

> wait for zero here instead of dec_and_test, I think things will
> automatically fall in place after that

More than that would be needed, the refcount is currently always being
held for the full life time of the ib_uverbs_device and the wait is
conditional. You'd have to restructure things so the wait becomes
unconditional and the refcount is conditionally held across the proper
times - eg only during close for the disassociate_ucontext mode.

Note sure this is prettier than a new mutex...

The fundamental thing is that the ib_uverbs_free_hw_resources thread
must wait for ib_uverbs_close's ib_uverbs_cleanup_ucontext to finish,
if necessary, not the other way around.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
