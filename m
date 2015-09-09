From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 20:08:57 -0700
Message-ID: <CA+55aFytfSV5YqzUrZxBjAgnUn72WoJVHnaB14k5MKLkw-YnLA@mail.gmail.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
	<CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
	<55EF9E82.70405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EF9E82.70405-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2015 at 7:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Because the tree isn't buildable, let alone testable, without it.

You're missing the ENTIRE POINT.

> Well, I expected it to be handled without much effort on your part and
> the existing network infrastructure to be the final version.

There is indeed not much effort - I'd be throwing that commit away
entirely in favor of the right one.

> Is further explanation necessary, or have I answered your questions?

Further explanation is necessary.

Why did you rebase this thing?

And since you *did* rebase it, why did you still take the broken version?

Why did you take a different commit than the networking people did in
the first place?

Why did two different people at Mellanox write clearly different
versions of the exact same thing? Don't tell me they didn't talk to
each other - it's the exact same thing done at around the same time,
and for the same reasons, just done with entirely different structure
names and structure contents.

Why did you make networking changes without talking to the networking people?

The whole thing is one big mystery. And the problem is not how to
merge this, but why this kind of crap happened, and why something as
simple as "talk to the networking maintainer" didn't happen.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
