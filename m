From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 188601] New: Function ioat_xor_val_self_test() does not set
 error code when the call to dma_mapping_error() fails
Date: Fri, 25 Nov 2016 10:40:15 +0000
Message-ID: <bug-188601-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188601

            Bug ID: 188601
           Summary: Function ioat_xor_val_self_test() does not set error
                    code when the call to dma_mapping_error() fails
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
ioat_xor_val_self_test() defined in file drivers/dma/ioat/init.c, variable err
takes the error code. However, the value of err is 0 (indicates success) even
when the call to dma_mapping_error() fails at line 830. Though this error may
occur rarely, it is better to assign "-ENOMEM" to err when dma_mapping_error()
fails. 
There are other 3 similar bugs when the call to dma_mapping_error() fail at
lines 838, 907 and 960. Codes related to these bugs are summarised as follows.

ioat_xor_val_self_test @@ drivers/dma/ioat/init.c
 761 static int ioat_xor_val_self_test(struct ioatdma_device *ioat_dma)
 762 {
         ...
 775     int err = 0;
         ...
 819     dma_chan = container_of(dma->channels.next, struct dma_chan,
 820                 device_node);
 821     if (dma->device_alloc_chan_resources(dma_chan) < 1) {
 822         err = -ENODEV;
 823         goto out;
 824     }
 825 
 826     /* test xor */
 827     op = IOAT_OP_XOR;
 828 
 829     dest_dma = dma_map_page(dev, dest, 0, PAGE_SIZE, DMA_FROM_DEVICE);
 830     if (dma_mapping_error(dev, dest_dma))
 831         goto free_resources;    // insert "err = -ENOMEM" before this jump
instruction?
 832  
 833     for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
 834         dma_srcs[i] = DMA_ERROR_CODE;
 835     for (i = 0; i < IOAT_NUM_SRC_TEST; i++) {
 836         dma_srcs[i] = dma_map_page(dev, xor_srcs[i], 0, PAGE_SIZE,
 837                        DMA_TO_DEVICE);
 838         if (dma_mapping_error(dev, dma_srcs[i]))
 839             goto dma_unmap;    // insert "err = -ENOMEM" before this jump
instruction?
 840     }
         ...
 904     for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++) {
 905         dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
 906                        DMA_TO_DEVICE);
 907         if (dma_mapping_error(dev, dma_srcs[i]))
 908             goto dma_unmap;    // insert "err = -ENOMEM" before this jump
instruction?
 909     }
         ...
 957     for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++) {
 958         dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
 959                        DMA_TO_DEVICE);
 960         if (dma_mapping_error(dev, dma_srcs[i]))
 961             goto dma_unmap;    // insert "err = -ENOMEM" before this jump
instruction?
 962     }
         ...
1003 dma_unmap:
1004     if (op == IOAT_OP_XOR) {
1005         if (dest_dma != DMA_ERROR_CODE)
1006             dma_unmap_page(dev, dest_dma, PAGE_SIZE,
1007                        DMA_FROM_DEVICE);
1008         for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
1009             if (dma_srcs[i] != DMA_ERROR_CODE)
1010                 dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
1011                            DMA_TO_DEVICE);
1012     } else if (op == IOAT_OP_XOR_VAL) {
1013         for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
1014             if (dma_srcs[i] != DMA_ERROR_CODE)
1015                 dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
1016                            DMA_TO_DEVICE);
1017     }
1018 free_resources:
1019     dma->device_free_chan_resources(dma_chan);
1020 out:
1021     src_idx = IOAT_NUM_SRC_TEST;
1022     while (src_idx--)
1023         __free_page(xor_srcs[src_idx]);
1024     __free_page(dest);
1025     return err;
1026 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
