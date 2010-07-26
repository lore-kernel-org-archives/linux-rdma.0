From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Mon, 26 Jul 2010 12:22:35 -0700
Message-ID: <adamxtejbes.fsf@roland-alpha.cisco.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sun, 25 Jul 2010 20:54:07 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > 2. Double completion processing loop
 >=20
 > * Initialization:
 > ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 >=20
 > * Notification handler:
 >=20
 > struct ib_wc wc;
 > do {
 > =C2=A0=C2=A0=C2=A0 while (ib_poll_cq(cq, 1, &wc) > 0)
 > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* process wc */
 > } while (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
 > IB_CQ_REPORT_MISSED_EVENTS) > 0);

This approach can be used to have race-free in-order processing of
completions using a scheme such as the NAPI processing loop used by the
IPoIB driver (with help from the core networking stack).  Essentially a
completion notification just marks the completion processing routine as
runnable, and the networking core schedules that processing routine in =
a
single-threaded way until the CQ is drained.

Another approach is to just always run the completion processing for a
given CQ on a single CPU and avoid locking entirely.  If you want more
CPUs to spread the work, just use multiple CQs and multiple event vecto=
rs.

 > see e.g. VipCQNotify() in the Virtual Interface Architecture
 > Specification.

I don't know of an efficient way to implement this type of "atomic
dequeue completion or enable completions" with any existing hardware.
Do you have an idea how this could be done?

 - R.
--=20
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go=
 to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
