From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Mon, 18 May 2015 13:16:59 +0300
Message-ID: <CAJ3xEMhOTYKKthGHjrrw-+bc0Ndi0Rz8S8Tg4hbhFQd8MPAtZQ@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	<1431485563.43876.93.camel@redhat.com>
	<CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	<1431530845.2377.30.camel@redhat.com>
	<55549D33.1000208@mellanox.com>
	<1431616073.3276.17.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431616073.3276.17.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 14, 2015 at 6:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>> Lets find a way to get things in that direction, for everyone's benefit.

> I'm fine with that.  What I'll propose is the following:

> Kernel.org tree: never rebases, will use a topic branch per release, I
> will coordinate tags on the different branches because Linus prefers to
> pull from signed tags anyway.  So, for-linus tag will always be the
> current code I wish Linus to pull, for-next will be the official next
> tag and it won't rebase, it will only move forward.

The official for-linus / for-next tag branding sounds OK, conditioned
on the git mechanics for the day-to-day developers use case to be
really simple (no need for checkouts? only pulls? maybe give few
examples on how people are expected to use that).

Personally, I am terribly sold out for the ultra simple practice of
two trees (e.g the netdev case) or two branches of the same tree (e.g
for-next, for-rc) which I always know where to get and what would they
contain. So I am a bit annoyed from the per-release topic branches.
But if everyone else are OK with your proposal we can go there (Amir -
is this OK for our automated systems?)


> github.com tree: will have my various topic branches (these will come
> and go as code is taken, merged into mainline, and then branch deleted),
> will have copies of the official k.o/ branches (which won't rebase), and
> will have to-be-rebase/* branches where I pull things together until I
> am happy with the overall branch and then I will move it over to k.o/*
> and it will no longer rebase.  It will also contain the most recent
> for-linus tag, and it will contain a for-next that.  The only special
> thing about the tags is if the for-next tag on k.o and here don't match,
> it means that this tag points to a branch that might be rebased and has
> not been blessed as official yet.  Once the tags between the two repos
> are identical again, you will know I've made the last rebase and moved
> the branch to the official status.

Sort of too complex for me to follow. I am on upstream for coupled of
years and worked with few maintainers, didn't had to go into that
level. I would prefer just to use your kernel.org and for-next things
need to be there before rc4 (today).

> So, under that scheme, your automated stuff can be pointed at k.o
> for-next, or if it is able to deal with rebases (meaning that your
> automated system blows away the last kernel and performs the merges all
> over again each time it runs) then you could point it at github
> for-next.  Is that acceptable?

Again, for the automated Amir needs to reply. For the day-to-day I
replied how I personally see things.

Another thing to nail down is patch subject line tagging. Currently it
seems no agreed practice. Under Roland we had for-next or nothing
(mostly the latter...)

I would suggest one of:

for-next (next release) and for-rc (current release)

or

rdma-next (next release) and rdma-rc (current release)

or

something else? RFCs are exception.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
