From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/3] nvme-rdma: use rdma_reject_msg() to log
 connection rejects
Date: Sat, 22 Oct 2016 00:48:06 +0300
Message-ID: <c2080444-9258-1bb4-83e2-7f6cef161ec3@grimberg.me>
References: <cover.1477003235.git.swise@opengridcomputing.com>
 <60243a2ce17e08cdc93600b9998698dbd7f83306.1477003235.git.swise@opengridcomputing.com>
 <20161021122318.GB17325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021122318.GB17325-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Given the nasty casting issues in the current RDMA/CM API maybe we should
> actually expand the scope of the rdma_consumer_reject helper to include
> the above check, e.g. check that there is a private data len and then
> return a pointer to the private data?
>
> Something like
>
> static int nvme_rdma_conn_rejected(struct nvme_rdma_queue *queue,
> 		struct rdma_cm_event *ev)
> {
> 	struct rdma_cm_id *cm_id = queue->cm_id;
> 	struct nvme_rdma_cm_rej *rej
> 	short nvme_status = -1;
>
> 	rej = rdma_cm_reject_message(ev);
> 	if (rej)
> 		nvme_status = le16_to_cpu(rej->sts);
>

Looks nicer...

>>
>> +	dev_err(queue->ctrl->ctrl.device, "Connect rejected: status %d (%s) "
>> +		"nvme status %d.\n", rdma_status,
>> +		rdma_reject_msg(cm_id, rdma_status), nvme_status);
>
> And while we're pretty printing the rest it would be nice to pretty
> print the NVMe status here as well.

Would be nice...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
