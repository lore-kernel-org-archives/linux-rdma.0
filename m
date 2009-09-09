From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH/RFC] IB/mad: Fix lock-lock-timer deadlock in RMPP code
Date: Wed, 09 Sep 2009 14:34:41 -0700
Message-ID: <adar5ufkdji.fsf@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
	<adabpllmk7c.fsf@cisco.com>
	<e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com>
	<adavdjrkfyq.fsf_-_@cisco.com>
	<F658AB9802E54F9887A2753721FA7882@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F658AB9802E54F9887A2753721FA7882-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 9 Sep 2009 14:22:28 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > The locking is needed to protect against items being removed from rmpp_list in
 > recv_timeout_handler() and recv_cleanup_handler().  No new items should be added
 > to the rmpp_list when ib_cancel_rmpp_recvs() is running (or there's a separate
 > bug).

Ah, I see.

That's trickier I guess... hmm...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
