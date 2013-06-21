From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 16:57:09 -0400
Message-ID: <51C4BE25.9000501@redhat.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com> <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com> <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com> <51C39ECB.3040006@redhat.com> <20130621063648.GA27963@obsidianresearch.com> <51C48F01.5030103@redhat.com> <20130621182617.GA17700@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621182617.GA17700-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/21/2013 02:26 PM, Jason Gunthorpe wrote:
> On Fri, Jun 21, 2013 at 01:36:01PM -0400, Doug Ledford wrote:
> 
>>>>> The new transports have new requirements, and the apps have new
>>>>> required behaviors - the API simply can't hide all this in every
>>>>> case. The changes before had nothing to do with MTU, FWIW.
>>>>
>>>> It demonstrates what I would call a leakage between layer 2 and higher
>>>> layer APIs though.
>>>
>>> What do you mean? Verbs is intended to expose transport specific
>>> behaviors at a very bare-metal level. The fact there are wide
>>> variations between the transports doesn't reflect a fault in verbs.
>>
>> When verbs only had to worry about IB, this made sense.  When we added
>> iWARP, IBoE, and now usNIC, it no longer does.  Verbs *needs* to be
>> transport agnostic.  Then a person should do non-agnostic things using
>> extension libraries or raw packet mode, similar to how transport
>> non-agnostic things are done for the sockets API.
> 
> I disagree, *verbs* needs to expose the HW capabilities, efficiently.

What we need is an efficient RDMA API (of which verbs is a candidate for
the underlying implementation).  It need not expose HW capabilities in
its base form.

> .. and what is this about 'extension libraries'!? rdmacm *IS* an
> extension library and here we are talking about the problems that
> causes.

It should not be.  There is no such thing as RDMA communications without
connection establishment.  It isn't really an extension, it's part of
the core.

> You want more extension libraries?

Architecturally different than the libibverbs/librdmacm mess, but yes
(think extensions that the core library offers to the user space app,
not that the user space app links against and must be kept in sync with
the core library).

> .. and raw packet mode is entirely a non-starter for controller HW
> assisted offload features.
> 
> Like I said before, these things are getting pushed into verbs because
> they don't fit in the sockets model. You really can't use sockets as a
> template for solving problems that sockets have already failed to solve
> :P

I'm not using sockets as a model.  I couldn't care less about them.  I
want a generic RDMA model and sockets does not work well for that (not
at all really, unless you just want to neuter RDMA capabilities).

>> I wouldn't care about verbs being transport agnostic if we already
>> had a reasonable transport agnostic API for RDMA usage that allowed
>> all of the base verbs to be used.  I don't see that from the
>> examples you list above.
> 
> There is some stuff in the latest rdma-cm library that is getting
> close to this, but you are broadly right. It is a hard problem,
> especially when new transports don't support many of the verbs.

However, given a minimal set of functioning verbs, some of the other
verbs can be emulated.

>> Except in the context of, as Sean picked up on, my suggestion that
>> reworking the API split a bit and bringing these highly related items
>> under one umbrella.  
> 
> I agree that combining the core libraries would simplify the
> maintenance, but it you are still talking about adding symbol versions
> to a big wack of APIs, and that still leaves non-core helper libraries
> out in the cold.

Depends on how you layer things as I mentioned above.

> Again, the problems are not caused by the split up libraries.

No, it partially is exactly caused by this.

> The
> problems are inherent to how the verbs API works.

Nothing is inherent to the API, only it's current implementation.

> Joining the
> libraries reduces the 'impact surface' but doesn't fundamentally solve
> the problem. Perhaps that is pragmatically '99%' good enough, as you
> say..
> 
> Admittedly, this seems to be how other projects use symbol versions,
> and I don't hear alot of screaming from other camps, but on the other
> hand, verbs has a larger than normal binary-only ISV user base..
> 
> .. and symbol versions do work well if an entirely contained ISV build
> tries to link to a set of self-consistent system libraries.
> 
>> You wouldn't expect to link against glibc for read/write/socket, and
>> against a different library for listen/accept, yet that's what we do
>> in rdma land.  We have an artificial split that doesn't make sense
>> and it causes these problems.
> 
> Have you used SCTP? Some calls are part of glibc, some are part of
> libsctp.. For instance listen is in glibc, and sctp_send is in
> libsctp. It isn't entirely unprecedented.

Not-unprecedented still doesn't mean "good idea" ;-)

>>>> So I hear you that people object to breaking the API for a new library
>>>> version.  My objection (which I'm sure I'll be overruled on) is that
>>>> people are taking the easy way out instead of fixing things up the right
>>>> way.
>>>
>>> So what is the 'right way' here? I'm not hearing any problem free
>>> solution.
>>
>> Who ever said that the right solution is either A) problem free or B)
>> always easy?  If you're looking for a for-free solution, don't bother
>> asking me.  As I outlined above, it seems to me that you can catch 99%
>> of the target audience with a limited set of targeted provider stack
>> updates.  This is totally doable, although not necessarily easy.  The
>> remaining code will have to be done by the end users.  If people think
>> that's too much work to fix the mess things are in currently, my
>> response would be "Suck it up, cupcake!  It needs done."  You could
>> even
> 
> K.. So, nobody seems to be paid to work on these verbs libraries, what
> you are talking about is a tonne of typing - who is going to do
> this?

<raises hand>  I'm ready for a new project.  I already had one in mind,
but it required some changes to libibverbs that are pretty deep changes.
 Instead of doing that deep work in libibverbs, I can start here and
move on to my next project when this is up and running.

Realistically I'm talking about starting off by cannibalizing
libibverbs, librdmacm, and libibcm into a single library.  That's a lot
of cut and paste work, with ensuing fixups.  After the initial bring
together, then we can start re-architecting and moving forward.

Since that cut and paste work will take a while, that also gives some
time for us to discuss what things might look like before starting that
"tonne of typing" as you called it ;-)

> I already tried pretty hard to convince some ISVs that it was OK to
> rev the SONAME and the extensions could be handled with new symbols,
> and I didn't get too far. :(

If they wish to keep getting their infrastructure for free, then they
kinda get what they get.  I mean, you don't want to just change things
and piss them off for no good reason, but when good reason exists, they
can suck it up and deal with it.  No one in the open source community is
obligated to preserve an outdated API forever just to make them happy.
The other alternative is that they can pick up long term maintenance of
libibverbs, librdmacm, and libibcm themselves (in fairness I can't say
that...Roland may think it is a horrible idea to put connection
management into the base verbs library and just want to keep on going
the way things are going, ditto to Sean, I obviously can't speak for
other people...but if we write a new library and the other maintainers
of the older libraries think the new one is the right path forward and
decide to quite updating the old ones, then you end up in this
situation).  They wouldn't be left with no choice, just with no choice
that includes someone providing them with ongoing feature enhancements
to an increasingly inappropriate and unmaintainable mess of an API for free.

> In the mean time, what about Jeff's problem?

We did get way off the point ;-)

As I mentioned, this patch is just another in a line of kludges.  That
doesn't make it wrong, it makes it ugly.  I'm for breaking the cycle.
But even if we do go ahead and break the cycle, that will take more time
than I imagine Jeff is willing to wait.  So in the meantime, I guess we
just gotta do what we just gotta do...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
