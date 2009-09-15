From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Tue, 15 Sep 2009 14:51:17 -0600
Message-ID: <f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <4AAE909F.6030202@vlnb.net>
	 <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>
	 <e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
	 <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
	 <4AAFC42D.4030708@vlnb.net>
	 <f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
	 <4AAFC794.7090205@vlnb.net>
	 <f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
	 <4AAFCA77.6050305@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AAFCA77.6050305-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 15, 2009 at 11:10 AM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> =
wrote:
> Chris Worley, on 09/15/2009 09:01 PM wrote:
>>
>> On Tue, Sep 15, 2009 at 10:57 AM, Vladislav Bolkhovitin <vst-UyIK/FWETgo@public.gmane.org=
t>
>> wrote:
>>>
>>> Chris Worley, on 09/15/2009 08:53 PM wrote:
>>>>
>>>> On Tue, Sep 15, 2009 at 10:43 AM, Vladislav Bolkhovitin <vst@vlnb.=
net>
>>>> wrote:
>>>>>
>>>>> Chris Worley, on 09/15/2009 07:50 PM wrote:
>>>>>>
>>>>>> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
>>>>>> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>>
>>>>>>> On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys-Re5JQEeQqe8@public.gmane.org=
m>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin
>>>>>>>> <vst-d+Crzxg7Rs0@public.gmane.org>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>>>>>>>>>
>>>>>>>>>> I've definitely removed the switch/firmware from being the c=
ause.
>>>>>>>>>>
>>>>>>>>>> I'm thinking the reason you can't repeat the test may be lat=
ency
>>>>>>>>>> related. =A0We get ~50usecs average latency (on small block =
sizes),
>>>>>>>>>> which can't be achieved using regular SSD's (and rotating dr=
ives
>>>>>>>>>> are
>>>>>>>>>> nowhere close). =A0Maybe a ramdisk would help repeat the iss=
ue.
>>>>>>>>>
>>>>>>>>> I think you should try to reproduce the problem with ramdisk =
or
>>>>>>>>> nullio.
>>>>>>>>> By
>>>>>>>>> so you will eliminate possible influence of the SSD backend.
>>>>>>>>
>>>>>>>> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>>>>>>>>
>>>>>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>>>>>> dd if=3D/dev/zero of=3D/mnt/foo bs=3D1024k count=3D7000
>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>>>>>
>>>>>>>> Then, on the initiator, I tested it... and it hung during sequ=
ential
>>>>>>>> 8KB block reads:
>>>>>>>>
>>>>>>>> fio --rw=3Dread --bs=3D8k --numjobs=3D64 --iodepth=3D64 --sync=
=3D0 --direct=3D1
>>>>>>>> --randrepeat=3D0 \
>>>>>>>> =A0--group_reporting --ioengine=3Dlibaio --filename=3D/dev/sde=
 --name=3Dtest
>>>>>>>> --loops=3D10000 --runtime=3D600
>>>>>>>>
>>>>>>>> Note that I was running the SM on the target this time too.
>>>>>>>
>>>>>>> Which Linux distro was installed on the inititiator and on the =
target
>>>>>>> ? And if applicable, which OFED version ? Which kernel messages=
 were
>>>>>>> logged by SRPT around the time the issue occurred (after having
>>>>>>> enabled SRPT logging first) ?
>>>>>>
>>>>>> As logging hadn't helped this issue previously, I've not been en=
abling
>>>>>> it. =A0That plus the kernel hacks needed to invoke logging, it's=
 not
