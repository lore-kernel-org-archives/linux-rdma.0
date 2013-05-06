From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: race in ULPs when processing RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Tue, 7 May 2013 00:08:30 +0300
Message-ID: <CAJZOPZKSNZc33JDTy1JvHg6OotcaCorCkPCmArKk9qP5yVSemQ@mail.gmail.com>
References: <5186671F.3020408@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD21043@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZKm2ZXKVgTKAYXj6uHzji_p00UQQbKHzmqiPaTSLctEKg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD2121B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2121B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 6, 2013 at 11:33 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> I would think that this would do it:
>
> - call rdma_destroy_qp() from the callback
> - decrement the global reference count
> - destroy the global context from the callback when count = 0
> - return non-zero from the callback to destroy the rdma cm id

Yep, generally speaking this makes some sense, we need to see how to
really make it work, in the presence of some other considerations
specific to iser.  At least now we understand clearly the problem of
the current code, I just wonder why over IB we don't hit the crash...
oh well.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
