From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: crash on device removal
Date: Wed, 13 Jul 2016 13:02:18 +0300
Message-ID: <578611AA.4000103@grimberg.me>
References: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/07/16 19:34, Steve Wise wrote:
> Hey Christoph,
>
> I see a crash when shutting down a nvme host node via 'reboot' that has 1 target
> device attached.  The shutdown causes iw_cxgb4 to be removed which triggers the
> device removal logic in the nvmf rdma transport.  The crash is here:
>
> (gdb) list *nvme_rdma_free_qe+0x18
> 0x1e8 is in nvme_rdma_free_qe (drivers/nvme/host/rdma.c:196).
> 191     }
> 192
> 193     static void nvme_rdma_free_qe(struct ib_device *ibdev, struct
> nvme_rdma_qe *qe,
> 194                     size_t capsule_size, enum dma_data_direction dir)
> 195     {
> 196             ib_dma_unmap_single(ibdev, qe->dma, capsule_size, dir);
> 197             kfree(qe->data);
> 198     }
> 199
> 200     static int nvme_rdma_alloc_qe(struct ib_device *ibdev, struct
> nvme_rdma_qe *qe,
>
> Apparently qe is NULL.
>
> Looking at the device removal path, the logic appears correct (see
> nvme_rdma_device_unplug() and the nice function comment :) ).  I'm wondering if
> concurrently to the host device removal path cleaning up queues, the target is
> disconnecting all of its queues due to the first disconnect event from the host
> causing some cleanup race on the host side?  Although since the removal path
> executing in the cma event handler upcall, I don't think another thread would be
> handling a disconnect event.  Maybe the qp async event handler flow?

Hey Steve,

I never got this error (but didn't test with cxgb4, did this happen
with mlx4/5?). Can you track which qe is it? is it a request qe? is
it a rsp qe? is it the async qe?

Also, it would be beneficial to know which queue handled the event
(admin/io)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
