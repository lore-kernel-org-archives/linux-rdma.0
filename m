From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
Date: Wed, 20 Oct 2010 12:21:13 +0200
Message-ID: <AANLkTikLUhN691OzPiqO_hqeAkE7VfWA6Gkwqt98MHN9@mail.gmail.com>
References: <4CBDB834.2050905@kernel.org> <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
 <4CBEAA6E.2060000@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBEAA6E.2060000-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 10:38 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On 10/19/2010 08:40 PM, Bart Van Assche wrote:
>> On Tue, Oct 19, 2010 at 5:24 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> [ ... ]
>>> This is to prepare for deprecation of flush_scheduled_work().
>>> [ ... ]
>>> Index: work/include/rdma/ib_verbs.h
>>> [ ... ]
>>> +extern struct workqueue_struct *ib_wq;
>>> [ ... ]
>>
>> This patch adds a declaration of a global variable to a public heade=
r
>> file. That might be unavoidable, but it doesn't make me happy.
>
> Hmm... that's one very interesting reason to be unhappy. =A0Can you
> please elaborate why addition of a global variable doesn't make you
> happy?

In the past every time I saw a global variable being added in a
software project that meant that some software concept was not being
abstracted properly. Which does not necessarily mean that that is the
case with this patch.

With the posted patch, just like with the current implementation, e.g.
the flush_workqueue() call in the ipath driver will make that driver
wait until work scheduled by the core/sa_query.c code finished and
vice versa. Is that necessary ? If not, using multiple work queues for
IB instead of one would allow to get rid of that global ib_wq
declaration.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
