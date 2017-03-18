From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Sat, 18 Mar 2017 07:51:56 -0400 (EDT)
Message-ID: <1768681609.3995777.1489837916289.JavaMail.zimbra@redhat.com>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com> <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com> <20170310165214.GC14379@mtr-leonro.local> <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com> <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com> <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com> <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com> <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31678a43-f76c-a921-e40c-470b0de1a86c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi
With this path, the OOM cannot be reproduced now.

But there is another problem, the reset operation[1] failed at iteration 1007.
[1]
echo 1 >/sys/block/nvme0n1/device/reset_controller

Execution log:
-------------------------------1007
reset.sh: line 8: echo: write error: Device or resource busy

Server log:
Client side log:
[   55.712617] virbr0: port 1(virbr0-nic) entered listening state
[   55.880978] virbr0: port 1(virbr0-nic) entered disabled state
[  269.995587] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.2.3:1023
[  270.178461] nvme nvme0: creating 16 I/O queues.
[  270.624840] nvme nvme0: new ctrl: NQN "nvme-subsystem-name", addr 172.31.2.3:1023
[ 1221.955386] nvme nvme0: rdma_resolve_addr wait failed (-110).
[ 1221.987117] nvme nvme0: failed to initialize i/o queue: -110
[ 1222.013938] nvme nvme0: Removing after reset failure

Server side log:
[ 1211.370445] nvmet: creating controller 1 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:6ed0e109-0b81-4bda-9950-786d67c91b5d.
[ 1211.471407] nvmet: adding queue 1 to ctrl 1.
[ 1211.490980] nvmet: adding queue 2 to ctrl 1.
[ 1211.511142] nvmet: adding queue 3 to ctrl 1.
[ 1211.530775] nvmet: adding queue 4 to ctrl 1.
[ 1211.550138] nvmet: adding queue 5 to ctrl 1.
[ 1211.569147] nvmet: adding queue 6 to ctrl 1.
[ 1211.588649] nvmet: adding queue 7 to ctrl 1.
[ 1211.608043] nvmet: adding queue 8 to ctrl 1.
[ 1211.626965] nvmet: adding queue 9 to ctrl 1.
[ 1211.646310] nvmet: adding queue 10 to ctrl 1.
[ 1211.666774] nvmet: adding queue 11 to ctrl 1.
[ 1211.686848] nvmet: adding queue 12 to ctrl 1.
[ 1211.706654] nvmet: adding queue 13 to ctrl 1.
[ 1211.726504] nvmet: adding queue 14 to ctrl 1.
[ 1211.747046] nvmet: adding queue 15 to ctrl 1.
[ 1211.767842] nvmet: adding queue 16 to ctrl 1.
[ 1211.822222] nvmet_rdma: freeing queue 0
[ 1211.840225] nvmet_rdma: freeing queue 1
[ 1211.840301] nvmet_rdma: freeing queue 12
[ 1211.841740] nvmet_rdma: freeing queue 13
[ 1211.843222] nvmet_rdma: freeing queue 14
[ 1211.844511] nvmet_rdma: freeing queue 15
[ 1211.846102] nvmet_rdma: freeing queue 16
[ 1211.946919] nvmet_rdma: freeing queue 2
[ 1211.964700] nvmet_rdma: freeing queue 3
[ 1211.982548] nvmet_rdma: freeing queue 4
[ 1212.001528] nvmet_rdma: freeing queue 5
[ 1212.020271] nvmet_rdma: freeing queue 6
[ 1212.038598] nvmet_rdma: freeing queue 7
[ 1212.048886] nvmet: creating controller 2 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:6ed0e109-0b81-4bda-9950-786d67c91b5d.
[ 1212.120320] nvmet_rdma: freeing queue 8
[ 1212.860605] nvmet_rdma: freeing queue 9
[ 1214.039350] nvmet_rdma: freeing queue 10
[ 1215.244894] nvmet_rdma: freeing queue 11
[ 1216.235774] nvmet_rdma: failed to connect queue 0
[ 1216.256877] nvmet_rdma: freeing queue 0
[ 1217.356506] nvmet_rdma: freeing queue 17



Best Regards,
  Yi Zhang


----- Original Message -----
From: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
To: "Yi Zhang" <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Sent: Friday, March 17, 2017 12:51:16 AM
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed during stress test on reset_controller


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

_______________________________________________
Linux-nvme mailing list
Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
http://lists.infradead.org/mailman/listinfo/linux-nvme
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
