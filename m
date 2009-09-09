From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH/RFC] IB/mad: Fix lock-lock-timer deadlock in RMPP code (was: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock)
Date: Wed, 9 Sep 2009 14:22:28 -0700
Message-ID: <F658AB9802E54F9887A2753721FA7882@amr.corp.intel.com>
References: <adaws4an4uh.fsf@cisco.com>	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>	<adaskeym5gu.fsf@cisco.com>	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>	<adabpllmk7c.fsf@cisco.com>	<e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com> <adavdjrkfyq.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdjrkfyq.fsf_-_-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Holding agent->lock across cancel_delayed_work() (which does
>del_timer_sync()) in ib_cancel_rmpp_recvs() leads to lockdep reports of
>possible lock-timer deadlocks if a consumer ever does something that
>connects agent->lock to a lock taken in IRQ context (cf
>http://marc.info/?l=linux-rdma&m=125243699026045).
>
>However, it seems this locking is not necessary here, since the locking
>did not prevent the rmpp_list from having an item added immediately
>after the lock is dropped -- so there must be sufficient synchronization
>protecting the rmpp_list without the locking here.  Therefore, we can
>fix the lockdep issue by simply deleting the locking.

The locking is needed to protect against items being removed from rmpp_list in
recv_timeout_handler() and recv_cleanup_handler().  No new items should be added
to the rmpp_list when ib_cancel_rmpp_recvs() is running (or there's a separate
bug).

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
