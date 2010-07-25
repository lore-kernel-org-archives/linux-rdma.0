From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: About a shortcoming of the verbs API
Date: Sun, 25 Jul 2010 20:54:07 +0200
Message-ID: <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

One of the most common operations when using the verbs API is to
dequeue and process completions. For many applications, e.g. storage
protocols, processing completions in order is a correctness
requirement. Unfortunately with the current IB verbs API it is not
possible to process completions in order on a multiprocessor system
when using notification-based completion processing without
introducing additional locking.

The two most common patterns for notification-based completion processi=
ng are:

1. Single completion processing loop.

* Initialization:
ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);

* Notification handler:

struct ib_wc wc;
ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
while (ib_poll_cq(cq, 1, &wc) > 0)
=A0=A0=A0 /* process wc */


2. Double completion processing loop

* Initialization:
ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);

* Notification handler:

struct ib_wc wc;
do {
=A0=A0=A0 while (ib_poll_cq(cq, 1, &wc) > 0)
=A0=A0=A0 =A0=A0=A0 /* process wc */
} while (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
IB_CQ_REPORT_MISSED_EVENTS) > 0);


A known performance-wise disadvantage of the single notification
processing loop in (1) is that the completion handler can be invoked
with an empty completion queue (see also
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg03148.html).
While less likely, this can also happen with the double notification
processing loop (2).

What is worse is that none of the above two loops guarantees that
completions will be processed in order on a multiprocessor system. The
following can happen with both (1) and (2):
* The completion handler is invoked.
* Notifications are reenabled.
* A work completion (A) is popped of the completion queue.
* Completion processing is delayed for whatever reason.
* A new completion is pushed on the completion queue by the HCA.
* A new notification is generated.
* The same completion handler is invoked on another CPU, pops a
completion (B) from the completion queue and processes it.
* The completion handler that was delayed continues and processes
completion (A).

Or: completions (A) and (B) have been processed out-of-order.

This is not only a shortcoming of the OFED implementation of the verbs
API, but a shortcoming that is also present in the verb extensions as
defined by the IBTA. My opinion is that defining "poll for completion"
and "request completion notification" as separate verbs is not the
most optimal approach for multiprocessor or multi-core systems.

The only way I know of to prevent out-of-order completion processing
with the current OFED verbs API is to protect the whole completion
processing loop against concurrent execution with a spinlock. Maybe it
should be considered to extend the verbs API such that it is possible
to process completions in order without additional locking. Apparently
API functions that allow this in a similar context have already been
invented in the past -- see e.g. VipCQNotify() in the Virtual
Interface Architecture Specification.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
