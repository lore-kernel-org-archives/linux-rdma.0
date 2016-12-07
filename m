From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Use ib_drain_qp instead of ib_drain_rq in ib_srp
Date: Thu, 8 Dec 2016 01:33:34 +0200
Message-ID: <45659b93-f938-9ed9-677a-5fe949e79381@mellanox.com>
References: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f@mellanox.com>
 <b2a1ed73-fb4c-07a5-c343-389bdc29501c@sandisk.com>
 <7ec8b32c-f813-5a86-b7e9-b1272bc28b2c@mellanox.com>
 <67507993-487f-d1fd-8a1d-76d8faa7cb96@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <67507993-487f-d1fd-8a1d-76d8faa7cb96-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/7/2016 3:04 AM, Bart Van Assche wrote:
> On 12/06/2016 02:01 AM, Max Gurtovoy wrote:
>> I understand why the beacon/drain is needed but I'm wondering if it's
>> enough draining only the recv_q/send_q of the qp.
>> These are 2 separate queues in the qp so receiving the beacon on the
>> recv_q, In theory doesn't ensure the all the send_q elements flushed.
>> Moreover if the cq is different for recv/send queues.
>> I can't prove it currently but I think I saw these happens when
>> developing iSER over FreeBSD (It was long time ago so it might have
>> happend because we posted stuff after posting the beacon).
>> In the current implementation we can't drain with IB_POLL_DIRECT ctx
>> (like srp send_cq) but we might think of implementation that can enable
>> it if needed.
>
> Hello Max,
>
> Do you agree with the approach of the attached two patches?
>
> Thanks,
>
> Bart.
>

Hi Bart,

thanks for the patches.
they will work in case of srp (the only user for DIRECT approach in the 
ULP's), but don't you think it's a hard requirment for the caller to 
ensure that no ib_poll_cq can be called during ib_set_cq_poll_context ?
There was some thought in the past to share cq's among ULP's that is 
currently on hold (in this approach we can't be sure other context don't 
call ib_poll_cq). In other hand we can avoid sharing DIRECT cq's.
Anyway, I thought of passing "struct ib_drain_cqe" as an arg to drain 
function from ULP and wait for completion (with tmo) in the ULP level, 
after direct ib_process_cq_direct.
I don't have an implementation yet, but I hope I explained my idea.

Thanks,
Max.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