>>>>>> worth enabling.
>>>>>>
>>>>>> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server k=
ernel.
>>>>>>
>>>>>> I couldn't get ramdisks working w/ SCST in RHEL5.2. =A0When runn=
ing:
>>>>>>
>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>
>>>>>> I get the error:
>>>>>>
>>>>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>>>>> capabilities
>>>>>>
>>>>>> ... which doesn't occur in the Ubuntu kernel, so I've been unabl=
e to
>>>>>> test RHEL kernels w/ ramdisks. =A0In general, this problem occur=
s w/ 8KB
>>>>>> and smaller blocks w/ the Ubuntu kernels, and 2KB and smaller bl=
ocks
>>>>>> w/ RHEL kernels.
>>>>>
>>>>> Use ramfs instead.
>>>>
>>>> Do you mean:
>>>>
>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>
>>> You should then create a file on it and use it.
>>
>> That's what I'm doing, I believe. =A0From above:
>>
>>>>>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>>>>>> dd if=3D/dev/zero of=3D/mnt/foo bs=3D1024k count=3D7000
>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>
>> ... but the "open", on RHEL5.2 kernel 2.6.18-92.el5, generates the
>> following kernel messages:
>>
>> dev_vdisk: Registering virtual FILEIO device ramdisk
>> scst: Processing thread started, PID 9629
>> scst: Processing thread started, PID 9630
>> scst: Processing thread started, PID 9631
>> scst: Processing thread started, PID 9632
>> scst: Processing thread started, PID 9633
>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>> capabilities
>> scst: ***ERROR***: New device handler's vdisk attach() failed: -22
>> scst: Processing thread PID 9629 finished
>> scst: Processing thread PID 9630 finished
>> scst: Processing thread PID 9631 finished
>> scst: Processing thread PID 9632 finished
>> scst: Processing thread PID 9633 finished
>> scst: Failed to attach to virtual device ramdisk
>>
>> Chris
>>>>
>>>> ?
>>>>
>>>> That's what I'm doing.
>
> That's strange. I'm doing it all the time, although with not so old k=
ernels
> as 2.6.18.

In lots of testing today, I've seen this panic twice on the Ubuntu 8.10=
 targets:

