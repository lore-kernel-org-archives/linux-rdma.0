From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Tue, 12 Jan 2010 18:23:22 +0100
Message-ID: <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <ada4omyud7c.fsf@roland-alpha.cisco.com>
	 <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	 <adak4vuqrcw.fsf@roland-alpha.cisco.com>
	 <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	 <adavdfapimb.fsf@roland-alpha.cisco.com>
	 <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
	 <ada3a2bp7ow.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada3a2bp7ow.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 6:13 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> Note: I do not know of any SRP targets that implement approach (=
2). As
> =A0> far as I know all SRP targets use approach (1).
>
> But no other SRP targets send SRP_CRED_REQ -- and that includes all
> native IB storage arrays that I know of. =A0So there must be some oth=
er
> way around this (and having separate buffers for command receives and
> response sends does seem like a sensible way to design a target anywa=
y).

Having separate buffer sets for command receives and response sends
might seem a sensible way to design a target. But calling
ib_post_recv() before sending a response back to the initiator is not
acceptable because this increases communication latency. When a target
uses separate buffer sets, sends back SRP_RSP before responses before
ib_post_recv() is called, and when it processes SRP_CMD requests in
parallel, it still can happen that a sequence of RL - 2 SRP_RSP
responses is sent back to the initiator all with the REQUEST LIMIT
DELTA field set to zero. So even with separate buffer sets there is a
need for SRP_CRED_REQ support in the initiator.

I'm surprised by all this opposition against adding SRP_CRED_REQ
support in the initiator, a feature defined in the SRP standard ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
