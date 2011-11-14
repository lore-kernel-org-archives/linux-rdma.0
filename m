From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 21:55:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9AB1E@ORSMSX101.amr.corp.intel.com>
References: <4EC13EE9.1070103@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAC4@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZKBaQ2HR4kbidW0Mec2xWhZ5H7-ezG20X-J_aYENd9ibw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAF4@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZLn3hEYp_kHRs22ttF3ca0iq4s5NtFi4iUYgEie81osBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLn3hEYp_kHRs22ttF3ca0iq4s5NtFi4iUYgEie81osBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> what return value can serve as bogus indication for the application?
> is that -EINVAL? also, basically a QP could have buffers posted to it
> also before being connected (e.g after RTR or there's no point in time
> an rdma-cm consumer for which the cma manages the QP state is exposed
> to such QP in RTR and not RTS?) as for the twice case, still the IB CM
> will go through the timewait status in return for the 1st, not bogus
> call, correct?

rdma_disconnect() returns the value from modifying the QP state into error.  It masks the return value of calling the ib_cm to send the DREQ or DREP.  If rdma_disconnect() succeeds, a timewait event should occur, unless the app calls rdma_disconnect() without being connected.

Calling disconnect is one way that a QP may be transitioned into timewait.  The ib_cm will also transition to timewait in certain connection failure cases: REP times out or is rejected, or remote side detects a stale connection.  Without reading through the code, I don't know off the top of my head if a timewait event would follow an asynchronous rdma_connect() failure, even if rdma_disconnect() were called after the error.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
