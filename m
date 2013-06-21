From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 00:36:48 -0600
Message-ID: <20130621063648.GA27963@obsidianresearch.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com>
 <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com>
 <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C39ECB.3040006-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2013 at 08:31:07PM -0400, Doug Ledford wrote:

> > The new transports have new requirements, and the apps have new
> > required behaviors - the API simply can't hide all this in every
> > case. The changes before had nothing to do with MTU, FWIW.
> 
> It demonstrates what I would call a leakage between layer 2 and higher
> layer APIs though.

What do you mean? Verbs is intended to expose transport specific
behaviors at a very bare-metal level. The fact there are wide
variations between the transports doesn't reflect a fault in verbs.

If you want a transport-agnostic API then there are projects that do
that: sockets, MPI, portals, CCI, etc, etc.

But look at some of the new extensions people are proposing, they tend
to be very transport specific, narrowly focused on certain performance
niches and not really abstractable through general APIs.

Frankly, that is why they are getting shoved into verbs, not run over
sockets :)

> > The issue is not sorting out the install of the core libraries via
> > package management tricks, but what happens when an app/middleware
> > outside the package management dynamically links to this mess.
> 
> If a user chooses not to use packaging, that's their prerogative.
> However, they can also collect the pieces when things break.  If a ISV
> chooses to do the same, then that ISV is just being flat lazy and
> sloppy.  The package management stacks are there for a reason and serve
> a valuable purpose.  Ignoring them is akin to just thumbing your nose at
> the libibverbs version as well.

The packaging tool still doesn't solve the problem I outlined. A
correctly packaged app, built for verbs v1.0 will still be installable
on a system with verbs v1.1, and the same inter-library problems I
described with symbol versioning in verbs will still show up.

You can avoid some nasty cases in the core libraries themselves with
packaging, but it doesn't solve the general problem.

.. and ISVs don't seem to like packaging for some insane reason.

> > It explodes. The fundamental problem with the v1.0/v1.1 switch is the
> > v1.0 functions are returning pointers that cannot be passed into a
> > v1.1 function, eg iv_close_device@1.1(ibv_open_device@1.0(..))
> > crashes.
> 
> This isn't a problem if library A doesn't call into library B and try to
> use the same struct as the app itself when the app calls into library B.

K, but they do, there are good reasons why they do, and saying "don't
do that" is really not helpful.

> I would argue that this is because the libraries are so disjoint (that
> librdmacm needs the deep internal knowledge it needs of libibverbs

No, it isn't deep internal knowledge. It uses the exposed, defined,
public verbs ABI, adds some helper functions and then re-exports verbs
objects to it's own users with minimal overhead. The re-exporting is
what burns symbol versions so badly.

And rdma cm isn't the only one, but it is the easiest to talk
about.

IMHO, the #1 fundamental issue is that all the low speed APIs use
exposed structures, often caller-stack-allocated and that very badly
limits our ability to elegantly adjust the API without breaking the ABI.

> back end to work IP v. GUID connection setup).  So, I think there is
> significant room to improve the layout of the overall RDMA APIs and
> doing that would address this particular issue and is probably the right
> way to go.

I won't argue with you there...

> However, aside from that, my current objection to all of this is that
> this solution, while meeting the needs of the "we don't want to have to
> change anything unless the app wants to run on this new fabric" results
> in what I would call a gross hack (some enum, some int, same variable).
>  I'm not so much complaining about Jeff's solution, more the requirement
> that we come up with such an ugly construct.  We are headed down a
> course of putting in gross hacks in order to preserve an outdated
> design, one which has much more elegant solutions today than what we are
> currently using.  At *some* point, this becomes a miserable,
> unmaintainable mess.

At some point? We are already there! Have you looked at the extension
mechanism? It is horrible, and not what any sane person
would want to do. It exists soley to satisfy the ISVs that don't want
to see verbs rev'd.

And they have a point. There are lot of things built on verbs, a rev
to the soname would create a terrible mess. An incompatible rev to the
API would be even worse.

> So I hear you that people object to breaking the API for a new library
> version.  My objection (which I'm sure I'll be overruled on) is that
> people are taking the easy way out instead of fixing things up the right
> way.

So what is the 'right way' here? I'm not hearing any problem free
solution.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
