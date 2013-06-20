From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Thu, 20 Jun 2013 15:14:54 -0600
Message-ID: <20130620211454.GA2434@obsidianresearch.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com>
 <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C36692.7000507-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2013 at 04:31:14PM -0400, Doug Ledford wrote:
> > happened for iwarp, rocee, etc.
> 
> If it happened once, then I would agree with you above.  That it *keeps*
> happening is the issue.  To me, that's a clear indication that instead
> of fixing the shortcomings of the current API properly, band-aids just
> keep getting applied.

The new transports have new requirements, and the apps have new
required behaviors - the API simply can't hide all this in every
case. The changes before had nothing to do with MTU, FWIW.

Jeff: Does your new transport support 100% of ibverbs and MTU is the
only change an app would need?

> > .. and this is sketchy anyhow, the above maths are not defined to work
> > anywhere, it just happens to work with the constants that have been
> > defined so far. This would break equally if we added any new constant
> > to the enum. So no, these maths are not important.
> 
> No, but I also skipped a number of patches where code did switch
> statements to convert from enum to byte value, or enum to string
> representation.  All of those would break too.

Yes, but often either doesn't matter (they are just print strings) or
there are default fall throughs.

UD apps are ones that are going to have a problem, but we already have
very poor transport agnostic support for UD, so it is unlikely an
existing UD app will run on a new transport.
 
> > There is a huge resistance to reving the symbol versions in
> > ibverbs. See the whole extension mess.
> 
> I thought the resistance was to revving the libibverbs soname, not just
> the internal symbol versions.

Nope, people want new apps (using extensions/etc) to run on old verbs
versions. I don't really like that, mind you, but it has been strongly
asked for.

> At the time the app is compiled, it will be compiled against a librdmacm
> that needs a specific version of the libibverbs symbols because
> librdmacm has already been compiled.  That means that if you want
> things to "just work" for the end user, when you rev the internal libibverbs
> symbols, then you make a corresponding change in librdmacm and when
> you

Both the app and librdmacm have a DT_NEEDED on libibverbs, and both
call into libibverbs.

The issue is not sorting out the install of the core libraries via
package management tricks, but what happens when an app/middleware
outside the package management dynamically links to this mess.

We've already seen this fail in the field with apps that link to the
v1.0 verbs ABI that call into other libraries that were linked to the
v1.1 API.

It explodes. The fundamental problem with the v1.0/v1.1 switch is the
v1.0 functions are returning pointers that cannot be passed into a
v1.1 function, eg iv_close_device@1.1(ibv_open_device@1.0(..))
crashes. 

Your idea to change the MTU causes the same problem with structure
versioning. If I use a rdmacm/etc API to get a MTU containing
structure then I still get the new meaning because rdmacm is linked to
the v1.2 verbs symbols, but my app is linked to the v1.1 symbols and
can't support it.

.. and of course rdmacm is just an example, there are other middleware
libraries (uDAPL, MPI, etc) that may be affected.

Symbol versioning *doesn't* solve the problem, it just creates a new
class of subtle failure modes. It appears to work in simple cases so
people think it is a silver bullet, but it is not. It is very complex,
the failures cases are screwy and subtle, and verbs tends to hit them
head on because of how exposed all the internal structures are.

> So, this isn't broken, it's just that no one is taking the time to
> properly identify incompatible versions and force compatible versions to
> be installed before things are allowed to link up.

You can't enforce things on binary-only proprietary apps being
installed from outside package management.

The verbs extension mechanism can safely deal with this kind of
change, it effectively adds structure versioning to the ABI, but it is
not mainlined yet and is also pretty complex.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
