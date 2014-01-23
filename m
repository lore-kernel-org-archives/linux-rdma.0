From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: How to find what's holding uverbs from detaching an Infiniband SR-IOV
 VF?
Date: Thu, 23 Jan 2014 14:25:21 +0100
Message-ID: <52E11841.1020407@simula.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I am trying to detach an Infiniband SR-IOV Virtual Function with active 
communication (perftest ib_send_bw --rdma_cm is running) from a Virtual 
Machine, with the intention to eventually migrate it.

The problem in short (more details below):
What fails is that in the detach process, the code execution hangs in 
line wait_for_completion(&uverbs_dev->comp); called from the 
ib_uverbs_remove_one() function located in file 
drivers/infiniband/core/uverbs_main.c and the VF cannot be detached. How 
can I find what's holding the uverbs from being removed?

--------

In more detail:

I use Mellanox OFED distribution which supports SR-IOV 
(MLNX_OFED_LINUX-2.0-3.0.0-rhel6.4-x86_64) and my code changes all take 
place in kernel and userspace drivers of the virtual machine itself 
(nothing is changed in the drivers installed in the hypervisor), as I 
want to make the detach transparent to the user application.

A similar work by Wei Lin Guay has solved this problem as described in 
this presentation (found here: 
https://www.openfabrics.org/ofa-documents/presentations/doc_download/526-prototyping-live-migration-with-sr-iov-supported-infiniband.html), 
but following the same logic doesn't seem to work when I try to 
implement his ideas in the latest drivers.

My programming logic:
1. When a userspace app using Infiniband starts, it registers it's PID 
to the Kernel
2. When the pci hotplug asks for device removal, the kernel sends a 
signal to the registered PIDs in the userspace
3. The userspace library libmlx4 calls the
      - ibv_destroy_qp() for all active QPs.
      - rdma_destroy_event_channel() for the existing rdma event channels.
      - ibv_close_device() for the active uverbs devices.

Eventually I do not see any rdma_cm or uverbs0 file descriptors under 
/proc/PID/fd/ on the virtual machine, the device is not visible in the 
lspci command output, but it's still there in the ibstat command output. 
However, the device cannot be detached (and consequently migrate) until 
I kill the application manually by sending a SIGINT to it (ctrl+C).
For the moment I don't care if the connection is broken (from the 
application point of view).

Any advice is highly appreciated on how to find what's holding the 
uverbs which will enable a successful detach of the SR-IOV VF.

Thank you.

This is the Kernel Call Trace that I get after 120 seconds of waiting 
without killing the application manually:
INFO: task kacpi_hotplug:26 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kacpi_hotplug D 0000000000000000     0    26      2 0x00000000
  ffff88011de179b0 0000000000000046 ffff88011fe7fe00 0000000000000000
  ffff88011de17970 ffffffff81338ac0 ffff88011de17970 0000000000000012
  ffff88011de0e5f8 ffff88011de17fd8 000000000000fb88 ffff88011de0e5f8
Call Trace:
  [<ffffffff81338ac0>] ? vt_console_print+0x260/0x330
  [<ffffffff8106e585>] ? __call_console_drivers+0x75/0x90
  [<ffffffff8150efa5>] schedule_timeout+0x215/0x2e0
  [<ffffffff8106f341>] ? vprintk+0x251/0x560
  [<ffffffff8150ec23>] wait_for_common+0x123/0x180
  [<ffffffff81063410>] ? default_wake_function+0x0/0x20
  [<ffffffff8150ed3d>] wait_for_completion+0x1d/0x20
  [<ffffffffa0157125>] ib_uverbs_remove_one+0x85/0xb0 [ib_uverbs]
  [<ffffffffa016acdf>] ib_unregister_device+0x4f/0x100 [ib_core]
  [<ffffffffa0197be9>] mlx4_ib_remove+0x69/0x210 [mlx4_ib]
  [<ffffffffa0128de1>] mlx4_remove_device+0x71/0x90 [mlx4_core]
  [<ffffffffa0128e4b>] mlx4_unregister_device+0x4b/0xb0 [mlx4_core]
  [<ffffffffa012ab74>] mlx4_remove_one+0x94/0x360 [mlx4_core]
  [<ffffffff8109cfc5>] ? __blocking_notifier_call_chain+0x65/0x80
  [<ffffffff8129a4d7>] pci_device_remove+0x37/0x70
  [<ffffffff8135ef3f>] __device_release_driver+0x6f/0xe0
  [<ffffffff8135f0ad>] device_release_driver+0x2d/0x40
  [<ffffffff8135e293>] bus_remove_device+0xa3/0x100
  [<ffffffff8135bf3d>] device_del+0x12d/0x1e0
  [<ffffffff8135c012>] device_unregister+0x22/0x60
  [<ffffffff81293754>] pci_stop_bus_device+0x94/0xa0
  [<ffffffff812ab31a>] acpiphp_disable_slot+0x9a/0x1d0
  [<ffffffff812abd9d>] _handle_hotplug_event_func+0xed/0x1d0
  [<ffffffff8109708e>] ? prepare_to_wait+0x4e/0x80
  [<ffffffff812abcb0>] ? _handle_hotplug_event_func+0x0/0x1d0
  [<ffffffff81090be0>] worker_thread+0x170/0x2a0
  [<ffffffff81096da0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff81090a70>] ? worker_thread+0x0/0x2a0
  [<ffffffff81096a36>] kthread+0x96/0xa0
  [<ffffffff8100c0ca>] child_rip+0xa/0x20
  [<ffffffff810969a0>] ? kthread+0x0/0xa0
  [<ffffffff8100c0c0>] ? child_rip+0x0/0x20

Regards,
Vangelis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
