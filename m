From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: rdma provider reregistration issue
Date: Mon, 11 Apr 2011 12:56:27 -0500
Message-ID: <4DA340CB.1040801@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

I discovered an issue while trying to support EEH events.  Currently, iw_cxgb4 will call ib_unregister_device() on an 
EEH event, and once the device has been reset, it will call ib_register_device() to reregister it.  However, I see a 
kobject warning during reregister:

kobject (c0000001785107b8): tried to init an initialized object, something is seriously wrong.
Call Trace:
[c00000017906f4f0] [c000000000012ca8] .show_stack+0x68/0x1b0 (unreliable)
[c00000017906f5a0] [c0000000002f4c04] .kobject_init+0xe4/0xf0
[c00000017906f630] [c0000000003ac6b4] .device_initialize+0x34/0xb0
[c00000017906f6c0] [c0000000003ad4a8] .device_register+0x18/0x30
[c00000017906f750] [d000000005e13d74] .ib_device_register_sysfs+0x84/0x2f0 [ib_core]
[c00000017906f810] [d000000005e15488] .ib_register_device+0x4e8/0x5f0 [ib_core]
[c00000017906f940] [d0000000067d7a94] .c4iw_register_device+0x374/0x470 [iw_cxgb4]
[c00000017906fa10] [d0000000067d01b8] .c4iw_uld_state_change+0xa8/0x1f0 [iw_cxgb4]
[c00000017906fac0] [d0000000063d1a0c] .notify_ulds+0x6c/0xd0 [cxgb4]
[c00000017906fb50] [d0000000063d2348] .cxgb_up+0x8d8/0xbc0 [cxgb4]
[c00000017906fc30] [d0000000063d2838] .eeh_slot_reset+0x208/0x240 [cxgb4]
[c00000017906fd00] [c00000000005fc2c] .eeh_report_reset+0x6c/0xe0
[c00000017906fd90] [c0000000003107e4] .pci_walk_bus+0xa4/0x140
[c00000017906fe50] [c00000000005f5ec] .handle_eeh_events+0x25c/0x460
[c00000017906ff00] [c00000000005fe18] .eeh_event_handler+0x128/0x1b0
[c00000017906ff90] [c000000000032024] .kernel_thread+0x54/0x70


I did some digging, and I think the issue has to do with a kobject reference kept on the device between 
ib_device_unregister_sysfs() and ib_dealloc_device().  I see this in ib_device_unregister_sysfs():

         /* Hold kobject until ib_dealloc_device() */
         kobject_get(&device->dev.kobj);

And this in ib_dealloc_device():

         kobject_put(&device->dev.kobj);

I have a feeling that due to this reference, the kobject never gets freed and thus on reregister, it gets initialized, 
but its already initialized generating the warning.

Is this a bug in the core code?  Or must RDMA providers always unregister + deallocate, then allocate + register?


Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
