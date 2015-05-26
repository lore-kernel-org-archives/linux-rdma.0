From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Tue, 26 May 2015 16:07:24 -0600
Message-ID: <20150526220724.GC4502@obsidianresearch.com>
References: <20150520002915.GD16941@obsidianresearch.com>
 <555C9D00.2090609@mellanox.com>
 <1432134677.5304.23.camel@opteya.com>
 <CAJ3xEMjO2HqFePAwXnoCt0rCzRLfYbqdP+883v4LaMovj7Y-FA@mail.gmail.com>
 <CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
 <CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
 <20150526160624.GA11800@obsidianresearch.com>
 <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
 <20150526185315.GF11800@obsidianresearch.com>
 <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 11:39:04PM +0300, Or Gerlitz wrote:
> >> Jason, you (U2 BTW) play really, really hard - refusing to say **one**
> >> word on your approach towards the built-in udata mechanism for uverbs
> >> which I asked you to comment on.
> 
> > And I asked to see the user space side and you have angrily refused
> > every time.
> 
> AFAIR I never ever refused to show any piece of code which went under
> my hands towards Linux to any-one.

For future reference, when someone asks a question and you go off on
an tangental rant and ignore the question, then that process repeats,
still without answering the question - most english speakers would
call that refusing to answer the question. It is not looked upon
kindly.

I'm really confused why you didn't just post the github links last
week, the patches are all a month old on there. Was it really so
offensive to you that we wanted to review the kernel UAPI patches and
verbs patches together?

> > So I guess we are both playing hard.
> 
> I disagree, you act as sort of being the boss here, stating every now
> and then your preferences and way of engineering things as the
> ultimate guidelines for Linux and/or RDMA engineering.

Lets be clear Or, I have given you (and others) some very pointed
comments and advice, privately and publicly. That is not 'being the
boss' that is contributing to fix our community.

When it comes to my patch comments, I give direction on what I want to
see to provide my Reviewed-By.

If you don't like it, then find someone else to review your code.

I'm busy, and I don't work for you. If I don't want to review some
patches because my questions have been ignored, then that is entirely
my perogative.

Pinging me *three times this week* on this stupid timestamp thing, is
somewhere between annoying and offensive.

Chill out Or.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
