From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 3/8] IB/srp: allow lockless work posting
Date: Mon, 10 Jan 2011 17:37:46 -0500
Message-ID: <1294699066.3038.20.camel@obelisk.thedillows.org>
References: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
	 <1294259716-30706-4-git-send-email-dillowda@ornl.gov>
	 <AANLkTinExFSLHAo97S0Q8tbfUb5Lc5h06kHXyyzj-2Cj@mail.gmail.com>
	 <1294590920.3071.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294590920.3071.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-01-09 at 11:35 -0500, David Dillow wrote:
> On Sun, 2011-01-09 at 16:59 +0100, Bart Van Assche wrote:
> > On Wed, Jan 5, 2011 at 9:35 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > > From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> 
> > > +       list_del_init(&target->free_tx);
> > > +       for (i = 0; i < SRP_SQ_SIZE; ++i)
> > > +               list_move(&target->tx_ring[i]->list, &target->free_tx);
> > >
> > >        target->qp_in_error = 0;
> > >        ret = srp_connect_target(target);
> 
> > Sorry that I hadn't noticed this before: invoking list_del_init() on
> > &target->free_tx seems strange to me since &target->free_tx is a list
> > head and not a list element. While list_del_init() will probably work
> > fine here, using INIT_LIST_HEAD() here seems more appropriate to me.
> 
> Yeah, it works, but INIT_LIST_HEAD() would be more appropriate. I'll fix
> that when I put this in my repository.

Actually, using INIT_LIST_HEAD() here on a non-empty free_tx corrupts
things when used with list_move(). That's not a problem in the next
patch, where we transition to list_add(), so I made the change in patch
4.

Thinking about it, we could just do an INIT_LIST_HEAD() here on both
free_tx and req_queue, and move to list_add() here. However, I've
already retested the change in patch 4 and pushed to git, so I'm going
to leave this be.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
