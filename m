From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCHv1] nvmet-rdma: Fix missing dma sync to nvme data
 structures
Date: Tue, 17 Jan 2017 10:07:39 +0200
Message-ID: <77902aab-5d1c-5755-ca46-679d737f496d@grimberg.me>
References: <1484597945-31143-1-git-send-email-parav@mellanox.com>
 <ff2d3e9b-323c-aae5-f2dc-b18da5e0dc09@grimberg.me>
 <VI1PR0502MB30083D014DF2D4C0BEEA9F17D17D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30083D014DF2D4C0BEEA9F17D17D0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>> +	for (i = 0; i < 2; i++) {
>>> +		if (cmd->sge[i].length)
>>> +			ib_dma_sync_single_for_device(ndev->device,
>>> +				cmd->sge[0].addr, cmd->sge[0].length,
>>> +				DMA_FROM_DEVICE);
>>> +	}
>>
>> a. you test on sge[i] but sync sge[0].
> Crap code. I will fix this.
>
>> b. I don't think we need the for statement, lest keep it open-coded for [0]
>> and [1].
>
> I put for loop because, there was high level agreement in max_sge thread chain between Chuck, Steve and Jason about having generic sg_list/bounce buffer and doing things similar to RW APIs.
> Now if we generalize at that point, my thoughts were, that this code can eventually move out from every ULP to that generic send() API.
> So I put a for loop to make is more ULP agnostic from beginning.

Lets start simple and clear, if we indeed do this (and I should
checkout this discussion) we'll move it out like all the rest of
the ULPs.

>>>  	if (ndev->srq)
>>>  		return ib_post_srq_recv(ndev->srq, &cmd->wr, &bad_wr);
>> @@ -507,6
>>> +515,10 @@ static void nvmet_rdma_send_done(struct ib_cq *cq, struct
>> ib_wc *wc)
>>>  	struct nvmet_rdma_rsp *rsp =
>>>  		container_of(wc->wr_cqe, struct nvmet_rdma_rsp,
>> send_cqe);
>>>
>>> +	ib_dma_sync_single_for_cpu(rsp->queue->dev->device,
>>> +			rsp->send_sge.addr, rsp->send_sge.length,
>>> +			DMA_TO_DEVICE);
>>
>> Why do you need to sync_for_cpu here? you have no interest in the data at
>> this point.
>>
> Before a cqe can be prepared by cpu, it needs to be synced.
> So once CQE send is completed, that region is ready for preparing new CQE.
> In error case cqe is prepared by the RDMA layer and sent using nvmet_req_complete.
> In happy path case cqe is prepared by the core layer before invoking queue_response() callback of fabric_ops.
>
> In happy case nvmet-core needs to do the sync_to_cpu.
> In error case rdma layer needs to do the sync_to_cpu.
>
> Instead of messing code at both places, I did the sync_for_cpu in send_done() which is unified place.
> If there is generic callback in fabric_ops that can be invoked by __nvmet_req_complete(), than its cleaner to do at single place by invoking it.
> I didn't find it worth enough to increase fabric_ops for this.
> Let me know if you have different idea to resolve this.

Why not sync it when you start using the cmd at nvmet_rdma_recv_done()?
--
@@ -747,6 +747,10 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, 
struct ib_wc *wc)
         rsp->flags = 0;
         rsp->req.cmd = cmd->nvme_cmd;

+       ib_dma_sync_single_for_cpu(rsp->queue->dev->device,
+                       rsp->send_sge.addr, rsp->send_sge.length,
+                       DMA_TO_DEVICE);
+
         if (unlikely(queue->state != NVMET_RDMA_Q_LIVE)) {
                 unsigned long flags;
--

>
>>> nvmet_rdma_rsp *rsp)  static void nvmet_rdma_handle_command(struct
>> nvmet_rdma_queue *queue,
>>>  		struct nvmet_rdma_rsp *cmd)
>>>  {
>>> +	int i;
>>>  	u16 status;
>>>
>>>  	cmd->queue = queue;
>>>  	cmd->n_rdma = 0;
>>>  	cmd->req.port = queue->port;
>>>
>>> +	for (i = 0; i < 2; i++) {
>>> +		if (cmd->cmd->sge[i].length)
>>> +			ib_dma_sync_single_for_cpu(queue->dev->device,
>>> +				cmd->cmd->sge[i].addr, cmd->cmd-
>>> sge[i].length,
>>> +				DMA_FROM_DEVICE);
>>> +	}
>>
>> Again, we don't need the for statement.
>>
>> Also, I think we can optimize a bit by syncing the in-capsule page only if:
>> 1. it was posted for recv (sge has length) 2. its a write command 3. it has in-
>> capsule data.
>>
>> So, here lets sync the sqe (sge[0]) and sync the in-capsule page in
>> nvmet_rdma_map_sgl_inline().
>
> I agree Sagi that this can be differed to _inline(). I was headed to do this in generic code eventually similar to RW API.
> And thought why not have the clean code now so that migration later to new API would be easy.
> But if you think we should differ it to later stage, I am fine with that and continue with open coding.
>
> Now when I review the code of map_sgl_inline() I am wondering that we should not sync the INLINE data page at all because cpu is not going to read it anyway.
> Its only the remote device which will read/write and it will do the dma_sync_to_device as part of that driver anyway.

Yea, you're right. Let's kill it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
