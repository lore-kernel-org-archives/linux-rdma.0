From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Mon, 28 Mar 2016 12:42:01 +0300
Message-ID: <CAJ3xEMh9k=eH1o3_Xmc0b47QLnmwWqVFiwpZERVKSXd0k9CaLA@mail.gmail.com>
References: <56F1B00F.7010406@redhat.com>
	<CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A@mail.gmail.com>
	<56F1F579.3080403@redhat.com>
	<CAJ3xEMhu7pKONneEAMDhJUtiz2nqnibynHMWe8vmgPCy+7DH5A@mail.gmail.com>
	<56F4068F.2070608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F4068F.2070608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 24, 2016 at 6:23 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/23/2016 06:37 PM, Or Gerlitz wrote:
>> On Wed, Mar 23, 2016 at 3:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>>> You made your arguments, which I thought were nebulous in the first
>>> place ("does not belong in the kernel" is not a well defined objection,
>>> it's like saying "I don't like that", you would need a more concise
>>> objection to carry stronger weight).

>> Doug, by all means my review was not in a "you should do X, period" or
>> "Y doesn't belong to the kernel, bump", take 5m and see:

> I read it all the first time Or.  I don't need to read it again.

You wrote that I was just pushing things back w.o any argumentation
why I find them wrong, which is simply not the case. You also did very
(very) little commenting (if any) on this thread (and many others
too). This brought me to a point where I couldn't see how you read the
reviewer comments and made this response, so I had to paste things.

>>> Their response to your argument
>>> was that putting it in the kernel saves multiple context switches per
>>> memory region in the cache.  This was a sufficient answer IMO (context
>>> switches are expensive and on 100GBit hardware, multiple context
>>> switches that aren't needed is positively huge).

>> So it tool quiet a lot of time and effort to have Denny make these
>> statements which are still not backed up by any published performance
>> data.

> Yes, so?  Do we have to have published performance numbers for every
> patch?  Especially ones that intuitively sound correct?  Because I don't
> see people putting those requirements on Mellanox, so I'm curious why
> you think that level of burden should be placed on Intel?

Someone suggests a kernel patch for something the reviewer pointed him
that can be put in user-space, and justifies pushing the code into the
kernel as of performance reasons. What's wrong for the reviewer to ask
for performance data? It's not a burden, it's a 100% legitimate
request as part of professional review session.

>> Any reason we can't hear you speaking in real time over a reviewing
>> thread, and have a fair chance to convince you that things are
>> actually the other way around vs. your position, but rather get your
>> opinion in the form of blank pulling of patches?

> You've already made your arguments.  I listened, I evaluated, I made my
> decision, I moved forward.  I had (and still have) too much work to do
> this merge cycle to belabor things just because you want to prevent
> Intel from architecting their driver they way they want.  I would be

Yes, we keep hearing you claiming that you don't have time. But this
is part of what we want to see from maintainer. You don't have to act
as the major reviewer if you don't want to, but if there is a review
that goes on, respect it and when the time comes, say your opinion or
even enforce it (but say you did it).

> more inclined to listen if this wasn't private to their driver, but it
> is, and you are trying to push in on their design with your own
> requirements that bear no relation to the core IB code or your company's
> drivers, and your requirement is one that Intel has already stated will
> have a negative impact on their performance.

The fact that the cache is private to their driver should make you
more worrying, not the other way around. The driver maintainer (the
author of the patches refuses to respond, are you okay with that BTW?)
claimed that this would have negative performance impact, but I
challenged his claims and asked for performance data, I know no other
way to do professional engineering.

As I wrote over the thread, AFAIK, two lead developers that were
involved in the past with this community (Roland D. and Pyte W.) were
working on user-space cache with small kernel part that only deals
with propagating MMU notifications to user-space, I don't think they
did it 10y ago just to stop hfi1 novel developments in 2016, do you
think so?

> Intel has worked their ass off in the name of your review requests so
> far.  The entire rdmavt code base was at your request.
[...]

And where are you Doug, re this code repetition in three drivers @ row?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
