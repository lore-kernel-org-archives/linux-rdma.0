From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 13 Jan 2010 08:29:57 +0100
Message-ID: <e2e108261001122329u698f13ecibf42c1dc60b5cc04@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <ada4omyud7c.fsf@roland-alpha.cisco.com>
	 <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	 <adak4vuqrcw.fsf@roland-alpha.cisco.com>
	 <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	 <adavdfapimb.fsf@roland-alpha.cisco.com>
	 <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
	 <ada3a2bp7ow.fsf@roland-alpha.cisco.com>
	 <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com>
	 <adavdf7nd7k.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdf7nd7k.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 11:57 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wro=
te:
>
> =A0> Having separate buffer sets for command receives and response se=
nds
> =A0> might seem a sensible way to design a target. But calling
> =A0> ib_post_recv() before sending a response back to the initiator i=
s not
> =A0> acceptable because this increases communication latency. When a =
target
> =A0> uses separate buffer sets, sends back SRP_RSP before responses b=
efore
> =A0> ib_post_recv() is called, and when it processes SRP_CMD requests=
 in
> =A0> parallel, it still can happen that a sequence of RL - 2 SRP_RSP
> =A0> responses is sent back to the initiator all with the REQUEST LIM=
IT
> =A0> DELTA field set to zero. So even with separate buffer sets there=
 is a
> =A0> need for SRP_CRED_REQ support in the initiator.
>
> I doubt you could benchmark the overhead of calling ib_post_recv() in
> the full SRP protocol. =A0Really, I bet it's less than 100 nanosecond=
s to
> form the work request and call ib_post_recv(). =A0Maybe I'm wrong but=
 I
> really expect the overhead of actually doing IO (even to a ramdisk
> buffer or something) is going to be much higher than posting a receiv=
e.
>
> Or maybe you did benchmark it and I'm wrong?

The impact of the ib_post_recv() call is small but measurable. I'll
publish measurement results soon.

> =A0> I'm surprised by all this opposition against adding SRP_CRED_REQ
> =A0> support in the initiator, a feature defined in the SRP standard =
?
>
> As I said I agree we should implement support for SRP_CRED_REQ. =A0Ho=
wever
> I think it would be better if the SCST target could be made to work
> reliably with pre-2.6.34 initiators as well.

OK, I will first evaluate which alternatives there are for SCST-SRPT
such that it does not rely on initiator-side support for SRP_CRED_REQ.
This will not only help with pre-2.6.34 SRP initiators but also with
other SRP initiators than the one available in the vanilla Linux
kernel (e.g. OFED or WinOF).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
