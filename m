From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Wed, 16 Sep 2009 13:41:20 -0600
Message-ID: <f3177b9e0909161241h89dabdbybaf98edc5b10f735@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
	 <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
	 <4AAFC42D.4030708@vlnb.net>
	 <f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
	 <4AAFC794.7090205@vlnb.net>
	 <f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
	 <4AAFCA77.6050305@vlnb.net>
	 <f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
	 <4AB12B40.9050902@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB12B40.9050902-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2009 at 12:15 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> =
wrote:
> Chris Worley, on 09/16/2009 12:51 AM wrote:
>>
>> On Tue, Sep 15, 2009 at 11:10 AM, Vladislav Bolkhovitin <vst-UyIK/FWETgo@public.gmane.org=
t>
>> wrote:
>>>
>>> Chris Worley, on 09/15/2009 09:01 PM wrote:
>>>>
>>>> On Tue, Sep 15, 2009 at 10:57 AM, Vladislav Bolkhovitin <vst@vlnb.=
net>
>>>> wrote:
>>>>>
>>>>> Chris Worley, on 09/15/2009 08:53 PM wrote:
>>>>>>
>>>>>> On Tue, Sep 15, 2009 at 10:43 AM, Vladislav Bolkhovitin <vst@vln=
b.net>
>>>>>> wrote:
>>>>>>>
>>>>>>> Chris Worley, on 09/15/2009 07:50 PM wrote:
>>>>>>>>
>>>>>>>> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
>>>>>>>> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>>>>
>>>>>>>>> On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys@gmail.=
com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin
>>>>>>>>>> <vst-d+Crzxg7Rs0@public.gmane.org>
>>>>>>>>>> wrote:
>>>>>>>>>>>
>>>>>>>>>>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> I've definitely removed the switch/firmware from being the
>>>>>>>>>>>> cause.
>>>>>>>>>>>>
>>>>>>>>>>>> I'm thinking the reason you can't repeat the test may be l=
atency
>>>>>>>>>>>> related. =A0We get ~50usecs average latency (on small bloc=
k
>>>>>>>>>>>> sizes),
>>>>>>>>>>>> which can't be achieved using regular SSD's (and rotating =
drives
>>>>>>>>>>>> are
>>>>>>>>>>>> nowhere close). =A0Maybe a ramdisk would help repeat the i=
ssue.
>>>>>>>>>>>
>>>>>>>>>>> I think you should try to reproduce the problem with ramdis=
k or
>>>>>>>>>>> nullio.
>>>>>>>>>>> By
>>>>>>>>>>> so you will eliminate possible influence of the SSD backend=
=2E
>>>>>>>>>>
>>>>>>>>>> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>>>>>>>>>>
>>>>>>>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>>>>>>>> dd if=3D/dev/zero of=3D/mnt/foo bs=3D1024k count=3D7000
>>>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>>>>>>>
>>>>>>>>>> Then, on the initiator, I tested it... and it hung during
>>>>>>>>>> sequential
>>>>>>>>>> 8KB block reads:
>>>>>>>>>>
>>>>>>>>>> fio --rw=3Dread --bs=3D8k --numjobs=3D64 --iodepth=3D64 --sy=
nc=3D0
>>>>>>>>>> --direct=3D1
>>>>>>>>>> --randrepeat=3D0 \
>>>>>>>>>> =A0--group_reporting --ioengine=3Dlibaio --filename=3D/dev/s=
de
>>>>>>>>>> --name=3Dtest
>>>>>>>>>> --loops=3D10000 --runtime=3D600
>>>>>>>>>>
>>>>>>>>>> Note that I was running the SM on the target this time too.
>>>>>>>>>
>>>>>>>>> Which Linux distro was installed on the inititiator and on th=
e
>>>>>>>>> target
>>>>>>>>> ? And if applicable, which OFED version ? Which kernel messag=
es
>>>>>>>>> were
>>>>>>>>> logged by SRPT around the time the issue occurred (after havi=
ng
>>>>>>>>> enabled SRPT logging first) ?
>>>>>>>>
>>>>>>>> As logging hadn't helped this issue previously, I've not been
>>>>>>>> enabling
>>>>>>>> it. =A0That plus the kernel hacks needed to invoke logging, it=
's not
>>>>>>>> worth enabling.
>>>>>>>>
>>>>>>>> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server
>>>>>>>> kernel.
>>>>>>>>
>>>>>>>> I couldn't get ramdisks working w/ SCST in RHEL5.2. =A0When ru=
nning:
>>>>>>>>
>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>>
>>>>>>>> I get the error:
>>>>>>>>
>>>>>>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>>>>>>> capabilities
>>>>>>>>
>>>>>>>> ... which doesn't occur in the Ubuntu kernel, so I've been una=
ble to
>>>>>>>> test RHEL kernels w/ ramdisks. =A0In general, this problem occ=
urs w/
>>>>>>>> 8KB
>>>>>>>> and smaller blocks w/ the Ubuntu kernels, and 2KB and smaller =
blocks
>>>>>>>> w/ RHEL kernels.
>>>>>>>
>>>>>>> Use ramfs instead.
>>>>>>
>>>>>> Do you mean:
>>>>>>
>>>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>>>
>>>>> You should then create a file on it and use it.
>>>>
>>>> That's what I'm doing, I believe. =A0From above:
>>>>
>>>>>>>>>> mount -t ramfs -o size=3D7g ramfs /mnt/
>>>>>>>>>> dd if=3D/dev/zero of=3D/mnt/foo bs=3D1024k count=3D7000
>>>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>
>>>> ... but the "open", on RHEL5.2 kernel 2.6.18-92.el5, generates the
>>>> following kernel messages:
>>>>
>>>> dev_vdisk: Registering virtual FILEIO device ramdisk
>>>> scst: Processing thread started, PID 9629
>>>> scst: Processing thread started, PID 9630
>>>> scst: Processing thread started, PID 9631
>>>> scst: Processing thread started, PID 9632
>>>> scst: Processing thread started, PID 9633
>>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>>> capabilities
>>>> scst: ***ERROR***: New device handler's vdisk attach() failed: -22
>>>> scst: Processing thread PID 9629 finished
>>>> scst: Processing thread PID 9630 finished
>>>> scst: Processing thread PID 9631 finished
>>>> scst: Processing thread PID 9632 finished
>>>> scst: Processing thread PID 9633 finished
>>>> scst: Failed to attach to virtual device ramdisk
>>>>
>>>> Chris
>>>>>>
>>>>>> ?
>>>>>>
>>>>>> That's what I'm doing.
>>>
>>> That's strange. I'm doing it all the time, although with not so old
>>> kernels
>>> as 2.6.18.
>>
>> In lots of testing today, I've seen this panic twice on the Ubuntu 8=
=2E10
>> targets:
>>
>> [ =A0330.155992] ib_srpt: disconnected session
>> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
>> been received.
>> [ =A0357.207046] ib_srpt: srpt_xmit_response: tag=3D 17 channel in b=
ad state 2
>> [ =A0357.207052] ib_srpt: disconnected session
>> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
>> been received.
>> [ =A0357.207100] ib_srpt: srpt_xmit_response: tag=3D 47 channel in b=
ad state 2
>> [ =A0357.207104] scst: ***ERROR***: Target driver ib_srpt
>> xmit_response() returned fatal error
>> [ =A0357.241429] scst: ***ERROR***: Target driver ib_srpt
>> xmit_response() returned fatal error
>> [ =A0357.250234] ------------[ cut here ]------------
>> [ =A0357.250537] ib_srpt: srpt_xmit_response: tag=3D 26 channel in b=
ad state 2
>> [ =A0357.250539] scst: ***ERROR***: Target driver ib_srpt
>> xmit_response() returned fatal error
>> [ =A0357.250550] ib_srpt: srpt_xmit_response: tag=3D 38 channel in b=
ad state 2
>> [ =A0357.250553] scst: ***ERROR***: Target driver ib_srpt
>> xmit_response() returned fatal error
>> [ =A0357.250560] ib_srpt: srpt_xmit_response: tag=3D 27 channel in b=
ad state 2
>> <repeated many times>
>> [ =A0357.301253] kernel BUG at /root/scst/scst/src/scst_targ.c:3089!
>> [ =A0357.301253] invalid opcode: 0000 [1] SMP
>> [ =A0357.301253] CPU 0
>> ...
>> [ =A0357.301253] RIP: 0010:[<ffffffffa04759f6>] =A0[<ffffffffa04759f=
6>]
>> scst_tgt_cmd_done+0x26/0x30 [scst]
>> [ =A0357.301253] RSP: 0018:ffff88039ad27b50 =A0EFLAGS: 00010297
>> [ =A0357.301253] RAX: 0000000000000200 RBX: ffff8803ad9c68f8 RCX:
>> 0000000000000000
>> [ =A0357.301253] RDX: 00000000ffffffff RSI: 0000000000000000 RDI:
>> ffff8803ad9c68f8
>> [ =A0357.301253] RBP: ffff88039ad27b50 R08: 0000000000000000 R09:
>> 0000000000000000
>> [ =A0357.301253] R10: ffff88039ad277c0 R11: ffff88041ad278cf R12:
>> ffff8803c2972180
>> [ =A0357.301253] R13: ffff88039ada0000 R14: 0000000000000001 R15:
>> ffff8803fb00c2b0
>> [ =A0357.301253] FS: =A00000000000000000(0000) GS:ffffffff807dd000(0=
000)
>> knlGS:0000000000000000
>> [ =A0357.301253] CS: =A00010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> [ =A0357.301253] CR2: 00007f9281e64000 CR3: 0000000000201000 CR4:
>> 00000000000006e0
>> [ =A0357.301253] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [ =A0357.301253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [ =A0357.301253] Process ib_cm/0 (pid: 8299, threadinfo
>> ffff88039ad26000, task ffff88039ad40000)
>> [ =A0357.301253] Stack: =A0ffff88039ad27b80 ffffffffa04c0c47
>> ffff88039a8db900 ffff8803c2972180
>> [ =A0357.301253] =A0ffff8803fb00c240 ffff8803fb00c284 ffff88039ad27b=
c0
>> ffffffffa04c0d93
>> [ =A0357.301253] =A0ffff88042a4959c0 ffff88042a9d7800 ffff88042544da=
00
>> ffff88042a9d7898
>> [ =A0357.301253] Call Trace:
>> [ =A0357.301253] =A0[<ffffffffa04c0c47>] srpt_abort_scst_cmd+0xd7/0x=
160
>> [ib_srpt]
>> [ =A0357.301253] =A0[<ffffffffa04c0d93>] srpt_release_channel+0xc3/0=
x190
>> [ib_srpt]
>> [ =A0357.301253] =A0[<ffffffffa04c0e82>]
>> srpt_find_and_release_channel+0x22/0x30 [ib_srpt]
>> [ =A0357.301253] =A0[<ffffffffa04c227d>] srpt_cm_handler+0x6d/0xbb8 =
[ib_srpt]
>
> It's because srpt called scst_tgt_cmd_done() when the corresponding c=
ommand
> hasn't yet been sent to xmit_response() callback, so srpt should use =
another
> function to abort commands in this state.

Could this be related to the hang (i.e. the command has been aborted
before xmit_response has been called... but w/o causing a panic)?

Thanks,

Chris
>
> Vlad
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
