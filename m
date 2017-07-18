From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 18 Jul 2017 11:24:01 -0700
Message-ID: <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
References: <1500393061.23761.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500393061.23761.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 18, 2017 at 8:51 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> This is the first round of fixes for the -rc cycle.

Pulled. However, I want to complain (again!) about bad merge commits.

You're not the only one doing this, so this is not rdma-specific, but
I complain when I notice.

There's a merge commit in there that has no explanation. This is the
totality of the commit message:

    Merge tag 'v4.13-rc1' into k.o/for-4.13-rc

    Linux v4.13-rc1

and I want to point out that there is *nothing* there that explains
why that merge exists.

Dammit, if you cannot explain why a merge exists, you should not do
that merge! It's that simple.

There is absolutely no excuse for commits without explanations, and
that is *doubly* true of merge commits that don't even have any sane
patch associated with them.

A normal commit that does an obvious one-liner fix? It really may not
need more than a trivial commit message saying "Fix typo in xyz". The
rest of the commit explains it well enough.

A merge? There *has* to be an explanation for why the merge exists.
What problem did that merge fix? Why was it done in the first palce?

And if the only reason for that merge is "sync with upstream", then
no, that is not a sufficient reason. It has to have an actual real
reason, and it needs to be stated.

                     Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
