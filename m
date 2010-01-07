From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Thu, 7 Jan 2010 11:01:49 +0100
Message-ID: <e2e108261001070201s418d0de7r20e5c2dce2fd8540@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <ada4omyud7c.fsf@roland-alpha.cisco.com>
	 <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	 <adak4vuqrcw.fsf@roland-alpha.cisco.com>
	 <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001070003y6881eac7g3e8129e44b78a475-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 7, 2010 at 9:03 AM, Bart Van Assche
<bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Jan 7, 2010 at 8:57 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wro=
te:
>>
>> =A0> It was only recently that I had the time to analyze this issue =
in
>> =A0> depth and that I added SRP_CRED_REQ support in SCST (checked in=
 that
>> =A0> support about one week ago). Before SRP_CRED_REQ support was ad=
ded in
>> =A0> SCST, the SRP initiator could not log the "Unhandled SRP opcode=
"
>> =A0> message because it did not receive any unhandled SRP opcodes.
>>
>> So it sounds like this is fixing something that was not the original
>> bug? =A0Because SCST wasn't sending SRP_CRED_REQ when the issue of t=
he
>> initiator hanging was originally seen, if I understand correctly.
>
> The patch I posted is really fixing the original bug. The problem was
> that neither the SRP target nor the SRP initiator had support for
> SRP_CRED_REQ. Support for SRP_CRED_REQ has to be added to both
> software components in order to fix this bug.

However, I have to admit that the patch description should have
described what happened more in detail. I'll address that in the
second version of my patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
