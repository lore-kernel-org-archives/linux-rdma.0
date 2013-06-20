From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Thu, 20 Jun 2013 16:31:14 -0400
Message-ID: <51C36692.7000507@redhat.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com> <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130620165305.GA19800-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/20/2013 12:53 PM, Jason Gunthorpe wrote:
> On Thu, Jun 20, 2013 at 12:34:04PM -0400, Doug Ledford wrote:
>> On 06/20/2013 10:21 AM, Jeff Squyres wrote:
>>> Keep IBV_MTU_* enums values as they are, but pass MTU values around as
>>> int's.  This is an ABI-compatible change; legacy applications will use
>>> the enum values,
>>
>> I'm not really concerned with what the legacy apps use so much as what
>> they are presented with.  In other words, I'm sure they won't request
>> anything other than an MTU represented by one of the enum values.  The
>> problem though, is what if they are run on a link with a non-IB MTU and
>> they are presented with it?  Let's look at one of the ports you did in
>> this patch as an example:
> 
> Remember, apps will only see a wonky value if they are being used on
> one of Jeff's new not-IB, not-ROCE, not-iWARP transports.

So?  That's just today.  The only reason RoCE/IBoE maps to IB MTUs is
that they didn't bother to make this ABI break for it, but it could
benefit from having a more flexible MTU that followed the underlying
Ethernet MTU.  So who's to say that isn't next?

> Who knows if
> they will even work on this new transport unmodified anyhow??

Either we should be trying to keep back compatibility or we shouldn't.
If we are, then it should work.  If we aren't, then there is no sense
doing the magic hocus-pocus tricks with the MTU where in some cases it
is the old enum value and other cases the real MTU value.

> An app update to suport future transports is not unreasonable,

I disagree.

> it
> happened for iwarp, rocee, etc.

If it happened once, then I would agree with you above.  That it *keeps*
happening is the issue.  To me, that's a clear indication that instead
of fixing the shortcomings of the current API properly, band-aids just
keep getting applied.

>>> diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
>>> index 21c551d..5a0656f 100644
>>> +++ b/examples/ud_pingpong.c
>>> @@ -332,7 +332,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
>>>  			fprintf(stderr, "Unable to query port info for port %d\n", port);
>>>  			goto clean_device;
>>>  		}
>>> -		mtu = 1 << (port_info.active_mtu + 7);
> 
> .. and this is sketchy anyhow, the above maths are not defined to work
> anywhere, it just happens to work with the constants that have been
> defined so far. This would break equally if we added any new constant
> to the enum. So no, these maths are not important.

No, but I also skipped a number of patches where code did switch
statements to convert from enum to byte value, or enum to string
representation.  All of those would break too.

>> One possible solution to this problem is to use ld.linux's symbolic
>> symbol versions to solve this problem for us.  Fortunately, Roland has
>> been excellent in the past about keeping all of libibverbs symbols
>> versioned.  That can save us here.
> 
> There is a huge resistance to reving the symbol versions in
> ibverbs. See the whole extension mess.

I thought the resistance was to revving the libibverbs soname, not just
the internal symbol versions.

> Further, the symbol versions don't work well in verbs, the internal
> structures are too exposed. The existing support is already broken and
> only works in very limited cases.
> 
> What you propose breaks in fairly common use cases, eg if
> librdmacm/etc and the app link to different ibverbs versions then
> things go wrong.

At the time the app is compiled, it will be compiled against a librdmacm
that needs a specific version of the libibverbs symbols because
librdmacm has already been compiled.  That means that if you want things
to "just work" for the end user, when you rev the internal libibverbs
symbols, then you make a corresponding change in librdmacm and when you
install libibverbs-devel, you make it have a Conflict: with librdmacm <
new-version.  Likewise, you make librdmacm have a BuildRequires:
libibverbs-devel >= new-version, and make librdmacm-devel have a
Requires: libibverbs-devel >= new-version.  In this way, librdmacm-devel
will automatically require that the installed libibverbs-devel be of the
right version or it won't install itself.  Likewise, updating
libibverbs-devel without also updating librdmacm-devel will cause the
entire transaction to get kicked out or, depending on options, cause
librdmacm to be removed from the system to be updated later.

Now, these are package install time checks that can be implemented in
either rpm or, I assume, apt.  If you want compile time checks, that
could be done too with header file magic.

So, this isn't broken, it's just that no one is taking the time to
properly identify incompatible versions and force compatible versions to
be installed before things are allowed to link up.

> rdmacm and the app pass pointers to verbs structures
> across their boundary but they are unware they are versioned
> differently, and will pass them back to the wrong verbs entry
> point. This has already been seen to fail with the existing symbol
> version support.
> 
> Basically: the verbs ABI was not designed to work with symbol
> versions.

The verbs ABI is perfectly fine working with versioned symbols.  The
package management of interrelated libraries has not been managed
sufficiently to provide even a modicum of assurance that things will
work properly.  This isn't for lack of tools, it's most likely simply
for lack of knowledge of how to, and desire to, deal with sorting the
issues out.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
