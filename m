From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] new ib_drain_qp() API
Date: Tue, 9 Feb 2016 16:18:43 -0500
Message-ID: <08D51C34-0009-4784-BE80-7BCB85441606@oracle.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com> <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com> <56BA540B.4040405@sandisk.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BA540B.4040405-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 9, 2016, at 4:03 PM, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> On 02/09/2016 12:50 PM, Steve Wise wrote:
>>>> This series creates a new helper API for draining a queue pair.  It is a
>>>> rework of an original patch created by Christoph Hellwig as part of the CQ
>>>> API rework and was dropped to be resubmitted by me with iw_cxgb4 support.
>>> 
>>> I finally got SRP running to test this series and it isn't working. :(  Anyway, there will be v3 posted once I fix it.
>>> 
>>> Steve.
>> 
>> The problem is SRP creates its SQ CQ with IB_POLL_DIRECT context, so the CQ is never armed for interrupts, and SRP polls the CQ
>> directly.  So the drain logic won't work.
>> 
>> I propose ib_drain_qp() takes a new parameter that tells it which queues to drain.  Then the SRP code will only drain the RQ (which
>> is what it is doing prior to this series).
> 
> Hello Steve,
> 
> How about creating three functions - one that drains the receive queue, one that drains the send queue and a third function that drains both ? The latter function then can call the two former functions. And since only one of these three functions will have a user in your patch series (the function that drains the RQ), how about only introducing only that function now and to wait with introducing the two other functions until these have a user ?

I would like xprtrdma to use the function that drains both.
Is that one of the functions that is being left out?

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
