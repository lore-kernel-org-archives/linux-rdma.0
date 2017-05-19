From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Fri, 19 May 2017 12:17:52 -0400 (EDT)
Message-ID: <358169046.8629042.1495210672801.JavaMail.zimbra@redhat.com>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com> <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com> <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com> <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com> <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com> <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me> <20170319070115.GP2079@mtr-leonro.local> <136275928.8307994.1495126919829.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <136275928.8307994.1495126919829.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Finally found below patch [1] that fixed this issue.
With [1], I can see the speed of reset_controller operation[2] is obviously slow than before.


[1]
commit b7363e67b23e04c23c2a99437feefac7292a88bc
Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Date:   Wed Mar 8 22:03:17 2017 +0200

    IB/device: Convert ib-comp-wq to be CPU-bound

[2]
echo 1 >/sys/block/nvme0n1/device/reset_controller


Best Regards,
  Yi Zhang


----- Original Message -----
From: "Yi Zhang" <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
Sent: Friday, May 19, 2017 1:01:59 AM
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed during stress test on reset_controller

I retest this issue on 4.11.0, the OOM issue cannot be reproduced now on the same environment[1] with test script[2], not sure which patch fixed this issue?

And finally got reset_controller failed[3].

[1]
memory:32GB
CPU: Intel(R) Xeon(R) CPU E5-2665 0 @ 2.40GHz
Card: 07:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]

[2]
#!/bin/bash
num=0
while [ 1 ]
do
        echo "-------------------------------$num"
        echo 1 >/sys/block/nvme0n1/device/reset_controller || exit 1
        ((num++))
	sleep 0.1
done 

[3]
-------------------------------897
reset_controller.sh: line 7: /sys/block/nvme0n1/device/reset_controller: No such file or directory

Log from client:
[ 2373.319860] nvme nvme0: creating 16 I/O queues.
[ 2374.214380] nvme nvme0: creating 16 I/O queues.
[ 2375.092755] nvme nvme0: creating 16 I/O queues.
[ 2375.988591] nvme nvme0: creating 16 I/O queues.
[ 2376.874315] nvme nvme0: creating 16 I/O queues.
[ 2384.604400] nvme nvme0: rdma_resolve_addr wait failed (-110).
[ 2384.636329] nvme nvme0: Removing after reset failure


Best Regards,
  Yi Zhang


----- Original Message -----
From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Yi Zhang" <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sent: Sunday, March 19, 2017 3:01:15 PM
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed during stress test on reset_controller

On Thu, Mar 16, 2017 at 06:51:16PM +0200, Sagi Grimberg wrote:
>
> > > > > > Sagi,
> > > > > > The release function is placed in global workqueue. I'm not familiar
> > > > > > with NVMe design and I don't know all the details, but maybe the
> > > > > > proper way will
> > > > > > be to create special workqueue with MEM_RECLAIM flag to ensure the
> > > > > > progress?
>
> Leon, the release work makes progress, but it is inherently slower
> than the establishment work and when we are bombarded with
> establishments we have no backpressure...

Sagi,
How do you see that release is slower than alloc? In this specific
test, all queues are empty and QP drains should finish immediately.

If we rely on the prints that Yi posted in the beginning of this thread,
the release function doesn't have enough priority for execution and
constantly delayed.

>
> > I tried with 4.11.0-rc2, and still can reproduced it with less than 2000
> > times.
>
> Yi,
>
> Can you try the below (untested) patch:
>
> I'm not at all convinced this is the way to go because it will
> slow down all the connect requests, but I'm curious to know
> if it'll make the issue go away.
>
> --
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index ecc4fe862561..f15fa6e6b640 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1199,6 +1199,9 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id
> *cm_id,
>         }
>         queue->port = cm_id->context;
>
> +       /* Let inflight queue teardown complete */
> +       flush_scheduled_work();
> +
>         ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>         if (ret)
>                 goto release_queue;
> --
>
> Any other good ideas are welcome...

Maybe create separate workqueue and flush its only, instead of global
system queue.

It will stress the system a little bit less.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
Linux-nvme mailing list
Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
http://lists.infradead.org/mailman/listinfo/linux-nvme

_______________________________________________
Linux-nvme mailing list
Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
http://lists.infradead.org/mailman/listinfo/linux-nvme
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
