From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_destroy_cm_id() versus cm callback race ?
Date: Tue, 01 May 2012 07:19:10 +0000
Message-ID: <4F9F8E6E.3050803@acm.org>
References: <4F9AC1F2.5070007@acm.org> <1828884A29C6694DAF28B7E6B8A82373469D891F@ORSMSX101.amr.corp.intel.com> <4F9BBEEB.40806@acm.org> <1828884A29C6694DAF28B7E6B8A82373469FED01@ORSMSX101.amr.corp.intel.com> <4F9EE22A.4020000@acm.org> <1828884A29C6694DAF28B7E6B8A8237346A00D4A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A00D4A-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/30/12 19:27, Hefty, Sean wrote:

>> * User requests shutdown and hence from another thread ib_send_cm_dreq() is
>> invoked.
> 
> ib_send_cm_dreq() at this point should fail with EINVAL, as the

> connection state is not yet established.

You are right, that didn't make sense. What I have noticed could be
explained by reception of a DREQ message while the REQ handler was still
running.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
