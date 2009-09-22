From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH/RFC] IB/mad: Fix lock-lock-timer deadlock in RMPP code
Date: Tue, 22 Sep 2009 15:27:23 -0700
Message-ID: <9DA1536B0B4943E7BC52280C977F1D23@amr.corp.intel.com>
References: <adaws4an4uh.fsf@cisco.com>	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>	<adaskeym5gu.fsf@cisco.com>	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>	<adabpllmk7c.fsf@cisco.com>	<e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com>	<adavdjrkfyq.fsf_-_@cisco.com>	<F658AB9802E54F9887A2753721FA7882@amr.corp.intel.com> <ada7hvq7s36.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada7hvq7s36.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>OK so how about something like this?  Just hold the lock to mark the
>items on the list as being canceled, and then actually cancel the
>delayed work without the lock.  I think this doesn't leave any races or
>holes where the delayed work can mess up the cancel.

This looks good to me.  Thanks for looking at this.

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
