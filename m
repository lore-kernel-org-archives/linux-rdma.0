From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: mlx5 driver unload hang
Date: Wed, 19 Feb 2014 08:43:46 +0100
Message-ID: <20140219084346.3a8794c1@b012350-ux>
References: <20140213095835.1ceae294@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213095835.1ceae294@b012350-ux>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Ping.

  Any info on this?

  Regards,

  S=C3=A9bastien.

On Thu, 13 Feb 2014 09:58:35 +0100
S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:

>   Hi,
>=20
>   I'm currently running tests with a Connect-IB board under the curre=
nt OFED-3.12 of the day:
>=20
>   - compat:	407b205 compat: Add kthread support for kernels <=3D 2.6.=
35
>   - compat-rdma: b2bda9f Fixed nfsrdma backport patch name
>   - linux-3.12:	f9e9918 Prepare Linux tree for OFED 3.12
>=20
>  =20
>   the board is:
>=20
> # mstflint -d mlx5_0 q
>=20
> -W- Running quick query - Skipping full image integrity checks.
>=20
> Image type:      FS3
> FW Version:      10.10.2000
> Device ID:       4113
> Chip Revision:   0
> Description:     UID                GuidsNumber  Step
> Base GUID1:      f4521403000bf580        8        1
> Base GUID2:      f4521403000bf588        8        1
> Base MAC1:       0000f452140bf580        8        1
> Base MAC2:       0000f452140bf588        8        1
> Image VSD:      =20
> Device VSD:     =20
> PSID:            MT_1220110019
>=20
>   When trying to restart the openibd service:
>=20
> # service openibd restart
>=20
>   here is what I get:
>=20
> INFO: task rmmod:22654 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> rmmod         D 0000000000000001     0 22654  22653 0x00000000
>  ffff88106f1b7b58 0000000000000082 0000000000000000 ffffffff81055f76
>  ffff88106f1b7ae8 ffff88107b0bb500 ffff88106f1b7ae8 ffffffff810522fd
>  ffff88107a8e9af8 ffff88106f1b7fd8 000000000000fb88 ffff88107a8e9af8
> Call Trace:
>  [<ffffffff81055f76>] ? enqueue_task+0x66/0x80
>  [<ffffffff810522fd>] ? check_preempt_curr+0x6d/0x90
>  [<ffffffff8150e555>] schedule_timeout+0x215/0x2e0
>  [<ffffffff81096c96>] ? autoremove_wake_function+0x16/0x40
>  [<ffffffff81051419>] ? __wake_up_common+0x59/0x90
>  [<ffffffff8150e1d3>] wait_for_common+0x123/0x180
>  [<ffffffff81063310>] ? default_wake_function+0x0/0x20
>  [<ffffffff810912b1>] ? __queue_work+0x41/0x50
>  [<ffffffff8150e2ed>] wait_for_completion+0x1d/0x20
>  [<ffffffffa05a3d18>] mlx5_cmd_exec+0x2d8/0x790 [mlx5_core]
>  [<ffffffffa05a583e>] mlx5_cmd_teardown_hca+0x5e/0x90 [mlx5_core]
>  [<ffffffffa05a10f9>] mlx5_dev_cleanup+0x69/0xe0 [mlx5_core]
>  [<ffffffffa05da3c9>] remove_one+0x59/0x70 [mlx5_ib]
>  [<ffffffff8129a047>] pci_device_remove+0x37/0x70
>  [<ffffffff8135e8bf>] __device_release_driver+0x6f/0xe0
>  [<ffffffff8135e9f8>] driver_detach+0xc8/0xd0
>  [<ffffffff8135d7fe>] bus_remove_driver+0x8e/0x110
>  [<ffffffff8135f1e2>] driver_unregister+0x62/0xa0
>  [<ffffffff8129a354>] pci_unregister_driver+0x44/0xb0
>  [<ffffffffa05e7349>] __exit_compat+0x15/0xbe [mlx5_ib]
>  [<ffffffff810b4814>] sys_delete_module+0x194/0x260
>  [<ffffffff8151311e>] ? do_page_fault+0x3e/0xa0
>  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
> 0000:01:00.0:wait_func:618:(pid 22654): TEARDOWN_HCA(0x103) timeout. =
Will cause a leak of a command resource
> 0000:01:00.0:mlx5_reclaim_startup_pages:419:(pid 22654): FW did not r=
eturn all pages. giving up...
> 0000:01:00.0:wait_func:618:(pid 22654): MLX5_CMD_OP_DISABLE_HCA(0x105=
) timeout. Will cause a leak of a command resource
> Compat-rdma backport release: 435a602-c
> Backport based on linux-3.12 385a572
> compat.git: linux-3.12
> mlx5_ib: Mellanox Connect-IB Infiniband driver v1.0 (June 2013)
> mlx5_ib 0000:01:00.0: firmware version: 10.10.2000
> 0000:01:00.0:wait_func:618:(pid 25331): MLX5_CMD_OP_ENABLE_HCA(0x104)=
 timeout. Will cause a leak of a command resource
> mlx5_ib 0000:01:00.0: enable hca failed
> mlx5_ib: probe of 0000:01:00.0 failed with error -110
>=20
>=20
>   It looks like the driver fails to tear down the HCA, leaving the de=
vice in a completely
> unstable state needing a reboot.
>=20
>   This behaviour is fully reproductible, although it _may_ succeed on=
ce or twice right
> after boot.
>=20
>   Is this a FW problem, a driver problem?
>=20
>   thanks,
>=20
>   S=C3=A9bastien.
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
