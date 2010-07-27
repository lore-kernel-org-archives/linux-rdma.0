From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 20:03:25 +0200
Message-ID: <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafwz4g98j.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 27, 2010 at 6:50 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> [ ... ]
>
> From Documentation/infiniband/core_locking.txt:
>
> =A0The low-level driver is responsible for ensuring that multiple
> =A0completion event handlers for the same CQ are not called
> =A0simultaneously. =A0The driver must guarantee that only one CQ even=
t
> =A0handler for a given CQ is running at a time. =A0In other words, th=
e
> =A0following situation is not allowed:
>
> =A0 =A0 =A0 =A0CPU1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0CPU2
>
> =A0low-level driver ->
> =A0 =A0consumer CQ event callback:
> =A0 =A0 =A0/* ... */
> =A0 =A0 =A0ib_req_notify_cq(cq, ...);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0low-level driver ->
> =A0 =A0 =A0/* ... */ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 consumer CQ event callback:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0/* ... */
> =A0 =A0 =A0return from CQ event handler
>
> mean that the problem you are complaining about doesn't actually exis=
t?

As far as I know it is not possible for a HCA to tell whether or not a
CPU has finished executing the interrupt it triggered. So it is not
possible for the HCA to implement the above requirement by delaying
the generation of a new interrupt -- implementing the above
requirement is only possible in the low-level driver. A low-level
driver could e.g. postpone notification reenabling until the end of
the interrupt handler or it could use a spinlock to prevent
simultaneous execution of notification handlers. I have inspected the
source code of one particular low-level driver but could not find any
such provisions. Did I overlook something ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
