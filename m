From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 14:37:11 -0600
Message-ID: <20160829203711.GC3201@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <765b7e2d-51e0-98aa-60d1-26be35eb7a3d@dev.mellanox.co.il>
 <20160829163453.GC23557@obsidianresearch.com>
 <aaf8d6ba-6dc2-51d9-b014-dcc10114079f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aaf8d6ba-6dc2-51d9-b014-dcc10114079f-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 29, 2016 at 11:03:45PM +0300, Yishai Hadas wrote:

> >Remember, most of the code is dead, the maintainer is MIA or hasn't
> >accepted a patch in months or years.
> 
> Agree, that's why I think that such dead providers code shouldn't be put and
> maintained with live providers, it doesn't make sense.
> How many providers/libraries in this GIT are really active ?

What? That is backwards. The best way to carry 'finished' code is in a
live and active repository, otherwise it just tends to bitrot into
failure.

Having it be an active part of day-to-day developer work flows is the
best way to keep 'finished' code compiling and working over the long
run.

This is how the kernel flow has worked for many years and it largely
is proven to be a success.

For instance, with rdma-plumbing it would have been trivial for Steve
to at least compile test his ARM64 enablement across all providers.

It was easy for me to fix the pthread mislinking across all providers.

It will also be easy to do 'build and run in place'.

Let alone things like Covarity, Travis CI and other tooling that is
cumbersome to access across 15 different source trees.

> >mlx4/mlx5 is an notable exeption. You and Doug should work out a
> >reasonable appraoch. Maybe he takes your pulls directly, maybe you
> >have co-commit access on Github (the team approach), something else?
> 
> We definitely need to close this point before going a head into any solution
> that might block a fast progress of accepting/merging new code of
> live/maintained projects as of libmlx4/5.

The obvious channel for something like your TSO example is the same as
the kernel, Doug takes the common code and the only implementation
(mlx5) together at the same time.

This is pretty much what we have been doing on the kernel side.

There is zero reason to delay the driver side once the verbs side is
OK.

I'm looking at the git commit activity on mlx4 and mlx5 and I honestly
don't see your concern, the commit rate is maybe 1 series every 3
months on mlx5 and even less on mlx4. Nothing here is so active that a
combination would be a significant negative, and by far the majority
of it is tied to verbs features anyhow.

> >>>This is already basically the case, you need to wait for Doug to take
> >>>any libibverbs changes before you can push any provider feature
> >>>change. 
> >>This is incorrect, when Doug is taking into libibverbs, vendor code that is
> >>ready can be taken immediately, the new approach might cause some extra
> >>delays and slowness.
> >
> >I haven't seen you do that.
> 
> What are you talking about ?

We are having troubles with English, apparently.

> Sure that we take *only* code that works with upstream libibverbs. Both
> libmlx4 and libmlx5 are *always* in a ready state for a release with latest
> libibverbs.

So nothing changes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
