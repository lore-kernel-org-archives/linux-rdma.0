From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 12:26:17 -0600
Message-ID: <20130621182617.GA17700@obsidianresearch.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com>
 <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com>
 <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com>
 <20130621063648.GA27963@obsidianresearch.com>
 <51C48F01.5030103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C48F01.5030103-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 21, 2013 at 01:36:01PM -0400, Doug Ledford wrote:

> >>> The new transports have new requirements, and the apps have new
> >>> required behaviors - the API simply can't hide all this in every
> >>> case. The changes before had nothing to do with MTU, FWIW.
> >>
> >> It demonstrates what I would call a leakage between layer 2 and higher
> >> layer APIs though.
> > 
> > What do you mean? Verbs is intended to expose transport specific
> > behaviors at a very bare-metal level. The fact there are wide
> > variations between the transports doesn't reflect a fault in verbs.
> 
> When verbs only had to worry about IB, this made sense.  When we added
> iWARP, IBoE, and now usNIC, it no longer does.  Verbs *needs* to be
> transport agnostic.  Then a person should do non-agnostic things using
> extension libraries or raw packet mode, similar to how transport
> non-agnostic things are done for the sockets API.

I disagree, *verbs* needs to expose the HW capabilities, efficiently.

.. and what is this about 'extension libraries'!? rdmacm *IS* an
extension library and here we are talking about the problems that
causes. You want more extension libraries?

.. and raw packet mode is entirely a non-starter for controller HW
assisted offload features.

Like I said before, these things are getting pushed into verbs because
they don't fit in the sockets model. You really can't use sockets as a
template for solving problems that sockets have already failed to solve
:P

> I wouldn't care about verbs being transport agnostic if we already
> had a reasonable transport agnostic API for RDMA usage that allowed
> all of the base verbs to be used.  I don't see that from the
> examples you list above.

There is some stuff in the latest rdma-cm library that is getting
close to this, but you are broadly right. It is a hard problem,
especially when new transports don't support many of the verbs.

> > The packaging tool still doesn't solve the problem I outlined. A
> > correctly packaged app, built for verbs v1.0 will still be installable
> > on a system with verbs v1.1, and the same inter-library problems I
> > described with symbol versioning in verbs will still show up.
> 
> Not if you also version the other libraries (and I admit you are getting
> into a lot of work here, but what I'm referring to is when you rev
> ibv_get_device_list for the new ibv_device_attr struct, you also rev
> rdma_get_device_list in the same way, keeping a back compat entry in
> rdmacm as well).

Yes, that is right, plus actually making compat calls across the two
library boundaries and other complexity. It is certainly a big job.

> >> This isn't a problem if library A doesn't call into library B and try to
> >> use the same struct as the app itself when the app calls into library B.
> > 
> > K, but they do, there are good reasons why they do, and saying "don't
> > do that" is really not helpful.
> 
> Except in the context of, as Sean picked up on, my suggestion that
> reworking the API split a bit and bringing these highly related items
> under one umbrella.  

I agree that combining the core libraries would simplify the
maintenance, but it you are still talking about adding symbol versions
to a big wack of APIs, and that still leaves non-core helper libraries
out in the cold.

Again, the problems are not caused by the split up libraries. The
problems are inherent to how the verbs API works. Joining the
libraries reduces the 'impact surface' but doesn't fundamentally solve
the problem. Perhaps that is pragmatically '99%' good enough, as you
say..

Admittedly, this seems to be how other projects use symbol versions,
and I don't hear alot of screaming from other camps, but on the other
hand, verbs has a larger than normal binary-only ISV user base..

.. and symbol versions do work well if an entirely contained ISV build
tries to link to a set of self-consistent system libraries.

> You wouldn't expect to link against glibc for read/write/socket, and
> against a different library for listen/accept, yet that's what we do
> in rdma land.  We have an artificial split that doesn't make sense
> and it causes these problems.

Have you used SCTP? Some calls are part of glibc, some are part of
libsctp.. For instance listen is in glibc, and sctp_send is in
libsctp. It isn't entirely unprecedented.

> >> So I hear you that people object to breaking the API for a new library
> >> version.  My objection (which I'm sure I'll be overruled on) is that
> >> people are taking the easy way out instead of fixing things up the right
> >> way.
> > 
> > So what is the 'right way' here? I'm not hearing any problem free
> > solution.
> 
> Who ever said that the right solution is either A) problem free or B)
> always easy?  If you're looking for a for-free solution, don't bother
> asking me.  As I outlined above, it seems to me that you can catch 99%
> of the target audience with a limited set of targeted provider stack
> updates.  This is totally doable, although not necessarily easy.  The
> remaining code will have to be done by the end users.  If people think
> that's too much work to fix the mess things are in currently, my
> response would be "Suck it up, cupcake!  It needs done."  You could
> even

K.. So, nobody seems to be paid to work on these verbs libraries, what
you are talking about is a tonne of typing - who is going to do
this?

I already tried pretty hard to convince some ISVs that it was OK to
rev the SONAME and the extensions could be handled with new symbols,
and I didn't get too far. :(

In the mean time, what about Jeff's problem?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
