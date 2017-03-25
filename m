From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 25 Mar 2017 15:45:48 -0700
Message-ID: <CA+55aFx+p+grY-vLzHOmj4VFKvni3eHUmO_hn+AzmHXw2MeUZg@mail.gmail.com>
References: <1490466578.2404.55.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490466578.2404.55.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 25, 2017 at 11:29 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> This has been a slow -rc cycle for the RDMA subsystem.  We really
> haven't had a lot of rc fixes come in.  This pull request is the first
> of this entire rc cycle and it has all of the suitable fixes so far and
> it's still only about 20 patches.  The fix for the minor breakage cause
> by the dma mapping patchset is in here, as well as a couple other
> potential oops fixes, but the rest is more minor.

I am getting *very* irritated with the rdma pull requests.

I'm looking at your commits, and they have all been done on a Friday
evening between 4pm and 11pm (with the bulk being after 9pm).

So what the hell happened in the rdma subsystem the rest of the week?
That's just *odd*. Why am I getting a pull request on a Saturday with
stuff that was done late Friday night?

Can you understand why it feels very hurried to me, and why I get a
feeling that you're timing your work and your pull requests for the rc
releases on a Sunday?

What testing did this branch get during the week? Several patches have
dates from a month ago, but regardless they all show this pattern of
looking like they were hurriedly committed the night before being sent
off..

It just fails the smell test.  What's going on here?

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
