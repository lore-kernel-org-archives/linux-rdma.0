From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Thu, 1 Oct 2015 12:37:36 -0400
Message-ID: <A5EE402A-82CE-49DC-8AB9-63EC340CE8DA@oracle.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net> <20150917204435.19671.56195.stgit@manet.1015granger.net> <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com> <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com> <55FE8C0F.1050706@dev.mellanox.co.il> <CANjDDBjcRXsPFt2Bd+9oL2wTBTxpDsAvN5PZN669dhTC7xSyqw@mail.gmail.com> <0804C887-9E32-4257-96D2-6C1FBC9CB271@oracle.com> <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Sep 22, 2015, at 1:32 PM, Devesh Sharma <devesh.sharma@avagotech.c=
om> wrote:
>=20
> On Mon, Sep 21, 2015 at 9:15 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>=20
>>> On Sep 21, 2015, at 1:51 AM, Devesh Sharma <devesh.sharma@avagotech=
=2Ecom> wrote:
>>>=20
>>> On Sun, Sep 20, 2015 at 4:05 PM, Sagi Grimberg <sagig-LDSdmyG8hGVEZ6tubOhOpQ@public.gmane.org=
co.il> wrote:
>>>>>> It is possible that in a given poll_cq
>>>>>> call you end up getting on 1 completion, the other completion is
>>>>>> delayed due to some reason.
>>>>>=20
>>>>>=20
>>>>> If a CQE is allowed to be delayed, how does polling
>>>>> again guarantee that the consumer can retrieve it?
>>>>>=20
>>>>> What happens if a signal occurs, there is only one CQE,
>>>>> but it is delayed? ib_poll_cq would return 0 in that
>>>>> case, and the consumer would never call again, thinking
>>>>> the CQ is empty. There's no way the consumer can know
>>>>> for sure when a CQ is drained.
>>>>>=20
>>>>> If the delayed CQE happens only when there is more
>>>>> than one CQE, how can polling multiple WCs ever work
>>>>> reliably?
>>>>>=20
>>>>> Maybe I don't understand what is meant by delayed.
>>>>>=20
>>>>=20
>>>> If I'm not mistaken, Devesh meant that if between ib_poll_cq (wher=
e you
>>>> polled the last 2 wcs) until the while statement another CQE was
>>>> generated then you lost a bit of efficiency. Correct?
>>>=20
>>> Yes, That's the point.
>>=20
>> I=E2=80=99m optimizing for the common case where 1 CQE is ready
>> to be polled. How much of an efficiency loss are you
>> talking about, how often would this loss occur, and is
>> this a problem for all providers / devices?
>=20
> The scenario would happen or not is difficult to predict, but its
> quite possible with any vendor based on load on PCI bus I guess.
> This may affect the latency figures though.
>=20
>>=20
>> Is this an issue for the current arrangement where 8 WCs
>> are polled at a time?
>=20
> Yes, its there even today.

This review comment does not feel closed yet. Maybe it=E2=80=99s
because I don=E2=80=99t understand exactly what the issue is.

Is this the problem that REPORT_MISSED_EVENTS is supposed to
resolve?=20

A missed WC will result in an RPC/RDMA transport deadlock. In
fact that is the reason for this particular patch (although
it addresses only one source of missed WCs). So I would like
to see that there are no windows here.

I=E2=80=99ve been told the only sure way to address this for every
provider is to use the classic but inefficient mechanism of
poll one WC at a time until no WC is returned; re-arm; poll
again until no WC is returned.

In the common case this means two extra poll_cq calls that
return nothing. So I claim the current status quo isn=E2=80=99t
good enough :-)

Doug and others have suggested the best place to address
problems with missed WC signals is in the drivers. All of
them should live up to the ib_poll_cq() API contract the
same way. In addition I=E2=80=99d really like to see

 - polling and arming work without having to perform extra
    unneeded locking of the CQ, and
 - polling arrays work without introducing races

Can we have that discussion now, since there is already
some discussion of IB core API fix-ups?


=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
