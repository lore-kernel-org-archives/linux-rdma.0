From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 13:36:01 -0400
Message-ID: <51C48F01.5030103@redhat.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com> <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com> <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com> <51C39ECB.3040006@redhat.com> <20130621063648.GA27963@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621063648.GA27963-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/21/2013 02:36 AM, Jason Gunthorpe wrote:
> On Thu, Jun 20, 2013 at 08:31:07PM -0400, Doug Ledford wrote:
> 
>>> The new transports have new requirements, and the apps have new
>>> required behaviors - the API simply can't hide all this in every
>>> case. The changes before had nothing to do with MTU, FWIW.
>>
>> It demonstrates what I would call a leakage between layer 2 and higher
>> layer APIs though.
> 
> What do you mean? Verbs is intended to expose transport specific
> behaviors at a very bare-metal level. The fact there are wide
> variations between the transports doesn't reflect a fault in verbs.

When verbs only had to worry about IB, this made sense.  When we added
iWARP, IBoE, and now usNIC, it no longer does.  Verbs *needs* to be
transport agnostic.  Then a person should do non-agnostic things using
extension libraries or raw packet mode, similar to how transport
non-agnostic things are done for the sockets API.

> If you want a transport-agnostic API then there are projects that do
> that: sockets, MPI, portals, CCI, etc, etc.
> 
> But look at some of the new extensions people are proposing, they tend
> to be very transport specific, narrowly focused on certain performance
> niches and not really abstractable through general APIs.
> 
> Frankly, that is why they are getting shoved into verbs, not run over
> sockets :)

I wouldn't care about verbs being transport agnostic if we already had a
reasonable transport agnostic API for RDMA usage that allowed all of the
base verbs to be used.  I don't see that from the examples you list above.

>>> The issue is not sorting out the install of the core libraries via
>>> package management tricks, but what happens when an app/middleware
>>> outside the package management dynamically links to this mess.
>>
>> If a user chooses not to use packaging, that's their prerogative.
>> However, they can also collect the pieces when things break.  If a ISV
>> chooses to do the same, then that ISV is just being flat lazy and
>> sloppy.  The package management stacks are there for a reason and serve
>> a valuable purpose.  Ignoring them is akin to just thumbing your nose at
>> the libibverbs version as well.
> 
> The packaging tool still doesn't solve the problem I outlined. A
> correctly packaged app, built for verbs v1.0 will still be installable
> on a system with verbs v1.1, and the same inter-library problems I
> described with symbol versioning in verbs will still show up.

Not if you also version the other libraries (and I admit you are getting
into a lot of work here, but what I'm referring to is when you rev
ibv_get_device_list for the new ibv_device_attr struct, you also rev
rdma_get_device_list in the same way, keeping a back compat entry in
rdmacm as well).

> You can avoid some nasty cases in the core libraries themselves with
> packaging, but it doesn't solve the general problem.
> 
> .. and ISVs don't seem to like packaging for some insane reason.
> 
>>> It explodes. The fundamental problem with the v1.0/v1.1 switch is the
>>> v1.0 functions are returning pointers that cannot be passed into a
>>> v1.1 function, eg iv_close_device@1.1(ibv_open_device@1.0(..))
>>> crashes.
>>
>> This isn't a problem if library A doesn't call into library B and try to
>> use the same struct as the app itself when the app calls into library B.
> 
> K, but they do, there are good reasons why they do, and saying "don't
> do that" is really not helpful.

Except in the context of, as Sean picked up on, my suggestion that
reworking the API split a bit and bringing these highly related items
under one umbrella.  You wouldn't expect to link against glibc for
read/write/socket, and against a different library for listen/accept,
yet that's what we do in rdma land.  We have an artificial split that
doesn't make sense and it causes these problems.

>> I would argue that this is because the libraries are so disjoint (that
>> librdmacm needs the deep internal knowledge it needs of libibverbs
> 
> No, it isn't deep internal knowledge. It uses the exposed, defined,
> public verbs ABI, adds some helper functions and then re-exports verbs
> objects to it's own users with minimal overhead. The re-exporting is
> what burns symbol versions so badly.
> 
> And rdma cm isn't the only one, but it is the easiest to talk
> about.
> 
> IMHO, the #1 fundamental issue is that all the low speed APIs use
> exposed structures, often caller-stack-allocated and that very badly
> limits our ability to elegantly adjust the API without breaking the ABI.
> 
>> back end to work IP v. GUID connection setup).  So, I think there is
>> significant room to improve the layout of the overall RDMA APIs and
>> doing that would address this particular issue and is probably the right
>> way to go.
> 
> I won't argue with you there...
> 
>> However, aside from that, my current objection to all of this is that
>> this solution, while meeting the needs of the "we don't want to have to
>> change anything unless the app wants to run on this new fabric" results
>> in what I would call a gross hack (some enum, some int, same variable).
>>  I'm not so much complaining about Jeff's solution, more the requirement
>> that we come up with such an ugly construct.  We are headed down a
>> course of putting in gross hacks in order to preserve an outdated
>> design, one which has much more elegant solutions today than what we are
>> currently using.  At *some* point, this becomes a miserable,
>> unmaintainable mess.
> 
> At some point? We are already there! Have you looked at the extension
> mechanism? It is horrible, and not what any sane person
> would want to do. It exists soley to satisfy the ISVs that don't want
> to see verbs rev'd.
> 
> And they have a point. There are lot of things built on verbs, a rev
> to the soname would create a terrible mess. An incompatible rev to the
> API would be even worse.

I disagree.  For end users, that *vast* majority would never have to see
the API change.  The MPI stacks and a few ISV stacks would need updated,
they would change their internal implementations but not necessarily
anything externally visible (for instance, OpenMPI would not need to
change the MPI interface to update to a newer verbs provider, and MPI
programs linked against OpenMPI would not need to be changed at all),
and I'm guessing that 99% of all applications by CPU hours consumed
would end up magically updated to the latest version.  Or am I wrong
that by far and away the two largest uses of RDMA in general are A) MPI
stacks and B) messaging stacks in financial sectors...both of which I
know for a fact hide the actual RDMA API from the end user's code?

>> So I hear you that people object to breaking the API for a new library
>> version.  My objection (which I'm sure I'll be overruled on) is that
>> people are taking the easy way out instead of fixing things up the right
>> way.
> 
> So what is the 'right way' here? I'm not hearing any problem free
> solution.

Who ever said that the right solution is either A) problem free or B)
always easy?  If you're looking for a for-free solution, don't bother
asking me.  As I outlined above, it seems to me that you can catch 99%
of the target audience with a limited set of targeted provider stack
updates.  This is totally doable, although not necessarily easy.  The
remaining code will have to be done by the end users.  If people think
that's too much work to fix the mess things are in currently, my
response would be "Suck it up, cupcake!  It needs done."  You could even
leave the current libibverbs/librdmacm/libibcm combo in place and allow
non-updated programs to continue working, while providing a new librdma
that handles all three jobs, but in a transport agnostic way.  Then you
could add transport specific extensions to librdma to get those extra
features you want.  That way, if people who haven't updated want new
features, then they can take the time to do the forward port to the new
library, and if not they can continue to use the deprecated but still
present older libraries.  So I guess I'm failing to really see the issue
that people keep making this out to be...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
