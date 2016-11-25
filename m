From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 188541] New: Function rsxx_pci_probe() does not set error code
 when the call to create_singlethread_workqueue() fails
Date: Fri, 25 Nov 2016 10:31:23 +0000
Message-ID: <bug-188541-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188541

            Bug ID: 188541
           Summary: Function rsxx_pci_probe() does not set error code when
                    the call to create_singlethread_workqueue() fails
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

Function create_singlethread_workqueue() returns a NULL pointer on failure. In
function rsxx_pci_probe() defined in file drivers/block/rsxx/core.c, variable
st keeps the error code, its value must be 0 at line 888. As a result, 0
(indicates no error) will be returned even when the call to function
create_singlethread_workqueue() at line 890 fails. Though this error may occur
rarely, it's better to explicitly assign "-ENOMEM" to st on the true branch of
the if-statement at line 891.

 758 static int rsxx_pci_probe(struct pci_dev *dev,
 759                     const struct pci_device_id *id)
 760 {
 761     struct rsxx_cardinfo *card;
 762     int st;
         ...
 876     card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl),
GFP_KERNEL);
 877     if (!card->ctrl) {
 878         st = -ENOMEM;
 879         goto failed_dma_setup;
 880     }
 881 
 882     st = rsxx_dma_setup(card);
 883     if (st) {
 884         dev_info(CARD_TO_DEV(card),
 885             "Failed to setup DMA engine\n");
 886         goto failed_dma_setup;
 887     }
 888     // the value of st must be 0 when the code reaches here
 889     /************* Setup Card Event Handler *************/
 890     card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 891     if (!card->event_wq) {
 892         dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
 893         goto failed_event_handler;          // insert "st = -ENOMEM"
before the jump instruction?
 894     }
         ...
 961     return 0;
 962 
 963 failed_create_dev:
 964     destroy_workqueue(card->event_wq);
 965     card->event_wq = NULL;
 966 failed_event_handler:
 967     rsxx_dma_destroy(card);
 968 failed_dma_setup:
 969 failed_compatiblity_check:
 970     destroy_workqueue(card->creg_ctrl.creg_wq);
 971     card->creg_ctrl.creg_wq = NULL;
         ...
 990 failed_ida_get:
 991     kfree(card);
 992 
 993     return st;
 994 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
