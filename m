From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Mon, 25 Jan 2016 00:13:12 +0200
Message-ID: <CAJ3xEMhPj3jsXD5qBrJYLyf2LsB1c5UwzQsb=+HMGuvQqTK9ug@mail.gmail.com>
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
	<CA+55aFy6ynd91QhGHyo=9vHb8HPj4yvsY10kYXPVpBSPemcxJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy6ynd91QhGHyo=9vHb8HPj4yvsY10kYXPVpBSPemcxJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 24, 2016, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Sun, Jan 24, 2016, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> It's possible that for a given merge cycle, we have networking changes that
>> require core changes and RDMA changes which require different core changes.
>
> Yes.
>
> However, you should synchronize it some way at least _internally_.
> Maybe by using a git tree inside Mellanox, so that the pain of your
> two development groups doesn't then hit people who don't know the
> hardware and can't test.

Yes, sounds like that's the right thing to do.

>> So I'd like to clarify with you a point re linux-next.
>>
>> From my experience working under few maintainers (Dave, Roland, Doug) over
>> the years...what the maintainer has to do is (A) register their for-next
>> tree/branch to linux-next merge tests and (B) respond to the linux-next
>> maintainer when he identifies conflicts and resolves them.
>
> Yes. And as far as I can tell, this conflict _was_ in linux-next.
>
> However, the fact that it got resolved in linux-next is purely
> informational. It doesn't "fix" the conflict - it just means that both
> sides should have gotten informed about it. That doesn't mean that the
> conflict goes away or becomes better.

That's news to me. When such things happen and caught by Stephen, we
are getting an email saying something like

"Today's linux-next merge of the infiniband tree got a conflict
between commit X from net-next tree and commit Y from the infiniband
tree. I fixed it up (see below) and can carry the fix as necessary (no
action is required)."

Also asked around a bit and got to learn on Stephen using git rerere,
so all (no action needed note + seeing git rerere in action...) that
leaded me to think that indeed no action is required from our side,
but after reading your email (twice, so far), I realized that this was
wrong conclusion.

> So what linux-next conflicts should have resulted in was that people
> were aware of it before it even hit my tree, and there might be
> mitigating efforts taken (where "mitigation" might be just informing
> me about it in the pull request, which didn't even happen).
>
> And Stephen is actually really really good at handling merge conflicts
> these days (he's probably the _one_ person who does more merges than I
> do), but at the same time, he tends to have a "merge and forget" model
> - not only does he use "git rerere" so that he never has to worry
> about the merge later, he doesn't tend to care very much about the end
> result and think about it.
>
> For example, I doubt Stephen spent a lot of time worrying about the
> byte offsets in that header file - he cares about getting things to
> compile. Or did he notice and notify people that the offsets were
> crap?

nope, the byte offsets party was not reported.

> In contrast, when I do a merge, I end up trying to see what the
> background for the conflict is. And that's not just about the code,
> it's explicitly about things like "why did these two trees conflict in
> the first place".
>
> Because _I_ care about not just trying to get things to compile, and
> not just about getting the right merge result, but in fact things like
> "is there some problem in code maintenance that causes this conflict -
> should we maybe split development some way?" is very much a primary
> concern for me.
>
> In 99% of all conflicts, the answer is "it's a trivial conflict, both
> sides did the rigth thing, I'm just fixing things up".

Would it be correct to phrase the points you are trying to make in
this email as:

If the conflict doesn't fall into a category of being a trivial one,
were both sides did the right thing and someone only has to fix things
up to co-exist -- something is wrong, and the conflict should be
resolved by a per-merge fix to at least one of the patches

?

[...]

> So no, "merge things right" is not the answer. Well, not the whole
> answer. I really want your two groups to be aware of each other. Talk
> before-hand. When you work on the same thing, TALK TO EACH OTHER - so
> that you share the same end result, so that it gets testing in both
> your groups.

>               Linus

Agree... we'll also share the internal practices for that
rdma-next/net-next shared-git tree with Doug to see he's happy with
how we act to improve things.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
