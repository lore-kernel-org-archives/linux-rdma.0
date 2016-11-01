From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Wed, 2 Nov 2016 00:34:57 +0200
Message-ID: <3512b8bb-4d29-b90a-49e1-ebf1085c47d7@grimberg.me>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com>
 <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me>
 <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com>
 <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me>
 <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com>
 <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me>
 <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com>
 <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me>
 <024e01d23476$6668b890$333a29b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <024e01d23476$6668b890$333a29b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> But:  I'll try this patch and run for a few hours and see what happens.  I
>>> believe regardless of a keep alive issue, the above patch is still needed.
>>
>> In your tests, can you enable dynamic debug on:
>> nvmet_start_keep_alive_timer
>> nvmet_stop_keep_alive_timer
>> nvmet_execute_keep_alive
>
> Hey Sagi.  I hit another crash on the target.  This was with 4.8.0 + the patch
> to skip disconnect events if the cm_id->qp is NULL. This time the crash is in
> _raw_spin_lock_irqsave() called by nvmet_rdma_recv_done().  The log is too big
> to include everything inline, but I'm attaching the full log as an attachment.
> Looks like at around 4988.169 seconds in the log, we see 5 controllers created,
> all named "controller 1"!  And 32 queues assigned to controller 1 5 times!  And
> shortly after that we hit the BUG.

So I think you're creating multiple subsystems and provision each
subsystem differently correct? the controller ids are unique within
a subsystem so two different subsystems can have ctrl id 1. Perhaps
our logging should mention the subsysnqn too?

Anyway, is there traffic going on?

The only way we can get recv_done with corrupted data is if we posted
something after the qp drain completed, can you check if that can happen?

Can you share your test case?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
