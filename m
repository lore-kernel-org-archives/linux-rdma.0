From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
Date: Wed, 20 Oct 2010 13:03:57 +0200
Message-ID: <4CBECC9D.6000504@kernel.org>
References: <4CBDB834.2050905@kernel.org> <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com> <4CBEAA6E.2060000@kernel.org> <AANLkTikLUhN691OzPiqO_hqeAkE7VfWA6Gkwqt98MHN9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikLUhN691OzPiqO_hqeAkE7VfWA6Gkwqt98MHN9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

On 10/20/2010 12:21 PM, Bart Van Assche wrote:
>> Hmm... that's one very interesting reason to be unhappy.  Can you
>> please elaborate why addition of a global variable doesn't make you
>> happy?
> 
> In the past every time I saw a global variable being added in a
> software project that meant that some software concept was not being
> abstracted properly. Which does not necessarily mean that that is the
> case with this patch.

That's too wide brushed position to agree with, but, well, let's talk
about that some other time.  :-)

> With the posted patch, just like with the current implementation, e.g.
> the flush_workqueue() call in the ipath driver will make that driver
> wait until work scheduled by the core/sa_query.c code finished and
> vice versa. Is that necessary ? If not, using multiple work queues for
> IB instead of one would allow to get rid of that global ib_wq
> declaration.

Yeap, if breaking it down further makes sense, definitely.  If someone
is interested, the followings are the guidelines I've been following
in these conversions.

* If all the possibly pending works can be safely enumerated without
  too much difficulty and the works in question are not used during
  memory reclaim, use the system workqueue and use explicit
  flush/cancel_work[_sync]() instead of using flush_workqueue().
  Please note that flush_work_sync() isn't in mainline yet.  It's
  scheduled for the coming rc1 window.

* If works can be used during memory reclaim, there's no way around
  it.  A separate workqueue needs to be used.

* If works free themselves or are used to put the last reference of
  the containing object, they can't be flushed explicitly and thus
  need to be queued on a dedicated workqueue which serves as the
  flushing domain.

For this patch, I chose less intrusive path and just replaced system
wide workqueue with subsystem wide one mainly because I don't have
experience with or access to anything infiniband.  If someone wants to
push it further, I would be happy to help.

BTW, does the posted patch look safe to you?

Thanks.

-- 
tejun
