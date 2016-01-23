From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 22 Jan 2016 21:42:42 -0800
Message-ID: <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A30910.9010002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 22, 2016 at 9:01 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> I obviously have my understanding of the development cycle here wrong.
> I had thought that the merge window was 4 weeks with a following 8 weeks
> of RC candidates resulting in roughly quarterly pace.  But you tagged
> v4.4 on 1/10/16, so this Sunday is only 2 weeks.  That certainly changes
> things.  I did not believe that the merge window was so short when I
> sent this request.

We've had this model now for ten years by now. Yes, it's really been that long.

Two weeks of merge window, followed by weekly release candidates until
it's "ready" (where the most common last one tends to be rc7, but that
has certainly fluctuated - we had 3.1 go to rc10 before release, and
we've had a few that only got to rc6).

This all is not new, and it's not undocumented. I have absolutely no
idea why you suddenly started multiplying all the times by two.

It's actually been very stable over the years. We've had exceptions
where travel schedules (or just holidays etc) have moved things around
by a week here and there, but on the whole it's actually not varied a
lot.

> But also, really?  Even ignoring that misconception,  it's the merge
> window.  And it has a deadline.

It's a *MERGE* window.

Not a *DEVELOPMENT* window.

See the difference?

This is not new either. The rule has been that things should basically
be ready by the time the merge window *opens*. Things should have been
in linux-next so that they get some testing, and so that people get a
heads-up not only about what is coming up, but how it interacts with
other things coming up.

And no, not everything ends up being in linux-next. But I think we've
been hitting almost 90% most recent releases, so that whole "things
should be in linux-next beforehand" is not just some theoretical goal,
it's something we actually hit in practice pretty well.

And yes, I do pull requests until the last minute (although I have
been known to hurry up the last minute and release -rc1 a day early
just because I don't want people to game my timing).

But generally at the last minute I want to feel that there was some
_reason_ for the last minute behavior.

And no, the reason is not "I am hurrying up to get everything done by
5pm on a Friday afternoon, and I didn't even get everything done, so
I'll send the rest on Monday".

Because that just makes me go "ok, this is clearly not ready".

[ And as to why the merge window is two weeks and not just "one single
day" if everything is supposed to be ready before-hand..

  That's actually a valid question, but it's at least partially about
_me_ (but also about flexibility for others, so that we don't have to
make the 90% be 100%).

  In particular, just the merging process itself would take me one
week. I can do about 20-30 merges a day for the first few days, and I
don't feel I could do more while still actually feeling like I had
some kind of overview of what I'm merging (the merge itself is often
quick, it's looking at it and doing a basic build test etc that takes
time).

  So one week would be the absolute minimum with the amount of
different trees I merge - and that assumes that every single tree is
ready and done at the beginning.

  In practice, things slow down after a few days as I catch up with
the queue of pull requests.  So in the end the average over the two
week period is about 10-15 merges per day for me.

  By the end of the two weeks, it really should have turned into a
slow trickle of merges of things that had dependencies or some other
valid reason to be late.. Or rather, I _wish_ it turned into a
trickle, but sadly the last Friday afternoon is seldom anything but
slow.

  So two weeks "works" - and has worked for the last ten years. It may
not be perfect, but I think it has worked exceptionally well in the
end - certainly better than people thought initially when we started
trying this whole no-longer-very-new-thing. ]

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