[  330.155992] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  357.207046] ib_srpt: srpt_xmit_response: tag=3D 17 channel in bad st=
ate 2
[  357.207052] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  357.207100] ib_srpt: srpt_xmit_response: tag=3D 47 channel in bad st=
ate 2
[  357.207104] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  357.241429] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  357.250234] ------------[ cut here ]------------
[  357.250537] ib_srpt: srpt_xmit_response: tag=3D 26 channel in bad st=
ate 2
[  357.250539] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  357.250550] ib_srpt: srpt_xmit_response: tag=3D 38 channel in bad st=
ate 2
[  357.250553] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  357.250560] ib_srpt: srpt_xmit_response: tag=3D 27 channel in bad st=
ate 2
<repeated many times>
[  357.301253] kernel BUG at /root/scst/scst/src/scst_targ.c:3089!
[  357.301253] invalid opcode: 0000 [1] SMP
[  357.301253] CPU 0
=2E..
[  357.301253] RIP: 0010:[<ffffffffa04759f6>]  [<ffffffffa04759f6>]
scst_tgt_cmd_done+0x26/0x30 [scst]
[  357.301253] RSP: 0018:ffff88039ad27b50  EFLAGS: 00010297
[  357.301253] RAX: 0000000000000200 RBX: ffff8803ad9c68f8 RCX: 0000000=
000000000
[  357.301253] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff880=
3ad9c68f8
[  357.301253] RBP: ffff88039ad27b50 R08: 0000000000000000 R09: 0000000=
000000000
[  357.301253] R10: ffff88039ad277c0 R11: ffff88041ad278cf R12: ffff880=
3c2972180
[  357.301253] R13: ffff88039ada0000 R14: 0000000000000001 R15: ffff880=
3fb00c2b0
[  357.301253] FS:  0000000000000000(0000) GS:ffffffff807dd000(0000)
knlGS:0000000000000000
[  357.301253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  357.301253] CR2: 00007f9281e64000 CR3: 0000000000201000 CR4: 0000000=
0000006e0
[  357.301253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  357.301253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  357.301253] Process ib_cm/0 (pid: 8299, threadinfo
ffff88039ad26000, task ffff88039ad40000)
[  357.301253] Stack:  ffff88039ad27b80 ffffffffa04c0c47
ffff88039a8db900 ffff8803c2972180
[  357.301253]  ffff8803fb00c240 ffff8803fb00c284 ffff88039ad27bc0
ffffffffa04c0d93
[  357.301253]  ffff88042a4959c0 ffff88042a9d7800 ffff88042544da00
ffff88042a9d7898
[  357.301253] Call Trace:
[  357.301253]  [<ffffffffa04c0c47>] srpt_abort_scst_cmd+0xd7/0x160 [ib=
_srpt]
[  357.301253]  [<ffffffffa04c0d93>] srpt_release_channel+0xc3/0x190 [i=
b_srpt]
[  357.301253]  [<ffffffffa04c0e82>]
srpt_find_and_release_channel+0x22/0x30 [ib_srpt]
[  357.301253]  [<ffffffffa04c227d>] srpt_cm_handler+0x6d/0xbb8 [ib_srp=
t]
[  357.301253]  [<ffffffff80247526>] ? try_to_wake_up+0x126/0x2f0
[  357.301253]  [<ffffffff802476fd>] ? default_wake_function+0xd/0x10
[  357.301253]  [<ffffffff80267106>] ? autoremove_wake_function+0x16/0x=
40
[  357.301253]  [<ffffffff8023c99a>] ? __wake_up_common+0x5a/0x90
[  357.301253]  [<ffffffff8023dece>] ? __wake_up+0x4e/0x70
[  357.301253]  [<ffffffff80263271>] ? __queue_work+0x41/0x50
[  357.301253]  [<ffffffff8026331d>] ? queue_work_on+0x4d/0x60
[  357.301253]  [<ffffffff8026344f>] ? queue_work+0x1f/0x30
[  357.301253]  [<ffffffff8026350d>] ? queue_delayed_work+0x2d/0x40
[  357.301253]  [<ffffffffa0373255>] ? wait_for_response+0xd5/0xe0 [ib_=
mad]
[  357.301253]  [<ffffffffa04b4e07>] cm_process_work+0x27/0x130 [ib_cm]
[  357.301253]  [<ffffffffa04b5cf1>] cm_drep_handler+0xf1/0x180 [ib_cm]
[  357.301253]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  357.301253]  [<ffffffffa04b7895>] cm_work_handler+0x105/0x1b8 [ib_cm=
]
[  357.301253]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  357.301253]  [<ffffffff802628c2>] run_workqueue+0xc2/0x1a0
[  357.301253]  [<ffffffff80262bcf>] worker_thread+0xaf/0x130
[  357.301253]  [<ffffffff802670f0>] ? autoremove_wake_function+0x0/0x4=
0
[  357.301253]  [<ffffffff80262b20>] ? worker_thread+0x0/0x130
[  357.301253]  [<ffffffff80266cbe>] kthread+0x4e/0x90
[  357.301253]  [<ffffffff80213c99>] child_rip+0xa/0x11
[  357.301253]  [<ffffffff80266c70>] ? kthread+0x0/0x90
[  357.301253]  [<ffffffff80213c8f>] ? child_rip+0x0/0x11
[  357.301253]
[  357.301253]
[  357.301253] Code: 00 00 00 00 00 55 48 89 e5 e8 a7 cc d9 df 83 7f
28 78 75 17 80 67 2d f7 c7 47 28 0d 00 00 00 ba 01 00 00 00 e8 8c fc
ff ff c9 c3 <0f> 0b eb fe 66 0f 1f 44 00 00 55 48 89 e5 41 54 53 e8 74
cc d9
[  357.301253] RIP  [<ffffffffa04759f6>] scst_tgt_cmd_done+0x26/0x30 [s=
cst]
[  357.301253]  RSP <ffff88039ad27b50>
[  358.302745] ---[ end trace a7f20725e9471e16 ]---
[  384.258076] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  384.276974] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  384.290055] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  411.329136] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  411.348297] ib_srpt: srpt_xmit_response: tag=3D 24 channel in bad st=
ate 2
[  411.348301] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  411.348323] ib_srpt: srpt_xmit_response: tag=3D 20 channel in bad st=
ate 2
[  411.348326] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  411.348331] ib_srpt: srpt_xmit_response: tag=3D 42 channel in bad st=
ate 2
<many repeats>
[  411.349705] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  411.621319] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  411.629805] ib_srpt: srpt_xmit_response: tag=3D 38 channel in bad st=
ate 2
[  411.636690] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  411.636698] ------------[ cut here ]------------
[  411.636699] WARNING: at /root/scst/srpt/src/ib_srpt.c:924
srpt_abort_scst_cmd+0xac/0x160 [ib_srpt]()
=2E..
[  411.636735]
[  411.636736] Call Trace:
[  411.636742]  [<ffffffff8024eb14>] warn_on_slowpath+0x64/0x90
[  411.636747]  [<ffffffff802b3aa0>] ? free_hot_page+0x10/0x20
[  411.636750]  [<ffffffff802e2430>] ? __slab_free+0x10/0x120
[  411.636753]  [<ffffffff80234089>] ? __phys_addr+0x9/0x50
[  411.636757]  [<ffffffff803b3e1c>] ? swiotlb_unmap_sg_attrs+0x9c/0xc0
[  411.636759]  [<ffffffffa04c0c1c>] srpt_abort_scst_cmd+0xac/0x160 [ib=
_srpt]
[  411.636762]  [<ffffffffa04c0d93>] srpt_release_channel+0xc3/0x190 [i=
b_srpt]
[  411.636764]  [<ffffffffa04c0e82>]
srpt_find_and_release_channel+0x22/0x30 [ib_srpt]
[  411.636766]  [<ffffffffa04c227d>] srpt_cm_handler+0x6d/0xbb8 [ib_srp=
t]
[  411.636769]  [<ffffffff80247526>] ? try_to_wake_up+0x126/0x2f0
[  411.636771]  [<ffffffff802476fd>] ? default_wake_function+0xd/0x10
[  411.636774]  [<ffffffff80267106>] ? autoremove_wake_function+0x16/0x=
40
[  411.636776]  [<ffffffff8023c99a>] ? __wake_up_common+0x5a/0x90
[  411.636778]  [<ffffffff8023dece>] ? __wake_up+0x4e/0x70
[  411.636781]  [<ffffffff80263271>] ? __queue_work+0x41/0x50
[  411.636783]  [<ffffffff8026331d>] ? queue_work_on+0x4d/0x60
[  411.636784]  [<ffffffff8026344f>] ? queue_work+0x1f/0x30
[  411.636785]  [<ffffffff8026350d>] ? queue_delayed_work+0x2d/0x40
[  411.636790]  [<ffffffffa0373255>] ? wait_for_response+0xd5/0xe0 [ib_=
mad]
[  411.636794]  [<ffffffffa04b4e07>] cm_process_work+0x27/0x130 [ib_cm]
[  411.636797]  [<ffffffffa04b5cf1>] cm_drep_handler+0xf1/0x180 [ib_cm]
[  411.636799]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  411.636802]  [<ffffffffa04b7895>] cm_work_handler+0x105/0x1b8 [ib_cm=
]
[  411.636804]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  411.636806]  [<ffffffff802628c2>] run_workqueue+0xc2/0x1a0
[  411.636808]  [<ffffffff80262bcf>] worker_thread+0xaf/0x130
[  411.636809]  [<ffffffff802670f0>] ? autoremove_wake_function+0x0/0x4=
0
[  411.636811]  [<ffffffff80262b20>] ? worker_thread+0x0/0x130
[  411.636812]  [<ffffffff80266cbe>] kthread+0x4e/0x90
[  411.636815]  [<ffffffff80213c99>] child_rip+0xa/0x11
[  411.636816]  [<ffffffff80266c70>] ? kthread+0x0/0x90
[  411.636817]  [<ffffffff80213c8f>] ? child_rip+0x0/0x11
[  411.636818]
[  411.636819] ---[ end trace a7f20725e9471e16 ]---
[  411.636838] ------------[ cut here ]------------
[  411.636839] kernel BUG at /root/scst/scst/src/scst_targ.c:3089!
[  411.636840] invalid opcode: 0000 [2] SMP
[  411.636841] CPU 3
=2E..
[  411.636863] RIP: 0010:[<ffffffffa04759f6>]  [<ffffffffa04759f6>]
scst_tgt_cmd_done+0x26/0x30 [scst]
[  411.636874] RSP: 0018:ffff88039ad4fb50  EFLAGS: 00010297
[  411.636875] RAX: 0000000000000200 RBX: ffff880071d34558 RCX: 0000000=
0000213e2
[  411.636876] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff880=
071d34558
[  411.636877] RBP: ffff88039ad4fb50 R08: 0000000000000006 R09: 0000000=
000000000
[  411.636878] R10: ffff88039ad4f7c0 R11: ffff88041ad4f8cf R12: ffff880=
39af49240
[  411.636879] R13: ffff88039ada0000 R14: 0000000000000001 R15: ffff880=
3ad8b97f0
[  411.636881] FS:  0000000000000000(0000) GS:ffff88042e4f7080(0000)
knlGS:0000000000000000
[  411.636882] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  411.636883] CR2: 00007f9281e64000 CR3: 0000000000201000 CR4: 0000000=
0000006e0
[  411.636884] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  411.636885] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  411.636887] Process ib_cm/3 (pid: 8302, threadinfo
ffff88039ad4e000, task ffff88039ad44350)
[  411.636888] Stack:  ffff88039ad4fb80 ffffffffa04c0c47
ffff88039a995a80 ffff88039af49240
[  411.636890]  ffff8803ad8b9780 ffff8803ad8b97c4 ffff88039ad4fbc0
ffffffffa04c0d93
[  411.636891]  ffff88042a4959c0 ffff88042896f300 ffff88041801d800
ffff88042896f398
[  411.636893] Call Trace:
[  411.636895]  [<ffffffffa04c0c47>] srpt_abort_scst_cmd+0xd7/0x160 [ib=
_srpt]
[  411.636897]  [<ffffffffa04c0d93>] srpt_release_channel+0xc3/0x190 [i=
b_srpt]
[  411.636899]  [<ffffffffa04c0e82>]
srpt_find_and_release_channel+0x22/0x30 [ib_srpt]
[  411.636901]  [<ffffffffa04c227d>] srpt_cm_handler+0x6d/0xbb8 [ib_srp=
t]
[  411.636903]  [<ffffffff80247526>] ? try_to_wake_up+0x126/0x2f0
[  411.636905]  [<ffffffff802476fd>] ? default_wake_function+0xd/0x10
[  411.636906]  [<ffffffff80267106>] ? autoremove_wake_function+0x16/0x=
40
[  411.636908]  [<ffffffff8023c99a>] ? __wake_up_common+0x5a/0x90
[  411.636909]  [<ffffffff8023dece>] ? __wake_up+0x4e/0x70
[  411.636911]  [<ffffffff80263271>] ? __queue_work+0x41/0x50
[  411.636912]  [<ffffffff8026331d>] ? queue_work_on+0x4d/0x60
[  411.636914]  [<ffffffff8026344f>] ? queue_work+0x1f/0x30
[  411.636915]  [<ffffffff8026350d>] ? queue_delayed_work+0x2d/0x40
[  411.636918]  [<ffffffffa0373255>] ? wait_for_response+0xd5/0xe0 [ib_=
mad]
[  411.636921]  [<ffffffffa04b4e07>] cm_process_work+0x27/0x130 [ib_cm]
[  411.636923]  [<ffffffffa04b5cf1>] cm_drep_handler+0xf1/0x180 [ib_cm]
[  411.636926]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  411.636928]  [<ffffffffa04b7895>] cm_work_handler+0x105/0x1b8 [ib_cm=
]
[  411.636930]  [<ffffffffa04b7790>] ? cm_work_handler+0x0/0x1b8 [ib_cm=
]
[  411.636932]  [<ffffffff802628c2>] run_workqueue+0xc2/0x1a0
[  411.636934]  [<ffffffff80262bcf>] worker_thread+0xaf/0x130
[  411.636935]  [<ffffffff802670f0>] ? autoremove_wake_function+0x0/0x4=
0
[  411.636937]  [<ffffffff80262b20>] ? worker_thread+0x0/0x130
[  411.636938]  [<ffffffff80266cbe>] kthread+0x4e/0x90
[  411.636939]  [<ffffffff80213c99>] child_rip+0xa/0x11
[  411.636941]  [<ffffffff80266c70>] ? kthread+0x0/0x90
[  411.636942]  [<ffffffff80213c8f>] ? child_rip+0x0/0x11
[  411.636943]
[  411.636943]
[  411.636943] Code: 00 00 00 00 00 55 48 89 e5 e8 a7 cc d9 df 83 7f
28 78 75 17 80 67 2d f7 c7 47 28 0d 00 00 00 ba 01 00 00 00 e8 8c fc
ff ff c9 c3 <0f> 0b eb fe 66 0f 1f 44 00 00 55 48 89 e5 41 54 53 e8 74
cc d9
[  411.636954] RIP  [<ffffffffa04759f6>] scst_tgt_cmd_done+0x26/0x30 [s=
cst]
[  411.636960]  RSP <ffff88039ad4fb50>
[  411.636966] ---[ end trace a7f20725e9471e16 ]---
[  412.361070] ib_srpt: srpt_xmit_response: tag=3D 8 channel in bad sta=
te 2
[  412.367835] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  412.376335] ib_srpt: srpt_xmit_response: tag=3D 16 channel in bad st=
ate 2
[  412.383183] scst: ***ERROR***: Target driver ib_srpt
xmit_response() returned fatal error
[  412.391677] ib_srpt: srpt_xmit_response: tag=3D 47 channel in bad st=
ate 2
<many repeats>
[  456.831960] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  456.850851] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  456.863891] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  483.902158] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  483.921040] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  483.934101] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  510.971720] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  510.990587] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  511.003643] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  543.542817] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000055:0x24710000000055, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  543.563208] scst: Using security group "Default" for initiator
"0x00247100000000550024710000000055"
[  544.186067] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  544.204962] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  544.218003] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  571.256063] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  571.274934] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  571.287930] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  598.330955] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  598.349836] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  598.362854] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  625.400865] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  625.419753] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  625.432786] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  652.470722] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  652.489625] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  652.502814] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  679.540621] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  679.559503] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  679.572514] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  706.610483] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  706.629376] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  706.642369] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  733.680405] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  733.699243] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  733.712237] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  760.750170] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  760.769019] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  760.782038] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  800.108971] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  800.127840] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  800.140847] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  827.178873] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  827.197731] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  827.210717] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  854.248829] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  854.267662] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  854.280645] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  881.318906] ib_srpt: received SRP_LOGIN_REQ with i_port_id
0x24710000000046:0x24710000000046, t_port_id
0x24717124000028:0x24717124000028 and length 260 on port 1
(guid=3D0xfe80000000000000:0x24717124000029)
[  881.337874] ib_srpt: disconnected session
0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
been received.
[  881.351139] scst: Using security group "Default" for initiator
"0x00247100000000460024710000000046"
[  893.147951] BUG: unable to handle kernel paging request at ffffe3e00=
e700cc0
[  893.155156] IP: [<ffffffff802e2589>] kfree+0x49/0x100
[  893.157386] PGD 0
[  893.157386] Oops: 0000 [3] SMP
[  893.157386] CPU 2
=2E..
[  893.157386] RIP: 0010:[<ffffffff802e2589>]  [<ffffffff802e2589>]
kfree+0x49/0x100
[  893.157386] RSP: 0018:ffff88042e4d7ce0  EFLAGS: 00010216
[  893.157386] RAX: 000001e00e700cc0 RBX: ffffe3e00e700cc0 RCX: 0100000=
000002081
[  893.157386] RDX: ffffe20000000000 RSI: ffff88039accdf00 RDI: 0000000=
39c033000
[  893.157386] RBP: ffff88042e4d7d10 R08: 0000000000000000 R09: 0000000=
000000001
[  893.157386] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880=
3c09d7c20
[  893.157386] R13: 000000039c033000 R14: ffff88039a108240 R15: ffff880=
071dc4558
[  893.157386] FS:  0000000000000000(0000) GS:ffff88042fc02d00(0000)
knlGS:0000000000000000
[  893.157386] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  893.157386] CR2: ffffe3e00e700cc0 CR3: 0000000000201000 CR4: 0000000=
0000006e0
[  893.157386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  893.157386] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  893.157386] Process swapper (pid: 0, threadinfo ffff88042e4d2000,
task ffff88042e4cace0)
[  893.157386] Stack:  ffff88042e4d7cf0 0000000000000001
ffff8803c09d7c20 ffff88039accdf00
[  893.157386]  ffff88039a108240 ffff880071dc4558 ffff88042e4d7d80
ffffffffa04bf301
[  893.157386]  0000000000000000 ffffffff802e2430 ffffe20001c77100
0000000000000202
[  893.157386] Call Trace:
[  893.157386]  <IRQ>  [<ffffffffa04bf301>] srpt_reset_ioctx+0x41/0xf0 =
[ib_srpt]
[  893.157386]  [<ffffffff802e2430>] ? __slab_free+0x10/0x120
[  893.157386]  [<ffffffffa047b8f7>] ? scst_destroy_put_cmd+0x47/0x80 [=
scst]
[  893.157386]  [<ffffffffa04bf42d>] srpt_on_free_cmd+0x7d/0xa0 [ib_srp=
t]
[  893.157386]  [<ffffffffa047bc59>] scst_free_cmd+0x39/0x1a0 [scst]
[  893.157386]  [<ffffffffa0474c7d>]
scst_process_active_cmd+0x144d/0x1bd0 [scst]
[  893.157386]  [<ffffffffa04c180e>] ? srpt_completion+0x4e/0x230 [ib_s=
rpt]
[  893.157386]  [<ffffffffa047546d>] scst_do_job_active+0x6d/0x90 [scst=
]
[  893.157386]  [<ffffffffa04754b7>] scst_cmd_tasklet+0x27/0x40 [scst]
[  893.157386]  [<ffffffffa0348a7d>] ? mlx4_eq_int+0x7d/0x2a0 [mlx4_cor=
e]
[  893.157386]  [<ffffffff80254776>] tasklet_action+0x86/0x110
[  893.157386]  [<ffffffff80254e3c>] __do_softirq+0x8c/0x100
[  893.157386]  [<ffffffff8021417c>] call_softirq+0x1c/0x30
[  893.157386]  [<ffffffff80215875>] do_softirq+0x65/0xa0
[  893.157386]  [<ffffffff80254ba5>] irq_exit+0x95/0xa0
[  893.157386]  [<ffffffff80215b1b>] do_IRQ+0x8b/0x100
[  893.157386]  [<ffffffff80212f0e>] ret_from_intr+0x0/0x29
[  893.157386]  <EOI>  [<ffffffff8021aba2>] ? mwait_idle+0x52/0x60
[  893.157386]  [<ffffffff8021ab59>] ? mwait_idle+0x9/0x60
[  893.157386]  [<ffffffff80210e95>] ? cpu_idle+0x75/0x110
[  893.157386]  [<ffffffff804ff405>] ? start_secondary+0x97/0xc2
[  893.157386]
[  893.157386]
[  893.157386] Code: 01 f3 ff 48 83 ff 10 49 89 fd 0f 86 85 00 00 00
e8 0d 1b f5 ff 48 c1 e8 0c 48 ba 00 00 00 00 00 e2 ff ff 48 c1 e0 06
48 8d 1c 10 <48> 8b 03 f6 c4 40 74 07 48 8b 5b 10 48 8b 03 84 c0 0f 89
87 00
[  893.157386] RIP  [<ffffffff802e2589>] kfree+0x49/0x100
[  893.157386]  RSP <ffff88042e4d7ce0>
[  893.157386] CR2: ffffe3e00e700cc0
[  893.157386] ---[ end trace a7f20725e9471e16 ]---
[  893.533612] Kernel panic - not syncing: Aiee, killing interrupt hand=
ler!
[  893.540006] ------------[ cut here ]------------
[  893.540617] WARNING: at /build/buildd/linux-2.6.27/kernel/smp.c:332
smp_call_function_mask+0x22c/0x240()
=2E..
[  893.630002]
[  893.630002] Call Trace:
[  893.632644]  <IRQ>  [<ffffffff8024eb14>] warn_on_slowpath+0x64/0x90
[  893.640002]  [<ffffffff8023e8f3>] ? __enqueue_entity+0x93/0xa0
[  893.643556]  [<ffffffff8023fdd9>] ? enqueue_entity+0xd9/0x260
[  893.650002]  [<ffffffff802463f9>] ? enqueue_task_fair+0x59/0x60
[  893.660002]  [<ffffffff8023c460>] ? enqueue_task+0x50/0x60
[  893.661747]  [<ffffffff80245e9d>] ? resched_task+0x2d/0x90
[  893.670002]  [<ffffffff8027876c>] smp_call_function_mask+0x22c/0x240
[  893.672916]  [<ffffffff802256c0>] ? stop_this_cpu+0x0/0x40
[  893.680003]  [<ffffffff80502d69>] ? mutex_unlock+0x9/0x20
[  893.690003]  [<ffffffff80284d44>] ? crash_kexec+0x74/0x100
[  893.690515]  [<ffffffff80267106>] ? autoremove_wake_function+0x16/0x=
40
[  893.700002]  [<ffffffff8023c99a>] ? __wake_up_common+0x5a/0x90
[  893.703245]  [<ffffffff802787a0>] smp_call_function+0x20/0x30
[  893.710002]  [<ffffffff80225688>] native_smp_send_stop+0x28/0x60
[  893.720003]  [<ffffffff80501b7d>] panic+0xb4/0x177
[  893.721449]  [<ffffffff8026c3a1>] ? __blocking_notifier_call_chain+0=
x21/0x90
[  893.730002]  [<ffffffff8026c426>] ? blocking_notifier_call_chain+0x1=
6/0x20
[  893.740002]  [<ffffffff80253505>] do_exit+0x3f5/0x410
[  893.740638]  [<ffffffff80504ea0>] oops_begin+0x0/0xb0
[  893.750002]  [<ffffffff80506e60>] do_page_fault+0x270/0x790
[  893.751374]  [<ffffffff802b2816>] ? get_page_from_freelist+0x2a6/0x3=
80
[  893.760003]  [<ffffffff8026b3e1>] ? ktime_get_ts+0x61/0x70
[  893.764197]  [<ffffffff8026d0ac>] ? sched_clock_cpu+0xcc/0x160
[  893.770002]  [<ffffffff805045ea>] error_exit+0x0/0x70
[  893.780003]  [<ffffffff802e2589>] ? kfree+0x49/0x100
[  893.780898]  [<ffffffffa04bf301>] srpt_reset_ioctx+0x41/0xf0 [ib_srp=
t]
[  893.790003]  [<ffffffff802e2430>] ? __slab_free+0x10/0x120
[  893.793126]  [<ffffffffa047b8f7>] ? scst_destroy_put_cmd+0x47/0x80 [=
scst]
[  893.800002]  [<ffffffffa04bf42d>] srpt_on_free_cmd+0x7d/0xa0 [ib_srp=
t]
[  893.810002]  [<ffffffffa047bc59>] scst_free_cmd+0x39/0x1a0 [scst]
[  893.812078]  [<ffffffffa0474c7d>]
scst_process_active_cmd+0x144d/0x1bd0 [scst]
[  893.820002]  [<ffffffffa04c180e>] ? srpt_completion+0x4e/0x230 [ib_s=
rpt]
[  893.830005]  [<ffffffffa047546d>] scst_do_job_active+0x6d/0x90 [scst=
]
[  893.833429]  [<ffffffffa04754b7>] scst_cmd_tasklet+0x27/0x40 [scst]
[  893.840003]  [<ffffffffa0348a7d>] ? mlx4_eq_int+0x7d/0x2a0 [mlx4_cor=
e]
[  893.850003]  [<ffffffff80254776>] tasklet_action+0x86/0x110
[  893.852828]  [<ffffffff80254e3c>] __do_softirq+0x8c/0x100
[  893.860004]  [<ffffffff8021417c>] call_softirq+0x1c/0x30
[  893.864467]  [<ffffffff80215875>] do_softirq+0x65/0xa0
[  893.870005]  [<ffffffff80254ba5>] irq_exit+0x95/0xa0
[  893.880004]  [<ffffffff80215b1b>] do_IRQ+0x8b/0x100
[  893.880448]  [<ffffffff80212f0e>] ret_from_intr+0x0/0x29
[  893.890003]  <EOI>  [<ffffffff8021aba2>] ? mwait_idle+0x52/0x60
[  893.893008]  [<ffffffff8021ab59>] ? mwait_idle+0x9/0x60
[  893.900003]  [<ffffffff80210e95>] ? cpu_idle+0x75/0x110
[  893.902676]  [<ffffffff804ff405>] ? start_secondary+0x97/0xc2
[  893.910004]
[  893.913956] ---[ end trace a7f20725e9471e16 ]---

This may have been due to low memory, as I was using most target
memory for the ramdisk.

I do seem to be able to push the issue harder with:

fio --rw=3Drandrw --bs=3D1k --numjobs=3D64 --iodepth=3D64 --sync=3D0 \
    --direct=3D1 --randrepeat=3D0  --group_reporting --ioengine=3Dlibai=
o \
    --filename=3D/dev/sdp --name=3Dtest --loops=3D10000 --runtime=3D160=
0 \
    --rwmixread=3D100

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
