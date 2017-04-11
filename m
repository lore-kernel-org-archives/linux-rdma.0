From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH v2] nvme-rdma: support devices with queue size < 32
Date: Tue, 11 Apr 2017 10:52:08 +0200 (CEST)
Message-ID: <1807354347.364485979.1491900728245.JavaMail.zimbra@kalray.eu>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu> <1491838338.4199.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491838338.4199.5.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, 2017-04-10 at 17:12 +0200, Marta Rybczynska wrote:
>> In the case of small NVMe-oF queue size (<32) we may enter
>> a deadlock caused by the fact that the IB completions aren't sent
>> waiting for 32 and the send queue will fill up.
>> 
>> The error is seen as (using mlx5):
>> [ 2048.693355] mlx5_0:mlx5_ib_post_send:3765:(pid 7273):
>> [ 2048.693360] nvme nvme1: nvme_rdma_post_send failed with error code -12
>> 
>> This patch changes the way the signaling is done so
>> that it depends on the queue depth now. The magic define has
>> been removed completely.
>> 
>> Signed-off-by: Marta Rybczynska <marta.rybczynska-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
>> Signed-off-by: Samuel Jones <sjones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
>> ---
>> Changes from v1:
>> * signal by queue size/2, remove hardcoded 32
>> * support queue depth of 1
>> 
>>  drivers/nvme/host/rdma.c | 17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
>> index 47a479f..4de1b92 100644
>> --- a/drivers/nvme/host/rdma.c
>> +++ b/drivers/nvme/host/rdma.c
>> @@ -1029,6 +1029,18 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct
>> ib_wc *wc)
>>                 nvme_rdma_wr_error(cq, wc, "SEND");
>>  }
>>  
>> +static inline nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
>> +{
>> +       int sig_limit;
>> +
>> +       /* We signal completion every queue depth/2 and also
>> +        * handle the case of possible device with queue_depth=1,
>> +        * where we would need to signal every message.
>> +        */
>> +       sig_limit = max(queue->queue_size / 2, 1);
>> +       return (++queue->sig_count % sig_limit) == 0;
>> +}
>> +
>>  static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
>>                 struct nvme_rdma_qe *qe, struct ib_sge *sge, u32 num_sge,
>>                 struct ib_send_wr *first, bool flush)
>> @@ -1056,9 +1068,6 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue
>> *queue,
>>          * Would have been way to obvious to handle this in hardware or
>>          * at least the RDMA stack..
>>          *
>> -        * This messy and racy code sniplet is copy and pasted from the iSER
>> -        * initiator, and the magic '32' comes from there as well.
>> -        *
>>          * Always signal the flushes. The magic request used for the flush
>>          * sequencer is not allocated in our driver's tagset and it's
>>          * triggered to be freed by blk_cleanup_queue(). So we need to
>> @@ -1066,7 +1075,7 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue
>> *queue,
>>          * embedded in request's payload, is not freed when __ib_process_cq()
>>          * calls wr_cqe->done().
>>          */
>> -       if ((++queue->sig_count % 32) == 0 || flush)
>> +       if (nvme_rdma_queue_sig_limit(queue) || flush)
>>                 wr.send_flags |= IB_SEND_SIGNALED;
>>  
>>         if (first)
> 
> Hello Marta,
> 
> The approach of this patch is suboptimal from a performance point of view.
> If the number of WRs that have been submitted since the last signaled WR
> was submitted would be tracked in a member variable that would allow to
> get rid of the (relatively slow) division operation.
> 

Hello Bart,
I think that we can remove the division (the modulo sig_limit). The sig_count
is an u8 so it is really a type of variable you propose. It isn't used anywhere
it seems so we can change the way it is used in the snippet to count until the
signaling moment. It will give something like:

static inline nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
{
       int sig_limit;

       /* We signal completion every queue depth/2 and also
        * handle the case of possible device with queue_depth=1,
        * where we would need to signal every message.
        */
       sig_limit = max(queue->queue_size / 2, 1);
       queue->sig_count++;
       if (queue->sig_count < sig_limit)
           return 0;
       queue->sig_count = 0;
       return 1;
}


Do you like it better?

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
