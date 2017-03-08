From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/cq: Don't process more than the given budget
Date: Thu, 9 Mar 2017 00:59:55 +0200
Message-ID: <61849961-0397-698b-20d8-44f26bad9673@grimberg.me>
References: <1489003801-4410-1-git-send-email-sagi@grimberg.me>
 <1489010916.2813.4.camel@sandisk.com> <20170308221227.GA447@lst.de>
 <1489011263.2813.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489011263.2813.9.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> -	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
>>>> +	while ((n = ib_poll_cq(cq, min(IB_POLL_BATCH, budget - completed),
>>>> +			cq->wc)) > 0) {
>>>>  		for (i = 0; i < n; i++) {
>>>>  			struct ib_wc *wc = &cq->wc[i];
>>>>
>>>
>>> This breaks the SRP initiator driver since that driver can pass -1 as budget.
>>
>> Good point, we'd need to special case that.
>
> How about using min_t(u32, IB_POLL_BATCH, budget - completed)?

Yep, I'll do that, thanks Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
