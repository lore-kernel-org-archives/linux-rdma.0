From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Thu, 16 Mar 2017 18:51:16 +0200
Message-ID: <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
 <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com>
 <20170310165214.GC14379@mtr-leonro.local>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
 <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
 <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7496c68a-15f3-d8cb-b17f-20f5a59a24d2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>>> Sagi,
>>>>> The release function is placed in global workqueue. I'm not familiar
>>>>> with NVMe design and I don't know all the details, but maybe the
>>>>> proper way will
>>>>> be to create special workqueue with MEM_RECLAIM flag to ensure the
>>>>> progress?

Leon, the release work makes progress, but it is inherently slower
than the establishment work and when we are bombarded with
establishments we have no backpressure...

> I tried with 4.11.0-rc2, and still can reproduced it with less than 2000
> times.

Yi,

Can you try the below (untested) patch:

I'm not at all convinced this is the way to go because it will
slow down all the connect requests, but I'm curious to know
if it'll make the issue go away.

--
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index ecc4fe862561..f15fa6e6b640 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1199,6 +1199,9 @@ static int nvmet_rdma_queue_connect(struct 
rdma_cm_id *cm_id,
         }
         queue->port = cm_id->context;

+       /* Let inflight queue teardown complete */
+       flush_scheduled_work();
+
         ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
         if (ret)
                 goto release_queue;
--

Any other good ideas are welcome...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
