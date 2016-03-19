From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 19 Mar 2016 14:37:08 -0700
Message-ID: <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ@mail.gmail.com>
References: <56EAE9D6.2030908@redhat.com>
	<CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
	<20160318173748.GL25216@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160318173748.GL25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 18, 2016 at 10:37 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Fri, Mar 18, 2016 at 09:52:16AM -0700, Linus Torvalds wrote:
>>
>> It would be much better to have the shared pre-requisite not as a
>> _patch_, but as a separate branch. So that you actually share the
>> commits, not just the diff.
>>
>> Other subsystems have been able to do that.
>
> I'm not sure that my understanding is correct and will be glad
> if you can point us to the examples of such branches, so we will
> use it as soon as possible.

Ok, let me try to explain with a very rough example what I'm looking for.

What Mellanox has been doing is to have two different teams that touch
their "own" areas (networking vs rdma), but with a lot of overlap in
the same files.

So, for example, you might have twenty patches from one group, and
thirty from another, and most of them are pretty independent, but some
of them really touch not just the same file, but the same function -
either right next to each other or even the same lines.

Then the two groups send their code to two different maintainers, and
the end result is that the upper level maintainers need to sort out
the fact that two independent groups touched the same things.

That won't fly any more. I have a very simple solution for it if it
ever happens again: I'll just stop pulling anything from the rdma tree
that has any Mellanox patches in it. Why rdma? It's simply much less
important than the networking tree. It's not personal, that's just how
it is.

So that's what used to happen, and it's not an option any more.

What you are suggesting you do going forward is to have the two trees
at least talk to each other, and instead of having 20/30 separate
patches, maybe you'll have 15+5+25 patches, where the five patches in
the middle are stuff that both groups need and use as a base, and you
still send twenty patches (15+5) to one maintainer and thirty (25+5)
to another, but you guarantee that those five patches are exactly the
same.

So that definitely *improves* on things. It improves on things in
three very real ways:

 - we won't see the really *crazy* case, which is that you implemented
the exact same thing in two different ways, and now it's not just the
code that clashes, it's actually core functionality.

 - yes, there may still be 50 commits total, but now ten of those
fifty will be identical patches, which can make it more likely that
things merge cleanly.

 - when things clash, at least when I look at the conflicts, I can see
"ok, both branches did _this_ part the same, so I can ignore those two
commits that are the same from both sides".

So that's three real improvements, but note how actual conflicts are
still going to happen - they just might be easier to resolve (because
no core semantic clashes, and because the top-level maintainers can
see the "same thing" parts more easily).

The reason they will still happen is that when you send the same patch
to two different maintainers, and one of the maintainers then updates
his file in other ways *afterwards*, what git will see is that both
sides changed the same code *differently*. One did A+B, and one did
just A', and it will all conflict anyway. So it's better, but it's not
great.

So the *best* situation would be:

 - your two groups talk it over, and figure out what the common commits are

 - you put those common commits as a "base" branch in git

 - you ask the two upper-level maintainers to both pull that base branch

 - you then make sure that you send the later patches (whether as
emailed patches or as pull requests) based on top of that base branch.

In the above scenario, you actually don't have any duplicate commits,
so now there is only 45 commits total. But the big improvement is not
in "fewer commits", it's in what happens when you have that situation
of "A+B" vs "just A". Because "A" is now a single shared commit, git
really sees that as shared state, and the fact that one side then did
B on top of that really doesn't matter, and doesn't cause conflicts.

Of course, if one side does "A+B", and another does "A+C", and B and C
conflict, then you'll still see conflicts, but if that happens, you
guys screwed up on the whole "what is our common base" question. But
the conflict will still be smaller than it would have been with two
different copies of A.

NOTE! There is one downside to this model, and that's is that you guys
really have to be more careful about that shared base branch. Because
it's a shared branch that both upstream maintainers will pull from,
that branch really has to be very high quality, and it cannot be
rebased etc after you've asked upstream to pull, because that would
negate the whole point.

And it has to be higher quality, because now you really need to
convince *two* maintainers to take it, and they both need to feel
comfortable doing a "git pull" from you. So you'd need to make sure
that branch really looks good, and that it's based on a good base that
work for both your upstream maintainers. But if you can do that,
everybody will be happier.

So it requires a bit more care, and a bit more control. You need to be
very confident about those shared commits that both the networking and
rdma people take. But quite frankly, after the mess that has been
Mellanox, that kind of care and effort just sounds like a good idea.

I hope that clarified.

              Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
