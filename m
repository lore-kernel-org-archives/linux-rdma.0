From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IB/ipoib: fix for rare multicast join race condition
Date: Fri, 12 Feb 2016 22:57:47 +0100
Message-ID: <CAJ3xEMj7U28ERUwPF_zP234KZFLt+Tu_pCN6XnHd5KsQnFtNDw@mail.gmail.com>
References: <20160211213051.29589.31877.stgit@phlsvlogin03.ph.intel.com>
	<CAJ3xEMgRxXx8kijLZK072oiN=_gYUXjqdUS=KtTKjk_BfKuXOw@mail.gmail.com>
	<CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ@mail.gmail.com>
	<56BE5342.7000902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BE5342.7000902-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 12, 2016 at 10:48 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/12/2016 04:47 PM, Or Gerlitz wrote:
>> On Fri, Feb 12, 2016 at 10:45 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Thu, Feb 11, 2016 at 10:30 PM, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> Proposed patch should prevent multicast join task to continue
>>>> if link state change is detected.
>>>>
>>>> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>
>>>> Changes from v4:
>>>> - as suggested by Doug Ledford, optimized spinlock usage,
>>>> i.e. ipoib_mcast_join() is called with lock held.
>>>> Changes from v3:
>>>> - sync with priv->lock before flag check.
>>>> Chages from v2:
>>>> - Move check for OPER_UP flag state to mcast_join() to
>>>> ensure no event worker is in progress.
>>>> - minor style fixes.
>>>> Changes from v1:
>>>> - No need to lock again if error detected.

>> Doug, I see now in your github that this indeed went in, could you made a
>> small git rebase rewording and remove this review history?

> It's not an important enough issue to warrant rebasing a tree that's
> already hit my k.o repo where I don't rebase except under dire need.

I disagree re the importance. The patch planted on your k.o tree just
minutes/hours ago... there
should be some borders to how low we're willing to get our subsystem
standards. The S.O.B area of
the patch is really badly written, the author S.O.B, next maybe 20
lines of irrelevant history followed
by the maintainer S.O.B -- this is very far from how properly signed
kernel commits need to look like.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
