From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Thu, 20 Jun 2013 20:31:07 -0400
Message-ID: <51C39ECB.3040006@redhat.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com> <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com> <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130620211454.GA2434-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/20/2013 05:14 PM, Jason Gunthorpe wrote:
> On Thu, Jun 20, 2013 at 04:31:14PM -0400, Doug Ledford wrote:
>>> happened for iwarp, rocee, etc.
>>
>> If it happened once, then I would agree with you above.  That it *keeps*
>> happening is the issue.  To me, that's a clear indication that instead
>> of fixing the shortcomings of the current API properly, band-aids just
>> keep getting applied.
> 
> The new transports have new requirements, and the apps have new
> required behaviors - the API simply can't hide all this in every
> case. The changes before had nothing to do with MTU, FWIW.

It demonstrates what I would call a leakage between layer 2 and higher
layer APIs though.

> Nope, people want new apps (using extensions/etc) to run on old verbs
> versions. I don't really like that, mind you, but it has been strongly
> asked for.

At some point people just need to suck it up and deal with a new
version.  Once you reach a certain level of maturity you can maintain
long term back compatibility and forward compatibility.  But that
requires that the API be sufficiently well thought out that each change
is more evolutionary than revolutionary.  The entire IB stack still
likes to do major, revolutionary changes.  It has not reached the level
of maturity where it can truly maintain a long term forward/back
compatibility IMO.  And the layer level leakage I mention earlier just
makes this more problematic.

> Both the app and librdmacm have a DT_NEEDED on libibverbs, and both
> call into libibverbs.
> 
> The issue is not sorting out the install of the core libraries via
> package management tricks, but what happens when an app/middleware
> outside the package management dynamically links to this mess.

If a user chooses not to use packaging, that's their prerogative.
However, they can also collect the pieces when things break.  If a ISV
chooses to do the same, then that ISV is just being flat lazy and
sloppy.  The package management stacks are there for a reason and serve
a valuable purpose.  Ignoring them is akin to just thumbing your nose at
the libibverbs version as well.

> We've already seen this fail in the field with apps that link to the
> v1.0 verbs ABI that call into other libraries that were linked to the
> v1.1 API.

So this exposes an issue, I agree.

> It explodes. The fundamental problem with the v1.0/v1.1 switch is the
> v1.0 functions are returning pointers that cannot be passed into a
> v1.1 function, eg iv_close_device@1.1(ibv_open_device@1.0(..))
> crashes. 

This isn't a problem if library A doesn't call into library B and try to
use the same struct as the app itself when the app calls into library B.

> Your idea to change the MTU causes the same problem with structure
> versioning. If I use a rdmacm/etc API to get a MTU containing
> structure then I still get the new meaning because rdmacm is linked to
> the v1.2 verbs symbols, but my app is linked to the v1.1 symbols and
> can't support it.
> 
> .. and of course rdmacm is just an example, there are other middleware
> libraries (uDAPL, MPI, etc) that may be affected.
> 
> Symbol versioning *doesn't* solve the problem, it just creates a new
> class of subtle failure modes. It appears to work in simple cases so
> people think it is a silver bullet, but it is not. It is very complex,
> the failures cases are screwy and subtle, and verbs tends to hit them
> head on because of how exposed all the internal structures are.

I would argue that this is because the libraries are so disjoint (that
librdmacm needs the deep internal knowledge it needs of libibverbs
indicates that maybe these two shouldn't be separate from each other for
example, or that maybe libibverbs should provide a unified connection
API to the user and internally use both librdmacm and libibcm on the
back end to work IP v. GUID connection setup).  So, I think there is
significant room to improve the layout of the overall RDMA APIs and
doing that would address this particular issue and is probably the right
way to go.

However, aside from that, my current objection to all of this is that
this solution, while meeting the needs of the "we don't want to have to
change anything unless the app wants to run on this new fabric" results
in what I would call a gross hack (some enum, some int, same variable).
 I'm not so much complaining about Jeff's solution, more the requirement
that we come up with such an ugly construct.  We are headed down a
course of putting in gross hacks in order to preserve an outdated
design, one which has much more elegant solutions today than what we are
currently using.  At *some* point, this becomes a miserable,
unmaintainable mess.

So I hear you that people object to breaking the API for a new library
version.  My objection (which I'm sure I'll be overruled on) is that
people are taking the easy way out instead of fixing things up the right
way.

>> So, this isn't broken, it's just that no one is taking the time to
>> properly identify incompatible versions and force compatible versions to
>> be installed before things are allowed to link up.
> 
> You can't enforce things on binary-only proprietary apps being
> installed from outside package management.

Correcting the API resolves this, and you can possibly play games in
header files to catch issues at compile time.  But if people ignore
package management, then they get to keep their own pieces as far as I'm
concerned.

> The verbs extension mechanism can safely deal with this kind of
> change, it effectively adds structure versioning to the ABI, but it is
> not mainlined yet and is also pretty complex.

That would address structures, but I think the API itself could use some
love and care, and that wouldn't be addressed by just the verbs
extension mechanism (and in fact if you rethink some of the exposed API,
it might drastically change how you might want to handle
extensions...who knows).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
