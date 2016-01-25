From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 24 Jan 2016 17:05:16 -0800
Message-ID: <CA+55aFwQ2uCOfrLNzw5nfKk73UfyrG+7j+9wSLU9ZvB0LM2paw@mail.gmail.com>
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
	<CAJ3xEMhPj3jsXD5qBrJYLyf2LsB1c5UwzQsb=+HMGuvQqTK9ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhPj3jsXD5qBrJYLyf2LsB1c5UwzQsb=+HMGuvQqTK9ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 24, 2016 at 2:13 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> That's news to me. When such things happen and caught by Stephen, we
> are getting an email saying something like
>
> "Today's linux-next merge of the infiniband tree got a conflict
> between commit X from net-next tree and commit Y from the infiniband
> tree. I fixed it up (see below) and can carry the fix as necessary (no
> action is required)."

So that's purely about linux-next, and Stephen carrying the merge
around there. He's informing you that he has resolved it in
linux-next, and you now should know about the issue, and that he won't
inform you again, because it's resolved in linux-next (sometimes -
very seldom - the clashes get so bad that he just throws out one tree
as unresolvable, and then that tree needs to actually work on getting
it resolved in linux-next).

>> In 99% of all conflicts, the answer is "it's a trivial conflict, both
>> sides did the rigth thing, I'm just fixing things up".
>
> Would it be correct to phrase the points you are trying to make in
> this email as:
>
> If the conflict doesn't fall into a category of being a trivial one,
> were both sides did the right thing and someone only has to fix things
> up to co-exist -- something is wrong, and the conflict should be
> resolved by a per-merge fix to at least one of the patches

So it's not entirely about the "trivial" part.

Sometimes we have complicated merges, simply because two different
people did very different things, and they clashed.

But of those two people had a good _reason_ to do different things,
and they were fundamentally independent things to do, then even a
non-trivial merge migth still be about everybody doing the right
thing, and it just happened to clash. Unfortunate, but it can happen.
For example, maybe Al Viro did some VFS re-organization that impacted
individual filesystems, and then one of the filesystem maintainers did
some independent changes for one of the filesystems that just happened
to clash. That would still be "everything is fine, we were just
slightly unlucky".

But when there are two groups in the same company, working on the
_same_ driver, then those two groups need to talk. When they clash,
it's not "we were just slightly unlucky, working on different things,
and normally these things don't interact that way".

This is not a matter of two independent groups working on independent
things that just have overlap. You're working on the same f*cking
driver, doing variations of the same f*cking thing, for chrissake.

So talk to each other.

We had the same thing happen with the NETDEV_CHANGEUPPER thing from
Mellanox. Again, it wasn't two different groups working on two
different things that just happened to get a clash. No, it was two
different groups inside of Mellanox working on the exact same thing,
inside the same company, and they just did the same thing (slightly
differently) without ever talking to each other, and sent it out to
two different maintainers.

See the difference? A _good_ merge conflict is when two groups work on
entirely different things and they just happen to have some
unfortunate overlap. A bad conflict is when two groups work on the
same exact thing and didn't talk it over.

                 Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
