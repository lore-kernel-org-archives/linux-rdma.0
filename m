From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
Date: Wed, 20 Oct 2010 10:38:06 +0200
Message-ID: <4CBEAA6E.2060000@kernel.org>
References: <4CBDB834.2050905@kernel.org> <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

On 10/19/2010 08:40 PM, Bart Van Assche wrote:
> On Tue, Oct 19, 2010 at 5:24 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> [ ... ]
>> This is to prepare for deprecation of flush_scheduled_work().
>> [ ... ]
>> Index: work/include/rdma/ib_verbs.h
>> [ ... ]
>> +extern struct workqueue_struct *ib_wq;
>> [ ... ]
> 
> This patch adds a declaration of a global variable to a public header
> file. That might be unavoidable, but it doesn't make me happy.

Hmm... that's one very interesting reason to be unhappy.  Can you
please elaborate why addition of a global variable doesn't make you
happy?

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
