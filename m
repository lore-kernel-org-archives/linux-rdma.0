From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 24 Jan 2016 09:16:56 -0800
Message-ID: <CA+55aFy6ynd91QhGHyo=9vHb8HPj4yvsY10kYXPVpBSPemcxJg@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
	<CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
	<56A3FE6F.4000800@redhat.com>
	<CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
	<56A42829.90401@redhat.com>
	<CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
	<56A4F986.5070604@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A4F986.5070604-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 24, 2016 at 8:19 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> It's possible that for a given merge cycle, we have networking changes that
> require core changes and RDMA changes which require different core changes.

Yes.

However, you should synchronize it some way at least _internally_.
Maybe by using a git tree inside Mellanox, so that the pain of your
two development groups doesn't then hit people who don't know the
hardware and can't test.

> So I'd like to clarify with you a point re linux-next.
>
> From my experience working under few maintainers (Dave, Roland, Doug) over
> the years...what the maintainer has to do is (A) register their for-next
> tree/branch to linux-next merge tests and (B) respond to the linux-next
> maintainer when he identifies conflicts and resolves them.

Yes. And as far as I can tell, this conflict _was_ in linux-next.

However, the fact that it got resolved in linux-next is purely
informational. It doesn't "fix" the conflict - it just means that both
sides should have gotten informed about it. That doesn't mean that the
conflict goes away or becomes better.

So what linux-next conflicts should have resulted in was that people
were aware of it before it even hit my tree, and there might be
mitigating efforts taken (where "mitigation" might be just informing
me about it in the pull request, which didn't even happen).

And Stephen is actually really really good at handling merge conflicts
these days (he's probably the _one_ person who does more merges than I
do), but at the same time, he tends to have a "merge and forget" model
- not only does he use "git rerere" so that he never has to worry
about the merge later, he doesn't tend to care very much about the end
result and think about it.

For example, I doubt Stephen spent a lot of time worrying about the
byte offsets in that header file - he cares about getting things to
compile. Or did he notice and notify people that the offsets were
crap?

In contrast, when I do a merge, I end up trying to see what the
background for the conflict is. And that's not just about the code,
it's explicitly about things like "why did these two trees conflict in
the first place".

Because _I_ care about not just trying to get things to compile, and
not just about getting the right merge result, but in fact things like
"is there some problem in code maintenance that causes this conflict -
should we maybe split development some way?" is very much a primary
concern for me.

In 99% of all conflicts, the answer is "it's a trivial conflict, both
sides did the rigth thing, I'm just fixing things up".

But sometimes the conflicts are about fundamental problems. The ARM
SoC updates were one such area a few years ago, where the insane
devicetree people continually stepped on each others toes and it got
annoying conflicts many times.

I told the ARM people that their model wasn't working, and the ARM
situation has improved tremendously.

Now I'm telling you guys. There's something rotten in the state of
Mellanox. It needs to be fixed.

> A2nd question here, AFAIK, git rerere assumes some ordering... is it okay
> we'll assume that you will always pull the networking changes and only later
> the rdma changes?

No.

Also note that I do not use "rerere" myself. I do not import the state
from linux-next, although I _use_ linux-next to see what I still have
to merge, and sometimes to look at whether things had been resolved
there (which is why I know at least _some_ of the Mellanox issues
already showed up in linux-next).

So linux-next merging is very different. The merge I do is independent
of linux-next, and it's often done in a different order.

> And this brings me to the last point, merge tests should be done before
> sending you pull requests. I know Dave is doing that... we will be
> discussing this with Doug to agree on the details.

The thing is, merge tests are all god, and I appreciate them as a
heads-up. Some groups do pre-merges to verify that nothing bad
happened, and also to give pointers about what is going on when they
do happen. The ARM team does that, for example, probable exactly
because of the historical issues they used to have.

But at the same time I do *not* appreciate submaintainer pre-merging
the end result in order to hide problems in the development model. I
don't want to see "I did a merge for you because it was nasty". I'm
not trying to push the pain of merging onto Doug, just so that I don't
need to know about it. Because I _do_ need to know about it, because
problems during the merge are important information for me. They are a
sign that something is not right, and two groups are stomping on each
others feet.

Problematic merges often cause problems later. Sometimes they cause
problems for immediate reasons - the merge resulted in bugs, and it's
*really* nasty when mis-merges cause issues, because there is often
not a very legible patch to blame. But at other times, the merge is
fine, but it hides the conflict of people working on the same code,
which will just cause problems later when it happens again.

So no, "merge things right" is not the answer. Well, not the whole
answer. I really want your two groups to be aware of each other. Talk
before-hand. When you work on the same thing, TALK TO EACH OTHER - so
that you share the same end result, so that it gets testing in both
your groups.

              Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
