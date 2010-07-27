From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 10:33:42 +0200
Message-ID: <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxtejbes.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 26, 2010 at 9:22 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> [ ... ]
>
> Another approach is to just always run the completion processing for =
a
> given CQ on a single CPU and avoid locking entirely. =A0If you want m=
ore
> CPUs to spread the work, just use multiple CQs and multiple event vec=
tors.

In the applications I'm familiar with InfiniBand is being used not
only because of its low latency but also because of its high
throughput. In order to handle such loads efficiently, interrupts have
to be spread over multiple CPUs.

Switching from a single receive queue to multiple receive queues is an
interesting alternative, but is not possible without changing the
communication protocol between client and server. Changing the
communication protocol is not always possible, especially when the
communication protocol has been defined by a standards organization.

> =A0> see e.g. VipCQNotify() in the Virtual Interface Architecture
> =A0> Specification.
>
> I don't know of an efficient way to implement this type of "atomic
> dequeue completion or enable completions" with any existing hardware.
> Do you have an idea how this could be done?

I am not an expert with regard to HCA programming. But I assume the
above should refer to "reprogrammable firmware" instead of "hardware"
?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
