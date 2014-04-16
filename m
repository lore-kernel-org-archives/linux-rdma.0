From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Wed, 16 Apr 2014 14:21:33 -0400
Message-ID: <FC61F219-ACA2-4CE8-BF02-1B8EE2464639@oracle.com>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com> <E9B601B5-1984-40D8-914A-DDD1380E8183@oracle.com> <534EA06A.7090200@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <534EA06A.7090200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Apr 16, 2014, at 11:23 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:

> On 4/16/2014 6:08 PM, Chuck Lever wrote:
>> Hi Sagi-
>>=20
>> Thanks for the review! In-line replies below.
> <SNIP>
>>=20
>>>> 2. If I understood correctly, I see that the CQs are loop-polled i=
n an interrupt context.
>>>>    This may become problematic in stress workload where the CQ sim=
ply never drains (imagine
>>>>    some studios task keeps posting WRs as soon as IOs complete). T=
his will cause CQ poll loop
>>>>    to go on forever. This situation may cause starvation of other =
CQs that share the same EQ (CPU
>>>>    is hogged by the endless poller).
>>>>    This may be solved in 2 ways:
>>>>    - Use blk-iopoll to maintain fairness - the downside will be mo=
ving from interrupt context to soft-irq (slower).
>>>>    - Set some configurable budget to CQ poller - after finishing t=
he budget, notify the CQ and bail.
>>>>      If there is another CQ waiting to get in - it's only fair tha=
t it will be given with a chance, else another interrupt
>>>>      on that CQ will immediately come.
>> I think it would be a reasonable change to pass an array of WC=92s t=
o
>> ib_poll_cq() just once in rpcrdma_{send,recv}cq_poll(), instead of
>> looping. Would that be enough?
>>=20
>> To be clear, my patch merely cleans up the completion handler logic,
>> which already did loop-polling. Should we consider this improvement
>> for another patch?
>=20
> Well, I wasn't suggesting passing an array, carrying it around (or on=
 the stack for that manner) might be annoying...
> I was suggesting a budget (poll loops or a time bound - jiffy is usua=
lly well behaved).

Passing a small array to ip_poll_cq() is actually easy to do, and is
exactly equivalent to a poll budget. The struct ib_wc should be taken
off the stack anyway, IMO.

The only other example I see in 3.15 right now is IPoIB, which seems
to do exactly this.

I=92m testing a patch now. I=92d like to start simple and make it more
complex only if we need to.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
