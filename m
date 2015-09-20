From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Sun, 20 Sep 2015 13:35:59 +0300
Message-ID: <55FE8C0F.1050706@dev.mellanox.co.il>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
 <20150917204435.19671.56195.stgit@manet.1015granger.net>
 <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com>
 <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A3B1A836-81AF-40E6-B551-587B7173B72D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> It is possible that in a given poll_cq
>> call you end up getting on 1 completion, the other completion is
>> delayed due to some reason.
>
> If a CQE is allowed to be delayed, how does polling
> again guarantee that the consumer can retrieve it?
>
> What happens if a signal occurs, there is only one CQE,
> but it is delayed? ib_poll_cq would return 0 in that
> case, and the consumer would never call again, thinking
> the CQ is empty. There's no way the consumer can know
> for sure when a CQ is drained.
>
> If the delayed CQE happens only when there is more
> than one CQE, how can polling multiple WCs ever work
> reliably?
>
> Maybe I don't understand what is meant by delayed.
>

If I'm not mistaken, Devesh meant that if between ib_poll_cq (where you
polled the last 2 wcs) until the while statement another CQE was
generated then you lost a bit of efficiency. Correct?

>
>> Would it be better to poll for 1 in every
>> poll call Or
>> otherwise have this
>> while ( rc <= ARRAY_SIZE(wcs) && rc);
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
