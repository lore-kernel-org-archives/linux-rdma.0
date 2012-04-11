From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 0/4] librdmacm: Rsockets API and implementation
Date: Wed, 11 Apr 2012 21:44:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451ACF9C@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373451ACEEF@ORSMSX101.amr.corp.intel.com>
 <4F85E720.5040307@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F85E720.5040307-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Interesting work. Regarding direct data placement: have the io_submit()
> and io_getevents() system calls been considered ? Those are the
> foundation of libaio.

I did look at aio and other interfaces, but I didn't try to move beyond the idea phase.  With aio, I didn't see how the calls could easily be used by a socket app without recoding, or even redesigning the app around the aio interface.

Are you suggesting calls similar to io_submit() and io_getevents() that work with a socket rather than an aio_context_t?

My intent is to start a more general discussion on whether direct data placement is needed (I'm assuming yes) and the best way to add it.  I wasn't comfortable enough with just my own musing on things to dedicate any time implementing something.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
