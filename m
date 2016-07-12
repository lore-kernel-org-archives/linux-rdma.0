From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: crash on device removal
Date: Tue, 12 Jul 2016 16:09:05 -0500
Message-ID: <010201d1dc81$9f59cf10$de0d6d30$@opengridcomputing.com>
References: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com> <1468356054.5426.1.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468356054.5426.1.camel@ssi>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ming Lin' <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'sagig' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Tue, 2016-07-12 at 11:34 -0500, Steve Wise wrote:
> > Hey Christoph,
> >
> > I see a crash when shutting down a nvme host node via 'reboot' that has 1 target
> > device attached.  The shutdown causes iw_cxgb4 to be removed which triggers
> the
> > device removal logic in the nvmf rdma transport.  The crash is here:
> >
> > (gdb) list *nvme_rdma_free_qe+0x18
> > 0x1e8 is in nvme_rdma_free_qe (drivers/nvme/host/rdma.c:196).
> > 191     }
> > 192
> > 193     static void nvme_rdma_free_qe(struct ib_device *ibdev, struct
> > nvme_rdma_qe *qe,
> > 194                     size_t capsule_size, enum dma_data_direction dir)
> > 195     {
> > 196             ib_dma_unmap_single(ibdev, qe->dma, capsule_size, dir);
> > 197             kfree(qe->data);
> > 198     }
> > 199
> > 200     static int nvme_rdma_alloc_qe(struct ib_device *ibdev, struct
> > nvme_rdma_qe *qe,
> >
> > Apparently qe is NULL.
> >
> > Looking at the device removal path, the logic appears correct (see
> > nvme_rdma_device_unplug() and the nice function comment :) ).  I'm wondering
> if
> > concurrently to the host device removal path cleaning up queues, the target is
> > disconnecting all of its queues due to the first disconnect event from the host
> > causing some cleanup race on the host side?  Although since the removal path
> > executing in the cma event handler upcall, I don't think another thread would be
> > handling a disconnect event.  Maybe the qp async event handler flow?
> >
> > Thoughts?
> 
> We actually missed a kref_get in nvme_get_ns_from_disk().
> 
> This should fix it. Could you help to verify?
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 4babdf0..b146f52 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -183,6 +183,8 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct
> gendisk *disk)
>  	}
>  	spin_unlock(&dev_list_lock);
> 
> +	kref_get(&ns->ctrl->kref);
> +
>  	return ns;
> 
>  fail_put_ns:

Hey Ming.  This avoids the crash in nvme_rdma_free_qe(), but now I see another crash:

[  975.633436] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 10.0.1.14:4420
[  978.463636] nvme nvme0: creating 32 I/O queues.
[  979.187826] nvme nvme0: new ctrl: NQN "testnqn", addr 10.0.1.14:4420
[  987.778287] nvme nvme0: Got rdma device removal event, deleting ctrl
[  987.882202] BUG: unable to handle kernel paging request at ffff880e770e01f8
[  987.890024] IP: [<ffffffffa03a1a46>] __ib_process_cq+0x46/0xc0 [ib_core]

This looks like another problem with freeing the tag sets before stopping the QP.  I thought we fixed that once and for all, but perhaps there is some other path we missed. :(

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
