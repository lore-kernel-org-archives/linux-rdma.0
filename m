From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Thu, 17 Apr 2014 09:55:04 -0400
Message-ID: <A7E4B101-BAF0-480C-95AE-26BB845EE2C3@oracle.com>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com> <E9B601B5-1984-40D8-914A-DDD1380E8183@oracle.com> <534EA06A.7090200@dev.mellanox.co.il> <FC61F219-ACA2-4CE8-BF02-1B8EE2464639@oracle.com> <534F7D5F.1090908@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <534F7D5F.1090908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Apr 17, 2014, at 3:06 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 4/16/2014 9:21 PM, Chuck Lever wrote:
>> Passing a small array to ip_poll_cq() is actually easy to do, and is
>> exactly equivalent to a poll budget. The struct ib_wc should be take=
n
>> off the stack anyway, IMO.
>>=20
>> The only other example I see in 3.15 right now is IPoIB, which seems
>> to do exactly this.
>>=20
>> I=92m testing a patch now. I=92d like to start simple and make it mo=
re
>> complex only if we need to.
>=20
> What array size are you using? Note that if you use a small array it =
may be an overkill since
> a lot more interrupts are invoked (-> more latency). I found that for=
 a high workload a budget
> of 256/512/1024 keeps fairness and doesn't increase latency.

My array size is currently 4. It=92s a macro that can be changed easily=
=2E

By a very large majority, my workloads see only one WC per completion=20
upcall. However, I=92m using an older card with simple synthetic benchm=
arks.

I don=92t want to make the array large because struct ib_wc is at least
64 bytes on my systems =97 each WC array would be enormous and hardly e=
ver
used. But we can dial it in over time.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
