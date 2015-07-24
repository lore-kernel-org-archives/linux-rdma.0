From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Fri, 24 Jul 2015 16:26:00 -0400
Message-ID: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> During some other testing I found that when a completion upcall
>>>> returns to the provider leaving CQEs still on the completion queue=
,
>>>> there is a non-zero probability that a completion will be lost.
>>>=20
>>> What does lost mean?
>>=20
>> Lost means a WC in the CQ is skipped by ib_poll_cq().
>>=20
>> In other words, I expected that during the next upcall,
>> ib_poll_cq() would return WCs that were not processed, starting
>> with the last one on the CQ when my upcall handler returned.
>=20
> Yes, this is what it should do. I wouldn't expect a timely upcall, bu=
t
> none should be lost.
>=20
>> I found this by intentionally having the completion handler
>> process only one or two WCs and then return.
>>=20
>>> The CQ is edge triggered, so if you don't drain it you might not ge=
t
>>> another timely CQ callback (which is bad), but CQEs themselves shou=
ld
>>> not be lost.
>>=20
>> I=92m not sure I fully understand this problem, it might
>> even be my misuderstanding about ib_poll_cq(). But forcing
>> the completion upcall handler to completely drain the CQ
>> during each upcall prevents the issue.
>=20
> CQs should never be lost.
>=20
> The idea that you can completely drain the CQ during the upcall is
> inherently racey, so this cannot be the answer to whatever the proble=
m
> is..

Hrm, ok. Completely draining the CQ is how the upcall handler
worked before commit 8301a2c047cc.


> Is there any chance this is still an artifact of the lazy SQE flow
> control? The RDMA buffer SQE recycling is solved by the sync
> invalidate, but workloads that don't use RDMA buffers (ie SEND only)
> will still run without proper flow control=85

I can=92t see how it can be related to the send queue these days.
The CQ is split. The behavior I observed was in the receive
completion path. All RECVs are signaled, and there are a fixed
and limited number of reply buffers that match the number of
RPC/RDMA credits.

Basically RPC work flow stopped because an RPC reply never
arrived.

The send queue accounting problem would cause the client to
stop sending RPC requests before we hit our credit limit.


> If you are totally certain a CQ was dropped from ib_poll_cq, and that
> the SQ is not overflowing by strict accounting, then I'd say driver
> problem, but the odds of having an undetected driver problem like tha=
t
> at this point seem somehow small=85

Under normal circumstances, most ULPs are prepared to deal with a
large number of WCs per upcall. IMO the issue would be difficult to
hit unless you have rigged the upcall handler to force the problem
to occur (poll once with a small ib_wc array size and then return
from the upcall handler).

I will have some time to experiment next week. Thanks for confirming
my understanding of ib_poll_cq().


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
