From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Tue, 22 Sep 2015 23:02:57 +0530
Message-ID: <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug@mail.gmail.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
 <20150917204435.19671.56195.stgit@manet.1015granger.net> <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com>
 <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com> <55FE8C0F.1050706@dev.mellanox.co.il>
 <CANjDDBjcRXsPFt2Bd+9oL2wTBTxpDsAvN5PZN669dhTC7xSyqw@mail.gmail.com> <0804C887-9E32-4257-96D2-6C1FBC9CB271@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0804C887-9E32-4257-96D2-6C1FBC9CB271-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 21, 2015 at 9:15 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> w=
rote:
>
>> On Sep 21, 2015, at 1:51 AM, Devesh Sharma <devesh.sharma@avagotech.=
com> wrote:
>>
>> On Sun, Sep 20, 2015 at 4:05 PM, Sagi Grimberg <sagig-LDSdmyG8hGXFtvusC2JeyQ@public.gmane.org=
o.il> wrote:
>>>>> It is possible that in a given poll_cq
>>>>> call you end up getting on 1 completion, the other completion is
>>>>> delayed due to some reason.
>>>>
>>>>
>>>> If a CQE is allowed to be delayed, how does polling
>>>> again guarantee that the consumer can retrieve it?
>>>>
>>>> What happens if a signal occurs, there is only one CQE,
>>>> but it is delayed? ib_poll_cq would return 0 in that
>>>> case, and the consumer would never call again, thinking
>>>> the CQ is empty. There's no way the consumer can know
>>>> for sure when a CQ is drained.
>>>>
>>>> If the delayed CQE happens only when there is more
>>>> than one CQE, how can polling multiple WCs ever work
>>>> reliably?
>>>>
>>>> Maybe I don't understand what is meant by delayed.
>>>>
>>>
>>> If I'm not mistaken, Devesh meant that if between ib_poll_cq (where=
 you
>>> polled the last 2 wcs) until the while statement another CQE was
>>> generated then you lost a bit of efficiency. Correct?
>>
>> Yes, That's the point.
>
> I=E2=80=99m optimizing for the common case where 1 CQE is ready
> to be polled. How much of an efficiency loss are you
> talking about, how often would this loss occur, and is
> this a problem for all providers / devices?

The scenario would happen or not is difficult to predict, but its
quite possible with any vendor based on load on PCI bus I guess.
This may affect the latency figures though.

>
> Is this an issue for the current arrangement where 8 WCs
> are polled at a time?

Yes, its there even today.

>
>
> =E2=80=94
> Chuck Lever
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
