From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Mon, 26 Jul 2010 19:59:44 +0200
Message-ID: <AANLkTi=phE--i0Bu_Hi7XSsem31K5U38H6h6imvo__H+@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<4C4D99F8.3090206@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4D99F8.3090206-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 26, 2010 at 4:21 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 07/25/2010 01:54 PM, Bart Van Assche wrote:
>>
>> [ ... ]
>>
>> The only way I know of to prevent out-of-order completion processing
>> with the current OFED verbs API is to protect the whole completion
>> processing loop against concurrent execution with a spinlock. Maybe it
>> should be considered to extend the verbs API such that it is possible
>> to process completions in order without additional locking. Apparently
>> API functions that allow this in a similar context have already been
>> invented in the past -- see e.g. VipCQNotify() in the Virtual
>> Interface Architecture Specification.
>
> Is this the API to which you refer?
>
> http://docsrv.sco.com/cgi-bin/man/man?VipCQNotify+3VI
>
> I don't see how it provides the semantics you desire?

The web page you refer to is owned by a company that is controversial
in the Linux world. A more neutral source is the book "The Virtual
Interface Architecture" (Intel Press, 2002) or the document "Virtual
Interface Architecture Specification" (1997, available online at
http://pllab.cs.nthu.edu.tw/cs5403/Readings/EJB/san_10.pdf). In both
documents it is described that VipCQNotify atomically either dequeues
a work completion or enables notifications. As far as I know none of
the verb extensions defined by the IBTA allows to perform both
operations in an atomic way.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
