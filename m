From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Tue, 1 Nov 2016 18:15:55 +0200
Message-ID: <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01b401d23458$af277210$0d765630$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hey guys,
>
> I just hit an nvmf target NULL pointer deref BUG after a few hours of keep-alive
> timeout testing.  It appears that nvmet_rdma_cm_handler() was called with
> cm_id->qp == NULL, so the local nvmet_rdma_queue * variable queue is left as
> NULL.  But then nvmet_rdma_queue_disconnect() is called with queue == NULL which
> causes the crash.

AFAICT, the only way cm_id->qp is NULL is for a scenario we didn't even
get to allocate a queue-pair (e.g. calling rdma_create_qp). The teardown
paths does not nullify cm_id->qp...

Are you sure that the flow is indeed DISCONNECTED event?

> In the log, I see that the target side keep-alive fired:
>
> [20676.867545] eth2: link up, 40Gbps, full-duplex, Tx/Rx PAUSE
> [20677.079669] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
> [20677.079684] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!

Wow, two keep-alive timeouts on the same controller? that is
seriously wrong...


> [20677.088402] nvmet_rdma: freeing queue 276
> [20677.090981] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000120
> [20677.090988] IP: [<ffffffffa084b6b4>] nvmet_rdma_queue_disconnect+0x24/0x90
> [nvmet_rdma]

No stack trace?

>
>
> So maybe there is just a race in that keep-alive can free the queue and yet a
> DISCONNECTED event still received on the cm_id after the queue is freed?

rdma_destroy_id should barrier this scenario.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
