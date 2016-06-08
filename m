From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/7] IB/IPoIB: Fix race between ipoib_remove_one
 to sysfs functions
Date: Wed, 8 Jun 2016 10:29:02 +0300
Message-ID: <CAJ3xEMizQaQ6ZMV3dzfbVbYEnczy4Ai9ZWgq=u1E2uCVVqCbfA@mail.gmail.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-4-git-send-email-leon@kernel.org> <CAJ3xEMh_Pg2Kkp6yHx2OUJMokn0HX8Jd9Q0bcsB50KfTAcP1Gw@mail.gmail.com>
 <CAAk-MO_9P2vVJS_RXrqUPx224Re9sjifug+hfxVGN4Ze5tYhSg@mail.gmail.com>
 <CAJ3xEMj-5Aet518M6N=3fGRT06YXWPSm-vDVL5iqRbiiRTbH-Q@mail.gmail.com> <CAAk-MO-idYZ9fCGY6GYhDavTQSGh+BhOpBjzgGX5Jw7KDtLecQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO-idYZ9fCGY6GYhDavTQSGh+BhOpBjzgGX5Jw7KDtLecQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 8, 2016 at 10:01 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Tue, Jun 7, 2016 at 11:22 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> yes, but the bug you're pointing on is out there for whole four years
>> and no one complained including you, can you explain that?

> Not really, it is a race, not easy to see it, but it is there, waiting..

yes, seems this is the case,

>> so why need to simulate? is that impossible to get it on non simulated env?

> It happened in our regression system.

so after four years the deadlock happened once in the regression
system and no one
else complained, that sounds like hard to reproduce one... good catch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
