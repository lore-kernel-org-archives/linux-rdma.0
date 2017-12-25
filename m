From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Linux kernel v4.15-rc4 and rdma_rxe
Date: Mon, 25 Dec 2017 15:02:18 +0200
Message-ID: <CAG9sBKOOvvwG6yaQfWG=c04-LQ-Yvw8QbD-jzTm-zJYOFJeEVQ@mail.gmail.com>
References: <1513732236.2535.25.camel@wdc.com> <CAG9sBKP=i9ukbkj7x11oW=yLAz8u2RYHTMbf_Z1h3=nQ3pjfLw@mail.gmail.com>
 <1513983674.2579.27.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513983674.2579.27.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The call trace in my previous e-mail was caused by a bug in the SRP initiator
> driver. I will post the patches that fix that bug after the holidays. But even
> after having fixed that bug I noticed a remarkable behavior difference between
> the mlx4_ib and rxe drivers. ib_srpt channels get closed properly when using
> the mlx4 driver but not when using the rxe driver. The test I ran is as follows:
> * Clone, build and install the kernel from branch block-scsi-for-next of
>   repository https://github.com/bvanassche/linux. Make sure that the SRP
>   initiator and target drivers are enabled in the kernel config. I plan to post
>   all patches that are in that repository and that are not yet upstream after
>   the holidays.
> * Clone https://github.com/bvanassche/srp-test.
> * Edit /etc/multipath.conf as indicated in the README.md document in the
>   srp-test repository.
> * Start multipathd.
> * If I run the following command on a system with a ConnectX-3 adapter:
>     srp-test/run_tests -d -r 10 -t 02-mq
>   then the test finishes after about 11 seconds.
>   But if I run the following command on a system without any RDMA adapters:
>     srp-test/run_tests -c -d -r 10 -t 02-mq
>   then the following output appears:
>
> Unloaded the ib_srpt kernel module
> Unloaded the rdma_rxe kernel module
> SoftRoCE network interfaces: rxe0
> Zero-initializing /dev/ram0 ... done
> Zero-initializing /dev/ram1 ... done
> Zero-initializing /dev/sdb ... done
> Configured SRP target driver
> Running test /home/bart/software/infiniband/srp-test/tests/02-mq ...
> Test file I/O on top of multipath concurrently with logout and login (0 min; mq)
> Using /dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000 -> ../../dm-2
> Unmounting /root/mnt1 from /dev/mapper/mpathb
> SRP LUN /sys/class/scsi_device/5:0:0:0 / sdc: removing /dev/dm-2: done
> SRP LUN /sys/class/scsi_device/5:0:0:1 / sde: removing /dev/dm-1: done
> SRP LUN /sys/class/scsi_device/5:0:0:2 / sdd: removing /dev/dm-0: done
> Unloaded the ib_srp kernel module
> Test /home/bart/software/infiniband/srp-test/tests/02-mq succeeded
> 1 tests succeeded and 0 tests failed
>
> [ test script hangs ]
>
> While the test script hangs the following appears in the system log (please note
> that the ib_srpt:srpt_zerolength_write_done: ib_srpt wc->status message is missing):
>
> ib_srpt:srpt_close_ch: ib_srpt 192.168.122.76-32: queued zerolength write
> [ ... ]
> ib_srpt srpt_disconnect_ch_sync(192.168.122.76-18 state 3): still waiting ...
> [ ... ]
> INFO: task rmdir:3215 blocked for more than 120 seconds.
>       Not tainted 4.15.0-rc4-dbg+ #2
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rmdir           D13912  3215   3208 0x00000000
> Call Trace:
>  __schedule+0x2ad/0xb90
>  schedule+0x31/0x90
>  schedule_timeout+0x1fb/0x590
>  wait_for_completion_timeout+0x11a/0x180
>  srpt_close_session+0xba/0x180 [ib_srpt]
>  target_shutdown_sessions+0xc8/0xd0 [target_core_mod]
>  core_tpg_del_initiator_node_acl+0x7c/0x130 [target_core_mod]
>  target_fabric_nacl_base_release+0x20/0x30 [target_core_mod]
>  config_item_release+0x5a/0xc0 [configfs]
>  config_item_put+0x21/0x24 [configfs]
>  configfs_rmdir+0x1ef/0x2f0 [configfs]
>  vfs_rmdir+0x6e/0x150
>  do_rmdir+0x168/0x1c0
>  SyS_rmdir+0x11/0x20
>

Hi Bart
Thanks for the detailed answer.
1. I will do my best to add more tests to RXE regression. However, it
may take a while.
2. Differences in behavior doesn't necessarily mean that at least one
implementation is wrong. In what you describe it is hard to understand
what you think is wrong with RXE, If I understand it right the script
tried to delete a directory that ib_srpt owns (configs or such?) and
this operation waits for a completion. If this is right do you know
who is expected to call complete()? It sound unlikely that rxe is the
one.
3. Despite that, let's try this: when script hangs, can you run echo t
> /proc/sysrq-trigger and see if you something in dmesg that can
explain the hang? Maybe a trace that rdma_rxe is a part of it?

thanks
Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
