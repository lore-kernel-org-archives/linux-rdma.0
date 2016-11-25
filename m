From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 188591] New: Function ioat_dma_self_test() does not set error
 code when the call to dma_mapping_error() fails
Date: Fri, 25 Nov 2016 10:39:16 +0000
Message-ID: <bug-188591-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188591

            Bug ID: 188591
           Summary: Function ioat_dma_self_test() does not set error code
                    when the call to dma_mapping_error() fails
           Product: Drivers
           Version: 2.5
    Kernel Version: linux-4.9-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bianpan2010-AvrBmmDjM4YnDS1+zs4M5A@public.gmane.org
        Regression: No

Function dma_mapping_error() returns a NULL pointer on failure. In function
ioat_dma_self_test() defined in file drivers/dma/ioat/init.c, variable err
takes the error code. However, the value of err is 0 (indicates success) even
when the calls to dma_mapping_error() fail at line 341 or 346. Though this
error may occur rarely, it is better to assgin "-ENOMEM" to err before the jump
instructions at lines 343 and 348. Codes related to these two bugs are
summarised as follows.

ioat_dma_self_test @@ drivers/dma/ioat/init.c
 302 static int ioat_dma_self_test(struct ioatdma_device *ioat_dma)
 303 {
         ...
 313     int err = 0;
         ...
 332     dma_chan = container_of(dma->channels.next, struct dma_chan,
 333                 device_node);
 334     if (dma->device_alloc_chan_resources(dma_chan) < 1) {
 335         dev_err(dev, "selftest cannot allocate chan resource\n");
 336         err = -ENODEV;
 337         goto out;
 338     }
 339 
 340     dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 341     if (dma_mapping_error(dev, dma_src)) {
 342         dev_err(dev, "mapping src buffer failed\n");
 343         goto free_resources;      // insert "err = -ENOMEM" before this
jump instruction?
 344     }
 345     dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
 346     if (dma_mapping_error(dev, dma_dest)) {
 347         dev_err(dev, "mapping dest buffer failed\n");
 348         goto unmap_src;   // insert "err = -ENOMEM" before this jump
instruction?
 349     }
         ...
 387 unmap_dma:
 388     dma_unmap_single(dev, dma_dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
 389 unmap_src:
 390     dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 391 free_resources:
 392     dma->device_free_chan_resources(dma_chan);
 393 out:
 394     kfree(src);
 395     kfree(dest);
 396     return err;
 397 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
